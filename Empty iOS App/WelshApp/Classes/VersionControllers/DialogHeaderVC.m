 //
//  DialogHeaderVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 03/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "DialogHeaderVC.h"
#import "SharedData.h"
#import "MonologVC.h"
#import "DialogVC.h"


@interface DialogHeaderVC () {
    NSArray *dialogHeaderList;
}

@end

@implementation DialogHeaderVC


- (void)viewDidLoad
{
    dialogHeaderList = [[SharedData sharedInstance] getDialogTitlesForCurrentUnit];
    self.tableArray = dialogHeaderList;
    self.lookupString = @"DialogHeader"; //To look up table format

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
        NSNumber *theGroupId = [dialogHeaderList[indexPath.row] groupId];
        NSString *dialogType = [[SharedData sharedInstance] getDialogTypeForGroupId: theGroupId.intValue];
        if ([dialogType isEqualToString: @"monologue"]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"MonologCell" forIndexPath:indexPath];
       } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DialogCell" forIndexPath:indexPath];
       }

        [self configureCell: cell];

        cell.textLabel.text = [dialogHeaderList[indexPath.row] english];
        cell.detailTextLabel.text = [dialogHeaderList[indexPath.row] welsh];
    }
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSNumber *theGroupId = [dialogHeaderList[indexPath.row] groupId];
    int extraIndex = theGroupId.intValue;
    if ([[segue identifier] isEqualToString: @"Monolog"]) {
        MonologVC *myVC = [segue destinationViewController];
        myVC.contentPair = [[SharedData sharedInstance] getMonologContentForExtraItem: extraIndex];
    } else {
        DialogVC *myVC = [segue destinationViewController];
        myVC.dialogItems = [[SharedData sharedInstance] getDialogContentForExtraItem: extraIndex];

    }
  
}



@end
