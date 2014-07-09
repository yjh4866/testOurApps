//
//  AppInfoItem.h
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import <Foundation/Foundation.h>

@interface AppInfoItem : NSObject

@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) NSString *bundleID;
@property (nonatomic, retain) NSString *appID;
@property (nonatomic, retain) NSString *appUrl;
@property (nonatomic, retain) NSString *appTinyUrl;
@property (nonatomic, retain) NSString *appVersion;
@property (nonatomic, retain) NSString *createDate;
@property (nonatomic, retain) NSString *releaseDate;
@property (nonatomic, retain) NSString *iconUrl;
@property (nonatomic, retain) NSString *price;

// 获取图标保存路径
- (NSString *)iconPath;

@end
