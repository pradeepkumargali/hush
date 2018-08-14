//
//  AppDelegate.swift
//  hush
//
//  Created by Pradeep Gali on 08/11/14.
//  Copyright (c) 2014 Pradeep Gali. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Background Fetch
        /*println("did finish")
        let  nsT: NSTimeInterval = 1
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)*/
        
        //Notifications
       /* Parse.setApplicationId("PWirUbLzq3GQx4AM8hz4FclOHzlMLvuGlyEdrR0V", clientKey: "2jUsySwxdIbuodKt0SOB96DWOngywVJXLhfliwFz")
        let userNotificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        else {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound)
        } */
        
        //Audio
        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application( application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData! ) {
        let currentInstallation: PFInstallation = PFInstallation.currentInstallation()

        currentInstallation.setDeviceTokenFromData(deviceToken)

        currentInstallation.saveEventually()

    

    }

    

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        print("Notification")

        PFPush.handlePush(userInfo)

        var vc :UINavigationController = self.window?.rootViewController as! UINavigationController

        var topViewController = vc.topViewController as! ViewController

        

        var instanceOfCustomObject: NetworkUtility = NetworkUtility()

        print(instanceOfCustomObject.GetCurrentWifiHotSpotName())

        if var s = instanceOfCustomObject.GetCurrentWifiHotSpotName(){

            print(s)

            if var fromDB=topViewController.checkSSID(s){

                println(fromDB.valueForKey("choice") as Bool)

                var isSelected = fromDB.valueForKey("choice") as Bool

                if isSelected{

                    instanceOfCustomObject.silentPhone()

                    completionHandler(UIBackgroundFetchResult.NoData)

                }

                else

                {

                    instanceOfCustomObject.unsilencePhone()

                    completionHandler(UIBackgroundFetchResult.NoData)

                }

                

            }

            else{

                topViewController.saveSSID(s,choice: false)

                completionHandler(UIBackgroundFetchResult.NewData)

                

            }

        }

        else

        {

            instanceOfCustomObject.unsilencePhone()

            completionHandler(UIBackgroundFetchResult.NoData)

            

        }

        

    }

    

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

        print("Fetch Started")

        

        var vc :UINavigationController = self.window?.rootViewController as! UINavigationController

        var topViewController = vc.topViewController as! ViewController

        

        var instanceOfCustomObject: NetworkUtility = NetworkUtility()

        print(instanceOfCustomObject.GetCurrentWifiHotSpotName())        

        if var s = instanceOfCustomObject.GetCurrentWifiHotSpotName(){

            print(s)

            if var fromDB=topViewController.checkSSID(s){

                println(fromDB.valueForKey("choice") as Bool)

                var isSelected = fromDB.valueForKey("choice") as Bool

                if isSelected{

                    instanceOfCustomObject.silentPhone()

                    completionHandler(UIBackgroundFetchResult.NoData)

                }

                else

                {

                    instanceOfCustomObject.unsilencePhone()

                    completionHandler(UIBackgroundFetchResult.NoData)

                }

                

            }

            else{

                topViewController.saveSSID(s,choice: false)

                completionHandler(UIBackgroundFetchResult.NewData)



            }

        }

        else

        {

            instanceOfCustomObject.unsilencePhone()

            completionHandler(UIBackgroundFetchResult.NoData)



        }

        

        

    }



    // MARK: - Core Data stack



    lazy var applicationDocumentsDirectory: NSURL = {

        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pkg.hush" in the application's documents Application Support directory.

        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)

        return urls[urls.count-1] as NSURL

    }()



    lazy var managedObjectModel: NSManagedObjectModel = {

        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.

        let modelURL = NSBundle.mainBundle().URLForResource("hush", withExtension: "momd")!

        return NSManagedObjectModel(contentsOfURL: modelURL)!

    }()



    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {

        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.

        // Create the coordinator and store

        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("hush.sqlite")

        var error: NSError? = nil

        var failureReason = "There was an error creating or loading the application's saved data."

        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {

            error = error1
            coordinator = nil

            // Report any error we got.

            let dict = NSMutableDictionary()

            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"

            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error

            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)

            // Replace this with code to handle the error appropriately.

            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

            NSLog("Unresolved error \(error), \(error!.userInfo)")

            abort()

        } catch {
            fatalError()
        }

        

        return coordinator

    }()



    lazy var managedObjectContext: NSManagedObjectContext? = {

        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.

        let coordinator = self.persistentStoreCoordinator

        if coordinator == nil {

            return nil

        }

        var managedObjectContext = NSManagedObjectContext()

        managedObjectContext.persistentStoreCoordinator = coordinator

        return managedObjectContext

    }()



    // MARK: - Core Data Saving support



    func saveContext () {

        if let moc = self.managedObjectContext {

            var error: NSError? = nil

            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {

                    error = error1
                    // Replace this implementation with code to handle the error appropriately.

                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    NSLog("Unresolved error \(error), \(error!.userInfo)")

                    abort()

                }
            }
        }
    }
    
    
    /*func saveSSID(name: String, choice: Bool) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("SSIDS",
            inManagedObjectContext:
            managedContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        person.setValue(choice, forKey: "choice")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        //5
        //items.append(person)
    }
    
    func checkSSID(ssid : String) -> NSManagedObject!{
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("SSIDS",
            inManagedObjectContext:
            managedContext)
        
        let fs : NSFetchRequest = NSFetchRequest(entityName: "SSIDS")
        
        
        //3
        //var ssid :String! = "TP-LINK_POCKET_3020_A48506"
        let predicate: NSPredicate = NSPredicate(format: "name = %@", ssid)!
        fs.predicate=predicate
        
        var error: NSError? = nil
        if let fr = managedContext.executeFetchRequest(fs, error: &error) {
            //  println("Could not save \(error), \(error?.userInfo)")
            if fr.count > 0 {
                 println(fr)
                return fr[0] as NSManagedObject
            }
            else
            {
                return nil
            }
            //fr.
        }
        else{
            return nil
        }
        
        
        
        
        
    }*/

}

