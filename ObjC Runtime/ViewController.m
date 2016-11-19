//
//  ViewController.m
//  ObjC Runtime
//
//  Created by Dasha Korneichuk on 11/19/16.
//  Copyright © 2016 Dasha Korneichuk. All rights reserved.
//

#import "ViewController.h"
#import "ObjC/Runtime.h"
#import "Cat.h"

@interface ViewController () {
    NSMutableString *ivarString;
    NSUInteger *ivarNumber;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    classListMethods([self class]);
    
    Cat *cat = [[Cat alloc]init];
    [cat testSwizzling];
}

void classListMethods(Class c) {
    NSMutableString *classInfo;
    {
        Class superClass;
        classInfo=[NSMutableString stringWithFormat:@"\nHierarchy: %@ ",c];
        superClass=[c superclass];
        while(superClass) {
            [classInfo appendFormat:@"-> %@ ",superClass];
            superClass=[superClass superclass];
        }
    }
    
    while (c) {
        unsigned int numMethods = 0;
        Method * methods = class_copyMethodList(c, &numMethods);
        [classInfo appendFormat:@"\n\nclass %@ has %d methods\n", c,numMethods];
        for(int i=0;i<numMethods;i++) {
            [classInfo appendFormat:@"%0.3d) %s\n",i+1,sel_getName(method_getName(methods[i]))];
        }
        if(methods) free(methods);
        c=[c superclass];
    }
    
    NSLog(@"%@",classInfo);
    return;
}


@end



