//
//  ServiceManager.swift
//  WebSocket
//
//  Created by Ahmad on 23/08/2022.
//

import Foundation
class ServiceManager {
    
    static func postApiCall(parameters: [String : Any]) {
    
    let post = "POST"
    let url = URL(string: "https://jomo.360scrm.com/Token")
    var request = URLRequest(url: url!)
    request.httpMethod = post
    
    request.httpBody = parameters.percentEncoded()
    
    let dataTask = URLSession.shared.dataTask(with: request) { data, response , error  in
        guard let data = data else {
            if error == nil {
                print(error?.localizedDescription)
            }
            return
        }
        
        if let response = response as? HTTPURLResponse {
            guard (200...299) ~= response.statusCode else {
                print("Status code: \(response.statusCode)")
                print("responsse is \(response)")
                return
            }
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    dataTask.resume()
}
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
