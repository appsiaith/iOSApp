//
//  PatternListVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 01/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "PatternListVC.h"
#import "SharedData.h"
#import "GroupHeader.h"
#import "PatternVC.h"


@interface PatternListVC () {
    NSArray *patternHeaders;
}


@end

@implementation PatternListVC


- (void)viewDidLoad
{
    patternHeaders = [[SharedData sharedInstance] getPatternTitlesForCurrentUnit]; // returns GroupHeaders
    self.tableArray = patternHeaders;
    self.lookupString = @"PatternHeader"; //To look up table format

    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) { // init the picture at the top of the list
        cell = [self configureHeaderForIndexPath: indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell" forIndexPath:indexPath];
        
        [self configureCell: cell];
        
        GroupHeader *item = patternHeaders[indexPath.row];
        cell.textLabel.text = [item english];
        cell.detailTextLabel.text = [item welsh];
    }
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([[segue identifier] isEqualToString:@"Pattern"]) {
        PatternVC *myVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Get the phrases for the right group
        int groupNum = [[patternHeaders[indexPath.row] groupId] intValue];
        myVC.chosenPhrases = [[SharedData sharedInstance]  getPatternBodiesForPatternGroup: groupNum];
 
    }
}




@end
