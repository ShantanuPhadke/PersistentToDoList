//
//  TaskCell.swift
//  PersistentToDoList
//
//  Created by Shantanu Phadke on 1/18/17.
//  Copyright © 2017 Shantanu. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var tester: UILabel!
    
    @IBOutlet weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
