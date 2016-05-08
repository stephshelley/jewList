//
//  MultiSelectionHelpers.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "MultiSelectionHelpers.h"
#import "User.h"

@implementation MultiSelectionHelpers

+ (NSArray *)optionsForType:(MultiSelectionType)type {
    NSArray *options = nil;
    
    switch (type) {
        case MultiSelectionTypeGender:
            options = @[@"Male", @"Female", @"Other", @"N/A"];
            break;
        case MultiSelectionTypeHighSchoolConnections:
            options = @[@"BBYO", @"USY", @"NFTY", @"NCSY", @"Young Judea",@"Jewish Camps", @"Other"];
            break;
        case MultiSelectionTypeLivingArrangment:
            options = @[@"On Campus", @"Off Campus"];
            break;
        case MultiSelectionTypeEarlyBird:
            options = @[@"Early Bird", @"Night Owl"];
            break;
        case MultiSelectionTypeCleanMessy:
            options = @[@"Organized", @"Clean Freak", @"Messy"];
            break;
        case MultiSelectionTypeWhenLookingInARoomate:
            options = @[@"Fall Semester 2016", @"Spring Semester 2017", @"Fall Semester 2018", @"Spring Semester 2019",
                        @"Fall Semester 2019", @"Spring Semester 2020", @"Fall Semester 2020", @"Spring Semester 2021"];
            break;
        case MultiSelectionTypeFun:
            options = @[@"Shabbat dinner with friends", @"A night out with friends", @"Getting work done ahead of time", @"Reading a book", @"Netflix night", @"Being outdoors", @"Joining a club"];
            break;
        case MultiSelectionTypeKosher:
            options = @[@"Yes - I am Shomer Kashrut", @"Yes / I do it my way", @"No"];
            break;
        case MultiSelectionTypeShabbat:
            options = @[@"Yes - I am Shomer Shabbat", @"Yes / I do it my way", @"No"];
            break;
        case MultiSelectionTypeMusic:
            options = @[@"Alternative", @"Blues", @"Classical Music", @"Country Music", @"Electronic Music", @"Hip Hop / Rap", @"Indie Pop", @"Jazz", @"New Age", @"Pop (Popular music)", @"R&B / Soul", @"Reggae", @"Rock"];
            break;
        case MultiSelectionTypeDuringTheDay:
            options = @[@"Taking a hike", @"Spending the day in a library", @"Reading a book", @"Cooking", @"Studying", @"Working out", @"Watching Netflix", @"Hanging out with friends", @"Shopping", @"Playing sports", @"Other"];
            break;
        case MultiSelectionTypeActivities:
            options = @[@"Greek Life", @"Jewish Life on Campus", @"Political Groups", @"Social Advocacy Groups", @"Athletics"];
            break;
        case MultiSelectionTypeWantContactFromJewishOrganizations:
            options = @[@"Yes", @"No"];
            break;
            
        default:
            break;
    }
    return options;
}

+ (NSString *)questionTitleForType:(MultiSelectionType)type {
    NSString *title = nil;
    
    switch (type) {
        case MultiSelectionTypeGender:
            title = @"My gender identity is...";
            break;
        case MultiSelectionTypeHighSchoolConnections:
            title = @"High School Jewish Connections";
            break;
        case MultiSelectionTypeLivingArrangment:
            title = @"Living Arrangement";
            break;
        case MultiSelectionTypeEarlyBird:
            title = @"Are you an early bird or a night owl?";
            break;
        case MultiSelectionTypeCleanMessy:
            title = @"Are you a clean or messy person?";
            break;
        case MultiSelectionTypeWhenLookingInARoomate:
            title = @"When are you looking for a roommate?";
            break;
        case MultiSelectionTypeFun:
            title = @"What does fun mean to you?";
            break;
        case MultiSelectionTypeKosher:
            title = @"Would you say to someone that you keep kosher?";
            break;
        case MultiSelectionTypeShabbat:
            title = @"Would you say to someone that you keep Shabbat?";
            break;
        case MultiSelectionTypeMusic:
            title = @"What music do you like to listen to?";
            break;
        case MultiSelectionTypeDuringTheDay:
            title = @"During the day, you can find me:";
            break;
        case MultiSelectionTypeActivities:
            title = @"What do you hope to get involved in on campus? If you’re already on campus, what types of organizations are you involved in?";
            break;
        case MultiSelectionTypeWantContactFromJewishOrganizations:
            title = @"Do you want to share your contact information with Jewish organizations on campus and in your area?";
            break;
            
        default:
            break;
    }
    return title;
}

