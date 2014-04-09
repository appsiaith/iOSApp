//
//  TableDetails.m
//  Configurer
//
//  Created by Chris Price on 24/12/2013.
//  Copyright (c) 2013 Chris Price. All rights reserved.
//

#import "TableDetails.h"

@implementation TableDetails

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

{
    self.backImageFile = backImageFile;
    self.backColor = backColor;
    self.headerHeight = headerHeight;
    self.headerImageFile = headerImageFile;
    self.headerFontSize = headerFontSize;
    self.headerFontColor = headerFontColor;
    self.headerCellColor = headerCellColor;
    self.cellHeight = cellHeight;
    self.cellColor = cellColor;
    self.twoTexts = twoTexts;
    self.mainFontSize = mainFontSize;
    self.mainFontColor = mainFontColor;
    self.subFontSize = subFontSize;
    self.subFontColor = subFontColor;
    self.title = title;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // If this is an iPad - double fontsize and spacing
        self.headerHeight = [NSNumber numberWithDouble: headerHeight.doubleValue*1.9];
        self.headerFontSize = [NSNumber numberWithDouble: headerFontSize.doubleValue*1.9];
        self.cellHeight = [NSNumber numberWithDouble: cellHeight.doubleValue*1.9];
        self.mainFontSize = [NSNumber numberWithDouble: mainFontSize.doubleValue*1.9];
        self.subFontSize = [NSNumber numberWithDouble: subFontSize.doubleValue*1.9];
    }
    
    return self;
}

-(CGFloat) floatHeaderHeight{
    return self.headerHeight.floatValue;
}

-(CGFloat) floatHeaderFontSize{
    return self.headerFontSize.floatValue;
}
-(CGFloat) floatCellHeight{
    return self.cellHeight.floatValue;
}

-(CGFloat) floatMainFontSize{
    return self.mainFontSize.floatValue;
}

-(CGFloat) floatSubFontSize{
    return self.subFontSize.floatValue;
}

@end
