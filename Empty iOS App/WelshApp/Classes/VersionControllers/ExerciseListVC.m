//
//  ExerciseListVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 04/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "ExerciseListVC.h"
#import "SharedData.h"
#import "GroupHeader.h"
#import "ExerciseVC.h"

@interface ExerciseListVC () {
   NSArray *exerciseList;
}

@end

@implementation ExerciseListVC


- (void)viewDidLoad
{
    // exerciseList is an array of GroupHeaders
    exerciseList = [[SharedData sharedInstance] getExerciseTitlesForCurrentUnit];
    self.tableArray = exerciseList;
    self.lookupString = @"QuestionHeader"; //To look up table format

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
        
        GroupHeader *item = exerciseList[indexPath.row];
        cell.textLabel.text = [item english];
        cell.detailTextLabel.text = [item welsh];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ExerciseVC *myVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    //Get the questions for the correct item within the lesson
    GroupHeader *item = exerciseList[indexPath.row];
    myVC.exerciseNum = [[item groupId] intValue];
    myVC.exerciseInstruction = [item english];
    
}

@end
