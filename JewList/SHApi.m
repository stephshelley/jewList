//
//  SHApi.m
//  JewList
//
//  Created by Oren Zitoun on 7/19/13.
//  Copyright (c) 2013 Oren Zitoun. All rights reserved.
//

#import "SHApi.h"
#import "AppDelegate.h"
#import "User.h"
#import "NSURL+NXOAuth2.h"
#import "NXOAuth2PostBodyStream.h"
#import "JSON.h"
#import "JSONKit.h"
#import "NSURL+NXOAuth2.h"
#import "SHAccessToken.h"
#import "College.h"

@interface SHApi (Private)

+ (NSString *)dataFilePath:(NSString *)fileName;
+ (BOOL)deleteDataFile:(NSString *)fileName error:(NSError **)err;

@end

static NSString *kCurrentUserPath = @"current_user";

@implementation SHApi

@synthesize currentUser = _currentUser;
@synthesize currentUserDetails = _currentUserDetails;
@synthesize shAccessToken = _shAccessToken;
@synthesize shLoginPassword = _shLoginPassword;

+ (id)sharedInstance {
    static dispatch_once_t pred;
    static SHApi *obj = nil;
	
    dispatch_once(&pred, ^{ obj = [[self alloc] init]; });
    return obj;
}

+ (NSString *)dataFilePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    return [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat", fileName]];
}
+ (BOOL)deleteDataFile:(NSString *)fileName error:(NSError **)err {
    NSFileManager *fm = [NSFileManager defaultManager];
	BOOL exists = [fm fileExistsAtPath:fileName];
	if (exists) return [fm removeItemAtPath:fileName error:err];
	return exists;
}

// Handle Login/Passwor

