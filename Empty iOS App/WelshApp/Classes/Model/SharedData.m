//
//  SharedData.m
//  CwrsCymraeg
//
//  Created by Chris Price on 19/04/2009.
//  Copyright 2009-2013 Aberystwyth University.
//

#import "SharedData.h"

@implementation SharedData

#pragma mark - Singleton pattern

/**
 * Simple implementation of the Singleton pattern. It does not prevent 
 * other instances from being created, but it is sufficient for this 
 * application. 
 */

+ (id) sharedInstance { 
   static SharedData *instance = nil; 
   
   if( ! instance ) { 
      instance = [[[self class] alloc] init];
      
      [instance databaseStartup];
      [instance load];
   }
   return instance; 
}

+ (NSInteger) currentUnitNumber { 
    return [[[self class] sharedInstance] currentUnitNumber];    
}

+ (UnitItem *) currentUnitItem { 
    return [[[self class] sharedInstance] currentUnit];    
}

-(NSString *) myDBName{
   // Default name for language database
   return @"langDB.sqlite3";
}


#pragma mark - Database open and close methods

-(void) databaseStartup{
	// This code opens the database read only
	// Retrieve the path to the application directory 
   NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: self.myDBName];
	
	if (sqlite3_open([path UTF8String], &lessonDBase) != SQLITE_OK){
	   sqlite3_close(lessonDBase);
	}
}


-(void) databaseClosedown{
	if (sqlite3_close(lessonDBase) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(lessonDBase));
    }
}

#pragma mark - Utility String Methods 

- (NSString *) utf8StringFromStatement: (sqlite3_stmt *) statement 
                            atPosition: (NSInteger) position { 
    char *itemChar = (char *)sqlite3_column_text(statement, (int)position);
    return [NSString stringWithUTF8String: itemChar];
}


- (NSString *) northSouthTextFromStatement: (sqlite3_stmt *) statement
                             northPosition: (NSInteger) north 
                             southPosition: (NSInteger) south { 
    
    if([self isNorth]) { 
        NSString *northText = [self utf8StringFromStatement: statement atPosition: north];
        if([northText length] > 0) { 
            return northText; 
        }
    }
    
    // this will be called when either the southern string is requested, or when the northern 
    // is requested, but it is the same as the southern string. 
    return [self utf8StringFromStatement: statement atPosition: south];    
    
}


#pragma mark Generic access methods

-(NSArray *) getArrayOfStringsWithQuery: (NSString *) myQuery{
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	
	NSString *query = [[NSString alloc] initWithString: myQuery] ;	
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			[tempArray addObject: [self utf8StringFromStatement: statement atPosition: 0]];
		}
	}
	sqlite3_finalize(statement);
	return tempArray;
}

- (UIImageView *) returnImageViewForJPG: (NSString *) filename{
    // Turn name into a full filepath including .jpg
    NSString *filepath = [[NSBundle mainBundle] pathForResource: filename ofType:@"jpg"];
    
    // Create a UIImage Object to store the image.
    UIImage *image = [[UIImage alloc ] initWithContentsOfFile: filepath];
    
    // Create a UIImageView which the TableView
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    // Set your TableView's background property, it takes a UIView Obj.
    return imageView;
}


#pragma mark  Menu detail obtainer methods

// Get an array of records where each record has one example from a pattern within a lesson
-(NSDictionary *) getMenuItems {
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
	NSString *query =  @"SELECT key, text, subText FROM menu;";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *key = [self utf8StringFromStatement: statement atPosition: 0];
            NSString *text = [self utf8StringFromStatement: statement atPosition: 1];
            NSString *subText = [self utf8StringFromStatement: statement atPosition: 2];
            [keys addObject: key];
            [values addObject: @[text, subText]];
		}
        
	}
	sqlite3_finalize(statement);
    NSDictionary *tempDict = [NSDictionary dictionaryWithObjects: values forKeys: keys];
	return tempDict;
}



