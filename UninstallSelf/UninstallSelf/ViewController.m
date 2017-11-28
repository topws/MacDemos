//
//  ViewController.m
//  UninstallSelf
//
//  Created by Avazu Holding on 2017/11/28.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
- (IBAction)uninstallSelf:(id)sender {
	
	NSBundle *mainB = [NSBundle mainBundle];
	NSString *path = mainB.bundlePath;
//	[[NSFileManager defaultManager] createFileAtPath:@"/Users/avazuholding/Desktop/selfPath.log" contents:[path dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
	
	//找到路径后删除自己
	if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
		NSError *error ;
		[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
		//删除成功后，代码仍可运行，当前正在运行的app不会退出
		[[NSApplication sharedApplication] terminate:nil];
	}
}
- (IBAction)setUserId:(id)sender {
	[[NSUserDefaults standardUserDefaults] setObject:@"190" forKey:@"userId"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)getUserID:(id)sender {
	//即使卸载后，用户偏好设置依然能够给取到值，真他么尴尬
	NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] ];
	[[NSFileManager defaultManager] createFileAtPath:@"/Users/avazuholding/Desktop/selfPath.log" contents:[str dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	
	
}


- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
