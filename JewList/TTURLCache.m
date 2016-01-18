//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTURLCache.h"
#import "NSString+NimbusCore.h"

#define TT_DEFAULT_CACHE_INVALIDATION_AGE (60*60*24)    // 1 day
#define TT_DEFAULT_CACHE_EXPIRATION_AGE   (60*60*24*7)  // 1 week
#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)   // inf

static        NSString* kDefaultCacheName       = @"Three20";
static        NSString* kEtagCacheDirectoryName = @"etag";

static TTURLCache*          gSharedCache = nil;
static NSMutableDictionary* gNamedCaches = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface TTURLCache()

/**
 * Creates paths as necessary and returns the cache path for the given name.
 */
+ (NSString*)cachePathWithName:(NSString*)name;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTURLCache

@synthesize disableDiskCache  = _disableDiskCache;
@synthesize cachePath         = _cachePath;
@synthesize invalidationAge   = _invalidationAge;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithName:(NSString*)name {
	self = [super init];
  if (self) {
    _name             = [name copy];
    _cachePath        = [TTURLCache cachePathWithName:name];
    _invalidationAge  = TT_CACHE_EXPIRATION_AGE_NEVER;

    // XXXjoe Disabling the built-in cache may save memory but it also makes UIWebView slow
    // NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0
    // diskPath:nil];
    // [NSURLCache setSharedURLCache:sharedCache];
    // [sharedCache release];

    [[NSNotificationCenter defaultCenter]
     addObserver: self
        selector: @selector(didReceiveMemoryWarning:)
            name: UIApplicationDidReceiveMemoryWarningNotification
          object: nil];
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [self initWithName:kDefaultCacheName];
  if (self) {
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
   removeObserver: self
             name: UIApplicationDidReceiveMemoryWarningNotification
           object: nil];

    _name = nil;
    _cachePath = nil;

}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTURLCache*)cacheWithName:(NSString*)name {
  if (nil == gNamedCaches) {
    gNamedCaches = [[NSMutableDictionary alloc] init];
  }
  TTURLCache* cache = [gNamedCaches objectForKey:name];
  if (nil == cache) {
    cache = [[TTURLCache alloc] initWithName:name];
    [gNamedCaches setObject:cache forKey:name];
  }
  return cache;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTURLCache*)sharedCache {
  if (nil == gSharedCache) {
    gSharedCache = [[TTURLCache alloc] init];
  }
  return gSharedCache;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)setSharedCache:(TTURLCache*)cache {
  if (gSharedCache != cache) {
      gSharedCache = nil;
    gSharedCache = cache;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)createPathIfNecessary:(NSString*)path {
  BOOL succeeded = YES;

  NSFileManager* fm = [NSFileManager defaultManager];
  if (![fm fileExistsAtPath:path]) {
    succeeded = [fm createDirectoryAtPath: path
              withIntermediateDirectories: YES
                               attributes: nil
                                    error: nil];
  }

  return succeeded;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)cachePathWithName:(NSString*)name {
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString* cachesPath = [paths objectAtIndex:0];
  NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];

  [self createPathIfNecessary:cachesPath];
  [self createPathIfNecessary:cachePath];

  return cachePath;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)createTemporaryURL {
  static int temporaryURLIncrement = 0;
  return [NSString stringWithFormat:@"temp:%d", temporaryURLIncrement++];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)createUniqueTemporaryURL {
  NSFileManager* fm = [NSFileManager defaultManager];
  NSString* tempURL = nil;
  NSString* newPath = nil;
  do {
    tempURL = [self createTemporaryURL];
    newPath = [self cachePathForURL:tempURL];
  } while ([fm fileExistsAtPath:newPath]);
  return tempURL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSNotifications


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning:(void*)object {
  // Empty the memory cache when memory is low
  [self removeAll:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)etagCachePath {
  return [self.cachePath stringByAppendingPathComponent:kEtagCacheDirectoryName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)keyForURL:(NSString*)URL {
  return [URL md5Hash];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)cachePathForURL:(NSString*)URL {
  NSString* key = [self keyForURL:URL];
  return [self cachePathForKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)cachePathForKey:(NSString*)key {
  return [_cachePath stringByAppendingPathComponent:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasDataForURL:(NSString*)URL {
  NSString* filePath = [self cachePathForURL:URL];
  NSFileManager* fm = [NSFileManager defaultManager];
  return [fm fileExistsAtPath:filePath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)dataForURL:(NSString*)URL {
  return [self dataForURL:URL expires:TT_CACHE_EXPIRATION_AGE_NEVER timestamp:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)dataForURL:(NSString*)URL expires:(NSTimeInterval)expirationAge
    timestamp:(NSDate**)timestamp {
  NSString* key = [self keyForURL:URL];
  return [self dataForKey:key expires:expirationAge timestamp:timestamp];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasDataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge {
  NSString* filePath = [self cachePathForKey:key];
  NSFileManager* fm = [NSFileManager defaultManager];
  if ([fm fileExistsAtPath:filePath]) {
    NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
    NSDate* modified = [attrs objectForKey:NSFileModificationDate];
    if ([modified timeIntervalSinceNow] < -expirationAge) {
      return NO;
    }

    return YES;
  }

  return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)dataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge
    timestamp:(NSDate**)timestamp {
  NSString* filePath = [self cachePathForKey:key];
  NSFileManager* fm = [NSFileManager defaultManager];
  if ([fm fileExistsAtPath:filePath]) {
    NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
    NSDate* modified = [attrs objectForKey:NSFileModificationDate];
    if ([modified timeIntervalSinceNow] < -expirationAge) {
      return nil;
    }
    if (timestamp) {
      *timestamp = modified;
    }

    return [NSData dataWithContentsOfFile:filePath];
  }

  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * This method needs to handle urlPaths with and without extensions.
 * So @"path.png" will resolve to @"path@2x.png" and
 *    @"path" will resolve to @"path@2x"
 *
 * Paths beginning with @"." will not be changed.
 */
+ (NSString*)doubleImageURLPath:(NSString*)urlPath {
  if ([[urlPath substringToIndex:1] isEqualToString:@"."]) {
    return urlPath;
  }

  // We'd ideally use stringByAppendingPathExtension: in this method, but it seems
  // to wreck bundle:// urls by replacing them with bundle:/ prefixes. Strange.
  NSString* pathExtension = [urlPath pathExtension];

  NSString* urlPathWithNoExtension = [urlPath substringToIndex:
                                      [urlPath length] - [pathExtension length]
                                      - (([pathExtension length] > 0) ? 1 : 0)];

  urlPath = [urlPathWithNoExtension stringByAppendingString:@"@2x"];

  if ([pathExtension length] > 0) {
    urlPath = [urlPath stringByAppendingFormat:@".%@", pathExtension];
  }

  return urlPath;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeData:(NSData*)data forURL:(NSString*)URL {
  NSString* key = [self keyForURL:URL];
  [self storeData:data forKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeData:(NSData*)data forKey:(NSString*)key {
  if (!_disableDiskCache) {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filePath contents:data attributes:nil];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)storeTemporaryData:(NSData*)data {
  NSString* URL = [self createUniqueTemporaryURL];
  [self storeData:data forURL:URL];
  return URL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)storeTemporaryFile:(NSURL*)fileURL {
  if ([fileURL isFileURL]) {
    NSString* filePath = [fileURL path];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
      NSString* tempURL = nil;
      NSString* newPath = nil;
      do {
        tempURL = [self createTemporaryURL];
        newPath = [self cachePathForURL:tempURL];
      } while ([fm fileExistsAtPath:newPath]);

      if ([fm moveItemAtPath:filePath toPath:newPath error:nil]) {
        return tempURL;
      }
    }
  }
  return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)moveDataForURL:(NSString*)oldURL toURL:(NSString*)newURL {

    
  NSString* oldKey = [self keyForURL:oldURL];
  NSString* oldPath = [self cachePathForKey:oldKey];
  NSFileManager* fm = [NSFileManager defaultManager];
  if ([fm fileExistsAtPath:oldPath]) {
    NSString* newKey = [self keyForURL:newURL];
    NSString* newPath = [self cachePathForKey:newKey];
    [fm moveItemAtPath:oldPath toPath:newPath error:nil];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)moveDataFromPath:(NSString*)path toURL:(NSString*)newURL {
  NSString* newKey = [self keyForURL:newURL];
  NSFileManager* fm = [NSFileManager defaultManager];
  if ([fm fileExistsAtPath:path]) {
    NSString* newPath = [self cachePathForKey:newKey];
    [fm moveItemAtPath:path toPath:newPath error:nil];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)moveDataFromPathToTemporaryURL:(NSString*)path {
  NSString* tempURL = [self createUniqueTemporaryURL];
  [self moveDataFromPath:path toURL:tempURL];
  return tempURL;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeURL:(NSString*)URL fromDisk:(BOOL)fromDisk {

  if (fromDisk) {
    NSString* key = [self keyForURL:URL];
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (filePath && [fm fileExistsAtPath:filePath]) {
      [fm removeItemAtPath:filePath error:nil];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeKey:(NSString*)key {
  NSString* filePath = [self cachePathForKey:key];
  NSFileManager* fm = [NSFileManager defaultManager];
  if (filePath && [fm fileExistsAtPath:filePath]) {
    [fm removeItemAtPath:filePath error:nil];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAll:(BOOL)fromDisk {
  _totalPixelCount = 0;

  if (fromDisk) {
    NSFileManager* fm = [NSFileManager defaultManager];
    if([fm removeItemAtPath:_cachePath error:nil])
    {
        BD_LOG(@"TTURLCache Cleared");
    }else{
        BD_LOG(@"TTURLCache Cleared FAILED");
        
    }
    
    [TTURLCache createPathIfNecessary:_cachePath];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateURL:(NSString*)URL {
  NSString* key = [self keyForURL:URL];
  return [self invalidateKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateKey:(NSString*)key {
  NSString* filePath = [self cachePathForKey:key];
  NSFileManager* fm = [NSFileManager defaultManager];
  if (filePath && [fm fileExistsAtPath:filePath]) {
    NSDate* invalidDate = [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
    NSDictionary* attrs = [NSDictionary dictionaryWithObject:invalidDate
      forKey:NSFileModificationDate];

#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    [fm setAttributes:attrs ofItemAtPath:filePath error:nil];
#else
    [fm changeFileAttributes:attrs atPath:filePath];
#endif
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidateAll {
  NSDate* invalidDate = [NSDate dateWithTimeIntervalSinceNow:-_invalidationAge];
  NSDictionary* attrs = [NSDictionary dictionaryWithObject:invalidDate
    forKey:NSFileModificationDate];

  NSFileManager* fm = [NSFileManager defaultManager];
  NSDirectoryEnumerator* e = [fm enumeratorAtPath:_cachePath];
  for (NSString* fileName; fileName = [e nextObject]; ) {
    NSString* filePath = [_cachePath stringByAppendingPathComponent:fileName];
#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    [fm setAttributes:attrs ofItemAtPath:filePath error:nil];
#else
    [fm changeFileAttributes:attrs atPath:filePath];
#endif
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)logMemoryUsage {

}


@end
