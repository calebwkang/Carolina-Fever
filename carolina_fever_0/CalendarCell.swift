//
//  CalendarCell.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 8/5/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit

/*simple abstraction of a cell in a calendar**/
class CalendarCell: UICollectionViewCell {
    
    @IBOutlet var dateNumber: UILabel!
    @IBOutlet var event: UILabel!
    
    var isGameDay = false
    var games = [Game]()
    var date: Date!
}
