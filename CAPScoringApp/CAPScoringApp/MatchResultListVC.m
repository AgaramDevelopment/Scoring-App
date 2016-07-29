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
#import "InsertUpdateMatchResult.h"
#import "GetMatchResultDetail.h"
#import "GetBestPlayerDetail.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"


@interface MatchResultListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

int selectedTablePostition;

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

GetMatchResultTypeAndCodeDetails *selectedResultType;
GetTeamANameDetails *selectedTeam;
SelectPlayerRecord *selectedManOfTheMatch;
SelectPlayerRecord *selectedManOfTheSeries;
SelectPlayerRecord *selectedBestBatsman;
SelectPlayerRecord *selectedBestBowler;
SelectPlayerRecord *selectedBestAllRounder;
SelectPlayerRecord *selectedMostValuPlayer;




@implementation MatchResultListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    self.scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, 850);
    
    selectedResultType = nil;
    selectedTeam = nil;
     selectedManOfTheMatch = nil;
     selectedManOfTheSeries = nil;
     selectedBestBatsman = nil;
     selectedBestBowler = nil;
     selectedBestAllRounder = nil;
     selectedMostValuPlayer = nil;

//
    _scroll_view.scrollEnabled = YES;
    selectedTablePostition = 0;
//    isTableOpen = NO;
    

    [self resetPage];
    
}



