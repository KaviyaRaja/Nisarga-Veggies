//
//  AppDelegate.swift
//  Nisarga
//
//  Created by Hari Krish on 01/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import IQKeyboardManagerSwift
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var mNavCtrl: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // IQkeyboard
        IQKeyboardManager.shared.enable = true
        
        
        //firebase
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        firebasepushNotification ()
        moveToSplash()
        return true
    }
    func moveToSplash()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "SplashVC") as? SplashVC
        mNavCtrl = UINavigationController(rootViewController: myVC!)
        mNavCtrl?.isNavigationBarHidden = true
        mNavCtrl?.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = mNavCtrl
        window?.makeKeyAndVisible()
    }
    func moveToHome()
    {
        
        UserDefaults.standard.setValue("Home", forKey: "SelectedTab")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.mNavCtrl = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
        self.mNavCtrl?.viewControllers = [storyboard.instantiateViewController(withIdentifier: "HomeVC")]
        let mainViewController = storyboard.instantiateInitialViewController() as? MainViewController
        mainViewController?.rootViewController = self.mNavCtrl
        mainViewController?.setup(type: 1)
        window?.rootViewController = mainViewController
        if window != nil {
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    func moveToLogin()
    {
        
        UserDefaults.standard.setValue("Home", forKey: "SelectedTab")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.mNavCtrl = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
        self.mNavCtrl?.viewControllers = [storyboard.instantiateViewController(withIdentifier: "LoginVC")]
        let mainViewController = storyboard.instantiateInitialViewController() as? MainViewController
        mainViewController?.rootViewController = self.mNavCtrl
        mainViewController?.setup(type: 1)
        window?.rootViewController = mainViewController
        if window != nil {
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    func goToHome()
    {
        UserDefaults.standard.setValue("Home", forKey: "SelectedTab")
        for controller: UIViewController in (mNavCtrl?.viewControllers)! {
            if (controller is HomeVC) {
                mNavCtrl?.popToViewController(controller, animated: false)
                break
            }
        }
    }
    func goToCategories()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "CategoriesVC") as? CategoriesVC
        self.mNavCtrl?.pushViewController(myVC!, animated: false)
    }
    func goToWishList()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "WishListVC") as? WishListVC
        self.mNavCtrl?.pushViewController(myVC!, animated: false)
    }
    func goToWallet()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "WalletVC") as? WalletVC
        self.mNavCtrl?.pushViewController(myVC!, animated: false)
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
    //MARK: - Firebase Notifications
    
    func firebasepushNotification() {
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().delegate = self as? MessagingDelegate
        let fcmToken = Messaging.messaging().fcmToken
        UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
        print("FCM token: \(fcmToken ?? "")")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    private func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        print("deviceToken: \(deviceToken)")
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo["aps"] {
            print("Message ID: \(messageID)")
        }
        // self.moveToNotificationVC()
        // Print full message.
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["aps"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        let state = UIApplication.shared.applicationState
        
        if state == .background {
            print("BACKGROUND STATE")
        }
        else if state == .active {
            print("ACTIVE STATE")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: Notification, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        //completionHandler([.alert, .badge, .sound])
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo["aps"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler()
    }


}

