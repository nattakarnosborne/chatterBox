//
//  CustomTabBarController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 9/6/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let userFeedController = UserFeedController(UICollectionViewLayout: UICollectionViewFlowLayout())
        
        
        
        
        let favoriteListController = FavoriteListController()
        let navigationController = UINavigationController(rootViewController: favoriteListController)
        navigationController.title = "Favorite"
        navigationController.tabBarItem.image = UIImage(named: "basket-favorite-heart")
        
        
        let messageController = MessagesController()
        let secondNavigationController = UINavigationController(rootViewController: messageController)
        secondNavigationController.title = "Recent Chat"
        secondNavigationController.tabBarItem.image = UIImage(named: "bubble-chat-favorite-heart")
        
        let pageController = PageController()
        let thirdNavigationController = UINavigationController(rootViewController: pageController)
        thirdNavigationController.title = "People"
        thirdNavigationController.tabBarItem.image = UIImage(named: "account-favorite")

        let profileSettingController = ProfileSettingController()
        let fourthNavigationController = UINavigationController(rootViewController: profileSettingController)
        fourthNavigationController.title = "Profile Setting"
        fourthNavigationController.tabBarItem.image = UIImage(named: "person-setting")
        
       
        
        
        
        viewControllers = [ navigationController, secondNavigationController, thirdNavigationController, fourthNavigationController]
        
        tabBar.isTranslucent = false
        
    }
    var loginController: LoginController?

    
}
