//
//  ImageProperties.swift
//  NetworkDemo_1
//
//  Created by Admin on 16.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation
import UIKit

struct ImageProperties {
    
    var key: String
    var data: Data
    
    init?(key: String, image: UIImage) {
        
        guard let data = image.pngData() else {
            return nil
        }
        self.key = key
        self.data = data
    }
}
