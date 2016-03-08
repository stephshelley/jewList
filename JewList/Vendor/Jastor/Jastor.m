#import "Jastor.h"
#import "JastorRuntimeHelper.h"
#import "NSString+CamelCase.h"

@implementation Jastor

static NSString *idPropertyName = @"id";
static NSString *idPropertyNameOnObject = @"dbId";

Class nsDictionaryClass;
Class nsArrayClass;

+ (id)objectFromDictionary:(NSDictionary*)dictionary {
    id item = [[self alloc] initWithDictionary:dictionary];
    return item;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        [self fillWithDictionary:dictionary];
    }
    return self;
}

- (id)fillWithDictionary:(NSDictionary *)dictionary {
	if (!nsDictionaryClass) nsDictionaryClass = [NSDictionary class];
	if (!nsArrayClass) nsArrayClass = [NSArray class];
	
    for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
        id value = [dictionary valueForKey:[key stringAsUnderscores]];
        
        if (value == [NSNull null] || value == nil) {
            continue;
        }
        
        if ([JastorRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
            continue;
        }
        
        // handle dictionary
        if ([value isKindOfClass:nsDictionaryClass]) {
            Class klass = [JastorRuntimeHelper propertyClassForPropertyName:key ofClass:[self class]];
            
            @try {
                value = [[klass alloc] initWithDictionary:value];
            }
            @catch (NSException *exception) {
                continue;
            }

        }
        
        if([key isEqualToString:@"metadata"])
        {
            BD_LOG(@"");
        }
        
        // handle array
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

        else if ([value isKindOfClass:nsArrayClass]) {
            Class arrayItemType = [[self class] performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@_class", key])];
            
#pragma clang diagnostic pop

            NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray*)value count]];
            
            for (id child in value) {
                if ([[child class] isSubclassOfClass:nsDictionaryClass]) {
                    Jastor *childDTO = [[arrayItemType alloc] initWithDictionary:child];
                    [childObjects addObject:childDTO];
                } else {
                    [childObjects addObject:child];
                }
            }
            
            value = childObjects;
        }
        // handle all others
        [self setValue:value forKey:key];
    }
    
    id objectIdValue;

    if (![dictionary isEqual:[NSNull null]] && (objectIdValue = [dictionary objectForKey:idPropertyName]) && objectIdValue != [NSNull null]) {
        if (![objectIdValue isKindOfClass:[NSString class]]) {
            objectIdValue = [NSString stringWithFormat:@"%@", objectIdValue];
        }
        [self setValue:objectIdValue forKey:idPropertyNameOnObject];
    }

	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:self.dbId forKey:idPropertyNameOnObject];
	for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
        
        id object = [self valueForKey:key];
        
		[encoder encodeObject:object forKey:key];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
		[self setValue:[decoder decodeObjectForKey:idPropertyNameOnObject] forKey:idPropertyNameOnObject];
		
		for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
            if ([JastorRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
			id value = [decoder decodeObjectForKey:key];
			if (value != [NSNull null] && value != nil) {
				[self setValue:value forKey:key];
			}
		}
	}
	return self;
}

- (NSMutableDictionary *)toDictionary {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.dbId) {
        [dic setObject:self.dbId forKey:idPropertyName];
    }
	
	for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
		id value = [self valueForKey:key];
        if (value && [value isKindOfClass:[Jastor class]]) {            
            [dic setObject:[value toDictionary] forKey:key];
        } else if (value && [value isKindOfClass:[NSArray class]] && ((NSArray*)value).count > 0) {
            id internalValue = [value objectAtIndex:0];
            if (internalValue && [internalValue isKindOfClass:[Jastor class]]) {
                NSMutableArray *internalItems = [NSMutableArray array];
                for (id item in value) {
                    [internalItems addObject:[item toDictionary]];
                }
                [dic setObject:internalItems forKey:key];
            } else {
                [dic setObject:value forKey:key];
            }
        } else if (value != nil) {
            [dic setObject:value forKey:key];
        }
	}
    return dic;
}

- (NSString *)description {
    NSMutableDictionary *dic = [self toDictionary];
	
	return [NSString stringWithFormat:@"#<%@: id = %@ %@>", [self class], self.dbId, [dic description]];
}

- (BOOL)isEqual:(id)object {
	if (object == nil || ![object isKindOfClass:[Jastor class]]) return NO;
	
	Jastor *model = (Jastor *)object;
	
	return [self.dbId isEqualToString:model.dbId];
}

@end
