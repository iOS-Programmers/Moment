//
//  SGFocusImageFrame.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import <objc/runtime.h>

#pragma mark - SGFocusImageItem Definition
@implementation SGFocusImageItem
- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    return self;
}
+ (id)itemWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    return [[SGFocusImageItem alloc] initWithTitle:title image:image tag:tag];
}
@end

#pragma mark - SGFocusImageFrame Definition

@interface SGFocusImageFrame ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

- (void)setupViews;
- (void)switchFocusImageItems;
@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"com.touchmob.sgfocusitems";
static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time  默认的轮播时间

@implementation SGFocusImageFrame

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItemsArrray:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, items, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = delegate;
        [self initImageFrame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];  
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {                                  
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);       
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];            
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.delegate = delegate;
        [self initImageFrame];
    }
    return self;
}

- (void)dealloc
{
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (void)initImageFrame
{
    [self initParameters];
    [self setupViews];
}
#pragma mark - private methods
- (void)initParameters
{
    self.switchTimeInterval = SWITCH_FOCUS_PICTURE_INTERVAL;
    self.autoScrolling = YES;
}
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    CGFloat mainWidth = self.frame.size.width, mainHeight = self.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, mainWidth, mainHeight)];
    
    CGSize size = CGSizeMake(100, 20);

    CGRect pcFrame = CGRectMake(self.bounds.size.width *.5 - size.width *.5 + 118, self.bounds.size.height - size.height, size.width, size.height);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pcFrame];
    [pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventTouchUpInside];
   
    [self addSubview:scrollView];
    [self addSubview:pageControl];
    
    /*
    scrollView.layer.cornerRadius = 10;
    scrollView.layer.borderWidth = 1 ;
    scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
    */
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    pageControl.numberOfPages = imageItems.count;
    pageControl.currentPage = 0;
    
    scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:tapGestureRecognize];
    
    CGSize scrollViewSize = scrollView.frame.size;
    scrollView.contentSize = CGSizeMake(scrollViewSize.width * imageItems.count, scrollViewSize.height);
    for (int i = 0; i < imageItems.count; i++) {
        SGFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height)];
        imageView.image = item.image;
        
        //黑色背景
        UIImageView *bannerBG = [[UIImageView alloc]init];
        bannerBG.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        bannerBG.frame = CGRectMake(i * scrollViewSize.width, scrollViewSize.height-20, scrollViewSize.width, 20);
        
        //广告条上的字
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];

        label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10.0f];
        label.text = item.title;

        CGFloat constrainedSize = 245.0f;
        CGSize textSize = [item.title sizeWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10.0f] constrainedToSize:CGSizeMake(constrainedSize, 12.0f) lineBreakMode:NSLineBreakByCharWrapping];
        label.frame = CGRectMake(i*scrollViewSize.width +10, scrollViewSize.height - 15, textSize.width, textSize.height);
        
        [scrollView addSubview:imageView];
//        [scrollView addSubview:bannerBG];
//        [scrollView addSubview:label];

    }
    
    self.scrollView = scrollView;
    self.pageControl = pageControl;
}

#pragma mark - Actions
//点击pageController时候的操作 
- (IBAction)pageControlTapped:(id)sender
{
    UIPageControl *pc = (UIPageControl *)sender;
    [self moveToTargetPage:pc.currentPage];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    int targetPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if (targetPage > -1 && targetPage < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:targetPage];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
}

#pragma mark - ScrollView Move
//要move到得页码
- (void)moveToTargetPage:(NSInteger)targetPage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    CGFloat targetX = targetPage * self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
}

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    if (self.autoScrolling) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}

//设置滚动轮播要滚动到得位置
- (void)moveToTargetPosition:(CGFloat)targetX
{
    //NSLog(@"moveToTargetPosition : %f" , targetX);
    if (targetX >= self.scrollView.contentSize.width) {
        targetX = 0.0;
    }
    
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    self.pageControl.currentPage = (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
}

- (void)setAutoScrolling:(BOOL)enable
{
    _autoScrolling = enable;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_autoScrolling) {
         [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:self.switchTimeInterval];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

@end
