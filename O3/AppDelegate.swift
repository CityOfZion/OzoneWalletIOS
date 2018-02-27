//
//  AppDelegate.swift
//  O3
//
//  Created by Andrei Terentiev on 9/6/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
import Channel
import CoreData
import Reachability
import Fabric
import Crashlytics
import SwiftTheme

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func setupChannel() {
        //O3 Development on Channel app_gUHDmimXT8oXRSpJvCxrz5DZvUisko_mliB61uda9iY
        Channel.setup(withApplicationId: "app_gUHDmimXT8oXRSpJvCxrz5DZvUisko_mliB61uda9iY")
    }

    func setupApperances() {
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedStringKey.font: ThemeManager.barButtonItemFont,
            NSAttributedStringKey.foregroundColor: UserDefaultsManager.theme.primaryColor], for: .normal)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UserDefaultsManager.theme.textColor,
            NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 32) as Any]
        SwiftTheme.ThemeManager.setTheme(index: UserDefaultsManager.theme == .light ? 0 : 1)

    }

    func registerDefaults() {
        let userDefaultsDefaults: [String: Any] = [
            "networkKey": "main",
            "usedDefaultSeedKey": false,
            "selectedThemeKey": Theme.light.rawValue,
            "referenceFiatCurrencyKey": Currency.usd.rawValue
        ]
        UserDefaults.standard.register(defaults: userDefaultsDefaults)
    }

    let alertController = UIAlertController(title: "Uh oh! There is no internet connection. 😵", message: nil, preferredStyle: .alert)
    @objc func reachabilityChanged(_ note: Notification) {
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            alertController.dismiss(animated: true, completion: nil)

        case .cellular:
            print("Reachable via cellular")
            alertController.dismiss(animated: true, completion: nil)
        case .none:
            print("Network not reachable")
            UIApplication.shared.keyWindow?.rootViewController?.presentFromEmbedded(alertController, animated: true, completion: nil)
        }
    }
    let reachability = Reachability()!
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: nil)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        self.registerDefaults()
        self.setupChannel()
        self.setupApperances()
        self.setupReachability()

        //check if there is an existing wallet in keychain
        //if so, present LoginToCurrentWalletViewController
        let walletExists =  UserDefaultsManager.o3WalletAddress != nil
        if walletExists {
            let login = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "LoginToCurrentWalletViewController")
            if let window = self.window {
                window.rootViewController = login
            }
        }

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "O3")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