- (NSArray *) itemsInMainMenu {
    // Get the menu items and return the right ones
    NSDictionary *allMenuItems = [self getMenuItems];
    NSMutableArray *mainMenu = [[NSMutableArray alloc] init];
    [mainMenu addObject: [allMenuItems valueForKey: @"MAIN_1"]];
    [mainMenu addObject: [allMenuItems valueForKey: @"MAIN_2"]];
    [mainMenu addObject: [allMenuItems valueForKey: @"MAIN_3"]];
    [mainMenu addObject: [allMenuItems valueForKey: @"MAIN_4"]];
    [mainMenu addObject: [allMenuItems valueForKey: @"MAIN_5"]];
    
    return mainMenu;
}

- (NSDictionary *) itemsInUnitSectionMenu {
    // Get the menu items and return the right ones
    NSDictionary *allMenuItems = [self getMenuItems];
    NSArray *pattern = [allMenuItems valueForKey: @"UNIT_1"];
    NSArray *vocabulary = [allMenuItems valueForKey: @"UNIT_2"];
    NSArray *question = [allMenuItems valueForKey: @"UNIT_3"];
    NSArray *grammar = [allMenuItems valueForKey: @"UNIT_4"];
    NSArray *dialog = [allMenuItems valueForKey: @"UNIT_5"];

    return [NSDictionary dictionaryWithObjects:
            @[ pattern, vocabulary, question, grammar, dialog ]
                                forKeys: @[@"pattern", @"vocabulary", @"question", @"grammar", @"dialog"] ];
}

-(NSString *) titleForScreen: (NSString *) screenName{
    NSString *result = @"";
    
    NSString *query = [[NSString alloc] initWithFormat:
                       @"SELECT title FROM appearance WHERE tableName = '%@';", screenName];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		if (sqlite3_step(statement) == SQLITE_ROW) {
           result = [self utf8StringFromStatement: statement atPosition: 0];
        }
    }
    sqlite3_finalize(statement);
 
    return result;
    
}


-(NSString *) headerForScreen: (NSString *) screenName{
    NSString *result = @"";
    
    NSString *query = [[NSString alloc] initWithFormat:
                       @"SELECT header FROM appearance WHERE tableName = '%@';", screenName];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		if (sqlite3_step(statement) == SQLITE_ROW) {
            result = [self utf8StringFromStatement: statement atPosition: 0];
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(NSArray *) furtherInfoList{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT title, info, linkType, url FROM about ORDER by ordering;";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		while (sqlite3_step(statement) == SQLITE_ROW) {
            [tempArray addObject: @[
                            [self utf8StringFromStatement: statement atPosition: 0],
                            [self utf8StringFromStatement: statement atPosition: 1],
                            [self utf8StringFromStatement: statement atPosition: 2],
                            [self utf8StringFromStatement: statement atPosition: 3] ]];
        }
    }
    sqlite3_finalize(statement);
    
    return tempArray;
}



-(CGFloat) colorValue: (sqlite3_stmt *) statement atPosition: (int) pos{
    int colorInt = (int) sqlite3_column_int(statement, pos);
    return colorInt / 255.0;
}

-(UIColor *) makeColor: (sqlite3_stmt *) statement atPosition: (int) pos  {
    UIColor *theColor = [UIColor colorWithRed: [self colorValue: statement atPosition: pos]
                                         green: [self colorValue: statement atPosition: pos+1]
                                          blue: [self colorValue: statement atPosition: pos+2]
                                         alpha: [self colorValue: statement atPosition: pos+3]];
    return theColor;
}


