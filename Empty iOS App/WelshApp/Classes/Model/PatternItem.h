//
//  PatternItem.h
//  CwrsCymraeg
//
//  Created by Chris Price on 26/04/2010.
//  Updated by Neil Taylor on 05/11/2011
//  Copyright 2010-2011 Aberystwyth University. All rights reserved.
//
// Simple Object to hold the usable details of a pattern entry
// An array of them is return to the Pattern class to use

#import <Foundation/Foundation.h>

@interface PatternItem : NSObject {

}

@property (nonatomic, retain) NSString *welsh;
@property (nonatomic, retain) NSString *english;
@property (nonatomic, retain) NSString *audio;

-(PatternItem *) initWelsh: (NSString *) myWelsh 
                   english: (NSString *) myEnglish 
                     audio: (NSString *) myAudio;
@end
