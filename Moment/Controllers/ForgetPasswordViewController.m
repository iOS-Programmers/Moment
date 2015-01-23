//
//  ForgetPasswordViewController.m
//  Moment
//
//  Created by Jyh on 1/20/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "CheckValidateCodeHttp.h"
#import "ChangePasswordHttp.h"
#import "GetValidateCodeHttp.h"

@interface ForgetPasswordViewController ()
{
    NSTimer *timer;
    int countDownTime;
}
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UITextField *firstPhonenumTF;
- (IBAction)onFirstNextBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *ValidateCodeView;
@property (weak, nonatomic) IBOutlet UILabel *phonenumLabel;

@property (weak, nonatomic) IBOutlet UITextField *validatecodeTF;
@property (weak, nonatomic) IBOutlet UIButton *regetValidateCodeBtn;
- (IBAction)onRegetValidateBtnClick:(UIButton *)sender;
- (IBAction)onSecondNextBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *modifyPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTF;
- (IBAction)onCommitBtnClick:(UIButton *)sender;

@property (strong, nonatomic) CheckValidateCodeHttp *checkcodeHttp;
@property (strong, nonatomic) ChangePasswordHttp *changePasswordHttp;
@property (strong, nonatomic) GetValidateCodeHttp *validateCodeHttp;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
    
    self.checkcodeHttp = [[CheckValidateCodeHttp alloc] init];
    self.changePasswordHttp = [[ChangePasswordHttp alloc] init];
    self.validateCodeHttp = [[GetValidateCodeHttp alloc] init];
    
    countDownTime = 60;

    [self.ValidateCodeView frameSetPoint:CGPointMake([LXUtils GetScreeWidth], 0)];
    [self.modifyPasswordView frameSetPoint:CGPointMake([LXUtils GetScreeWidth], 0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.firstPhonenumTF becomeFirstResponder];
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

//倒计时操作
- (void)getValiteCountDown
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
    [self.regetValidateCodeBtn setTitle:[NSString stringWithFormat:@"验证码已发送(%d)",countDownTime] forState:UIControlStateNormal];
    [self.regetValidateCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.regetValidateCodeBtn.userInteractionEnabled = NO;
    
}
- (void)changeButtonState{
    
    self.regetValidateCodeBtn.userInteractionEnabled = YES;
    [self.regetValidateCodeBtn setTitleColor:UIColorRGB(48, 134, 229) forState:UIControlStateNormal];
    [self.regetValidateCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
}

- (void)stopTimer {
    if (nil != timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

//显示第二个填写验证码页面
- (void)showValidateCodeView
{
    [self.phoneNumView setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.ValidateCodeView frameSetPoint:CGPointMake(0, 0)];
        [self.view addSubview:self.ValidateCodeView];
    }];
    
    self.phonenumLabel.text = self.firstPhonenumTF.text;
}

//显示第三个修改密码页面
- (void)showChangePasswordView
{
    [self.ValidateCodeView setHidden:YES];
    
    [self.passwordTF becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.modifyPasswordView frameSetPoint:CGPointMake(0, 0)];
        [self.view addSubview:self.modifyPasswordView];
    }];
}


#pragma mark - IBAciton
/**
 *  点击根据手机号去发送验证码
 *
 *  @param sender
 */
- (IBAction)onFirstNextBtnClick:(id)sender {
    if (![LXUtils checkPhoneNumberRule:self.firstPhonenumTF.text] || FBIsEmpty(self.firstPhonenumTF.text))
    {
        [self showWithText:@"手机号格式输入有误"];
        return ;
    }
    
    [self getValidateCode];
}

/**
 *  重新发送验证码
 *
 *  @param sender
 */
- (IBAction)onRegetValidateBtnClick:(UIButton *)sender {
    
    [self getValidateCode];
}

/**
 *  对验证码验证
 *
 *  @param sender
 */
- (IBAction)onSecondNextBtnClick:(id)sender
{
    if (FBIsEmpty(self.validatecodeTF.text)) {
        [self showWithText:@"请输入验证码！"];
        return;
    }
    
    [self checkValidateCode];
}

- (IBAction)onCommitBtnClick:(UIButton *)sender {
    if (FBIsEmpty(self.passwordTF.text) || FBIsEmpty(self.repasswordTF.text)) {
        [self showWithText:@"请输入密码!"];
        return;
    }
    
    if (![self.passwordTF.text isEqualToString:self.repasswordTF.text]) {
        [self showWithText:@"两次输入密码不一致！"];
        return;
    }
    if (self.passwordTF.text.length < 6 || self.repasswordTF.text.length < 6) {
        [self showWithText:@"密码长度必须为6位以上!"];
        return;
    }
    
    [self modifyPassword];
}

#pragma mark - Request

- (void)getValidateCode
{

    self.validateCodeHttp.parameter.mobile = self.firstPhonenumTF.text;
    __block ForgetPasswordViewController *weak_self = self;
    [self.validateCodeHttp getDataWithCompletionBlock:^{
        if (weak_self.validateCodeHttp.isValid)
        {
            [weak_self showWithText:@"获取验证码成功，请稍候查收短信"];
            //获取成功后
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weak_self selector:@selector(getValiteCountDown) userInfo:nil repeats:YES];
            countDownTime = 60;
            
            [weak_self showValidateCodeView];
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



/**
 *  对验证码进行验证，验证成功后，重新设置密码
 */
- (void)checkValidateCode
{
//    self.checkcodeHttp.parameter.mobile = self.firstPhonenumTF.text;
    
    if (![self.validatecodeTF.text isEqualToString:self.validateCodeHttp.resultModel.code]) {
        [self showWithText:@"验证码验证失败!"];
        return;
    }
    else {
        //验证成功后，显示修改密码页面
        [self showChangePasswordView];
    }
//    self.checkcodeHttp.parameter.code = self.validateCodeHttp.resultModel.code;
//    
//    [self showLoadingWithText:MT_LOADING];
//    __weak ForgetPasswordViewController *weak_self = self;
//    [self.checkcodeHttp getDataWithCompletionBlock:^{
//        [weak_self hideLoading];
//        if (weak_self.checkcodeHttp.isValid)
//        {
//            if ([weak_self.checkcodeHttp.resultModel.status isEqualToString:@"1"]) {
//                //验证成功后，显示修改密码页面
//                [self showChangePasswordView];
//            }
//        }
//        else
//        {   //显示服务端返回的错误提示
//            [weak_self showWithText:weak_self.checkcodeHttp.erorMessage];
//        };
//    }failedBlock:^{
//        [weak_self hideLoading];
//        if (![LXUtils networkDetect])
//        {
//            [weak_self showWithText:MT_CHECKNET];
//        }
//        else
//        {
//            //统统归纳为服务器出错
//            [weak_self showWithText:MT_NETWRONG];
//        };
//    }];

}

/**
 *  修改密码
 */
- (void)modifyPassword
{
    self.changePasswordHttp.parameter.mobile = self.firstPhonenumTF.text;
    self.changePasswordHttp.parameter.password = self.passwordTF.text;
    
    [self showLoadingWithText:MT_LOADING];
    __weak ForgetPasswordViewController *weak_self = self;
    [self.changePasswordHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.changePasswordHttp.isValid)
        {
            if ([weak_self.changePasswordHttp.resultModel.status isEqualToString:@"1"]) {
               
                //修改成功，返回登录页
                [weak_self showWithText:@"密码修改成功，请重新登录！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weak_self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.changePasswordHttp.erorMessage];
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

@end
