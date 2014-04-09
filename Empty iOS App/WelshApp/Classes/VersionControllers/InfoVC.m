//
//  InfoVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 13/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "InfoVC.h"

@interface InfoVC ()  <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation InfoVC

- (void) loadRemotePage: (NSString *) neededURL{
    self.myWebView.scalesPageToFit = YES;
    NSURL *myURL = [NSURL URLWithString: neededURL];
    NSURLRequest *myReq = [NSURLRequest requestWithURL: myURL];

    [self.myWebView loadRequest: myReq];
}

- (void) loadLocalPage: (NSString *) fileName{
    self.myWebView.scalesPageToFit = NO;
    NSString *baseFileName = [fileName stringByReplacingOccurrencesOfString: @".html" withString:@""];
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURLRequest *request = [[NSURLRequest alloc]
                             initWithURL: [NSURL fileURLWithPath:
                                           [NSBundle pathForResource: baseFileName ofType: @"html"
                                                         inDirectory: path]]];
    [self.myWebView loadRequest: request];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
    if ([self.linkType isEqualToString: @"local"]) {
        [self loadLocalPage: self.webFilename];
    } else {
        [self loadRemotePage: self.webFilename];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	self.myWebView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.myWebView stopLoading];
	self.myWebView.delegate = nil;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+3 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
	[self.myWebView loadHTMLString:errorString baseURL:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
