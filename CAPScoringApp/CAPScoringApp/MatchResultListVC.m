//
//  MatchResultListVC.m
//  CAPScoringApp
//
//  Created by APPLE on 22/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "MatchResultListVC.h"
#import "FetchMatchResult.h"
#import "GetMatchResultTypeAndCodeDetails.h"
#import "GetTeamANameDetails.h"
#import "SelectPlayerRecord.h"


@interface MatchResultListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

int selectedTablePostition ;

int POS_RESULT_TYPE = 1;
int POS_TEAM = 2;
int POS_MAN_OF_THE_MATCH = 3;
int POS_MAN_OF_THE_SERIES = 4;
int POS_BEST_BATSMAN = 5;
int POS_BEST_BOWLER = 6;
int POS_BEST_ALL_ROUNDER = 7;
int POS_MOST_VALUABLE_PLAYER = 8;


//BOOL isTableOpen;

UITableView *popTableView;
FetchMatchResult *fetchMatchResult;
NSMutableArray *teamDetails;

@implementation MatchResultListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    self.scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, 850);
    
    _scroll_view.scrollEnabled = YES;
    selectedTablePostition = 0;
//    isTableOpen = NO;
    
    fetchMatchResult = [[FetchMatchResult alloc]init];
    [fetchMatchResult getMatchReultsDetails:self.competitionCode :self.matchCode :self.TEAMACODE :self.INNINGSNO];
    
     teamDetails=[[NSMutableArray alloc]init];

    if(fetchMatchResult.GetTeamANameDetail.count>0){
        [teamDetails addObject:[fetchMatchResult.GetTeamANameDetail objectAtIndex:0 ]];
    }
    
    
    if(fetchMatchResult.GetTeamBNameDetail.count>0){
        [teamDetails addObject:[fetchMatchResult.GetTeamBNameDetail objectAtIndex:0 ]];
    }
    
    [self.txtf_comments.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txtf_comments.layer.borderWidth=2;
    
    [self.view_team_layer.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_team_layer.layer.borderWidth=2;
    
    
    [self.view_result_type.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_result_type.layer.borderWidth=2;
    
    
    
    [self.view_man_of_the_match.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_man_of_the_match.layer.borderWidth=2;
    
    
    [self.view_man_of_the_series.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_man_of_the_series.layer.borderWidth=2;
    
    
    [self.view_best_batsman.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_best_batsman.layer.borderWidth=2;
    
    [self.view_best_bowler.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_best_bowler.layer.borderWidth=2;

    
    [self.view_best_allrounder.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_best_allrounder.layer.borderWidth=2;

    
    [self.view_most_wicket.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_most_wicket.layer.borderWidth=2;
    
    [self.txtf_team_a_point.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txtf_team_a_point.layer.borderWidth=2;

    [self.txtf_team_b_point.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.txtf_team_b_point.layer.borderWidth=2;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    
    if(selectedTablePostition == POS_RESULT_TYPE){
        return [fetchMatchResult.GetMatchResultTypeAndCode count];
    }else if(selectedTablePostition == POS_TEAM){
        return [teamDetails count];
    }else if(selectedTablePostition == POS_MAN_OF_THE_MATCH){
        return [fetchMatchResult.GetManOfTheMatchDetail count];
    }else if(selectedTablePostition == POS_MAN_OF_THE_SERIES){
        return [fetchMatchResult.GetManOfTheSeriesDetails count];

    }else if(selectedTablePostition == POS_BEST_BATSMAN){
        return [fetchMatchResult.GetBestBatsManDetails count];
        
    }else if(selectedTablePostition == POS_BEST_BOWLER){
        return [fetchMatchResult.GetBestBowlerDetails count];
        
    }else if(selectedTablePostition == POS_BEST_ALL_ROUNDER){
        return [fetchMatchResult.GetManOfTheMatchDetail count];
        
    }else if(selectedTablePostition == POS_MOST_VALUABLE_PLAYER){
        return [fetchMatchResult.GetManOfTheMatchDetail count];
        
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        
    }
    if(selectedTablePostition == POS_RESULT_TYPE){
        
        GetMatchResultTypeAndCodeDetails *data = [fetchMatchResult.GetMatchResultTypeAndCode objectAtIndex:indexPath.row];
        cell.textLabel.text = data.RESULTTYPE;
        
    }else if(selectedTablePostition == POS_TEAM){
        GetTeamANameDetails *data = [teamDetails objectAtIndex:indexPath.row];
        cell.textLabel.text = data.TEAMNAME;
        
    }else if(selectedTablePostition == POS_MAN_OF_THE_MATCH){
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheMatchDetail objectAtIndex:indexPath.row];
        cell.textLabel.text = data.playerName;
        
    }else if(selectedTablePostition == POS_MAN_OF_THE_SERIES){
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
        cell.textLabel.text = data.playerName;
        
    }
    
else if(selectedTablePostition == POS_BEST_BATSMAN){
    SelectPlayerRecord *data = [fetchMatchResult.GetBestBatsManDetails objectAtIndex:indexPath.row];
    cell.textLabel.text = data.playerName;
    
}else if(selectedTablePostition == POS_BEST_BOWLER){
    SelectPlayerRecord *data = [fetchMatchResult.GetBestBowlerDetails objectAtIndex:indexPath.row];
    cell.textLabel.text = data.playerName;
}else if(selectedTablePostition == POS_BEST_ALL_ROUNDER){
    SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
    cell.textLabel.text = data.playerName;
    
}else if(selectedTablePostition == POS_MOST_VALUABLE_PLAYER){
    SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
    cell.textLabel.text = data.playerName;
    
}

    cell.textLabel.textColor=[UIColor blackColor];


    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(selectedTablePostition == POS_RESULT_TYPE){
        //isTableOpen = NO;
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;


        GetMatchResultTypeAndCodeDetails *data = [fetchMatchResult.GetMatchResultTypeAndCode objectAtIndex:indexPath.row];
        _lbl_result_type.text = data.RESULTTYPE;

    
        
    }else if(selectedTablePostition == POS_TEAM){
        
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;

        
        GetTeamANameDetails *data = [teamDetails objectAtIndex:indexPath.row];
        _lbl_team.text = data.TEAMNAME;
        
    }else if(selectedTablePostition == POS_MAN_OF_THE_MATCH){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;

        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheMatchDetail objectAtIndex:indexPath.row];
        _lbl_man_of_the_match.text = data.playerName;
        
    }else if(selectedTablePostition == POS_MAN_OF_THE_SERIES){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;

        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
        _lbl_man_of_the_series.text = data.playerName;
        
    }else if(selectedTablePostition == POS_BEST_BATSMAN){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetBestBatsManDetails objectAtIndex:indexPath.row];
        _lbl_select_best_batsman.text = data.playerName;
        
    }else if(selectedTablePostition == POS_BEST_BOWLER){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetBestBowlerDetails objectAtIndex:indexPath.row];
        _lbl_select_best_bowler.text = data.playerName;
    }else if(selectedTablePostition == POS_BEST_ALL_ROUNDER){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
        _lbl_select_allrounder.text = data.playerName;
        
    }else if(selectedTablePostition == POS_MOST_VALUABLE_PLAYER){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
        _lbl_select_most_valu_player.text = data.playerName;
        
    }

}




//Shows popup for table view
-(void) openResultTypeTableView
{
    
        //Table view
        popTableView=[[UITableView alloc]initWithFrame:CGRectMake(280, 140,300,200)];
     popTableView.scrollEnabled = YES;
    popTableView.userInteractionEnabled = YES;
        popTableView.backgroundColor = [UIColor whiteColor];
        popTableView.dataSource = self;
        popTableView.delegate = self;
        [self.rootView addSubview:popTableView];
        [popTableView reloadData];
    _scroll_view.scrollEnabled = NO;
    
    
 //
//        if(self.ballEventRecord.objOverthrow!=0){
//            NSInteger position = [self.overThrowOptionArray indexOfObject:self.ballEventRecord.objOverthrow];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
//            [resultTypeTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            
//            [resultTypeTableView scrollToRowAtIndexPath:indexPath
//                                      atScrollPosition:UITableViewScrollPositionTop
//                                              animated:YES];
//        }
    
        //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //  [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //         indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //
        
        //isOverthrowSelected = YES;
    
    
}


-(void) openPopTableView: (CGFloat) yValue
{
    
    //Table view
    popTableView=[[UITableView alloc]initWithFrame:CGRectMake(275, yValue,285,200)];
    popTableView.scrollEnabled = YES;
    popTableView.userInteractionEnabled = YES;
    popTableView.backgroundColor = [UIColor whiteColor];
    popTableView.dataSource = self;
    popTableView.delegate = self;
    [self.scroll_view addSubview:popTableView];
    [popTableView reloadData];
    _scroll_view.scrollEnabled = NO;
}

- (IBAction)btn_back:(id)sender {
}
- (IBAction)btn_result_type:(id)sender {
    
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_RESULT_TYPE){
        selectedTablePostition = POS_RESULT_TYPE;
        [self openPopTableView:60];
        //[self openResultTypeTableView];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
//    if(!isTableOpen){
//        isTableOpen = YES;
//        [self openResultTypeTableView];
//    }else{
//        if(resultTypeTableView!=nil){
//            [resultTypeTableView removeFromSuperview];
//        }
//        isTableOpen = NO;
//        _scroll_view.scrollEnabled = YES;
//
//    }
}

- (IBAction)btn_done:(id)sender {
}
- (IBAction)btn_revert:(id)sender {
}
- (IBAction)btn_team:(id)sender {
    
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_TEAM){
        selectedTablePostition = POS_TEAM;
        [self openPopTableView:130];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
}
- (IBAction)btn_man_of_the_match:(id)sender {
    
    
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_MAN_OF_THE_MATCH){
        selectedTablePostition = POS_MAN_OF_THE_MATCH;
        [self openPopTableView:275];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
}

- (IBAction)btn_man_of_the_series:(id)sender {
    
    
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_MAN_OF_THE_SERIES){
        selectedTablePostition = POS_MAN_OF_THE_SERIES;
        [self openPopTableView:345];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
}
- (IBAction)btn_best_batsman:(id)sender {
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_BEST_BATSMAN){
        selectedTablePostition = POS_BEST_BATSMAN;
        [self openPopTableView:420];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
}
- (IBAction)btn_best_bowler:(id)sender {
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_BEST_BOWLER){
        selectedTablePostition = POS_BEST_BOWLER;
        [self openPopTableView:480];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
}

- (IBAction)btn_allrounder:(id)sender {
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_BEST_ALL_ROUNDER){
        selectedTablePostition = POS_BEST_ALL_ROUNDER;
        [self openPopTableView:550];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
}
- (IBAction)btn_most_valu_player:(id)sender {
    if(popTableView!=nil){
        [popTableView removeFromSuperview];
    }
    
    if(selectedTablePostition != POS_MOST_VALUABLE_PLAYER){
        selectedTablePostition = POS_MOST_VALUABLE_PLAYER;
        [self openPopTableView:620];
    }else{
        selectedTablePostition =0;
        _scroll_view.scrollEnabled = YES;
    }
}
@end
