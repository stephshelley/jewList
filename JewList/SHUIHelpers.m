//
//  SHUIHelpers.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHUIHelpers.h"

@implementation SHUIHelpers

+ (CGFloat)getTextHeight:(NSString*)text font:(UIFont*)font withCapHeight:(CGFloat)capHeight width:(CGFloat)width
{
    CGFloat height = 0;
    CGSize detailTextSize = CGSizeZero;
    if(text)
    {
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(width,capHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
        detailTextSize = textRect.size;
    }
    
    if(detailTextSize.height == 0) return 0;
    height = detailTextSize.height + ((detailTextSize.height > 200) ? 40 : 30);
    
    return ceilf(height);
    
}

+ (UIButton *)getNavBarButton:(CGRect)frame title:(NSString *)title selector:(SEL)selector sender:(id)sender
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    button.contentMode = UIViewContentModeCenter;
    [button setBackgroundColor:UIColorFromRGB(0x53b5f1)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:13];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 3.0f;
    button.clipsToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button addTarget:sender action:selector forControlEvents:UIControlEventTouchUpInside];

    return button;
    
}

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

+ (void)handleApiError:(NSDictionary *)errorDict
{
    [self alertErrorWithMessage:[NSString stringWithFormat:@"%@",[errorDict objectForKey:@"message"]]];
}

+ (void)alertErrorWithMessage:(NSString *)message
{
    if(!message) return;
    
    [self alertWithTitle:@"Oy! Error"
                        message:message
              cancelButtonTitle:@"OK"];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:cancelButtonTitle
                                 otherButtonTitles:nil];

    [alertView show];
    
}

+ (CGFloat)textHeight:(NSString *)text widthCap:(CGFloat)maxWidth font:(UIFont *)font {
    if (text.length == 0) return 0;
    
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : font}
                                         context:nil];
    return CGRectGetHeight(textRect);
}

@end
