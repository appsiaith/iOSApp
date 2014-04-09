//
//  TableDetails.h
//  Configurer
//
//  Created by Chris Price on 24/12/2013.
//  Copyright (c) 2013 Chris Price. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableDetails : NSObject

@property (retain, nonatomic) NSString *title;

@property (retain, nonatomic) NSString *backImageFile;
@property (retain, nonatomic) UIColor *backColor;

@property (retain, nonatomic) NSNumber *headerHeight;
@property (retain, nonatomic) NSString *headerImageFile;
@property (retain, nonatomic) UIColor *headerFontColor;
@property (retain, nonatomic) UIColor *headerCellColor;
@property (retain, nonatomic) NSNumber *headerFontSize;

@property (retain, nonatomic) NSNumber *cellHeight;

@property (nonatomic) BOOL twoTexts;

@property (retain, nonatomic) UIColor *cellColor;
@property (retain, nonatomic) UIColor *mainFontColor;
@property (retain, nonatomic) NSNumber *mainFontSize;
@property (retain, nonatomic) UIColor *subFontColor;
@property (retain, nonatomic) NSNumber *subFontSize;




- (TableDetails *) initWithBackImageFile: (NSString *) backImageFile
                 backColor: (UIColor *) backColor
                 headerHeight: (NSNumber *) headerHeight
                 headerImageFile: (NSString *) headerImageFile
                 headerFontSize: (NSNumber *) headerFontSize
                 headerFontColor: (UIColor *) headerFontColor
                 headerCellColor: (UIColor *) headerCellColor
                 cellHeight: (NSNumber *) cellHeight
                 cellColor: (UIColor *) cellColor
                 twoTexts: (BOOL) twoTexts
                 mainFontSize: (NSNumber *) mainFontSize
                 mainFontColor: (UIColor *) mainFontColor
                    subFontSize: (NSNumber *) subFontSize
                 subFontColor: (UIColor *) subFontColor
                        title: (NSString *) title;

-(CGFloat) floatHeaderHeight;
-(CGFloat) floatCellHeight;

-(CGFloat) floatHeaderFontSize;
-(CGFloat) floatMainFontSize;
-(CGFloat) floatSubFontSize;

@end
