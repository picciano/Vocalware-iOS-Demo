//
//  ViewController.h
//  VocalwareDemo
//
//  Created by Anthony Picciano on 9/3/15.
//  Copyright (c) 2015 Anthony Picciano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic) CGFloat voiceRate;
@property (nonatomic) NSInteger voiceId;
@property (nonatomic) NSInteger voiceEngineId;
@property (nonatomic) NSInteger voiceLanguageId;

@end

