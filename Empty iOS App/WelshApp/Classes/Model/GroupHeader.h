//
//  GroupHeader.h
//  CwrsSylfaen
//
//  Created by Chris Price on 25/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupHeader : NSObject

@property (nonatomic, retain) NSString *welsh;
@property (nonatomic, retain) NSString *english;
@property (nonatomic, retain) NSNumber *groupId;
@property (nonatomic, retain) NSNumber *lessonId;

-(GroupHeader *) initWelsh: (NSString *) myWelsh
                   english: (NSString *) myEnglish
                   groupId: (NSNumber *) myGroupId
                  lessonId: (NSNumber *) myLessonId;

@end
