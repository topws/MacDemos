//
//  ViewController.m
//  定时器和睡眠后的启动
//
//  Created by Avazu Holding on 2017/12/15.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
@interface ViewController(){
	dispatch_source_t _timer;
}

@end
@implementation ViewController


- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	
	
	[self gcdTimer1];
	
}
// 重复执行的定时器
- (void)gcdTimer1 {
	
	// 获取全局队列
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	// 创建定时器
	_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	
	// 开始时间
	dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
	
	//    dispatch_time_t start = dispatch_walltime(NULL, 0);
	
	// 重复间隔
	uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
	
	// 设置定时器
	dispatch_source_set_timer(_timer, start, interval, 0);
	
	// 设置需要执行的事件
	dispatch_source_set_event_handler(_timer, ^{
		
		//在这里执行事件
		static NSInteger num = 0;
		
		NSLog(@"%ld", (long)num);
		num++;
		
		if (num > 4) {
			
			NSLog(@"end");
			
			// 关闭定时器
			dispatch_source_cancel(_timer);
		}
	});
	// 开启定时器
	dispatch_resume(_timer);
	
	NSLog(@"start");
}

//用来告诉系统你正在做的事是否重要，系统通过这个来判断是否可以进入小睡状态
- (void)test{
	
	NSOperationQueue *queue = [NSOperationQueue mainQueue];
	NSProcessInfo *info = [NSProcessInfo processInfo];
	[info beginActivityWithOptions:NSActivityBackground reason:@"can't be interapt"];
	[queue addOperationWithBlock:^{
		NSLog(@"重要的事情不能被打断");
	}];
	[[NSProcessInfo processInfo] endActivity:info];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
