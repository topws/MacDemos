//
//  NewsWindowController.m
//  WindowSkipTest
//
//  Created by Avazu Holding on 2017/11/7.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "NewsWindowController.h"

@interface NewsWindowController ()

@end

@implementation NewsWindowController
- (IBAction)bXK:(NSButton *)sender {
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
	
	NSRect frame = self.window.screen.visibleFrame;
	
//	[[self window] setFrameOrigin:NSMakePoint(frame.size.width * 0.5, frame.size.height * 0.5)];
	[[self window] setMaxSize:NSMakeSize(960, 960)];
	[[self window] setMinSize:NSMakeSize(960, 960)];
	[[self window] setContentSize:NSMakeSize(960, 960)];
	[[self window] center];
}

@end
