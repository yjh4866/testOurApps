//
//  AppItemCell.m
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import "AppItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Cache.h"
#import "AppInfoItem.h"

#define Size_AppIcon            75.0f
#define Top_AppIcon             ((Height_AppItemCell-Size_AppIcon)/2.0f)
#define Left_AppIcon            Top_AppIcon
#define Frame_AppIcon           CGRectMake(Left_AppIcon,Top_AppIcon,Size_AppIcon,Size_AppIcon)
#define Left_AppDetailItem      (Left_AppIcon+Size_AppIcon+Left_AppIcon)
#define Height_AppDetailItem    (Size_AppIcon/4.0f)

@interface AppItemCell () {
    
    UIImageView *_imageViewIcon;
    UILabel *_labelName;
    UILabel *_labelVersion;
    UILabel *_labelReleaseDate;
    UILabel *_labelPrice;
}

@end

@implementation AppItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 应用图标
        _imageViewIcon = [[UIImageView alloc] initWithFrame:Frame_AppIcon];
        _imageViewIcon.backgroundColor = [UIColor lightGrayColor];
		_imageViewIcon.layer.masksToBounds = YES;
		_imageViewIcon.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:_imageViewIcon];
        // 应用名称
        CGRect frameDetailItem = CGRectMake(Left_AppDetailItem, Top_AppIcon, self.bounds.size.width-Left_AppDetailItem-Left_AppIcon, Height_AppDetailItem);
        _labelName = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelName.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelName];
        // 应用版本
        frameDetailItem.origin.y += Height_AppDetailItem;
        _labelVersion = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelVersion.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_labelVersion];
        // 当前版本发布日期
        frameDetailItem.origin.y += Height_AppDetailItem;
        _labelReleaseDate = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelReleaseDate.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_labelReleaseDate];
        // 价格
        frameDetailItem.origin.y += Height_AppDetailItem;
        _labelPrice = [[UILabel alloc] initWithFrame:frameDetailItem];
        _labelPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_labelPrice];
        
        [self addObserver:self forKeyPath:@"self.appInfo"
                  options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.appInfo"];
    //
    [_imageViewIcon release];
    [_labelName release];
    [_labelVersion release];
    [_labelReleaseDate release];
    [_labelPrice release];
    
    [super dealloc];
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.appInfo"]) {
        [_imageViewIcon loadImageFromCachePath:[self.appInfo iconPath] orPicUrl:self.appInfo.iconUrl];
        _labelName.text = self.appInfo.appName;
        _labelVersion.text = self.appInfo.appVersion;
        _labelReleaseDate.text = self.appInfo.releaseDate;
        _labelPrice.text = self.appInfo.price;
    }
}

@end
