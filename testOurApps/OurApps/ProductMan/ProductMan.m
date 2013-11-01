//
//  ProductMan.m
//  
//
//  Created by 建红 杨 on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProductMan.h"
#import "XMLParser.h"


//网络请求类型
#define     NetRequestProductType_None          0
#define     NetRequestProductType_AppList       1
#define     NetRequestProductType_AppIcon       2

//网络请求类型的参数
#define     NetRequestProductParam_None             0
#define     NetRequestProductParam_AppListiPhone    1
#define     NetRequestProductParam_AppListiPad      2


#pragma mark - ProductMan

@interface ProductMan () <HTTPConnectionDelegate> {

    //
    HTTPConnection *_httpConnect;
}
@end


@implementation ProductMan

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initilization.
        _httpConnect = [[HTTPConnection alloc] init];
        _httpConnect.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    _httpConnect.delegate = nil;
    [_httpConnect release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Public

// 获取我们的iPhone应用列表
- (void)getOuriPhoneAppList:(NSString *)appleID
{
    NSLog(@"获取我们iPhone应用列表");
    // 
    NSString *strURL = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewArtistSeeAll?ids=%@&softwareType=iPhone&dkId=11", appleID];
    // 以iTunes的名义发送请求
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mRequest setValue:@"iTunes/10.6.3 AppleWebKit/534.57.2" forHTTPHeaderField:@"User-Agent"];
    [mRequest setValue:@"143465-19,12" forHTTPHeaderField:@"X-Apple-Store-Front"];
    //[mRequest setValue:@"28800" forHTTPHeaderField:@"X-Apple-Tz"];
    // 其他参数
    NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:NetRequestProductType_AppList], @"type", 
                              [NSNumber numberWithLongLong:NetRequestProductParam_AppListiPhone], @"listType", nil];
    // 获取iPhone应用列表
    [_httpConnect requestWebDataWithRequest:mRequest andParam:dicParam
                                      cache:YES priority:YES];
    [mRequest release];
    [dicParam release];
}

// 获取我们的iPad应用列表
- (void)getOuriPadAppList:(NSString *)appleID
{
    //@"http://itunes.apple.com/artist/cobbler/id441076723";
    //@"http://itunes.apple.com/artist/cobbler/id441076723?l=zh";
    
    NSLog(@"获取我们的iPad应用列表");
    // 
    NSString *strURL = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewArtistSeeAll?ids=%@&softwareType=iPad&dkId=11", appleID];
    // 以iTunes的名义发送请求
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mRequest setValue:@"iTunes/10.6.3 AppleWebKit/534.57.2" forHTTPHeaderField:@"User-Agent"];
    [mRequest setValue:@"143465-19,12" forHTTPHeaderField:@"X-Apple-Store-Front"];
    //[mRequest setValue:@"28800" forHTTPHeaderField:@"X-Apple-Tz"];
    // 其他参数
    NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:NetRequestProductType_AppList], @"type", 
                              [NSNumber numberWithLongLong:NetRequestProductParam_AppListiPad], @"listType", nil];
    // 获取iPhone应用列表
    [_httpConnect requestWebDataWithRequest:mRequest andParam:dicParam
                                      cache:YES priority:NO];
    [mRequest release];
    [dicParam release];
}

// 下载应用图标
- (void)downloadAppIcon:(NSString *)appID with:(NSString *)strAppIconURL
{
    NSLog(@"下载应用图标:%@", appID);
    //
    NSURL *url = [NSURL URLWithString:strAppIconURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSDictionary *dicParam = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:NetRequestProductType_AppIcon], @"type", 
                              appID, @"appID", nil];
    // 下载应用图标
    [_httpConnect requestWebDataWithURL:strAppIconURL andParam:dicParam
                                  cache:YES priority:NO];
    [request release];
    [dicParam release];
}


#pragma mark - HTTPConnection

