//
//  RootTabBarController.swift
//  SHCalendar
//
//  Created by 임수현 on 20/05/2019.
//  Copyright © 2019 limsuhyun. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    let selectedTabIndexKey = "selectedTabIndex"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Load the last selected tab if the key exists in the UserDefaults
        if UserDefaults.standard.object(forKey: self.selectedTabIndexKey) != nil {
            self.selectedIndex = UserDefaults.standard.integer(forKey: self.selectedTabIndexKey)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Save the selected index to the UserDefaults
        UserDefaults.standard.set(self.selectedIndex, forKey: self.selectedTabIndexKey)
        UserDefaults.standard.synchronize()
    }
}
