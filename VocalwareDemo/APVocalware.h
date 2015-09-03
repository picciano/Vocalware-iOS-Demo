//
//  APVocalware.h
//  VocalwareDemo
//
//  Created by Anthony Picciano on 9/3/15.
//  Copyright (c) 2015 Anthony Picciano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APVocalware : NSObject

+ (NSURL *)urlWithText:(NSString *)txt;
+ (NSURL *)urlWithText:(NSString *)txt engine:(NSInteger)eid language:(NSInteger)lid voice:(NSInteger)vid;

@end
