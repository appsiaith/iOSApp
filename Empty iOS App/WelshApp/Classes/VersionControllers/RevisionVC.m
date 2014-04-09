//
//  RevisionVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 17/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "RevisionVC.h"
#import "SharedData.h"

@interface RevisionVC () {
    NSArray *chosenPhrases; // Randomised version of the availablePhrases
    NSArray *availablePhrases; // All phrases (or vocab) up to this lesson
    int currentQuestion;
    int askedCount;
	int correctCount;
    NSString *revisionType; // can be Words or Phrases
}

@property (nonatomic, retain) IBOutlet UILabel *questionNumber;
@property (nonatomic, retain) IBOutlet UILabel *questionText;
@property (nonatomic, retain) IBOutlet UILabel *answerText;
@property (nonatomic, retain) IBOutlet UILabel *resultPromptText;

@property (nonatomic, retain) IBOutlet UILabel *wereYouCorrectLabel;

@property (nonatomic, retain) IBOutlet UIButton *correctButton;
@property (nonatomic, retain) IBOutlet UIButton *wrongButton;
@property (nonatomic, retain) IBOutlet UIButton *answerFinishButton;

- (IBAction)doWrong:(id)sender;
- (IBAction)doRight:(id)sender;
- (IBAction)doAnswer:(id)sender;
- (IBAction)togglePhrases:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleButton;

@end

@implementation RevisionVC



- (void) makeButtonsVisible: (BOOL) showButtons {
    
    CGFloat alphaValue = 0.0;
    if(showButtons) {
        alphaValue = 1.0;
    }
    
    self.answerText.alpha = alphaValue;
    self.correctButton.alpha = alphaValue;
    self.wrongButton.alpha = alphaValue;
    self.wereYouCorrectLabel.alpha = alphaValue;
}


- (void) showAnswerText: (BOOL) showAnswerText  {
    
    [UIView beginAnimations: @"Fade2" context: nil];
    
    if(showAnswerText)
    {
        [UIView setAnimationDuration: 1];
        [self makeButtonsVisible: YES];
        self.answerFinishButton.hidden = YES;
        
    }
    else {
        [UIView setAnimationDuration: 0.5];
        [self makeButtonsVisible: NO];
    }
    
    [UIView commitAnimations];
}


-(NSArray *) randomised: (NSArray *) startArray{
    NSMutableArray *origArray = [[NSMutableArray alloc] init];
    [origArray addObjectsFromArray: startArray];
    
    NSMutableArray *randomisedArray = [[NSMutableArray alloc] init];
    // Seed the random number
	srandom((int)time(NULL));
    while ([origArray count] > 0) {
        int myIndex = (random() % (int)[origArray count]);
//        NSLog(@"Length is %i, index is %d, item is %@", (int)[origArray count], myIndex, origArray[myIndex]);
        [randomisedArray addObject: origArray[myIndex]];
        [origArray removeObjectAtIndex: myIndex];
    }
    return randomisedArray;
}

-(void) setUpQuestion{
 	if ([chosenPhrases count] == 0) {
        if ([revisionType isEqualToString: @"Phrases"]){
           self.questionText.text = @"SORRY - YOU HAVEN'T LEARNED ANY PHRASES YET";
        } else {
            self.questionText.text = @"SORRY - YOU HAVEN'T LEARNED ANY VOCABULARY YET";
        }
        self.questionNumber.text = @"";
        self.answerFinishButton.hidden = YES;

        return;
    }
    if (currentQuestion == [chosenPhrases count]) {
        currentQuestion = 0;
        chosenPhrases = [self randomised: availablePhrases];

//        self.questionText.hidden = YES;
//        self.questionNumber.hidden = YES;
//        [self showAnswerText: NO ];
    }
//    else
//    {
		VocabItem *vocabItem = (VocabItem *) [chosenPhrases objectAtIndex: currentQuestion];
        
        NSString *prefix = @"";
        if ([vocabItem isVerb] ) {
            prefix = @"to ";
        }
        
        self.questionNumber.text = @"What is the Welsh for...?";
        self.questionText.text = [NSString stringWithFormat: @"%@%@", prefix, vocabItem.englishText];
        self.answerText.text = vocabItem.welshText;
        self.answerText.alpha = 0;
        self.correctButton.alpha = 0;
        self.wrongButton.alpha = 0;
        self.wereYouCorrectLabel.alpha = 0;
        [self showAnswerText: NO ];
        self.answerFinishButton.hidden = NO;

//	}
}

- (void) goToNextQuestion {
    currentQuestion++;
    askedCount++;
    [self setUpQuestion];
}


- (IBAction)doWrong: (id)sender {
    
    [self goToNextQuestion];
    self.title = [NSString stringWithFormat: @"Got %d out of %d right", correctCount, askedCount];
}

- (IBAction)doRight:(id)sender {
	[self goToNextQuestion];
	correctCount++;
    self.title = [NSString stringWithFormat: @"Got %d out of %d right", correctCount, askedCount];
}

- (IBAction)doAnswer:(id)sender {
    [self showAnswerText: YES];
}

- (IBAction)togglePhrases:(id)sender {
    if ([revisionType isEqualToString: @"Phrases"]){
        // Toggle to words and make phrases available
        availablePhrases = [[SharedData sharedInstance] getAllVocabItemsFromLesson: 1 ToLesson: (int)[[SharedData sharedInstance] currentUnitNumber]];
        self.toggleButton.title = @"Phrases";
        revisionType = @"Words";
    } else {
        availablePhrases = [[SharedData sharedInstance] getAllPatternBodiesFromLesson: 1 ToLesson: (int)[[SharedData sharedInstance] currentUnitNumber]];
        self.toggleButton.title = @"Words";
        revisionType = @"Phrases";
    }
    chosenPhrases = [self randomised: availablePhrases];
    self.title = @"Start practising...";
    currentQuestion = 0;
    askedCount = 0;
	correctCount = 0;
	[self setUpQuestion];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Load with all phrases up to our present chapter
    availablePhrases = [[SharedData sharedInstance] getAllPatternBodiesFromLesson: 1 ToLesson: (int)[[SharedData sharedInstance] currentUnitNumber]];
    chosenPhrases = [self randomised: availablePhrases];
    
    revisionType = @"Phrases";
    
    self.title = @"Start practising...";
	currentQuestion = 0;
    askedCount = 0;
	correctCount = 0;
	[self setUpQuestion];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
