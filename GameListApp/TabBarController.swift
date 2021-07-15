//
//  TabBarController.swift
//  GameListApp
//
//  Created by Ayşe Nur Bakırcı on 15.07.2021.
//

import UIKit

class TabBarController: UITabBarController {

    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabbarConfiguration()
    }
    
    private func tabbarConfiguration() {
        
        tabbar.barTintColor = .darkGray
        tabbar.tintColor = .white
        tabbar.unselectedItemTintColor = .lightGray
        
        tabbar.layer.cornerRadius = 10
        tabbar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabbar.layer.masksToBounds = true
        
    }

}
