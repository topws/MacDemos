//
//  AppDelegate.swift
//  CSMainApp
//
//  Created by Avazu Holding on 2017/10/17.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

import Cocoa
import ServiceManagement
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
		let appId = "Avazu.LauncherApp";
		SMLoginItemSetEnabled(appId as CFString, true);
		
		var startedAtLogin = false
		
		for app in NSWorkspace.shared.runningApplications {
			if app.bundleIdentifier == appId	{
				
				startedAtLogin = true;
			}
		}
		if startedAtLogin {
			let notification = Notification.Name("killme");
			DistributedNotificationCenter.default().post(name: notification, object: Bundle.main.bundleIdentifier!);
		}
		
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

