//
//  AppDelegate.m
//  WindowSkipTest
//
//  Created by Avazu Holding on 2017/11/7.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
@interface AppDelegate ()

//@property (weak) IBOutlet NSWindow *window;

@property (nonatomic,strong)MainWindowController *mainWindow;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	
	
	_mainWindow = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
	//居中
//	[[_mainWindow window]center];
//	NSRect frame = _mainWindow.window.screen.visibleFrame;
//
//	[[_mainWindow window] setFrameOrigin:NSMakePoint(frame.size.width * 0.5, frame.size.height * 0.5)];

	//前置显示
	[_mainWindow.window orderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
