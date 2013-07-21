//
//  UIView+FindAndResignFirstResponder.m
//  JewList
//
//  Created by Mihai Chiorean on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"

@implementation UIView (FindAndResignFirstResponder)

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

@end
