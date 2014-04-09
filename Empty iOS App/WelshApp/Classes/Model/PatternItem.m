//
//  PatternItem.m
//  CwrsCymraeg
//
//  Created by Chris Price on 26/04/2010.
//  Updated by Neil Taylor on 05/11/2011
//  Copyright 2010-2011 Aberystwyth University. All rights reserved.
//

#import "PatternItem.h"

@implementation PatternItem

-(PatternItem *) initWelsh: (NSString *) myWelsh
                   english: (NSString *) myEnglish 
                     audio: (NSString *) myAudio {
	self.welsh = myWelsh;
	self.english = myEnglish;
	self.audio = myAudio;	
	return self;
}

- (NSString *) description { 
    return [NSString stringWithFormat: @"PatternItem english: '%@' welsh: '%@' audio: '%@'", self.english, self.welsh, self.audio];    
}

@end
