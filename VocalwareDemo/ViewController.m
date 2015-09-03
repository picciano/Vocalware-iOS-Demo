//
//  ViewController.m
//  VocalwareDemo
//
//  Created by Anthony Picciano on 9/3/15.
//  Copyright (c) 2015 Anthony Picciano. All rights reserved.
//

#import "ViewController.h"
#import "APVocalware.h"
#import "APMD5.h"
#import "NSMutableArray+QueueStack.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSMutableArray *queue;
@property (strong, nonatomic) NSMutableDictionary *preloadedAudio;
@property (nonatomic) BOOL speaking;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preloadedAudio = [NSMutableDictionary dictionary];
    
    self.voiceRate = 1.0;
    self.voiceId = 3;
    self.voiceLanguageId = 1;
    self.voiceEngineId = 3;
    
    [self configureAudioSession];
}

- (void)configureAudioSession {
    NSError *setCategoryError = nil;
    BOOL setCategorySuccess = [[AVAudioSession sharedInstance]
                               setCategory:AVAudioSessionCategoryPlayAndRecord
                               withOptions:AVAudioSessionCategoryOptionDuckOthers|AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionAllowBluetooth
                               error:&setCategoryError];
    
    if (setCategorySuccess) {
        NSLog(@"Audio Session options set.");
    } else {
        NSLog(@"WARNING: Could not set audio session options.");
    }
}

#pragma mark - User Interface methods

- (IBAction)speakItAction:(id)sender {
    if (self.textField.text && self.textField.text.length > 0) {
        [self say:self.textField.text];
    }
}

- (IBAction)preloadAudioAction:(id)sender {
    if (self.textField.text && self.textField.text.length > 0) {
        [self preload:self.textField.text];
    }
}

#pragma mark - Private methods

- (void)say:(NSString *)text {
    if (text == nil || text.length == 0) {
        return;
    }
    
    if (_speaking) {
        [self.queue queuePush:text];
        return;
    }
    
    _speaking = YES;
    
    NSData *data = [self.preloadedAudio objectForKey:[text md5]];
    if (data) {
        [self vocalWare:data withText:text];
    } else {
        [self vocalWareTextToSpeech:text];
    }
}

- (void)preload:(NSString *)text {
    [self vocalWare:text completion:^(NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSString *hash = [text md5];
            [self.preloadedAudio setObject:data forKey:hash];
        }
    }];
}

- (void)finishedSpeaking {
    _speaking = NO;
    if (self.queue.count > 0) {
        [self say:[self.queue queuePop]];
    } else {
        [self.player stop];
        [self.player prepareToPlay];
        self.player = nil;
        [self setAudioSessionActive:NO];
    }
}

- (void)setAudioSessionActive:(BOOL)active {
    _speaking = active;
    
    NSError *activationError = nil;
    BOOL activationResult = [[AVAudioSession sharedInstance] setActive:active
                                                                 error:&activationError];
    
    if (activationResult == NO) {
        NSLog(@"WARNING: Could not %@ audio session.", active?@"activate":@"deactivate");
    } else {
        NSLog(@"Audio Session: %@", active?@"ACTIVE":@"INACTIVE");
    }
}

- (NSError *)playAudioData:(NSData *)data rate:(CGFloat)rate {
    [self setAudioSessionActive:YES];
    
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    
    if (error) {
        return error;
    } else {
        self.player.delegate = self;
        if (rate != 1.0) {
            self.player.rate = rate;
            self.player.enableRate = YES;
        }
        [self.player play];
    }
    return nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self finishedSpeaking];
}

#pragma mark - VocalWare Speech

- (void)vocalWareTextToSpeech:(NSString *)text {
    if (text == nil || text.length == 0) {
        return;
    }
    
    [self vocalWare:text completion:^(NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Failed to load audio data from VocalWare: %@", connectionError.localizedDescription);
        } else {
            [self vocalWare:data withText:text];
        }
    }];
}

- (void)vocalWare:(NSData *)data withText:(NSString *)text {
    NSError *error = [self playAudioData:data rate:self.voiceRate];
    if (error) {
        NSLog(@"Failed to play audio from VocalWare: %@.\n\n\nHave you updated the Configuration.h file?", error.localizedDescription);
    }
}

- (void)vocalWare:(NSString *)text completion:(void (^)(NSData *data, NSError *connectionError))completion {
    NSURL *url = [APVocalware urlWithText:text engine:self.voiceEngineId language:self.voiceLanguageId voice:self.voiceId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               completion(data, connectionError);
                           }];
}

@end
