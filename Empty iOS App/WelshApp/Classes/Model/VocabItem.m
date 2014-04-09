//
//  VocabItem.m
//  CwrsCymraeg
//
//  Created by Chris Price on 06/05/2010.
//  Updated by Neil Taylor on 05/11/2011
//  Copyright 2010-2011 Aberystwyth University. All rights reserved.
//

#import "VocabItem.h"

@implementation VocabItem

- (VocabItem *) initEnglishText: (NSString *) myEnglishText 
                     welshText: (NSString *) myWelshText  
							audioName: (NSString *) myAudioName 
                        isMale: (BOOL) myIsMale 
                       hasType: (NSString *) myType {
   
	self.englishText = myEnglishText;
	self.welshText = myWelshText;
	self.audioName = myAudioName;
	self.isMale = myIsMale;
	self.wordType = myType;
	return self;
	
}

- (BOOL) hasAudio { 
   return [self.audioName length] == 0; 
}

- (BOOL) isVerb { 
   return [self.wordType isEqualToString: @"v"];   
}

- (NSString *) description { 
    return [NSString stringWithFormat: @"VocabItem englishText: '%@' welshText: '%@' audioName: '%@' isMale: '%i' wordType: '%@'", 
               self.englishText, self.welshText, self.audioName, self.isMale, self.wordType];
}

@end
