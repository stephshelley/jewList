//
//  User.h
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "Jastor.h"

@interface User : Jastor

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *kosher;
@property (nonatomic, strong) NSString *shabat;

@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *fbToken;
@property (nonatomic, strong) NSString *fbImageUrl;
@property (nonatomic, strong) NSString *fbHometownId;
@property (nonatomic, strong) NSString *fbHometownName;
@property (nonatomic, strong) NSString *fbLocationId;
@property (nonatomic, strong) NSString *fbLocationName;
@property (nonatomic, strong) NSString *fbCollegeName;

@property (nonatomic, strong) NSNumber *campus;
@property (nonatomic, strong) NSNumber *cleaning;
@property (nonatomic, strong) NSNumber *diet;
@property (nonatomic, strong) NSString *fb;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSNumber *gradYear;
@property (nonatomic, strong) NSString *hsEngagement;
@property (nonatomic, strong) NSNumber *personality;
@property (nonatomic, strong) NSNumber *primaryId;
@property (nonatomic, strong) NSNumber *religious;
@property (nonatomic, strong) NSString *roommatePrefs;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSNumber *social;

@property (nonatomic, strong) NSDictionary *fbMeResult;
@property (nonatomic, strong) NSDictionary *fbUsername;


@end
