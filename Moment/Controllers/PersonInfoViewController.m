//
//  PersonInfoViewController.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UploadPictureHttp.h"
#import "ModifyAvatarHttp.h"
#import "ModifyNickNameHttp.h"
#import "ModifyUserNameHttp.h"
#import "PersionInfoAvatarCell.h"
#import "MTEditTextViewController.h"
#import "YHBaseNavigationController.h"

@interface PersonInfoViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UploadPictureHttp *updatePicHttp;
@property (strong, nonatomic) ModifyAvatarHttp *modifyAvatarHttp;
@property (strong, nonatomic) ModifyNickNameHttp *modifyNicknameHttp;
@property (strong, nonatomic) ModifyUserNameHttp *modifyusernameHttp;

@property (strong, nonatomic) NSArray *titles;

@property (copy, nonatomic) NSString *nickName;
@property (copy, nonatomic) NSString *userName;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人资料";
    
    self.titles =@[@"头像",@"用户名",@"昵称",@"注册日期"];
    
    self.updatePicHttp = [[UploadPictureHttp alloc] init];
    self.modifyAvatarHttp = [[ModifyAvatarHttp alloc] init];
    self.modifyNicknameHttp = [[ModifyNickNameHttp alloc] init];
    self.modifyusernameHttp = [[ModifyUserNameHttp alloc] init];

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

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"systemcellIdentfier";
    static NSString *CellIdentifiers = @"Cell";
    UITableViewCell *cell;
    if (indexPath.row == 0) {
 
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    if (!cell) {
        if (indexPath.row == 0) {
           
            NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"PersionInfoAvatarCell" owner:self options:nil];
            for (id oneObject in cellNib)
            {
                if ([oneObject isKindOfClass:[PersionInfoAvatarCell class]])
                {
                    cell = (PersionInfoAvatarCell *)oneObject;
                }
            }
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
       
        if (indexPath.row != 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,[MTUserInfo defaultUserInfo].avatar]] placeholderImage:[UIImage imageNamed:@"touxiang_pinglun + Oval 7"]];
    }
    if (indexPath.row == 1) {
        //用户名
        cell.detailTextLabel.text = [MTUserInfo defaultUserInfo].username;
    }
    if (indexPath.row == 2) {
        //昵称
        cell.detailTextLabel.text = [MTUserInfo defaultUserInfo].nickname;
    }
    if (indexPath.row == 3) {
        //注册日期
        cell.detailTextLabel.text = [LXUtils secondChangToDate:[MTUserInfo defaultUserInfo].regtime];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    if (row == 3) {
        return;
    }
    if (row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:@"从相册选取"
                                                       otherButtonTitles:@"拍照",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
        return;
    }
    
    MTEditTextViewController *vc = [[MTEditTextViewController alloc] init];
    YHBaseNavigationController *nav = [[YHBaseNavigationController alloc] initWithRootViewController:vc];
    if (row == 1) {
        vc.titleStr = @"用户名";
    }
    if (row == 2) {
        vc.titleStr = @"昵称";
    }
    __weak PersonInfoViewController *weak_self = self;
    EditBackBlock block = ^(NSString *str)
    {
        if (indexPath.row == 1) {
            weak_self.userName = str;
        }
        if (indexPath.row == 2) {
            weak_self.nickName = str;
        }

        [weak_self updateUserInfo:(int)indexPath.row];
    };
    [vc setBackBlock:block];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//添加动画
    [self presentViewController:nav animated:YES completion:^{}];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90;
    }
    
    return 44;
}

#pragma mark - IBAciton

/**
 *  更换头像
 */
- (void)modifyAvatar:(NSString *)avatarUrl
{
    self.modifyAvatarHttp.parameter.avatar = avatarUrl;
    [self showLoadingWithText:MT_LOADING];
    __block PersonInfoViewController *weak_self = self;
    [self.modifyAvatarHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.modifyAvatarHttp.isValid)
        {
            if ([weak_self.modifyAvatarHttp.resultModel.status isEqualToString:@"1"]) {
                [weak_self showWithText:@"更换头像成功！"];
                
                //更换成功后，把头像存在本地
                
                MTUserInfo *info = [[MTUserInfo alloc] init];
                info.avatar = weak_self.updatePicHttp.resultModel.avatar;
                [MTUserInfo saveUserInfo:info];
                
                [weak_self refreshUI];
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

//刷新界面
- (void)refreshUI
{
    /**
     *  发送修改资料成功的
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:MT_UpdatePersonalInfo object:nil];
    
    [self.tableView reloadData];
}

-(void)updateUserInfo:(int)type{
    
    //修改用户名
    if (type == 1 && self.userName.length > 0) {
       
        self.modifyusernameHttp.parameter.username = self.userName;
        [self showLoadingWithText:MT_LOADING];
        __block PersonInfoViewController *weak_self = self;
        [self.modifyusernameHttp getDataWithCompletionBlock:^{
            [weak_self hideLoading];
            if (weak_self.modifyusernameHttp.isValid)
            {
                if ([weak_self.modifyusernameHttp.resultModel.status isEqualToString:@"1"]) {
                    [weak_self showWithText:@"修改用户名成功！"];
                    
                    //修改成功后，把昵称存在本地
                    
                    MTUserInfo *info = [[MTUserInfo alloc] init];
                    info.username = weak_self.modifyusernameHttp.parameter.username;
                    [MTUserInfo saveUserInfo:info];
                    
                    [weak_self refreshUI];
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
    
    //修改昵称
    if (type == 2 && self.nickName.length > 0) {
        
        self.modifyNicknameHttp.parameter.nickname = self.nickName;
        [self showLoadingWithText:MT_LOADING];
        __block PersonInfoViewController *weak_self = self;
        [self.modifyNicknameHttp getDataWithCompletionBlock:^{
            [weak_self hideLoading];
            if (weak_self.modifyNicknameHttp.isValid)
            {
                if ([weak_self.modifyNicknameHttp.resultModel.status isEqualToString:@"1"]) {
                    [weak_self showWithText:@"修改昵称成功！"];
                    
                    //修改成功后，把昵称存在本地
                    
                    MTUserInfo *info = [[MTUserInfo alloc] init];
                    info.nickname = weak_self.modifyNicknameHttp.parameter.nickname;
                    [MTUserInfo saveUserInfo:info];
                    
                    [weak_self refreshUI];
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

    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    if (buttonIndex == 0)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    UIImage *rightImage = [LXUtils rotateImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.updatePicHttp.parameter.image = rightImage;
    [self showLoadingWithText:MT_UPLOADING];
    __block PersonInfoViewController *weak_self = self;
    [self.updatePicHttp getDataWithCompletionBlock:^{
        [weak_self hideLoading];
        if (weak_self.updatePicHttp.isValid)
        {
            
            if (weak_self.updatePicHttp.resultModel.avatar) {
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weak_self modifyAvatar:weak_self.updatePicHttp.resultModel.avatar];
                    
                });
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
