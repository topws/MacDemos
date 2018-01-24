//
//  ViewController.m
//  GetWindowTitleList
//
//  Created by Avazu Holding on 2018/1/22.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
#import "GetWindowTitleManager.h"
@interface ViewController(){
	dispatch_source_t _timer;
	
}
@property (nonatomic, copy)NSArray *violationArr;
@end
@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self canculatewindowTime];
	
	GetWindowTitleManager *manager = [GetWindowTitleManager sharedManager];
	[manager startTimer];
	
	
}
- (IBAction)btnClick:(NSButton *)sender {
	
	dispatch_suspend(_timer);
	
}




- (void)canculatewindowTime{
	
	

	
}


@end
