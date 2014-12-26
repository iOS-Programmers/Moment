//
//  SysMessageViewController.m
//  Moment
//
//  Created by Jyh on 14/12/17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "SysMessageViewController.h"
#import "SysMessageCell.h"
#import "SystemMessageHttp.h"

@interface SysMessageViewController ()

@property (strong, nonatomic) SystemMessageHttp *messageHttp;
@end

@implementation SysMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"系统消息";
    self.messageHttp = [[SystemMessageHttp alloc] init];

    [self requestMessageList];
    
    self.tableView.rowHeight = 125;
    
    self.canPullRefresh = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMessageList
{
    
    __weak SysMessageViewController *weak_self = self;
    [self.messageHttp getDataWithCompletionBlock:^{
    
        if (weak_self.messageHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self updateMyProfileWithInfo:weak_self.messageHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.messageHttp.erorMessage];
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
- (void)updateMyProfileWithInfo:(NSMutableArray *)array
{
    [self.header endRefreshing];
    
    self.dataSource = array;
    
    [self.tableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SysMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"SysMessageCell" owner:self options:nil];
        for (id oneObject in cellNib)
        {
            if ([oneObject isKindOfClass:[SysMessageCell class]])
            {
                cell = (SysMessageCell *)oneObject;
            }
        }
    }
    
    Message *message = (Message *)self.dataSource[indexPath.row];
    
    [cell updateMessageCellWithInfo:message];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 上下拉刷新的Delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //上拉刷新时的操作
    if (self.header == refreshView)
    {
        [self requestMessageList];
    }
    //下拉加载时的操作
    else {
        
    }
}

@end
