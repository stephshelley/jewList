//
//  STTextFieldOnBoarding.m
//  Storm-frontend
//
//  Created by Guillaume Salva on 2/26/13.
//  Copyright (c) 2013 Milestone Project. All rights reserved.
//

#import "SHTextFieldOnBoarding.h"

@implementation SHTextFieldOnBoarding

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.font = [UIFont fontWithName:DEFAULT_FONT size:IsIpad ? 21.0 : 15];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textColor = UIColorFromRGB(0x666666);
    self.backgroundColor = [UIColor whiteColor];
    self.text = @"";
    self.textAlignment = NSTextAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.borderStyle = UITextBorderStyleNone;
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 5, 5);
}

@end
