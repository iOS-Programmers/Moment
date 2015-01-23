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

@interface FindDetailViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIView *moreView;

- (IBAction)onCommentBtnClick:(UIButton *)sender;
- (IBAction)onShareBtnClick:(UIButton *)sender;
@end

@implementation FindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故事";
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [self findDetailrightNavItem];
    
    if ([self.momentInfo.pictureurls count] > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,(NSString *)self.momentInfo.pictureurls[0]]]];
    }
    
    [self.moreView frameSetPoint:CGPointMake(([LXUtils GetScreeWidth] - CGRectGetWidth(self.moreView.frame) - 10), 0)];
    self.moreView.hidden = YES;
    [self.view addSubview:self.moreView];
    
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

        }
            break;
        case 3:
        {
            //QQ好友
        }
            break;
            
        default:
            break;
    }
}


@end
