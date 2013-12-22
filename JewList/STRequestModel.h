/*
 *  File    : STRequestModel.h
 *  Project : Storm Frontend
 *
 *  Description : This class will handle network requests using AFnetworking JsonRequest Operations
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/12/12.
 *  Copyright 2010-2011 MilestoneLab. All rights reserved.
 *
 */

#import "STBaseDataModel.h"
#import "LGJSONRequestOperation.h"
#import "TTURLCache.h"

@interface STRequestModel : STBaseDataModel
{
    
    BOOL          _isLoadingMore;
    BOOL          _isLoaded;
    BOOL          _hasNoMore;
    BOOL          _hasNoLess;
    BOOL          _isLoading;
    BOOL          _isLoadingLess;
    
}

@property (nonatomic) BOOL forceCache;
@property (nonatomic) BOOL shouldGetCache;
@property (nonatomic) BOOL fetchingFromCache;

/* Bool to use for paging purposes */
@property (nonatomic) BOOL hasNoMore;

/* The json request operation */
@property (nonatomic,strong) AFJSONRequestOperation* loadingRequest;

/**
 * Valid upon completion of the URL request. Represents the timestamp of the completed request.
 */
@property (nonatomic, retain) NSDate*   loadedTime;

/**
 * Valid upon completion of the URL request. Represents the request's cache key.
 */
@property (nonatomic, copy)   NSString* cacheKey;

/**
 * Resets the model to its original state before any data was loaded.
 */
- (void)reset;
- (void)start;

/* Creating the request and proccesing the result*/
- (void)createRequest:(NSMutableURLRequest *)urlRequest
              success:(void (^)(LGJSONRequestOperation *requestOperation,
                                LGURLJSONResponse *responseProcessor,
                                id JSON))success
              failure:(void (^)(LGJSONRequestOperation *requestOperation,
                                LGURLJSONResponse *responseProcessor,
                                NSError *error,
                                id JSON))failure
responseProcessorClass:(Class)responseProcessorClass ;

- (void) createRequest:(NSMutableURLRequest *)urlRequest
               success:(void (^)(LGJSONRequestOperation *requestOperation,
                                 LGURLJSONResponse *responseProcessor,
                                 id JSON))success
               failure:(void (^)(LGJSONRequestOperation *requestOperation,
                                 LGURLJSONResponse *responseProcessor,
                                 NSError *error,
                                 id JSON))failure
responseProcessorClass:(Class)responseProcessorClass
    shouldGetFromCache:(BOOL)shouldGetFromCache ;

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
       withAutoRelogin:(BOOL)autorelogin;


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
            forceCache:(BOOL)forceCache;

+(TTURLCache*)cache;

@end
