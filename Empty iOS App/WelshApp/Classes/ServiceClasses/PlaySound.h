//
//  PlaySound.h
//  CwrsCymraeg
//
//  Created by Chris Price on 26/04/2010.
//  Copyright 2010 Aberystwyth University. All rights reserved.
//
// Given an mp3 soundfile name without ".mp3" on the end, this plays the sound

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FileUtility.h"

@interface PlaySound : NSObject 

@property (nonatomic, retain) AVAudioPlayer *avPlayer; 

- (float) duration;
- (void) playSound: (NSString *) soundfileName;
- (BOOL) isPlaying; 
- (void) pause; 


@end
