//
//  AppDelegate.m
//  OneProcessRun
//
//  Created by Avazu Holding on 2018/1/24.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	NSString *str = @"/Users/avazuholding/Library/Developer/Xcode/DerivedData/CloudShield-djqtonumhjkmsqcjaquopfjywfaa/Build/Products/Debug/nDefender.app/Contents/Library/DaemonHelper/DaemonHelper.app";
	
	NSLog(@"%d",[[NSWorkspace sharedWorkspace] launchApplication:str]);
	
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
	
	return NO;
}
//- (instancetype)init{
//	if (self = [super init]) {
//		NSXPCConnection *connection = [NSXPCConnection new];
//		connection.serviceName = @"com.dotcunited.OneProcessRun";
//

//		if (![connection registerName:]) {
//			NSRunAlertPanel(@"程序正在运行中", @"OK", nil, nil,nil);
//			[NSApp terminate:nil];
//			return nil;
//		}
//	}
//	return self;
//}

@end
