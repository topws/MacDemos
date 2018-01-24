//
//  AppDelegate.m
//  GetWindowTitleList
//
//  Created by Avazu Holding on 2018/1/22.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import "AppDelegate.h"
#import "SystemEvent.h"
@interface AppDelegate ()

@property (nonatomic,strong)SystemEvent *event;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	self.event = [[SystemEvent alloc]init];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
