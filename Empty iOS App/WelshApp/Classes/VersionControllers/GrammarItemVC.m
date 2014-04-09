//
//  GrammarItemVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 02/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "GrammarItemVC.h"
#import "SharedData.h"

@interface GrammarItemVC ()
@property (retain, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation GrammarItemVC

// load the relevant grammar
- (void) loadPage: (NSString *) theGrammar{
    
    NSString *header = @"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"grammar.css\" title=\"fonts\" /></head><body><div class=\"content\">";
   NSString *body = theGrammar;

//    NSString *body = @"<table><tr><td>Bydda i</td><td>Fydda i?</td><td>Fydda i ddim</td></tr><tr><td>Byddi di</td><td>Fyddi di?</td><td>Fyddi di ddim</td></tr></table>";
    NSString *tail = @"</div></body></html>";
 
    NSString *myHTML = [NSString stringWithFormat:@"%@%@%@", header, body, tail];
    
    NSURL *baseURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]];

	[self.myWebView loadHTMLString: myHTML baseURL: baseURL];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadPage: self.grammarContent];
}

- (void)viewDidUnload
{
    [self setMyWebView:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
