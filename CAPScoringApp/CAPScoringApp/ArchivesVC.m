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
#import "FetchSEPageLoadRecord.h"
#import "EditModeVC.h"
#import "ScorEnginVC.h"

@interface ArchivesVC ()<SwipeableCellDelegate>
{
    CustomNavigationVC * objCustomNavigation;
    NSString * matchCode;
    NSString * matchTypeCode;
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
    FetchCompitionArray =[DBManager ArchivesFixturesData:self.CompitionCode];
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
    
    return [FetchCompitionArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"ArchiveCell";
    
    
    Archive *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell.delegate = self;
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    
    
    FixturesRecord *objFixtureRecord=(FixturesRecord*)[FetchCompitionArray objectAtIndex:indexPath.row];
    NSLog(@"Matchcode=%@",objFixtureRecord.matchcode);
    NSLog(@"Compitioncode=%@",objFixtureRecord.competitioncode);
    
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
    matchCode=objFixtureRecord.matchcode;
    matchTypeCode =objFixtureRecord.matchTypeCode;
    
    [formatter setDateFormat:@"MMM ''yy"];
    newDate = [formatter stringFromDate:date];
    cell.lbl_displaydate.text=newDate;
    NSMutableArray* objInniningsarray=[DBManager FETCHSEALLINNINGSSCOREDETAILS:objFixtureRecord.competitioncode MATCHCODE:objFixtureRecord.matchcode];
    
    if(objInniningsarray.count>0){
    FetchSEPageLoadRecord *objfetchSEPageLoadRecord=(FetchSEPageLoadRecord*)[objInniningsarray objectAtIndex:0];
    cell.innings1teamname1.text=objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME;
    cell.innings1team1runs.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FIRSTINNINGSTOTAL,objfetchSEPageLoadRecord.FIRSTINNINGSWICKET];
    cell.innings1team1overs.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FIRSTINNINGSOVERS];
    cell.innings2teamname2.text=objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME;
    cell.innings2team2runs.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.SECONDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
    cell.innings2team2overs.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.SECONDINNINGSOVERS];
    
    }
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
- (void)RightSideEditBtnAction
{
    EditModeVC * objEditModeVC=[[EditModeVC alloc]init];
    objEditModeVC=(EditModeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"EditModeVC"];
    objEditModeVC.Comptitioncode =self.CompitionCode;
    objEditModeVC.matchCode = matchCode;
    objEditModeVC.matchTypeCode=matchTypeCode;
    [self.navigationController pushViewController:objEditModeVC animated:YES];
}

- (void)RightsideResumeBtnAction
{
    // [self showDetailWithText:[NSString stringWithFormat:@"Clicked button two for %@", itemText]];
//    EditModeVC *buttonCell = (EditModeCell *)[senderButton superview];
//    
//    NSIndexPath* pathOfTheCell = [self.tbl_archive indexPathForCell:buttonCell];
//    FixturesRecord *objFixtureRecord=(FixturesRecord*)[FetchCompitionArray objectAtIndex:pathOfTheCell.row];
//    
//    NSMutableArray *mSetUp = [[NSMutableArray alloc]init];
//    [mSetUp addObject:objFixtureRecord];

    ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
    
    scoreEngine =(ScorEnginVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
    //scoreEngine.matchSetUp = mSetUp;
    scoreEngine.matchCode=matchCode;
    scoreEngine.competitionCode=self.CompitionCode;
    [self.navigationController pushViewController:scoreEngine animated:YES];
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