- (TableDetails *) getTableInfo: (NSString *) tableName{
    //Needs filling from database
 
    TableDetails *myInfo;
    // Get appearance details from database
	NSString *query = [[NSString alloc] initWithFormat:
                       @"SELECT backImage, backColorRed, backColorGreen, backColorBlue, backColorAlpha, headerHeight, headerImage, headerFontsize, cellHeight, cellColorRed, cellColorGreen, cellColorBlue, cellColorAlpha,  twoTexts, mainFontSize, mainFontColorRed, mainFontColorGreen,	 mainFontColorBlue, mainFontColorAlpha, subFontSize, subFontColorRed, subFontColorGreen, subFontColorBlue, subFontColorAlpha, headerFontColorRed, headerFontColorGreen, headerFontColorBlue, headerFontColorAlpha, headerCellColorRed, headerCellColorGreen, headerCellColorBlue, headerCellColorAlpha, title FROM appearance WHERE tableName = '%@';", tableName];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		while (sqlite3_step(statement) == SQLITE_ROW) {

            myInfo = [[TableDetails alloc]
                          initWithBackImageFile: [self utf8StringFromStatement: statement atPosition: 0]
                          backColor: [self makeColor: statement atPosition: 1]
                          headerHeight:  [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 5)]
                          headerImageFile: [self utf8StringFromStatement: statement atPosition: 6]
                          headerFontSize: [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 7)]
                          headerFontColor: [self makeColor: statement atPosition: 24]
                          headerCellColor: [self makeColor: statement atPosition: 28]
                          cellHeight: [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 8)]
                          cellColor: [self makeColor: statement atPosition: 9]
                          twoTexts: YES
                          mainFontSize: [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 14)]
                          mainFontColor: [self makeColor: statement atPosition: 15]
                          subFontSize:  [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 19)]
                          subFontColor: [self makeColor: statement atPosition: 20]
                      title: [self utf8StringFromStatement: statement atPosition: 32] ];
	}
	sqlite3_finalize(statement);

    
   }
    
    return myInfo;
}


#pragma mark  Lesson title methods
- (NSArray *) groupHeadersForLesson: (int) lessonNum ofType: (NSString *) groupType {
    // Get an array of group headers
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	NSString *query =  [[NSString alloc] initWithFormat: @"SELECT english, south, north, id FROM group_header WHERE lessonId = %d AND groupType = '%@' ORDER BY ordering;", lessonNum, groupType ];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		GroupHeader *myGroupHeader;
		while (sqlite3_step(statement) == SQLITE_ROW) {
            
			myGroupHeader = [[GroupHeader alloc]
                             initWelsh: [self northSouthTextFromStatement: statement northPosition:2 southPosition: 1]
                             english: [self utf8StringFromStatement: statement atPosition: 0]
                             groupId: [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 3)]
                             lessonId: [NSNumber numberWithInt: lessonNum]];
            [tempArray addObject: myGroupHeader];
//            NSLog(@"Groupid is %i", myGroupHeader.groupId.intValue);
		}
        
	}
	sqlite3_finalize(statement);
	return tempArray;
}


#pragma mark Lesson pattern access methods

// Get an array of records where each record has one example from a pattern within a lesson
-(NSArray *) getPatternBodiesForPatternGroup: (int) groupNum {
    
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
	NSString *query = [[NSString alloc] initWithFormat: 
							 @"SELECT south, north, english, audioSouth, audioNorth FROM pattern WHERE groupId = %d ORDER BY id;", groupNum ];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		PatternItem *myPattern;
		while (sqlite3_step(statement) == SQLITE_ROW) {
            
			myPattern = [[PatternItem alloc] initWelsh: [self northSouthTextFromStatement: statement northPosition:1 southPosition: 0] 
                                               english: [self utf8StringFromStatement: statement atPosition: 2] 
                                                 audio: [self northSouthTextFromStatement: statement northPosition: 4 southPosition: 3] ];

            [tempArray addObject: myPattern];
		}
      
	}
	sqlite3_finalize(statement);
	return tempArray;
}


- (NSArray *) getPatternTitlesForCurrentUnit {
    return [self groupHeadersForLesson: (int) self.currentUnitNumber ofType: @"pattern"];
}


