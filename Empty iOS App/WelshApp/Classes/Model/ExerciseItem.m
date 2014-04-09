//
//  ExerciseItem.m
//  CwrsCymraeg
//
//  Created by Chris Price on 26/04/2010.
//  Updated by Neil Taylor on 05/11/2011
//  Copyright 2010-2011 Aberystwyth University. All rights reserved.
//

#import "ExerciseItem.h"

@implementation ExerciseItem

-(ExerciseItem *) initExerciseQText: (NSString *) myQText 
                            ansText: (NSString *) myAnsText  
                             header: (NSString *) myHeader
                             qAudio: (NSString *) myQAudio
                           ansAudio: (NSString *) myAnsAudio
                            picFile: (NSString *) myPicFile{
	self.qText = myQText;
	self.ansText = myAnsText;
    self.header = myHeader;
	self.qAudio = myQAudio;
	self.ansAudio = myAnsAudio;
    self.picFile = myPicFile;
	return self;
}

- (NSString *) description { 
    return [NSString stringWithFormat: @"ExerciseItem qText: '%@' ansText: '%@' qAudio: '%@' ansAudio: '%@' pic: '%@", 
               self.qText, self.ansText, self.qAudio, self.ansAudio, self.picFile];
}

@end
