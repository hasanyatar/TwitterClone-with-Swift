//
//  ViewController.swift
//  TwitterClone
//
//  Created by Hasan YATAR on 25.02.2023.
//

import UIKit

class MainTabbarViewController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: NotificationsViewController())
        let vc4 = UINavigationController(rootViewController: DirectMessagesViewController())
        configureTabbarItem(vc1, "house", "house.fill")
        configureTabbarItem(vc2, "magnifyingglass")
        configureTabbarItem(vc3, "bell","bell.fill")
        configureTabbarItem(vc4, "envelope","envelope.fill")
        
       setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }
    
    
    
    
    private func configureTabbarItem(_ vc:UIViewController, _ systemImageName:String,_ selectedSystemImageName:String? = nil){
        vc.tabBarItem.image = UIImage(systemName: systemImageName)
        if let selectedSystemImageName {
            vc.tabBarItem.selectedImage = UIImage(systemName: selectedSystemImageName)
        }
       
    }

 
    
    
 

    
}

