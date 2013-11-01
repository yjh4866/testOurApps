//
//  DataAppItem.m
//  
//
//  Created by yangjianhong-MAC on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataAppItem.h"

@implementation DataAppItem

- (void)dealloc
{
    self.appID = nil;
    self.appURL = nil;
    self.appIcon = nil;
    self.appIconURL = nil;
    self.appName = nil;
    self.appGenre = nil;
    self.appVersion = nil;
    self.appReleasedDate = nil;
    self.appPrice = nil;
    
    [super dealloc];
}

@end
