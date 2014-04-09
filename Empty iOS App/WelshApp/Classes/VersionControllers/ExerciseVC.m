//
//  ExerciseVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 04/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "ExerciseVC.h"
#import "ExerciseItem.h"
#import "SharedData.h"
#import "PlaySound.h"

#import <AVFoundation/AVFoundation.h>

@interface ExerciseVC () {
    NSArray *chosenExercises; // A set of exercise items to go through
    PlaySound *myPlaySound;
    int indexInExercise;
}

@property (nonatomic, retain) IBOutlet UILabel *instructionText;
@property (nonatomic, retain) IBOutlet UILabel *questionText1;
@property (weak, nonatomic) IBOutlet UILabel *questionText2;

@property (nonatomic, retain) IBOutlet UILabel *answerText;
@property (nonatomic, retain) IBOutlet UIButton *answerButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;


- (IBAction)doNext: (id)sender;
- (IBAction)doPrev: (id)sender;

- (IBAction)giveAnswer:(id)sender;

- (IBAction)repeat: (id)sender;
@end

@implementation ExerciseVC

- (void) playSound: (NSString *)soundFileName {
    if ([soundFileName length] != 0) {
		[myPlaySound playSound: soundFileName];
    }
}

- (IBAction) repeat: (id) sender {
    ExerciseItem *myExercise = chosenExercises[indexInExercise];
    if ( [myExercise.qAudio length] != 0 ) {
        [self playSound: myExercise.qAudio];
	}
}

- (UIImage *) returnImageForJPG: (NSString *) filename{
    if ([filename length] == 0) {return nil;}
    // Turn name into a full filepath including .jpg
    NSString *baseFilename = [filename stringByReplacingOccurrencesOfString: @".jpg" withString:@""];
    NSString *filepath = [[NSBundle mainBundle] pathForResource: baseFilename ofType:@"jpg"];
    
    // Create a UIImage Object to store the image.
    UIImage *image = [[UIImage alloc ] initWithContentsOfFile: filepath];
    
    return image;
}

-(void) setUpExercise: (int) index {
	ExerciseItem *myExercise = chosenExercises[index];
    if ([myExercise.picFile length] != 0){
        self.questionImageView.image = [self returnImageForJPG: myExercise.picFile];
        self.questionText1.text = myExercise.qText;
        self.questionText2.text = @"";
    } else {
        self.questionText1.text = @"";
        self.questionText2.text = myExercise.qText;
    }
    
	// Add the instructions to the exercise near top of screen
	self.instructionText.text = myExercise.header;
 	self.answerText.text = myExercise.ansText;
    [self.answerText setHidden: YES];
	if ( [myExercise.qAudio length] != 0 ) {
        [self playSound: myExercise.qAudio];
        [self.repeatButton setEnabled: YES];
	}
    else {
        [self.repeatButton setEnabled: NO];
    }
    
    if (( [myExercise.ansAudio length] == 0) && ([myExercise.ansText isEqualToString:@""])) {
        [self.answerButton setEnabled: NO];
    }
    else {
        [self.answerButton setEnabled: YES];
    }
}

/**
 * Determine if the previous and next buttons should be enabled.
 */
- (void) setPrevNextButtonDisplay {
    
    // set the previous button
    if( indexInExercise == 0 ) {
        [self.prevButton setEnabled: NO];
    }
    else {
        [self.prevButton setEnabled: YES];
    }
    
    // set the next button
    if (indexInExercise == ([chosenExercises count] - 1)) {
        [self.nextButton setEnabled: NO];
    }
    else {
        [self.nextButton setEnabled: YES];
    }
}

- (void)viewDidLoad
{
 	// Get all of the records for this pattern	
	chosenExercises = [[SharedData sharedInstance] getExerciseBodiesForExercise: self.exerciseNum];
    	
	// Create the sound player
	myPlaySound = [[PlaySound alloc] init];
	
	//Decide what kind of question it is
	// If first one has no ansText and noAnsAudio, then don't offer an answer
	/*ExerciseItem *myExercise = [chosenPhrases objectAtIndex: 0];
     if (([myExercise.ansText length] == 0) && ([myExercise.ansAudio length] == 0)) {
     answerButton.hidden = YES;
     }
     else {
     answerButton.hidden = NO;
     }*/
	
	// Ask first question
	indexInExercise = 0;
	[self setUpExercise: indexInExercise];
    [self setPrevNextButtonDisplay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doNext: (id)sender {
	
    if ([self.nextButton isEnabled]) {
        indexInExercise++;
        [self setUpExercise: indexInExercise];
        [self setPrevNextButtonDisplay];
    }
}

- (IBAction)doPrev: (id)sender {
	
    if ([self.prevButton isEnabled]) {
        indexInExercise--;
        [self setUpExercise: indexInExercise];
        [self setPrevNextButtonDisplay];
    }
}

/**
 * Show the answer for the current item.
 */
- (IBAction) giveAnswer:(id)sender{
    
    ExerciseItem *myExercise = [chosenExercises objectAtIndex: indexInExercise];
    
    self.answerText.text = myExercise.ansText;
    [self.answerText setHidden: NO];
    if ([myExercise.ansAudio length] != 0 ) {
        [self playSound: myExercise.ansAudio];
    }
	
}


@end
