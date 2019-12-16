//
//  MainViewController.swift
//  NetworkDemo_1
//
//  Created by Admin on 16.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit
import UserNotifications

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let uploadImageUrl = "https://api.imgur.com/3/image"
private let downloadFileUrl = "https://speed.hetzner.de/100MB.bin"
private let coursesUrl = "https://swiftbook.ru//wp-content/uploads/api/api_courses"

enum Action: String, CaseIterable {
    
    case DownloadImage = "DOWNLOAD"
    case Get = "GET"
    case Post = "POST"
    case FetchData = "SHOW COURSES"
    case Upload = "UPLOAD"
    case DownloadData = "DOWNLOAD DATA"
    case FetchDataAlamofire = "ALAMOFIRE"
}

class MainViewController: UICollectionViewController {
    
    private let actions = Action.allCases
    private var alert: UIAlertController!
    private var dataProvider = DataProvider()
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        
        dataProvider.fileLocation = { (location) in
            print("File saved to \(location.absoluteString)")
            self.alert.dismiss(animated: false)
            self.filePath = location.absoluteString
            self.postNotification()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        let action = actions[indexPath.row].rawValue
        cell.titleLabel.text = action
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let action = actions[indexPath.row]
        
        switch action {
        case .DownloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
            break
        case .Get:
            NetworkManager.getRequest(url)
            break
        case .Post:
            NetworkManager.postRequest(url)
            break
        case .FetchData:
            performSegue(withIdentifier: "ShowCourses", sender: self)
            break
        case .Upload:
            NetworkManager.uploadImage(uploadImageUrl, imageName: "Soulfly")
            break
        case .DownloadData:
            showAlert()
            dataProvider.downloadFile(downloadFileUrl)
            break
        case .FetchDataAlamofire:
            performSegue(withIdentifier: "ShowCoursesAlamofire", sender: self)
            break
        }
    }
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading ...", message: "Downloaded: 0%", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            self.dataProvider.cancelDownload()
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            
            let constraint = NSLayoutConstraint(item: self.alert.view!,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 0,
                                                constant: 170)
            self.alert.view.addConstraint(constraint)
            
            let frame = self.alert.view.frame
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: (frame.width / 2) - (size.width / 2), y: frame.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.isHidden = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: 2))
            
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let dvc = segue.destination as? CoursesTableViewController else { return }
        
        switch identifier {
        case "ShowCourses":
            dvc.fetchData(coursesUrl)
            break
        case "ShowCoursesAlamofire":
            dvc.fetchDataAlamofire(coursesUrl)
            break
        default:
            break
        }
    }
}

extension MainViewController {
    
    private func registerForNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download compleate!"
        content.body = "File saved to \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "TransferCompleate", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
