//
//  SHMemberResultsDataSoutce.h
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "STBaseDataSource.h"
#import "SHMembersResultsModel.h"
#import "College.h"

@interface SHMemberResultsDataSource : STBaseDataSource

@property (nonatomic, strong) SHMembersResultsModel *model;
@property (nonatomic, strong) College *college;

- (id)initWithCollege:(College *)college;
- (void)cancel;

@end
