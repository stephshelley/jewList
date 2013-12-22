//
//  SHMemberResultsDataSoutce.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHMemberResultsDataSource.h"
#import "SHUserCellItem.h"
#import "SHApi.h"

@implementation SHMemberResultsDataSource

- (id)initWithCollege:(College *)college
{
    self = [super init];
    if(self)
    {
        self.college = college;
        _model = [[SHMembersResultsModel alloc] initWithCollege:college];
        [_model.delegates addObject:self];
    }
    
    return self;
}

- (void)cancel
{
    [_model cancel];
    
}

- (void)reloadModel
{
    [_model load:STURLRequestCachePolicyReloading more:NO];
}

- (void)loadModel
{
    [_model load:STURLRequestCachePolicyDefault more:NO];
    
}

- (void)generateDemoItems
{
    User *demoUser = [[SHApi sharedInstance] currentUser];
    self.items = [NSMutableArray array];

    for(int i = 0; i < 10; i++)
    {
        SHUserCellItem *item = [[SHUserCellItem alloc] init];
        item.user = demoUser;
        [self.items addObject:item];
        
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataSourceLoaded:)])
        [self.delegate dataSourceLoaded:self];

}

- (void)modelDidFinishLoad:(SHMembersResultsModel*)aModel
{
    self.items = [NSMutableArray array];
    
    for(User *user in aModel.items)
    {
        SHUserCellItem *item = [[SHUserCellItem alloc] init];
        item.user = user;
        [self.items addObject:item];
        
    }
  
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(dataSourceLoaded:)])
        [self.delegate dataSourceLoaded:self];
    
}

- (void)modelDidFinishLoad:(SHMembersResultsModel*)aModel withError:(NSError *)error
{
    [self modelDidFinishLoad:aModel];
}


@end
