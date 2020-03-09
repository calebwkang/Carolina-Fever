//
//  Game.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/25/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit

/*simple abtraction for a fever game
 has a student, number of points, date, location
 name of sport, and a description to go with it**/
class Game: NSObject {
    
    let date: NSDate
    let string: NSString
    let points: NSNumber
    let student: NSString
    let location: NSString
    let sport: NSString
    
    init(_ student: NSString, _ date: NSDate, _ description: NSString, _ points: NSNumber, _ location: NSString, _ sport: NSString) {
        self.date = date; self.string = description; self.points = points; self.student = student; self.location = location; self.sport = sport
    }
    
    func getDate() -> NSDate {
        return date
    }
    
    func getDescription() -> NSString {
        return string
    }
    
    func getPoints() -> NSNumber {
        return points
    }
    
    func toString() -> String {
        return (student as String) + " went to \(string) on \(date) worth \(points) points"
    }
    

}
