//
//  PlacehoderTextView.h
//  Chemayi
//
//  Created by Chemayi on 14/8/19.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

/**
 *  带有PlaceHolder的TextView
 */

#import <UIKit/UIKit.h>

@interface PlacehoderTextView : UITextView

{
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;


@end
