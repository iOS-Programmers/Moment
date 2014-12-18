//
//  LoginViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MTAppDelegate.h"

@interface LoginViewController ()

- (IBAction)onRegisterBtnClick:(UIButton *)sender;
- (IBAction)onLoginBtnClick:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLCOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    }
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



- (IBAction)onRegisterBtnClick:(UIButton *)sender {

  [self pushViewController:@"RegisterViewController"];
}

- (IBAction)onLoginBtnClick:(UIButton *)sender {

    [[MTAppDelegate shareappdelegate] initMainView];
  
}
@end
