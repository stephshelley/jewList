//
//  MultiSelectionCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "MultiSelectionCell.h"

@implementation MultiSelectionCell

+ (CGFloat)cellHeight {
    return 50;
}

- (void)awakeFromNib {
    self.checkImageView.image = [[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.checkImageView.tintColor = DEFAULT_BLUE_COLOR;
    self.checkImageView.hidden = YES;
}

@end
