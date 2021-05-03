//
//  Mappable.swift
//  ClientList
//
//  Created by Alessandro Pace on 1/5/21.
//

import Foundation

protocol Mappable: Codable {
    init?(jsonData: Data?)
    init?(jsonString: String)
    init?<T: Decodable>(jsonData: Data?, type: T.Type?)
}

extension Mappable {
    init?(jsonData: Data?) {
        guard let data = jsonData else { return nil }
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        }
        catch {
            print("Mappable error -> \(error)")
            return nil
        }
    }
    
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        self.init(jsonData: data)
    }
    
    init?<T: Decodable>(jsonData: Data?, type: T.Type? = nil) {
        guard let data = jsonData else { return nil }
        do {
            if let type = type {
                self =  try JSONDecoder().decode(type.self, from: data) as! Self
            }
            else {
                self = try JSONDecoder().decode(Self.self, from: data)
            }
            
        }
        catch {
            return nil
        }
    }
    
    func toJson(with params: [String: Any]) -> [String: Any] {
        var paramsJson: [String: Any] = ["":""]
        do {
            //Encode the dictionary in JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            //Decode from JSON data
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            //Convert decoded data on a dictionary
            if let dictFromJSON = decoded as? [String: Any] {
                paramsJson = dictFromJSON
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return paramsJson
    }
}
