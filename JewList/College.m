//
//  SHCollege.m
//  JewList
//
//  Created by Oren Zitoun on 7/20/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "College.h"

@implementation College


-(id)copyWithZone:(NSZone *)zone
{
    College *newCollege = [[College alloc] init];
    newCollege.dbId = [self.dbId copyWithZone:zone];
    newCollege.name = [_name copyWithZone:zone];
    return newCollege;
    
}

@end
