//
//  AboutListVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 13/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "AboutListVC.h"
#import "InfoVC.h"
#import "SharedData.h"

@interface AboutListVC () {
    NSArray *webItems;
}


@end

@implementation AboutListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    webItems = [[SharedData sharedInstance] furtherInfoList];
    self.tableArray = webItems;
    self.lookupString = @"About"; //To look up table format

    [super viewDidLoad];


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) { // Configure the header at the top of the list
        cell = [self configureHeaderForIndexPath: indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell" forIndexPath:indexPath];
        
        [self configureCell: cell];
        cell.textLabel.text = webItems[indexPath.row][0];
        cell.detailTextLabel.text = webItems[indexPath.row][1];
    }
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  set up the right web page
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    InfoVC *myVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    myVC.webFilename = webItems[indexPath.row][3];
    myVC.title = webItems[indexPath.row][0];
    myVC.linkType = webItems[indexPath.row][2];
}

@end
