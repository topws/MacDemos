//
//  ViewController.m
//  OneProcessRun
//
//  Created by Avazu Holding on 2018/1/24.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
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
	[self startTimer];
}

- (void)startTimer{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	 _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	
	
	dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 2 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
	dispatch_source_set_event_handler(_timer, ^{
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			BOOL iskilled = YES;
			for (NSRunningApplication *app in [NSWorkspace sharedWorkspace].runningApplications) {
				if ([app.bundleIdentifier isEqualToString:@"com.dotcunited.CloudShield"]) {
					iskilled = NO;
				}
			}
			if (iskilled) {
				//删除 配置信息
				NSLog(@"主进程被 kill");
				
				
				[self stopTimer];
				[NSApp terminate:nil];
			}else{
				NSLog(@"running");
			}
		});
		
		
	});
	dispatch_resume(_timer);
	
}

- (void)stopTimer{
	
	dispatch_source_cancel(_timer);
	_timer = nil;
	
}


@end
