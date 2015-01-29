//
//  CommentCell.h
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentInfo;

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;

@property (weak, nonatomic) IBOutlet UIView *theContentView;

- (void)updateUIWithCommentInfo:(CommentInfo *)info;

@end
