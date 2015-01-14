//
//  MTEditTextViewController.m
//  Moment
//
//  Created by Jyh on 1/14/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "MTEditTextViewController.h"

@interface MTEditTextViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MTEditTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar];
    self.title = self.titleStr;
    if (self.titleStr.length>0)
    {
        self.textField.placeholder = self.titleStr;
        
    }
    [self.textField becomeFirstResponder];
//    switch (self.titleType) {
//        case 4:
//            self.textField.keyboardType = UIKeyboardTypeNumberPad;//数字键盘
//            break;
//        case 1:
//            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//电话键盘
//            break;
//        case 2:
//            self.textField.keyboardType = UIKeyboardTypeNamePhonePad;//邮箱键盘
//            break;
//        case 3:
//        {   self.textField.keyboardType = UIKeyboardTypeNumberPad;//数字键盘
//            self.textField.secureTextEntry = YES;//密码类型
//        }
//            break;
//            
//        default:
//            self.textField.keyboardType = UIKeyboardTypeDefault;//默认键盘
//            break;
//    }
}

- (void)setNavBar
{
    
    UIImage *backImage = [UIImage imageNamed:@"back"];
    UIImage *backImageH = [UIImage imageNamed:@"back"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0.0f, 0.0f, backImage.size.width, backImage.size.height);
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn setImage:backImageH forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    rightBtn.frame = CGRectMake(0.0f, 0.0f, 50, 30);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)dismiss
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未保存！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alert show];
    
}

- (void)setBackBlock:(EditBackBlock)block
{
    backBlock = [block copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark -
# pragma mark - Action
- (IBAction)saveAction
{
    __weak MTEditTextViewController *weak_self = self;
    if (backBlock)
    {
        backBlock(weak_self.textField.text);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    
    [self.textField resignFirstResponder];
}

# pragma mark -
# pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //yes
        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    }
}

@end
