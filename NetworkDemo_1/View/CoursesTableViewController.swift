//
//  CoursesTableViewController.swift
//  NetworkDemo_1
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController {

    private var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func fetchData(_ url: String) {
        NetworkManager.fetchData(url) { (courses) in
            DispatchQueue.main.async {
                self.courses = courses
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataAlamofire(_ url: String) {
        AlamofireRequest.fetchData(url) { (courses) in
            DispatchQueue.main.async {
                self.courses = courses
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Table view data source
extension CoursesTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CourseTableViewCell else {
            return UITableViewCell()
        }
        
        let course = courses[indexPath.row]
        cell.configure(course: course)

        return cell
    }
}
