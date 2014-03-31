//
//  UIImageView+Cache.m
//  
//
//  Created by CocoaChina_yangjh on 13-12-17.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "HTTPConnection.h"


// 将url转换为文件名
NSString *transferFileNameFromURL(NSString *url)
{
    //拼接图片文件名
    NSCharacterSet *setChars = [NSCharacterSet characterSetWithCharactersInString:@":/."];
    NSArray *components = [url componentsSeparatedByCharactersInSet:setChars];
    NSMutableString *mstrFileName = [NSMutableString string];
    for (NSString *component in components) {
        [mstrFileName appendString:component];
    }
    //拼接后缀
    [mstrFileName appendFormat:@".%@", [[NSURL URLWithString:url] pathExtension]];
    return mstrFileName;
}

#pragma mark - UIImageViewManager

@interface UIImageViewManager : NSObject <HTTPConnectionDelegate> {
    
    HTTPConnection *_httpDownload;
    
    NSMutableDictionary *_mdicURLKey;
}
@end

@implementation UIImageViewManager

- (id)init
{
    self = [super init];
    if (self) {
        _httpDownload = [[HTTPConnection alloc] init];
        _httpDownload.delegate = self;
        //
        _mdicURLKey = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_httpDownload release];
    //
    [_mdicURLKey release];
    
    [super dealloc];
}

+ (UIImageViewManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static UIImageViewManager *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UIImageViewManager alloc] init];
    });
    
    return sSharedInstance;
}

- (void)downloadFile:(NSString *)filePath from:(NSString *)url showOn:(UIImageView *)imageView
{
    // 创建参数字典
    NSDictionary *dicNewParam = @{@"view": imageView, @"path": filePath, @"url": url};
    // 取出url相应的任务列表
    NSMutableArray *marray = [_mdicURLKey objectForKey:url];
    if (nil == marray) {
        marray = [NSMutableArray array];
        [_mdicURLKey setObject:marray forKey:url];
    }
    // 加入下载任务
    [marray addObject:dicNewParam];
    // 该url未下载才会下载
    if (marray.count == 1) {
        [_httpDownload requestWebDataWithURL:url andParam:dicNewParam cache:YES priority:YES];
    }
}


#pragma mark HTTPConnectionDelegate

// 网络数据下载失败
- (void)httpConnect:(HTTPConnection *)httpConnect error:(NSError *)error with:(NSDictionary *)dicParam
{
    NSString *url = [dicParam objectForKey:@"url"];
    NSMutableArray *marray = [_mdicURLKey objectForKey:url];
    // 该url的图片均下载失败
    [marray removeAllObjects];
}

// 网络数据下载完成
- (void)httpConnect:(HTTPConnection *)httpConnect finish:(NSData *)data with:(NSDictionary *)dicParam
{
    NSString *url = [dicParam objectForKey:@"url"];
    NSMutableArray *marray = [_mdicURLKey objectForKey:url];
    // 创建图片对象
    UIImage *image = [[UIImage alloc] initWithData:data];
    if (image) {
        // 相应的所有下载任务都算完成
        for (NSDictionary *dic in marray) {
            // 保存
            NSString *filePath = [dic objectForKey:@"path"];
            [data writeToFile:filePath atomically:YES];
            // 显示图片
            UIImageView *imageView = [dic objectForKey:@"view"];
            imageView.image = image;
        }
    }
    [image release];
    // 清空任务
    [marray removeAllObjects];
}

@end


#pragma mark - UIImageView (Cache)

@implementation UIImageView (Cache)

/**
 *	@brief	设置图片路径和网址（不全为空）
 *
 *	@param 	filePath 	缓存图片保存路径
 *	@param 	picUrl 	图片下载地址
 */
- (void)loadImageFromCachePath:(NSString *)filePath orPicUrl:(NSString *)picUrl
{
    // 无路径则使用默认路径
    if (filePath.length == 0) {
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/AppIcons"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:cachePath]) {
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES
                                    attributes:nil error:nil];
        }
        NSString *fileName = transferFileNameFromURL(picUrl);
        filePath = [cachePath stringByAppendingPathComponent:fileName];
    }
    // 读缓存图片
    UIImage *imageCache = [UIImage imageWithContentsOfFile:filePath];
    // 读取缓存成功
    if (imageCache) {
        self.image = imageCache;
    }
    // 缓存图片没读取到，且url存在，则下载
    else if (picUrl) {
        [[UIImageViewManager sharedInstance] downloadFile:filePath from:picUrl showOn:self];
    }
}

@end
