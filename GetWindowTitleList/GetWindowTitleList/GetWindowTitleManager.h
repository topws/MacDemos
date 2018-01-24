//
//  GetWindowTitleManager.h
//  GetWindowTitleList
//
//  Created by Avazu Holding on 2018/1/23.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViolationObject.h"

@interface GetWindowTitleManager : NSObject
- (void)startTimer;
- (void)stopTimer;
+ (instancetype)sharedManager;
@end


