//
//  AllCommentListViewController.m
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AllCommentListViewController.h"
#import "CommentCell.h"
#import "CommentListHttp.h"
#import "AddCommentHttp.h"

@interface AllCommentListViewController ()

@property (strong, nonatomic) CommentListHttp *commentListHttp;
@property (strong, nonatomic) AddCommentHttp *addCommentHttp;

@end

@implementation AllCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.commentListHttp = [[CommentListHttp alloc] init];
    self.addCommentHttp = [[AddCommentHttp alloc] init];

    
    [self requestStoryCommentList];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 120;
    self.tableView.separatorColor = [UIColor clearColor];

    self.navigationItem.rightBarButtonItem = [self commentListNavItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)requestStoryCommentList
{
    if (FBIsEmpty(self.tid)) {
        return;
    }
    
    self.commentListHttp.parameter.tid = self.tid;
    [self showLoadingWithText:MT_LOADING];
    __weak AllCommentListViewController *weak_self = self;
    [self.commentListHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
//        [weak_self.header endRefreshing];
        if (weak_self.commentListHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self updateMomentListWithInfo:weak_self.commentListHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.commentListHttp.erorMessage];
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

- (UIBarButtonItem *)commentListNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, 35, 35);
    btn.backgroundColor = [UIColor clearColor];
//    [btn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [btn setTitle:@"评论" forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = YES;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(commentListNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn showsTouchWhenHighlighted];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)commentListNavItemClick
{
    self.addCommentHttp.parameter.tid = self.tid;
    self.addCommentHttp.parameter.fid = self.fid;
    self.addCommentHttp.parameter.message = @"有些事，我都已忘记，但我现在还记得，在一个晚上，我的母亲问我今天怎么不开心，我说在我的想象中，有一双滑板鞋，与众不同最时尚，跳舞肯定棒。";
    [self showLoadingWithText:MT_LOADING];
    __weak AllCommentListViewController *weak_self = self;
    [self.addCommentHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        //        [weak_self.header endRefreshing];
        if (weak_self.addCommentHttp.isValid)
        {
            /**
             *  更新数据
             */
//            [weak_self updateMomentListWithInfo:weak_self.commentListHttp.resultModel.dataArray];
            [weak_self.tableView reloadData];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.addCommentHttp.erorMessage];
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

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        for (id oneObject in cellNib)
        {
            if ([oneObject isKindOfClass:[CommentCell class]])
            {
                cell = (CommentCell *)oneObject;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CommentInfo *commentDetail = (CommentInfo *)self.dataSource[indexPath.row];
    
    [cell updateUIWithCommentInfo:commentDetail];
    
    return cell;
}

@end
