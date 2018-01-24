//
//  GetWindowTitleManager.m
//  GetWindowTitleList
//
//  Created by Avazu Holding on 2018/1/23.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import "GetWindowTitleManager.h"

@interface GetWindowTitleManager(){
	dispatch_source_t _timer;
}
@property (nonatomic,assign)BOOL isScreenLocked;
@property (nonatomic, copy)NSArray *violationArr;
@property (nonatomic, strong)NSMutableArray<ViolationObject *> *violationTitles;
@end

@implementation GetWindowTitleManager
- (NSMutableArray *)violationTitles{
	if (_violationTitles == nil) {
		_violationTitles = [NSMutableArray array];
	}
	return _violationTitles;
}
- (void)getWindowList{
	
	CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly| kCGWindowListExcludeDesktopElements , kCGNullWindowID);
	
	//进入循环前，假定所有的网页都停止了浏览
	[self.violationTitles enumerateObjectsUsingBlock:^(ViolationObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.needEnd = YES;
	}];
	
	//开始循环
	for (NSMutableDictionary* entry in (__bridge NSArray*)windowList)
	{
		NSString *name = [entry objectForKey:(id)kCGWindowName];
		if (!name || name.length == 0) {
			continue;
		}
		NSString *ownerName = [entry objectForKey:(id)kCGWindowOwnerName];
		
		//获取到title后，判断是否需要记录
		for (NSString *violationStr in self.violationArr) {
			if ([name containsString:violationStr]) {
				//找到一个违规的网页title
				NSString *title = [NSString stringWithFormat:@"%@:%@",ownerName,name];
				//增加一个阈值，用于记录当前违规标题是否存在于 已有的违规标题数组里
				__block BOOL isContain = NO;
				[self.violationTitles enumerateObjectsUsingBlock:^(ViolationObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					//标题存在，这判断为仍然在浏览，不用处理
					if ([obj.title isEqualToString:title]) {
						obj.needEnd = NO;
						isContain = YES;
					}
				}];
				//如果当前违规标题不存在与 违规标题数组中，则添加
				if (!isContain) {
					ViolationObject *violationObject = [ViolationObject new];
					violationObject.date = [NSDate date];
					violationObject.title = title;
					violationObject.needEnd = NO;
					[self.violationTitles addObject:violationObject];
				}
			}
		}
	}
	CFRelease(windowList);
	
	//一次取值结束后，进行文件写入，并且移除
	[self removeTitle];
}

- (void)removeTitle{
	NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
	[self.violationTitles enumerateObjectsUsingBlock:^(ViolationObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.needEnd) {
			NSTimeInterval timerInterval = [[NSDate date] timeIntervalSinceDate:obj.date];
			if (timerInterval > 2) {
				NSLog(@"title = %@,time = %.02f",obj.title,timerInterval);
			}
			[set addIndex:idx];
		}
	}];
	[self.violationTitles removeObjectsAtIndexes:set];
}

- (void)startTimer{
	if (self.isScreenLocked) {
		return;
	}
	if (_timer) {
		return;
	}
	dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
	_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0);
	// 任务回调
	//这里回调是在 子线程中执行
	dispatch_source_set_event_handler(_timer, ^{
		[self getWindowList];
	});
	
	// 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
	dispatch_resume(_timer);
	
	//以下定时器的两个出口必须包含一个
	
	//挂起定时器(挂起的定时器不能被销毁)
//	dispatch_suspend(_timer);
	
	//取消定时器
//	dispatch_source_cancel(_timer);
}

- (void)stopTimer{
	dispatch_source_cancel(_timer);
	_timer = nil;
	
	[self.violationTitles enumerateObjectsUsingBlock:^(ViolationObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.needEnd = YES;
	}];
	[self removeTitle];
}

+ (instancetype)sharedManager{
	static GetWindowTitleManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[GetWindowTitleManager alloc]init];
		manager.violationArr = @[@"京东",@"淘宝"];
		NSDistributedNotificationCenter * center = [NSDistributedNotificationCenter defaultCenter];
		[center addObserver: self
				   selector: @selector(receive:)
					   name: @"com.apple.screenIsLocked"
					 object: nil
		 ];
		[center addObserver: self
				   selector: @selector(receive:)
					   name: @"com.apple.screenIsUnlocked"
					 object: nil
		 ];
		manager.isScreenLocked = NO;
	});
	return manager;
}

-(void) receive: (NSNotification*) notification {
	NSString *name = [NSString stringWithCString:[[notification name] UTF8String] encoding:NSUTF8StringEncoding];
	if ([name isEqualToString:@"com.apple.screenIsLocked"]) {
		self.isScreenLocked = YES;
		[self stopTimer];
	}
	if ([name isEqualToString:@"com.apple.screenIsUnlocked"]) {
		self.isScreenLocked = NO;
		
	}
}

-(void)dealloc{
	NSDistributedNotificationCenter * center = [NSDistributedNotificationCenter defaultCenter];
	[center removeObserver:self];
}
@end

