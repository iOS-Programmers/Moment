//
//  LoginViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "MTAppDelegate.h"
#import "MTTextFiedBGView.h"
#import "LoginHttp.h"

#import "SSKeychain.h"

//友盟第三方登录
#import "UMSocial.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (strong, nonatomic) LoginHttp *loginHttp;

- (IBAction)onRegisterBtnClick:(UIButton *)sender;
- (IBAction)onLoginBtnClick:(UIButton *)sender;
- (IBAction)onFindPswBtnClick:(UIButton *)sender;
- (IBAction)onQQLoginBtnClick:(UIButton *)sender;

- (IBAction)onWeiboLoginBtnclick:(UIButton *)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.loginHttp = [[LoginHttp alloc] init];
    
    if (self.loginType == LoginTypeDismiss) {
        [self addCancelBtn];
    }
    
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLCOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.weiboBtn.layer.borderWidth = 1;
    self.weiboBtn.layer.borderColor = UIColorToRGB(0xff00aa).CGColor;
    self.weiboBtn.layer.cornerRadius = 5;
    self.qqBtn.layer.borderWidth = 1;
    self.qqBtn.layer.borderColor = UIColorToRGB(0xff00aa).CGColor;
    self.qqBtn.layer.cornerRadius = 5;
    
    //如果钥匙串中有保存账号密码，则给予显示
    NSString *userName = [SSKeychain passwordForService:@"com.sj.moment"account:@"username"];
    NSString *passWord = [SSKeychain passwordForService:@"com.sj.moment"account:@"password"];
    
    if (!FBIsEmpty(userName)) {
        self.userNameTF.text = userName;
    }
    if (!FBIsEmpty(passWord)) {
        self.passWordTF.text = passWord;
    }
}

- (void)addCancelBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0.0f, 0.0f,40,30);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)cancelBtnClick
{
    if (self.loginType == LoginTypeDismiss) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
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

 
    if (![LXUtils checkPhoneNumberRule:self.userNameTF.text] || FBIsEmpty(self.userNameTF.text))
    {
        [self showWithText:@"手机号格式输入有误"];
        return ;
    }
    
    if (FBIsEmpty(self.passWordTF.text)) {
        [self showWithText:@"请输入密码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    self.loginHttp.parameter.mobile = self.userNameTF.text;
    self.loginHttp.parameter.password = self.passWordTF.text;

    [self showLoadingWithText:MT_LOADING];
    __weak LoginViewController *weak_self = self;
    [self.loginHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.loginHttp.isValid)
        {
            [weak_self showWithText:@"登录成功"];
            
            //登陆成功后，保存用户名跟密码到钥匙串里
            [SSKeychain setPassword:weak_self.userNameTF.text forService:@"com.sj.moment" account:@"username"];
            [SSKeychain setPassword:weak_self.passWordTF.text forService:@"com.sj.moment" account:@"password"];
            
            //登录成功后，保存useriD，以后的接口请求都会用到
            [MTUserInfo saveUserID:weak_self.loginHttp.resultModel.member_id];
            
            MTUserInfo *userInfo = [[MTUserInfo alloc] init];
            userInfo.avatar = weak_self.loginHttp.resultModel.avatar;
            userInfo.username = weak_self.loginHttp.resultModel.username;
            userInfo.nickname = weak_self.loginHttp.resultModel.nickname;
            userInfo.mobile = weak_self.loginHttp.resultModel.mobile;
            userInfo.regtime = weak_self.loginHttp.resultModel.regtime;
            
            [MTUserInfo saveUserInfo:userInfo];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[MTAppDelegate shareappdelegate] initMainView];
            });
            
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.loginHttp.erorMessage];
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


- (IBAction)onFindPswBtnClick:(UIButton *)sender {
    
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onQQLoginBtnClick:(UIButton *)sender {
}

/**
 *  微博登录
 *
 *  @param sender
 */
- (IBAction)onWeiboLoginBtnclick:(UIButton *)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
}
@end
