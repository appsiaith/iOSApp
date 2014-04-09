//
//  PlaySound.m
//  CwrsCymraeg
//
//  Created by Chris Price on 26/04/2010.
//  Copyright 2010 Aberystwyth University. All rights reserved.
//

#import "PlaySound.h"
#import "SharedData.h"

@implementation PlaySound

@synthesize avPlayer = _avPlayer; 

- (void) playSound: (NSString *) soundfileName { 
	
    // Old version of this routine used to check whether a Northern version exists
    // This is no longer necessary as the Northern version is explicitly in thedatabase
    NSString *baseFilename = [soundfileName stringByReplacingOccurrencesOfString: @".mp3" withString:@""];
    
   // CJP 09/04/12 Check that the file exists so we don't crash...
   if ([[NSFileManager defaultManager] fileExistsAtPath: [NSBundle pathForResource: baseFilename ofType: @"mp3"
                                                                       inDirectory: [[NSBundle mainBundle] bundlePath]]]) {
      NSURL *fileURL = [FileUtility languageURLForMP3Resource: baseFilename];

      self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];	
      
      if (self.avPlayer) {
         [self.avPlayer prepareToPlay];
         [self.avPlayer play];	
      }  
      
   }
      
}

- (float) duration { 
   return [self.avPlayer duration];
}

-(void) play {
	[self.avPlayer play];	
}

- (BOOL) isPlaying { 
   return [self.avPlayer isPlaying];   
}

- (void) pause { 
   [self.avPlayer pause];   
}

@end
