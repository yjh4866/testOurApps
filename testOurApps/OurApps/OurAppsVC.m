//
//  OurAppsVC.m
//  
//
//  Created by yangjh on 14-3-31.
//
//

#import "OurAppsVC.h"
#import "AppItemCell.h"
#import "UIView+MBProgressHUD.h"
#import "AppManager.h"
#import "UIScrollView+PullRefresh.h"


@interface OurAppsVC () <UITableViewDataSource, UITableViewDelegate, AppManagerDelegate> {
    
    UITableView *_tableViewApp;
    
    // 应用管理
    AppManager *_appManager;
    //
    NSMutableArray *_marriPhoneApp;
    NSMutableArray *_marriPadApp;
}

@property (nonatomic, assign) BOOL iPhoneAppList;

@end

@implementation OurAppsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.iPhoneAppList = YES;
        //
        _marriPhoneApp = [[NSMutableArray alloc] initWithCapacity:5];
        _marriPadApp = [[NSMutableArray alloc] initWithCapacity:5];
        // 应用管理
        _appManager = [[AppManager alloc] init];
        _appManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"产品列表";
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 当前为导航栏根视图控制器，另外添加一个关闭按钮
    if (self.navigationController.viewControllers[0] == self) {
        UIBarButtonItem *itemClose = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(clickClose)];
        self.navigationItem.leftBarButtonItem = itemClose;
        [itemClose release];
    }
    
    //
    if (nil == _tableViewApp) {
        _tableViewApp = [[UITableView alloc] initWithFrame:self.view.bounds
                                                     style:UITableViewStylePlain];
        _tableViewApp.dataSource = self;
        _tableViewApp.delegate = self;
    }
    [self.view addSubview:_tableViewApp];
    
    // 如果是iPad，也要获取iPad版本
    NSRange range = [[UIDevice currentDevice].model rangeOfString:@"iPad"];
    if (NSNotFound != range.location) {
        //iPhone、iPad列表切换按钮放在导航栏上
        UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"iPad", @"iPhone"]];
        segCtrl.frame = CGRectMake(0, 0, 165, 32);
        segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
        [segCtrl addTarget:self action:@selector(clickSwitch:)
          forControlEvents:UIControlEventValueChanged];
        segCtrl.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segCtrl;
        [segCtrl release];
        //
        self.iPhoneAppList = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _tableViewApp.frame = self.view.bounds;
    // viewDidDisappear处会设置为nil，故需要在设置下拉刷新
    [_tableViewApp showHeaderRefresh];
    [_tableViewApp setStartBlockOfHeaderRefresh:^(UIScrollView *scrollView) {
        [self.view showActivityWithText:@"加载中..."];
        [_appManager getAppListOf:self.artistID];
    }];
    [_tableViewApp startHeaderRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _tableViewApp.frame = self.view.bounds;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    _tableViewApp.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 必须设置为nil才能释放当前类
    [_tableViewApp setStartBlockOfHeaderRefresh:nil];
    [_tableViewApp removeHeaderRefresh];
}

- (void)dealloc
{
    //
    self.artistID = nil;
    //
    [_tableViewApp release];
    //
    _appManager.delegate = nil;
    [_appManager release];
    [_marriPhoneApp release];
    [_marriPadApp release];
    
    [super dealloc];
}


#pragma mark - ClickEvent

- (void)clickClose
{
    [self.delegate ourAppsVCClose:self];
}

- (void)clickSwitch:(UISegmentedControl *)segCtrl
{
    // 只有iPad才会调用到这里，第一项是iPad，最后一项是iPhone
    self.iPhoneAppList = (segCtrl.numberOfSegments-1)==segCtrl.selectedSegmentIndex;
    [_tableViewApp reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.iPhoneAppList?_marriPhoneApp.count:_marriPadApp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AppItemCell";
    AppItemCell *cellAppItem = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cellAppItem) {
        cellAppItem = [[[AppItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //
    NSArray *arrAppInfo = self.iPhoneAppList?_marriPhoneApp:_marriPadApp;
    if (indexPath.row < arrAppInfo.count) {
        cellAppItem.appInfo = arrAppInfo[indexPath.row];
    }
    
    return cellAppItem;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Height_AppItemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSArray *arrAppInfo = self.iPhoneAppList?_marriPhoneApp:_marriPadApp;
    if (indexPath.row < arrAppInfo.count) {
        [self.delegate ourAppsVC:self clickAppItem:arrAppInfo[indexPath.row]];
    }
}


#pragma mark - AppManagerDelegate

// 获取应用列表失败
- (void)appManager:(AppManager *)appManager appListFailure:(NSError *)error
              with:(NSString *)artistID
{
    [_tableViewApp endHeaderRefresh];
    [self.view hideActivity];
    [self.view showTextNoActivity:error.localizedDescription timeLength:1.0f];
}

// 获取到iPhone应用列表和iPad应用列表
- (void)appManager:(AppManager *)appManager appListSuccessWith:(NSString *)artistID
 withiPhoneAppList:(NSArray *)arriPhoneApp andiPadApplist:(NSArray *)arriPadApp
{
    [_tableViewApp endHeaderRefresh];
    [self.view hideActivity];
    [_marriPhoneApp setArray:arriPhoneApp];
    [_marriPadApp setArray:arriPadApp];
    //
    [_tableViewApp reloadData];
}

@end
