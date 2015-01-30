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
#import "SupportStoryHttp.h"
//#import "MWPhotoBrowser.h"

@interface FindMomentViewController ()

@property (strong, nonatomic) MomentListHttp *momentHttp;
@property (strong, nonatomic) MomentInfoHttp *momentInfoHttp;
@property (strong, nonatomic) SupportStoryHttp *supportHttp;

//装图片的数组
@property (nonatomic, strong) NSMutableArray *photos;

@property (strong, nonatomic) UIButton *titleBtn;

@property (strong, nonatomic) IBOutlet UIView *storyTypeView;

- (IBAction)onStoryTypeBtnClick:(UIButton *)sender;

@end

@implementation FindMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发现瞬间";
    self.momentHttp = [[MomentListHttp alloc] init];
    self.momentInfoHttp = [[MomentInfoHttp alloc] init];
    self.supportHttp = [[SupportStoryHttp alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    
    self.momentHttp.parameter.fid = @"0";
    
    self.tableView.rowHeight = 118;
    
    [self requestMomentList];
    
    //添加下拉刷新
    self.canPullRefresh = YES;
    
    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleBtn.frame = CGRectMake(0, 0, 300, 44);
    self.titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleBtn.titleLabel.textColor = [UIColor whiteColor];
    self.titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleBtn setTitle:@"发现瞬间" forState:UIControlStateNormal];
    [self.titleBtn addTarget:self action:@selector(onTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.storyTypeView.layer.borderWidth = 0.5;
    self.storyTypeView.layer.cornerRadius = 3;
    self.storyTypeView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self.storyTypeView frameSetPoint:CGPointMake(([LXUtils GetScreeWidth]/2 - CGRectGetWidth(self.storyTypeView.frame)/2), 0)];
    self.storyTypeView.hidden = YES;
    [self.view addSubview:self.storyTypeView];

    self.navigationItem.titleView = self.titleBtn;
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

#pragma mark - Request

- (void)requestMomentList
{
    self.momentHttp.parameter.pagesize = @"20";
    
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

/**
 *  故事点赞
 *
 *  @param tid 故事id
 */
- (void)requestSupportStory:(NSString *)tid
{
    if (FBIsEmpty(tid)) {
        [self showWithText:@"故事id有误！"];
        return;
    }
    
    self.supportHttp.parameter.tid = tid;
    
    [self showLoadingWithText:MT_LOADING];
    __weak FindMomentViewController *weak_self = self;
    [self.supportHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];

        if (weak_self.supportHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self requestMomentList];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.supportHttp.erorMessage];
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


#pragma mark - IBAciton

- (IBAction)onStoryTypeBtnClick:(UIButton *)sender {

    [UIView animateWithDuration:0.3 animations:^{
        [self.storyTypeView setHidden:YES];
    }];
    
    switch (sender.tag) {
        case 0:
        {
            //因为爱情
            self.momentHttp.parameter.fid = @"1";
        }
            break;
        case 1:
        {
            //青春梦想
            self.momentHttp.parameter.fid = @"2";
        }
            break;
        case 2:
        {
            //那些故事
            self.momentHttp.parameter.fid = @"3";
        }
            break;
        case 3:
        {
            //闪耀瞬间
            self.momentHttp.parameter.fid = @"4";
        }
            break;
            
        default:
            break;
    }
    
    [self.titleBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    [self requestMomentList];
}

/**
 *  点击标题事件
 */
- (void)onTitleBtnClick:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.storyTypeView setHidden:!self.storyTypeView.hidden];
    }];
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
    
    //点击喜欢
    cell.likeBtn.tag = indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(onLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)onLikeBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    MomentDetail *detail = (MomentDetail *)self.dataSource[btn.tag];

    [self requestSupportStory:detail.tid];
}


- (void)requestMomentInfoWithId:(MomentDetail *)detail
{
    if (FBIsEmpty(detail.tid)) {
        return;
    }

    self.momentInfoHttp.parameter.tid = detail.tid;
    
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
    FindDetailViewController *detailVC = [[FindDetailViewController alloc] init];

    detailVC.momentInfo = info;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MomentDetail *detail = (MomentDetail *)self.dataSource[indexPath.row];
    
    [self requestMomentInfoWithId:detail];
}

#pragma mark - MWPhotoBrowserDelegate

//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return _photos.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    if (index < _photos.count)
//        return [_photos objectAtIndex:index];
//    return nil;
//}

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
