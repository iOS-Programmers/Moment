//
//  FindMomentViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "FindMomentViewController.h"
#import "FindMomentCell.h"
#import "FindDetailViewController.h"

#import "MomentListHttp.h"
#import "MomentInfoHttp.h"
#import "MWPhotoBrowser.h"

@interface FindMomentViewController () <MWPhotoBrowserDelegate>

@property (strong, nonatomic) MomentListHttp *momentHttp;
@property (strong, nonatomic) MomentInfoHttp *momentInfoHttp;

//装图片的数组
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation FindMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发现瞬间";
    self.momentHttp = [[MomentListHttp alloc] init];
    self.momentInfoHttp = [[MomentInfoHttp alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    
    self.tableView.rowHeight = 118;
    
    [self requestMomentList];
    
    //添加下拉刷新
    self.canPullRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLCOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMomentList
{
    self.momentHttp.parameter.fid = @"0";
    self.momentHttp.parameter.pagesize = @"10";
    
    
    [self showLoadingWithText:MT_LOADING];
    __weak FindMomentViewController *weak_self = self;
    [self.momentHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        [weak_self.header endRefreshing];
        if (weak_self.momentHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self updateMomentListWithInfo:weak_self.momentHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.momentHttp.erorMessage];
        };
    }failedBlock:^{
        [weak_self hideLoading];
        [weak_self.header endRefreshing];
        
        if (![LXUtils networkDetect])
        {
            [weak_self showWithText:MT_CHECKNET];
        }
        else
        {
            //统统归纳为服务器出错
            [weak_self showWithText:MT_NETWRONG];
        };
    }];
}

/**
 *  更新界面信息
 *
 *  @param infoArray 列表数组
 */
- (void)updateMomentListWithInfo:(NSMutableArray *)infoArray
{
    if (!FBIsEmpty(infoArray)) {
        self.dataSource = infoArray;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FindMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"FindMomentCell" owner:self options:nil];
        for (id oneObject in cellNib)
        {
            if ([oneObject isKindOfClass:[FindMomentCell class]])
            {
                cell = (FindMomentCell *)oneObject;
            }
        }
    }
    
    MomentDetail *detail = (MomentDetail *)self.dataSource[indexPath.row];
    
    [cell updateMomentCellWithInfo:detail];
    
    return cell;
}


- (void)requestMomentInfoWithId:(NSString *)storyId
{
    self.momentInfoHttp.parameter.tid = storyId;
    
    [self showLoadingWithText:MT_LOADING];
    __weak FindMomentViewController *weak_self = self;
    [self.momentInfoHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.momentInfoHttp.isValid)
        {
            /**
             *  去单个详情页
             */
            [weak_self gotoMomentDetailView:weak_self.momentInfoHttp.resultModel];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.momentInfoHttp.erorMessage];
        };
    }failedBlock:^{
        [weak_self hideLoading];
        
        if (![LXUtils networkDetect])
        {
            [weak_self showWithText:MT_CHECKNET];
        }
        else
        {
            //统统归纳为服务器出错
            [weak_self showWithText:MT_NETWRONG];
        };
    }];

}

- (void)gotoMomentDetailView:(MomentInfo *)info
{
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i = 0; i < [info.pictureurls count]; i ++) {
        MWPhoto *photo;
        
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,info.pictureurls[i]]]];
        photo.caption = info.content;
        [photos addObject:photo];
    }

    self.photos = photos;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    //    browser.displayActionButton = displayActionButton;
    //    browser.displayNavArrows = displayNavArrows;
    //    browser.displaySelectionButtons = displaySelectionButtons;
    //    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    //    browser.enableGrid = enableGrid;
    //    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MomentDetail *detail = (MomentDetail *)self.dataSource[indexPath.row];
    
    [self requestMomentInfoWithId:detail.tid];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

#pragma mark 上下拉刷新的Delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //上拉刷新时的操作
    if (self.header == refreshView)
    {
        [self requestMomentList];
    }
    //下拉加载时的操作
    else {
        
    }
}

@end
