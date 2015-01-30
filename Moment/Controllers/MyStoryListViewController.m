//
//  MyStoryListViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MyStoryListViewController.h"
#import "StoryListCell.h"

#import "FindDetailViewController.h"
#import "MyStory.h"

#import "MyStoryHttp.h"
#import "DeleMyStoryHttp.h"
#import "MomentInfoHttp.h"

@interface MyStoryListViewController ()

@property (strong, nonatomic) MyStoryHttp *myStoryHttp;
@property (strong, nonatomic) DeleMyStoryHttp *delemyStoryHttp;
@property (strong, nonatomic) MomentInfoHttp *momentInfoHttp;

@end

@implementation MyStoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的故事";
    
    self.myStoryHttp = [[MyStoryHttp alloc] init];
    self.delemyStoryHttp = [[DeleMyStoryHttp alloc] init];
    self.momentInfoHttp = [[MomentInfoHttp alloc] init];
    
    self.tableView.rowHeight = 88;
    
    [self requestMyStoryList];
    
    //添加下拉刷新
    self.canPullRefresh = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMyStoryList
{
    
    [self showLoadingWithText:MT_LOADING];
    __weak MyStoryListViewController *weak_self = self;
    [self.myStoryHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        [weak_self.header endRefreshing];
        if (weak_self.myStoryHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self updateMomentListWithInfo:weak_self.myStoryHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.myStoryHttp.erorMessage];
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
        
        self.dataSource = (NSMutableArray *)[[infoArray reverseObjectEnumerator] allObjects];
    }
    
    [self.tableView reloadData];
}

- (void)requestMomentInfoWithId:(MyStory *)detail
{
    if (FBIsEmpty(detail.tid)) {
        return;
    }
    
    self.momentInfoHttp.parameter.tid = detail.tid;
    
    [self showLoadingWithText:MT_LOADING];
    __weak MyStoryListViewController *weak_self = self;
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

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"StoryListCell" owner:self options:nil];
        for (id oneObject in cellNib)
        {
            if ([oneObject isKindOfClass:[StoryListCell class]])
            {
                cell = (StoryListCell *)oneObject;
            }
        }
    }
    
    MyStory *storyDetail = (MyStory *)self.dataSource[indexPath.row];
    
    [cell updateStoryCellWithInfo:storyDetail];
    
    
    return cell;
}

//UITableView可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        MyStory *storyDetail = (MyStory *)self.dataSource[indexPath.row];
        if (FBIsEmpty(storyDetail.tid)) {
            return;
        }
        
        self.delemyStoryHttp.parameter.tid = storyDetail.tid;
        
        /**
         *  这里进行删除操作，
         */
        [self showLoadingWithText:@"删除中"];
        __weak MyStoryListViewController *weak_self = self;
        [self.delemyStoryHttp getDataWithCompletionBlock:^{
            [weak_self hideLoading];
            [weak_self.header endRefreshing];
            if (weak_self.delemyStoryHttp.isValid)
            {
                if ([weak_self.delemyStoryHttp.resultModel.status isEqualToString:@"1"]) {
                    //删除成功的回调
                    [weak_self.dataSource removeObjectAtIndex:indexPath.row];
                    // Delete the row from the data source.
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [weak_self.tableView reloadData];
                }
                
            }
            else
            {   //显示服务端返回的错误提示
                [weak_self showWithText:weak_self.delemyStoryHttp.erorMessage];
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

}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    MyStory *detail = (MyStory *)self.dataSource[indexPath.row];
    
    [self requestMomentInfoWithId:detail];
}


#pragma mark 上下拉刷新的Delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //上拉刷新时的操作
    if (self.header == refreshView)
    {
        [self requestMyStoryList];
    }
    //下拉加载时的操作
    else {
        
    }
}

@end
