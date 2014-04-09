//
//  GroupHeader.m
//  CwrsSylfaen
//
//  Created by Chris Price on 25/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "GroupHeader.h"

@implementation GroupHeader

-(GroupHeader *) initWelsh: (NSString *) myWelsh
                   english: (NSString *) myEnglish
                   groupId: (NSNumber *) myGroupId
                  lessonId: (NSNumber *) myLessonId{
	self.welsh = myWelsh;
	self.english = myEnglish;
	self.groupId = myGroupId;
    self.lessonId = myLessonId;
	return self;
}

- (NSString *) description {
    return [NSString stringWithFormat: @"GroupHeader english: '%@' welsh: '%@'", self.english, self.welsh];
}
            
@end
