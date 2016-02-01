//
//  AppManager.m
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import "AppManager.h"
#import "NBLHTTPManager.h"

#import "AppInfoItem.h"

@interface AppManager ()
@end

@implementation AppManager


#pragma mark - Public

// 获取指定开发者ID的应用列表
- (void)getAppListOf:(NSString *)artistID
{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSMutableString *mstrURL = [NSMutableString stringWithString:@"https://itunes.apple.com/"];
    if (countryCode.length > 0) {
        [mstrURL appendFormat:@"%@/", countryCode];
    }
    [mstrURL appendFormat:@"artist/id%@?dataOnly=true", artistID];
    //
    NSURL *URL = [NSURL URLWithString:mstrURL];
    NSMutableURLRequest *mURLRequest = [NSMutableURLRequest requestWithURL:URL];
    [mURLRequest setTimeoutInterval:20.0f];
    [mURLRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [mURLRequest setValue:@"iTunes-iPad/6.0 (6; 16GB; dt:73)" forHTTPHeaderField:@"User-Agent"];
    //
    [[NBLHTTPManager sharedManager] requestObject:NBLResponseObjectType_JSON withRequest:mURLRequest param:@{@"id": artistID} andResult:^(NSHTTPURLResponse *httpResponse, id responseObject, NSError *error, NSDictionary *dicParam) {
        NSString *artistID = dicParam[@"id"];
        if (error) {
            [self.delegate appManager:self appListFailure:error with:artistID];
        }
        else {
            NSMutableArray *marriPhoneApp = [NSMutableArray array];
            NSMutableArray *marriPadApp = [NSMutableArray array];
            // 解析app列表
            NSArray *arrItem = responseObject[@"stack"];
            for (NSDictionary *dicItem in arrItem) {
                NSString *titleItem = dicItem[@"title"];
                NSArray *arrAppItem = dicItem[@"content"];
                if (NSNotFound != [titleItem rangeOfString:@"iPad"].location) {
                    for (NSDictionary *dicAppInfo in arrAppItem) {
                        AppInfoItem *appInfo = [[AppInfoItem alloc] init];
                        [self translateAppInfoItem:appInfo from:dicAppInfo];
                        [marriPadApp addObject:appInfo];
                    }
                }
                else if (NSNotFound != [titleItem rangeOfString:@"iPhone"].location) {
                    for (NSDictionary *dicAppInfo in arrAppItem) {
                        AppInfoItem *appInfo = [[AppInfoItem alloc] init];
                        [self translateAppInfoItem:appInfo from:dicAppInfo];
                        [marriPhoneApp addObject:appInfo];
                    }
                }
            }
            // 数据获取成功
            [self.delegate appManager:self appListSuccessWith:artistID
                    withiPhoneAppList:marriPhoneApp andiPadApplist:marriPadApp];
        }
    }];
}


#pragma mark - Private

- (void)translateAppInfoItem:(AppInfoItem *)appInfo from:(NSDictionary *)dicAppInfo
{
    appInfo.appName = dicAppInfo[@"name"];
    appInfo.bundleID = dicAppInfo[@"bundle-id"];
    appInfo.appID = dicAppInfo[@"id"];
    appInfo.appUrl = dicAppInfo[@"url"];
    appInfo.appTinyUrl = dicAppInfo[@"tinyUrl"];
    appInfo.appVersion = dicAppInfo[@"version"];
    appInfo.createDate = dicAppInfo[@"release_date"];
    appInfo.releaseDate = dicAppInfo[@"posted"];
    // 价格
    NSArray *arrPrice = dicAppInfo[@"offers"];
    for (NSDictionary *dicPrice in arrPrice) {
        appInfo.price = dicPrice[@"priceFormatted"];
        break;
    }
    // 75像素的图标
    NSArray *arrIconItem = dicAppInfo[@"artwork"];
    for (NSDictionary *dicIcon in arrIconItem) {
        int sizeIcon = [dicIcon[@"width"] intValue];
        if (75 == sizeIcon) {
            appInfo.iconUrl = dicIcon[@"url"];
            break;
        }
        else if (100 == sizeIcon) {
            appInfo.iconUrl = dicIcon[@"url"];
            break;
        }
        else if (144 == sizeIcon) {
            appInfo.iconUrl = dicIcon[@"url"];
            break;
        }
    }
}

@end
