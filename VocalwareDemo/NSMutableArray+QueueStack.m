//
//  NSMutableArray+QueueStack.m
//  TallyGo
//
//  Created by Anthony Picciano on 5/4/15.
//  Copyright (c) 2015 TallyGo. All rights reserved.
//

#import "NSMutableArray+QueueStack.h"

@implementation NSMutableArray (QueueStack)

- (id)queuePop {
    if ([self count] == 0) {
        return nil;
    }
    
    id queueObject = [self objectAtIndex:0];
    
    [self removeObjectAtIndex:0];

    return queueObject;
}

- (void)queuePush:(id)anObject {
    [self addObject:anObject];
}

- (id)stackPop {
    id lastObject = [self lastObject];
    
    if (lastObject)
        [self removeLastObject];
    
    return lastObject;
}

- (void)stackPush:(id)obj {
    [self addObject: obj];
}

@end
