//
//  UIDevice+Custom.h
//  
//
//  Created by Jianhong Yang on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (Custom)

//系统版本号
+ (NSUInteger)systemVersionID;

//取MAC地址
+ (NSString *)macAddress;

@end
