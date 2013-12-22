//
//  LGJSONRequestOperation.h
//  
//
//  Created by yosit on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "LGURLJSONResponse.h"

@interface LGJSONRequestOperation : AFJSONRequestOperation
+ (LGJSONRequestOperation *)JSONRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(LGJSONRequestOperation *requestOperation, LGURLJSONResponse *responseProcessor, id JSON))success 
                                                    failure:(void (^)(LGJSONRequestOperation *requestOperation, LGURLJSONResponse *responseProcessor, NSError *error, id JSON))failure 
                                          responseProcessor:(LGURLJSONResponse*)responseProccessor ;

@property (nonatomic, retain) LGURLJSONResponse *responseProcessor;
@end
