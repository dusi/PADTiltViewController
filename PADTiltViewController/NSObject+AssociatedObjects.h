//
//  NSObject+AssociatedObjects.h
//  PADTiltViewController
//
//  Created by Pavel Dusatko on 5/4/14.
//  Copyright (c) 2014 Pavel Dusatko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObjects)

/**
 *  @abstract The associated value setter.
 *  @param value The associated object.
 *  @param key   The associated key.
 */
- (void)associateValue:(id)value withKey:(void *)key;

/**
 *  @abstract The associated value getter.
 *  @param key The associated key.
 *  @return The associated object.
 */
- (id)associatedValueForKey:(void *)key;

@end
