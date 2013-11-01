//
//  DataAppItem.h
//  
//
//  Created by yangjianhong-MAC on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataAppItem : NSObject

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appURL;
@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, assign) CGSize appIconSize;
@property (nonatomic, copy) NSString *appIconURL;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appGenre;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appReleasedDate;
@property (nonatomic, copy) NSString *appPrice;

@end
