//
//  cellView.swift
//  Leverage
//
//  Created by Todd Resudek on 6/17/15.
//  Copyright (c) 2015 supersimple. All rights reserved.
//

import UIKit

class cellView: UITableViewCell {
    @IBOutlet weak var cellJob: UILabel!
    @IBOutlet weak var cellLocation: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellButton.layer.cornerRadius = 3
        cellButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
