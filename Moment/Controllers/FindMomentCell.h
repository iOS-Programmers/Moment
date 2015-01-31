//
//  FindMomentCell.h
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MomentDetail;

@interface FindMomentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avtarImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendNmLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;


- (void)updateMomentCellWithInfo:(MomentDetail *)detail;

@end
