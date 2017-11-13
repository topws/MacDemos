//
//  ViewController.m
//  NSButtonTest
//
//  Created by Avazu Holding on 2017/11/8.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()
@property (weak) IBOutlet NSButton *topBtn;
@property (weak) IBOutlet NSButton *roundRectBtn;

@end
@implementation ViewController
- (IBAction)topBtn:(id)sender {
	NSLog(@"topbtn = %@",sender);
}
- (IBAction)aboveBtn:(id)sender {
	NSLog(@"abbtn = %@",sender);
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	
//	[self.topBtn setTitle:@"lalal"];
//	self.topBtn.wantsLayer = YES;
//	self.topBtn.layer.backgroundColor = [NSColor redColor].CGColor;
	
//	[self.topBtn cell].attributedStringValue = [[NSAttributedString alloc] initWithString:@"wori " attributes:@{NSForegroundColorAttributeName : [NSColor blueColor]}];
	
	self.topBtn.attributedTitle = [[NSAttributedString alloc] initWithString:@"wori " attributes:@{NSForegroundColorAttributeName : [NSColor redColor]}];
	
}


- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
