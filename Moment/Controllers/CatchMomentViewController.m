//
//  CatchMomentViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CatchMomentViewController.h"
#import "EditStoryViewController.h"

#import "UploadPictureHttp.h"
#import "AdMomentHttp.h"

@interface CatchMomentViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UploadPictureHttp *updatePicHttp;
@property (strong, nonatomic) AdMomentHttp *addMomentHttp;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *imageIds;   //存图片ID的数组


- (IBAction)onNextBtnClick:(UIButton *)sender;

- (IBAction)onPhotoAlbumClick:(UIButton *)sender;
- (IBAction)onCameraClick:(id)sender;
- (IBAction)onFontClick:(id)sender;
- (IBAction)onLabelClick:(UIButton *)sender;


@end

@implementation CatchMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"抓住瞬间";
    self.imageIds = [[NSMutableArray alloc] initWithCapacity:1];
    
    self.updatePicHttp = [[UploadPictureHttp alloc] init];
    self.addMomentHttp = [[AdMomentHttp alloc] init];
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

#pragma mark - RequestMethod

- (void)addMomentRequest
{
    self.addMomentHttp.parameter.fid = @"2";
    self.addMomentHttp.parameter.title = @"重大消息！阿里巴巴收购腾讯！！！！";
    self.addMomentHttp.parameter.content = @"阿里巴巴在昨晚宣布，收购腾讯百分之八十的股权，这在历史上是前无古人后无来者的，同时马化腾成为马云的手下。";

    [self showLoadingWithText:MT_LOADING];
    __block CatchMomentViewController *weak_self = self;
    [self.addMomentHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.addMomentHttp.isValid)
        {
            [weak_self showWithText:@"发布成功"];
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

#pragma mark - IBAciton
- (IBAction)onNextBtnClick:(UIButton *)sender {

    EditStoryViewController *editVC = [[EditStoryViewController alloc] init];
    editVC.hidesBottomBarWhenPushed = YES;
    
    editVC.imageIds = self.imageIds;
    
    [self.navigationController pushViewController:editVC animated:YES];
}


/**
 *  点击相册按钮
 *
 *  @param sender
 */
- (IBAction)onPhotoAlbumClick:(UIButton *)sender {

    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

/**
 *  点击相机按钮
 *
 *  @param sender
 */
- (IBAction)onCameraClick:(id)sender {
    
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

/**
 *  点击更换字体按钮
 *
 *  @param sender
 */
- (IBAction)onFontClick:(id)sender {
}

/**
 *  点击添加Label按钮
 *
 *  @param sender
 */
- (IBAction)onLabelClick:(UIButton *)sender {

    UITextField *firstTF = [[UITextField alloc] init];
    firstTF.frame = CGRectMake(0, 0, 200, 40);
    firstTF.center = self.imageView.center;
    firstTF.textColor = [UIColor whiteColor];
    firstTF.text = @"此处文字可随意拖动!";

    [self.view addSubview:firstTF];

}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
   
    UIImage *rightImage = [LXUtils rotateImage:image];

    [picker dismissViewControllerAnimated:YES completion:nil];
    self.updatePicHttp.parameter.image = rightImage;
    [self showLoadingWithText:MT_LOADING];
    __block CatchMomentViewController *weak_self = self;
    [self.updatePicHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.updatePicHttp.isValid)
        {
            
            if (weak_self.updatePicHttp.resultModel.avatar) {
                
                if (![weak_self.imageIds containsObject:weak_self.updatePicHttp.resultModel.avatar]) {
                    [weak_self.imageIds addObject:weak_self.updatePicHttp.resultModel.avatar];
                }

                if ([weak_self.imageIds count] > 0) {
                    weak_self.addMomentHttp.parameter.pictureurls = [weak_self.imageIds componentsJoinedByString:@","];
                }
                
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,weak_self.updatePicHttp.resultModel.avatar]]];
            }
            
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
@end
