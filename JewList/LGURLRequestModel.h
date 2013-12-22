//
//  LGNIURLRequestModel.h
//
//  Created by Yosi Taguri on 5/24/12.
//  Copyright (c) 2012 Labgoo LTD. All rights reserved.
//

#import "LGJSONRequestOperation.h"
//#import "Three20Network/TTURLCache.h"
#import "STBaseDataModel.h"

@interface LGURLRequestModel : STBaseDataModel {
    AFJSONRequestOperation* _loadingRequest;
    
    BOOL          _isLoadingMore;
    BOOL          _isLoaded;
    BOOL          _hasNoMore;
    BOOL          _isLoading;
    BOOL          _shouldGetCache;
}

/**
 * Not used internally, but intended for book-keeping purposes when making requests.
 */
@property (nonatomic) BOOL hasNoMore;
@property (nonatomic, retain) AFJSONRequestOperation* loadingRequest;

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
- (void)start ;
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

//+(TTURLCache*)cache;
@end