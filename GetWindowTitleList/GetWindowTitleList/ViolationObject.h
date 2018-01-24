//
//  ViolationObject.h
//  GetWindowTitleList
//
//  Created by Avazu Holding on 2018/1/23.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViolationObject : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,assign)BOOL needEnd;
@end
