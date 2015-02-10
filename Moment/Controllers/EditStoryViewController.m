//
//  EditStoryViewController.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "EditStoryViewController.h"
#import "PlacehoderTextView.h"
#import "AdMomentHttp.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>


@interface EditStoryViewController () <UITextViewDelegate, UIActionSheetDelegate,TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    
    NSMutableArray* _permissions;
}

@property (weak, nonatomic) IBOutlet UIView *storyContentView;
@property (weak, nonatomic) IBOutlet UITextField *storyTitleTF;
@property (weak, nonatomic) IBOutlet UIButton *chooseStoryTypeBtn;
@property (strong, nonatomic) PlacehoderTextView *textView;

@property (strong, nonatomic) AdMomentHttp *addMomentHttp;

- (IBAction)onChooseStoryTypeClick:(id)sender;
- (IBAction)onPublishBtnClick:(UIButton *)sender;
- (IBAction)onPublishAndShareBtnClick:(UIButton *)sender;

@end

@implementation EditStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"编辑故事";
    self.addMomentHttp = [[AdMomentHttp alloc] init];
    
    _textView = [[PlacehoderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 125)];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.placeholder = @"故事内容";
    
    [self.storyContentView addSubview:_textView];
    
    //腾讯相关
    _permissions = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:
                                                   kOPEN_PERMISSION_GET_USER_INFO,
                                                   kOPEN_PERMISSION_ADD_SHARE,
                                                   
                                                   nil]];
    
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID
                                            andDelegate:self];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MT_RefreshMomentUI object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction
/**
 *  点击选择故事分类
 */
- (IBAction)onChooseStoryTypeClick:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择故事分类" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"因为爱情",@"青春、梦想、那些年",@"那些故事", nil];
    action.tag = 1;
    [action  showInView:self.view];
}

- (IBAction)onPublishBtnClick:(UIButton *)sender {
    
    if (FBIsEmpty(self.storyTitleTF.text)) {
        [self showWithText:@"请输入故事标题!"];
        return;
    }
    if (FBIsEmpty(self.textView.text)) {
        [self showWithText:@"请输入故事内容!"];
        return;
    }
    
    if (FBIsEmpty(self.imageIds)) {
        [self showWithText:@"您未上传任何图片!"];
        return;
    }
    
    if (FBIsEmpty(self.addMomentHttp.parameter.fid)) {
        [self showWithText:@"请选择故事分类!"];
        return;
    }
    
    
    if ([self.imageIds count] == 1) {
        self.addMomentHttp.parameter.litpic = self.imageIds[0];
        self.addMomentHttp.parameter.pictureurls = self.imageIds[0];
    }
    if ([self.imageIds count] > 1) {
        self.addMomentHttp.parameter.litpic = self.imageIds[0];
        self.addMomentHttp.parameter.pictureurls = self.imageIds[1];
    }
    

    self.addMomentHttp.parameter.title = self.storyTitleTF.text;
    self.addMomentHttp.parameter.content = self.textView.text;
    
    [self showLoadingWithText:MT_LOADING];
    __block EditStoryViewController *weak_self = self;
    [self.addMomentHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.addMomentHttp.isValid)
        {
            [weak_self showWithText:@"发布成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weak_self.navigationController popToRootViewControllerAnimated:YES];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weak_self editFinshAndRefresh];
                });
            });
        }
    }failedBlock:^{
        [weak_self hideLoading];
        if (![LXUtils networkDetect])
        {
            [weak_self showWithText:MT_CHECKNET];
        }
        else
        {   //统统归纳为服务器出错
            [weak_self showWithText:MT_NETWRONG];
        };
    }];
}

/**
 *  发布并分享
 *
 *  @param sender
 */
- (IBAction)onPublishAndShareBtnClick:(UIButton *)sender {

    if (FBIsEmpty(self.storyTitleTF.text)) {
        [self showWithText:@"请输入故事标题!"];
        return;
    }
    if (FBIsEmpty(self.textView.text)) {
        [self showWithText:@"请输入故事内容!"];
        return;
    }
    
    if (FBIsEmpty(self.imageIds)) {
        [self showWithText:@"您未上传任何图片!"];
        return;
    }
    
    if (FBIsEmpty(self.addMomentHttp.parameter.fid)) {
        [self showWithText:@"请选择故事分类!"];
        return;
    }
    
    //点击分享
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"微信朋友圈",@"微信好友",@"新浪微博",@"QQ好友", nil];
    action.tag = 2;
    [action  showInView:self.view];
}

