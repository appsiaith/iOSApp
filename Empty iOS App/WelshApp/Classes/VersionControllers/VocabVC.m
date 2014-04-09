//
//  VocabVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 02/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "VocabVC.h"
#import "SharedData.h"
#import "PlaySound.h"

@interface VocabVC () {
    NSArray *chosenVocab;
    PlaySound *myPlaySound;
}

//@property (weak, nonatomic) IBOutlet UILabel *welshLabel;
//@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
//@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//@property (weak, nonatomic) IBOutlet PlayPauseView *playerView;


@end

@implementation VocabVC


- (void)viewDidLoad
{
    chosenVocab = [[SharedData sharedInstance] getVocabItemsForCurrentUnit];
    self.tableArray = chosenVocab;
    self.lookupString = @"UnitVocab"; //To look up table format

    [super viewDidLoad];
    // Get the config data from the database
    myPlaySound = [[PlaySound alloc] init];
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"VocabCell" forIndexPath:indexPath];

        [self configureCell: cell];

        VocabItem *myItem = chosenVocab[indexPath.row];

        cell.textLabel.text = myItem.welshText;
        cell.detailTextLabel.text = myItem.englishText;
        if ([[myItem audioName] isEqualToString: @""]) {
            cell.imageView.image = [UIImage imageNamed:@"notplay.png"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"play.png"];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VocabItem *myItem = chosenVocab[indexPath.row];
    if (![[myItem audioName] isEqualToString: @""]) {
        [myPlaySound playSound: [myItem audioName]];
    }
    
}

@end
