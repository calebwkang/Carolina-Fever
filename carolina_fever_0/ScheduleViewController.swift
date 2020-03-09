//
//  TestViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/31/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import Parse

/*This view controller is the parent view controller
 of CalendarView and the ListView. This view has a segmental
 control that switches between the two views so that users can
 view the schedule in list form and in calenar form*/
class ScheduleViewController: UIViewController {

    // MARK: - Properties
    var schedule = [Game]()
    var hasScrolled = false
    var isParent = true
    
    // MARK: - Outlets
    
    // this switches the schedule type
    @IBOutlet var scheduleSwitcher: UISegmentedControl!
    
    // MARK: - Schedule View Controllers
    
    // ListView controller
    lazy var listViewController: ListScheduleViewController = {
        
        // get list view and add to this view as a child
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ListScheduleViewController") as! ListScheduleViewController
        viewController.schedule = self.schedule
        self.addChild(viewController)
        
        return viewController
    }()
    
    // CalendarView controller
    lazy var calendarViewController: CalendarScheduleViewController = {
        
        // get calendar view and add to this view as a child
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CalendarScheduleViewController") as! CalendarScheduleViewController
        viewController.schedule = self.schedule;
        self.addChild(viewController)
        
        return viewController
    }()
    
    lazy var gameViewController: GameViewController = {
        
        // get GameController and add to the view
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "GameController") as! GameViewController
        self.addChild(viewController)
        
        return viewController
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Make Title 'Schedule'
        self.navigationController?.navigationBar.topItem?.title = "Schedule"
        
        /*Queries server for all FEVER games*/
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
                
                /*sorts games by date*/
                self.schedule.sort(by: { (first: Game, second: Game) -> Bool in
                    let result = first.getDate().compare(second.getDate() as Date)
                    return result == ComparisonResult.orderedAscending
                })
                
                /*set the initial view is the LIST schedule view*/
                self.scheduleSwitcher.selectedSegmentIndex = 0
                self.addChild(self.listViewController)
                self.removeChild(viewController: self.calendarViewController)
                self.removeChild(viewController: self.gameViewController)
            }
        })
    }
    
    // MARK: - Actions

    @IBAction @ objc func scheduleSwitched(_ sender: UISegmentedControl) {
        if scheduleSwitcher.selectedSegmentIndex == 0 { // user chooses ListView so display list view
            
            listViewController.schedule = schedule
            listViewController.tableView.reloadData()
            addChild(listViewController)
            removeChild(viewController: gameViewController)
            removeChild(viewController: calendarViewController)
            
        } else { // user choose calendar view so display calendar view
            addChild(calendarViewController)
            removeChild(viewController: listViewController)
            removeChild(viewController: gameViewController)
        }
    }
    
    // MARK: - Helper Methods
    override func addChild(_ childController: UIViewController) {
        
        super.addChild(childController)
        
        // child view is added as subview. bounds should match with parent's
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

