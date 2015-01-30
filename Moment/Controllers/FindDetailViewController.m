//
//  FindDetailViewController.m
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "FindDetailViewController.h"
#import "AllCommentListViewController.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface FindDetailViewController () <UIActionSheetDelegate,TencentSessionDelegate,UIScrollViewDelegate>
{
    TencentOAuth *_tencentOAuth;
    
    NSMutableArray* _permissions;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) IBOutlet UIView *moreView;

- (IBAction)onCommentBtnClick:(UIButton *)sender;
- (IBAction)onShareBtnClick:(UIButton *)sender;
@end

@implementation FindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故事";
    
    //腾讯相关
    _permissions = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:
                                                   kOPEN_PERMISSION_GET_USER_INFO,
                                                   kOPEN_PERMISSION_ADD_SHARE,
                                                   
                                                   nil]];
    
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID
                                            andDelegate:self];

    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [self findDetailrightNavItem];
    
    if ([self.momentInfo.pictureurls count] > 0) {

        [self.imageView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,(NSString *)self.momentInfo.pictureurls[0]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat width;
            CGFloat height;
            if (image.size.width > [LXUtils GetScreeWidth]) {
                width = [LXUtils GetScreeWidth];
                height = image.size.height/(image.size.width/[LXUtils GetScreeWidth]);
            }
            else {
                width = image.size.width;
                height = image.size.height;
            }
            self.imageView.frame = CGRectMake(0, 0, width, height);
        }];
        
        [self.scrollView setContentSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)];
        self.scrollView.backgroundColor = [UIColor blackColor];
    }
    
    [self.moreView frameSetPoint:CGPointMake(([LXUtils GetScreeWidth] - CGRectGetWidth(self.moreView.frame) - 10), 0)];
    self.moreView.hidden = YES;
    [self.view addSubview:self.moreView];
    
    
    self.contentTextView.text = self.momentInfo.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)findDetailrightNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.0f, 0.0f, 35, 35);
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = YES;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(findDetailrightItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn showsTouchWhenHighlighted];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

/**
 *  显示更多选项View
 */
- (void)findDetailrightItemClick
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.moreView setHidden:!self.moreView.hidden];
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

- (IBAction)onCommentBtnClick:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.moreView setHidden:!self.moreView.hidden];
    }];

    //点击评论列表
    AllCommentListViewController *listVC = [[AllCommentListViewController alloc] init];
    listVC.tid = self.momentInfo.tid;
    listVC.fid = self.momentInfo.fid;
    
    [self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)onShareBtnClick:(UIButton *)sender {

    [UIView animateWithDuration:0.3 animations:^{
        [self.moreView setHidden:!self.moreView.hidden];
    }];
    
    //点击分享
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"微信朋友圈",@"微信好友",@"新浪微博",@"QQ好友", nil];
    [action  showInView:self.view];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView setHidden:YES];
    }];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.contentView setHidden:NO];
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //微信朋友圈
            
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = FBIsEmpty(self.momentInfo.title) ? @"瞬间":self.momentInfo.title;
            message.description = FBIsEmpty(self.momentInfo.content) ? @"我已经是个有“故事”的人了，跟我一起来打造属于我们的故事吧。上「瞬间」做个有故事的人！" : self.momentInfo.content;
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
            
            message.title = FBIsEmpty(self.momentInfo.title) ? @"瞬间":self.momentInfo.title;
            message.description = FBIsEmpty(self.momentInfo.content) ? @"我已经是个有“故事”的人了，跟我一起来打造属于我们的故事吧。上「瞬间」做个有故事的人！" : self.momentInfo.content;
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
            webpage.objectID = self.momentInfo.tid;
            webpage.title = self.momentInfo.title;
            webpage.description = self.momentInfo.content;

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
            NSString *title = self.momentInfo.title;
            NSString *description = self.momentInfo.content;

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
