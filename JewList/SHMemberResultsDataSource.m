//
//  SHMemberResultsDataSoutce.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHMemberResultsDataSource.h"
#import "User.h"
#import "SHApi.h"

@implementation SHMemberResultsDataSource

- (id)initWithCollege:(College *)college
{
    self = [super init];
    if(self)
    {
        self.college = college;
        self.model = [[SHMembersResultsModel alloc] initWithCollege:college];
        [self.model.delegates addObject:self];
    }
    return self;
}

- (void)cancel {
    [_model cancel];
}

- (void)reloadModel {
    [_model load:STURLRequestCachePolicyReloading more:NO];
}

- (void)loadModel {
    [_model load:STURLRequestCachePolicyDefault more:NO];
}

- (void)modelDidFinishLoad:(SHMembersResultsModel*)aModel
{
    self.items = [NSMutableArray arrayWithArray:aModel.items];
    
    if([self.delegate respondsToSelector:@selector(dataSourceLoaded:)]) {
        [self.delegate dataSourceLoaded:self];
    }
}

- (void)modelDidFinishLoad:(SHMembersResultsModel*)aModel withError:(NSError *)error {
    [self modelDidFinishLoad:aModel];
}

@end
