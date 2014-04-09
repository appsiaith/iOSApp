//
//  UnitGrammarList.m
//  CymraegTeulu
//
//  Created by Chris Price on 02/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "UnitGrammarListVC.h"
#import "SharedData.h"
#import "GrammarItemVC.h"

@interface UnitGrammarListVC () {
    NSArray *grammarHeaderList;
}

@end

@implementation UnitGrammarListVC


- (void)viewDidLoad
{
    grammarHeaderList = [[SharedData sharedInstance] getGrammarTitlesForCurrentUnit]; //gets group headers
    self.tableArray = grammarHeaderList;
    self.lookupString = @"UnitGrammar"; //To look up table format

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
        
        cell.textLabel.text = [grammarHeaderList[indexPath.row] english];
        cell.detailTextLabel.text = @"";
    }
   return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    GrammarItemVC *myVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    //Get the grammar html for the correct item within the lesson
    NSNumber *theGroupId = [grammarHeaderList[indexPath.row] groupId];
    myVC.grammarContent = [[SharedData sharedInstance] getGrammarContentForHeader: theGroupId.intValue];

}



@end
