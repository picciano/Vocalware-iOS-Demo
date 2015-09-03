//
//  APMD5.h
//  VocalwareDemo
//
//  Created by Anthony Picciano on 9/3/15.
//  Copyright (c) 2015 Anthony Picciano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TGMD5)
- (NSString *)md5;
@end

@interface NSData (TGMD5)
- (NSString*)md5;
@end
