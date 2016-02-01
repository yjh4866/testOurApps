//
//  AppInfoItem.m
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import "AppInfoItem.h"

#define CachePath_AppIcon [NSHomeDirectory() stringByAppendingPathComponent:@"Library/OurAppIcons"]
#define FilePath_IconVer [NSHomeDirectory() stringByAppendingPathComponent:@"Library/OurAppIcons/IconVer.plist"]

@implementation AppInfoItem

// 获取图标保存路径
- (NSString *)iconPath
{
    // 创建保存图标的文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:CachePath_AppIcon]) {
        [fileManager createDirectoryAtPath:CachePath_AppIcon withIntermediateDirectories:YES
                                attributes:nil error:nil];
        [@{} writeToFile:FilePath_IconVer atomically:YES];
    }
    // 图标保存路径
    NSString *ext = [self.iconUrl pathExtension];
    NSString *iconName = [self.appID stringByAppendingPathExtension:ext];
    NSString *iconPath = [CachePath_AppIcon stringByAppendingPathComponent:iconName];
    // 当前保存的图标的版本号
    {
        NSMutableDictionary *mdicIconVer = [NSMutableDictionary dictionaryWithContentsOfFile:FilePath_IconVer];
        NSString *iconVer = mdicIconVer[self.appID];
        if (nil == iconVer) iconVer = @"";
        // 当前应用已有图标的版本号与当前应用的版本号不一致，则删除旧图标并保存新版本号
        if (![self.appVersion isEqualToString:iconVer]) {
            [[NSFileManager defaultManager] removeItemAtPath:iconPath error:nil];
            //
            [mdicIconVer setObject:self.appVersion forKey:self.appID];
            [mdicIconVer writeToFile:FilePath_IconVer atomically:YES];
        }
    }
    return iconPath;
}

@end
