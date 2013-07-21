//
//  JLColors.m
//  JewList
//
//  Created by Stephanie Volftsun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "JLColors.h"

@implementation UIColor (Extensions)

+ (UIColor *)JLGrey {
    return [UIColor colorWithRed:0.18 green:0.192 blue:0.196 alpha:1] /*#2e3132*/;
}

+ (UIColor *)JLGreen {
    return [UIColor colorWithRed:0.831 green:0.906 blue:0.714 alpha:1] /*#d4e7b6*/;
}

+ (UIColor *)JLDarkGreen {
    return [UIColor colorWithRed:0.745 green:0.863 blue:0.557 alpha:1] /*#bedc8e*/;
}

+ (UIColor *)JLBlue {
    return [UIColor colorWithRed:0.424 green:0.773 blue:0.98 alpha:1] /*#6cc5fa*/;
}

+ (UIColor *)JLDarkBlue {
    return [UIColor colorWithRed:0.349 green:0.631 blue:0.831 alpha:1] /*#59a1d4*/;
}

@end
