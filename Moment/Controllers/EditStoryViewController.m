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

@interface EditStoryViewController () <UITextViewDelegate>

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

#pragma mark - IBAction
- (IBAction)onChooseStoryTypeClick:(id)sender {
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
        [self showWithText:@"您未上传任何图片"];
        return;
    }
    
    self.addMomentHttp.parameter.pictureurls = [self.imageIds componentsJoinedByString:@","];
    
    self.addMomentHttp.parameter.fid = @"2";
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

- (IBAction)onPublishAndShareBtnClick:(UIButton *)sender {
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
@end
