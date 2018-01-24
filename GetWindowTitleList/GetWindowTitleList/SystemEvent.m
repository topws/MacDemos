//
//  SystemEvent.m
//  GetWindowTitleList
//
//  Created by Avazu Holding on 2018/1/23.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import "SystemEvent.h"
#import <Carbon/Carbon.h>
#import <AppKit/AppKit.h>
#import "AppDelegate.h"
@implementation SystemEvent

- (instancetype)init{
	
	if (self = [super init]) {
		NSDistributedNotificationCenter * center
		= [NSDistributedNotificationCenter defaultCenter];
		
		[center addObserver: self
				   selector:    @selector(receive:)
					   name:        @"com.apple.screensaver.didlaunch"
					 object:      nil
		 ];
		
		[center addObserver: self
				   selector:    @selector(receive:)
					   name:        @"com.apple.screensaver.didstart"
					 object:      nil
		 ];
		[center addObserver: self
				   selector:    @selector(receive:)
					   name:        @"com.apple.screensaver.didstop"
					 object:      nil
		 ];
		[center addObserver: self
				   selector:    @selector(receive:)
					   name:        @"com.apple.screenIsLocked"
					 object:      nil
		 ];
		[center addObserver: self
				   selector:    @selector(receive:)
					   name:        @"com.apple.screenIsUnlocked"
					 object:      nil
		 ];
	}
	return self;
}
-(void) receive: (NSNotification*) notification {
//	printf("notification = %s\n", [[notification name] UTF8String] );
	NSLog(@"notification = %s", [[notification name] UTF8String]);
	
	AppDelegate * delegate =  [NSApplication sharedApplication].delegate;
	
	NSString *name = [NSString stringWithCString:[[notification name] UTF8String] encoding:NSUTF8StringEncoding];
	
	if ([name isEqualToString:@"com.apple.screenIsLocked"]) {
		delegate.isScreenLocked = YES;
	}
	if ([name isEqualToString:@"com.apple.screenIsUnlocked"]) {
		delegate.isScreenLocked = NO;
	}
	//记录状态并且发送通知
	
	
}
// 监听全局事件
+ (void)addGlobalMonitorForEvent{
	
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:^(NSEvent *event){
		NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
		if (flags == NSCommandKeyMask) {
			// handle it
		}
	}];
	
	// 本地
	[NSEvent addLocalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:^(NSEvent *event){
		NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
		if (flags == NSCommandKeyMask) {
			// handle it
		}
		return event;
	}];
}

@end
