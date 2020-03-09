//
//  FirstViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/25/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import Parse

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // list of games current user has attended
    var log = [Game]()
    
    // MARK: Outlets
    @IBOutlet var points: UILabel!
    @IBOutlet var rank: UILabel!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var logLabel: UILabel!
    @IBOutlet var gamesLog: UITableView!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading animation
        loading.startAnimating()
        loading.hidesWhenStopped = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        gamesLog.isHidden = true
        
        /*queries server for the game log of the current user
         add up all the points earned. then displays number of
         points and calculates rank                       **/
        if let user = PFUser.current() {
            if let username = user.username {
                
                let gamesQuery = PFQuery(className: "Game")
                gamesQuery.whereKey("student", equalTo: username)
                
                gamesQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    
                    var points = 0
                
                    if let games = objects {
                        
                        var i = 0;
                        
                        while i < games.count {
                            let game = games[i]
                            
                            do {
                                try game.fetchIfNeeded()
                                self.log.append(Game(game["student"] as! NSString, game["date"] as! NSDate, game["description"] as! NSString, game["points"] as! NSNumber, game["location"] as! NSString, game["sport"] as! NSString))
                                
                                let point = (game["points"] as! NSNumber)
                                
                                points += Int(exactly: point)!
                                
                            } catch {
                                // couldn't fetch game object
                            }
                            
                            i += 1
                        }
                        
                        DispatchQueue.main.async {
                            self.points.text = String(points) + "pts"
                            
                            if let rank_bool = user["isTop150"] as? Bool {
                                if rank_bool {
                                    self.rank.text = "Top 150!"
                                } else {
                                    self.rank.text = "Not Top 150"
                                }
                            }
                        }
                        
                        self.gamesLog.reloadData()
                        self.gamesLog.isHidden = false
                        
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.loading.stopAnimating()
                        
                    }
                })
                
               
            }
        }
        
        configLine()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let username = PFUser.current()!.username!
        if let bar = navigationController?.navigationBar {
            bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            bar.topItem?.title = "Welcome, \(username)"
        }
        
        
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count+1
    }
    
    /*this method fills in the game log**/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if log.count == 0 {
            
            /*parse hasnt been queried yet so return empty cell*/
            let cell = UITableViewCell()
            return cell
            
        } else if indexPath.row < log.count {
            
            /*fill all cells with game content, except for last row*/
            if let cell = tableView.dequeueReusableCell(withIdentifier: "content") as? ContentTableViewCell {
                
                let game = log[indexPath.row]
                
                let date = game.date as Date
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.short
                
                var date_str = formatter.string(from: date) as NSString
                date_str = date_str.substring(to: date_str.length-3) as NSString
                
                
                cell.date.text = String(date_str)
                cell.gameString.text = String(game.getDescription())
                
                if let integer = game.getPoints() as? Int {
                    cell.points.text = String(integer)
                }
                
                return cell
            }
           
        } else if indexPath.row == log.count {
            
            /*fill the last cell/row with missingPoints cell*/
            if let cell = tableView.dequeueReusableCell(withIdentifier: "missingPoints") as? MissingPointsTableViewCell {
                   return cell
            }
        }
        
        
        return UITableViewCell()
    }
    
    /*default height for a cell**/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    // MARK: Actions
    
    /*actions executed when the user is missing points. Makes
     segue to the corrections form view controller       **/
    @IBAction func missingPointsPressed(_ sender: UIButton) {
        self.navigationController?.navigationBar.topItem?.title = "Dashboard"
        performSegue(withIdentifier: "toCorrections", sender: self)
    }
    
    // MARK: Helper Methods
    
    /*create the line separatng game log label from tableview*/
    func configLine() {
        let bottomBorder = CAShapeLayer()
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: 0, y: logLabel.frame.height))
        bottomPath.addLine(to: CGPoint(x: logLabel.frame.width, y: logLabel.frame.height))
        bottomBorder.path = bottomPath.cgPath
        bottomBorder.strokeColor = UIColor.white.cgColor
        bottomBorder.lineWidth = 1.0
        bottomBorder.fillColor = UIColor.white.cgColor
        logLabel.layer.addSublayer(bottomBorder)
    }
}