-(void) resetPage{
    
    _lbl_team.text = @"Select";
    _lbl_result_type.text = @"Select";
    _txtf_comments.text = @"";
    _txtf_team_a_point.text = @"";
    _txtf_team_b_point.text =@"";
    _lbl_man_of_the_match.text = @"Select";
    _lbl_man_of_the_series.text = @"Select";
    _lbl_select_best_batsman.text = @"Select";
    _lbl_select_best_bowler.text = @"Select";
    _lbl_select_allrounder.text = @"Select";
    _lbl_select_most_valu_player.text= @"Select";


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
    
    if(teamDetails.count>1){
        GetTeamANameDetails *teamA = [teamDetails objectAtIndex:0];
        GetTeamANameDetails *teamB = [teamDetails objectAtIndex:1];
        
        _lbl_team_a_point.text = [NSString stringWithFormat:@"%@ Point",teamA.SHORTTEAMNAME];
        _lbl_team_b_point.text = [NSString stringWithFormat:@"%@ Point",teamB.SHORTTEAMNAME];
        
    }
    
    //Set Data
    
    if([ fetchMatchResult.GetMatchResultDetails count]>0){
        GetMatchResultDetail *matchResult = [fetchMatchResult.GetMatchResultDetails objectAtIndex:0];
        _lbl_result_type.text =matchResult.RESULTTYPE;
        _txtf_comments.text = matchResult.COMMENTS;
        _txtf_team_a_point.text = matchResult.TEAMAPOINTS == nil ? @"":matchResult.TEAMAPOINTS;
        _txtf_team_b_point.text = matchResult.TEAMBPOINTS == nil ? @"":matchResult.TEAMBPOINTS;
        _lbl_team.text = matchResult.TEAM ;
        _lbl_man_of_the_match.text = matchResult.MANOFTHEMATCH;
        [_btn_submit_id setTitle:@"UPDATE" forState:UIControlStateNormal];
        
        
        
        
        
        
        //Reset Team
        if(![matchResult.RESULTTYPE isEqual:@"Win"] && ![matchResult.RESULTTYPE isEqual:@"Match Awarded"]){
            
            [self.view_team_layer.layer setBorderColor:[UIColor colorWithRed:(46/255.0f) green:(52/255.0f) blue:(56/255.0f) alpha:(1)].CGColor];
            self.view_team_layer.layer.borderWidth=2;
            self.btn_team_id.userInteractionEnabled = NO;
            _lbl_team.text = @"Select";
            selectedTeam = nil;
            
        }
        
        
        for(int i=0;i<[fetchMatchResult.GetMatchResultTypeAndCode count];i++){
            GetMatchResultTypeAndCodeDetails *data = [fetchMatchResult.GetMatchResultTypeAndCode objectAtIndex:i];
            if([matchResult.RESULTTYPE isEqual:data.RESULTTYPE]){
                selectedResultType = data;
                break;
            }
        }
        
        for(int i=0;i<[teamDetails count];i++){
            GetTeamANameDetails *data = [teamDetails objectAtIndex:i];
            if([matchResult.TEAM isEqual:data.TEAMNAME]){
                selectedTeam = data;
                break;
            }
        }
        
        for(int i=0;i<[fetchMatchResult.GetManOfTheMatchDetail count];i++){
            SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheMatchDetail objectAtIndex:i];
            if([matchResult.MANOFTHEMATCH isEqual:data.playerName]){
                selectedManOfTheMatch = data;
                break;
            }
        }
        
        [self.btn_revert_id.layer setBackgroundColor:[UIColor colorWithRed:(255/255.0f) green:(86/255.0f) blue:(88/255.0f) alpha:(1)].CGColor];
                _btn_revert_id.userInteractionEnabled = YES;

        if([ fetchMatchResult.GetBestPlayerDetails count]>0){
            GetBestPlayerDetail *playerDetail = [fetchMatchResult.GetBestPlayerDetails objectAtIndex:0];
            
            _lbl_man_of_the_series.text = [playerDetail.MANOFTHESERIES  isEqual: @""]?@"Select":playerDetail.MANOFTHESERIES;
            _lbl_select_best_batsman.text = [playerDetail.BESTBATSMAN  isEqual: @""]?@"Select":playerDetail.BESTBATSMAN;
            _lbl_select_best_bowler.text = [playerDetail.BESTBOWLER isEqual: @""]?@"Select":playerDetail.BESTBOWLER;
            _lbl_select_allrounder.text = [playerDetail.BESTALLROUNDER isEqual: @""]?@"Select":playerDetail.BESTALLROUNDER;
            _lbl_select_most_valu_player.text = [playerDetail.MOSTVALUABLEPLAYER isEqual: @""]?@"Select":playerDetail.MOSTVALUABLEPLAYER;
            
            
            for(int i=0;i<[fetchMatchResult.GetManOfTheSeriesDetails count];i++){
                SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:i];
                if([playerDetail.MANOFTHESERIES isEqual:data.playerName]){
                    selectedManOfTheSeries = data;
                    break;
                }
                
            }
            
            for(int i=0;i<[fetchMatchResult.GetBestBatsManDetails count];i++){
                SelectPlayerRecord *data = [fetchMatchResult.GetBestBatsManDetails objectAtIndex:i];
                if([playerDetail.BESTBATSMAN isEqual:data.playerName]){
                    selectedBestBatsman = data;
                    break;
                }
            }
            
            for(int i=0;i<[fetchMatchResult.GetBestBowlerDetails count];i++){
                SelectPlayerRecord *data = [fetchMatchResult.GetBestBowlerDetails objectAtIndex:i];
                if([playerDetail.BESTBOWLER isEqual:data.playerName]){
                    selectedBestBowler = data;
                    break;
                }
            }
            for(int i=0;i<[fetchMatchResult.GetManOfTheSeriesDetails count];i++){
                SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:i];
                if([playerDetail.BESTALLROUNDER isEqual:data.playerName]){
                    selectedBestAllRounder = data;
                    break;
                }
            }
            
            for(int i=0;i<[fetchMatchResult.GetManOfTheSeriesDetails count];i++){
                SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:i];
                if([playerDetail.MOSTVALUABLEPLAYER isEqual:data.playerName]){
                    selectedMostValuPlayer = data;
                    break;
                }
            }
            
            
        }
        
    }else{
        [self.btn_revert_id.layer setBackgroundColor:[UIColor colorWithRed:(119/255.0f) green:(57/255.0f) blue:(58/255.0f) alpha:(1)].CGColor];
        _btn_revert_id.userInteractionEnabled = NO;

    }
    

    
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
        return [fetchMatchResult.GetManOfTheSeriesDetails count];
        
    }else if(selectedTablePostition == POS_MOST_VALUABLE_PLAYER){
        return [fetchMatchResult.GetManOfTheSeriesDetails count];
        
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
        
        selectedResultType = data;
        
        _lbl_result_type.text = data.RESULTTYPE;
        
        
        _lbl_team.text = @"Select";
        selectedTeam = nil;
        
        
        //Reset Team
        if([selectedResultType.RESULTTYPE isEqual:@"Win"] || [selectedResultType.RESULTTYPE isEqual:@"Match Awarded"]){
            
            [self.view_team_layer.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
            self.view_team_layer.layer.borderWidth=2;
            
            self.btn_team_id.userInteractionEnabled = YES;
            
            
        }else{
            
            [self.view_team_layer.layer setBorderColor:[UIColor colorWithRed:(46/255.0f) green:(52/255.0f) blue:(56/255.0f) alpha:(1)].CGColor];
            self.view_team_layer.layer.borderWidth=2;
            self.btn_team_id.userInteractionEnabled = NO;
        }
        

    
        
    }else if(selectedTablePostition == POS_TEAM){
        
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        GetTeamANameDetails *data = [teamDetails objectAtIndex:indexPath.row];
        selectedTeam = data;
        
        _lbl_team.text = data.TEAMNAME;
        
    }else if(selectedTablePostition == POS_MAN_OF_THE_MATCH){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;

        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheMatchDetail objectAtIndex:indexPath.row];
        selectedManOfTheMatch = data;
        _lbl_man_of_the_match.text = data.playerName;
        
    }else if(selectedTablePostition == POS_MAN_OF_THE_SERIES){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;

        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
        selectedManOfTheSeries = data;
        _lbl_man_of_the_series.text = data.playerName;
        
    }else if(selectedTablePostition == POS_BEST_BATSMAN){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetBestBatsManDetails objectAtIndex:indexPath.row];
        selectedBestBatsman = data;
        _lbl_select_best_batsman.text = data.playerName;
        
    }else if(selectedTablePostition == POS_BEST_BOWLER){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetBestBowlerDetails objectAtIndex:indexPath.row];
        selectedBestBowler = data;
        _lbl_select_best_bowler.text = data.playerName;
    }else if(selectedTablePostition == POS_BEST_ALL_ROUNDER){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
        selectedBestAllRounder = data;
        _lbl_select_allrounder.text = data.playerName;
        
    }else if(selectedTablePostition == POS_MOST_VALUABLE_PLAYER){
        [popTableView removeFromSuperview];
        _scroll_view.scrollEnabled = YES;
        selectedTablePostition =0;
        
        
        SelectPlayerRecord *data = [fetchMatchResult.GetManOfTheSeriesDetails objectAtIndex:indexPath.row];
        selectedMostValuPlayer = data;
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
    if(selectedTablePostition == POS_TEAM){
        popTableView=[[UITableView alloc]initWithFrame:CGRectMake(275, yValue,285,95)];

    }else{
        popTableView=[[UITableView alloc]initWithFrame:CGRectMake(275, yValue,285,200)];

    }
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
    
    if([self checkValidation]){
    
    NSString *MANOFTHESERIESCODE = selectedManOfTheSeries == nil ?@"":selectedManOfTheSeries.playerCode;
    NSString *BESTBATSMANCODE = selectedBestBatsman == nil ?@"":selectedBestBatsman.playerCode;
    NSString *BESTBOWLERCODE = selectedBestBowler == nil ?@"":selectedBestBowler.playerCode;
    NSString *BESTALLROUNDERCODE = selectedBestAllRounder == nil ?@"":selectedBestAllRounder.playerCode;
    NSString *MOSTVALUABLEPLAYERCODE = selectedMostValuPlayer == nil ?@"":selectedMostValuPlayer.playerCode;
    NSString *MATCHRESULTCODE = selectedResultType == nil ?@"":selectedResultType.RESULTCODE;
    NSString *MATCHWONTEAMCODE = selectedTeam == nil ?@"":selectedTeam.TEAMACODE;
    NSNumber *TEAMAPOINTS = [NSNumber numberWithInteger: [_txtf_team_a_point.text integerValue]]  ;
    NSString *TEAMBPOINTS = _txtf_team_b_point.text;
    NSString *MANOFTHEMATCHCODE =selectedManOfTheMatch == nil ?@"":selectedManOfTheMatch.playerCode;
    NSString *COMMENTS = _txtf_comments.text;
    NSString *TEAMNAME = @"";
    NSString *BUTTONNAME = @"DONE";


    InsertUpdateMatchResult *insertUpdateData = [[InsertUpdateMatchResult alloc]init];
    
    [insertUpdateData InsertMatchResult: self.competitionCode : self.matchCode : MANOFTHESERIESCODE : BESTBATSMANCODE :BESTBOWLERCODE : BESTALLROUNDERCODE : MOSTVALUABLEPLAYERCODE : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS :MANOFTHEMATCHCODE : COMMENTS : TEAMNAME : BUTTONNAME];
        
        [self resetPage];
        
        [self startService:@"DONE"];
        
        [self.delegate MatchResultFinishBtnAction];

    }
    

    
}
- (IBAction)btn_revert:(id)sender {
   
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Alert"
                                                   message: @"Do you want to Revert?"
                                                  delegate: self
                                         cancelButtonTitle:@"Yes"
                                         otherButtonTitles:@"No",nil];
    
    alert.tag = 100;
    [alert show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) { // UIAlertView with tag 1 detected
    if (buttonIndex == 0)
    {
        
        NSString *MANOFTHESERIESCODE = selectedManOfTheSeries == nil ?@"":selectedManOfTheSeries.playerCode;
        NSString *BESTBATSMANCODE = selectedBestBatsman == nil ?@"":selectedBestBatsman.playerCode;
        NSString *BESTBOWLERCODE = selectedBestBowler == nil ?@"":selectedBestBowler.playerCode;
        NSString *BESTALLROUNDERCODE = selectedBestAllRounder == nil ?@"":selectedBestAllRounder.playerCode;
        NSString *MOSTVALUABLEPLAYERCODE = selectedMostValuPlayer == nil ?@"":selectedMostValuPlayer.playerCode;
        NSString *MATCHRESULTCODE = selectedResultType == nil ?@"":selectedResultType.RESULTCODE;
        NSString *MATCHWONTEAMCODE = selectedTeam == nil ?@"":selectedTeam.TEAMACODE;
        NSNumber *TEAMAPOINTS = [NSNumber numberWithInteger: [_txtf_team_a_point.text integerValue]]  ;
        NSString *TEAMBPOINTS = _txtf_team_b_point.text;
        NSString *MANOFTHEMATCHCODE =selectedManOfTheMatch == nil ?@"":selectedManOfTheMatch.playerCode;
        NSString *COMMENTS = _txtf_comments.text;
        NSString *TEAMNAME = @"";
        NSString *BUTTONNAME = @"REVERT";
        
        
        InsertUpdateMatchResult *insertUpdateData = [[InsertUpdateMatchResult alloc]init];
        
        [insertUpdateData InsertMatchResult: self.competitionCode : self.matchCode : MANOFTHESERIESCODE : BESTBATSMANCODE :BESTBOWLERCODE : BESTALLROUNDERCODE : MOSTVALUABLEPLAYERCODE : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS :MANOFTHEMATCHCODE : COMMENTS : TEAMNAME : BUTTONNAME];
        
        [self resetPage];
        
        [self startService:@"REVERT"];
        [self.delegate MatchResultFinishBtnAction];

        
    }
    else
    {
    }
        }
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

