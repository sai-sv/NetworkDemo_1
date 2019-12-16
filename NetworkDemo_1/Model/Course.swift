//
//  Course.swift
//  NetworkDemo_1
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation

struct Course: Decodable {
    var id: Int?
    var name: String?
    var link: String?
    var imageUrl: String?
    var numberOfLessons: Int?
    var numberOfTests: Int?
    
    init?(json: [String: Any]) {
        
        guard let id = json["id"] as? Int, let name = json["name"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.link = json["link"] as? String
        self.imageUrl = json["imageUrl"] as? String
        self.numberOfLessons = json["number_of_lessons"] as? Int
        self.numberOfTests = json["number_of_tests"] as? Int
    }
    
    static func getArray(from value: Any) -> [Course]? {
        guard let json = value as? Array<[String: Any]> else { return nil }
        return json.compactMap { Course(json: $0) }
    }
}
