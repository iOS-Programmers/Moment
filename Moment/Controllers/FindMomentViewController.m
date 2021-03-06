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
#import "DelMomentZanHttp.h"

@interface FindMomentViewController ()

@property (strong, nonatomic) MomentListHttp *momentHttp;
@property (strong, nonatomic) MomentInfoHttp *momentInfoHttp;
@property (strong, nonatomic) SupportStoryHttp *supportHttp;
@property (strong, nonatomic) DelMomentZanHttp *delMomentHttp;

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIButton *titleBtn;

@property (strong, nonatomic) IBOutlet UIView *storyTypeView;

//标记当前是否在请求数据，请求完成后设置成No
@property (nonatomic) BOOL isRequest;

- (IBAction)onTitleBtnClick:(id)sender;

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
    self.delMomentHttp = [[DelMomentZanHttp alloc] init];
    
    self.isRequest = NO;
    
    self.momentHttp.parameter.fid = @"0";
    
    self.tableView.rowHeight = 118;
    
    
    //添加下拉刷新
    self.canPullRefresh = YES;
    
    self.titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleBtn setTitle:@"发现瞬间" forState:UIControlStateNormal];

    self.storyTypeView.layer.borderWidth = 0.5;
    self.storyTypeView.layer.cornerRadius = 3;
    self.storyTypeView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self.storyTypeView frameSetPoint:CGPointMake(([LXUtils GetScreeWidth]/2 - CGRectGetWidth(self.storyTypeView.frame)/2), 0)];
    self.storyTypeView.hidden = YES;
    [self.view addSubview:self.storyTypeView];

    self.navigationItem.titleView = self.titleView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMomentUI) name:MT_RefreshMomentUI object:nil];
    
    [self requestMomentList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLCOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshMomentUI
{
    [[MTAppDelegate shareappdelegate].rootTabBarController setSelectedIndex:0];
    [self.header beginRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)requestMomentList
{
    if (self.isRequest) {
        return;
    }
    self.isRequest  = YES;
    
    self.momentHttp.parameter.pagesize = @"100";
    
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
            
            weak_self.isRequest = NO;
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.momentHttp.erorMessage];
            
            weak_self.isRequest = NO;
        };
    }failedBlock:^{
        [weak_self hideLoading];
        [weak_self.header endRefreshing];
        
        weak_self.isRequest = NO;
        
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
- (void)requestSupportStory:(NSString *)tid btnTag:(NSInteger)tag
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
            //请求成功后设置Btn的状态
            NSIndexPath *index1 =  [NSIndexPath indexPathForItem:tag inSection:0];
            FindMomentCell *cell =  (FindMomentCell *)[self.tableView cellForRowAtIndexPath:index1];
            cell.likeBtn.selected = YES;
            
            cell.recommendNmLabel.text = weak_self.supportHttp.resultModel.recommend_add;
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

/**
 *  取消赞
 *
 *  @param tid 故事id
 */
- (void)requestDeleStorySupport:(NSString *)tid btnTag:(NSInteger)tag
{
    if (FBIsEmpty(tid)) {
        [self showWithText:@"故事id有误！"];
        return;
    }
    
    self.delMomentHttp.parameter.tid = tid;
    
    [self showLoadingWithText:MT_LOADING];
    __weak FindMomentViewController *weak_self = self;
    [self.delMomentHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        
        if (weak_self.delMomentHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self requestMomentList];
            //请求成功后设置Btn的状态
            NSIndexPath *index1 =  [NSIndexPath indexPathForItem:tag inSection:0];
            FindMomentCell *cell =  (FindMomentCell *)[self.tableView cellForRowAtIndexPath:index1];
            cell.likeBtn.selected = NO;
            cell.recommendNmLabel.text = weak_self.supportHttp.resultModel.recommend_add;
            
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.delMomentHttp.erorMessage];
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
- (IBAction)onTitleBtnClick:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.storyTypeView setHidden:!self.storyTypeView.hidden];
    }];
}

- (void)onLikeBtnClick:(UIButton *)btn
{
    MomentDetail *detail = (MomentDetail *)self.dataSource[btn.tag];
    
    if (btn.selected) {
        //取消赞
        [self requestDeleStorySupport:detail.tid btnTag:btn.tag];
    }
    else {
        //赞
        [self requestSupportStory:detail.tid btnTag:btn.tag];
    }
    
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


- (void)onReportBtnClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"举报" message:@"请输入你要举报的理由" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showWithText:@"举报成功"];
        });
    }
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
    
    [cell.reportBtn addTarget:self action:@selector(onReportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MomentDetail *detail = (MomentDetail *)self.dataSource[indexPath.row];
    
    [self requestMomentInfoWithId:detail];
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
