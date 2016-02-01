//
//  AppInfoItem.h
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import <Foundation/Foundation.h>

@interface AppInfoItem : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *bundleID;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appUrl;
@property (nonatomic, strong) NSString *appTinyUrl;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *price;

// 获取图标保存路径
- (NSString *)iconPath;

@end
