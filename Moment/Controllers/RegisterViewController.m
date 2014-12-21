//
//  RegisterViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterHttp.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (strong, nonatomic) RegisterHttp *registerHttp;

- (IBAction)onRegisterBtnClick:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.registerHttp = [[RegisterHttp alloc] init];
    self.title = @"注册";
    
    
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

/**
 *  1.先判断手机号非空并且格式正确
 *  2.再判断验证码是否为空
 *  3.判断新密码跟确认密码是否为空
 *  4.最后判断两次输入密码是否一致
 
 *  @return 返回判断结果
 */
- (BOOL)checkCode
{
    if (![LXUtils checkPhoneNumberRule:self.usernameTF.text] || FBIsEmpty(self.usernameTF.text))
    {
        [self showWithText:@"手机号格式输入有误"];
        return NO;
    }
    
    else if (FBIsEmpty(self.passwordTF.text)) {
        [self showWithText:@"请输入密码"];
        return NO;
    }
    else
    {
        return  YES;
    }
}

- (IBAction)onRegisterBtnClick:(id)sender {
    
    if (![self checkCode]) {
        return;
    }
    
    self.registerHttp.parameter.mobile = self.usernameTF.text;
    self.registerHttp.parameter.password = self.passwordTF.text;


    [self showLoadingWithText:MT_LOADING];
    __weak RegisterViewController *weak_self = self;
    [self.registerHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.registerHttp.isValid)
        {
            [MTUserInfo saveUserID:weak_self.registerHttp.resultModel.member_id];
            [weak_self showWithText:@"注册成功！"];
            
            [weak_self performSelector:@selector(enterMainView) withObject:nil afterDelay:2];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.registerHttp.erorMessage];
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
 *  进入主界面
 */
- (void)enterMainView
{
    [[MTAppDelegate shareappdelegate] initMainView];
}
@end
