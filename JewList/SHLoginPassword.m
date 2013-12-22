//
//  STLoginPassword.m
//  Storm-frontend
//
//  Created by Guillaume Salva on 1/23/13.
//  Copyright (c) 2013 Milestone Project. All rights reserved.
//

#import "SHLoginPassword.h"
#import "NSString+NXOAuth2.h"
#include <Security/SecItem.h>


@implementation SHLoginPassword

#pragma mark Lifecycle

- (id)initWithLogin:(NSString *)login andPassword:(NSString *)password
{
	self = [super init];
	if (self) {
		_login  = login;
		_password = password;
	}
	return self;
}

- (void)dealloc;
{
    
}

- (NSString *)description;
{
	return [NSString stringWithFormat:@"<Storm Login passwor:%@-%@>", self.login, self.password];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_login forKey:@"login"];
	[aCoder encodeObject:_password forKey:@"password"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) {
		_login = [[aDecoder decodeObjectForKey:@"login"] copy];
		_password = [[aDecoder decodeObjectForKey:@"password"] copy];
	}
	return self;
}


#pragma mark Keychain Support

+ (NSString *)serviceNameWithProvider:(NSString *)provider;
{
    NSString *serviceName = nil;
    
	NSString *appName = [[NSBundle mainBundle] bundleIdentifier];
	serviceName = [NSString stringWithFormat:@"%@::StormLoginPassword::%@", appName, provider];
    
	return serviceName;
}

#if TARGET_OS_IPHONE

+ (id)loginPasswordFromDefaultKeychainWithServiceProviderName:(NSString *)provider
{
	NSString *serviceName = [[self class] serviceNameWithProvider:provider];
	CFDictionaryRef cfresult = nil;
	NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
						   (__bridge NSString *)kSecClassGenericPassword, kSecClass,
						   serviceName, kSecAttrService,
						   kCFBooleanTrue, kSecReturnAttributes,
						   nil];
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&cfresult);
	
	if (status != noErr) {
		//NSAssert1(status == errSecItemNotFound, @"unexpected error while fetching token from keychain: %d", status);
		return nil;
	}
    
    NSDictionary *result = (__bridge NSDictionary*)cfresult;
    status = nil;
    cfresult = nil;
    query = nil;
	return [NSKeyedUnarchiver unarchiveObjectWithData:[result objectForKey:(__bridge NSString *)kSecAttrGeneric]];
}

- (void)storeInDefaultKeychainWithServiceProviderName:(NSString *)provider;
{
	NSString *serviceName = [[self class] serviceNameWithProvider:provider];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
	NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
						   (__bridge NSString *)kSecClassGenericPassword, kSecClass,
						   serviceName, kSecAttrService,
						   @"OAuth 2 Access Token", kSecAttrLabel,
						   data, kSecAttrGeneric,
						   nil];
	[self removeFromDefaultKeychainWithServiceProviderName:provider];
	OSStatus __attribute__((unused)) err = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
	//NSAssert1(err == noErr, @"error while adding token to keychain: %d", err);
}

- (void)removeFromDefaultKeychainWithServiceProviderName:(NSString *)provider;
{
	NSString *serviceName = [[self class] serviceNameWithProvider:provider];
	NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
						   (__bridge NSString *)kSecClassGenericPassword, kSecClass,
						   serviceName, kSecAttrService,
						   nil];
	OSStatus __attribute__((unused)) err = SecItemDelete((__bridge CFDictionaryRef)query);
	//NSAssert1((err == noErr || err == errSecItemNotFound), @"error while deleting token from keychain: %d", err);
}

#else

+ (id)loginPasswordFromDefaultKeychainWithServiceProviderName:(NSString *)provider;
{
	NSString *serviceName = [[self class] serviceNameWithProvider:provider];
	
	SecKeychainItemRef item = nil;
	OSStatus err = SecKeychainFindGenericPassword(NULL,
												  strlen([serviceName UTF8String]),
												  [serviceName UTF8String],
												  0,
												  NULL,
												  NULL,
												  NULL,
												  &item);
	if (err != noErr) {
		NSAssert1(err == errSecItemNotFound, @"unexpected error while fetching token from keychain: %d", err);
		return nil;
	}
    
    // from Advanced Mac OS X Programming, ch. 16
    UInt32 length;
    char *password;
	NSData *result = nil;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;
	
    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;
    
    list.count = 4;
    list.attr = attributes;
    
    err = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);
    if (err == noErr) {
        if (password != NULL) {
			result = [NSData dataWithBytes:password length:length];
        }
        SecKeychainItemFreeContent(&list, password);
    } else {
		// TODO find out why this always works in i386 and always fails on ppc
		BD_LOG(@"Error from SecKeychainItemCopyContent: %d", err);
        return nil;
    }
    CFRelease(item);
	return [NSKeyedUnarchiver unarchiveObjectWithData:result];
}

- (void)storeInDefaultKeychainWithServiceProviderName:(NSString *)provider;
{
	[self removeFromDefaultKeychainWithServiceProviderName:provider];
	NSString *serviceName = [[self class] serviceNameWithProvider:provider];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
	
	OSStatus __attribute__((unused))err = SecKeychainAddGenericPassword(NULL,
																		strlen([serviceName UTF8String]),
																		[serviceName UTF8String],
																		0,
																		NULL,
																		[data length],
																		[data bytes],
																		NULL);
	
	NSAssert1(err == noErr, @"error while adding token to keychain: %d", err);
}

- (void)removeFromDefaultKeychainWithServiceProviderName:(NSString *)provider;
{
	NSString *serviceName = [[self class] serviceNameWithProvider:provider];
	SecKeychainItemRef item = nil;
	OSStatus err = SecKeychainFindGenericPassword(NULL,
												  strlen([serviceName UTF8String]),
												  [serviceName UTF8String],
												  0,
												  NULL,
												  NULL,
												  NULL,
												  &item);
	NSAssert1((err == noErr || err == errSecItemNotFound), @"error while deleting token from keychain: %d", err);
	if (err == noErr) {
		err = SecKeychainItemDelete(item);
	}
	if (item) {
		CFRelease(item);
	}
	NSAssert1((err == noErr || err == errSecItemNotFound), @"error while deleting token from keychain: %d", err);
}

#endif


@end
