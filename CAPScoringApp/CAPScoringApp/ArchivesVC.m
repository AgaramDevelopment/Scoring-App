//
//  Archives.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 10/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ArchivesVC.h"
#import "CustomNavigationVC.h"
#import "DBManager.h"
#import "Archive.h"
#import "FixturesRecord.h"

@interface ArchivesVC ()<SwipeableCellDelegate>
{
    CustomNavigationVC * objCustomNavigation;
}
@property(nonatomic,strong) NSMutableArray* FetchCompitionArray;
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@end

@implementation ArchivesVC
@synthesize tbl_archive,FetchCompitionArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    FetchCompitionArray=[[NSMutableArray alloc]init];
    self.cellsCurrentlyEditing = [NSMutableArray array];
    FetchCompitionArray =[DBManager RetrieveFixturesData:self.CompitionCode];
    [self customnavigationmethod];
}
-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"ARCHIVES";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [FetchCompitionArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"ArchiveCell";
    

    Archive *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
//    if (cell == nil)
//    {
//        //cell = [[Archive alloc] initWithStyle:UITableViewCellStyleDefault
//                                      // reuseIdentifier:MyIdentifier];
//       // NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"Archive" owner:nil options:nil];
//        cell = (Archive*)[[[NSBundle mainBundle] loadNibNamed:@"Archive" owner:nil options:nil] objectAtIndex:0];
//       // cell = [views objectAtIndex:0];
//       
//        
//    }
    //NSString *item = self.FetchCompitionArray[indexPath.row];
    //cell.itemText = item;
    cell.delegate = self;
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    

    FixturesRecord *objFixtureRecord=(FixturesRecord*)[FetchCompitionArray objectAtIndex:indexPath.row];
    
    NSString * teamAname=objFixtureRecord.teamAname;
    NSString * teamBname =objFixtureRecord.teamBname;
    cell.lbl_teamname.text=[NSString stringWithFormat:@"%@  VS  %@",teamAname,teamBname];
    cell.lbl_groundName.text=objFixtureRecord.groundname;
    cell.lbl_cityname.text=objFixtureRecord.city;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:objFixtureRecord.matchdate];
    [formatter setDateFormat:@"dd"];
    NSString *newDate = [formatter stringFromDate:date];
    cell.lbl_date.text=newDate;

    [formatter setDateFormat:@"MMM ''yy"];
    newDate = [formatter stringFromDate:date];
    cell.lbl_displaydate.text=newDate;
    [cell.Btn_swipebutton addTarget:self action:@selector(swiftRightsideBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
      return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1
        [FetchCompitionArray removeObjectAtIndex:indexPath.row];
        
        //2
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        //3
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

-(IBAction)swiftRightsideBtnAction:(id)sender
{
    [self.cellsCurrentlyEditing removeObject:[self.tbl_archive indexPathForCell:sender]];
}

#pragma mark - SwipeableCellDelegate
- (void)buttonOneActionForItemText:(NSString *)itemText
{
   // [self showDetailWithText:[NSString stringWithFormat:@"Clicked button one for %@", itemText]];
}

- (void)buttonTwoActionForItemText:(NSString *)itemText
{
   // [self showDetailWithText:[NSString stringWithFormat:@"Clicked button two for %@", itemText]];
}


//4
- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cellDidOpen:(UITableViewCell *)cell
{
    NSIndexPath *currentEditingIndexPath = [self.tbl_archive indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:[self.tbl_archive indexPathForCell:cell]];
}

-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
