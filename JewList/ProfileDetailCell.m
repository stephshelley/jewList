//
//  ProfileDetailCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/20/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "ProfileDetailCell.h"
#import "UIView+Common.h"

const NSUInteger titleLabelTopMargin = 5.0;
const NSUInteger detailLabelTopMargin = 4.0;
const NSUInteger detailLabelBottomMargin = 8.0;
const NSUInteger titleLabelHeight = 21.0;

#define kTitleFont [UIFont systemFontOfSize:14]
#define kDetailFont [UIFont systemFontOfSize:16]
#define kMaxLabelWidth 300

@interface ProfileDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation ProfileDetailCell

+ (CGFloat)cellHeightForItem:(ProfileDetailCellItem *)item {
    CGSize detailSize = [[self class] detailLabelSize:item.detail];
    return titleLabelTopMargin + detailLabelTopMargin + detailSize.height + detailLabelBottomMargin + titleLabelHeight;
}

+ (CGSize)titleLabelSize:(NSString *)title {
    CGSize titleSize = [[self class] textSize:title font:kTitleFont maxWidth:kMaxLabelWidth];
    return titleSize;
}

+ (CGSize)detailLabelSize:(NSString *)detail {
    CGSize detailSize = [[self class] textSize:detail font:kDetailFont maxWidth:kMaxLabelWidth];
    return detailSize;
}

- (void)setItem:(ProfileDetailCellItem *)item {
    _item = item;
    self.titleLabel.text = _item.title;
    self.detailLabel.text = _item.detail;
}

+ (CGSize)textSize:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    if (text.length == 0) return CGSizeZero;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    return rect.size;
}

@end
