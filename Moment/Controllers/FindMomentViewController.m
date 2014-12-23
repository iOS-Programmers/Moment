//
//  FindMomentViewController.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "FindMomentViewController.h"
#import "FindMomentCell.h"
#import "FindDetailViewController.h"

#import "MomentListHttp.h"

#import "MWPhotoBrowser.h"

@interface FindMomentViewController () <MWPhotoBrowserDelegate>

@property (strong, nonatomic) MomentListHttp *momentHttp;

//装图片的数组
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation FindMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发现瞬间";
    self.momentHttp = [[MomentListHttp alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    
    self.tableView.rowHeight = 118;
    
    [self requestMomentList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLCOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMomentList
{
    self.momentHttp.parameter.fid = @"0";
    self.momentHttp.parameter.pagesize = @"10";
    
    
    [self showLoadingWithText:MT_LOADING];
    __weak FindMomentViewController *weak_self = self;
    [self.momentHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.momentHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self updateMomentListWithInfo:weak_self.momentHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.momentHttp.erorMessage];
        };
    }failedBlock:^{
        [weak_self hideLoading];
        
        if (![LXUtils networkDetect])
        {
            [weak_self showWithText:MT_CHECKNET];
        }
        else
        {
            //统统归纳为服务器出错
            [weak_self showWithText:MT_NETWRONG];
        };
    }];
}

/**
 *  更新界面信息
 *
 *  @param infoArray 列表数组
 */
- (void)updateMomentListWithInfo:(NSMutableArray *)infoArray
{
    if (!FBIsEmpty(infoArray)) {
        self.dataSource = infoArray;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FindMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"FindMomentCell" owner:self options:nil];
        for (id oneObject in cellNib)
        {
            if ([oneObject isKindOfClass:[FindMomentCell class]])
            {
                cell = (FindMomentCell *)oneObject;
            }
        }
    }
    
    MomentDetail *detail = (MomentDetail *)self.dataSource[indexPath.row];
    
    [cell updateMomentCellWithInfo:detail];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    FindDetailViewController *detail = [[FindDetailViewController alloc] init];
//    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
    
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;

    photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"photo1.jpg"]];
    photo.caption = @"党培养一个干部特别是高级干部是很不容易的。这些年，一些干部包括一些相当高层次的领导干部因违犯党纪国法落马，我们很痛心。我们中央的同志说起这些事都很痛心，都有一种恨铁不成钢的感觉。";
    [photos addObject:photo];
    photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"photo2.jpg"]];
    photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
    [photos addObject:photo];
    photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"photo3.jpg"]];
    photo.caption = @"“党内决不能搞封建依附那一套，决不能搞小山头、小圈子、小团伙那一套，决不能搞门客、门宦、门附那一套，搞这种东西总有一天会出事！有的案件一查处就是一串人，拔出萝卜带出泥，其中一个重要原因就是形成了事实上的人身依附关系。在党内，所有党员都应该平等相待，都应该平等享有一切应该享有的权利、履行一切应该履行的义务。”";
    [photos addObject:photo];
    photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"photo4.jpg"]];
    photo.caption = @"Campervan";
    [photos addObject:photo];
    
    
    self.photos = photos;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = displayActionButton;
//    browser.displayNavArrows = displayNavArrows;
//    browser.displaySelectionButtons = displaySelectionButtons;
//    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
//    browser.enableGrid = enableGrid;
//    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


@end