- (void)setStLoginPassword:(SHLoginPassword *)shLoginPassword
{
    if (_shLoginPassword) {
        [self.shLoginPassword removeFromDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
		_shLoginPassword = nil;
	}
	if (shLoginPassword) {
		_shLoginPassword = shLoginPassword;
    }
    
    [self.shLoginPassword storeInDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
    
}

- (SHLoginPassword *)stLoginPassword
{
	if (_shLoginPassword) return _shLoginPassword;
	
    _shLoginPassword = [SHLoginPassword loginPasswordFromDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
    return _shLoginPassword;
}

- (BOOL)userIsConnected
{
    return ([self userLogin] != nil);
}

- (void)saveUserLogin:(NSString *)login andPassword:(NSString *)password
{
    [self cleanUserLoginAndPassword];
    if((login != nil) && (password != nil)){
        self.stLoginPassword = [[SHLoginPassword alloc] initWithLogin:login andPassword:password];
    }
}

- (void)cleanUserLoginAndPassword
{
    [self.stLoginPassword removeFromDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
    _shLoginPassword = nil;
}

- (NSString *)userLogin
{
    return self.stLoginPassword.login;
}

- (NSString *)userPassword
{
    return self.stLoginPassword.password;
}

- (User *)currentUser
{
	if (!_currentUser) {
		_currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[SHApi dataFilePath:kCurrentUserPath]];
        if (_currentUser) BD_LOG(@"StormApi#currentUser from file:");
	}
	return _currentUser;
}

- (NSDictionary *)currentUserDetails
{
    return _currentUserDetails;
}

- (void)setCurrentUserDetails:(NSDictionary *)currentUserDetails
{
   	if (_currentUserDetails == currentUserDetails && currentUserDetails != nil) return;
	if (_currentUserDetails) {
		_currentUserDetails = nil;
	}
    
    _currentUserDetails = currentUserDetails;
}

- (void)cacheCurrentUserDetails
{
    if(nil != _currentUser)
    {
        if(![NSKeyedArchiver archiveRootObject:_currentUser toFile:[SHApi dataFilePath:kCurrentUserPath]])
        {
            BD_LOG(@"user object cache failed");
        }
    }
    
}

- (void)setCurrentUser:(User *)currentUser {
    
    if(currentUser == nil)
    {
        [SHApi deleteDataFile:[SHApi dataFilePath:kCurrentUserPath] error:nil];
		_currentUser = nil;
        return;
    }
    
	if (_currentUser == currentUser && currentUser != nil) return;
    
	if (_currentUser) {
		_currentUser = nil;
	}
	if (currentUser) {
		_currentUser = currentUser;
        
        
		
		if(![NSKeyedArchiver archiveRootObject:_currentUser toFile:[SHApi dataFilePath:kCurrentUserPath]])
        {
            BD_LOG(@"user object cache failed");
            
        }
        
		dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentUserUpdated" object:currentUser];
        });
	}
	else {
		[SHApi deleteDataFile:[SHApi dataFilePath:kCurrentUserPath] error:nil];
        
        //clean the network cache.
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
		BD_LOG(@"StormApi#setCurrentUser = nil");
	}
}

/* Setting a new access token */
- (void)setStAccessToken:(SHAccessToken *)shAccessToken
{
    if(shAccessToken == nil)
    {
        [SHApi deleteDataFile:[SHApi dataFilePath:kCurrentUserPath] error:nil];
		_currentUser = nil;
        return;
    }
    
	if (_shAccessToken == shAccessToken && shAccessToken != nil) return;
    
	if (_shAccessToken) {
        [self.shAccessToken removeFromDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
		_shAccessToken = nil;
	}
	if (shAccessToken) {
		_shAccessToken = shAccessToken;
    }
    
    [self.shAccessToken storeInDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
    
}

- (SHAccessToken *)shAccessToken
{
	if (_shAccessToken) return _shAccessToken;
	
    _shAccessToken = [SHAccessToken tokenFromDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
    return _shAccessToken;
}

- (void)logout
{
    /*
    [self logoutUser:^(void){
        STORM_LOG(@"logout Success");
    }failure:^(NSError *error)
     {
         STORM_LOG(@"failed to logout");
     }];
     */
    
    [_shAccessToken removeFromDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
    [_shLoginPassword removeFromDefaultKeychainWithServiceProviderName:kSCHMOOZ_HOST];
    
    NSString *path_user = [SHApi dataFilePath:kCurrentUserPath];
    if(path_user && [[NSFileManager defaultManager] fileExistsAtPath:path_user])
    {
        [[NSFileManager defaultManager] removeItemAtPath:path_user error:nil];
    }
    
    _shAccessToken = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogedOutNotification object:nil];
        
    });
        
}

- (id)getColleges:(void (^)(NSArray *colleges))success
          failure:(void (^)(NSError * error))failure
{
    return [self standardDictionaryRequestWithPath:@"questions/college"
                                            params:nil
                                            method:@"GET"
                                      noAuthNeeded:YES
                                           success:^(id result) {
                                               if([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"answers"])
                                               {
                                                   NSArray *results = [result objectForKey:@"answers"];
                                                   
                                                   NSMutableArray *colleges = [NSMutableArray array];
                                                   for(NSDictionary *dict in results)
                                                   {
                                                       College *college = [[College alloc] initWithDictionary:dict];
                                                       [colleges addObject:college];
                                                       
                                                   }
                                                   
                                                   success(colleges);
                                                   
                                               }else{
                                                   if([result objectForKey:@"error"])
                                                   {
                                                       //[UIHelpers handleApiError:[result objectForKey:@"error"]];
                                                   }
                                                   
                                                   failure(nil);
                                               }
                                               
                                           }
                                           failure:failure];
}

/* Login with credintials */
- (id)loginInWithEmail:(NSString *)email
           andPassword:(NSString*)password
               success:(void (^)(void))success
               failure:(void (^)(NSError * error))failure
{
    
    return [self standardDictionaryRequestWithPath:@"auth"
                                            params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    SAFE_VAL(email), @"identity",
                                                    SAFE_VAL(password), @"password",
                                                    nil]
                                            method:@"POST"
                                      noAuthNeeded:YES
                                           success:^(id result) {
                                               if([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"auth_token"])
                                               {
                                                   SHAccessToken *token = [[SHAccessToken alloc] initWithAccessToken:[result objectForKey:@"auth_token"]];
                                                   [self setShAccessToken:token];
                                                   
                                                   User *user = nil;
                                                   if([result objectForKey:@"user"])
                                                   {
                                                       user = [[User alloc] initWithDictionary:[result objectForKey:@"user"]];
                                                   }else{
                                                       user = [[User alloc] init];
                                                       user.email = [result objectForKey:@"email"];
                                                       user.dbId = [NSString stringWithFormat:@"%d",[[result objectForKey:@"id"] intValue]];
                                                       user.username = [result objectForKey:@"username"];
                                                   }
                                                
                                                   [self saveUserLogin:email andPassword:password];
                                                   [self setCurrentUser:user];
                                                   
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:kUserSessionChangeNotification object:kUserNewSessionLogin];
                                                       
                                                   });
                                                   
                                                   success();
                                                   
                                               }else{
                                                   if([result objectForKey:@"error"])
                                                   {
                                                       //[STUIHelpers handleApiError:[result objectForKey:@"error"]];
                                                   }
                                                   
                                                   failure(nil);
                                               }
                                               
                                           }
                                           failure:failure];
}









- (void)cancelRequest:(id)request
{
    if (!request) return;
    
	Class requestClass = [request class];
    
    if (requestClass == [AFURLConnectionOperation class]) {
		[((AFURLConnectionOperation *)request) cancel];
	}

}








