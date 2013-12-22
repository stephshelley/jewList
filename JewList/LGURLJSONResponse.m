//
//  LGURLJSONResponse.m
//
//  Created by Yosi Taguri on 5/24/12.
//  Copyright (c) 2012 Labgoo LTD. All rights reserved.
//

#import "LGURLJSONResponse.h"
#import "JSON.h"

NSString* const kSTORMExtJSONErrorDomain = @"Storm.json.not_dictionanry_or_array_or_nil";
NSInteger const kSTORMExtJSONErrorCodeInvalidJSON = 100;

@implementation LGURLJSONResponse
@synthesize rootObject       = _rootObject;
@synthesize isCachedResponse = _isCachedResponse;

- (void)dealloc {

    _rootObject = nil;
}

#pragma mark -
#pragma mark LGURLResponse


- (NSError*)process:(AFHTTPRequestOperation*)requestOperation responseObject:(id)responseObject {
    self.rootObject = responseObject;
    
    NSError* err = nil;
    if (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]) {
        err = [NSError errorWithDomain:kSTORMExtJSONErrorDomain
                                  code:kSTORMExtJSONErrorCodeInvalidJSON
                              userInfo:nil];
        return err;
    }
    
    return err;
}
@end

