//
//  SettingViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "SettingViewController.h"
#import "YHBaseNavigationController.h"
#import "PersonInfoViewController.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()
@property (strong, nonatomic) IBOutlet UIView *footerView;

- (IBAction)logoutClick:(id)sender;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    
    self.dataSource = [[MTStoreManager shareStoreManager] getSettingConfigureArray];
    
    self.tableView.tableFooterView = self.footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Action

-(void)switchValueChange:(UISwitch *)sw
{
    NSLog(@"section:%li,switch:%i",(long)sw.tag, sw.on);
}

/**
 *  退出登录
 *
 *  @param sender
 */
- (IBAction)logoutClick:(id)sender
{
    [MTUserInfo clearAllUserInfo];
    LoginViewController *loginVC = [[LoginViewController alloc] init];

    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    [self.navigationController presentViewController:loginNav animated:YES completion:^{
        
    }];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifierForSettingRow = @"settingcellIdentfier";
    static NSString *cellIdentifier = @"systemcellIdentfier";
    
    UITableViewCell *cell;
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForSettingRow];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    if (!cell) {
        if (indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            UISwitch *sw=[[UISwitch alloc]init];
            sw.tag = indexPath.row;
            [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView=sw;

            
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (indexPath.row < self.dataSource.count) {
        NSDictionary *settingDictionary = self.dataSource[indexPath.section];
      
        cell.textLabel.text = [settingDictionary valueForKey:@"title"][indexPath.row];
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
            switch (indexPath.row) {
                case 0: {
                    //我的账号
                    viewController = [[PersonInfoViewController alloc] init];
                }
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case 2: {
            
            switch (indexPath.row) {
                case 0: {
                    //关于我们
                    viewController = [[AboutUsViewController alloc] init];
                }
                    break;
                case 1: {
                    //检测新版本
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showWithText:@"当前是最新版本!"];
                    });
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 3: {
            //清除图片缓存
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showWithText:@"图片缓存清除成功!"];
            });
        }
            break;
            
        default: {
        }
            break;
    }
    if (viewController) {

        [self pushNewViewController:viewController];
    }

}

@end
