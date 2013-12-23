//
//  SHMembersResultsModel.m
//  JewList
//
//  Created by Oren Zitoun on 12/22/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHMembersResultsModel.h"
#import "SHApi.h"
#import "SHMemberResultsJsonResponse.h"

@implementation SHMembersResultsModel

- (id)initWithCollege:(College *)college
{
    self = [super init];
    if(self)
    {
        self.college = college;
        _resultsPerPage = 30;
        _page = 1;
        self.items = [NSMutableArray array];
        
    }
    
    return self;

}

- (void)load:(STURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    [super load:cachePolicy more:more];
    _moreIsLoading = more;
    
    NSString *endpoint = [NSString stringWithFormat:@"GetMembersBySchoolID/%@",_college.dbId];
 
    NSString* url = [[SHApi sharedInstance] apiSecureURLForPath:endpoint
                                                          andQuery:nil];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:REQUEST_TIMEOUT];
    
    int page = _page;
    [[SHApi sharedInstance] enrichNSMutableURLRequestWithAuth:request];
    
    NSLog(@"Fetching request = %@",[request.URL absoluteString]);
    
    __unsafe_unretained __block SHMembersResultsModel *weakSelf = (SHMembersResultsModel *)self;
    
    [self createRequest:request success:^(LGJSONRequestOperation *requestOperation, LGURLJSONResponse *responseProcessor, id JSON) {
        if ([responseProcessor isKindOfClass:[SHMemberResultsJsonResponse class]]) {
            
            SHMemberResultsJsonResponse* response = (SHMemberResultsJsonResponse*)responseProcessor;
            if (page == 1 || responseProcessor.isCachedResponse) {
                weakSelf.items = response.members;
            } else {
                [weakSelf.items addObjectsFromArray:response.members];
            }
            weakSelf->_page = page + 1;
            weakSelf->_finished = (response.members.count < weakSelf->_resultsPerPage);
            weakSelf->_hasMore = !weakSelf->_finished;
        }
        
    } failure:^(LGJSONRequestOperation *requestOperation, LGURLJSONResponse *responseProcessor, NSError *error, id JSON) {
        
        if(weakSelf.finished && weakSelf.currentCachePolicy == STURLRequestCachePolicyNone && [error code] == 0)
        {
            // If we display a cache response we should not display a connection error
        }else{
            //[STUIHelpers handleNetworkError:error];
            [self didFinishLoad];
            
        }
        
    }
 responseProcessorClass:[SHMemberResultsJsonResponse class]
     shouldGetFromCache:_page == 1 && cachePolicy != STURLRequestCachePolicyReloading
             forceCache:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self start];
    });
    
}


@end
