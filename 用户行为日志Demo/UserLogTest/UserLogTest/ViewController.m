//
//  ViewController.m
//  UserLogTest
//
//  Created by Avazu Holding on 2017/11/15.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
#import <SSZipArchive/SSZipArchive.h>
@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"%@",[self specificTime]);
	
	NSLog(@"%@",[self hexStringFromString:@"x01"]);
	return;
	NSDate *nowDate = [NSDate date];

	NSString *path = [self getPathByMainBundle];
	NSLog(@"%@",path);
	
	NSString *userLog = @"nishiyigedasi\n";
	[[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
	NSError * error;
	BOOL result = [userLog writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
	if (result && !error) {
		NSLog(@"write success");
	}else{
		NSLog(@"error=%@",error);
	}
	BOOL flag = [[NSFileManager defaultManager] isWritableFileAtPath:path];
	NSLog(@"%d",flag);
//	[@"lallalal" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
//	NSArray *arr = @[@"1",@"2",@"3",@"4"];
//	[arr writeToFile:path atomically:YES];
	
	NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	
	if(fileHandle == nil)
		
	{
		
		return;
		
	}
	
	[fileHandle seekToEndOfFile];
	
	[fileHandle writeData:[@"123\n" dataUsingEncoding:NSUTF8StringEncoding]];

	[fileHandle closeFile];
	
	NSTimeInterval timer = [[NSDate date] timeIntervalSinceDate:nowDate];
	NSLog(@"%f",timer);
	
	
	
	
}

/**
 *  log路径
 */
- (NSString *)getLogPath{
	
	NSLog(@"homePath = %@",NSHomeDirectory());
	NSArray *urlPaths = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationDirectory inDomains:NSUserDomainMask];
	NSURL *urlPath = urlPaths.lastObject;
	NSString *filePath = @"";
	if (urlPath.absoluteString.length > 0) {
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
		[dateFormatter setLocale:[NSLocale currentLocale]];//[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
		
		filePath = [@"Contents" stringByAppendingPathComponent:dateStr];
		filePath = [dateStr stringByAppendingPathComponent:@"nDefender.log"];
		filePath = [urlPath.absoluteString stringByAppendingPathComponent:filePath];
		filePath = [filePath stringByAppendingPathComponent:@""];
	}
	return filePath;
}

- (NSString *)getPathByMainBundle{
	return @"/Users/avazuholding/Desktop/nDefender.log";
	
	NSString *appPath = [[NSBundle mainBundle] bundlePath];
	appPath = [appPath stringByAppendingPathComponent:@"Contents"];
	appPath = [appPath stringByAppendingPathComponent:@"nDefenderLogs"];
	//总的文件路径
	if (![[NSFileManager defaultManager] fileExistsAtPath:appPath]) {
		NSError *logsError;
		[[NSFileManager defaultManager] createDirectoryAtPath:appPath withIntermediateDirectories:NO attributes:nil error:&logsError];
		if (logsError) {
			NSLog(@"logsError = %@",logsError);
		}
	}
	//当天的文件
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"yyyyMMdd"];
	NSString *dateStr = [formatter stringFromDate:[NSDate date]];
	NSString *filePath = [appPath stringByAppendingPathComponent:dateStr];
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
	}
	
	return filePath;
}

- (NSString *)specificTime{
	NSDate *nowDate = [NSDate date];
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateFormat:@"yyyyMMddHH:mm"];//yyyy-MM-dd HH:mm:ss
	NSTimeInterval timer1 = [[NSDate date] timeIntervalSinceDate:nowDate];
	NSLog(@"%f",timer1);
	NSString *dateStr = [formatter stringFromDate:[NSDate date]];
	
	NSDate *nowDate1 = [NSDate date];
	NSTimeInterval timer = [[NSDate date] timeIntervalSinceDate:nowDate1];
	NSLog(@"timer =%f",timer);
	return dateStr;
}

//普通字符串转换为十六进制的。

- (NSString *)hexStringFromString:(NSString *)string{
	NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
	Byte *bytes = (Byte *)[myD bytes];
	//下面是Byte 转换为16进制。
	NSString *hexStr=@"";
	for(int i=0;i<[myD length];i++)
		
	{
		NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
		
		if([newHexStr length]==1)
			
			hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
		
		else
			
			hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
	}
	return hexStr;
}

@end
