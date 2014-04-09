//
//  FormattedTableVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 06/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "FormattedTableVC.h"
#import "SharedData.h"

@interface FormattedTableVC () 


@end

@implementation FormattedTableVC

- (UIImage *) returnImageForJPG: (NSString *) filename{
    if ([filename length] == 0) {return nil;}
    // Turn name into a full filepath including .jpg
    NSString *baseFilename = [filename stringByReplacingOccurrencesOfString: @".jpg" withString:@""];
    NSString *filepath = [[NSBundle mainBundle] pathForResource: baseFilename ofType:@"jpg"];
    
    // Create a UIImage Object to store the image.
    UIImage *image = [[UIImage alloc ] initWithContentsOfFile: filepath];
    
    return image;
}

- (UIImageView *) returnImageViewForJPG: (NSString *) filename{
    if ([filename length] == 0) {return nil;}
    // Turn name into a full filepath including .jpg
    NSString *baseFilename = [filename stringByReplacingOccurrencesOfString: @".jpg" withString:@""];
    NSString *filepath = [[NSBundle mainBundle] pathForResource: baseFilename ofType:@"jpg"];
    
    // Create a UIImage Object to store the image.
    UIImage *image = [[UIImage alloc ] initWithContentsOfFile: filepath];
    
    // Create a UIImageView which the TableView
    UIImageView *bgView = [[UIImageView alloc] initWithImage:image];
    
    // Set your TableView's background property, it takes a UIView Obj.
    return bgView;
}

- (void) loadBackgroundImageAndTitle {
    self.myTableDets = [[SharedData sharedInstance] getTableInfo: self.lookupString];
    NSString *backFileName = [SharedData unitiseString: self.myTableDets.backImageFile];
    UIImageView *backView = [self returnImageViewForJPG: backFileName];
    if (backView != nil){
        [[self tableView] setBackgroundView: backView];
    } else {
        [[self tableView] setBackgroundColor: self.myTableDets.backColor ];
    }
    self.title = [SharedData unitiseString: self.myTableDets.title];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBackgroundImageAndTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 1;  // Size for optional heading picture
    if (section == 1) {
        numOfRows = self.tableArray.count;
    }
    return numOfRows;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result = self.myTableDets.floatCellHeight;
    if (indexPath.section == 0) {result = self.myTableDets.floatHeaderHeight; }
    return result;
}

-(void) pimpMyCellHeader: (UITableViewCell *) cell {
    // This method can be used by specific FormattedTables to do substitutions in the headerText label
}

-(UITableViewCell *) configureHeaderForIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
    if ([self.myTableDets.headerImageFile length] > 0){
       NSString *headerFileName = [SharedData unitiseString: self.myTableDets.headerImageFile];
        cell.backgroundView = [self returnImageViewForJPG: headerFileName];
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.backgroundView = nil;
        cell.backgroundColor = self.myTableDets.headerCellColor;
    }
    UIFont *myFont = [UIFont boldSystemFontOfSize: self.myTableDets.floatHeaderFontSize];
    cell.textLabel.font = myFont;
    cell.textLabel.textColor = self.myTableDets.headerFontColor;
    NSString *headerText = [[SharedData sharedInstance] headerForScreen: self.lookupString];
    cell.textLabel.text = [SharedData unitiseString: headerText];

    [self pimpMyCellHeader: cell];
    return cell;
}

-(void) configureCell: (UITableViewCell *) cell{
    UIFont *myFont = [UIFont systemFontOfSize: self.myTableDets.floatMainFontSize];
    cell.textLabel.font = myFont;
    cell.textLabel.textColor = self.myTableDets.mainFontColor;
    cell.backgroundColor = self.myTableDets.cellColor;
    cell.detailTextLabel.text = nil;
    if (self.myTableDets.twoTexts){
        UIFont *myFont = [UIFont systemFontOfSize: self.myTableDets.floatSubFontSize];
        cell.detailTextLabel.font = myFont;
        cell.detailTextLabel.textColor = self.myTableDets.subFontColor;
    }
}


@end
