//
//  MyCommentListViewController.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MyCommentListViewController.h"
#import "MyCommentListCell.h"
#import "MyCommentListHttp.h"
#import "CommentMeListHttp.h"

@interface MyCommentListViewController ()

@property (strong, nonatomic) MyCommentListHttp *mycommentHttp;
@property (strong, nonatomic) CommentMeListHttp *commentmeHttp;

/**
 *  设置是评论我的，还是我的评论的tag
 */
@property (nonatomic) BOOL isMyCommentTag;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControl;
- (IBAction)segementAction:(id)sender;
@end

@implementation MyCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化
    self.mycommentHttp = [[MyCommentListHttp alloc] init];
    self.commentmeHttp = [[CommentMeListHttp alloc] init];
    
    self.isMyCommentTag = YES;
    
    self.tableView.rowHeight = 165;
    [self.tableView setFrame:CGRectMake(0, 50, [LXUtils GetScreeWidth], [LXUtils getContentViewHeight] + 10)];
    self.title = @"我的评论";
    
    [self requestMyCommentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)requestMyCommentList
{
    //请求前清空数据列表
    [self.dataSource removeAllObjects];
    
    __weak MyCommentListViewController *weak_self = self;
    [self.mycommentHttp getDataWithCompletionBlock:^{
        
        if (weak_self.mycommentHttp.isValid)
        {
            /**
             *  更新我的评论列表数据
             */
            [weak_self updateMyCommentListWithInfo:weak_self.mycommentHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.mycommentHttp.erorMessage];
            
            [weak_self.tableView reloadData];
        };
    }failedBlock:^{
        
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

- (void)requestCommentMeList
{
    //请求前清空数据列表
    [self.dataSource removeAllObjects];
    
    __weak MyCommentListViewController *weak_self = self;
    [self.commentmeHttp getDataWithCompletionBlock:^{
        
        if (weak_self.commentmeHttp.isValid)
        {
            /**
             *  更新评论我的列表数据
             */
            [weak_self updateCommentMeListWithInfo:weak_self.commentmeHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.commentmeHttp.erorMessage];
            
            [weak_self.tableView reloadData];
        };
    }failedBlock:^{
        
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
- (void)updateMyCommentListWithInfo:(NSMutableArray *)array
{
    [self.header endRefreshing];
    
    self.isMyCommentTag = YES;
    self.dataSource = array;
    
    [self.tableView reloadData];
}

/**
 *  更新列表信息
 *
 *  @param infoArray 列表数组
 */
- (void)updateCommentMeListWithInfo:(NSMutableArray *)array
{
    [self.header endRefreshing];
    
    self.isMyCommentTag = NO;
    self.dataSource = array;
    
    [self.tableView reloadData];
}


- (IBAction)segementAction:(id)sender {
    UISegmentedControl *segement = (UISegmentedControl *)sender;
    switch (segement.selectedSegmentIndex) {
        case 0:
        {
            //我的评论
            [self requestMyCommentList];
        }
            break;
        case 1:
        {
            //评论我的
            [self requestCommentMeList];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"MyCommentListCell" owner:self options:nil];
        for (id oneObject in cellNib)
        {
            if ([oneObject isKindOfClass:[MyCommentListCell class]])
            {
                cell = (MyCommentListCell *)oneObject;
            }
        }
    }
    
    if (self.isMyCommentTag) {
        MyComment *info = (MyComment *)self.dataSource[indexPath.row];
        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,info.avatar]]];
        cell.storyNameLabel.text = info.title;
        cell.nickNameLabel.text = info.author;
        cell.mycommentLabel.text = info.message;
        cell.timeLabel.text = [LXUtils secondChangToDateString:info.dateline];
        [cell.litpicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,info.litpic]]];
        
    }
    else {
        CommentMe *info = (CommentMe *)self.dataSource[indexPath.row];
        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,info.avatar]]];
        cell.storyNameLabel.text = info.title;
        cell.nickNameLabel.text = info.author;
        cell.mycommentLabel.text = info.message;
        cell.timeLabel.text = [LXUtils secondChangToDateString:info.dateline];
        [cell.litpicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,info.litpic]]];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
