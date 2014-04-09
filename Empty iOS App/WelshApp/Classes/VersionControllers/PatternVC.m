//
//  PatternVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 01/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "PatternVC.h"
#import "PatternItem.h"
#import "PlaySound.h"


@interface PatternVC () {
   int indexInPattern;
   PlaySound *myPlaySound;
}

@property (weak, nonatomic) IBOutlet UILabel *englishLabel;

@property (weak, nonatomic) IBOutlet UILabel *welshLabel;

- (IBAction)doNext:(id)sender;
- (IBAction)doLast:(id)sender;
- (IBAction)doRepeat:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

@end

@implementation PatternVC


-(void) setUpPattern: (int) index{
	PatternItem *myPattern = [self.chosenPhrases objectAtIndex: index];
	self.englishLabel.text = myPattern.english;
    self.welshLabel.text = myPattern.welsh;
	NSString *soundString = myPattern.audio;
    if ([soundString length] != 0) {
       [myPlaySound playSound: soundString];
        self.repeatButton.enabled = YES;
    } else {
        self.repeatButton.enabled = NO;
        self.repeatButton.imageView.image = [UIImage imageNamed:@"notplay.png"];
    }
    
}

/**
 * Determine if the previous and next buttons should be enabled.
 */
- (void) setPrevNextButtonDisplay {
    
    // set the previous button
    if( indexInPattern == 0 )
    {
        [self.prevButton setEnabled: NO];
    }
    else {
        [self.prevButton setEnabled: YES];
    }
    
    // set the next button
    if (indexInPattern == ([self.chosenPhrases count] - 1)) {
        [self.nextButton setEnabled: NO];
    }
    else {
        [self.nextButton setEnabled: YES];
    }
    
}

/**
 * This routine does the moving to the next phrase in
 * the lesson and playing it.
 */
- (void) shiftToNextPhrase {
    
	indexInPattern++;
/*    if([soundPlayer isPlaying] ) {
        [playPauseView stop];
        [soundPlayer pause];
    }  */
	[self setPrevNextButtonDisplay];
    [self setUpPattern: indexInPattern];
}

/**
 * This routine links the NEXT button to the moving to
 * the next phrase in the lesson and playing it.
 */
- (IBAction)doNext:(id)sender {
    
	if ([self.nextButton isEnabled]) {
        [self shiftToNextPhrase];
    }
}


/**
 * This routine does the moving to the previous phrase
 * in the lesson and playing it.
 */
- (void) shiftToLastPhrase {
	indexInPattern--;
/*	if([soundPlayer isPlaying] ) {
        [playPauseView stop];
        [soundPlayer pause];
    } */
	[self setPrevNextButtonDisplay];
    [self setUpPattern: indexInPattern];
}

- (IBAction)doLast:(id)sender{
	if ([self.prevButton isEnabled]) {
        [self shiftToLastPhrase];
    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create the sound player
	myPlaySound = [[PlaySound alloc] init];

    indexInPattern = 0;
    [self setUpPattern: indexInPattern];
    [self setPrevNextButtonDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doRepeat:(id)sender {
    PatternItem *myPattern = [self.chosenPhrases objectAtIndex: indexInPattern];
	NSString *soundString = myPattern.audio;
    [myPlaySound playSound: soundString];
}

@end
