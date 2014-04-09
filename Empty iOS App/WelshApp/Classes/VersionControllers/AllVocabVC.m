//
//  AllVocabVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 03/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "AllVocabVC.h"
#import "SharedData.h"
#import "PlaySound.h"


@interface AllVocabVC () {
    PlaySound *myPlaySound;
    NSArray *chosenVocab;

}

@property (weak, nonatomic) IBOutlet UIButton *sortButton;

- (IBAction)toggleSort:(id)sender;

@end

@implementation AllVocabVC

-(void) updateDisplay{
    self.tableArray = chosenVocab;
    self.lookupString = @"GlobalVocab"; //To look up table format
}

- (void)viewDidLoad
{
    chosenVocab = [[SharedData sharedInstance] getAllVocabItemsbyEnglish: YES];
    [self updateDisplay];
    [super viewDidLoad];
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell" forIndexPath:indexPath];

        [self configureCell: cell];

        VocabItem *myItem = chosenVocab[indexPath.row];
 
        if ([self.sortButton.titleLabel.text isEqualToString: @"English"]){
           cell.textLabel.text = myItem.englishText;
           cell.detailTextLabel.text = myItem.welshText;
        } else {
            cell.textLabel.text = myItem.welshText;
            cell.detailTextLabel.text = myItem.englishText;
        }
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

- (IBAction)toggleSort:(id)sender {
 
    if ([self.sortButton.titleLabel.text isEqualToString: @"Welsh"]){
       [self.sortButton setTitle: @"English" forState: UIControlStateNormal ];
       chosenVocab = [[SharedData sharedInstance] getAllVocabItemsbyEnglish: NO];
    } else {
        [self.sortButton setTitle: @"Welsh" forState: UIControlStateNormal ];
        chosenVocab = [[SharedData sharedInstance] getAllVocabItemsbyEnglish: YES];
    }
    [self updateDisplay];
    [self.tableView reloadData];

}

@end
