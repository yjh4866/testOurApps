//
//  AppItemCell.h
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import <UIKit/UIKit.h>


#define     Height_AppItemCell          120.0f

@class AppInfoItem;

@interface AppItemCell : UITableViewCell

@property (nonatomic, retain) AppInfoItem *appInfo;

@end