-(BOOL) checkValidation{
    
    BOOL flag = YES;
    
    NSString *errorMessage = @"";
    
    if(selectedResultType==nil){
        errorMessage = [NSString stringWithFormat:@"%@",@"Please select Result type.\n"];
        flag = NO;

    }
    
    if([_txtf_comments.text isEqual:@""]){
        errorMessage = [NSString stringWithFormat:@"%@%@",errorMessage,@"Please enter comments.\n"];
        flag = NO;
    }
    
    if( selectedResultType==nil&&  selectedTeam==nil){
        errorMessage = [NSString stringWithFormat:@"%@%@",errorMessage,@"Please select team.\n"];
        flag = NO;
    }else if(([selectedResultType.RESULTTYPE isEqual:@"Win"] || [selectedResultType.RESULTTYPE isEqual:@"Match Awarded"]) &&  selectedTeam==nil){
        errorMessage = [NSString stringWithFormat:@"%@%@",errorMessage,@"Please select team.\n"];
        flag = NO;
    }
    
    if(![self textValidation:_txtf_team_a_point.text] && ([_txtf_team_a_point.text intValue]<0 || [_txtf_team_a_point.text intValue]>9)){
        errorMessage = [NSString stringWithFormat:@"%@%@",errorMessage,@"Please enter A point between 0 to 9.\n"];
        flag = NO;
    }else if(![self textValidation:_txtf_team_b_point.text] && ([_txtf_team_b_point.text intValue]<0 || [_txtf_team_b_point.text intValue]>9)){
        errorMessage = [NSString stringWithFormat:@"%@%@",errorMessage,@"Please enter point between 0 to 9.\n"];
        flag = NO;
    }
    
    if(![errorMessage isEqual:@""]){
        [self showDialog:errorMessage andTitle:@"MatchResult"];
    }
    
    return flag;
}

