//
//  ViewController.m
//  NSScrollView
//
//  Created by Avazu Holding on 2018/2/28.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSView *dcView;
@end
@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	NSRect frame = NSMakeRect(100, 100, 400, 200);
	
	self.scrollView = [[NSScrollView alloc] initWithFrame:frame];
	self.scrollView.hasVerticalScroller = YES;
	self.scrollView.hasHorizontalScroller = YES;
	[self.scrollView setBorderType:NSNoBorder];
	[self.scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	
	self.dcView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width * 5, frame.size.height)];
	for (int i = 0; i < 5; i++) {
		NSImage * image = [NSImage imageNamed:@"VolumeIcon.icns"];
		[image setSize:CGSizeMake(200, 200)];
		NSImageView * imageView = [[NSImageView alloc] initWithFrame:CGRectMake(200 * i, 0, 200, frame.size.height)];
		imageView.image = image;
		[self.dcView addSubview:imageView];
	}
	
	[self.scrollView setDocumentView:self.dcView];
	
	NSLog(@"%@", NSStringFromSize(self.scrollView.contentSize));
	[self.view addSubview:self.scrollView];
}


- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
