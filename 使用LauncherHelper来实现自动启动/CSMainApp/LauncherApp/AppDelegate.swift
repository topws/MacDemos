//
//  AppDelegate.swift
//  LauncherApp
//
//  Created by Avazu Holding on 2017/10/17.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
		let mainAppId = "Avazu.CSMainApp"
		let running   = NSWorkspace.shared.runningApplications;
		var alreadyRunning = false;
		for app in running {
			if app.bundleIdentifier == mainAppId {
				
				alreadyRunning = true;
				break
			}
		}
		if !alreadyRunning {
			let notification = Notification.Name("killme");
			DistributedNotificationCenter.default().addObserver(self, selector: #selector(Process.terminate), name: notification, object: mainAppId);
			let path = Bundle.main.bundlePath as NSString;
			var components = path.pathComponents;
			components.removeLast()
			components.removeLast()
			components.removeLast()
			components.append("MacOS")
			components.append("CSMainApp")
			
			let newPath = NSString.path(withComponents: components);
			NSWorkspace.shared.launchApplication(newPath);
		}else{
			
			self.terminate();
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	func terminate() -> Void {
		NSApp.terminate(nil);
	}

}

