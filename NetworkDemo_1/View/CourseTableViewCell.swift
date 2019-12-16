//
//  CourseTableViewCell.swift
//  NetworkDemo_1
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameOfCourseLabel: UILabel!
    @IBOutlet weak var numberOfLessonsLabel: UILabel!
    @IBOutlet weak var numberOfTestsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(course: Course) {
        
        nameOfCourseLabel.text = course.name
        if let numberOfLessons = course.numberOfLessons {
            numberOfLessonsLabel.text = "Number of Lessons: \(numberOfLessons)"
        }
        if let numberOfTests = course.numberOfTests {
            numberOfTestsLabel.text = "Number of Tests: \(numberOfTests)"
        }
        
        if let imgURLString = course.imageUrl, let imageURL = URL(string: imgURLString) {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            logoImageView.image = UIImage(data: imageData)
        }
    }
}
