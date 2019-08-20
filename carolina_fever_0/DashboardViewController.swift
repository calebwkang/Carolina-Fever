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
    
    var log = [Game]()
    
    @IBOutlet var points: UILabel!
    @IBOutlet var rank: UILabel!
    
    @IBOutlet var loading: UIActivityIndicatorView!
    
    @IBOutlet var logLabel: UILabel!
    @IBOutlet var gamesLog: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loading.startAnimating()
        loading.hidesWhenStopped = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        gamesLog.isHidden = true
        
        
        if let user = PFUser.current() {
            if let username = user.username {
                
                let gamesQuery = PFQuery(className: "Game")
                gamesQuery.whereKey("student", equalTo: username)
                
                gamesQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    
                    var points = 0
                    
                    
                    if let games = objects {
                        print(games)
                        
                        var i = 0;
                        
                        while i < games.count {
                            let game = games[i]
                            
                            do {
                                try game.fetchIfNeeded()
                                self.log.append(Game(game["student"] as! NSString, game["date"] as! NSDate, game["description"] as! NSString, game["points"] as! NSNumber, game["location"] as! NSString, game["sport"] as! NSString))
                                
                                let point = (game["points"] as! NSNumber)
                                
                                points += Int(exactly: point)!
                                
                            } catch {
                                print("couldnt fetch game object")
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
    
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if log.count == 0 {
            
            /*log hasnt been queried yet so return empty cell*/
            
            let cell = UITableViewCell()
            
            return cell
            
            
        } else if indexPath.row < log.count {
            
            /*fill all cells with Content view, except for last row*/
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }

    @IBAction func missingPointsPressed(_ sender: UIButton) {
        self.navigationController?.navigationBar.topItem?.title = "Dashboard"
        performSegue(withIdentifier: "toCorrections", sender: self)
    }
    
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