+ (void)setUserValue:(NSString *)value type:(MultiSelectionType)type user:(User *)user {
    switch (type) {
        case MultiSelectionTypeGender:
            user.gender = value;
            break;
        case MultiSelectionTypeHighSchoolConnections:
            user.hsEngagement = value;
            break;
        case MultiSelectionTypeLivingArrangment:
            user.campus = value;
            break;
        case MultiSelectionTypeEarlyBird:
            user.earlyLate = value;
            break;
        case MultiSelectionTypeCleanMessy:
            user.cleanMessy = value;
            break;
        case MultiSelectionTypeFun:
            user.funMeans = value;
            break;
        case MultiSelectionTypeKosher:
            user.kosher = value;
            break;
        case MultiSelectionTypeWhenLookingInARoomate:
            user.whenLookingForARoomate = value;
            break;
        case MultiSelectionTypeShabbat:
            user.shabbatResponse = value;
            break;
        case MultiSelectionTypeMusic:
            user.music = value;
            break;
        case MultiSelectionTypeDuringTheDay:
            user.hobbies = value;
            break;
        case MultiSelectionTypeActivities:
            user.campusInvolvement = value;
            break;
        case MultiSelectionTypeWantContactFromJewishOrganizations:
            user.contactFromJewishOrgs = value;
            break;
            
        default:
            break;
    }
}

+ (NSUInteger)getIndexValueForValue:(NSString *)value type:(MultiSelectionType)type {
    NSUInteger index = 0;
    
    NSArray *options = [[self class] optionsForType:type];
    for (NSString *str in options) {
        if ([str isEqualToString:value]) {
            break;
        }
        index++;
    }
    return index;
}

+ (NSNumber *)getNumberValueForType:(MultiSelectionType)type user:(User *)user {
    NSNumber *value = nil;
    
    switch (type) {
        case MultiSelectionTypeGender:
            if ([user.gender isKindOfClass:[NSString class]]) {
                value = @([self getIndexValueForValue:user.gender type:MultiSelectionTypeGender]);
            } else if ([user.gender isKindOfClass:[NSNumber class]]) {
                value = (NSNumber *)user.gender;
            }
            
            break;
        case MultiSelectionTypeLivingArrangment:
            if ([user.campus isKindOfClass:[NSString class]]) {
                value = @([self getIndexValueForValue:user.campus type:MultiSelectionTypeLivingArrangment]);
            } else if ([user.campus isKindOfClass:[NSNumber class]]) {
                value = (NSNumber *)user.campus;
            }
            
            break;
        case MultiSelectionTypeCleanMessy:
            if ([user.cleanMessy isKindOfClass:[NSString class]]) {
                value = @([self getIndexValueForValue:user.cleanMessy type:MultiSelectionTypeCleanMessy]);
            } else if ([user.cleanMessy isKindOfClass:[NSNumber class]]) {
                value = (NSNumber *)user.cleanMessy;
            }
            
            break;
        
        case MultiSelectionTypeFun:
            if ([user.funMeans isKindOfClass:[NSString class]]) {
                value = @([self getIndexValueForValue:user.funMeans type:MultiSelectionTypeFun]);
            }
            
            break;
            
            
        default:
            break;
    }
    
    return value;
}


+ (NSString *)userValueForType:(MultiSelectionType)type user:(User *)user {
    NSString *value = nil;
    
    switch (type) {
        case MultiSelectionTypeGender:
            if ([user.gender isKindOfClass:[NSNumber class]]) {
                
                NSArray *options = [[self class] optionsForType:type];
                value = options[[(NSNumber *)user.gender integerValue]];

            }else {
                value = user.gender;
            }
            break;
        case MultiSelectionTypeHighSchoolConnections:
            value = user.hsEngagement;
            break;
        case MultiSelectionTypeLivingArrangment:
            if ([user.campus isKindOfClass:[NSNumber class]]) {
                
                NSArray *options = [[self class] optionsForType:type];
                value = options[[(NSNumber *)user.campus integerValue]];
    
            }else {
                value = user.campus;
            }
            break;
        case MultiSelectionTypeEarlyBird:
            value = user.earlyLate;
            break;
        case MultiSelectionTypeCleanMessy:
            if ([user.cleanMessy isKindOfClass:[NSNumber class]]) {
                
                NSArray *options = [[self class] optionsForType:type];
                value = options[[(NSNumber *)user.cleanMessy integerValue]];
                
            }else {
                value = user.cleanMessy;
            }
            break;
        case MultiSelectionTypeFun:
            value = user.funMeans;
            break;
        case MultiSelectionTypeKosher:
            value = user.kosher;
            break;
        case MultiSelectionTypeShabbat:
            value = user.shabbatResponse;
            break;
        case MultiSelectionTypeWhenLookingInARoomate:
            value = user.whenLookingForARoomate;
            break;
        case MultiSelectionTypeMusic:
            value = user.music;
            break;
        case MultiSelectionTypeDuringTheDay:
            value = user.hobbies;
            break;
        case MultiSelectionTypeActivities:
            value = user.campusInvolvement;
            break;
        case MultiSelectionTypeWantContactFromJewishOrganizations:
            value = user.contactFromJewishOrgs;
            break;
            
        default:
            break;
    }
    return value;
}

+ (BOOL)supportsMultiSelectionForType:(MultiSelectionType)type {
    
    BOOL supportsMultiSelection = NO;
    switch (type) {
        case MultiSelectionTypeHighSchoolConnections:
        case MultiSelectionTypeFun:
        case MultiSelectionTypeMusic:
        case MultiSelectionTypeDuringTheDay:
        case MultiSelectionTypeActivities:
            supportsMultiSelection = YES;
            
        default:
            break;
    }
    return supportsMultiSelection;
}

@end
