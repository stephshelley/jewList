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
            options = @[@"Female", @"Male", @"Other", @"N/A"];
            break;
        case MultiSelectionTypeHighSchoolConnections:
            options = @[@"BBYO", @"USY", @"NFTY", @"NCSY", @"Young Judea", @"Other"];
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
        case MultiSelectionTypeFun:
            options = @[@"Shabbat dinner with friends", @"A night out with friends", @"Getting work done ahead of time", @"Reading a book", @"Netflix Night", @"Being Outdoors"];
            break;
        case MultiSelectionTypeKosher:
            options = @[@"Yes - I am Shomer Kashrut", @"Yes", @"No"];
            break;
        case MultiSelectionTypeShabbat:
            options = @[@"Yes - I am Shomer Shabbat", @"Yes", @"No"];
            break;
        case MultiSelectionTypeMusic:
            options = @[@"Alternative", @"Blues", @"Classical Music", @"Country Music", @"Electronic Music", @"Hip Hop / Rap", @"Indie Pop", @"Jazz", @"New Age", @"Pop (Popular music)", @"R&B / Soul", @"Reggae", @"Rock"];
            break;
        case MultiSelectionTypeDuringTheDay:
            options = @[@"Taking a hike", @"Spending the day in a library", @"Reading a book", @"Cooking", @"Study", @"Workout", @"Watching Netflix", @"Hanging out with Friends", @"Shopping", @"Playing Sports", @"Other"];
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
            title = @"Gender";
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
            user.earlyBird = value;
            break;
        case MultiSelectionTypeCleanMessy:
            user.cleaning = value;
            break;
        case MultiSelectionTypeFun:
            user.fun = value;
            break;
        case MultiSelectionTypeKosher:
            user.kosher = value;
            break;
        case MultiSelectionTypeShabbat:
            user.shabat = value;
            break;
        case MultiSelectionTypeMusic:
            user.music = value;
            break;
        case MultiSelectionTypeDuringTheDay:
            user.duringTheDay = value;
            break;
        case MultiSelectionTypeActivities:
            user.activities = value;
            break;
        case MultiSelectionTypeWantContactFromJewishOrganizations:
            user.contactFromJewishOrgs = value;
            break;
            
        default:
            break;
    }
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
