//
//  LGJSONRequestOperation.m
//  
//
//  Created by yosit on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LGJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
@interface LGJSONRequestOperation ()
@end


@implementation LGJSONRequestOperation
@synthesize responseProcessor = _responseProcessor;
+ (LGJSONRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(LGJSONRequestOperation *requestOperation, LGURLJSONResponse *responseProcessor, id JSON))success 
                                                    failure:(void (^)(LGJSONRequestOperation *requestOperation, LGURLJSONResponse *responseProcessor, NSError *error, id JSON))failure 
                                          responseProcessor:(LGURLJSONResponse*)responseProccessor
{
    
    LGJSONRequestOperation *_requestOperation = [[self alloc] initWithRequest:urlRequest];
    _requestOperation.responseProcessor = responseProccessor;
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];

    __weak LGJSONRequestOperation *requestOperation = _requestOperation;
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];

            success(requestOperation, responseProccessor, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];

            failure(requestOperation, responseProccessor, error, [(AFJSONRequestOperation *)operation responseJSON]);
        }
    }];
    
    return requestOperation;
}

-(void) dealloc {
    _responseProcessor = nil;

}

- (id)responseJSON {
    id superResponse = [super responseJSON];
    if ([self error]) {
        return superResponse;
    }
    [self.responseProcessor process:self responseObject:superResponse];
    return superResponse;
}

@end
