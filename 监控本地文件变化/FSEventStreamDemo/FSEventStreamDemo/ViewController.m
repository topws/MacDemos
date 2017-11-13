//
//  ViewController.m
//  FSEventStreamDemo
//
//  Created by Avazu Holding on 2017/10/9.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
#import "CSFSEventStream.h"

@interface ViewController()

@end
@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	CSFSEventStream *stream = [CSFSEventStream sharedManager];
	[stream startEventStream];
}


@end




