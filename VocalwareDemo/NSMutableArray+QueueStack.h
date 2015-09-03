//
//  NSMutableArray+QueueStack.h
//  TallyGo
//
//  Created by Anthony Picciano on 5/4/15.
//  Copyright (c) 2015 TallyGo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueStack)

- (id)queuePop;
- (void)queuePush:(id)obj;
- (id)stackPop;
- (void)stackPush:(id)obj;

@end
