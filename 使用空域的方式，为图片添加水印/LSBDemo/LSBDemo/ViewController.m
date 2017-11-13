//
//  ViewController.m
//  LSBDemo
//
//  Created by Avazu Holding on 2017/9/22.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//	[self showOriginImage];
//	//获取一张PNG图片的数据
//	UIImage * img = [UIImage imageNamed:@"test"];
//
//	NSData * data = UIImagePNGRepresentation(img);
//
//	NSLog(@"length = %lu\n",(unsigned long)data.length);
//	NSLog(@"---------------------------------------------");
//	[self analysisIMG:data];

	
	
}


- (void)analysisIMG:(NSData *)data{
	//移除非关键数据块(IHDR,PLTE,IDAT,IEND)
	NSMutableData *newData = [NSMutableData new];
	//文件头
	NSData *headData = [data subdataWithRange:NSMakeRange(0, 8)];
	[newData appendData:headData];
	
	Byte *headBytes = (Byte *)[headData bytes];
	for (int i = 0; i < headData.length; i ++) {
		NSLog(@"headBytes = %0x",headBytes[i]);
	}
	NSLog(@"headData = %@",headData);
	NSUInteger location = 8;
	BOOL finish = NO;
	//数据块(主要内容为 IHDR,PLTE,IDAT,IEND)
	while (1) {
		//解析每个数据块的内容
		
		//块内容长度
		NSData *chunkLen = [data subdataWithRange:NSMakeRange(location, 4)];
		location += 4;
		NSLog(@"chunkLen = %d\n",[self dataToInt:chunkLen]);
		//块类型
		NSData *chunkType = [data subdataWithRange:NSMakeRange(location, 4)];
		location += 4;
		NSString *chunkTypeStr = [[NSString alloc]initWithData:chunkType encoding:NSUTF8StringEncoding];
		NSLog(@"chunkType = %@\n",chunkTypeStr);
		if ([chunkTypeStr isEqualToString:@"IEND"] || [chunkTypeStr isEqualToString:@"iend"]) {
			finish = YES;
		}
		
		//块内容
		NSUInteger chunkLength = [self dataToInt:chunkLen];
		NSData *chunkContent = [data subdataWithRange:NSMakeRange(location, chunkLength)];
		NSLog(@"chunkData = %@",chunkContent);
		location += chunkLength;
		if ([chunkTypeStr isEqualToString:@"IHDR"]) {
			//获取图片的宽高
			NSData *imgWData = [chunkContent subdataWithRange:NSMakeRange(0, 4)];
			NSLog(@"imgW = %d",[self dataToInt:imgWData]);
			NSData *imgHData = [chunkContent subdataWithRange:NSMakeRange(4, 4)];
			NSLog(@"imgH = %d",[self dataToInt:imgHData]);
		}
		//CRC 冗余校验码
		NSData *chunkCRC = [data subdataWithRange:NSMakeRange(location, 4)];
		location += 4;
		NSLog(@"chunkCRC = %@\n",chunkCRC);
		NSLog(@"\n");
		
		//判断是否是关键数据块，是则拼接PLTE,IDAT,IEND
		if ([chunkTypeStr isEqualToString:@"IHDR"] ||
			[chunkTypeStr isEqualToString:@"PLTE"] ||
			[chunkTypeStr isEqualToString:@"IDAT"] ||
			[chunkTypeStr isEqualToString:@"IEND"]
			) {
			NSMutableData * crcMData = [NSMutableData new];
			[crcMData appendData:chunkLen];
			[crcMData appendData:chunkType];
			[crcMData appendData:chunkContent];
			Byte *testByte = [crcMData.copy bytes];
	
			char *inStr = [self convertDataToHexStr:crcMData];
//			char inStr[crcMData.length];
//			for (int i = 0; i < crcMData.length; i++) {
//				NSLog(@"testByte = %02x",testByte[i]);
//				inStr[i] = testByte[i];
//			}
//			if (inStr) {
				unsigned int crc32 = [self GetCRC:inStr :strlen(inStr)];
				NSData *crc32Data = [self intToData:(int)crc32];
				NSLog(@"crc32Data = %@,chunkCRC = %@",crc32Data,chunkCRC);
//			}
			
			
			//拼接
			[newData appendData:chunkLen];
			[newData appendData:chunkType];
			[newData appendData:chunkContent];
			[newData appendData:chunkCRC];
			
		}
		if ([chunkTypeStr isEqualToString:@"IHDR"]) {
			//文件头的后面拼接一个 自定义的数据块
			[self addNewDataIntoPNG:newData];
		}
		if (finish) {
			break;
		}
	}
	
	[self showNewImage:newData.copy];
}
//将NSData转换成十六进制的字符串
- (char *)convertDataToHexStr:(NSData *)data {
	if (!data || [data length] == 0) {
		return "";
	}
	NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
	
	__block char *wantStr;
	[data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
		unsigned char *dataBytes = (unsigned char*)bytes;
		char inStr[byteRange.length];
		for (NSInteger i = 0; i < byteRange.length; i++) {
			NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
			
			if ([hexStr length] == 2) {
				[string appendString:hexStr];
//				inStr[i] = hexStr.cString;
			} else {
				[string appendFormat:@"0%@", hexStr];
//				inStr[i] = string.cString;
			}
			
			inStr[i] = (dataBytes[i]) & 0xff;
		}
		
		wantStr = inStr;
	}];
	
	return wantStr;
}
- (void)addNewDataIntoPNG:(NSMutableData *)data{
	NSString *str = @"ITSSSNeew,2017.10.01.09.8.21,name:wei";
	NSString *name = @"tEXt";
	
	NSMutableData * forCRC = [NSMutableData new];
	//chunkType
	NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
	//chunkLength
	NSData *addData = [str dataUsingEncoding:NSUTF8StringEncoding];
	NSUInteger length = addData.length;
	NSData *lengthData = [self intToData:(int)length];
	//chunkContent
	NSData *chunkContent = [str dataUsingEncoding:NSUTF8StringEncoding];
	
	[forCRC appendData:lengthData];
	[forCRC appendData:nameData];
	[forCRC appendData:chunkContent];
	
	//chunkCRC
	unsigned int chunkCRC = [self GetCRC:(char *)[forCRC.copy bytes] :(unsigned int)(8 + length)];
	NSData *chunkCRCData = [self intToData:(int)chunkCRC];
	[forCRC appendData:chunkCRCData];

	[data appendData:forCRC.copy];
}
- (unsigned int)GetCRC:(char *)InStr :(unsigned int)len{
	//无符号的整形数组
	unsigned int Crc32Table[256];
	int i,j;
	unsigned int Crc;
	for (i = 0; i < 256; i++) {
		Crc = i;
		for (j = 0; j < 8; j++) {
			if (Crc & 1) {
				Crc = (Crc >> 1) ^ 0xEDB88320;
			}else{
				Crc >>= 1;
			}
		}
		Crc32Table[i] = Crc;
	}
	
	Crc = 0xffffffff;
	for (int m=0; m<len; m++) {
		Crc = (Crc >> 8) ^ Crc32Table[(Crc & 0xFF) ^ InStr[m]];
	}
	
	Crc ^= 0xFFFFFFFF;
	return Crc;
}
// InStr 其实指向的是 一个数组的指针
unsigned int GetCrc32(char* InStr,unsigned int len){
	unsigned int Crc32Table[256];
	int i,j;
	unsigned int Crc;
	for (i = 0; i < 256; i++){
		Crc = i;
		for (j = 0; j < 8; j++){
	  if (Crc & 1)
		  Crc = (Crc >> 1) ^ 0xEDB88320;
	  else
		  Crc >>= 1;
		}
		Crc32Table[i] = Crc;
	}
	
	Crc=0xffffffff;
	for(int m=0; m<len; m++){
		Crc = (Crc >> 8) ^ Crc32Table[(Crc & 0xFF) ^ InStr[m]];
	}
	
	Crc ^= 0xFFFFFFFF;
	return Crc;
}

