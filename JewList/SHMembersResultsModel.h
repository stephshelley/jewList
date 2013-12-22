//
//  SHMembersResultsModel.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "STBaseDataModel.h"
#import "STRequestModel.h"
#import "College.h"

@interface SHMembersResultsModel : STRequestModel

@property (nonatomic, assign) STURLRequestCachePolicy currentCachePolicy;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *selectedUsers;
@property (nonatomic, strong) College *college;
@property (nonatomic, assign) NSUInteger resultsPerPage;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, readonly) BOOL finished;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL moreIsLoading;

- (id)initWithCollege:(College *)college;

@end
