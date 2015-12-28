//
//  SHUIHelpers.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUIHelpers : NSObject

+ (UIAlertController *)actionSheetAlertContorllerWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles completion:(void (^)(NSString *buttonTitle))completion;
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(void))completion;
+ (UIAlertController *)errorAlertControllerWithMessage:(NSString *)message completion:(void (^)(void))completion;
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles completion:(void (^)(NSString *buttonTitle))completion;

+ (UIView*)getCustomBarButtonView:(CGRect)frame buttonImage:(NSString*)buttonImage selectedImage:(NSString*)selectedImage title:(NSString*)title andSelector:(SEL)selector sender:(id)sender titleColor:(UIColor*)color;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
+ (void)alertErrorWithMessage:(NSString *)message;
+ (void)handleApiError:(NSDictionary *)errorDict;
+ (CGFloat)getTextHeight:(NSString*)text font:(UIFont*)font withCapHeight:(CGFloat)capHeight width:(CGFloat)width;
+ (UIButton *)getNavBarButton:(CGRect)frame title:(NSString *)title selector:(SEL)selector sender:(id)sender;
+ (CGFloat)textHeight:(NSString *)text widthCap:(CGFloat)maxWidth font:(UIFont *)font;

@end
