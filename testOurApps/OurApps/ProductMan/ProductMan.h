//
//  ProductMan.h
//  
//
//  Created by 建红 杨 on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
#import "DataAppItem.h"


@protocol ProductManDelegate;

@interface ProductMan : NSObject

@property (nonatomic, assign) id <ProductManDelegate> delegate;

// 获取我们的iPhone应用列表
- (void)getOuriPhoneAppList:(NSString *)appleID;

// 获取我们的iPad应用列表
- (void)getOuriPadAppList:(NSString *)appleID;

// 下载应用图标
- (void)downloadAppIcon:(NSString *)appID with:(NSString *)strAppIconURL;

@end



@protocol ProductManDelegate <NSObject>

@optional

// 我们的iPhone应用列表获取成功
- (void)productMan:(ProductMan *)productMan iPhoneAppListSuccess:(NSArray *)arrayAppList;

// 我们的iPhone应用列表获取失败
- (void)productManiPhoneAppListFailure:(ProductMan *)productMan;

// 我们的iPad应用列表获取成功
- (void)productMan:(ProductMan *)productMan iPadAppListSuccess:(NSArray *)arrayAppList;

// 我们的iPad应用列表获取失败
- (void)productManiPadAppListFailure:(ProductMan *)productMan;

// 应用图标下载成功
- (void)productMan:(ProductMan *)productMan downloadAppIconSuccess:(UIImage *)imageAppIcon of:(NSString *)appID;

// 应用图标下载失败
- (void)productMan:(ProductMan *)productMan downloadAppIconFailureOf:(NSString *)appID;

@end