#pragma mark - Delegate

- (void)editFinshAndRefresh
{

    FindMomentViewController *momentVC = [MTAppDelegate shareappdelegate].findViewController;
    
    [momentVC refreshMomentUI];
    
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //选择故事分类
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
            {
                [self.chooseStoryTypeBtn setTitle:@"因为爱情" forState:UIControlStateNormal];
                self.addMomentHttp.parameter.fid = @"1";
            }
                break;
            case 1:
            {
                [self.chooseStoryTypeBtn setTitle:@"青春、梦想、那些年" forState:UIControlStateNormal];
                self.addMomentHttp.parameter.fid = @"2";
            }
                break;
            case 2:
            {
                [self.chooseStoryTypeBtn setTitle:@"那些故事" forState:UIControlStateNormal];
                self.addMomentHttp.parameter.fid = @"3";
            }
                break;
                
            default:
                break;
        }

    }
    else {
        
        [self onPublishBtnClick:nil];
        
        switch (buttonIndex) {
            case 0:
            {
                //微信朋友圈
                
                WXMediaMessage *message = [WXMediaMessage message];
                
                message.title = FBIsEmpty(self.storyTitleTF.text) ? @"瞬间":self.storyTitleTF.text;
                message.description = FBIsEmpty(self.textView.text) ? @"我已经是个有“故事”的人了，跟我一起来打造属于我们的故事吧。上「瞬间」做个有故事的人！" : self.textView.text;
                [message setThumbImage:[UIImage imageNamed:@"icon"]];
                
                WXAppExtendObject *ext = [WXAppExtendObject object];
                
                ext.url = AppStoreDownloadUrl;
                
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneTimeline;
                
                [WXApi sendReq:req];
                
            }
                break;
            case 1:
            {
                //微信好友
                WXMediaMessage *message = [WXMediaMessage message];
                
                message.title = FBIsEmpty(self.storyTitleTF.text) ? @"瞬间":self.storyTitleTF.text;
                message.description = FBIsEmpty(self.textView.text) ? @"我已经是个有“故事”的人了，跟我一起来打造属于我们的故事吧。上「瞬间」做个有故事的人！" : self.textView.text;
                [message setThumbImage:[UIImage imageNamed:@"icon"]];
                
                WXAppExtendObject *ext = [WXAppExtendObject object];
                
                ext.url = AppStoreDownloadUrl;
                
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneSession;
                
                [WXApi sendReq:req];
                
            }
                break;
            case 2:
            {
                //微博分享
                
                WBMessageObject *message = [WBMessageObject message];
                
                
                WBWebpageObject *webpage = [WBWebpageObject object];
                webpage.objectID = self.addMomentHttp.resultModel.tid;
                webpage.title = self.storyTitleTF.text;
                webpage.description = self.textView.text;
                
                webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"theiconlogo@2x" ofType:@"png"]];
                webpage.webpageUrl = AppStoreDownloadUrl;
                message.mediaObject = webpage;
                
                message.text = @"我已经是个有“故事”的人了，跟我一起来打造属于我们的故事吧。上「瞬间」做个有故事的人！";
                
                
                MTAppDelegate *myDelegate =(MTAppDelegate*)[[UIApplication sharedApplication] delegate];
                
                WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
                authRequest.redirectURI = Weibo_RedirectURI;
                authRequest.scope = @"all";
                
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
                request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                     @"Other_Info_1": [NSNumber numberWithInt:123],
                                     @"Other_Info_2": @[@"obj1", @"obj2"],
                                     @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                [WeiboSDK sendRequest:request];
                
                
            }
                break;
            case 3:
            {
                //QQ好友
                
                NSString *utf8String = AppStoreDownloadUrl;
                NSString *title = self.storyTitleTF.text;
                NSString *description = self.textView.text;
                
                QQApiNewsObject *newsObj = [QQApiNewsObject
                                            objectWithURL:[NSURL URLWithString:utf8String]
                                            title:title
                                            description:description
                                            previewImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"theiconlogo@2x" ofType:@"png"]]];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
                //将内容分享到qq
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                //将内容分享到qzone
                //            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                [self handleSendResult:sent];
            }
                break;
                
            default:
                break;
        }

    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯文本分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯图片分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - Tencent Delegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    YHLog(@"请求回来的东西 openid %@ \n accessToken %@",_tencentOAuth.openId,_tencentOAuth.accessToken);
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