/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alertDialog show];
}


//Check internet connection
- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void) startService:(NSString *)OPERATIONTYPE{
    if(self.checkInternetConnection){
        
        NSString *MANOFTHESERIESCODE = selectedManOfTheSeries == nil ?@"NULL":selectedManOfTheSeries.playerCode;
        NSString *BESTBATSMANCODE = selectedBestBatsman == nil ?@"NULL":selectedBestBatsman.playerCode;
        NSString *BESTBOWLERCODE = selectedBestBowler == nil ?@"NULL":selectedBestBowler.playerCode;
        NSString *BESTALLROUNDERCODE = selectedBestAllRounder == nil ?@"NULL":selectedBestAllRounder.playerCode;
        NSString *MOSTVALUABLEPLAYERCODE = selectedMostValuPlayer == nil ?@"":selectedMostValuPlayer.playerCode;
        NSString *MATCHRESULTCODE = selectedResultType == nil ?@"NULL":selectedResultType.RESULTCODE;
        NSString *MATCHWONTEAMCODE = selectedTeam == nil ?@"NULL":selectedTeam.TEAMACODE;
        NSNumber *TEAMAPOINTS = [NSNumber numberWithInteger: [_txtf_team_a_point.text integerValue]]  ;
        NSString *TEAMBPOINTS = [_txtf_team_b_point.text isEqual: @""] ?@"NULL":_txtf_team_b_point.text;
        NSString *MANOFTHEMATCHCODE =selectedManOfTheMatch == nil ?@"NULL":selectedManOfTheMatch.playerCode;
        NSString *COMMENTS = [_txtf_comments.text isEqual: @""] ?@"NULL":_txtf_comments.text;
        NSString *TEAMNAME = @"NULL";
        
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/MATCHRESULT/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT], self.competitionCode,self.matchCode,MANOFTHESERIESCODE,BESTBATSMANCODE,BESTBOWLERCODE,BESTALLROUNDERCODE,MOSTVALUABLEPLAYERCODE,MATCHRESULTCODE,MATCHWONTEAMCODE,TEAMAPOINTS,TEAMBPOINTS,MANOFTHEMATCHCODE,COMMENTS,TEAMNAME,OPERATIONTYPE];
            NSLog(@"-%@",baseURL);
          

            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            
            NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            
            if(rootArray !=nil && rootArray.count>0){
                NSDictionary *valueDict = [rootArray objectAtIndex:0];
                NSString *success = [valueDict valueForKey:@"DataItem"];
                if([success isEqual:@"Success"]){
                    
                }
            }else{
                
            }
//            NSNumber * errorCode = (NSNumber *)[rootDictionary objectForKey: @"LOGIN_STATUS"];
//            NSLog(@"%@",errorCode);
//            
//            
//            if([errorCode boolValue] == YES)
//            {
//                
//                BOOL isUserLogin = YES;
//                
//                NSString *userCode = [rootDictionary valueForKey:@"L_USERID"];
//                [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
//                [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [self openContentView];
//                
//            }else{
//                
//                [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
//            }
            [delegate hideLoading];
        });
        
        //[delegate hideLoading];
    }
}


-(BOOL)textValidation:(NSString*) validation{
    
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    
    filtered = [[validation componentsSeparatedByCharactersInSet:charcter] componentsJoinedByString:@""];
    return [validation isEqualToString:filtered];
    
    
    
    
    
}

@end
