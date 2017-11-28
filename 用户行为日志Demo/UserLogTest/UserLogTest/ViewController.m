//
//  ViewController.m
//  UserLogTest
//
//  Created by Avazu Holding on 2017/11/15.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
//#import <SSZipA rchive/SSZipArchive.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#import <objective-zip/Objective-Zip.h>
@implementation ViewController


- (void)viewDidLoad {
	[super viewDidLoad];

	NSString *zipFilePath = @"/Users/avazuholding/Desktop/test/lalal.zip";
	NSString *dataPath = @"/Users/avazuholding/Desktop/test";
	OZZipFile *zipFile = [[OZZipFile alloc]initWithFileName:zipFilePath mode:OZZipFileModeCreate];
	// 读取目录中的文件
	NSError *error = nil;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:&error];   // 将每个文件写入zip
	for (NSString *filename in files) {
		// 获取文件创建日期
		NSString *path = [dataPath stringByAppendingPathComponent:filename];
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
		NSDate *date = [attributes objectForKey:NSFileCreationDate];
		// 写文件
		OZZipWriteStream *stream = [zipFile writeFileInZipWithName:filename fileDate:date compressionLevel:OZZipCompressionLevelBest];
		NSData *data = [NSData dataWithContentsOfFile:path];
		[stream writeData:data];
		[stream finishedWriting];
	}
	// 关闭zip文件
	[zipFile close];
	
}
int mainTest()
{
//	unsigned char *data = (unsigned char *)"/Volumes/小蘑菇/Test/20171120.log";
	NSString *nedStr = @"/Volumes/小蘑菇/Test/20171120.log";
	const char *data = [nedStr UTF8String];
	size_t size;
	
	size = strlen((const char *)data);
	
	appendCharacter(&data, &size , 0x01);
	NSLog(@"data = %s",data);
	
	
	
	nedStr = [NSString stringWithUTF8String:data];
	NSLog(@"nedStr = %@",nedStr);
	return 0;
}
int appendCharacter(unsigned char **data, size_t *size, int sepStyle)
{
	if (*data == NULL || *size < 1)
	{
		return 0;
	}
	
//	const char character[1] = { 0x01 };
	unsigned char *string = NULL;

	string = (unsigned char *)malloc(*size + 1);
	memset(string, 0, *size+1);
	memcpy(string, *data, *size);
	string[*size] = sepStyle;
	string[*size + 1] = 0x00;
	*data = string;
	*size += 1;
	
//	NSLog(@"%s",string);
	
	return 1;
}
- (void)test{
//aaaa\^A
//	aaaa\^A
}
- (void)checkIsDir{
	BOOL isDir = NO;
	;
	NSLog(@"%d",[[NSFileManager defaultManager] fileExistsAtPath:@"/Users/avazuholding/Desktop/test1/20171116.log" isDirectory:&isDir]);
	NSLog(@"dir = %d",isDir);
}
- (void)writeContent{
	NSString *path = [self getPathByMainBundle];
	NSLog(@"%@",path);
	
	NSString *userLog = @"nishiyige\n";
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
	NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	
	if(fileHandle == nil)
	{
		return;
	}
	
	[fileHandle seekToEndOfFile];
	[fileHandle writeData:[@"123\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandle closeFile];
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
