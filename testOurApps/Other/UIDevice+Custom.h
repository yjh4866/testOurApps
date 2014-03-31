//
//  UIDevice+Custom.h
//  
//
//  Created by Jianhong Yang on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


// 根据版本号计算一个整数
NSUInteger versionID(NSString *strVersion);


@interface UIDevice (Custom)

// 系统版本号
+ (NSUInteger)systemVersionID;

// 取MAC地址
+ (NSString *)macAddress;

// 局域网IP
+ (NSString *)localIPAddress;

@end
