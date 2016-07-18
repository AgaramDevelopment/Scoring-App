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
#import "TorunamentVC.h"
#import "InningsDetailsVC.h"

@interface ArchivesVC ()<SwipeableCellDelegate,InningsDetailsDelegate>
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

NSArray *MuliteDayMatchtype;

- (void)viewDidLoad {
    [super viewDidLoad];
    MuliteDayMatchtype =[[NSArray alloc]initWithObjects:@"MSC023",@"MSC114", nil];

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
    cell.Btn_Resume.tag=indexPath.row;
    cell.Btn_Edit.tag = indexPath.row;
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
        
        if(![objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqual:@""]){
    cell.innings2teamname2.text=objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME;
    cell.innings2team2runs.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.SECONDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
    cell.innings2team2overs.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.SECONDINNINGSOVERS];
        }else{
            cell.innings2teamname2.text=@"";
            cell.innings2team2runs.text=@"";
            cell.innings2team2overs.text=@"";
            
        }
       
        if([MuliteDayMatchtype containsObject:objFixtureRecord.matchTypeCode]){
        cell.innings1teamname2.text=objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME;
        cell.innings1team2runs.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.THIRDINNINGSTOTAL,objfetchSEPageLoadRecord.SECONDINNINGSWICKET];
        cell.innings1team2overs.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.THIRDINNINGSOVERS];
    
        cell.innings2teamname1.text=objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME;
        cell.innings2team1runs.text=[NSString stringWithFormat:@"%@/%@",objfetchSEPageLoadRecord.FOURTHINNINGSTOTAL,objfetchSEPageLoadRecord.FOURTHINNINGSWICKET];
        cell.innings2team1overs.text=[NSString stringWithFormat:@"%@ OVS",objfetchSEPageLoadRecord.FOURTHINNINGSOVERS];
        }
        
//        
//        
//        
//        _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.SECONDINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSTOTAL,fetchSEPageLoadRecord.SECONDINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSWICKET];
//        _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.SECONDINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSOVERS];
//        
//        
//        
//        _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",fetchSEPageLoadRecord.FIRSTINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSTOTAL,fetchSEPageLoadRecord.FIRSTINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSWICKET];
//        _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FIRSTINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSOVERS];
//        
//        if([MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE]){
//            _lbl_teamASecIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.THIRDINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.THIRDINNINGSTOTAL,fetchSEPageLoadRecord.THIRDINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.THIRDINNINGSWICKET];
//            _lbl_teamASecIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.THIRDINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.THIRDINNINGSOVERS];
//            
//            _lbl_teamBSecIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.FOURTHINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.FOURTHINNINGSTOTAL,fetchSEPageLoadRecord.FOURTHINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.FOURTHINNINGSWICKET];
//            _lbl_teamBSecIngsOvs.text =[NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FOURTHINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.FOURTHINNINGSOVERS];
//        }
        
        
        
        
        
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
- (void)RightSideEditBtnAction:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;

    FixturesRecord *objFixtureRecord=(FixturesRecord*)[FetchCompitionArray objectAtIndex:button.tag];

    EditModeVC * objEditModeVC=[[EditModeVC alloc]init];
    objEditModeVC=(EditModeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"EditModeVC"];
    objEditModeVC.Comptitioncode =self.CompitionCode;
    objEditModeVC.matchCode = objFixtureRecord.matchcode;
    objEditModeVC.matchTypeCode=matchTypeCode;
    
    [self.navigationController pushViewController:objEditModeVC animated:YES];
}

- (void)RightsideResumeBtnAction:(UIButton *)sender
{
  
   
    UIButton *button = (UIButton *)sender;
    
    
    NSLog(@"the butto, on cell number... %d", button.tag);
    
    FixturesRecord *objFixtureRecord=(FixturesRecord*)[FetchCompitionArray objectAtIndex:button.tag];
    NSMutableArray *mSetUp = [[NSMutableArray alloc]init];
    [mSetUp addObject:objFixtureRecord];
    
    if([objFixtureRecord.MatchStatus isEqualToString:@"MSC124"]||[objFixtureRecord.MatchStatus isEqualToString:@"MSC240"])
    {
        if([objFixtureRecord.InningsStatus isEqualToString:@"1"])
        {
            InningsDetailsVC *_InningsDetailsVC = [[InningsDetailsVC alloc]initWithNibName:@"InningsDetailsVC" bundle:nil];
            _InningsDetailsVC.delegate = self;
            _InningsDetailsVC.matchSetUp = mSetUp;
            _InningsDetailsVC.MATCHCODE=objFixtureRecord.matchcode;
            _InningsDetailsVC.competitionCode=self.CompitionCode;
            _InningsDetailsVC.matchTypeCode=matchTypeCode;
            [self.navigationController pushViewController:_InningsDetailsVC animated:YES];
        }
        else
        {
            ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
            scoreEngine =(ScorEnginVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
            scoreEngine.matchSetUp = mSetUp;
            scoreEngine.matchCode=objFixtureRecord.matchcode;
            scoreEngine.competitionCode=self.CompitionCode;
            scoreEngine.matchTypeCode=matchTypeCode;
            [self.navigationController pushViewController:scoreEngine animated:YES];
        }
    }else if([objFixtureRecord.MatchStatus isEqualToString:@"MSC125"]){
        ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
        scoreEngine =(ScorEnginVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
        scoreEngine.matchSetUp = mSetUp;
        scoreEngine.matchCode=objFixtureRecord.matchcode;
        scoreEngine.competitionCode=self.CompitionCode;
        scoreEngine.matchTypeCode=matchTypeCode;
        [self.navigationController pushViewController:scoreEngine animated:YES];
    }
}


//4

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
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ScoreEnginExit"]) {
        NSLog(@"yes");
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ScoreEnginExit"];
        TorunamentVC*tournmentVc = [[TorunamentVC alloc]init];
        
        tournmentVc =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
        //tournmentVc.selectDashBoard=selectType;
        [self.navigationController pushViewController:tournmentVc animated:YES];
        
    } else {
        NSLog(@"no");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)StartInningsprocessSuccessful : (NSString *)CompetitionCode : (NSString *)MATCHCODE : (NSString *)matchTypeCode : (NSMutableArray *)matchSetUp
{
    ScorEnginVC *scoreengine = [[ScorEnginVC alloc] init];
    
    scoreengine =  (ScorEnginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
    scoreengine.matchSetUp = matchSetUp;
    scoreengine.matchCode = MATCHCODE;
    scoreengine.competitionCode = CompetitionCode;
    scoreengine.matchTypeCode = matchTypeCode;
    
    [self.navigationController pushViewController:scoreengine animated:YES];
}


@end
