//
//  AppManager.m
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import "AppManager.h"
#import "HTTPConnection.h"

#import "AppInfoItem.h"

typedef NS_ENUM(NSUInteger, AppManagerNetType) {
    AppManagerNetType_None,
    AppManagerNetType_AppList,
};

@interface AppManager () <HTTPConnectionDelegate> {
    
    HTTPConnection *_httpConnection;
}

@end

@implementation AppManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpConnection = [[HTTPConnection alloc] init];
        _httpConnection.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [_httpConnection release];
    
    [super dealloc];
}


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
    [_httpConnection requestWebDataWithRequest:mURLRequest andParam:@{@"type": @(AppManagerNetType_AppList), @"id": artistID}];
}


#pragma mark - HTTPConnectionDelegate

// 网络数据下载失败
- (void)httpConnect:(HTTPConnection *)httpConnect error:(NSError *)error with:(NSDictionary *)dicParam
{
    AppManagerNetType netType = [dicParam[@"type"] intValue];
    switch (netType) {
        case AppManagerNetType_AppList:
        {
            NSString *artistID = dicParam[@"id"];
            [self.delegate appManager:self appListFailure:error with:artistID];
        }
            break;
        default:
            break;
    }
}

// 网络数据下载完成
- (void)httpConnect:(HTTPConnection *)httpConnect finish:(NSData *)data with:(NSDictionary *)dicParam
{
    AppManagerNetType netType = [dicParam[@"type"] intValue];
    switch (netType) {
        case AppManagerNetType_AppList:
        {
            NSMutableArray *marriPhoneApp = [NSMutableArray array];
            NSMutableArray *marriPadApp = [NSMutableArray array];
            //
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *arrItem = dicData[@"stack"];
            for (NSDictionary *dicItem in arrItem) {
                NSString *titleItem = dicItem[@"title"];
                NSArray *arrAppItem = dicItem[@"content"];
                if (NSNotFound != [titleItem rangeOfString:@"iPad"].location) {
                    for (NSDictionary *dicAppInfo in arrAppItem) {
                        AppInfoItem *appInfo = [[AppInfoItem alloc] init];
                        [self translateAppInfoItem:appInfo from:dicAppInfo];
                        [marriPadApp addObject:appInfo];
                        [appInfo release];
                    }
                }
                else if (NSNotFound != [titleItem rangeOfString:@"iPhone"].location) {
                    for (NSDictionary *dicAppInfo in arrAppItem) {
                        AppInfoItem *appInfo = [[AppInfoItem alloc] init];
                        [self translateAppInfoItem:appInfo from:dicAppInfo];
                        [marriPhoneApp addObject:appInfo];
                        [appInfo release];
                    }
                }
            }
            //
            NSString *artistID = dicParam[@"id"];
            if (nil == dicData || nil == arrItem) {
                NSError *error = [NSError errorWithDomain:@"" code:-9999 userInfo:@{NSLocalizedDescriptionKey: @"数据错误"}];
                [self.delegate appManager:self appListFailure:error with:artistID];
            }
            else {
                [self.delegate appManager:self appListSuccessWith:artistID
                        withiPhoneAppList:marriPhoneApp andiPadApplist:marriPadApp];
            }
        }
            break;
        default:
            break;
    }
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
