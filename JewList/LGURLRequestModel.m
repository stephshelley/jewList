//
//  LGNIURLRequestModel.m
//
//  Created by Yosi Taguri on 5/24/12.
//  Copyright (c) 2012 Labgoo LTD. All rights reserved.
//

#import "NSString+NimbusCore.h"

#import "LGURLRequestModel.h"

#define kLGURLRequestModelCacheName @"kLGURLRequestModelCacheName"
@implementation LGURLRequestModel

@synthesize hasNoMore       = _hasNoMore;
@synthesize loadingRequest  = _loadingRequest;
@synthesize cacheKey        = _cacheKey;
@synthesize loadedTime      = _loadedTime;

/*+(TTURLCache*)cache {
    return [TTURLCache cacheWithName:kLGURLRequestModelCacheName];
}*/

- (void)dealloc {
    [_loadingRequest cancel];
    _loadingRequest = nil;
    _cacheKey = nil;
    _loadedTime = nil;

}


- (void)load:(STURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    [self cancel];
    
    _isLoadingMore = more;
    _isLoading = YES;
}

- (void)reset {
    _isLoaded = NO;
    _isLoading = NO;
}

- (NSString*)generateCacheKey:(NSURLRequest *)urlRequest {
    return [[[urlRequest URL] absoluteString] md5Hash];
}


- (void) createRequest:(NSMutableURLRequest *)urlRequest
               success:(void (^)(LGJSONRequestOperation *requestOperation, 
                                 LGURLJSONResponse *responseProcessor, 
                                 id JSON))success 
               failure:(void (^)(LGJSONRequestOperation *requestOperation, 
                                 LGURLJSONResponse *responseProcessor, 
                                 NSError *error, 
                                 id JSON))failure 
     responseProcessorClass:(Class)responseProcessorClass 
    shouldGetFromCache:(BOOL)shouldGetFromCache {
    
    _shouldGetCache = shouldGetFromCache;
    
    [urlRequest setHTTPShouldUsePipelining:YES];

    [urlRequest setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];

    LGJSONRequestOperation *requestOperation = 
    [LGJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                                                    success:^(LGJSONRequestOperation *requestOperation, 
                                                              LGURLJSONResponse *responseProcessor,
                                                              id JSON) {
                                                        if (shouldGetFromCache) {
                                                            self.cacheKey = [self generateCacheKey:urlRequest];
                                                        }
                                                        self.loadedTime = [NSDate date];
                                                        self->_isLoaded = YES;
                                                        self->_isLoading = NO;
                                                        if (success) {
                                                            success(requestOperation, responseProcessor, JSON);
                                                        }
                                                        [self didFinishLoad];
                                                        if (shouldGetFromCache) {
                                                           
                                                        }
                                                    } 
                                                    failure:^(LGJSONRequestOperation *requestOperation, 
                                                              LGURLJSONResponse *responseProcessor, 
                                                              NSError *error, 
                                                              id JSON) {
                                                        self->_isLoading = NO;
                                                        if (failure) {
                                                            failure(requestOperation, 
                                                                    responseProcessor, 
                                                                    [NSError errorWithDomain:(error.domain == nil) ? @"URLRequest" : error.domain
                                                                                        code:requestOperation.response.statusCode 
                                                                                    userInfo:error.userInfo], 
                                                                    JSON);
                                                        }
                                                        if (![requestOperation isCancelled]) {
                                                            [self didFailLoadWithError:error];
                                                        }
                                                    } 
                                          responseProcessor:[[responseProcessorClass alloc] init]];
    [self setRequest:requestOperation];

}

- (void) createRequest:(NSMutableURLRequest *)urlRequest
               success:(void (^)(LGJSONRequestOperation *requestOperation, 
                                 LGURLJSONResponse *responseProcessor, 
                                 id JSON))success 
               failure:(void (^)(LGJSONRequestOperation *requestOperation, 
                                 LGURLJSONResponse *responseProcessor, 
                                 NSError *error, 
                                 id JSON))failure 
responseProcessorClass:(Class)responseProcessorClass  {    
    [self createRequest:urlRequest success:success failure:failure responseProcessorClass:responseProcessorClass shouldGetFromCache:NO];
}

- (void)setRequest:(LGJSONRequestOperation*)request {
    if (request != _loadingRequest) {
        [self willChangeValueForKey:@"loadingRequest"];
        [_loadingRequest cancel];
        _loadingRequest = nil;
        _loadingRequest = request;
        [self didChangeValueForKey:@"loadingRequest"];
    }
}

- (void)start {
    _isLoading = YES;
    [self didStartLoad];
    [self.loadingRequest start];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded {
    return _isLoaded;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoading {
    return _isLoading;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoadingMore {
    return _isLoadingMore;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
    [self.loadingRequest cancel];
    _loadingRequest = nil;
    _isLoading = NO;
}

- (void)invalidate:(BOOL)erase {
    if (nil != _cacheKey) {
        if (erase) {
          //  [[TTURLCache cacheWithName:kLGURLRequestModelCacheName] removeKey:_cacheKey];
            
        } else {
           // [[TTURLCache cacheWithName:kLGURLRequestModelCacheName] invalidateKey:_cacheKey];
        }
        
        _cacheKey = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isOutdated {
    if (nil == _cacheKey) {
        return nil != _loadedTime && _shouldGetCache;
        
    } else {
        NSDate* loadedTime = self.loadedTime;
        
        if (nil != loadedTime) {
          //  return -[loadedTime timeIntervalSinceNow] > [TTURLCache cacheWithName:kLGURLRequestModelCacheName].invalidationAge;
            return NO;
        } else {
            return NO;
        }
    }
}

@end
