//
//  UnitSettingsVC.m
//  CymraegTeulu
//
//  Created by Chris Price on 02/01/2014.
//  Copyright (c) 2014 Chris Price. All rights reserved.
//

#import "UnitSettingsVC.h"
#import "SharedData.h"

@interface UnitSettingsVC () <UITableViewDelegate, UITableViewDataSource> {
    // holds the temporarily selected unit in the table.
    NSInteger selectedUnit;
}

@property (retain, nonatomic) IBOutlet UITableView *unitTable;
@property (retain, nonatomic) NSArray *units;

@property (retain, nonatomic) IBOutlet UISegmentedControl *northSouthControl;
@property (retain, nonatomic) IBOutlet UILabel *introText;
- (IBAction) northSouthChange: (id) sender;

@end

@implementation UnitSettingsVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.units = [[SharedData sharedInstance] allUnits];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
 //   NSIndexPath *path = [NSIndexPath indexPathForRow: (selectedUnit - 1) inSection: 0];
 //   [self.unitTable scrollToRowAtIndexPath: path atScrollPosition: UITableViewScrollPositionMiddle animated: NO];
    self.introText.text = [SharedData unitiseString: @"You are currently on Unit U1. You can select another unit to study below."];
    if ([[SharedData sharedInstance] isNorth]) {self.northSouthControl.selectedSegmentIndex = 0;}
    else {self.northSouthControl.selectedSegmentIndex = 1;}
    selectedUnit = [SharedData currentUnitNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedUnit = indexPath.row + 1;
    [[SharedData sharedInstance] setCurrentUnitNumber: selectedUnit];
    [[SharedData sharedInstance] save]; 
    self.introText.text = [SharedData unitiseString: @"You are currently on Unit U1. You can select another unit to study below."];
    [tableView reloadData];
}

#pragma mark - Table Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.units count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell" forIndexPath:indexPath];
    
    if((indexPath.row + 1) == selectedUnit) { // then this is the chosen unit at present
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath: indexPath animated: YES scrollPosition: UITableViewScrollPositionMiddle];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
    }
    
    NSString *myWelsh;
    if ([[SharedData sharedInstance] isNorth]){
        myWelsh = [self.units[indexPath.row] north];
    } else {
        myWelsh = [self.units[indexPath.row] south];
    }
    
//    cell.textLabel.text = [self.units[indexPath.row] english];
    cell.textLabel.text =  [NSString stringWithFormat: @"Unit %i", (int)indexPath.row+1];

//    cell.detailTextLabel.text = myWelsh;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@\n%@  ", [self.units[indexPath.row] english], myWelsh];
    return cell;
}

/*- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *myWelsh;
    if ([[SharedData sharedInstance] isNorth]){
        myWelsh = [[self.units objectAtIndex: indexPath.row] north];
    } else {
        myWelsh = [[self.units objectAtIndex: indexPath.row] south];
    }
    
    return [UnitSettingsCell heightForCellForEnglish: [[units objectAtIndex: indexPath.row] english] welsh: myWelsh];
} */



#pragma mark - Segment Control

- (IBAction) northSouthChange: (id) sender {
    
    if( [((UISegmentedControl *)sender) selectedSegmentIndex] == 0 ) {
        [[SharedData sharedInstance] setNorthSouth: ProjectSettingsLanguageNorth];
    }
    else {
        [[SharedData sharedInstance] setNorthSouth: ProjectSettingsLanguageSouth];
    }
    [[SharedData sharedInstance] save];  // cjp 30/11/11
    [[self unitTable] reloadData];
    
}



@end
