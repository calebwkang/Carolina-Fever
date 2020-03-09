//
//  ListScheduleCell.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 8/6/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit


/*a cell representing a fever game. has game time,
 opponent, number of points etc. similar to Content
 Table view cell but has location information    **/
class ListScheduleCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

}
