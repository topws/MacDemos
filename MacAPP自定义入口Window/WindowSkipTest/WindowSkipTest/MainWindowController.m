//
//  MainWindowController.m
//  WindowSkipTest
//
//  Created by Avazu Holding on 2017/11/7.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "MainWindowController.h"
#import "NewsWindowController.h"
#define WindowWidth 540
@interface MainWindowController ()
@property (strong)NewsWindowController *newsWindow;
@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
	
	self.window.contentView.layer.backgroundColor = [NSColor redColor].CGColor;
	
	NSRect frame = self.window.screen.visibleFrame;
	
//	[[self window] setFrameOrigin:NSMakePoint(frame.size.width * 0.5-480, frame.size.height * 0.5)];
	[[self window] setMaxSize:NSMakeSize(960, WindowWidth)];
	[[self window] setMinSize:NSMakeSize(960, WindowWidth)];
	[[self window] setContentSize:NSMakeSize(960, WindowWidth)];
	[[self window] center];
	
}
- (IBAction)showNewsWindow:(NSButtonCell *)sender {
	
	_newsWindow = [[NewsWindowController alloc] initWithWindowNibName:@"NewsWindowController"];
	[_newsWindow.window orderFront:nil];
	
	//
	[self.window orderOut:nil];
}

@end
