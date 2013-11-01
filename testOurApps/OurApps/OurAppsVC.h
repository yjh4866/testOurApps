//
//  OurAppsVC.h
//  
//
//  Created by 建红 杨 on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAppItem.h"

@protocol OurAppsVCDelegate;

@interface OurAppsVC : UIViewController

@property (nonatomic, copy) NSString *appleID;
@property (nonatomic, assign) id <OurAppsVCDelegate> delegate;

@end



@protocol OurAppsVCDelegate <NSObject>

@optional

// 返回
- (void)ourAppsVCBack:(OurAppsVC *)ourAppsVC;

// 应用项被点击
- (void)ourAppsVC:(OurAppsVC *)ourAppsVC clickAppItem:(DataAppItem *)dataAppItem;

@end
