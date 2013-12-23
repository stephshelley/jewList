/*
 *  File    : RuntimeHelper.h
 *  Project Schmooz
 *
 *  Description : This class will help fetch our basic object properites names
 *
 *  DRI     : Oren Zitoun
 *  Created : 12/23/12.
 *  Copyright 2010-2012 BBYO. All rights reserved.
 *
 */

@interface RuntimeHelper : NSObject {
	
}

/* Return the class for a property name in a certain base class */
+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)klass;

/* Returns and array with the property names of a class */
+ (NSArray *)propertyNames:(Class)klass;

@end
