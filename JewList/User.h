//
//  User.h
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "Jastor.h"
#import "College.h"

@interface User : Jastor

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *kosher;
@property (nonatomic, strong) NSString *shabat;

@property (nonatomic, strong) NSString *fb;
@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *fbToken;
@property (nonatomic, strong) NSString *fbImageUrl;
@property (nonatomic, strong) NSString *fbHometownId;
@property (nonatomic, strong) NSString *fbHometownName;
@property (nonatomic, strong) NSString *fbLocationId;
@property (nonatomic, strong) NSString *fbLocationName;
@property (nonatomic, strong) NSString *fbCollegeName;

@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *campus;
@property (nonatomic, strong) NSString *earlyBird;
@property (nonatomic, strong) NSString *cleaning;
@property (nonatomic, strong) NSString *fun;
@property (nonatomic, strong) NSNumber *diet;
@property (nonatomic, strong) NSString *dietText;
@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, strong) NSString *desiredMajor;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *music;
@property (nonatomic, strong) NSString *duringTheDay;
@property (nonatomic, strong) NSString *activities;
@property (nonatomic, strong) NSString *contactFromJewishOrgs;
@property (nonatomic, strong) NSNumber *gradYear;
@property (nonatomic, strong) NSString *hsEngagement;
@property (nonatomic, strong) NSNumber *personality;
@property (nonatomic, strong) NSString *personalityText;
@property (nonatomic, strong) NSNumber *primaryId;
@property (nonatomic, strong) NSNumber *religious;
@property (nonatomic, strong) NSString *religiousText;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSNumber *social;
@property (nonatomic, assign) BOOL didFinishSignup;
@property (nonatomic, strong) College *college;

@property (nonatomic, strong) NSDictionary *fbMeResult;
@property (nonatomic, strong) NSDictionary *fbUsername;

- (NSString *)fbImageUrlForSize:(CGSize)size;
- (NSString *)fbCoverUrlForSize:(CGSize)size;

@end
