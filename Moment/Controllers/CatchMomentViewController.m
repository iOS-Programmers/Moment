//
//  CatchMomentViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CatchMomentViewController.h"
#import "EditStoryViewController.h"

#import "wiUIImage+Category.h"
#import "wiUIImageView+Category.h"
#import "UploadPictureHttp.h"

#define kFontOneName   @"DFGirl-Kelvin"
#define kFontTwoName   @"QXyingbikai"
#define kFontThreeName   @"Arial-BoldMT"

#define FontSize  20

#define kBtnTag   100

@interface CatchMomentViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UITextField *textField;   //编辑文字的TF
    UIButton *labelBtn1;
    int fontIndex;            //记录字体的index
    NSInteger currentPage;          //当前第几页,从0开始
    NSString *currentText;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//第一次的遮罩层
@property (strong, nonatomic) IBOutlet UIControl *coverControl;
@property (strong, nonatomic) UploadPictureHttp *updatePicHttp;

@property (strong, nonatomic) NSMutableArray *images;   //存图片的数组

@property (strong, nonatomic) NSMutableArray *imageURLs;   //存图片地址的数组

@property (strong, nonatomic) NSMutableArray *labelFonts;   //存字体名称的数组


@property (strong, nonatomic) NSMutableArray *labelInfos;   //存每页文字的信息，包括文字，字体，坐标point值

//页码
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

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
    self.imageURLs = [[NSMutableArray alloc] initWithCapacity:1];
    self.labelFonts = [NSMutableArray arrayWithArray:@[kFontOneName,kFontTwoName,kFontThreeName]];
    
    self.labelInfos = [NSMutableArray arrayWithObjects:
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],
                       [NSMutableDictionary dictionaryWithDictionary:@{@"text":@"",@"font":@"",@"point":@""}],nil];
    fontIndex = 0;
    currentPage = 0;
    
    self.updatePicHttp = [[UploadPictureHttp alloc] init];
    
    [self.scrollView setContentSize:CGSizeMake([LXUtils GetScreeWidth] * 2, 0)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onDeleteAllImageItemClick:)];
    self.navigationItem.rightBarButtonItem = deleteItem;

    //添加遮罩层
    self.coverControl.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.coverControl addTarget:self action:@selector(hideControl) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.coverControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.scrollView addGestureRecognizer:tap];
    
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

- (void)endEdit
{
    [self.scrollView endEditing:YES];
}

- (void)hideControl
{
    [self.coverControl setHidden:YES];
}

