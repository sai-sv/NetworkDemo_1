//
//  NetworkManager.swift
//  NetworkDemo_1
//
//  Created by Admin on 16.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func getRequest(_ url: String) {
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response, let data = data else { return }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription), info: \(error.userInfo)")
            }
        }
        task.resume()
    }
    
    static func postRequest(_ url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let userJSONData = ["Course": "Network", "Lesson": "GET and POST request"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let data = try JSONSerialization.data(withJSONObject: userJSONData, options: [])
            request.httpBody = data
        } catch {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, let response = response else { return }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }  catch let error as NSError {
                print("Error: \(error.localizedDescription), info: \(error.userInfo)")
            }
        }
        task.resume()
    }
    
    static func fetchData(_ url: String, completion: @escaping ([Course]) -> Void) {

        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                completion(courses)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription), info: \(error.userInfo)")
            }
        }
        task.resume()
    }
    
    static func downloadImage(_ url: String, completion: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, responce, error) in
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            completion(image)
        }
        task.resume()
    }
    
    static func uploadImage(_ url: String, imageName: String) {
        
        guard let url = URL(string: url) else { return }
        guard let image = UIImage(named: imageName) else { return }
        guard let imageProperties = ImageProperties(key: "image", image: image) else { return }
        
        let headers = ["Authorization": "Client-ID 1bd22b9ce396a4c"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = imageProperties.data
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else {
                print("Invalid data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
