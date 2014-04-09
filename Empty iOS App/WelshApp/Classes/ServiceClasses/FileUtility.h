//
//  FileUtility.h
//  CwrsCymraeg
//
//  Created by Neil Taylor on 14/09/2010.
//  Copyright 2010 Aberystwyth University. All rights reserved.
//
//  This file provides utility methods for loading files. 
//

#import <Foundation/Foundation.h>

@interface FileUtility : NSObject 

+ (NSString *) languageFileNameForMP3Resource: (NSString *) resource;
+ (NSString *) languageFileNameForXMLResource: (NSString *) resource;
+ (NSString *) languageFileNameForResource: (NSString *) resource ofType: (NSString *) type;

+ (BOOL) mainBundleContainsMP3File: (NSString *) filename;
+ (BOOL) mainBundleContainsXMLFile: (NSString *) filename;
+ (BOOL) mainBundleContainsFile: (NSString *) filename ofType: (NSString *) type; 

+ (NSURL *) languageURLForMP3Resource: (NSString *) resource; 
+ (NSURL *) languageURLForXMLResource: (NSString *) resource; 
+ (NSURL *) languageURLForResource: (NSString *) resource ofType: (NSString *) type;

@end
