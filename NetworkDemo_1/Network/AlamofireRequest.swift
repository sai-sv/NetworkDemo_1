//
//  AlamofireRequest.swift
//  NetworkDemo_1
//
//  Created by Admin on 16.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireRequest {
    
    static func fetchData(_ url: String, completion: @escaping ([Course]) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                if let courses = Course.getArray(from: data) {
                    completion(courses)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
