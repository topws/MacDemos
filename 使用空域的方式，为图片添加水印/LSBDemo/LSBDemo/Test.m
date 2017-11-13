//
//  Test.m
//  LSBDemo
//
//  Created by Avazu Holding on 2017/9/25.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "Test.h"
#import <UIKit/UIKit.h>
@implementation Test

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
@end
