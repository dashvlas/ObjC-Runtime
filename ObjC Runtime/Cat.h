//
//  Cat.h
//  ObjC Runtime
//
//  Created by Dasha Korneichuk on 11/19/16.
//  Copyright © 2016 Dasha Korneichuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cat : NSObject

- (void)purr;
- (void)irritateNeighbors;
- (void)testReflection;
- (void)testSwizzling;

void methodSwizzle(Class c, SEL swizzledSelector, SEL swizzlingSelector);

@end
