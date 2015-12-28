//
//  MultiSelectionHelpers.h
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiSelectionEnum.h"

@class User;
@interface MultiSelectionHelpers : NSObject

+ (NSArray *)optionsForType:(MultiSelectionType)type;
+ (NSString *)questionTitleForType:(MultiSelectionType)type;
+ (void)setUserValue:(NSString *)value type:(MultiSelectionType)type user:(User *)user;
+ (NSString *)userValueForType:(MultiSelectionType)type user:(User *)user;
+ (BOOL)supportsMultiSelectionForType:(MultiSelectionType)type;

@end
