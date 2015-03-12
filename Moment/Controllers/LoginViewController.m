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
#import "UserAgreementViewController.h"
#import "MTAppDelegate.h"
#import "MTTextFiedBGView.h"
#import "LoginHttp.h"
#import "OAuthLoginHttp.h"
#import "WeiboUser.h"
#import "SSKeychain.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface LoginViewController () <TencentSessionDelegate,MTDelete>
{
    TencentOAuth *_tencentOAuth;
    
    
}
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UITextField *userNameTF;
@property (retain, nonatomic) IBOutlet UITextField *passWordTF;
@property (retain, nonatomic) IBOutlet UIButton *weiboBtn;
@property (retain, nonatomic) IBOutlet UIButton *qqBtn;

@property (strong, nonatomic) LoginHttp *loginHttp;
@property (strong, nonatomic) OAuthLoginHttp *oaLoginHttp;

@property (strong, nonatomic) NSMutableArray* permissions;

//设置微博的通知只能调用一次
@property (nonatomic) BOOL isRequestWeiBo;

//昵称，第三方登录的入参，可以为空
@property (copy, nonatomic) NSString *nickeName;
//头像，第三方登录的入参，可以为空
@property (copy, nonatomic) NSString *avatarUrl;

- (IBAction)onRegisterBtnClick:(UIButton *)sender;
- (IBAction)onLoginBtnClick:(UIButton *)sender;
- (IBAction)onFindPswBtnClick:(UIButton *)sender;
- (IBAction)onQQLoginBtnClick:(UIButton *)sender;

- (IBAction)onWeiboLoginBtnclick:(UIButton *)sender;
- (IBAction)onXieYiBtnClick:(UIButton *)sender;
@end

#pragma mark - Implementation

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.loginHttp = [[LoginHttp alloc] init];
    self.oaLoginHttp = [[OAuthLoginHttp alloc] init];
    

    [MTAppDelegate shareappdelegate].delegate = self;
    
    self.isRequestWeiBo = NO;
    
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
    
    
    //腾讯相关
    self.permissions = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:
                                                   kOPEN_PERMISSION_GET_INFO,
                                                   kOPEN_PERMISSION_GET_USER_INFO,
                                                   kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                                   kOPEN_PERMISSION_ADD_SHARE,
                                                
                                                   nil]];

    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID
                                            andDelegate:self];
    
    /**
     *  判断用户有没有安装QQ，没安装的话，隐藏掉QQ登录按钮
     */
    if (![TencentOAuth iphoneQQInstalled]) {
        self.qqBtn.hidden = YES;
        
        self.weiboBtn.center = CGPointMake([LXUtils GetScreeWidth]/2, self.weiboBtn.frame.origin.y +17);
    }

}


//- (void)addCancelBtn
//{
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0.0f, 0.0f,40,30);
//    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
//    leftBtn.backgroundColor = [UIColor clearColor];
//    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//}

//- (void)cancelBtnClick
//{
//    if (self.loginType == LoginTypeDismiss) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MTDelegate
- (void)sendWeiBoLogin:(NSDictionary *)dic
{
     YHLog(@"------代理----------微博第三方登录的回调~");
    NSString *openid = dic[@"accessToken"];
    NSString *userid = dic[@"userId"];
    
    [WBHttpRequest requestForUserProfile:userid withAccessToken:openid andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
        WeiboUser *user = (WeiboUser *)result;
        
        YHLog(@"----%@",user.name);
        YHLog(@"----%@",user.avatarLargeUrl);
        
        [self requstWeiboLoginWithNickName:user.name openID:openid avatar:user.avatarLargeUrl];
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)requstWeiboLoginWithNickName:(NSString *)nickName openID:(NSString *)openid avatar:(NSString *)avtar
{
    if (FBIsEmpty(openid)) {
        [self showWithText:@"获取微博信息为空"];
        return;
    }
    
    if (self.isRequestWeiBo) {
        return;
    }
    self.isRequestWeiBo = YES;
    
    self.oaLoginHttp.parameter.openid = openid;
    self.oaLoginHttp.parameter.nickname = FBIsEmpty(nickName) ? @"微博用户":nickName;
    self.oaLoginHttp.parameter.avatar = FBIsEmpty(avtar) ? @"":avtar;
    
    [self showLoadingWithText:MT_LOADING];
    __weak LoginViewController *weak_self = self;
    [self.oaLoginHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.oaLoginHttp.isValid)
        {
            [weak_self showWithText:@"登录成功"];
            
            weak_self.isRequestWeiBo = NO;
            
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
            
            weak_self.isRequestWeiBo = NO;
        };
    }failedBlock:^{
        [weak_self hideLoading];
        
        weak_self.isRequestWeiBo = NO;
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
    
    [_tencentOAuth authorize:self.permissions inSafari:YES];
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

- (IBAction)onXieYiBtnClick:(UIButton *)sender {
    UserAgreementViewController *vc = [[UserAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)QQAuthLogin
{
    if (FBIsEmpty(_tencentOAuth.openId)) {
        return;
    }
    self.oaLoginHttp.parameter.openid = _tencentOAuth.openId;
    self.oaLoginHttp.parameter.nickname = FBIsEmpty(self.nickeName) ? @"QQ用户" : self.nickeName;
    //第三方登录头像 self.avatarUrl
    self.oaLoginHttp.parameter.avatar = FBIsEmpty(self.avatarUrl) ? @"" : self.avatarUrl;
    
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
    
    //获取用户的基本信息
    if(![_tencentOAuth getUserInfo]){
        [self showWithText:@"获取QQ信息失败"];
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [self showWithText:@"获取QQ信息失败"];
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    [self showWithText:@"网络出问题了，请稍后再试!"];
}

/**
 *  获取QQ用户信息成功后回调
 */
- (void)getUserInfoResponse:(APIResponse*) response {
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSMutableString *str=[NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse) {
            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
        }
        self.nickeName = response.jsonResponse[@"nickname"];
        self.avatarUrl = response.jsonResponse[@"figureurl_qq_2"];
        
        //调用登录
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self QQAuthLogin];
        });
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
                              
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
    }
    
    
}
@end