- (NSArray *) getAllPatternBodiesFromLesson: (int) startLessonNum ToLesson: (int) endLessonNum{
    NSMutableArray *patternGroups = [[NSMutableArray alloc] init];
    // First get all the pattern group headers
	NSString *query =  [[NSString alloc] initWithFormat: @"SELECT id FROM group_header WHERE lessonId >= %d AND lessonId <= %d AND groupType = 'pattern';", startLessonNum, endLessonNum ];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		while (sqlite3_step(statement) == SQLITE_ROW) {
            NSNumber *groupNum =  [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 0)];
            [patternGroups addObject: groupNum];
 		}
	}
	sqlite3_finalize(statement);
    
    // Now get all the patterns for each lesson group in pattern groups as vocab items (used in Revision)
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	
    for (NSNumber *nextGroup in patternGroups) {
	   // Use each groupIndex to get all patterns in that group
	   query = [[NSString alloc] initWithFormat:
                       @"SELECT south, north, english, audioSouth, audioNorth FROM pattern WHERE groupId = %d;", nextGroup.intValue];
	   if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		   VocabItem *myVocab;  //Using Vocab items so revision items always look the same
		   while (sqlite3_step(statement) == SQLITE_ROW) {
			   myVocab = [[VocabItem alloc] initEnglishText: [self utf8StringFromStatement: statement atPosition: 2]
                                               welshText: [self northSouthTextFromStatement: statement northPosition:1 southPosition: 0]
                                               audioName: [self northSouthTextFromStatement: statement northPosition: 4 southPosition: 3]
                                                  isMale: NO
                                                 hasType: @""];
			
			[tempArray addObject: myVocab];
           }
	   }
	   sqlite3_finalize(statement);
    }
	return tempArray;

}


#pragma mark Exercise access methods

-(NSArray *) getExerciseTitlesForLesson: (int) lessonNum{
    // Get an array ofrecords where each record has the exercise header and the id to be used to look up contents
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	NSString *query =  [[NSString alloc] initWithFormat: @"SELECT english, id FROM group_header WHERE lessonId = %d AND groupType = 'question' ORDER BY ordering;", lessonNum ];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		while (sqlite3_step(statement) == SQLITE_ROW) {
			[tempArray addObject:  @[[self utf8StringFromStatement: statement atPosition: 0],
                                     [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 1)]]];
		}
	}
	sqlite3_finalize(statement);
	return tempArray;
    
}

-(NSArray *) getExerciseBodiesForExercise: (int) groupId{
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
	NSString *query = [[NSString alloc] initWithFormat:
							 @"SELECT questionSouth, questionNorth, answerSouth, answerNorth, questionAudioSouth, questionAudioNorth, answerAudioSouth, answerAudioNorth, picture, title FROM question WHERE groupId = %d;", groupId ];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		ExerciseItem *myExercise;
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
        	myExercise = [[ExerciseItem alloc] initExerciseQText: [self northSouthTextFromStatement: statement northPosition:1 southPosition: 0] 
                                                         ansText: [self northSouthTextFromStatement: statement northPosition: 3 southPosition: 2]
                                                         header: [self utf8StringFromStatement: statement atPosition: 9]
                                                         qAudio: [self northSouthTextFromStatement: statement northPosition: 5 southPosition: 4]
                                                        ansAudio: [self northSouthTextFromStatement: statement northPosition: 7 southPosition: 6]
                                                        picFile: [self utf8StringFromStatement: statement atPosition: 8]];
			
			[tempArray addObject: myExercise];
		}
	}
	sqlite3_finalize(statement);
	return tempArray;
}

#pragma mark - Vocab Access Methods 

-(NSArray *) getVocabItemsForLesson: (int) lessonNum{
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    //Get the header(s)
    NSArray *groupHeaders = [self groupHeadersForLesson: lessonNum ofType: @"vocabulary"];
    sqlite3_stmt *statement;
    for (GroupHeader *item in groupHeaders){
        int groupNum = item.groupId.intValue;

        NSString *query = [[NSString alloc] initWithFormat:
						 @"SELECT south, north, english, audioSouth, audioNorth, gender, wordClass FROM vocabulary WHERE groupId = %d ORDER BY ordering;", groupNum ];
	    if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		   VocabItem *myVocab;
		
           while (sqlite3_step(statement) == SQLITE_ROW) {
		
		    	NSString *gender = [self utf8StringFromStatement: statement atPosition: 5];
		    	BOOL tryMale = ![gender isEqualToString:@"f"];

			    myVocab = [[VocabItem alloc] initEnglishText: [self utf8StringFromStatement: statement atPosition: 2]
                                               welshText: [self northSouthTextFromStatement: statement northPosition: 1 southPosition: 0] 
                                               audioName: [self northSouthTextFromStatement: statement northPosition: 4 southPosition: 3]
                                                  isMale: tryMale 
                                                 hasType: [self utf8StringFromStatement: statement atPosition: 6]];
			
			    [tempArray addObject: myVocab];
		   }
	   }
        sqlite3_finalize(statement);
    }

	return tempArray;
}

