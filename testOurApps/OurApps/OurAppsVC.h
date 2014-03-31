//
//  OurAppsVC.h
//  
//
//  Created by yangjh on 14-3-31.
//
//

#import <UIKit/UIKit.h>
#import "AppInfoItem.h"

@protocol OurAppsVCDelegate;

@interface OurAppsVC : UIViewController

@property (nonatomic, copy) NSString *artistID;
@property (nonatomic, assign) id <OurAppsVCDelegate> delegate;

@end


@protocol OurAppsVCDelegate <NSObject>

// 关闭
- (void)ourAppsVCClose:(OurAppsVC *)ourAppsVC;

// 应用项被点击
- (void)ourAppsVC:(OurAppsVC *)ourAppsVC clickAppItem:(AppInfoItem *)appInfoItem;

@end
