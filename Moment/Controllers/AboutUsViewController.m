//
//  AboutUsViewController.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *desTextView;
@property (weak, nonatomic) IBOutlet UILabel *versonLabel;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    /**
     *  CFBundleShortVersionString  是取得版本号
     *  CFBundleVersion             是取的Build号
     *  不可混用，切记切记
     */
    NSString *currentVersion = infoDict[@"CFBundleShortVersionString"];
    
    self.versonLabel.text = [NSString stringWithFormat:@"当前版本号：%@ ",currentVersion];

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

@end
