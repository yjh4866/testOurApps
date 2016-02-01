//
//  AppItemCell.m
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import "AppItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+NBL.h"
#import "AppInfoItem.h"

#define Size_AppIcon            75.0f
#define Top_AppIcon             ((Height_AppItemCell-Size_AppIcon)/2.0f)
#define Left_AppIcon            Top_AppIcon
#define Frame_AppIcon           CGRectMake(Left_AppIcon,Top_AppIcon,Size_AppIcon,Size_AppIcon)
#define Left_AppDetailItem      (Left_AppIcon+Size_AppIcon+Left_AppIcon)
#define Height_AppDetailItem    (Size_AppIcon/4.0f)

@interface AppItemCell ()
@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelVersion;
@property (nonatomic, strong) UILabel *labelReleaseDate;
@property (nonatomic, strong) UILabel *labelPrice;
@end

@implementation AppItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 应用图标
        self.imageViewIcon = [[UIImageView alloc] initWithFrame:Frame_AppIcon];
        self.imageViewIcon.backgroundColor = [UIColor lightGrayColor];
		self.imageViewIcon.layer.masksToBounds = YES;
		self.imageViewIcon.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:self.imageViewIcon];
        // 应用名称
        CGRect frameDetailItem = CGRectMake(Left_AppDetailItem, Top_AppIcon, self.bounds.size.width-Left_AppDetailItem-Left_AppIcon, Height_AppDetailItem);
        self.labelName = [[UILabel alloc] initWithFrame:frameDetailItem];
        self.labelName.backgroundColor = [UIColor clearColor];
        [self addSubview:self.labelName];
        // 应用版本
        frameDetailItem.origin.y += Height_AppDetailItem;
        self.labelVersion = [[UILabel alloc] initWithFrame:frameDetailItem];
        self.labelVersion.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelVersion];
        // 当前版本发布日期
        frameDetailItem.origin.y += Height_AppDetailItem;
        self.labelReleaseDate = [[UILabel alloc] initWithFrame:frameDetailItem];
        self.labelReleaseDate.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelReleaseDate];
        // 价格
        frameDetailItem.origin.y += Height_AppDetailItem;
        self.labelPrice = [[UILabel alloc] initWithFrame:frameDetailItem];
        self.labelPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelPrice];
        
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
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.appInfo"]) {
        self.imageViewIcon.image = nil;
        [self.imageViewIcon loadImageFromCachePath:[self.appInfo iconPath]
                                          orPicUrl:self.appInfo.iconUrl];
        self.labelName.text = self.appInfo.appName;
        self.labelVersion.text = self.appInfo.appVersion;
        self.labelReleaseDate.text = self.appInfo.releaseDate;
        self.labelPrice.text = self.appInfo.price;
    }
}

@end
