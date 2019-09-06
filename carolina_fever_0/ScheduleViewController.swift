//
//  TestViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/31/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import Parse

class ScheduleViewController: UIViewController {

    // MARK: - Properties
    var schedule = [Game]()
    var hasScrolled = false
    var isParent = true
    
    // MARK: - Outlets
    @IBOutlet var scheduleSwitcher: UISegmentedControl!
    
    
    
    // MARK: - Schedule View Controllers
    lazy var listViewController: ListScheduleViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ListScheduleViewController") as! ListScheduleViewController
        
        viewController.schedule = self.schedule


        
        self.addChild(viewController)
        
        return viewController
    }()
    
    lazy var calendarViewController: CalendarScheduleViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "CalendarScheduleViewController") as! CalendarScheduleViewController
        
        viewController.schedule = self.schedule

        
        self.addChild(viewController)
        
        return viewController
    }()
    
    lazy var gameViewController: GameViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "GameController") as! GameViewController
        
        
        self.addChild(viewController)
        
        return viewController
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


        
        self.navigationController?.navigationBar.topItem?.title = "Schedule"
        
        let gamesQuery = PFQuery(className: "Game")
        gamesQuery.whereKey("student", equalTo: "")
        
        gamesQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            
            
            if let games = objects {
                
                var i = 0;
                
                while i < games.count {
                    let game = games[i]
                    
                    do {
                        try game.fetchIfNeeded()
                        self.schedule.append(Game("", game["date"] as! NSDate, game["description"] as! NSString, game["points"] as! NSNumber, game["location"] as! NSString, game["sport"] as! NSString))
                        
                    } catch {
                        print("couldnt fetch game object")
                    }
                    
                    i += 1
                }
                
                self.schedule.sort(by: { (first: Game, second: Game) -> Bool in
                    let result = first.getDate().compare(second.getDate() as Date)
                    
                    
                    return result == ComparisonResult.orderedAscending
                    
                })
                                
                
                self.scheduleSwitcher.selectedSegmentIndex = 0
                self.addChild(self.listViewController)
                self.removeChild(viewController: self.calendarViewController)
                self.removeChild(viewController: self.gameViewController)
                
                
            }
        })
        
        
        
        
    }
    
    
    // MARK: - Actions
    @IBAction @ objc func scheduleSwitched(_ sender: UISegmentedControl) {
        
        if scheduleSwitcher.selectedSegmentIndex == 0 {
            listViewController.schedule = schedule; listViewController.tableView.reloadData()
            addChild(listViewController)
            
            removeChild(viewController: gameViewController)
            removeChild(viewController: calendarViewController)
            
        } else {
            addChild(calendarViewController)
            removeChild(viewController: listViewController)
            removeChild(viewController: gameViewController)
        }
    }
    
    
    
    // MARK: - Helper Methods
    override func addChild(_ childController: UIViewController) {
        
        super.addChild(childController)
        
        view.addSubview(childController.view)
        childController.view.frame = view.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childController.didMove(toParent: self)
        
    }
    
    
    /*remove subview from the superview*/
    func removeChild(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    

}