- (void)updateUI
{
 
    if ([self.images count] > 9) {
        [self showWithText:@"最多只能上传9张照片"];
        return;
    }
    
    [self.scrollView removeAllSubview];
    for (int i = 0; i < [self.images count]; i ++) {
        //创建图片
        UIImageView * imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake([LXUtils GetScreeWidth] * i,0 , [LXUtils GetScreeWidth], self.scrollView.frame.size.height);
        imgView.image = self.images[i];
        
        [self.scrollView addSubview:imgView];
        
        //创建删除按钮
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = i;
        deleteBtn.frame = CGRectMake([LXUtils GetScreeWidth] * i + 270, 10, 40, 40);
        [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(onDeleteImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:deleteBtn];
        
        //创建文字button
        if ([self.labelInfos count] <= i) {
            return;
        }
        NSMutableDictionary *tempDic = (NSMutableDictionary *)self.labelInfos[i];
       
        if (!FBIsEmpty(tempDic[@"text"])) {
            UIButton * labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            labelBtn.frame = CGRectMake(20+ i*[LXUtils GetScreeWidth], 100, 300, 60);
            labelBtn.center = CGPointFromString(tempDic[@"point"]);
            
            labelBtn.backgroundColor = [UIColor clearColor];
            labelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            labelBtn.tag = kBtnTag + i;
            [labelBtn setTitle:tempDic[@"text"] forState:UIControlStateNormal];
            
            labelBtn.titleLabel.font = [UIFont fontWithName:tempDic[@"font"] size:FontSize];
            [labelBtn addTarget:self action:@selector(onTapLabel:) forControlEvents:UIControlEventTouchUpInside];
            
            [labelBtn addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
            [labelBtn addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
            [labelBtn addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents:
             UIControlEventTouchUpInside |
             UIControlEventTouchUpOutside];
            
            [self.scrollView addSubview:labelBtn];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake([LXUtils GetScreeWidth] *([self.images count] +1), 0);
    if ([self.images count] == 0) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    else {
        self.scrollView.contentOffset = CGPointMake([LXUtils GetScreeWidth] *([self.images count] -1), 0);
    }
}


#pragma mark - IBAciton
- (IBAction)onNextBtnClick:(UIButton *)sender {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是否还要继续添加图片？" delegate:self cancelButtonTitle:@"继续添加" otherButtonTitles:@"现在发布", nil];
    [alert show];

}


/**
 *  导航右上角的删除按钮
 *
 *  @param sender
 */
- (void)onDeleteAllImageItemClick:(id)sender
{
    //点击后跳出提示，是否放弃本次编辑
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除本次添加所有图片？" delegate:self cancelButtonTitle:@"暂不删除" otherButtonTitles:@"确认删除", nil];
    alert.tag = 1;
    [alert show];
    
}

- (void)onDeleteImageClick:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    if ([self.images count] > tag) {
        [self.images removeObjectAtIndex:tag];
    }
    
    [self updateUI];
}

/**
 *  点击相册按钮
 *
 *  @param sender
 */
- (IBAction)onPhotoAlbumClick:(UIButton *)sender {
    
    if ([self.images count] >= 9) {
        [self showWithText:@"最多只能上传9张照片"];
        return;
    }

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

    if ([self.images count] >= 9) {
        [self showWithText:@"最多只能上传9张照片"];
        return;
    }
    
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
    
    if (fontIndex == 3) {
        fontIndex = 0;
    }
    
    for (id view in [self.scrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag ==  currentPage + kBtnTag) {
                btn.titleLabel.font = [UIFont fontWithName:self.labelFonts[fontIndex] size:FontSize];

                NSMutableDictionary *tempDic = (NSMutableDictionary *)self.labelInfos[currentPage];
                tempDic[@"font"] = self.labelFonts[fontIndex];
            }
        }
    }
    
    
    fontIndex ++;
}

/**
 *  点击添加Label按钮,每张图片都可以添加button
 *
 *  @param sender
 */
- (IBAction)onLabelClick:(UIButton *)sender {
    

    NSLog(@"curentPage----%ld",currentPage);
    //创建前判断当前页是否已经有labelbutton
    for (id view in [self.scrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag ==  currentPage + kBtnTag) {
                return;
            }
        }
    }
    
    UIButton * labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    labelBtn.frame = CGRectMake(20+ currentPage*[LXUtils GetScreeWidth], 100, 300, 60);
    labelBtn.backgroundColor = [UIColor clearColor];
    labelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    labelBtn.tag = kBtnTag + currentPage;
    [labelBtn setTitle:@"此处文字可随意拖动" forState:UIControlStateNormal];
    
    if (fontIndex > 2) {
        fontIndex = 2;
    }
    labelBtn.titleLabel.font = [UIFont fontWithName:self.labelFonts[fontIndex] size:FontSize];
    [labelBtn addTarget:self action:@selector(onTapLabel:) forControlEvents:UIControlEventTouchUpInside];

    [labelBtn addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
    [labelBtn addTarget:self action:@selector(dragMoving:withEvent: )forControlEvents: UIControlEventTouchDragInside];
    [labelBtn addTarget:self action:@selector(dragEnded:withEvent: )forControlEvents:
     UIControlEventTouchUpInside |
     UIControlEventTouchUpOutside];
    
    [self.scrollView addSubview:labelBtn];
    
    

}

- (void) dragBegan:(UIControl *)c withEvent:ev
{
    NSLog(@"Button  moving bagin .....%@",NSStringFromCGPoint(c.center));
//    isMoving = YES;

    
}
- (void)dragMoving:(UIControl *)c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.scrollView];
    NSLog(@"Button  moving  ......%@",NSStringFromCGPoint(c.center));
}

- (void)dragEnded:(UIControl *)c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.scrollView];
//    isMoving = NO;

    NSLog(@"Button  end moving .....%@",NSStringFromCGPoint(c.center));
}

- (void)onTapLabel:(UIButton *)labelbtn
{
//    if ( isMoving) {
//        return;
//    }
    //点击label，跳出textfeild修改label
    if (!textField) {
        textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeAlways;

    }
    
    textField.frame = CGRectMake(0, 0, 280, 35);
    textField.center = self.scrollView.center;
    
    [textField becomeFirstResponder];
    [self.view addSubview:textField];
    
    
    //创建前判断当前页是否已经有labelbutton
    for (id view in [self.scrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag ==  currentPage + kBtnTag) {
                textField.placeholder = btn.titleLabel.text;
            }
        }
    }
    
    NSString *point = NSStringFromCGPoint(labelbtn.center);
    
    NSMutableDictionary *tempDic = (NSMutableDictionary *)self.labelInfos[currentPage];
    tempDic[@"point"] = point;
}

#pragma mark -  UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)atextField{
    
    //创建前判断当前页是否已经有labelbutton
    for (id view in [self.scrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag ==  currentPage + kBtnTag) {
                if ([textField.text length] > 0) {
                    [btn setTitle:textField.text forState:UIControlStateNormal];
                }
            }
        }
    }
    
    if ([textField.text length] > 0) {
        currentText = textField.text;
        NSMutableDictionary *tempDic = (NSMutableDictionary *)self.labelInfos[currentPage];
        tempDic[@"text"] = currentText;
        if (fontIndex > 2) {
            fontIndex = 2;
        }
        tempDic[@"font"] = self.labelFonts[fontIndex];
    }
    
    
    [atextField resignFirstResponder];
    [textField frameSetY:[LXUtils getContentViewHeight]];
    return YES;

}

