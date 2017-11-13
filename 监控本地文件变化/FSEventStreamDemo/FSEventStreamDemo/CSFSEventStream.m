//
//  CSFSEventStream.m
//  CloudShield
//
//  Created by Avazu Holding on 2017/10/17.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "CSFSEventStream.h"
#import <CoreServices/CoreServices.h>
#import <AppKit/AppKit.h>

@interface CSFSEventStream()

@property (nonatomic, assign)NSInteger syncEventID;
@property (nonatomic, assign)FSEventStreamRef syncEventStream;

@end

@implementation CSFSEventStream

- (void)startEventStream{
	
	[self stopEventStream];
	[self fsEventsSetUp];
}

- (void)stopEventStream{
	
	if(self.syncEventStream) {
		FSEventStreamStop(self.syncEventStream);
		FSEventStreamInvalidate(self.syncEventStream);
		FSEventStreamRelease(self.syncEventStream);
		self.syncEventStream = NULL;
	}
}
//使用File System Events,支持10.5以后的系统
- (void)fsEventsSetUp{
	
	if (self.syncEventStream) {
		//必须先调用 stop
		FSEventStreamStop(self.syncEventStream);
		FSEventStreamInvalidate(self.syncEventStream);
		FSEventStreamRelease(self.syncEventStream);
		self.syncEventStream = NULL;
	}
	//生成一个 Event Stream
	//1.监控的路径
	CFStringRef mypath = CFSTR("/");
	CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
	//	NSArray *paths = @[@"/Users/avazuholding/Desktop/123"];
	FSEventStreamContext context;
	context.info = (__bridge void * _Nullable)self;
	context.version = 0;
	context.retain = NULL;
	context.release = NULL;
	context.copyDescription = NULL;
	
	CFAbsoluteTime latency = 1.0;/* Latency in seconds */
	
	/* Create the stream,passing in a callback */
	self.syncEventStream = FSEventStreamCreate(NULL,
											   &fsevents_callback,
											   &context,
											   pathsToWatch,
											   self.syncEventID,/* kFSEventStreamEventIdSinceNow Or a previous event ID*/
											   latency,
											   kFSEventStreamEventFlagRootChanged|kFSEventStreamCreateFlagFileEvents|kFSEventStreamCreateFlagUseCFTypes /* Flags explained in reference */);
	//kFSEventStreamEventFlagMount
	
	
//	self.syncEventStream = FSEventStreamCreateRelativeToDevice(NULL,
//															   &fsevents_callback,
//															   &context,
//															   25347,
//															   pathsToWatch,
//															   self.syncEventID,
//															   latency,
//															   kFSEventStreamCreateFlagFileEvents|kFSEventStreamCreateFlagUseCFTypes);
	
	//2.添加到application 的运行循环
	FSEventStreamScheduleWithRunLoop(self.syncEventStream, CFRunLoopGetMain(), kCFRunLoopDefaultMode);//CFRunLoopGetCurrent()
	
	//3.开启 文件系统监听
	FSEventStreamStart(self.syncEventStream);
}

//updateEventID
- (void)updateEventID{
	self.syncEventID = FSEventStreamGetLatestEventId(self.syncEventStream);
}
//setter , getter
- (void)setSyncEventID:(NSInteger)syncEventID{
	[[NSUserDefaults standardUserDefaults] setInteger:syncEventID forKey:@"Cloud-SyncEventID"];
}
-(NSInteger)syncEventID{
#warning 判断此处的事件ID是否需要存储，考虑到有开关功能，关闭时不应再添加水印
	NSInteger syncEventID = [[NSUserDefaults standardUserDefaults] integerForKey:@"Cloud-SyncEventID"];
	if (syncEventID == 0) {
		syncEventID = kFSEventStreamEventIdSinceNow;
	}
	return syncEventID;
}
void fsevents_callback(ConstFSEventStreamRef streamRef,
					   void *userData,
					   size_t numEvents,
					   void *eventPaths,
					   const FSEventStreamEventFlags eventFlags[],
					   const FSEventStreamEventId eventIds[]) {
	CSFSEventStream *self = (__bridge CSFSEventStream *)userData;
	NSArray *pathArr = (__bridge NSArray*)eventPaths;
	FSEventStreamEventId lastRenameEventID = 0;
	NSString* lastPath = nil;
	for(int i=0; i<numEvents; i++){
		FSEventStreamEventFlags flag = eventFlags[i];
		if(kFSEventStreamEventFlagItemCreated & flag) {
			NSLog(@"create file: %@", pathArr[i]);
		}
		if(kFSEventStreamEventFlagItemRenamed & flag) {
			FSEventStreamEventId currentEventID = eventIds[i];
			NSString* currentPath = pathArr[i];
			if (currentEventID == lastRenameEventID + 1) {
				// 重命名或者是移动文件
//				NSLog(@"mv %@ %@", lastPath, currentPath);
			} else {
				// 其他情况, 例如移动进来一个文件, 移动出去一个文件, 移动文件到回收站
				if ([[NSFileManager defaultManager] fileExistsAtPath:currentPath]) {
					// 移动进来一个文件
					if (![currentPath containsString:@"/Sogou/"]) {
						NSLog(@"move in file: %@", currentPath);
					}
					
					//判断是否是图片
					NSArray *pathArr = [currentPath componentsSeparatedByString:@"."];
					NSString *lastStr = pathArr.lastObject;
					if ([self validateIsPictureName:lastStr]) {
						NSImage *img = [[NSImage alloc]initWithContentsOfFile:currentPath];
						NSImageView *imgV = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 100, 100)];
						imgV.image = img;
						
#warning TODO Digital waterMarking
					}
				} else {
					// 移出一个文件
//					NSLog(@"move out file: %@", currentPath);
				}
			}
			lastRenameEventID = currentEventID;
			lastPath = currentPath;
		}
		if(kFSEventStreamEventFlagItemRemoved & flag) {
//			NSLog(@"remove: %@", pathArr[i]);
		}
		if(kFSEventStreamEventFlagItemModified & flag) {
//			NSLog(@"modify: %@", pathArr[i]);
		}
	}
	[self updateEventID];
}

/**
 *  校验是否是图片后缀名
 */
-(BOOL)validateIsPictureName:(NSString *)name{
	
	NSArray *suffix = @[@"png",@"PNG",
						@"jpg",@"JPG",
						@"jpeg",@"JPEG",
						@"jfif",@"JFIF",
						@"bmp",@"BMP",
						@"gif",@"GIF"];
	//	NSPredicate *preTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicateStr];
	BOOL flag = [suffix containsObject:name];
	return flag;
	
}

#pragma mark - singleton
+ (instancetype)sharedManager{
	
	static CSFSEventStream *fsEventStream;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		fsEventStream = [[CSFSEventStream alloc]init];
	});
	return fsEventStream;
}
@end

