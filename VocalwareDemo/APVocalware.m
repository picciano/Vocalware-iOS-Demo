//
//  APVocalware.m
//  VocalwareDemo
//
//  Created by Anthony Picciano on 9/3/15.
//  Copyright (c) 2015 Anthony Picciano. All rights reserved.
//

#import "APVocalware.h"
#import "APMD5.h"
#import "Configuration.h"

@implementation APVocalware

static NSInteger const kDefaultEid              = 3;
static NSInteger const kDefaultLid              = 1;
static NSInteger const kDefaultVid              = 3;

static NSString * const kExtensionMP3           = @"mp3";
static NSString * const kBaseURL                = @"http://www.vocalware.com/tts/gen.php";
static NSString * const kEidParameter           = @"?EID=%li";
static NSString * const kLidParameter           = @"&LID=%li";
static NSString * const kVidParameter           = @"&VID=%li";
static NSString * const kTxtParameter           = @"&TXT=%@";
static NSString * const kExtParameter           = @"&EXT=%@";
static NSString * const kFxTypeParameter        = @"&FX_TYPE=%@";
static NSString * const kFxLevelParameter       = @"&FX_LEVEL=%@";
static NSString * const kAccParameter           = @"&ACC=%@";
static NSString * const kApiParameter           = @"&API=%@";
static NSString * const kSessionParameter       = @"&SESSION=%@";
static NSString * const kHttpErrParameter       = @"&HTTP_ERR=%@";
static NSString * const kCsParameter            = @"&CS=%@";

+ (NSURL *)urlWithText:(NSString *)txt {
    return [[self class] urlWithText:txt engine:kDefaultEid language:kDefaultLid voice:kDefaultVid];
}

+ (NSURL *)urlWithText:(NSString *)txt engine:(NSInteger)eid language:(NSInteger)lid voice:(NSInteger)vid {
    NSString *cs = [[self class] checksumWithEid:eid lid:lid vid:vid txt:txt ext:kExtensionMP3 acc:kVocalWareAccountID api:kVocalWareAPIID];
    
    NSMutableString *urlString = [NSMutableString stringWithString:kBaseURL];
    [urlString appendString:[NSString stringWithFormat:kEidParameter, (long)eid]];
    [urlString appendString:[NSString stringWithFormat:kLidParameter, (long)lid]];
    [urlString appendString:[NSString stringWithFormat:kVidParameter, (long)vid]];
    [urlString appendString:[NSString stringWithFormat:kTxtParameter, [txt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlString appendString:[NSString stringWithFormat:kExtParameter, kExtensionMP3]];
    [urlString appendString:[NSString stringWithFormat:kAccParameter, kVocalWareAccountID]];
    [urlString appendString:[NSString stringWithFormat:kApiParameter, kVocalWareAPIID]];
    [urlString appendString:[NSString stringWithFormat:kCsParameter, cs]];
    
    return [NSURL URLWithString:urlString];
}

+ (NSString *)checksumWithEid:(NSInteger)eid
                          lid:(NSInteger)lid
                          vid:(NSInteger)vid
                          txt:(NSString *)txt
                          ext:(NSString *)ext
                          acc:(NSString *)acc
                          api:(NSString *)api {
    NSString *input = [NSString stringWithFormat:@"%li%li%li%@%@%@%@%@", (long)eid, (long)lid, (long)vid, txt, ext, acc, api, kVocalWareSecretPhrase];
    NSString *cs = input.md5;
    
    return cs;
}

@end