- (NSArray *) getAllVocabItemsFromLesson: (int) startLessonNum ToLesson: (int) endLessonNum{
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int lessonNum = startLessonNum; lessonNum <= endLessonNum; lessonNum++) {
        [tempArray addObjectsFromArray: [self getVocabItemsForLesson: lessonNum] ];
    }

	return tempArray;
}

-(NSArray *) getAllVocabItemsbyEnglish: (BOOL) sortedEnglish{
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	// Turn the index into a patternId
	NSString *query;
	if (sortedEnglish == YES){
			query = [[NSString alloc] initWithFormat: 
							 @"SELECT south, north, english, audioSouth, audioNorth, gender, wordClass FROM vocabulary ORDER BY UPPER(english);"];
	} else {
		   query = [[NSString alloc] initWithFormat: 
								 @"SELECT south, north, english, audioSouth, audioNorth, gender, wordClass FROM vocabulary ORDER BY UPPER(south);"];
	}
		
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		VocabItem *myVocab;
		BOOL tryMale;

		while (sqlite3_step(statement) == SQLITE_ROW) {
			
            NSString *gender = [self utf8StringFromStatement: statement atPosition: 4];
			tryMale = ![gender isEqualToString:@"f"]; 	
			
			myVocab = [[VocabItem alloc] initEnglishText: [self utf8StringFromStatement: statement atPosition: 2] 
                                               welshText: [self northSouthTextFromStatement: statement northPosition: 1 southPosition: 0] 
                                               audioName: [self northSouthTextFromStatement: statement northPosition: 4 southPosition: 3]
                                                  isMale: tryMale
                                                 hasType: [self utf8StringFromStatement: statement atPosition: 6]];
			
			[tempArray addObject: myVocab];
		}
	}
	
	sqlite3_finalize(statement);
	return tempArray;
}

-(NSString *) getRandomVocab: (int) lessonNum{
	
	// This returns a random vocab item from the current lesson the learner is on
	// Get all vocab items and pick one
	NSArray *tempArray = [self getVocabItemsForLesson: lessonNum];
	
   // don't continue if there aren't any items
   if ([tempArray count] == 0) {
      return @"--";
   }
   
	// Seed the random number
	srandom((int)time(NULL));
	int myIndex = random() % (int)[tempArray count];
	
	VocabItem *myVocab = [tempArray objectAtIndex: myIndex];
	return [[NSString alloc] initWithFormat: @"%@ - %@", myVocab.welshText, myVocab.englishText ];	

}

// Grammar access methods
- (NSArray *) getGrammarTitlesForCurrentUnit{
    // Get an array of group headers
    return [self groupHeadersForLesson: (int) self.currentUnitNumber ofType: @"grammar"];
}

-(NSString *) getGrammarContentForHeader: (int) groupId {
   //Used when choosing from a list of grammar items in the current unit - indexUnit is the chosen one, so get its groupId from the group_header then get the right one
    NSString *result;
    NSString *query =  [NSString stringWithFormat: @"SELECT html FROM grammar WHERE groupId = %i;", groupId];
    sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		if (sqlite3_step(statement) == SQLITE_ROW) {
            result = [self utf8StringFromStatement: statement atPosition: 0];
		}
	}
	sqlite3_finalize(statement);
    return result;
}


- (NSArray *) getListOfGrammarTitles{ 
    // This method returns an ordered array of group_headers
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	NSString *query =  @"SELECT english, id, lessonId FROM group_header WHERE groupType = 'grammar' ORDER BY lessonId;";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
		GroupHeader *myGroupHeader;
		while (sqlite3_step(statement) == SQLITE_ROW) {
			myGroupHeader = [[GroupHeader alloc]
                             initWelsh: nil
                             english: [self utf8StringFromStatement: statement atPosition: 0]
                             groupId: [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 1)]
                             lessonId: [NSNumber numberWithInt:(int) sqlite3_column_int(statement, 2)]];
            [tempArray addObject: myGroupHeader];
		}
	}
	sqlite3_finalize(statement);
	return tempArray;
}



