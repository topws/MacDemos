//
//  AppDelegate.m
//  定时器和睡眠后的启动
//
//  Created by Avazu Holding on 2017/12/15.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	[self registerNotifcation];
}
- (void)registerNotifcation{
	
	//注册 电脑睡眠后的苏醒
	[[NSWorkspace sharedWorkspace].notificationCenter addObserver:self selector:@selector(wakeup:) name:NSWorkspaceDidWakeNotification object:nil];
	
}
- (void)wakeup:(NSNotification *)notify{
	NSLog(@"wake up");
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}
- (void)applicationWillHide:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}
- (void)applicationDidHide:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}
- (void)applicationWillUnhide:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}
- (void)applicationDidUnhide:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}
/**
 *  窗口前置和后置
 */
- (void)applicationWillBecomeActive:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}
- (void)applicationDidBecomeActive:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}
- (void)applicationWillResignActive:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}
- (void)applicationDidResignActive:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}

//状态更新就会调用，启动时，点击Dock栏图标时等，会调用多次
- (void)applicationWillUpdate:(NSNotification *)notification{
//	NSLog(@"%s",__func__);
}
- (void)applicationDidUpdate:(NSNotification *)notification{
//	NSLog(@"%s",__func__);
}

// 显示器的配置发生改变时就会调用(调整亮度不会调用)
- (void)applicationDidChangeScreenParameters:(NSNotification *)notification{
	NSLog(@"%s",__func__);
}

//应用程序的可见性发生改变(电脑在睡眠后 呼起时会调用)
- (void)applicationDidChangeOcclusionState:(NSNotification *)notification{
//	NSLog(@"notification = %@",notification);
	NSLog(@"%s",__func__);
	
} //NS_AVAILABLE_MAC(10_9);

@end
