//
//  UserGuideViewController.m
//  SeekU
//
//  Created by Jyh on 13-5-13.
//
//

#import "UserGuideViewController.h"
#import "LoginViewController.h"
#import "YHBaseNavigationController.h"

#define PageCount 3

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLCOR;
    [self initGuide];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
}
- (void)initGuide
{
    
    guideScr = [[UIScrollView alloc]init];
    guideScr.delegate = self;
    [guideScr setFrame:CGRectMake(0, 0, [LXUtils GetScreeWidth], [LXUtils GetScreeHeight] + 20)];
    [guideScr setContentSize:CGSizeMake([LXUtils GetScreeWidth] * PageCount, [LXUtils GetScreeHeight] + 20)];
    [guideScr setPagingEnabled:YES];
    [guideScr setShowsHorizontalScrollIndicator:NO];
    [guideScr setBackgroundColor:[UIColor blackColor]];
    
    pageControl = [[UIPageControl alloc]init];
    [pageControl setFrame:CGRectMake(0, [LXUtils GetScreeHeight] - 15, 320, 10)];
    [pageControl setNumberOfPages:PageCount];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(changePage:)
                forControlEvents:UIControlEventValueChanged];
    
    for (int i = 0; i< PageCount; i++)
    {
        UIImageView *img = [[UIImageView alloc]init];
        [img setFrame:CGRectMake(i *[LXUtils GetScreeWidth], 0, [LXUtils GetScreeWidth], [LXUtils GetScreeHeight] + 20)];
        
        if (INCH4)
        {
            if (i == 0) {
                [img setImage:[UIImage imageNamed:@"1-640x1136"]];
            }
            else if (i == 1){
                [img setImage:[UIImage imageNamed:@"2-640x1136"]];
            }
            else if (i == 2){
                [img setImage:[UIImage imageNamed:@"3-640x1136"]];
            }

        }
        
        else
        {
            if (i == 0) {
                [img setImage:[UIImage imageNamed:@"1-640x960"]];
            }
            else if (i == 1){
                [img setImage:[UIImage imageNamed:@"2-640x960"]];
            }
            else if (i == 2){
                [img setImage:[UIImage imageNamed:@"3-640x960"]];
            }
        }
        
        img.tag = i;
        [guideScr addSubview:img];

    }
    [self.view addSubview:guideScr];
    [self.view addSubview:pageControl];

    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setTitleNH:@"登录"];
    btnLogin.showsTouchWhenHighlighted = YES;
    [btnLogin setFrame:CGRectMake(50, [LXUtils GetScreeHeight] - 67, 220, 35)];
    btnLogin.backgroundColor = [UIColor clearColor];
    btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    btnLogin.layer.borderWidth = 1;

    [btnLogin addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *image = (UIImageView *)[guideScr viewWithTag:2];
    
    if (image.tag == 2)
    {
        [image setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Login)];
        [image addGestureRecognizer:tap];
        [image addSubview:btnLogin];
    }
    

    
}
- (void)Login
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    YHBaseNavigationController *loginNav = [[YHBaseNavigationController alloc] initWithRootViewController:loginViewController];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    [self presentViewController:loginNav animated:YES completion:^{
        
    }];
}

//scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //通过滚动的偏移量来判断目前页面所对应的小白点
    int page = guideScr.contentOffset.x / 290;
    
    pageControl.currentPage = page;
    
}

- (void)changePage:(id)sender
{
    NSInteger page = pageControl.currentPage;

    [guideScr setContentOffset:CGPointMake([LXUtils GetScreeWidth] * page, 0)animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
