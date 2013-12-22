//
//  LGURLResponse.h
//
//  Created by Yosi Taguri on 5/24/12.
//  Copyright (c) 2012 Labgoo LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@protocol LGURLResponse <NSObject>
@required

- (NSError*)process:(AFHTTPRequestOperation*)requestOperation responseObject:(id)responseObject;
@optional

- (NSError*)request:(AFHTTPRequestOperation*)requestOperation processErrorResponse:(NSHTTPURLResponse*)response
               data:(id)data;
@end
