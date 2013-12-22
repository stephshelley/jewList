//
//  SHMemberResultsJsonResponse.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "LGURLJSONResponse.h"

@interface SHMemberResultsJsonResponse : LGURLJSONResponse

/* Results array */
@property (nonatomic, strong) NSMutableArray *members;

@end
