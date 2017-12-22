//
//  AppDelegate.m
//  NSURLProtocolTest
//
//  Created by Avazu Holding on 2017/12/6.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "AppDelegate.h"
#import "Filter.h"
#import <resolv.h>
#include <arpa/inet.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
//	[NSURLProtocol registerClass:[Filter class]];
	
//	[[Filter new] startLoading];
	
	unsigned char auResult[512];
	int nBytesRead = 0;
	nBytesRead = res_9_query("www.baidu.com", ns_c_in, ns_t_a, auResult, sizeof(auResult));
	
	ns_msg handle;
	res_9_ns_initparse(auResult, nBytesRead, &handle);
	NSMutableArray *ipList = nil;
	int msg_count = ns_msg_count(handle, ns_s_an);
	if (msg_count > 0) {
		ipList = [[NSMutableArray alloc] initWithCapacity:msg_count];
		for(int rrnum = 0; rrnum < msg_count; rrnum++) {
			ns_rr rr;
			if(ns_parserr(&handle, ns_s_an, rrnum, &rr) == 0) {
				char ip1[16];
				strcpy(ip1, inet_ntoa(*(struct in_addr *)ns_rr_rdata(rr)));
				NSString *ipString = [[NSString alloc] initWithCString:ip1 encoding:NSASCIIStringEncoding];
				if (![ipString isEqualToString:@""]) {
					
					//将提取到的IP地址放到数组中
					[ipList addObject:ipString];
				}
			}
		}
	}
	NSLog(@"%@",ipList);
	
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end
