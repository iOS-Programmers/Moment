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
#import "OAuthLoginHttp.h"

#import "SSKeychain.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface LoginViewController () <TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    
    NSMutableArray* _permissions;
}
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (strong, nonatomic) LoginHttp *loginHttp;
@property (strong, nonatomic) OAuthLoginHttp *oaLoginHttp;

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
    self.oaLoginHttp = [[OAuthLoginHttp alloc] init];
    
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
    NSString *avatar = [SSKeychain passwordForService:@"com.sj.moment"account:@"avatar"];
    
    if (!FBIsEmpty(userName)) {
        self.userNameTF.text = userName;
    }
    if (!FBIsEmpty(passWord)) {
        self.passWordTF.text = passWord;
    }
    if (!FBIsEmpty(avatar)) {
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,avatar]] placeholderImage:[UIImage imageNamed:@"Oval 7 + Oval 11"]];
        self.avatarImage.layer.cornerRadius = CGRectGetWidth(self.avatarImage.frame)/2;
        self.avatarImage.layer.masksToBounds = YES;
    }
    
    //添加第三方登录的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauthLogin:) name:MT_OAuthLogin object:nil];
    
    //腾讯相关
    _permissions = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:
                                                   kOPEN_PERMISSION_GET_USER_INFO,
                                                   kOPEN_PERMISSION_ADD_SHARE,
                                                
                                                   nil]];

    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID
                                            andDelegate:self];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)oauthLogin:(NSNotification *)noti
{
    if ([[noti name] isEqualToString:MT_OAuthLogin]) {
        NSLog(@"第三方登录的回调~");
        
        NSDictionary *userInfo = noti.userInfo;
        
        NSString *openid = userInfo[@"accessToken"];
        NSString *nickname = userInfo[@"userId"];
        if (FBIsEmpty(openid) || FBIsEmpty(nickname)) {
            [self showWithText:@"第三方账号信息有误"];
            return;
        }
        
        self.oaLoginHttp.parameter.openid = openid;
        self.oaLoginHttp.parameter.nickname = nickname;
        
        [self showLoadingWithText:MT_LOADING];
        __weak LoginViewController *weak_self = self;
        [self.oaLoginHttp getDataWithCompletionBlock:^{
            [weak_self hideLoading];
            if (weak_self.oaLoginHttp.isValid)
            {
                [weak_self showWithText:@"登录成功"];
    
                //登录成功后，保存useriD，以后的接口请求都会用到
                [MTUserInfo saveUserID:weak_self.oaLoginHttp.resultModel.member_id];
    
                MTUserInfo *userInfo = [[MTUserInfo alloc] init];
                userInfo.avatar = weak_self.oaLoginHttp.resultModel.avatar;
                userInfo.username = weak_self.oaLoginHttp.resultModel.username;
                userInfo.nickname = weak_self.oaLoginHttp.resultModel.nickname;
                userInfo.regtime = weak_self.oaLoginHttp.resultModel.regtime;
    
                [MTUserInfo saveUserInfo:userInfo];
    
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[MTAppDelegate shareappdelegate] initMainView];
                });
                
            }
            else
            {   //显示服务端返回的错误提示
                [weak_self showWithText:weak_self.oaLoginHttp.erorMessage];
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
    
}

#pragma mark - IBAciton

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
            [SSKeychain setPassword:weak_self.loginHttp.resultModel.avatar forService:@"com.sj.moment" account:@"avatar"];
            
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

/**
 *  QQ登录
 *
 *  @param sender 
 */
- (IBAction)onQQLoginBtnClick:(UIButton *)sender {
    
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

/**
 *  微博登录
 *
 *  @param sender
 */
- (IBAction)onWeiboLoginBtnclick:(UIButton *)sender
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = Weibo_RedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginOAuthLoginViewController",
                        };
    [WeiboSDK sendRequest:request];
}

- (void)QQAuthLogin
{
    if (FBIsEmpty(_tencentOAuth.openId)) {
        return;
    }
    self.oaLoginHttp.parameter.openid = _tencentOAuth.openId;
    self.oaLoginHttp.parameter.nickname = @"QQ用户";
    
    [self showLoadingWithText:MT_LOADING];
    __weak LoginViewController *weak_self = self;
    [self.oaLoginHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.oaLoginHttp.isValid)
        {
            [weak_self showWithText:@"登录成功"];
            
            //登录成功后，保存useriD，以后的接口请求都会用到
            [MTUserInfo saveUserID:weak_self.oaLoginHttp.resultModel.member_id];
            
            MTUserInfo *userInfo = [[MTUserInfo alloc] init];

            userInfo.avatar = weak_self.oaLoginHttp.resultModel.avatar;
            userInfo.username = weak_self.oaLoginHttp.resultModel.username;
            userInfo.nickname = weak_self.oaLoginHttp.resultModel.nickname;
            userInfo.regtime = weak_self.oaLoginHttp.resultModel.regtime;
            
            [MTUserInfo saveUserInfo:userInfo];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[MTAppDelegate shareappdelegate] initMainView];
            });
            
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.oaLoginHttp.erorMessage];
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

#pragma mark - Tencent Delegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    NSLog(@"请求回来的东西 openid %@ \n accessToken %@",_tencentOAuth.openId,_tencentOAuth.accessToken);
    [self QQAuthLogin];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{

}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    [self showWithText:@"网络出问题了，请稍后再试!"];
}
@end
