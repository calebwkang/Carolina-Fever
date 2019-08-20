//
//  ListScheduleCell.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 8/6/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit

class ListScheduleCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

}
