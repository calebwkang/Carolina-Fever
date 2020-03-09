//
//  ListScheduleViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 8/1/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import Parse

class ListScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: - Properties
    var schedule = [Game]()
    var hasScrolled = false
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return schedule.count
    }
    
    /*this method fills each table view cell with game information**/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if schedule.count != 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? ListScheduleCell {
                
                let game = schedule[indexPath.row]
                
                let date = game.date as Date
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.short
                
                
                var date_str = formatter.string(from: date) as NSString
                date_str = date_str.substring(to: date_str.length-3) as NSString
                
                formatter.dateStyle = DateFormatter.Style.none
                formatter.timeStyle = DateFormatter.Style.short
                
                var time_str = formatter.string(from: date) as NSString
                time_str = time_str.replacingOccurrences(of: " ", with: "") as NSString
                
                cell.dateLabel.text = "\(String(date_str)) \(String(time_str))"
                cell.gameLabel.text = String(game.getDescription())
                cell.locationLabel.text = game.location as String
                
                if let integer = game.getPoints() as? Int {
                    cell.pointsLabel.text = "\(String(integer))pts"
                }
                
                let now = Date()
                let result = now.compare(game.date as Date)
                
                if (!hasScrolled && result == ComparisonResult.orderedAscending) || indexPath.row == schedule.count-1 {
                    hasScrolled = true
                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                }
                
                return cell
                
            }
            
            
        }
        
        let cell = UITableViewCell()
        
        return cell
    }
    
    /*default values for tableview config**/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }


}
