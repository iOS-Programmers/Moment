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

@interface FindMomentViewController ()

@property (strong, nonatomic) MomentListHttp *momentHttp;

@end

@implementation FindMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发现瞬间";
    self.momentHttp = [[MomentListHttp alloc] init];
    
    self.tableView.rowHeight = 118;
    
    [self requestMomentList];
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

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FindDetailViewController *detail = [[FindDetailViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

}

@end
