//
//  UserCoverCell.m
//  JewList
//
//  Created by Oren Zitoun on 12/19/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "UserCoverCell.h"
#import "NINetworkImageView.h"
#import "SHApi.h"

@interface UserCoverCell ()

@property (weak, nonatomic) IBOutlet NINetworkImageView *userCoverPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet NINetworkImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation UserCoverCell

+ (CGFloat)cellHeight {
    return 180;
}

- (void)setUser:(User *)user {
    _user = user;
    
    self.userNameLabel.text = _user.firstName;
    [self.avatarView setUserImagePathToNetworkImage:[_user fbImageUrlForSize:self.avatarView.size] forDisplaySize:self.avatarView.size contentMode:UIViewContentModeScaleAspectFill];

    if([_user.age integerValue] > 0) {
        self.infoLabel.text = [NSString stringWithFormat:@"%@, %d, Class of %d",[self getGenderSign],[_user.age integerValue] ,[_user.gradYear integerValue]];
    }
    else {
        self.infoLabel.text = [NSString stringWithFormat:@"%@, Class of %d",[self getGenderSign],[_user.gradYear integerValue]];
    }
    [self loadCover];
}

- (NSString *)getGenderSign {
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

- (void)loadCover {
    __weak __typeof(self) weakSelf = self;
    [[SHApi sharedInstance] getCoverUrl:_user.fb success:^(NSString *url)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.userCoverPhoto setPathToNetworkImage:url forDisplaySize:weakSelf.userCoverPhoto.size contentMode:UIViewContentModeScaleAspectFill];
             
         });
     }failure:nil];
}


@end