- (NSArray *) getExerciseTitlesForCurrentUnit { 
    return [self groupHeadersForLesson: (int) self.currentUnitNumber ofType: @"question"];
}


- (NSArray *) getVocabItemsForCurrentUnit { 
   return [self getVocabItemsForLesson: (int) self.currentUnitNumber];   
}

- (NSString *) getRandomVocabForCurrentUnit { 
   return [self getRandomVocab: (int) self.currentUnitNumber];   
}


#pragma mark dialog access methods

- (NSArray *) getDialogTitlesForCurrentUnit{
    return [self groupHeadersForLesson: (int) self.currentUnitNumber ofType: @"dialog"];
}

-(NSString *) getDialogTypeForGroupId: (int) groupId{
    NSString *result = @"dialogue";
	NSString *query;
    query = [[NSString alloc] initWithFormat:
             @"SELECT  memberType FROM group_header WHERE id = %d;", groupId ];
    
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
        
		if (sqlite3_step(statement) == SQLITE_ROW) {
            int memType = sqlite3_column_int(statement, 0);
            if (memType == 1) { result = @"monologue";}
        }
	}
    
	sqlite3_finalize(statement);
	return result;
    
}

- (NSArray *) getMonologContentForExtraItem: (int) extraItem{
    // Return an array with an NSString to html, plus an audio file name
    // Return an array of [name: / subname / type / index tuples] for the current unit
	NSArray *tempArray;
	// Turn the index into a patternId
	NSString *query;
    query = [[NSString alloc] initWithFormat:
             @"SELECT  south, north, audioSouth, audioNorth FROM dialog WHERE groupId = %d;", extraItem ];
    
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
        
		if (sqlite3_step(statement) == SQLITE_ROW) {
			// adding speaker, welsh (north or south) and the audio to the array
			tempArray = @[ [self northSouthTextFromStatement: statement northPosition: 1 southPosition: 0],
                           [self northSouthTextFromStatement: statement northPosition: 3 southPosition: 2]];
		}
	}
    
	sqlite3_finalize(statement);
	return tempArray;
}




- (NSArray *) getDialogContentForExtraItem: (int) extraItem {
   // Return an array of [name: / dialog string / audio triples] for the current unit
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	// Turn the index into a patternId
	NSString *query;
    query = [[NSString alloc] initWithFormat: 
               @"SELECT speaker, south, north, audioSouth, audioNorth FROM dialog WHERE groupId = %d ORDER BY ordering", extraItem ];

	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2( lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
     
		while (sqlite3_step(statement) == SQLITE_ROW) {
      //      NSLog(@"got a dialog item");	
         
			// adding speaker, welsh (north or south) and the audio to the array
			[tempArray addObject: @[ [self utf8StringFromStatement: statement atPosition: 0],
                                      [self northSouthTextFromStatement: statement northPosition:2 southPosition:1], 
                                      [self northSouthTextFromStatement: statement northPosition:4 southPosition:3] ]];
		}
	}
	
	sqlite3_finalize(statement);
	return tempArray;
}

#pragma mark - Property Settings 

- (NSString *) pathToSettingsFile { 
   
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex: 0];
   NSString *path = [documentsDirectory stringByAppendingPathComponent: @"cmsettings.plist"];
   
   return path; 
}


/*
 * Load the settings from a file (if the file exists), or create the settings
 * with default values. 
 */
- (void) load { 
   NSString *path = [self pathToSettingsFile];
   if ([[NSFileManager defaultManager] fileExistsAtPath: path]) {
      
      NSArray *array;
      
      @try {
         array = [[NSArray alloc] initWithContentsOfFile: path];
         self.northSouth = [[array objectAtIndex: 0] intValue];
         self.currentUnitNumber = [[array objectAtIndex: 1] integerValue];
      }
      @catch (NSException * e) {
         NSLog(@"Error opening and loading file %@", e);
      }
      @finally {
      }
   }
   else {
//      NSLog(@"No file at path - creating default values");
      // initialise default variables.
      self.northSouth = ProjectSettingsLanguageSouth; 
      self.currentUnitNumber = 1; 
   }
}

