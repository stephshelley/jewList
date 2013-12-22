#import "NSDictionary+QueryString.h"

@implementation NSDictionary (QueryString)

- (NSString *)urlEncode:(id)object {
	NSString *string = [NSString stringWithFormat:@"%@", object];
	
	NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																				  NULL,
																				  (CFStringRef)string,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8 ));
	return encodedString;
}

- (NSString *)urlEncodedString {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in self) {
		id value = [self objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode:key], [self urlEncode:value]];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];
}

@end