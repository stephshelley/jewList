//
//  UserResultCell.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "UserResultCell.h"
#import "User.h"

@implementation UserResultCell

+ (float)rowHeight
{
    return IsIpad ? 90 : 90;
}

/* Init */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        CGFloat cellWidth = IsIpad ? 700 : 320;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.userImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _userImageView.left = 5;
        _userImageView.centerY = floorf([UserResultCell rowHeight]/2);
        _userImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userImageView];
        
        self.nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, 280,21)];
        _nameLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_nameLabel.height-2)];
        _nameLabel.textColor = DEFAULT_BLUE_COLOR;
        _nameLabel.left = _userImageView.right + 5;
        _nameLabel.width = cellWidth - 10 - (_userImageView.right + 10);
        _nameLabel.top = _userImageView.top + 4;
        _nameLabel.adjustsFontSizeToFitWidth = NO;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        self.accesoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 7, _nameLabel.width, 17)];
        _accesoryLabel.font = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:(_accesoryLabel.height - 2)];
        _accesoryLabel.textColor = UIColorFromRGB(0x706f6d);
        _accesoryLabel.adjustsFontSizeToFitWidth = NO;
        _accesoryLabel.backgroundColor = [UIColor clearColor];
        _accesoryLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_accesoryLabel];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        sep.backgroundColor = UIColorFromRGB(0xcccccc);
        sep.bottom = [UserResultCell rowHeight];
        [self.contentView addSubview:sep];
        
    }
    
    return self;
    
}

- (void)setItem:(SHUserCellItem *)item
{
    _item = item;
    [self setUser:_item.user];
    
}

- (void)setUser:(User *)user
{
    _user = user;
    [_userImageView setUserImagePathToNetworkImage:[_user fbImageUrlForSize:_userImageView.size] forDisplaySize:_userImageView.size contentMode:UIViewContentModeScaleAspectFill];
    _nameLabel.text = _user.firstName;
    
    //NSMutableArray *items = [NSMutableArray array];
    
    NSMutableString *nameString = [NSMutableString stringWithFormat:@"%@",_user.firstName];
    
    if(nil != _user.age && [_user.age integerValue] > 0)
    {
        [nameString appendFormat:@" %d/",[_user.age integerValue]];
        //[items addObject:[NSString stringWithFormat:@"%d",[_user.age integerValue]]];
        [nameString appendFormat:@"%@",[self getFullGenderSign]];
    }
    else
    {
        [nameString appendFormat:@" %@",[self getFullGenderSign]];

    }
    
    /*
    if(nil != _user.gender)
    {
        [items addObject:[NSString stringWithFormat:@"%@",[self getGenderSign]]];
    }
    
    if(nil != _user.age)
    {
        [items addObject:[NSString stringWithFormat:@"%d",[_user.age integerValue]]];
    }
    
    if(nil != _user.gradYear)
    {
        [items addObject:[NSString stringWithFormat:@"Class of %d",[_user.gradYear integerValue]]];
    }
    */
    
     __block TTTAttributedLabel *_nameLabel_ = _nameLabel;
    NSInteger age = [_user.age integerValue];
    NSString *gender = [self getFullGenderSign];
     
     [_nameLabel setText:nameString afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
     NSRange range1 = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@" %d/",age] options:NSCaseInsensitiveSearch];

         NSRange range2 = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"%@",gender] options:NSCaseInsensitiveSearch];

         [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)UIColorFromRGB(0xb5b2ac).CGColor range:range1];

         [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)UIColorFromRGB(0xb5b2ac).CGColor range:range2];

     UIFont *boldSystemFont = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:_nameLabel_.font.pointSize + 2];
     CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);

         UIFont *genderFont = [UIFont fontWithName:DEFAULT_FONT_REGULAR size:_nameLabel_.font.pointSize];
         CTFontRef genderCFfont = CTFontCreateWithName((__bridge CFStringRef)genderFont.fontName, genderFont.pointSize, NULL);

     if (font) {
         [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range1];
         CFRelease(font);
     }
     
         if (genderCFfont) {
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)genderCFfont range:range2];
             CFRelease(genderCFfont);
         }
         
     return mutableAttributedString;
     }];
    
    NSString *gradYear = nil;
    if(_user.gradYear != nil && [_user.gradYear integerValue] > 0)
    {
        gradYear = [NSString stringWithFormat:@"Class of %d",[_user.gradYear integerValue]];
    }
    else
    {
        gradYear = @"";
    }
    
    if((_user.college.collegeName != nil && _user.college.collegeName.length > 0))
    {
        if(gradYear.length > 0)
        {
            _accesoryLabel.text = [NSString stringWithFormat:@"%@, %@",_user.college.collegeName,gradYear];
            
        }
        else
        {
            _accesoryLabel.text = _user.college.collegeName;
            
        }
        
    }
    else
    {
        _accesoryLabel.text = [NSString stringWithFormat:@"%@",gradYear];
        
    }
    //[items componentsJoinedByString:@", "];

}

- (NSString*)getGenderSign
{
    NSString *gender = nil;
    
    if([_user.gender intValue] == 0)
    {
        gender = @"M";
    }else if([_user.gender intValue] == 1)
    {
        gender = @"F";
    }else{
        gender = @"";
    }
    
    return gender;
    
}

- (NSString*)getFullGenderSign
{
    NSString *gender = nil;
    
    if([_user.gender intValue] == 0)
    {
        gender = @"male";
    }else if([_user.gender intValue] == 1)
    {
        gender = @"female";
    }else{
        gender = @"";
    }
    
    return gender;
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_userImageView prepareForReuse];
    
}

@end
