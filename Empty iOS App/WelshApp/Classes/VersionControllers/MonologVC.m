//
//  MonologVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 03/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "MonologVC.h"
#import "PlaySound.h"

@interface MonologVC () {
    PlaySound *myPlaySound;
}

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
- (IBAction)doPlay:(id)sender;

@end

@implementation MonologVC

// load the relevant text
- (void) loadPage: (NSString *) theContent{
    
    NSString *header = @"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"grammar.css\" title=\"fonts\" /></head><body><div class=\"content\">";
    NSString *body = theContent;

    NSString *tail = @"</div></body></html>";
    
    NSString *myHTML = [NSString stringWithFormat:@"%@%@%@", header, body, tail];
    
    NSURL *baseURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]];
    
	[self.myWebView loadHTMLString: myHTML baseURL: baseURL];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadPage: self.contentPair[0] ];
    // Audio filename is self.contentPair[1]
    myPlaySound = [[PlaySound alloc] init];
    NSString *audioFile = self.contentPair[1];
    if ([audioFile isEqualToString: @""]){
        self.playButton.enabled = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doPlay:(id)sender {
    NSString *audioFile = self.contentPair[1];
    [myPlaySound playSound: audioFile];
}

@end
