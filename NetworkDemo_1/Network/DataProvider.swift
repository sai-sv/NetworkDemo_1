//
//  DataProvider.swift
//  NetworkDemo_1
//
//  Created by Admin on 16.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation
import UIKit

class DataProvider: NSObject {
    
    private lazy var backgroundSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.sais.NetworkDemo-1")
        configuration.sessionSendsLaunchEvents = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    private var downloadTask: URLSessionDownloadTask?
    var fileLocation: ((URL) -> Void)?
    var onProgress: ((Double) -> Void)?
    
    func downloadFile(_ url: String) {
        
        guard let url = URL(string: url) else { return }
        
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask?.earliestBeginDate = Date().addingTimeInterval(1)
        downloadTask?.countOfBytesClientExpectsToSend = 512
        downloadTask?.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
                
        downloadTask?.resume()        
    }
    
    func cancelDownload() {
        
        if let task = downloadTask {
            task.cancel()
        }
    }
}

extension DataProvider: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = delegate.backgroundSessionCompletionHandler else {
                    return
            }
            delegate.backgroundSessionCompletionHandler = nil
            completionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        DispatchQueue.main.async {
            print("File downloaded to: \(location.absoluteString)")
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Downloading: \(progress)")

        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
