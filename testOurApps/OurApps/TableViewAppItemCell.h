//
//  TableViewAppItemCell.h
//  
//
//  Created by Jianhong Yang on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define     HEIGHT_APPITEMCELL          100.0f

@class DataAppItem;

@interface TableViewAppItemCell : UITableViewCell

@property (nonatomic, retain) DataAppItem *dataAppItem;
@property (nonatomic, retain) UIImage *appIcon;

@end
