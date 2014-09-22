//
//  SHMemberResultsJsonResponse.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHMemberResultsJsonResponse.h"
#import "User.h"
#import "AFHTTPRequestOperation.h"

@implementation SHMemberResultsJsonResponse

-(void)dealloc
{
    _members = nil;
}

/* Parsing the result */
- (NSError*)process:(AFHTTPRequestOperation*)requestOperation responseObject:(id)responseObject {
    NSError *error = [super process:requestOperation responseObject:responseObject];
    if (error) {
        return error;
    }
		
    NSArray *entries = self.rootObject;//[root objectForKey:@"members"];
    
    if (entries && [entries isKindOfClass:[NSArray class]] && [entries count] > 0) {
        NSMutableArray *currItems = [NSMutableArray arrayWithCapacity:[entries count]];
        
        for (NSDictionary *entry in entries) {
            User* item = [[User alloc] initWithDictionary:entry];
            
            [currItems addObject:item];
        }
        
        self.members = currItems;
    }
    else
    {
        self.members = [NSMutableArray array];
    }
    
    self.rootObject = nil;
    return nil;
    
}

@end
