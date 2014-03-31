//
//  UIImageView+Cache.h
//  
//
//  Created by CocoaChina_yangjh on 13-12-17.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>


// 将url转换为文件名
NSString *transferFileNameFromURL(NSString *url);


@interface UIImageView (Cache)

/**
 *	@brief	设置图片路径和网址（不全为空）
 *
 *	@param 	filePath 	缓存图片保存路径
 *	@param 	picUrl 	图片下载地址
 */
- (void)loadImageFromCachePath:(NSString *)filePath orPicUrl:(NSString *)picUrl;

@end