/*
 * Save the specified settings to file. 
 */
- (void) save {
   NSMutableArray *array;
   
   @try {
      array = [[NSMutableArray alloc] init];
      [array addObject: [NSNumber numberWithInt: self.northSouth]];
      [array addObject: [NSNumber numberWithInteger: self.currentUnitNumber]];
      [array writeToFile: [self pathToSettingsFile] atomically: YES];
   }
   @catch (NSException * e) {
      NSLog(@"Unable to save detals: %@", e); 
   }
   @finally {
   }
}

- (BOOL) isNorth { 
   return self.northSouth == ProjectSettingsLanguageNorth; 
}

- (BOOL) isSouth { 
   return self.northSouth == ProjectSettingsLanguageSouth; 
}

#pragma mark - Lesson Types


-(BOOL) lessonTypeExists: (NSString *) lessonType inLesson: (int) lessonNum {
    BOOL result = NO;
	sqlite3_stmt *statement;
    NSString *query = [NSString stringWithFormat:
        @"SELECT english FROM group_header WHERE lessonId = %i AND groupType = '%@';",  lessonNum, lessonType];
	if (sqlite3_prepare_v2(lessonDBase, [query UTF8String], -1, &statement, nil ) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW) { //Then there is a result for this unit
            result = YES;
        }
    }
    sqlite3_finalize(statement);
    return result;
}

- (NSArray *) lessonTypesInCurrentUnit {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSString *lessonType in @[ @"pattern", @"vocabulary", @"question", @"grammar", @"dialog" ]) {
        if ([self lessonTypeExists: lessonType inLesson: (int)[self currentUnitNumber]]) {
            [tempArray addObject: lessonType];
        }
    }

	return tempArray;  
}

- (UnitItem *) extractUnitDetailsFromStatement: (sqlite3_stmt *) statement { 
    
    UnitItem *item = [[UnitItem alloc] init];
    [item setUnitId: sqlite3_column_int(statement, 0)];
    [item setEnglish: [self utf8StringFromStatement:statement atPosition: 1]];
    [item setNorth: [self utf8StringFromStatement:statement atPosition: 2]];
    [item setSouth: [self utf8StringFromStatement:statement atPosition: 3]];
    
    return item; 
}
 
- (UnitItem *) unitWithId: (NSInteger) unitId { 

    UnitItem *item = nil; 
    
    NSString *query = [[NSString alloc] initWithFormat: @"SELECT id, english, north, south FROM lesson WHERE id = %i", (int)unitId];
    sqlite3_stmt *statement; 
    if(sqlite3_prepare_v2(lessonDBase, [query UTF8String], -1, &statement, nil) == SQLITE_OK) { 
        if(sqlite3_step(statement)) { 
            item = [self extractUnitDetailsFromStatement: statement];                    
        }
    }
    
    sqlite3_finalize(statement);
    return item; 
}

- (UnitItem *) currentUnit { 
    return [self unitWithId: [self currentUnitNumber]];
}

- (NSArray *) allUnits { 
    
    NSMutableArray *units = [[NSMutableArray alloc] init];
    
    NSString *query = [[NSString alloc] initWithFormat: @"SELECT id, english, north, south FROM lesson ORDER BY ordering"];
    sqlite3_stmt *statement; 
    if(sqlite3_prepare_v2(lessonDBase, [query UTF8String], -1, &statement, nil) == SQLITE_OK) { 
        while(sqlite3_step(statement)== SQLITE_ROW) { 
            [units addObject: [self extractUnitDetailsFromStatement: statement]];                    
        }
    }
    
    sqlite3_finalize(statement);
    return units; 
}

// Customise strings to the current unit

+(NSString *) unitiseString: (NSString *) theString{
   //This method replaces occurrences of "U1" in the string with the current unit number
    NSString *unitNumber = [NSString stringWithFormat: @"%i", (int)[SharedData currentUnitNumber]];
    
    return [theString stringByReplacingOccurrencesOfString: @"U1" withString: unitNumber];
}

@end
