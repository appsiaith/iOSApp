//
//  UnitChoiceVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 31/12/2013.
//  Copyright (c) 2013 Chris Price. All rights reserved.
//

#import "UnitChoiceVC.h"
#import "SharedData.h"

@interface UnitChoiceVC () {
    int presentUnitNumber;
    NSArray *choiceItems; // The types of learning are available for this unit - e.g. Patterns, Vocab,
    NSDictionary *unitSectionTitles;
}

@property (retain, nonatomic) NSArray *units;

@end

@implementation UnitChoiceVC

/**
 * Show the title in the header of the navigation bar.
 */
- (void) updateDisplay {
    presentUnitNumber = (int)[SharedData currentUnitNumber];

    choiceItems = [[SharedData sharedInstance] lessonTypesInCurrentUnit];
    self.tableArray = choiceItems; // Needed to make sure super is up to date
    [self loadBackgroundImageAndTitle];
    [[self tableView] reloadData];
}


- (void)viewDidLoad
{
    choiceItems = [[SharedData sharedInstance] lessonTypesInCurrentUnit];
    self.tableArray = choiceItems;
    self.lookupString = @"UnitChoice"; //To look up table format

    [super viewDidLoad];
    
    presentUnitNumber = (int)[SharedData currentUnitNumber];

    unitSectionTitles = [[SharedData sharedInstance] itemsInUnitSectionMenu];
    self.units = [[SharedData sharedInstance] allUnits];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void) pimpMyCellHeader: (UITableViewCell *) cell {
    // This method can be used by specific FormattedTables to do substitutions in the headerText label
    // UnitChoice allows you to use Ex and Wx to put the english and welsh lesson titles into the title
    NSString *myEnglish = [self.units[presentUnitNumber-1] english];
    NSString *myWelsh;
    if ([[SharedData sharedInstance] isNorth]){
        myWelsh = [self.units[presentUnitNumber-1] north];
    } else {
        myWelsh = [self.units[presentUnitNumber-1] south];
    }
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString: @"Ex" withString: myEnglish];
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString: @"Wx" withString: myWelsh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) { // init the picture at the top of the list
        cell = [self configureHeaderForIndexPath: indexPath];
        
 //       cell.textLabel.text = [SharedData unitiseString: @"Unit U1"];
    } else {
        NSString *title = choiceItems[indexPath.row];
        NSString *cellName = [NSString stringWithFormat: @"%@Cell", title];
        cell = [tableView dequeueReusableCellWithIdentifier: cellName forIndexPath:indexPath];

        [self configureCell: cell];
        
        NSArray *textItems = [unitSectionTitles objectForKey: title];
        cell.textLabel.text = [SharedData unitiseString: textItems[0]];
        cell.detailTextLabel.text = [SharedData unitiseString: textItems[1]];
    }
    return cell;
}


@end
