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
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatarUrl;

@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *fbToken;
@property (nonatomic, strong) NSString *fbImageUrl;
@property (nonatomic, strong) NSString *fbHometownId;
@property (nonatomic, strong) NSString *fbHometownName;
@property (nonatomic, strong) NSString *fbLocationId;
@property (nonatomic, strong) NSString *fbLocationName;
@property (nonatomic, strong) NSString *fbCollegeName;

@property (nonatomic, strong) NSString *gendre;

@property (nonatomic, strong) NSDictionary *fbMeResult;


@end
