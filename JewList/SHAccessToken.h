//
//  SHAccessToken.h
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "Jastor.h"
#import <Security/Security.h>

@interface SHAccessToken : Jastor <NSCoding>

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, readonly, strong) NSDate *expiresAt;
@property (nonatomic, readonly) BOOL doesExpire;
@property (nonatomic, readonly) BOOL hasExpired;

- (id)initWithAccessToken:(NSString *)accessToken;
- (id)initWithAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken expiresAt:(NSDate *)expiryDate;
- (id)initWithAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken expiresAt:(NSDate *)expiryDate scope:(NSSet *)scope;


#pragma mark Keychain Support

+ (id)tokenFromDefaultKeychainWithServiceProviderName:(NSString *)provider;
- (void)storeInDefaultKeychainWithServiceProviderName:(NSString *)provider;
- (void)removeFromDefaultKeychainWithServiceProviderName:(NSString *)provider;


@end
