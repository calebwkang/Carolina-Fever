//
//  GameViewController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 8/7/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit

/*class so user can top on a game
 and get more of its details**/
class GameViewController: UIViewController {
    
    var games = [Game]()

    @IBOutlet var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var string = ""
        for game in games {
            string = "\(string) \(game.toString())"
        }
        
        label.text = string
    }


}
