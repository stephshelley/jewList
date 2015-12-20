//
//  UserCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/19/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "UserCell.h"
#import "NINetworkImageView.h"

@interface UserCell ()

@property (weak, nonatomic) IBOutlet NINetworkImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation UserCell

+ (CGFloat)cellHeight {
    return 90;
}

- (void)setUser:(User *)user {
    _user = user;
    
    [self.avatarView setUserImagePathToNetworkImage:[_user fbImageUrlForSize:self.avatarView.size] forDisplaySize:self.avatarView.size contentMode:UIViewContentModeScaleAspectFill];

    NSMutableString *nameString = [NSMutableString stringWithFormat:@"%@",_user.firstName];
    
    NSString *ageString = [NSString stringWithFormat:@" %d/",[_user.age integerValue]];
    NSString *genderString = [NSString stringWithFormat:@"%@",[self getFullGenderSign]];

    if([_user.age integerValue] > 0) {
        [nameString appendString:ageString];
        [nameString appendFormat:@"%@",genderString];
    }
    else {
        [nameString appendFormat:@" %@",genderString];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:nameString];
    NSDictionary *attrs = @{NSForegroundColorAttributeName : self.infoLabel.textColor ,NSFontAttributeName : self.userNameLabel.font};
    NSRange ageRange = [nameString rangeOfString:ageString];
    NSRange genderRange = [nameString rangeOfString:genderString];
    
    [attString addAttributes:attrs range:ageRange];
    [attString addAttributes:attrs range:genderRange];
    self.userNameLabel.attributedText = attString;
    
    [self setInfoLabelText];
}

- (void)setInfoLabelText {
    NSString *gradYear = nil;
    if([_user.gradYear integerValue] > 0) {
        gradYear = [NSString stringWithFormat:@"Class of %d",[_user.gradYear integerValue]];
    }
    else {
        gradYear = @"";
    }
    
    if(_user.college.collegeName.length > 0) {
        if(gradYear.length > 0) {
            self.infoLabel.text = [NSString stringWithFormat:@"%@, %@",_user.college.collegeName,gradYear];
        }
        else {
            self.infoLabel.text = _user.college.collegeName;
        }
    }
    else {
        self.infoLabel.text = [NSString stringWithFormat:@"%@",gradYear];
    }
}

- (NSString *)getGenderSign
{
    NSString *gender = nil;
    
    if([_user.gender intValue] == 0) {
        gender = @"M";
    }
    else if([_user.gender intValue] == 1) {
        gender = @"F";
    }
    else {
        gender = @"";
    }
    return gender;
}

- (NSString *)getFullGenderSign
{
    NSString *gender = nil;
    
    if([_user.gender intValue] == 0) {
        gender = @"male";
    }
    else if([_user.gender intValue] == 1) {
        gender = @"female";
    }
    else{
        gender = @"";
    }
    return gender;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = highlighted ? [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] : [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = selected ? [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] : [UIColor clearColor];
}

@end
