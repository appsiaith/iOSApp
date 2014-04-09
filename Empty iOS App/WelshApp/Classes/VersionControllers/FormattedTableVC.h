//
//  FormattedTableVC.h
//  CymraegTeulu
//
//  Created by Chris Price on 06/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableDetails.h"

@interface FormattedTableVC : UITableViewController

@property (nonatomic, retain) TableDetails *myTableDets;
@property (nonatomic, retain) NSString *lookupString;
@property (nonatomic, retain) NSArray *tableArray;

-(UITableViewCell *) configureHeaderForIndexPath:(NSIndexPath *)indexPath;

-(void) configureCell: (UITableViewCell *) cell;

- (void) loadBackgroundImageAndTitle;

@end
