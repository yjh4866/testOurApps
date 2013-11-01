//
//  TableViewAppItemCell.m
//  
//
//  Created by Jianhong Yang on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableViewAppItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+MBProgressHUD.h"
#import "DataAppItem.h"


#define     WIDTH_APPICON               75.0f
#define     HEIGHT_APPICON              75.0f
#define     TOP_APPICON                 ((HEIGHT_APPITEMCELL-HEIGHT_APPICON)/2.0f)
#define     LEFT_APPICON                TOP_APPICON
#define     FRAME_APPICON               CGRectMake(LEFT_APPICON,TOP_APPICON,WIDTH_APPICON,HEIGHT_APPICON)
#define     LEFT_APPDETAILITEM          (LEFT_APPICON+WIDTH_APPICON+LEFT_APPICON)
#define     HEIGHT_APPDETAILITEM        (HEIGHT_APPICON/4.0f)
#define     SIZE_DETAILITEMFONT         14.0f

@interface TableViewAppItemCell () {

    //
    UIImageView *_viewAppIcon;
    UILabel *_labelAppName;
    UILabel *_labelAppVersion;
    UILabel *_labelAppReleasedDate;
    UILabel *_labelAppPrice;
}

@end


@implementation TableViewAppItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 应用图标
        _viewAppIcon = [[UIImageView alloc] initWithFrame:FRAME_APPICON];
		_viewAppIcon.layer.masksToBounds = YES;
		_viewAppIcon.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:_viewAppIcon];
        _viewAppIcon.backgroundColor = [UIColor lightGrayColor];
        [_viewAppIcon showActivity];
        // 应用名称
        CGFloat width = self.bounds.size.width;
        CGRect frameDetailItem = CGRectMake(LEFT_APPDETAILITEM, TOP_APPICON, 
                                            width-LEFT_APPICON-LEFT_APPDETAILITEM, 
                                            HEIGHT_APPDETAILITEM);
        _labelAppName = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelAppName.backgroundColor = [UIColor clearColor];
        _labelAppName.font = [UIFont systemFontOfSize:SIZE_DETAILITEMFONT];
        [self.contentView addSubview:_labelAppName];
        // 应用版本
        frameDetailItem.origin.y += HEIGHT_APPDETAILITEM;
        _labelAppVersion = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelAppVersion.backgroundColor = [UIColor clearColor];
        _labelAppVersion.font = [UIFont systemFontOfSize:SIZE_DETAILITEMFONT];
        [self.contentView addSubview:_labelAppVersion];
        // 当前版本发布日期
        frameDetailItem.origin.y += HEIGHT_APPDETAILITEM;
        _labelAppReleasedDate = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelAppReleasedDate.backgroundColor = [UIColor clearColor];
        _labelAppReleasedDate.font = [UIFont systemFontOfSize:SIZE_DETAILITEMFONT];
        [self.contentView addSubview:_labelAppReleasedDate];
        // 价格
        frameDetailItem.origin.y += HEIGHT_APPDETAILITEM;
        _labelAppPrice = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelAppPrice.backgroundColor = [UIColor clearColor];
        _labelAppPrice.font = [UIFont systemFontOfSize:SIZE_DETAILITEMFONT];
        [self.contentView addSubview:_labelAppPrice];
        
        [self addObserver:self forKeyPath:@"self.dataAppItem"
                  options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"self.appIcon"
                  options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    //只需调整应用名称标签的尺寸即可
    CGFloat width = self.bounds.size.width;
    CGRect frameDetailItem = CGRectMake(LEFT_APPDETAILITEM, TOP_APPICON, 
                                        width-LEFT_APPICON-LEFT_APPDETAILITEM, 
                                        HEIGHT_APPDETAILITEM);
    _labelAppName.frame = frameDetailItem;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.dataAppItem"];
    [self removeObserver:self forKeyPath:@"self.appIcon"];
    //
    self.dataAppItem = nil;
    self.appIcon = nil;
    //
    [_viewAppIcon release];
    [_labelAppName release];
    [_labelAppVersion release];
    [_labelAppReleasedDate release];
    [_labelAppPrice release];
    
    [super dealloc];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.dataAppItem"]) {
        //
        self.appIcon = self.dataAppItem.appIcon;
        _labelAppName.text = self.dataAppItem.appName;
        _labelAppVersion.text = self.dataAppItem.appVersion;
        _labelAppReleasedDate.text = self.dataAppItem.appReleasedDate;
        if (self.dataAppItem.appPrice.length > 0) {
            _labelAppPrice.text = self.dataAppItem.appPrice;
        }
        else {
            _labelAppPrice.text = @"Free";
        }
    }
    else if ([keyPath isEqualToString:@"self.appIcon"]) {
        _viewAppIcon.image = self.appIcon;
        //
        [_viewAppIcon hideActivity];
    }
}

@end
