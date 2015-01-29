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

@interface CatchMomentViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UploadPictureHttp *updatePicHttp;

@property (strong, nonatomic) NSMutableArray *images;   //存图片的数组


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
    self.images = [[NSMutableArray alloc] initWithCapacity:1];
    
    self.updatePicHttp = [[UploadPictureHttp alloc] init];
    
    [self.scrollView setContentSize:CGSizeMake([LXUtils GetScreeWidth] * 2, [LXUtils getContentViewHeight] - 120)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    //测试上传拼接的长图
//    [self uploadImage:nil];
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

- (void)updateUI
{
    for (int i = 0; i < [self.images count]; i ++) {
        UIImageView * imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake([LXUtils GetScreeWidth] * i,0 , [LXUtils GetScreeWidth], self.scrollView.frame.size.height);
        imgView.image = self.images[i];
        
        [self.scrollView addSubview:imgView];
        
    }
    
    self.scrollView.contentSize = CGSizeMake([LXUtils GetScreeWidth] *([self.images count] +1), self.scrollView.frame.size.height);
}


#pragma mark - IBAciton
- (IBAction)onNextBtnClick:(UIButton *)sender {

    /**
       先拼接长图，然后再上传，上传成功后，再跳转
     */
    if ([self.images count] < 1) {
        [self showWithText:@"请至少上传一张图片!"];
        return;
    }
    
    UIImage *uploadImage  = [self addImageWithImageArray:self.images];
    
    [self uploadImage: uploadImage];
    
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
    firstTF.center = self.scrollView.center;
    firstTF.textColor = [UIColor whiteColor];
    firstTF.text = @"此处文字可随意拖动!";

    [self.view addSubview:firstTF];

}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
   
    UIImage *rightImage = [LXUtils rotateImage:image];
    
    [self.images addObject:rightImage];
    
    [self updateUI];

    [picker dismissViewControllerAnimated:YES completion:nil];
   
}

/**
 *  把数组里的image拼接成长图
 *
 *  @param arr 装image的数组
 *
 *  @return 返回单张uiimage
 */
- (UIImage *)addImageWithImageArray:(NSMutableArray *)arr
{
    if ([arr count] < 1) {
        return nil;
    }
    
    UIImage *image1 = (UIImage *)arr[0];
    CGSize size= CGSizeMake([LXUtils GetScreeWidth],image1.size.height * [arr count]);
    UIGraphicsBeginImageContext(size);
    
    for (int i = 0; i< [arr count]; i ++) {
        UIImage *image = [[UIImage alloc] init];
        image = (UIImage *)arr[i];
        [image drawInRect:CGRectMake(0, image1.size.height * i, image1.size.width, image1.size.height)];
    }
    // Draw image1
//    [image2.image drawInRect:CGRectMake(0, 0, image1.frame.size.width, image1.frame.size.height)];
//    
//    // Draw image2
//    [image1.image drawInRect:CGRectMake(0, image1.frame.size.height, image2.frame.size.width, image2.frame.size.height)];
//    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

//- (UIImage *)addImage:(UIImageView *)image1 toImage:(UIImageView *)image2 {
//    CGSize size= CGSizeMake(image1.frame.size.width,image1.frame.size.height+image2.frame.size.height);
//    UIGraphicsBeginImageContext(size);
//    
//    // Draw image1
//    [image2.image drawInRect:CGRectMake(0, 0, image1.frame.size.width, image1.frame.size.height)];
//    
//    // Draw image2
//    [image1.image drawInRect:CGRectMake(0, image1.frame.size.height, image2.frame.size.width, image2.frame.size.height)];
//    
//    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return resultingImage;
//}

- (void)uploadImage:(UIImage *)rightImage
{
    self.updatePicHttp.parameter.image = rightImage;
    [self showLoadingWithText:MT_LOADING];
    __block CatchMomentViewController *weak_self = self;
    [self.updatePicHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.updatePicHttp.isValid)
        {
            
            if (weak_self.updatePicHttp.resultModel.avatar) {
                
                EditStoryViewController *editVC = [[EditStoryViewController alloc] init];
                editVC.hidesBottomBarWhenPushed = YES;
                
                editVC.imageIds = [NSMutableArray arrayWithArray:@[self.updatePicHttp.resultModel.avatar]];
                
                [weak_self.navigationController pushViewController:editVC animated:YES];

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