// 网络数据下载失败
- (void)httpConnect:(HTTPConnection *)httpConnect error:(NSError *)error with:(NSDictionary *)dicParam
{
    //网络请求类型
    NSUInteger requesttype = [[dicParam objectForKey:@"type"] intValue];
    //
    switch (requesttype) {
            //应用列表
        case NetRequestProductType_AppList:
        {
            //网络请求类型参数
            int listType = [[dicParam objectForKey:@"listType"] longLongValue];
            switch (listType) {
                    //iPhone应用列表
                case NetRequestProductParam_AppListiPhone:
                {
                    if ([self.delegate respondsToSelector:@selector(productManiPhoneAppListFailure:)])
                    {
                        [self.delegate productManiPhoneAppListFailure:self];
                    }
                }
                    break;
                    //iPad应用列表
                case NetRequestProductParam_AppListiPad:
                {
                    if ([self.delegate respondsToSelector:@selector(productManiPadAppListFailure:)])
                    {
                        [self.delegate productManiPadAppListFailure:self];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
            //应用图标
        case NetRequestProductType_AppIcon:
        {
            NSString *appID = [dicParam objectForKey:@"appID"];
            if ([self.delegate respondsToSelector:@selector(productMan:downloadAppIconFailureOf:)]) {
                [self.delegate productMan:self downloadAppIconFailureOf:appID];
            }
        }
            break;
        default:
            break;
    }
}

// 网络数据下载完成
- (void)httpConnect:(HTTPConnection *)httpConnect finish:(NSData *)data with:(NSDictionary *)dicParam
{
    //网络请求类型
    NSUInteger requesttype = [[dicParam objectForKey:@"type"] intValue];
    //
    switch (requesttype) {
            //应用列表
        case NetRequestProductType_AppList:
        {
            //处理数据包
            NSString *strWebData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //网络请求类型参数
            int listType = [[dicParam objectForKey:@"listType"] longLongValue];
            switch (listType) {
                    //iPhone应用列表
                case NetRequestProductParam_AppListiPhone:
                {
                    //应用列表数据的范围
                    NSRange rangeAppList = [self analysisWebDataOfAppList:strWebData];
                    //iPhone应用列表数据的分析
                    NSString *strAppList = [strWebData substringWithRange:rangeAppList];
                    NSMutableArray *marrayAppList = [[NSMutableArray alloc] initWithCapacity:5];
                    [self analysisAppItemFromAppList:strAppList saveInto:marrayAppList];
                    //
                    if ([self.delegate respondsToSelector:@selector(productMan:iPhoneAppListSuccess:)]) {
                        [self.delegate productMan:self iPhoneAppListSuccess:marrayAppList];
                    }
                    [marrayAppList release];
                }
                    break;
                    //iPad应用列表
                case NetRequestProductParam_AppListiPad:
                {
                    NSRange rangeAppList = [self analysisWebDataOfAppList:strWebData];
                    //iPad应用列表数据的分析
                    NSString *strAppList = [strWebData substringWithRange:rangeAppList];
                    NSMutableArray *marrayAppList = [[NSMutableArray alloc] initWithCapacity:5];
                    [self analysisAppItemFromAppList:strAppList saveInto:marrayAppList];
                    //
                    if ([self.delegate respondsToSelector:@selector(productMan:iPadAppListSuccess:)]) {
                        [self.delegate productMan:self iPadAppListSuccess:marrayAppList];
                    }
                    [marrayAppList release];
                }
                    break;
                default:
                    break;
            }
            [strWebData release];
        }
            break;
            //应用图标
        case NetRequestProductType_AppIcon:
        {
            NSString *appID = [dicParam objectForKey:@"appID"];
            UIImage *imageAppIcon = [[UIImage alloc] initWithData:data];
            if ([self.delegate respondsToSelector:@selector(productMan:downloadAppIconSuccess:of:)]) {
                [self.delegate productMan:self downloadAppIconSuccess:imageAppIcon of:appID];
            }
            [imageAppIcon release];
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark Private

//从指定位置开始分析给定的XML数据，返回最近的完整结点的范围
- (NSRange)analysisXML:(NSString *)strXML from:(NSUInteger)start
{
    //完整的最短结点长度为4
    if (strXML.length < 4) {
        return NSMakeRange(0, 0);
    }
    
    NSRange rangeXMLNode = NSMakeRange(start, 0);
    //先找到最近的结点的起点
    while (YES) {
        unichar ch = [strXML characterAtIndex:rangeXMLNode.location];
        //找到'<'
        if (ch == '<') {
            //下一个字符不是'/'
            if (strXML.length == rangeXMLNode.location+2) {
                return NSMakeRange(0, 0);
            }
            unichar ch_next = [strXML characterAtIndex:rangeXMLNode.location+1];
            if (ch_next != '/') {
                break;
            }
        }
        rangeXMLNode.location++;
        //到字符串结尾依然没有找到
        if (rangeXMLNode.location+1 == strXML.length) {
            return NSMakeRange(0, 0);
        }
    }
    //找结束标志
    rangeXMLNode.length = 1;
    NSUInteger number = 1;
    while (number > 0) {
        //到字符串结尾依然没有找到
        if (rangeXMLNode.location+rangeXMLNode.length > strXML.length) {
            return NSMakeRange(0, 0);
        }
        unichar ch = [strXML characterAtIndex:rangeXMLNode.location+rangeXMLNode.length];
        switch (ch) {
                //
            case '/':
            {
                rangeXMLNode.length++;
                //到字符串结尾依然没有找到
                if (rangeXMLNode.location+rangeXMLNode.length > strXML.length) {
                    return NSMakeRange(0, 0);
                }
                //"/>"
                if ([strXML characterAtIndex:rangeXMLNode.location+rangeXMLNode.length] == '>') {
                    number--;
                }
            }
                break;
                //
            case '<':
            {
                rangeXMLNode.length++;
                //到字符串结尾依然没有找到
                if (rangeXMLNode.location+rangeXMLNode.length > strXML.length) {
                    return NSMakeRange(0, 0);
                }
                //"</"
                if ([strXML characterAtIndex:rangeXMLNode.location+rangeXMLNode.length] == '/') {
                    number--;
                }
                //"<"
                else {
                    number++;
                }
            }
                break;
            default:
                break;
        }
        rangeXMLNode.length++;
    }
    //向后到xml结点结尾处
    while ([strXML characterAtIndex:rangeXMLNode.location+rangeXMLNode.length] != '>') {
        rangeXMLNode.length++;
        //到字符串结尾依然没有找到
        if (rangeXMLNode.location+rangeXMLNode.length > strXML.length) {
            return NSMakeRange(0, 0);
        }
    }
    rangeXMLNode.length++;
    //到字符串结尾依然没有找到
    if (rangeXMLNode.location+rangeXMLNode.length > strXML.length) {
        return NSMakeRange(0, 0);
    }
    return rangeXMLNode;
}

//分析应用列表数据的范围
- (NSRange)analysisWebDataOfAppList:(NSString *)strWebData
{
    //<div class="content-and-controls">
    //<div class="paginated-container">
    //提取所有应用的数据
    //找到应用列表的起始位置
    NSRange rangeAppList = [strWebData rangeOfString:@"adam-id"];
    if (rangeAppList.location != NSNotFound) {
        while ([strWebData characterAtIndex:rangeAppList.location] != '<') {
            rangeAppList.location--;
        }
        //
        rangeAppList.location--;
        while ([strWebData characterAtIndex:rangeAppList.location] != '<') {
            rangeAppList.location--;
        }
    }
    else {
        return NSMakeRange(0, 0);
    }
    //返回应用列表数据的范围
    return [self analysisXML:strWebData from:rangeAppList.location];
}

//分析应用列表数据 
- (void)analysisAppItemFromAppList:(NSString *)strAppList saveInto:(NSMutableArray *)marrayAppList
{
    strAppList = [strAppList stringByReplacingOccurrencesOfString:@"&yen;" withString:@"￥"];
    NSRange rangeAppItem = [self analysisXML:strAppList from:1];
    //
    while (rangeAppItem.location > 0) {
        //应用数据的字符串
        NSString *strAppItem = [strAppList substringWithRange:rangeAppItem];
        //识别XML结点
        XMLNode *nodeAppItem = [strAppItem xmlNodeWithEncoding:NSUTF8StringEncoding];
        if (nodeAppItem) {
            DataAppItem *dataAppItem = [[DataAppItem alloc] init];
            //应用ID
            dataAppItem.appID = [nodeAppItem.nodeAttributesDict objectForKey:@"adam-id"];
            //其他数据
            NSArray *arrChild = [nodeAppItem children];
            if (arrChild.count > 1) {
                //图标数据
                XMLNode *nodeIcon = [arrChild objectAtIndex:0];
                [self analysisIconData:nodeIcon with:dataAppItem];
                //其他信息
                XMLNode *nodeDetail = [arrChild objectAtIndex:1];
                [self analysisDetailData:nodeDetail with:dataAppItem];
            }
            if (dataAppItem.appVersion.length == 0) {
                NSLog(@"");
            }
            //
            [marrayAppList addObject:dataAppItem];
            [dataAppItem release];
            
            [nodeAppItem clear];
        }
        //下一个结点
        rangeAppItem = [self analysisXML:strAppList from:rangeAppItem.location+rangeAppItem.length+1];
    }
}

//分析应用的图标信息
- (void)analysisIconData:(XMLNode *)nodeIcon with:(DataAppItem *)dataAppItem
{
    //应用的地址
    dataAppItem.appURL = [nodeIcon.nodeAttributesDict objectForKey:@"href"];
    //找到图标结点并获取相应的数据
    XMLNode *nodeImg = nil;
    NSMutableArray *marray = [[NSMutableArray alloc] initWithObjects:nodeIcon, nil];
    while (marray.count > 0) {
        XMLNode *node = [marray objectAtIndex:0];
        [marray removeObjectAtIndex:0];
        if ([node.nodeName compare:@"img"] == NSOrderedSame) {
            nodeImg = node;
            break;
        }
        //将子结点放到数组以备搜索
        NSArray *arrChild = node.children;
        for (XMLNode *nodeChild in arrChild) {
            [marray addObject:nodeChild];
        }
    }
    [marray release];
    
    //图标尺寸
    CGFloat width_icon = [[nodeImg.nodeAttributesDict objectForKey:@"width"] floatValue];
    CGFloat height_icon = [[nodeImg.nodeAttributesDict objectForKey:@"height"] floatValue];
    dataAppItem.appIconSize = CGSizeMake(width_icon, height_icon);
    //图标地址
    dataAppItem.appIconURL = [nodeImg.nodeAttributesDict objectForKey:@"src-swap"];
}

//分析应用的其他信息
- (void)analysisDetailData:(XMLNode *)nodeDetail with:(DataAppItem *)dataAppItem
{
    NSMutableArray *marray = [[NSMutableArray alloc] initWithObjects:nodeDetail, nil];
    while (marray.count > 0) {
        XMLNode *node = [marray objectAtIndex:0];
        [marray removeObjectAtIndex:0];
        //版本
        if ([node.nodeName isEqualToString:@"button"]) {
            dataAppItem.appVersion = [node.nodeAttributesDict objectForKey:@"bundle-short-version"];
        }
        //名称，类型，发布日期，价格
        NSString *strClass = [node.nodeAttributesDict objectForKey:@"class"];
        if ([strClass isEqualToString:@"name"]) {
            XMLNode *nodeLiA = [node.children objectAtIndex:0];
            dataAppItem.appName = nodeLiA.nodeValue;
        }
        else if ([strClass isEqualToString:@"genre"]) {
            dataAppItem.appGenre = node.nodeValue;
        }
        else if ([strClass isEqualToString:@"release-date"]) {
            dataAppItem.appReleasedDate = node.nodeValue;
        }
        else if ([strClass isEqualToString:@"price"]) {
            dataAppItem.appPrice = node.nodeValue;
        }
        //将子结点放到数组以备搜索
        NSArray *arrChild = node.children;
        for (XMLNode *nodeChild in arrChild) {
            [marray addObject:nodeChild];
        }
    }
    [marray release];
}

@end
