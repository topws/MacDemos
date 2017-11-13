//
//  CSFSEventStream.h
//  CloudShield
//
//  Created by Avazu Holding on 2017/10/17.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFSEventStream : NSObject
+ (instancetype)sharedManager;

- (void)startEventStream;
- (void)stopEventStream;
@end
