//
//  MainMenuVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 03/12/2013.
//  Copyright (c) 2013 Chris Price. All rights reserved.
//

#import "MainMenuVC.h"
#import "SharedData.h"
#import "InfoVC.h"

@interface MainMenuVC () 

@end

@implementation MainMenuVC

NSArray *mainMenuItems;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.clearsSelectionOnViewWillAppear = NO;
//        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    // Do these things BEFORE super, as [super viewDidLoad uses tableArray and lookupString
    mainMenuItems = [[SharedData sharedInstance] itemsInMainMenu];

    self.tableArray = mainMenuItems;
    self.lookupString = @"MainMenu"; //To look up table format
    [super viewDidLoad];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) { // Configure the header at the top of the list
        cell = [self configureHeaderForIndexPath: indexPath];
    } else {
        if (indexPath.row == 4){
            cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell" forIndexPath:indexPath];
        } else if (indexPath.row == 3){
            cell = [tableView dequeueReusableCellWithIdentifier:@"GrammarCell" forIndexPath:indexPath];
        } else if (indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"DictionaryCell" forIndexPath:indexPath];
        } else if (indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"RevisionCell" forIndexPath:indexPath];
        } else {
           cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell" forIndexPath:indexPath];
        }
        
        [self configureCell: cell];
        cell.textLabel.text = [SharedData unitiseString: mainMenuItems[indexPath.row][0]];
        cell.detailTextLabel.text = [SharedData unitiseString: mainMenuItems[indexPath.row][1]];
    }
   return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"info"]) {
        InfoVC *myVC = [segue destinationViewController];
        
        myVC.webFilename = @"info";
        myVC.linkType = @"local";
        myVC.title = @"About this app";
    } else {
    }
}


@end
