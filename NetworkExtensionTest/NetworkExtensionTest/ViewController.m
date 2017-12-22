//
//  ViewController.m
//  NetworkExtensionTest
//
//  Created by Avazu Holding on 2017/12/5.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
@interface ViewController()
@property (weak) IBOutlet WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	
	NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
	
	NEAppProxyProviderManager *manager = [NEAppProxyProviderManager sharedManager];
	[manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
		NSLog(@"error = %@",error);
		
	}];
	NETunnelProviderSession *session = (NETunnelProviderSession *)manager.connection;
	NSError *err;
	[session startTunnelWithOptions:nil andReturnError:&err];
	
	[NEAppProxyProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NEAppProxyProviderManager *> * _Nullable managers, NSError * _Nullable error) {
		NSLog(@"managers =%@,error = %@",managers,error);
		
		
	}];
	
	
	
	
	
									  
}


- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
