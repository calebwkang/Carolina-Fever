//
//  TabBarController.swift
//  carolina_fever_0
//
//  Created by Caleb Kang on 7/25/19.
//  Copyright © 2019 Caleb Kang. All rights reserved.
//

import UIKit
import Parse

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegue(withIdentifier: "toLogIn", sender: self)
    }
}
