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
        DynamsoftLicenseManager.initLicense("DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==", verificationDelegate: self)
        return true
    }

   
    
    func licenseVerificationCallback(_ isSuccess: Bool, error: Error?) {
        // Add your code to execute when the license server handles callback.
        print(error?.localizedDescription)
    }


}

