//
//  CSChangeBGButton.m
//  NSButtonTest
//
//  Created by Avazu Holding on 2017/11/8.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "CSChangeBGButton.h"

@implementation CSChangeBGButton

- (void)drawRect:(NSRect)dirtyRect {

    [super drawRect:dirtyRect];
	//背景颜色
	[[NSColor blueColor] set];
	NSRectFill(dirtyRect);
	
	//绘制文字
//	if (titleString != nil) {
		NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
		[paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
		[paraStyle setAlignment:NSCenterTextAlignment];
		//[paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		NSDictionary *attrButton = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Verdana" size:14], NSFontAttributeName, [NSColor colorWithCalibratedRed:255 green:255 blue:255 alpha:1], NSForegroundColorAttributeName, paraStyle, NSParagraphStyleAttributeName, nil];
		NSAttributedString * btnString = [[NSAttributedString alloc] initWithString:@"worinidaye" attributes:attrButton];
		
		[btnString drawInRect:NSMakeRect(0, 4, self.frame.size.width, self.frame.size.height)];
//	}
}

@end
