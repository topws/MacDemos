//
//  AppProxyProvider.m
//  NExtension
//
//  Created by Avazu Holding on 2017/12/5.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import "AppProxyProvider.h"

@implementation AppProxyProvider

- (void)startProxyWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
	// Add code here to start the process of connecting the tunnel.
	
	NSError *error;
		completionHandler(error);
	
}

- (void)stopProxyWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
	// Add code here to start the process of stopping the tunnel.
	completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler {
	// Add code here to handle the message.
	if (completionHandler != nil) {
		completionHandler(messageData);
	}
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
	// Add code here to get ready to sleep.
	completionHandler();
}

- (void)wake {
	// Add code here to wake up.
	NSLog(@"112");
}

- (BOOL)handleNewFlow:(NEAppProxyFlow *)flow {
	// Add code here to handle the incoming flow.
	return NO;
}

@end
