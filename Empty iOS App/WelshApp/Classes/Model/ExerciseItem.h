//
//  ExerciseItem.h
//  CwrsCymraeg
//
//  Created by Chris Price on 26/04/2010.
//  Copyright 2010-2011 Aberystwyth University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExerciseItem : NSObject {

}

@property (nonatomic, retain) NSString *qText;
@property (nonatomic, retain) NSString *ansText;
@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) NSString *qAudio;
@property (nonatomic, retain) NSString *ansAudio;
@property (nonatomic, retain) NSString *picFile;

// Initializer
-(ExerciseItem *) initExerciseQText: (NSString *) myQText 
                            ansText: (NSString *) myAnsText
                             header: (NSString *) myHeader
                             qAudio: (NSString *) myQAudio 
                           ansAudio: (NSString *) myAnsAudio
                            picFile: (NSString *) picFile;

@end
