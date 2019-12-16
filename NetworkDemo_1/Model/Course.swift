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
}
