//
//  AllCommentListViewController.m
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AllCommentListViewController.h"
#import "CommentCell.h"
#import "CommentListHttp.h"
#import "AddCommentHttp.h"
#import "PlacehoderTextView.h"

@interface AllCommentListViewController () <UITextViewDelegate>

@property (strong, nonatomic) CommentListHttp *commentListHttp;
@property (strong, nonatomic) AddCommentHttp *addCommentHttp;

/*******评论View*********/
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet PlacehoderTextView *CommentTextView;

//点击评论Btn
- (IBAction)onCommentBtnClick:(UIButton *)sender;

- (IBAction)onCancleBtnClick:(UIButton *)sender;
- (IBAction)onSendBtnClick:(UIButton *)sender;

@end

@implementation AllCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"评论";
    self.commentListHttp = [[CommentListHttp alloc] init];
    self.addCommentHttp = [[AddCommentHttp alloc] init];
    
    self.CommentTextView.placeholder = @"我来说两句...";
    
    [self requestStoryCommentList];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 120;
    self.tableView.frame = CGRectMake(0, 0, [LXUtils GetScreeWidth], [LXUtils getContentViewHeight] +20);
    self.tableView.separatorColor = [UIColor clearColor];
    
    //设置评论View的默认位置
    self.commentView.frame = CGRectMake(0, [LXUtils GetScreeHeight], [LXUtils GetScreeWidth], CGRectGetHeight(self.commentView.frame));
    [self.view addSubview:self.commentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)requestStoryCommentList
{
    if (FBIsEmpty(self.tid)) {
        return;
    }
    
    self.commentListHttp.parameter.tid = self.tid;
    [self showLoadingWithText:MT_LOADING];
    __weak AllCommentListViewController *weak_self = self;
    [self.commentListHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
//        [weak_self.header endRefreshing];
        if (weak_self.commentListHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self updateMomentListWithInfo:weak_self.commentListHttp.resultModel.dataArray];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.commentListHttp.erorMessage];
        };
    }failedBlock:^{
        [weak_self hideLoading];
        [weak_self.header endRefreshing];
        
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

#pragma mark Keyboard
-(void)keyboardWillShow:(NSNotification*)notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = [value CGRectValue].size.height;
    
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [UIView setAnimationCurve:[curve intValue]];
        [self.commentView frameSetY:[LXUtils getContentViewHeight] - keyboardHeight - CGRectGetHeight(self.commentView.frame)];
    }];
    
    
}

-(void)keyboardWillHide:(NSNotification*)notif
{
    [self.commentView frameSetY:[LXUtils getContentViewHeight]];
}


#pragma mark - IBAciton

/**
 *  点击弹出
 *
 *  @param sender
 */
- (IBAction)onCommentBtnClick:(UIButton *)sender {
    
    [self.CommentTextView becomeFirstResponder];
}

/**
 *  取消
 *
 *  @param sender
 */
- (IBAction)onCancleBtnClick:(UIButton *)sender {

    [self.CommentTextView resignFirstResponder];
}

/**
 *  发送
 *
 *  @param sender
 */
- (IBAction)onSendBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.commentView frameSetY:[LXUtils GetScreeHeight]];
        [self.CommentTextView resignFirstResponder];
        
        [self sendCommentContent];
    }];
}


- (void)sendCommentContent
{
    self.addCommentHttp.parameter.tid = self.tid;
    self.addCommentHttp.parameter.fid = self.fid;
    if ([self.CommentTextView.text length] < 1) {
        [self showWithText:@"请输入评论内容"];
        return;
    }
    
    self.addCommentHttp.parameter.message = self.CommentTextView.text;
    [self showLoadingWithText:MT_LOADING];
    __weak AllCommentListViewController *weak_self = self;
    [self.addCommentHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        //        [weak_self.header endRefreshing];
        if (weak_self.addCommentHttp.isValid)
        {
            /**
             *  更新数据
             */
            [weak_self showWithText:@"评论成功"];
            weak_self.CommentTextView.text = @"";
            [weak_self requestStoryCommentList];
        }
        else
        {   //显示服务端返回的错误提示
            [weak_self showWithText:weak_self.addCommentHttp.erorMessage];
        };
    }failedBlock:^{
        [weak_self hideLoading];
        [weak_self.header endRefreshing];
        
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

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        for (id oneObject in cellNib)
        {
            if ([oneObject isKindOfClass:[CommentCell class]])
            {
                cell = (CommentCell *)oneObject;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CommentInfo *commentDetail = (CommentInfo *)self.dataSource[indexPath.row];
    
    [cell updateUIWithCommentInfo:commentDetail];
    
    return cell;
}


@end
