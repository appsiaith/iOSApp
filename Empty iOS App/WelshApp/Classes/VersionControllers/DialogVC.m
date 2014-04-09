//
//  DialogVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 03/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "DialogVC.h"
#import "SharedData.h"
#import "PlaySound.h"

@interface DialogVC () {
   PlaySound *myPlaySound;
}

@end

@implementation DialogVC


- (void)viewDidLoad
{
    self.tableArray = self.dialogItems;
    self.lookupString = @"DialogBody";
    
    [super viewDidLoad];
    
    myPlaySound = [[PlaySound alloc] init];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


// !!!!! Several items below do not fit the standard table initialization
// !!!!! Some thought is needed...

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) { // init the picture at the top of the list
        cell = [self configureHeaderForIndexPath: indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell" forIndexPath:indexPath];

        [self configureCell: cell];

        cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", self.dialogItems[indexPath.row][0], self.dialogItems[indexPath.row][1] ];
        
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *audioFile = self.dialogItems[indexPath.row][2];
    [myPlaySound playSound: audioFile];

}

@end
