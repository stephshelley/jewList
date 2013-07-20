//
//  STLoginPassword.h
//  Storm-frontend
//
//  Created by Guillaume Salva on 1/23/13.
//  Copyright (c) 2013 Milestone Project. All rights reserved.
//

#import <Security/Security.h>

@interface SHLoginPassword : NSObject <NSCoding>

@property (nonatomic, readonly, strong) NSString *login;
@property (nonatomic, readonly, strong) NSString *password;

- (id)initWithLogin:(NSString *)login andPassword:(NSString *)password;

#pragma mark Keychain Support

//TODO: Support alternate KeyChain Locations

+ (id)loginPasswordFromDefaultKeychainWithServiceProviderName:(NSString *)provider;
- (void)storeInDefaultKeychainWithServiceProviderName:(NSString *)provider;
- (void)removeFromDefaultKeychainWithServiceProviderName:(NSString *)provider;

@end

