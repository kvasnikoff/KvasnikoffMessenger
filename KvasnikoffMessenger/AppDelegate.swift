//
//  AppDelegate.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 14.02.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var previousApplicationState: UIApplication.State = .inactive

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        printLog(log: "Application moved from Not Running State to \(parseState(state: application.applicationState)): \(#function)")
        previousApplicationState = application.applicationState
        FirebaseApp.configure()
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let controller = ConversationsListViewController()
        let navController = UINavigationController(rootViewController: controller)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        printLog(log: "Application moved from \(parseState(state: previousApplicationState)) to \(parseState(state: application.applicationState)): \(#function)")
        previousApplicationState = application.applicationState
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        printLog(log: "Application moved from \(parseState(state: previousApplicationState)) to \(parseState(state: application.applicationState)): \(#function)")
        previousApplicationState = application.applicationState
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        printLog(log: "Application moved from \(parseState(state: previousApplicationState)) to \(parseState(state: application.applicationState)): \(#function)")
        previousApplicationState = application.applicationState
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        printLog(log: "Application moved from \(parseState(state: previousApplicationState)) to \(parseState(state: application.applicationState)): \(#function)")
        previousApplicationState = application.applicationState
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        printLog(log: "Application moved from \(parseState(state: previousApplicationState)) to \(parseState(state: application.applicationState)): \(#function)")
        previousApplicationState = application.applicationState
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        printLog(log: "Application moved from \(parseState(state: previousApplicationState)) to \(parseState(state: application.applicationState)): \(#function)")
        previousApplicationState = application.applicationState
        
        return true
    }

}
