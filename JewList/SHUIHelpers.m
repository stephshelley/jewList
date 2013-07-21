//
//  SHUIHelpers.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHUIHelpers.h"

@implementation SHUIHelpers

+ (UIView*)getCustomBarButtonView:(CGRect)frame buttonImage:(NSString*)buttonImage selectedImage:(NSString*)selectedImage title:(NSString*)title andSelector:(SEL)selector sender:(id)sender titleColor:(UIColor*)color
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    button.contentMode = UIViewContentModeCenter;
    [button setBackgroundImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:15];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button addTarget:sender action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
