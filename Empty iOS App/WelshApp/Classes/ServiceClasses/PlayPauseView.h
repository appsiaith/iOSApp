//
//  PlayPauseView.h
//  CwrsCymraeg
//
//  Created by Neil Taylor on 22/05/2010.
//  Copyright 2010 Aberystwyth University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlayPauseView : UIControl {
   
   float timeInSeconds; 
   float timeRemaining; 
   float increment; 
   
   NSTimer *timer; 
   
   IBOutlet UITextView *text; 
}

@property (nonatomic, retain) NSTimer *timer; 

@property float timeInSeconds; 
@property float timeRemaining; 
@property float increment; 

- (void) playForTime: (float) seconds;
- (void) pause;
- (void) stop; 

@end
