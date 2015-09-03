//
//  APMD5.m
//  VocalwareDemo
//
//  Created by Anthony Picciano on 9/3/15.
//  Copyright (c) 2015 Anthony Picciano. All rights reserved.
//

#import "APMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TGMD5)

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15] ];
}

@end

@implementation NSData (TGMD5)

- (NSString*)md5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (int)self.length, result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15] ];
}

@end
