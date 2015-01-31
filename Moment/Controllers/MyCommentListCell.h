//
//  MyCommentListCell.h
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *mycommentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *litpicImage;

@property (weak, nonatomic) IBOutlet UILabel *storyNameLabel;

@property (weak, nonatomic) IBOutlet UIView *storyBGView;
@end
