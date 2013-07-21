//
//  SHUIHelpers.h
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUIHelpers : NSObject

+ (UIView*)getCustomBarButtonView:(CGRect)frame buttonImage:(NSString*)buttonImage selectedImage:(NSString*)selectedImage title:(NSString*)title andSelector:(SEL)selector sender:(id)sender titleColor:(UIColor*)color;

@end