#pragma mark Keyboard

-(void)keyboardWillShow:(NSNotification*)notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = [value CGRectValue].size.height;
    if (keyboardHeight == 184) {
        keyboardHeight = 252;
    }
    
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationCurve:[curve intValue]];
        [textField frameSetY:[LXUtils getContentViewHeight] - keyboardHeight - CGRectGetHeight(textField.frame) ];
        textField.text = @"";
    }];

}

-(void)keyboardWillHide:(NSNotification*)notif
{
    [textField frameSetY:[LXUtils getContentViewHeight]];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger thecurrentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    currentPage = thecurrentPage;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / 9", currentPage + 1];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //提示是否删除所有图片
    if (alertView.tag == 1) {
        
        if (buttonIndex == 1) {
            //清空
            [self.images removeAllObjects];
            [self.imageURLs removeAllObjects];
            
            [self updateUI];
        }
    }
    else {
        if (buttonIndex == 0) {
            //上传图片
        }
        if (buttonIndex == 1) {
            //暂不上传
            /**
             先拼接长图，然后再上传，上传成功后，再跳转
             */
            if ([self.images count] < 1) {
                [self showWithText:@"请至少上传一张图片!"];
                return;
            }
            
            UIImage *uploadImage  = [self addImageWithImageArray:self.images];
            
            [self uploadImage: uploadImage andPublish:YES];
            
        }
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
   
    UIImage *rightImage = [LXUtils rotateImage:image];
    
    [self.images addObject:rightImage];
    //上传第一张图片作为封面图
    if ([self.images count] == 1) {
        [self uploadImage:rightImage andPublish:NO];
    }
    
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
    CGSize size= CGSizeMake(image1.size.width,image1.size.height * [arr count]);
    UIGraphicsBeginImageContext(size);
    

    for (int i = 0; i< [arr count]; i ++) {
        UIImage *image = [[UIImage alloc] init];
        image = (UIImage *)arr[i];
        if (fontIndex > 2) {
            fontIndex = 2;
        }
        
        CGPoint btnPoint;
        for (id view in [self.scrollView subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                if (btn.tag ==  i + kBtnTag) {
                    
                    //计算字体应该所在的point
                    NSUInteger length = btn.titleLabel.text.length;
                    length = length/2*20;
                    
                    //坐标是按照320取值的，但是截图按照640来截图的，所以要乘以2
                    btnPoint = CGPointMake((btn.center.x - length -[LXUtils GetScreeWidth]*i)*2, (btn.center.y-20)*2);

                    //强制处理负坐标情况
                    if (btnPoint.x < 0) {
                        btnPoint.x = 0;
                    }
//                    YHLog(@"标题的长度是 %ld",[btn.titleLabel.text length]);
//                    YHLog(@"打印出来的坐标是 %@",NSStringFromCGPoint(btnPoint));
                }
            }
        }
        
        NSMutableDictionary *tempDic = (NSMutableDictionary *)self.labelInfos[i];
        CGPoint point = CGPointFromString(tempDic[@"point"]);
        
        image = [image imageWithStringWaterMark:tempDic[@"text"] atPoint:point color:[UIColor whiteColor] font:[UIFont fontWithName:tempDic[@"font"] size:FontSize*2]];
        [image drawInRect:CGRectMake(0, image1.size.height * i, image1.size.width, image1.size.height)];
    
    }


    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


/**
 *  上传并且发布
 *
 *  @param rightImage 图片
 *  @param isPublish  判断是否要发布
 */
- (void)uploadImage:(UIImage *)rightImage andPublish:(BOOL)isPublish
{
    self.updatePicHttp.parameter.image = rightImage;
    [self showLoadingWithText:MT_LOADING];
    __block CatchMomentViewController *weak_self = self;
    [self.updatePicHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.updatePicHttp.isValid)
        {
            
            if (weak_self.updatePicHttp.resultModel.avatar) {
                
                [self.imageURLs addObject:weak_self.updatePicHttp.resultModel.avatar];
                
                
                if (isPublish) {
                    //发布成功后，要移除本地的数据
                    //清空
                    
                    EditStoryViewController *editVC = [[EditStoryViewController alloc] init];
                    editVC.hidesBottomBarWhenPushed = YES;
                    
                    editVC.imageIds = [self.imageURLs copy];
                    
                    [self.images removeAllObjects];
                    [self.imageURLs removeAllObjects];
                    [self.labelInfos removeAllObjects];
                    
                    [self updateUI];
                    
                    [weak_self.navigationController pushViewController:editVC animated:YES];
                }
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
