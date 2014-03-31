//
//  AppManager.h
//  
//
//  Created by yangjh on 14-3-30.
//
//

#import <Foundation/Foundation.h>


@protocol AppManagerDelegate;

@interface AppManager : NSObject

@property (nonatomic, assign) id <AppManagerDelegate> delegate;

// 获取指定开发者ID的应用列表
- (void)getAppListOf:(NSString *)artistID;

@end


@protocol AppManagerDelegate <NSObject>

// 获取应用列表失败
- (void)appManager:(AppManager *)appManager appListFailure:(NSError *)error
              with:(NSString *)artistID;

// 获取到iPhone应用列表和iPad应用列表
- (void)appManager:(AppManager *)appManager appListSuccessWith:(NSString *)artistID
 withiPhoneAppList:(NSArray *)arriPhoneApp andiPadApplist:(NSArray *)arriPadApp;

@end