- (void)showNewImage:(NSData *)data{
	
	UIImage *img = [[UIImage alloc]initWithData:data];
	UIImageView * imgV = [[UIImageView alloc]initWithImage:img];
	imgV.frame = CGRectMake(200, 100, 100, 100);
	[self.view addSubview:imgV];
	
	//保存这个图片
	UIImageWriteToSavedPhotosAlbum(img, self, @selector(image: didFinishSavingWithError:contextInfo:), NULL);
	
}
//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
	NSString *msg = nil ;
	if(error != NULL){
		msg = @"保存图片失败" ;
	}else{
		msg = @"保存图片成功" ;
	}
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alert dismissViewControllerAnimated:NO completion:nil];
	}];
	[alert addAction:action];
	[self showViewController:alert sender:nil];
}

- (void)showOriginImage{
	
	UIImage * img = [UIImage imageNamed:@"test"];
	UIImageView * imgV = [[UIImageView alloc]initWithImage:img];
	imgV.frame = CGRectMake(100, 100, 100, 100);
	[self.view addSubview:imgV];
}

/**
 int 转 NSData
 
 @param value int
 @return NSData
 */
- (NSData *)intToData:(int)value {
	Byte byte[4] = {};
	byte[0] =  (Byte) ((value>>24) & 0xFF);
	byte[1] =  (Byte) ((value>>16) & 0xFF);
	byte[2] =  (Byte) ((value>>8) & 0xFF);
	byte[3] =  (Byte) (value & 0xFF);
	return [NSData dataWithBytes:byte length:4];
}


/**
 NSData 转 int
 
 @param data NSData
 @return int
 */
- (int)dataToInt:(NSData *)data {
	Byte byte[4] = {};
	[data getBytes:byte length:4];
	int value;
	value = (int) (((byte[0] & 0xFF)<<24)
				   | ((byte[1] & 0xFF)<<16)
				   | ((byte[2] & 0xFF)<<8)
				   | (byte[3] & 0xFF));
	
	return value;
}


- (void)test1:(NSData *)data{
	
	//	NSData * chunkName = [data subdataWithRange:NSMakeRange(12, 4)];
	//	NSString * str = [[NSString alloc] initWithData:chunkName encoding:NSUTF8StringEncoding];
	//	NSLog(@"chunkName = %@",str);
	
	//	NSData * chunkData = [data subdataWithRange:NSMakeRange( data.length - 12, 12)];
	//	NSLog(@"%@",chunkData);
	
	NSData * rangeData = [data subdataWithRange:NSMakeRange(12, 17)];
	
	char newBuf[17] = {0x49,0x48,0x44,0x52,0x00,0x00,0x00,0x48,0x00,0x00,0x00,0x48,0x08,0x04,0x00,0x00,0x00};
	unsigned int crc32=GetCrc32(newBuf,sizeof(newBuf));
	
	printf("%08X\n，oc=%08X",crc32,[self GetCRC:newBuf :sizeof(newBuf)]);
	
	char * arrStr = (char *)[rangeData bytes];
	
	NSLog(@"%08X",GetCrc32(arrStr, sizeof(arrStr)));
	
	unsigned int a = 0xFFDFFFF7;
	unsigned char i = (unsigned char)a;
	char* b = (char*)&a;
 
	printf("%08x, %08x\n", i, *b);
}
@end
