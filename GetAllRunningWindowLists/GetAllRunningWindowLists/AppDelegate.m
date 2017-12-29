//
//  AppDelegate.m
//  GetAllRunningWindowLists
//
//  Created by Avazu Holding on 2017/12/28.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID);
	
	for (NSMutableDictionary* entry in (__bridge NSArray*)windowList)
	{
		NSString* ownerName = [entry objectForKey:(id)kCGWindowOwnerName];
		NSInteger ownerPID = [[entry objectForKey:(id)kCGWindowOwnerPID] integerValue];
		NSString* name = [entry objectForKey:(id)kCGWindowName];
		NSString* number = [entry objectForKey:(id)kCGWindowNumber];
		if ([ownerName isEqualToString:@"Google Chrome"]) {
			NSString * alpha = [NSString stringWithFormat:@"%@",[entry objectForKey:(id)kCGWindowAlpha]];
			NSLog(@"%@:%d------%@,number = %@", ownerName, ownerPID,name,number);
		}
		
	}
	CFRelease(windowList);
	
	CFArrayRef googleList = CGWindowListCreateDescriptionFromArray((__bridge CFArrayRef)@[@"99"]);
	
	NSLog(@"googleList = %@",(__bridge NSArray*)googleList);
	
	
	
}


//CG_EXTERN const CFStringRef  kCGWindowStoreType
//
//CG_EXTERN const CFStringRef  kCGWindowLayer
//
//CG_EXTERN const CFStringRef  kCGWindowBounds
//
//CG_EXTERN const CFStringRef  kCGWindowSharingState
//
//CG_EXTERN const CFStringRef  kCGWindowAlpha

//CG_EXTERN const CFStringRef  kCGWindowMemoryUsage
//
//CG_EXTERN const CFStringRef  kCGWindowWorkspace


@end
