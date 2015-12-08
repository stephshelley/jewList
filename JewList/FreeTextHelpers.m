//
//  FreeTextHelpers.m
//  JewList
//
//  Created by Oren Zitoun on 12/7/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "FreeTextHelpers.h"
#import "User.h"

@implementation FreeTextHelpers

+ (NSString *)questionTitleForType:(FreeTextType)type {
    NSString *title = nil;
    
    switch (type) {
        case FreeTextTypeAboutMe:
            title = @"About Me";
            break;
        case FreeTextTypeDesiredMajor:
            title = @"What is your desired major?";
            break;

        default:
            break;
    }
    return title;
}

+ (NSString *)placeholderForType:(FreeTextType)type {
    NSString *title = nil;
    
    switch (type) {
        case FreeTextTypeAboutMe:
            title = @"Short text about you";
            break;
        case FreeTextTypeDesiredMajor:
            title = @"What are you going to study in college?";
            break;
            
        default:
            break;
    }
    return title;
}

+ (void)setUserValue:(NSString *)value type:(FreeTextType)type user:(User *)user {
    switch (type) {
        case FreeTextTypeAboutMe:
            user.aboutMe = value;
            break;
        case FreeTextTypeDesiredMajor:
            user.desiredMajor = value;
            break;

        default:
            break;
    }

}

@end
