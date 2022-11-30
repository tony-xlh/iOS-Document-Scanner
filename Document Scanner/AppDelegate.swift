//
//  AppDelegate.swift
//  Document Scanner
//
//  Created by xulihang on 2022/11/27.
//

import UIKit
import DynamsoftDocumentNormalizer

@main
class AppDelegate: UIResponder, UIApplicationDelegate, LicenseVerificationListener  {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        let navController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        DynamsoftLicenseManager.initLicense("DLS2eyJoYW5kc2hha2VDb2RlIjoiMTAxMDc0MDY2LVRYbE5iMkpwYkdWUWNtOXFYMlJrYmciLCJvcmdhbml6YXRpb25JRCI6IjEwMTA3NDA2NiIsImNoZWNrQ29kZSI6MTYyNTI3MTI4OH0=", verificationDelegate: self)
        return true
    }

   
    
    func licenseVerificationCallback(_ isSuccess: Bool, error: Error?) {
        // Add your code to execute when the license server handles callback.
        print(error?.localizedDescription)
    }


}