////////////////////////////////////////////////////////////////////////////////////////////////

- (id)standardRequestWithPath:(NSString *)path
					   params:(NSDictionary *)params
                       method:(NSString *)method
                 noAuthNeeded:(BOOL)noAuth
					  success:(void (^)(id))success
					  failure:(void (^)(NSError *error))failure {
	
	NSMutableURLRequest *request;
	
	if (params && [params objectForKey:@"https"]) {
		NSMutableDictionary *mutableCopy = [params mutableCopy];
		[mutableCopy removeObjectForKey:@"https"];
		params = mutableCopy;
		
		request = [self apiSecureRequestForPath:path andQuery:nil forMethod:method];
	}
	else {
		request = [self apiRequestForPath:path andQuery:nil forMethod:method];
	}
    
    [self applyParameters:params onRequest:request];
    
    if(!noAuth)
        [self enrichNSMutableURLRequestWithAuth:request];
    
    
    request.timeoutInterval = 60.0;
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    AFURLConnectionOperation *_requestOperation = [[AFURLConnectionOperation alloc] initWithRequest:request];
    __unsafe_unretained __block AFURLConnectionOperation *requestOperation = _requestOperation;
    
    //__unsafe_unretained __block SHApi *weakSelf = (SHApi *)self;
    
    [requestOperation setCompletionBlock:^
     {
         [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
         
         if(requestOperation.error)
         {
             NSError *error = requestOperation.error;
             
             BD_LOG(@"standardRequestWithPath %@ error - %@ | ui: %@ error code = %d", path, error, [error userInfo],[error code]);
             BD_LOG(@"errors = %@",[[error userInfo] objectForKey:@"errors"]);
             
             if (failure && ([requestOperation.error code] != NSURLErrorCancelled)) failure(error);
         }else{
             
             BD_LOG(@"response string = %@",requestOperation.responseString);
             BD_LOG(@"response data size = %db",[requestOperation.responseData length]);

             if (success) success([self jsonToDictionary:requestOperation.responseData]);

         }
                  
     }];
    
    [requestOperation start];
    return request;
}


- (NSMutableURLRequest *)apiSecureRequestForPath:(NSString *)path forMethod:(NSString *)method {
	NSString *URLString = [self apiSecureURLForPath:path andQuery:nil];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
	
	[request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
	
	request.HTTPMethod = method;
	return request;
}

- (NSMutableURLRequest *)apiSecureRequestForPath:(NSString *)path andQuery:(NSString*)query forMethod:(NSString *)method {
	NSString *URLString = [self apiSecureURLForPath:path andQuery:nil];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
	
	[request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody: [query dataUsingEncoding:NSUTF8StringEncoding]];
    
	request.HTTPMethod = method;
	return request;
}

- (NSMutableURLRequest *)apiRequestForPath:(NSString *)path andQuery:(NSString*)query forMethod:(NSString *)method {
	NSString *URLString = [self apiURLForPath:path andQuery:query];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
	[request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
	
	request.HTTPMethod = method;
	return request;
}

- (NSString *)apiURLForPath:(NSString *)path {
	return [self apiURLForPath:path andQuery:nil];
}


- (NSString *)apiURLForPath:(NSString *)path andQuery:(NSString *)query {
	NSMutableString *urlString = [NSMutableString stringWithFormat:kSCHMOOZ_API_ACTION_BASE_URL, [NSString stringWithFormat:@"%@", path]];
	if (query) [urlString appendFormat:@"?%@", query];
    BD_LOG(@"API URL Returned: %@", urlString);
	return urlString;
}

- (NSString *)apiSecureURLForPath:(NSString *)path andQuery:(NSString *)query {
	NSMutableString *urlString = [NSMutableString stringWithFormat:kSCHMOOZ_API_ACTION_BASE_URL, [NSString stringWithFormat:@"%@", path]];
	if (query) [urlString appendFormat:@"?%@", query];
    BD_LOG(@"Secure API URL Returned: %@", urlString);
	return urlString;
}


- (void)enrichNSMutableURLRequestWithAuth:(NSMutableURLRequest *)request {
    if (![request isKindOfClass:[NSMutableURLRequest class]]) {
        return;
    }
        
    if (self.shAccessToken.authToken) {
        [request setValue:[NSString stringWithFormat:@"%@",self.shAccessToken.authToken] forHTTPHeaderField:@"SOMETOKENHEADER"];
        
	}
    
}

- (void)enrichNSMutableURLRequestWithAuthLikeGet:(NSMutableURLRequest *)request {
    if (![request isKindOfClass:[NSMutableURLRequest class]]) {
        return;
    }
	
    if (self.shAccessToken.authToken) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:self.shAccessToken.authToken forKey:@"auth_token"];
        request.URL = [request.URL nxoauth2_URLByAddingParameters:params];
	}
    
}

- (id)standardItemRequestWithPath:(NSString *)path
						   params:(NSDictionary *)params
                           method:(NSString *)method
                     noAuthNeeded:(BOOL)noAuth
						  success:(void (^)(id result))success
						  failure:(void (^)(NSError *error))failure {
	
	return [self standardDictionaryRequestWithPath:path
											params:params
                                            method:(NSString *)method
                                      noAuthNeeded:noAuth
										   success:^(NSDictionary *data) {
                                               success(data );
                                           }
										   failure:failure];
}

- (id)typedItemRequestWithPath:(NSString *)path
				   outputClass:(Class)outputClass
						params:(NSDictionary *)params
                        method:(NSString *)method
                  noAuthNeeded:(BOOL)noAuth
					   success:(void (^)(id result))success
					   failure:(void (^)(NSError *error))failure {
	
	
	return [self standardDictionaryRequestWithPath:path
                                            params:params
                                            method:method
                                      noAuthNeeded:noAuth
                                           success:^(id result) {
                                               if (result != [NSNull null]) {
                                                   NSDictionary *item = (NSDictionary *)result;
                                                   id typedResult = [[outputClass alloc] initWithDictionary:item];
                                                   
                                                   success(typedResult);
                                               }
                                               else success(nil);
                                           }
                                           failure:failure];
}

- (id)standardDictionaryRequestWithPath:(NSString *)path
								 params:(NSDictionary *)params
                                 method:(NSString *)method
                           noAuthNeeded:(BOOL)noAuth
								success:(void (^)(NSDictionary *results))success
								failure:(void (^)(NSError *error))failure {
	
	return [self standardRequestWithPath:path
								  params:params
                                  method:method
                            noAuthNeeded:noAuth
								 success:^(id data) {
                                     success((NSDictionary *)data);
                                 }
								 failure:failure];
}


- (NSError *)errorFromResponseString:(NSString *)responseString errorCode:(int)errorCode {
    NSDictionary *jsonData = [responseString objectFromJSONString];
    
    if (!jsonData || ![jsonData objectForKey:@"errors"]) {
        jsonData = nil;
    }
    
    NSString *errorDomain = [jsonData objectForKey:@"errorStatusCode"] ? [jsonData objectForKey:@"errorStatusCode"] : @"StormAPIErrorDomain";
    
    NSError *error = [NSError errorWithDomain:errorDomain
                                         code:errorCode
                                     userInfo:jsonData];
    
    return error;
}

- (NSArray *)dictionaryArrayToTypedArray:(NSArray *)input outputClass:(Class)outputClass {
	NSUInteger count = [input count];
	NSMutableArray *typedResults = [NSMutableArray arrayWithCapacity:count];
	
	for (int i = 0; i < count; i++) {
		[typedResults addObject:[[outputClass alloc] initWithDictionary:[input objectAtIndex:i]]];
	}
	
	return typedResults;
}

- (NSDictionary *)jsonToDictionary:(id)data {
    if (data == nil || data == NULL) {
        return nil;
    }
	JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
	NSDictionary *jsonData = [jsonKitDecoder objectWithData: data];
	return jsonData;
}

- (NSArray *)readErrors:(id)data {
	JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
	NSDictionary *jsonData = [jsonKitDecoder objectWithData: data];
	NSArray *results = [jsonData objectForKey:@"errors"];
	return results;
}


- (void)applyParameters:(NSDictionary *)parameters onRequest:(NSMutableURLRequest *)aRequest;
{
	if (!parameters) return;
	
	NSString *httpMethod = [aRequest HTTPMethod];
	if ([httpMethod caseInsensitiveCompare:@"POST"] != NSOrderedSame
		&& [httpMethod caseInsensitiveCompare:@"PUT"] != NSOrderedSame) {
		aRequest.URL = [aRequest.URL nxoauth2_URLByAddingParameters:parameters];
	} else {
		NSInputStream *postBodyStream = [[NXOAuth2PostBodyStream alloc] initWithParameters:parameters];
		
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", [(NXOAuth2PostBodyStream *)postBodyStream boundary]];
		NSString *contentLength = [NSString stringWithFormat:@"%lld", [(NXOAuth2PostBodyStream *)postBodyStream length]];
		[aRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
		[aRequest setValue:contentLength forHTTPHeaderField:@"Content-Length"];
		
		[aRequest setHTTPBodyStream:postBodyStream];
	}
}



@end
