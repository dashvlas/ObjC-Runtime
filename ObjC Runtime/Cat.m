//
//  Cat.m
//  ObjC Runtime
//
//  Created by Dasha Korneichuk on 11/19/16.
//  Copyright © 2016 Dasha Korneichuk. All rights reserved.
//

#import "Cat.h"
#import "ObjC/Runtime.h"

@interface Cat()

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSUInteger* age;

- (void)privateMethod;

@end

@implementation Cat

- (void)purr {
    NSLog(@"purr");
}

- (void)irritateNeighbors {
    NSLog(@"irritate");
}

- (void)privateMethod {
    
}

- (void)testSwizzling {
    
    [self purr];
    
    SEL selMethod1=@selector(purr);
    SEL selMethod2=@selector(irritateNeighbors);
    methodSwizzle([self class], selMethod1, selMethod2);
    
    [self purr];
    
}

//NSString* myDescriptionIMP(id self, SEL _cmd)
//{
//    unsigned int ivarCount=0;
//    Ivar * ivars=class_copyIvarList([self class], &ivarCount);
//    
//    Ivar currentIvar;
//    NSMutableString *ivarValues=[NSMutableString stringWithFormat:@"%@\n",self];
//    
//    if(ivarCount)
//    {
//        [ivarValues appendString:@"Instance Variables:"];
//        for (int i=0; i < ivarCount; i++) {
//            currentIvar=ivars[i];
//            const char *ivarType=ivar_getTypeEncoding(currentIvar);
//            id ivarValue=@"type not supported";
//            switch (*ivarType) {
//                case '@':
//                    ivarValue=object_getIvar(self,currentIvar );
//                    ivarValue=[NSString stringWithFormat:@"%@,%@",ivarValue,[ivarValue class]];
//                    break;
//                case 'i':
//                {
//                    int value=*((int*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithInt:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,int",ivarValue];
//                }
//                    break;
//                case 's':
//                {
//                    short value=*((short*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithShort:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,short",ivarValue];
//                }
//                    break;
//                case 'l':
//                {
//                    long value=*((long*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithLong:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,long",ivarValue];
//                }
//                    break;
//                case 'q':
//                {
//                    long long value=*((long long*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithLong:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,long long",ivarValue];
//                }
//                    break;
//                case 'I':
//                {
//                    unsigned int value=*((unsigned int*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithUnsignedInt:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,unsigned int",ivarValue];
//                }
//                    break;
//                case 'S':
//                {
//                    unsigned short value=*((unsigned short*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithUnsignedShort:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,unsigned short",ivarValue];
//                }
//                    break;
//                case 'L':
//                {
//                    unsigned long value=*((unsigned long*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithUnsignedLong:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,unsigned long",ivarValue];
//                }
//                    break;
//                case 'Q':
//                {
//                    unsigned long long value=*((unsigned long long*)((__bridge void*)self + ivar_getOffset(currentIvar)));
//                    ivarValue=[NSNumber numberWithUnsignedLongLong:value];
//                    ivarValue=[NSString stringWithFormat:@"%@,unsigned long long",ivarValue];
//                }
//                    break;
//                default:
//                    break;
//            }
//            [ivarValues appendFormat:@"\n%s= %@",ivar_getName(currentIvar),ivarValue];
//        }
//    }
//    if(ivars)
//        free(ivars);
//    return [NSString stringWithString:ivarValues];
//    
//}
//
//void classAddDesciption(Class class)
//{
//    BOOL status=class_addMethod(class, @selector(description),(IMP)myDescriptionIMP , "@@:");
//    if(status == NO)
//    {
//        NSLog(@"classAddDesciption: cannot add method to class %@",class);
//    }
//}

void methodSwizzle(Class c, SEL swizzledSelector, SEL swizzlingSelector){
    BOOL isClassMethod=NO;
    Method swizzledMETHOD=class_getInstanceMethod(c, swizzledSelector);
    if(swizzledMETHOD == NULL)
    {
        //Try class method
        swizzledMETHOD=class_getClassMethod(c, swizzledSelector);
        if(swizzledMETHOD == NULL)
        {
            NSLog(@"Neither class or instance method swizzledSelector=%s exists for %@",(char*)swizzledSelector,c);
            return;
        }
        isClassMethod=YES;
    }
    Method swizzlingMETHOD;
    if(isClassMethod)
    {
        swizzlingMETHOD=class_getClassMethod(c, swizzlingSelector);
        if(swizzlingMETHOD == NULL)
        {
            NSLog(@"class method swizzlingSelector= %s does not exist in class %@",(char*)swizzlingSelector,c);
            return;
        }
    }
    else {
        swizzlingMETHOD=class_getInstanceMethod(c, swizzlingSelector);
        if(swizzlingMETHOD == NULL)
        {
            NSLog(@"instance method swizzlingSelector= %s does not exist in class %@",(char*)swizzlingSelector,c);
            return;
        }
    }
    
    method_exchangeImplementations(swizzledMETHOD, swizzlingMETHOD);
}

@end
