//
//  SHTextCellItem.m
//  JewList
//
//  Created by Oren Zitoun on 12/28/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHTextCellItem.h"
#import "SHUIHelpers.h"

@implementation SHTextCellItem


- (CGFloat)getCellHeight
{
    CGFloat height = [SHUIHelpers getTextHeight:_text font:[UIFont fontWithName:DEFAULT_FONT size:kCellTextFontSize] withCapHeight:1000 width:280];
    return height + 37;
    
}

@end
