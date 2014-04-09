//
//  VocabItem.h
//  CwrsCymraeg
//
//  Created by Chris Price on 06/05/2010.
//  Copyright 2010-2011 Aberystwyth University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VocabItem : NSObject {
	
}

@property (nonatomic, retain) NSString *englishText;
@property (nonatomic, retain) NSString *welshText;
@property (nonatomic, retain) NSString *audioName;
@property (nonatomic) BOOL isMale;
@property (nonatomic, retain) NSString *wordType;

// Initializer
-(VocabItem *) initEnglishText: (NSString *) myEnglishText 
                     welshText: (NSString *) myWelshText  
					 audioName: (NSString *) myAudioName 
                        isMale: (BOOL) myIsMale 
                       hasType: (NSString *) myType;

- (BOOL) hasAudio; 
- (BOOL) isVerb;

@end
