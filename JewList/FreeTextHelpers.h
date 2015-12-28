//
//  FreeTextHelpers.h
//  JewList
//
//  Created by Oren Zitoun on 12/7/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreeTextEnum.h"
@class User;

@interface FreeTextHelpers : NSObject

+ (NSString *)questionTitleForType:(FreeTextType)type;
+ (NSString *)placeholderForType:(FreeTextType)type;
+ (void)setUserValue:(NSString *)value type:(FreeTextType)type user:(User *)user;
+ (NSString *)userValueForType:(FreeTextType)type user:(User *)user;

@end
