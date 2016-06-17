//
//  ScoreCardVC.m
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ScoreCardVC.h"
#import "ScoreCardCellTVCell.h"
#import "FetchScorecard.h"
#import "BattingSummaryDetailsForScoreBoard.h"

@interface ScoreCardVC ()

@end

@implementation ScoreCardVC

@synthesize competitionCode;
@synthesize matchCode;
@synthesize inningsNo;
FetchScorecard *fetchScorecard ;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    competitionCode = @"UCC0000004";
    matchCode = @"IMSC02200224DB2663B00002";
    inningsNo = @"2";
    
    
     fetchScorecard = [[FetchScorecard alloc]init];
    [fetchScorecard FetchScoreBoard:competitionCode :matchCode :inningsNo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return fetchScorecard.BattingSummaryForScoreBoard.count+1;    //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"scorecard_batsman_cell";
    static NSString *CellIdentifierHeader = @"batsman_header_cell";
    
    if(indexPath.row == 0){
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierHeader];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.batsManHeaderCell;
            self.batsManHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }else{
        BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:indexPath.row-1];
        
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.batsmanCell;
            self.batsmanCell = nil;
        }
        cell.lbl_player_name.text = battingSummaryDetailsForSB.BATSMANNAME;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.lbl_sr.text = battingSummaryDetailsForSB.STRIKERATE;
       
        cell.lbl_rss.text = battingSummaryDetailsForSB.RUNSPERSCORINGSHOTS;
       
        cell.lbl_runs.text = battingSummaryDetailsForSB.RUNS;
        cell.lbl_balls.text = battingSummaryDetailsForSB.BALLS;
        cell.lbl_b_fours.text = battingSummaryDetailsForSB.FOURS;
        cell.lbl_b_sixes.text = battingSummaryDetailsForSB.SIXES;
        cell.lbl_how_out.text = battingSummaryDetailsForSB.WICKETDESCRIPTION;
        cell.lbl_dot_ball.text = battingSummaryDetailsForSB.DOTBALLS;
        cell.lbl_dot_ball_percent.text = battingSummaryDetailsForSB.DOTBALLPERCENTAGE;
        
        
        return cell;
    }
    
    
 
    
    
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 44;
    }else{
    return 70;
    }
}

//
//ScoreCardCellTVCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//if (cell == nil)
//{
//    [tableView registerNib:[UINib nibWithNibName:@"ScoreCardCellTVCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
//    
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    //        cell = [[ScoreCardCellTVCell alloc] initWithStyle:UITableViewCellStyleDefault
//    //                                  reuseIdentifier:CellIdentifier];
//}
//[cell setBackgroundColor:[UIColor clearColor]];
//cell.lbl_player_name.text = @"fsdkhfksdhfkhsdkjhf";
//
//return cell;
@end
