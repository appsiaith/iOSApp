//
//  FileUtility.m
//  CwrsCymraeg
//
//  Created by Neil Taylor on 14/09/2010.
//  Copyright 2010 Aberystwyth University. All rights reserved.
//

#import "FileUtility.h"
#import "SharedData.h"

@implementation FileUtility


#pragma mark -
#pragma mark Language Filename for Resources

+ (NSString *) languageFileNameForMP3Resource: (NSString *) resource { 
   return [FileUtility languageFileNameForResource: resource ofType: @"mp3"];   
}

+ (NSString *) languageFileNameForXMLResource: (NSString *) resource { 
   return [FileUtility languageFileNameForResource: resource ofType: @"xml"];   
}

+ (NSString *) languageFileNameForResource: (NSString *) resource ofType: (NSString *) type { 
    
   NSString *filename = resource; 
   
   if ([[SharedData sharedInstance] isNorth]) {
		NSString *northFilename = [ @"N" stringByAppendingString: filename];
		if( [[NSFileManager defaultManager] fileExistsAtPath:
              [NSBundle pathForResource: northFilename ofType: type 
                            inDirectory: [[NSBundle mainBundle] bundlePath]]]) {
			filename = northFilename;
				  } 
	}
   
   return filename; 
   
}

#pragma mark -
#pragma mark Language URL for Resources

+ (NSURL *) languageURLForXMLResource: (NSString *) resource { 
   return [FileUtility languageURLForResource: resource ofType: @"xml"];
}

+ (NSURL *) languageURLForMP3Resource: (NSString *) resource { 
   return [FileUtility languageURLForResource: resource ofType: @"mp3"];
}


+ (NSURL *) languageURLForResource: (NSString *) resource ofType: (NSString *) type { 

   NSString *file = [FileUtility languageFileNameForResource: resource ofType: type];
   return [NSURL fileURLWithPath: 
              [NSBundle pathForResource: file 
                                 ofType: type 
                            inDirectory: [[NSBundle mainBundle] bundlePath]]];
   
}

#pragma mark -
#pragma mark Main Bundle Methods

+ (BOOL) mainBundleContainsMP3File: (NSString *) filename { 
   return [FileUtility mainBundleContainsFile: filename ofType: @"mp3"];
}

+ (BOOL) mainBundleContainsXMLFile: (NSString *) filename { 
   return [FileUtility mainBundleContainsFile: filename ofType: @"xml"];
}


+ (BOOL) mainBundleContainsFile: (NSString *) filename ofType: (NSString *) type { 
   return [[NSFileManager defaultManager] fileExistsAtPath: 
           [NSBundle pathForResource: filename ofType: type inDirectory: [[NSBundle mainBundle] bundlePath]]]; 
}

@end
