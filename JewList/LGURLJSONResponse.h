//
//  LGURLJSONResponse.h
//
//  Created by Yosi Taguri on 5/24/12.
//  Copyright (c) 2012 Labgoo LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGURLResponse.h"

@interface LGURLJSONResponse : NSObject <LGURLResponse> {
    id _rootObject;
}

@property (nonatomic, strong) id    rootObject;
@property (nonatomic, assign) BOOL  isCachedResponse;   //is this a response coming back from a cache?
@end