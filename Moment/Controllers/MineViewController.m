//
//  MineViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MineViewController.h"
#import "SettingViewController.h"
#import "PersonInfoViewController.h"
#import "MyStoryListViewController.h"
#import "SysMessageViewController.h"
#import "MyCommentListViewController.h"

#import "MyProfileHttp.h"


@interface MineViewController ()

@property (strong, nonatomic) MyProfileHttp *myProfileHttp;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的";
    self.myProfileHttp  = [[MyProfileHttp alloc] init];
    
    self.dataSource = [[MTStoreManager shareStoreManager] getMineConfigureArray];
    
    self.navigationItem.rightBarButtonItem = [self rightNavItem];
    
    [self requestMyProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)rightNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, 35, 35);
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = YES;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(settingItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn showsTouchWhenHighlighted];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

#pragma mark - Action

/**
 *  点击设置
 */
- (void)settingItemClick
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)requestMyProfile
{
 
    __weak MineViewController *weak_self = self;
    [self.myProfileHttp getDataWithCompletionBlock:^{

        if (weak_self.myProfileHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self updateMyProfileWithInfo:weak_self.myProfileHttp.resultModel];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.myProfileHttp.erorMessage];
        };
    }failedBlock:^{
        
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
- (void)updateMyProfileWithInfo:(MyProfile *)info
{
    MTUserInfo *userInfo = [MTUserInfo defaultUserInfo];
    userInfo.avatar = info.avatar;
    userInfo.mobile = info.mobile;
    userInfo.nickname = info.nickname;
    userInfo.regtime = info.regtime;
    userInfo.username = info.username;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifierForFirstRow = @"avatarcellIdentfier";
    static NSString *cellIdentifier = @"systemcellIdentfier";
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForFirstRow];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
           
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = [MTUserInfo defaultUserInfo].nickname;
        if (FBIsEmpty([MTUserInfo defaultUserInfo].nickname)) {
            cell.textLabel.text = @"用户名";
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"账号:%@",[MTUserInfo defaultUserInfo].mobile];
        
        if (!FBIsEmpty([MTUserInfo defaultUserInfo].avatar)) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,[MTUserInfo defaultUserInfo].avatar]] placeholderImage:[UIImage imageNamed:@"touxiang_pinglun + Oval 7"]];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"touxiang_pinglun + Oval 7"];
        }
    }
    else {
    
        NSDictionary *moreDictionary = self.dataSource[indexPath.section];
        cell.imageView.image = [UIImage imageNamed:[moreDictionary valueForKey:@"image"][indexPath.row]];
        cell.textLabel.text = [moreDictionary valueForKey:@"title"][indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = nil;
    
    
    
    NSInteger section = indexPath.section;
    switch (section) {
        case 0: {
            //
            //个人资料
            viewController = [[PersonInfoViewController alloc] init];
            break;
        }
            
        case 1: {
        
            switch (indexPath.row) {
                case 0: {
                    //我的故事
                    viewController = [[MyStoryListViewController alloc] init];
                }
                    break;
                case 1: {
                    //系统消息
                    viewController = [[SysMessageViewController alloc] init];
                }
                    break;
                case 2: {
                    //评论
                    viewController = [[MyCommentListViewController alloc] init];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        
        case 2: {
                //邀请好友
        }
            break;
            
        default: {
        }
            break;
    }
    if (viewController) {
        viewController.hidesBottomBarWhenPushed = YES;
        [self pushNewViewController:viewController];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }
    
    return 44;
}

@end
