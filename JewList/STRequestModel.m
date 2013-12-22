/*
 *  File    : STRequestModel.m
 *  Project : Storm Frontend
 *
 *  Description : This class will handle network requests using AFnetworking JsonRequest Operations
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/12/12.
 *  Copyright 2010-2011 MilestoneLab. All rights reserved.
 *
 */

#import "NSString+NimbusCore.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "STRequestModel.h"

#define kLGURLRequestModelCacheName @"kLGURLRequestModelCacheName"

@implementation STRequestModel
@synthesize hasNoMore       = _hasNoMore;
@synthesize loadingRequest  = _loadingRequest;
@synthesize cacheKey        = _cacheKey;
@synthesize loadedTime      = _loadedTime;


+(TTURLCache*)cache {
    return [TTURLCache cacheWithName:kLGURLRequestModelCacheName];
}

- (void)dealloc {
    [_loadingRequest cancel];
    _loadingRequest = nil;
    _cacheKey = nil;
    _loadedTime = nil;
    
}

- (void)load:(STURLRequestCachePolicy)cachePolicy less:(BOOL)less {
    [self cancel];
    
    _isLoadingMore = NO;
    _isLoadingLess = less;
    _isLoading = YES;
}

- (void)load:(STURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    [self cancel];
    
    _isLoadingMore = more;
    _isLoadingLess = NO;
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
    shouldGetFromCache:(BOOL)shouldGetFromCache
            forceCache:(BOOL)forceCache
{
    _forceCache = forceCache;
    [self createRequest:urlRequest
                success:success
                failure:failure
 responseProcessorClass:responseProcessorClass
     shouldGetFromCache:shouldGetFromCache
        withAutoRelogin:YES];
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
    shouldGetFromCache:(BOOL)shouldGetFromCache
{
    _forceCache = NO;
    [self createRequest:urlRequest
                success:success
                failure:failure
 responseProcessorClass:responseProcessorClass
     shouldGetFromCache:shouldGetFromCache
        withAutoRelogin:YES];
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
    shouldGetFromCache:(BOOL)shouldGetFromCache
       withAutoRelogin:(BOOL)autorelogin
{
    _shouldGetCache = shouldGetFromCache;
    
    //[urlRequest setHTTPShouldUsePipelining:YES];
    
    //[urlRequest setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    __unsafe_unretained __block STRequestModel *weakSelf = (STRequestModel *)self;
    
    LGJSONRequestOperation *requestOperation =
    [LGJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                                                    success:^(LGJSONRequestOperation *requestOperation,
                                                              LGURLJSONResponse *responseProcessor,
                                                              id JSON) {
                                                        if (shouldGetFromCache) {
                                                            self.cacheKey = [self generateCacheKey:urlRequest];
                                                        }
                                                        
                                                        _fetchingFromCache = NO;
                                                        self.loadedTime = [NSDate date];
                                                        self->_isLoaded = YES;
                                                        self->_isLoading = NO;
                                                        if (success) {
                                                            success(requestOperation, responseProcessor, JSON);
                                                        }
                                                        [self didFinishLoad];
                                                        
                                                        if (_shouldGetCache || _forceCache)
                                                        {
                                                            dispatch_async(dispatch_queue_create("CACHE", DISPATCH_QUEUE_SERIAL), ^{
                                                                NSString *cacheKey = [self generateCacheKey:urlRequest];
                                                                NSData *storedData = [NSKeyedArchiver archivedDataWithRootObject:JSON];
                                                                [[TTURLCache cacheWithName:kLGURLRequestModelCacheName] storeData:storedData
                                                                                                                           forKey:cacheKey];
                                                                
                                                                BD_LOG(@"going to store response for:%@",[[urlRequest URL] absoluteString]);
                                                            });
                                                        }
                                                    }
                                                    failure:^(LGJSONRequestOperation *requestOperation,
                                                              LGURLJSONResponse *responseProcessor,
                                                              NSError *error,
                                                              id JSON) {
                                                        
                                                    }
                                          responseProcessor:[[responseProcessorClass alloc] init]];
    [self setRequest:requestOperation];
    
    if (shouldGetFromCache) {
        
        dispatch_async(dispatch_queue_create("CACHE", DISPATCH_QUEUE_CONCURRENT), ^{
            NSString *cacheKey = [weakSelf generateCacheKey:urlRequest];
            if ([[TTURLCache cacheWithName:kLGURLRequestModelCacheName] hasDataForKey:cacheKey expires:SH_DEFAULT_CACHE_INVALIDATION_AGE]) {
                NSDate *timestamp;
                NSData *cachedData = [[TTURLCache cacheWithName:kLGURLRequestModelCacheName] dataForKey:cacheKey
                                                                                                expires:SH_DEFAULT_CACHE_INVALIDATION_AGE
                                                                                              timestamp:&timestamp];
                weakSelf->_isLoaded = YES;
                
                id rootObject = [NSKeyedUnarchiver unarchiveObjectWithData:cachedData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success && rootObject) {
                        
                        BD_LOG(@"succesfuly restored response for:%@",[[urlRequest URL] absoluteString]);
                        
                        LGURLJSONResponse *cachedReponseProcessor = [[responseProcessorClass alloc] init];
                        cachedReponseProcessor.isCachedResponse = YES;
                        [cachedReponseProcessor process:requestOperation responseObject:rootObject];
                        success(requestOperation, cachedReponseProcessor, rootObject);
                    }
                    if (rootObject) {
                        weakSelf->_fetchingFromCache = YES;
                        [weakSelf didFinishLoad];
                        
                    }
                });
                    
                weakSelf.loadedTime = timestamp;
            }
        });
    }
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
    if(self.loadingRequest.request.URL.absoluteString)
    {
        BD_LOG(@"\n\nCanceling Request = %@\n\n",self.loadingRequest.request.URL.absoluteString);
        
    }
    
    [self.loadingRequest cancel];
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    _isLoading = NO;
}




@end
