//
//  User.m
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark == SERIALIZATION ==
/* Deserialize */
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
	return self;
    
}

/* Serialize */
- (void)encodeWithCoder:(NSCoder*)encoder
{
    [super encodeWithCoder:encoder];
    
}

-(id)copyWithZone:(NSZone *)zone
{
    User *newUser = [[User alloc] init];
    newUser.fbId = [_fb copyWithZone:zone];
    newUser.dbId = [self.dbId copyWithZone:zone];
    newUser.fbToken = [_fbToken copyWithZone:zone];
    newUser.fbImageUrl = [_fbImageUrl copyWithZone:zone];
    newUser.campus = [_campus copyWithZone:zone];
    newUser.cleaning = [_cleaning copyWithZone:zone];
    newUser.cleaningText = [_cleaningText copyWithZone:zone];
    newUser.diet = [_diet copyWithZone:zone];
    newUser.dietText = [_dietText copyWithZone:zone];
    newUser.firstName = [_firstName copyWithZone:zone];
    newUser.lastName = [_lastName copyWithZone:zone];
    newUser.gender = [_gender copyWithZone:zone];
    newUser.gradYear = [_gradYear copyWithZone:zone];
    newUser.hsEngagement = [_hsEngagement copyWithZone:zone];
    newUser.personality = [_personality copyWithZone:zone];
    newUser.personalityText = [_personalityText copyWithZone:zone];
    newUser.religious = [_religious copyWithZone:zone];
    newUser.religiousText = [_religiousText copyWithZone:zone];
    newUser.roommatePrefs = [_roommatePrefs copyWithZone:zone];
    newUser.school = [_school copyWithZone:zone];
    newUser.aboutMe = [_aboutMe copyWithZone:zone];
    newUser.didFinishSignup = _didFinishSignup;
    newUser.college = [_college copy];
    
    return newUser;
}


- (NSString *)fbImageUrlForSize:(CGSize)size
{
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d", self.fbId,(int)size.width*scale,(int)size.height*scale];
    return url;
    
}

@end
