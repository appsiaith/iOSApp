//
//  SharedData.h
//  CwrsCymraeg
//
//  This class provides access to the database and manages settings 
//  including North and South selection and the units that are authorised. 
//
//  Created by Chris Price on 19/04/2009.
//  Copyright 2009-2011 Aberystwyth University. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "PatternItem.h"
#import "ExerciseItem.h"
#import "VocabItem.h"
#import "UnitItem.h"
#import "TableDetails.h"
#import "GroupHeader.h"

typedef enum { 
   ProjectSettingsLanguageNorth, 
   ProjectSettingsLanguageSouth
} ProjectSettingsLanguageType; 

@interface SharedData : NSObject {

	sqlite3 *lessonDBase;
      
}

// holds the value of 1 or 2 (LANGUAGE_NORTH/SOUTH) 
@property (nonatomic) ProjectSettingsLanguageType northSouth; 

// the unit number that is displayed as the current unit on the home page
@property (nonatomic) NSInteger currentUnitNumber; 


- (BOOL) isNorth; 
- (BOOL) isSouth; 

- (void) load; 
- (void) save; 

+ (id) sharedInstance;  
+ (NSInteger) currentUnitNumber; 
+ (UnitItem *) currentUnitItem; 

// Database open and close methods
- (void) databaseStartup;

- (void) databaseClosedown;


//Detail obtainer methods
- (NSArray *) itemsInMainMenu;
- (NSDictionary *) itemsInUnitSectionMenu;
-(NSString *) headerForScreen: (NSString *) screenName;
-(NSString *) titleForScreen: (NSString *) screenName;
- (TableDetails *) getTableInfo: (NSString *) tableName;
-(NSArray *) furtherInfoList;


// Pattern access methods
- (NSArray *) getPatternTitlesForCurrentUnit;
-(NSArray *) getPatternBodiesForPatternGroup: (int) groupNum;

    // (Following returns an array of VocabItems as used in shared code with vocab code)
- (NSArray *) getAllPatternBodiesFromLesson: (int) startLessonNum ToLesson: (int) endLessonNum;

// Exercise access methods
- (NSArray *) getExerciseTitlesForCurrentUnit;
-(NSArray *) getExerciseBodiesForExercise: (int) groupId;

// Vocab access methods
- (NSArray *) getVocabItemsForCurrentUnit; 
- (NSArray *) getAllVocabItemsFromLesson: (int) startLessonNum ToLesson: (int) endLessonNum;
-(NSArray *) getAllVocabItemsbyEnglish: (BOOL) sortedEnglish;
- (NSString *) getRandomVocabForCurrentUnit; 

// Grammar access methods
- (NSArray *) getGrammarTitlesForCurrentUnit; 
-(NSString *) getGrammarContentForHeader: (int) groupId;
- (NSArray *) getListOfGrammarTitles; // Find all grammar items

// Dialogue access methods
- (NSArray *) getDialogTitlesForCurrentUnit;
- (NSArray *) getMonologContentForExtraItem: (int) extraItem;
- (NSArray *) getDialogContentForExtraItem: (int) extraItem;
-(NSString *) getDialogTypeForGroupId: (int) groupId;

// Unit level details
- (NSArray *) lessonTypesInCurrentUnit;

- (NSArray *) allUnits;
- (UnitItem *) unitWithId: (NSInteger) unitId;
- (UnitItem *) currentUnit;

// Customise strings to the current unit
+(NSString *) unitiseString: (NSString *) theString;

@end
