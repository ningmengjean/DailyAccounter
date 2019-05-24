//
//  AppDelegate.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/6.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dbVersionCheck()
        // Override point for customization after application launch.
        let memberResult = RealmService.shared.object(Member.self)
        if memberResult?.count == 0 {
            let member0 = Member(id: 0, memberName: "Me", isDefault: true)
            
            let member1 = Member(id: 1, memberName: "Mother", isDefault: false)
            
            let member2 = Member(id: 2, memberName: "Father", isDefault: false)
            
            RealmService.shared.saveObject(member0)
            RealmService.shared.saveObject(member1)
            RealmService.shared.saveObject(member2)
        }
//        let tabBarViewController = UITabBarController()
//        let navigationController = UINavigationController()
//        let tabBarItem = UITabBarItem(title: "报表", image: UIImage(named: "pie"), tag: 1)
//        tabBarViewController.tabBarItem = tabBarItem
//        let vc = MainViewController()
//        tabBarViewController.addChild(navigationController)
//        navigationController.addChild(vc)
//        window?.rootViewController = tabBarViewController
        
        return true
    }
    
    func dbVersionCheck() -> Void {
        let config = Realm.Configuration(
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: 1,
            
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

