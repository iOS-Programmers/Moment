//
//  RegisterViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterHttp.h"
#import "GetValidateCodeHttp.h"

@interface RegisterViewController ()
{
    NSTimer *timer;
    int countDownTime;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@property (strong, nonatomic) RegisterHttp *registerHttp;
@property (strong, nonatomic) GetValidateCodeHttp *validateCodeHttp;

- (IBAction)onRegisterBtnClick:(id)sender;
- (IBAction)onVerifyBtnClick:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.registerHttp = [[RegisterHttp alloc] init];
    self.validateCodeHttp = [[GetValidateCodeHttp alloc] init];
    
    countDownTime = 60;
    
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
    else if (FBIsEmpty(self.verifyCodeTF.text)) {
        [self showWithText:@"请输入验证码"];
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
    
    [self.view endEditing:YES];
    
    self.registerHttp.parameter.mobile = self.usernameTF.text;
    self.registerHttp.parameter.password = self.passwordTF.text;
    self.registerHttp.parameter.code = self.verifyCodeTF.text;


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
 *  点击获取验证码
 *
 *  @param sender
 */
- (IBAction)onVerifyBtnClick:(id)sender {

    if (![LXUtils checkPhoneNumberRule:self.usernameTF.text] || FBIsEmpty(self.usernameTF.text))
    {
        [self showWithText:@"手机号格式输入有误"];
        return ;
    }
    
    self.validateCodeHttp.parameter.mobile = self.usernameTF.text;
    __block RegisterViewController *weak_self = self;
    [self.validateCodeHttp getDataWithCompletionBlock:^{
        if (weak_self.validateCodeHttp.isValid)
        {
            [weak_self showWithText:@"获取验证码成功，请稍候查收短信"];
            //获取成功后
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weak_self selector:@selector(getGetValiteCountDown) userInfo:nil repeats:YES];
            countDownTime = 60;
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.validateCodeHttp.erorMessage];
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

//倒计时操作
- (void)getGetValiteCountDown
{
    countDownTime --;
    if (countDownTime == 0)
    {
        if ([timer isValid]) {

            [timer invalidate];
            [self changeButtonState];
            return;
        }
    }
    [self.verifyBtn setTitle:[NSString stringWithFormat:@"验证码已发送(%d)",countDownTime] forState:UIControlStateNormal];
    [self.verifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.verifyBtn.userInteractionEnabled = NO;
    
}
- (void)changeButtonState{
    
    self.verifyBtn.userInteractionEnabled = YES;
    [self.verifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)stopTimer {
    if (nil != timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}


/**
 *  进入主界面
 */
- (void)enterMainView
{
    [[MTAppDelegate shareappdelegate] initMainView];
}
@end
