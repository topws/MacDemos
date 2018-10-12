//
//  AppDelegate.swift
//  Quotes
//
//  Created by Avazu Holding on 2018/10/10.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	var eventMonitor: EventMonitor?
	let popover = NSPopover()

	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		if let button = statusItem.button {
			button.image = NSImage(named: "statusIcon")
			button.action = #selector(togglePopover(sender:))
			button.target = self
		}
		
		//添加菜单栏
		//addMenu()
		
		//popover
		popover.contentViewController = QuotesViewController.init(nibName: "QuotesViewController", bundle: nil)
		
		
		eventMonitor = EventMonitor(mask: NSEvent.EventTypeMask(rawValue: NSEvent.EventTypeMask.leftMouseDown.rawValue | NSEvent.EventTypeMask.rightMouseDown.rawValue), handler: { [weak self]event in
			if let popover = self?.popover {
				if popover.isShown {
					self?.closePopover(sender: event)
				}
			}
			
		})
		eventMonitor?.start()
	}
	
	@objc func showPopover(sender:AnyObject) {
		if let button = statusItem.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
		}
	}
	@objc func togglePopover(sender:AnyObject) {
		if popover.isShown {
			closePopover(sender: sender)
		}else {
			showPopover(sender: sender)
		}
	}
	@objc func closePopover(sender:AnyObject?) {
		popover.performClose(sender)
		
		eventMonitor?.stop()
	}
	
	
	private func addMenu() {
		
		//Dock栏隐藏，用info.plist ,选用Application is Agent
		//启动窗口不显示，选择MainMenu.xib的Window窗口属性，Visible At Launch
		
		//给Status Item添加菜单
		let menu = NSMenu()
		
		//keyEquivalent快捷键，小写默认Cmd作为辅助键，大写表示Cmd + Shift
		//这个快捷键只有应用在最前端并且活动的情况下才有效
		menu.addItem(withTitle: "Print Quote", action: #selector(printQuote(sender:)), keyEquivalent:"p")
		menu.addItem(NSMenuItem.separator())
		menu.addItem(withTitle: "Quit Quotes", action: #selector(quit), keyEquivalent: "q")
		statusItem.menu = menu
	}
	
	@objc func printQuote(sender:AnyObject) {
		let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
		let quoteAuthor = "Mark Twain"
		
		print("\(quoteText) - \(quoteAuthor)")
	}

	@objc func quit() {
		
//		Terminates the receiver.
//		This method is typically invoked when the user chooses Quit or Exit from the application’s menu.
//		When invoked, this method performs several steps to process the termination request. First, it asks the application’s document controller (if one exists) to save any unsaved changes in its documents. During this process, the document controller can cancel termination in response to input from the user. If the document controller does not cancel the operation, this method then calls the delegate’s applicationShouldTerminate: method. If applicationShouldTerminate: returns NSTerminateCancel, the termination process is aborted and control is handed back to the main event loop. If the method returns NSTerminateLater, the application runs its run loop in the NSModalPanelRunLoopMode mode until the replyToApplicationShouldTerminate: method is called with the value YES or NO. If the applicationShouldTerminate: method returns NSTerminateNow, this method posts a NSApplicationWillTerminateNotification notification to the default notification center.
//		Do not bother to put final cleanup code in your application’s main() function—it will never be executed. If cleanup is necessary, perform that cleanup in the delegate’s applicationWillTerminate: method.
//		Parameters
//		sender
//		Typically, this parameter contains the object that initiated the termination request.
//		Availability    Mac OS X (10.0 and later)
		NSApplication.shared.terminate(nil)//exit(0)
		
	}
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

