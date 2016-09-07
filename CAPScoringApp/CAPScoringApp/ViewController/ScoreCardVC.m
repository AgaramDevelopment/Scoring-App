//
//  ScoreCardVC.m
//  CAPScoringApp
//
//  Created by Sathish on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ScoreCardVC.h"
#import "ScoreCardCellTVCell.h"
#import "FetchScorecard.h"
#import "BattingSummaryDetailsForScoreBoard.h"
#import "BowlingSummaryDetailsForScoreBoard.h"
#import "CustomNavigationVC.h"
#import "FetchSEPageLoadRecord.h"

@interface ScoreCardVC (){
    CustomNavigationVC *objCustomNavigation;
    
}
@end

@implementation ScoreCardVC

@synthesize competitionCode;
@synthesize matchCode;
@synthesize inningsNo;
@synthesize RunRate;
@synthesize selectedPlayerFilterArray;
@synthesize selectedPlayerArray;

FetchScorecard *fetchScorecard ;
FetchSEPageLoadRecord *fetchSEpage;

NSArray *muliteDayMatchtype;

int batsmanHeaderPosition = 0;
int batsmanPostion = 0;

int extraPostion = 0 ;
int overRunRatePostion = 0;
int didNotBatPostion = 0;
int fallOfWktHeaderPostion = 0;
int fallOfWktPostion = 0;
int bowlerHeaderPosition = 0;
int bowlerPostion = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table.HVTableViewDataSource = self;
    self.table.HVTableViewDelegate = self;
    
    muliteDayMatchtype =[[NSArray alloc]initWithObjects:@"MSC023",@"MSC114", nil];

    
    [self customnavigationmethod];
    
    [self scoreDetailsColorChange];
 
    //self.matchTypeCode = @"MSC115";
    
    
    fetchScorecard = [[FetchScorecard alloc]init];
    [fetchScorecard FetchScoreBoard:competitionCode :matchCode :inningsNo];
    
     fetchSEpage = [[FetchSEPageLoadRecord alloc]init];
    [fetchSEpage fetchSEPageLoadDetails:competitionCode :matchCode];
    
    
    
    //Set Table Cell Position
    batsmanHeaderPosition = 0;
    batsmanPostion = fetchScorecard.BattingSummaryForScoreBoard.count > 0 ? 1 :0;
    extraPostion = fetchScorecard.BattingSummaryForScoreBoard.count>0?fetchScorecard.BattingSummaryForScoreBoard.count+1:1;
    overRunRatePostion = extraPostion+1;
    didNotBatPostion = overRunRatePostion+1;
    
    
    BOOL isFOW = NO;
    for (BattingSummaryDetailsForScoreBoard *batSumryDtl in fetchScorecard.BattingSummaryForScoreBoard) {
        
        if(batSumryDtl.WICKETTYPE !=nil && ![batSumryDtl.WICKETTYPE isEqual:@"(null)"] && ![batSumryDtl.WICKETTYPE isEqual:@""]){
            isFOW = YES;
            break;
        }
    }
    fallOfWktHeaderPostion = isFOW?didNotBatPostion+1:0;
    fallOfWktPostion = isFOW?fallOfWktHeaderPostion+1:0;

    bowlerHeaderPosition =isFOW?fallOfWktPostion+1:didNotBatPostion+1;
    bowlerPostion = bowlerHeaderPosition+1;


    
    [self hideLabelBasedOnMatchType];
    
    _lbl_battingShrtName.text = _BATTEAMSHORTNAME;
    _lbl_firstIngsTeamName.text = _FIRSTINNINGSSHORTNAME;
    _lbl_secIngsTeamName.text =  [_SECONDINNINGSSHORTNAME isEqual:@""]?_BOWLTEAMSHORTNAME:_SECONDINNINGSSHORTNAME;
    
    _lbl_battingScoreWkts.text = [NSString stringWithFormat:@"%ld / %ld",(unsigned long)_BATTEAMRUNS,(unsigned long) _BATTEAMWICKETS];
    
    _lbl_overs.text = [NSString stringWithFormat:@"%ld.%ld OVS" ,(unsigned long)_BATTEAMOVERS,(unsigned long)_BATTEAMOVRBALLS];
    
//    _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEpage.BATTEAMRUNRATE floatValue], [fetchSEpage.RUNSREQUIRED floatValue]];
//    
    
    if(inningsNo.intValue>1 && ![muliteDayMatchtype containsObject:_matchTypeCode]){
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEpage.BATTEAMRUNRATE floatValue] < 0 ? @"0.0".floatValue: [fetchSEpage.BATTEAMRUNRATE floatValue], [fetchSEpage.REQRUNRATE floatValue] < 0 ? @"0.0".floatValue: [fetchSEpage.REQRUNRATE floatValue]];
    }else{
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f",[fetchSEpage.BATTEAMRUNRATE floatValue]];
    }
    
    
    
    _lbl_teamBSecIngsScore.text = [NSString stringWithFormat:@"%@ / %@", _SECONDINNINGSTOTAL,_SECONDINNINGSWICKET];
    _lbl_teamBSecIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",_SECONDINNINGSOVERS];
    
    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",_FIRSTINNINGSTOTAL,
                                     _FIRSTINNINGSWICKET];
    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",_FIRSTINNINGSOVERS];
    
    

    
    [self setInitView];
    int btnSize =self.btn_sec_inns_id.frame.origin.x;
    
    //    self.btn_tab_fst_inns.constant =200;
    ////    self.btn_tab_second_inns.constant =400;
    //self.btn_fst_inn_x.constant=btnSize*2;
    //    self.btn_fst_inn_width.constant = 200;
    ////    self.btn_sec_inn_x.constant=400;
    
    //
    //    self.lbl_strip.constant=500;
    //
    //
    //    self.btn_tab_fst_inns.constant=500;
    //
    //    self.btn_tab_second_inns.constant=500;
    

    
    [self teamLogo];
    
if (([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] || [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"] || [self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]) &&[inningsNo isEqualToString:@"1"]) {
    
    
        [self.btn_sec_inns_id setHidden:YES];
    
    self.btn_third_inns_id.hidden = YES;
    self.btn_fourth_inns_id.hidden = YES;
    }
    
    //test match
    if (([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"])&&[inningsNo isEqualToString:@"2"]) {
        
     
        self.btn_third_inns_id.hidden = YES;
        self.btn_fourth_inns_id.hidden = YES;
        
    }else if (([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"])&&[inningsNo isEqualToString:@"3"]){
        
          self.btn_fourth_inns_id.hidden = YES;
    }
    

}

-(void) setInitView{
    
    if([inningsNo isEqual:@"1"]){
        self.lbl_strip.constant=0;
        
[self.btn_fst_inns_id setTitle:[NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BATTINGTEAMNAME] forState: UIControlStateNormal];
[self.btn_sec_inns_id setTitle: [NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BOWLINGTEAMNAME] forState: UIControlStateNormal];
        
    }else if([inningsNo isEqual:@"2"]){
        self.lbl_strip.constant= 195;
        [self.btn_fst_inns_id setTitle:[NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BOWLINGTEAMNAME] forState: UIControlStateNormal];
        
        [self.btn_sec_inns_id setTitle: [NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BATTINGTEAMNAME] forState: UIControlStateNormal];
       
    }else if([inningsNo isEqual:@"3"]){
    
         self.lbl_strip.constant= 385;
        
        [self.btn_fst_inns_id setTitle:[NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BATTINGTEAMNAME] forState: UIControlStateNormal];
        [self.btn_sec_inns_id setTitle: [NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BOWLINGTEAMNAME] forState: UIControlStateNormal];
        
        [self.btn_third_inns_id setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",fetchScorecard.BATTINGTEAMNAME] forState: UIControlStateNormal];
        
        [self.btn_fourth_inns_id setTitle: [NSString stringWithFormat:@"%@ 2nd INNS",fetchScorecard.BOWLINGTEAMNAME] forState: UIControlStateNormal];
       
    }else if([inningsNo isEqual:@"4"]){
        self.lbl_strip.constant=580;
        
    [self.btn_fst_inns_id setTitle:[NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BOWLINGTEAMNAME] forState: UIControlStateNormal];
    [self.btn_sec_inns_id setTitle: [NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BATTINGTEAMNAME] forState: UIControlStateNormal];
        
        [self.btn_third_inns_id setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",fetchScorecard.BOWLINGTEAMNAME] forState: UIControlStateNormal];
        
        [self.btn_fourth_inns_id setTitle: [NSString stringWithFormat:@"%@ 2nd INNS",fetchScorecard.BATTINGTEAMNAME] forState: UIControlStateNormal];
        
       
    }
    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
        
        self.btn_third_inns_id.hidden = YES;
        self.btn_fourth_inns_id.hidden = YES;
        self.lbl_third_div.hidden = YES;
        
        
    }else{ // Test Match
        
        _lbl_teamASecIngsScore.text = [NSString stringWithFormat:@"%@ / %@", _THIRDINNINGSTOTAL==nil?@"0":_THIRDINNINGSTOTAL,_THIRDINNINGSWICKET==nil?@"0":_THIRDINNINGSWICKET];
        _lbl_teamASecIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",_THIRDINNINGSOVERS==nil?@"0":_THIRDINNINGSOVERS];
        _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", _FOURTHINNINGSTOTAL==nil?@"0":_FOURTHINNINGSTOTAL,_FOURTHINNINGSWICKET==nil?@"0":_FOURTHINNINGSWICKET];
        
        _lbl_teamBfirstIngsOvs.text =[NSString stringWithFormat:@"%@ OVS",_FOURTHINNINGSOVERS==nil?@"0":_FOURTHINNINGSOVERS];
        
        


    
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"SCORE CARD";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideLabelBasedOnMatchType{
    
    
    
    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
        
        
        _lbl_teamAsecIngsHeading.hidden = YES;
        _lbl_teamASecIngsScore.hidden = YES;
        _lbl_teamASecIngsOvs.hidden = YES;

        
        _lbl_teamBfirstIngsScore.hidden = YES;
        _lbl_teamBfirstIngsOvs.hidden = YES;
        _lbl_teamBsecIngsHeading.hidden = YES;
        
        
        
        
    }else{
        
        _lbl_teamAsecIngsHeading.hidden = NO;
        _lbl_teamBsecIngsHeading.hidden = NO;
        
        _lbl_teamASecIngsScore.hidden = NO;
        _lbl_teamASecIngsOvs.hidden = NO;
        _lbl_teamBfirstIngsScore.hidden = NO;
        _lbl_teamBfirstIngsOvs.hidden = NO;
        
    }
    
}
-(void)scoreDetailsColorChange{
    
    
    if ([inningsNo isEqualToString:@"1"]) {
        
     

       self.lbl_teamAfirstIngsHeading.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
       self.lbl_teamAfirstIngsScore.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
        self.lbl_teamAfirstIngsOvs.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];

    }else if ([inningsNo isEqualToString:@"2"]){
        
     

        _lbl_teamBsecHeading.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
       _lbl_teamBSecIngsScore.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
        
        _lbl_teamBSecIngsOvs.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
        
    }else if ([inningsNo isEqualToString:@"3"]){
        
        
        _lbl_teamAsecIngsHeading.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
        self.lbl_teamASecIngsScore.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
        self.lbl_teamASecIngsOvs.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
        

        
    }else if ([inningsNo isEqualToString:@"4"]){
        
        
           _lbl_teamBsecIngsHeading.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];
        _lbl_teamBfirstIngsScore.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];

        _lbl_teamBfirstIngsOvs.textColor = [UIColor colorWithRed:(191/255.0f) green:(161/255.0f) blue:(68/255.0f) alpha:1.0f];

        
    }
    
    
}
-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIView *purchaseButton = (UIButton *)[cell viewWithTag:10];
    purchaseButton.alpha = 0;
    purchaseButton.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        purchaseButton.alpha = 1;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }];
}

//perform your collapse stuff (may include animation) for cell here. It will be called when the user touches an expanded cell so it gets collapsed or the table is in the expandOnlyOneCell satate and the user touches another item, So the last expanded item has to collapse
-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIView *purchaseButton = (UIButton *)[cell viewWithTag:10];
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet";
        purchaseButton.alpha = 0;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(-3.14);
    } completion:^(BOOL finished) {
        purchaseButton.hidden = YES;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = fetchScorecard.BowlingSummaryForScoreBoard.count+
    fetchScorecard.BattingSummaryForScoreBoard.count+
    (fallOfWktHeaderPostion==0?0:1) + (fallOfWktPostion==0?0:1) + 5;
    return rows;  //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
  
    
    static NSString *batsmanCell = @"scorecard_batsman_cell";
    static NSString *batsmanHeaderCell = @"batsman_header_cell";
    static NSString *bowlerHeaderCell = @"bowler_header_cell";
    static NSString *bowlerCell = @"scorecard_bowler_cell";
    static NSString *extraCell = @"scorecard_extra_cell";
    static NSString *overCell = @"over_run_rate_cell";
    static NSString *didNotCell =  @"did_Not_Bat_cell";
    static NSString *fallWktCell =  @"fall_wkt_cell";
    static NSString *fallWktCellHeader = @"fall_of_wkt_header";
    
    

    
    if(indexPath.row == 0){//Batsman header
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:batsmanHeaderCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.batsManHeaderCell;
            self.batsManHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row){//Batsman display
        BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:indexPath.row - 1];
        
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:batsmanCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.batsmanCell;
           // self.batsmanCell = nil;
            
            
        }
        UIView *purchaseButton = (UIView *)[cell viewWithTag:10];
        [cell.spiderWagon_Btn addTarget:self action:@selector(didClickSpiderWagonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.sectorWagon_Btn addTarget:self action:@selector(didClickSectorWagonAction:) forControlEvents:UIControlEventTouchUpInside];
        
         [cell.pitch_Btn addTarget:self action:@selector(didClickpitchAction:) forControlEvents:UIControlEventTouchUpInside];
        
         [cell.onSide_Btn addTarget:self action:@selector(didClickonSideAction:) forControlEvents:UIControlEventTouchUpInside];
        
         [cell.offSide_Btn addTarget:self action:@selector(didClickOffSideAction:) forControlEvents:UIControlEventTouchUpInside];
        
         [cell.wangon1s_Btn addTarget:self action:@selector(didClick1sAction:) forControlEvents:UIControlEventTouchUpInside];
        
         [cell.wangon2s_Btn addTarget:self action:@selector(didClick2sAction:) forControlEvents:UIControlEventTouchUpInside];
        
         [cell.wangon3s_Btn addTarget:self action:@selector(didClick3sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.wangon4s_Btn addTarget:self action:@selector(didClick4sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.wangon6s_Btn addTarget:self action:@selector(didClick6sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([battingSummaryDetailsForSB.WICKETDESCRIPTION isEqualToString:@"NOT OUT"]) {
            
        cell.lbl_player_name.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_sr.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_rss.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_runs.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_balls.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_b_fours.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_b_sixes.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_dot_ball.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
         cell.lbl_dot_ball_percent.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
               cell.lbl_how_out.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
        }else{
            
            cell.lbl_player_name.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_sr.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_rss.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_runs.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_balls.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_b_fours.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_b_sixes.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_dot_ball.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_dot_ball_percent.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            cell.lbl_how_out.textColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            
        }
        if (!isExpanded) //prepare the cell as if it was collapsed! (without any animation!)
        {
            //[cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
            purchaseButton.hidden = YES;
        }
        else ///prepare the cell as if it was expanded! (without any animation!)
        {
            purchaseButton.hidden = NO;

        }
        
        cell.lbl_player_name.text = battingSummaryDetailsForSB.BATSMANNAME;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.lbl_sr.text = [NSString stringWithFormat:@"%.02f",[battingSummaryDetailsForSB.STRIKERATE floatValue]];
        
        
        cell.lbl_rss.text = [NSString stringWithFormat:@"%.02f",[battingSummaryDetailsForSB.RUNSPERSCORINGSHOTS floatValue]];
        cell.lbl_runs.text = battingSummaryDetailsForSB.RUNS;
        cell.lbl_balls.text = battingSummaryDetailsForSB.BALLS;
        cell.lbl_b_fours.text = battingSummaryDetailsForSB.FOURS;
        cell.lbl_b_sixes.text = battingSummaryDetailsForSB.SIXES;
        cell.lbl_how_out.text = battingSummaryDetailsForSB.WICKETDESCRIPTION;
        cell.lbl_dot_ball.text = battingSummaryDetailsForSB.DOTBALLS;
        cell.lbl_dot_ball_percent.text = [NSString stringWithFormat:@"%.02f",[battingSummaryDetailsForSB.DOTBALLPERCENTAGE floatValue]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if(extraPostion== indexPath.row){//Extras total byes
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:extraCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.extraCell;
            self.extraCell = nil;
            
        }
        
        cell.lbl_totalExtra_runs.text = fetchScorecard.TOTALEXTRAS;
        
        cell.lbl_extras.text = [NSString stringWithFormat:@"(B: %@, LB: %@, WB: %@, P: %@)", fetchScorecard.BYES,fetchScorecard.LEGBYES,fetchScorecard.WIDES,fetchScorecard.PENALTIES];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (overRunRatePostion == indexPath.row){ // total overs
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:overCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.overRunRateCell;
            self.overRunRateCell = nil;
        }
  
        cell.lbl_over_run_rate.text = [NSString stringWithFormat:@"%@ / %@ (%@) RR %.02f" ,fetchScorecard.INNINGSTOTAL, fetchScorecard.INNINGSTOTALWICKETS,fetchScorecard.INNINGSMATCHOVERS,fetchScorecard.INNINGSRUNRATE.floatValue];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if (didNotBatPostion == indexPath.row)//did not bat postion
    {
        
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:didNotCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.didNotBatCell;
            self.didNotBatCell = nil;
        }
        
        NSMutableArray *notBatArray = fetchScorecard.DidNotBatArray ;
        
        
        
        NSString *value = [[notBatArray valueForKey:@"BATSMANNAME"]componentsJoinedByString:@", "];
        NSLog(@"%@",value);
        
        cell.lbl_didNotBat.text = value;
        cell.lbl_didNotBat.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lbl_didNotBat.numberOfLines = 0;
        
        
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if (fallOfWktHeaderPostion == indexPath.row){//fall of wicket header
        
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:fallWktCellHeader];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.fallOfWktCell;
            self.fallOfWktCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if (fallOfWktPostion == indexPath.row){//fall of wkt 
        
        NSString *strFOW = @"";
        
        for (BattingSummaryDetailsForScoreBoard *batSumryDtl in fetchScorecard.BattingSummaryForScoreBoard) {
            
            if(batSumryDtl.WICKETTYPE !=nil && ![batSumryDtl.WICKETTYPE isEqual:@"(null)"] && ![batSumryDtl.WICKETTYPE isEqual:@""]){
                
                
                
                NSArray *exceptionalWicketTypes = [NSArray arrayWithObjects:@"MSC101",@"MSC107",@"MSC133",nil];
                NSString *strFOWTemp;
                
                if ([exceptionalWicketTypes containsObject:batSumryDtl.WICKETTYPE]) {
                    
                    strFOWTemp = [NSString stringWithFormat:@"%@ - %@ (%@ %@)",batSumryDtl.WICKETNO,batSumryDtl.WICKETSCORE,batSumryDtl.BATSMANNAME,batSumryDtl.WICKETTYPEDESCRIPTION];
                    
                    
                }else{
                    strFOWTemp = [NSString stringWithFormat:@"%@ - %@ (%@ %@.%@)ov",batSumryDtl.WICKETNO,batSumryDtl.WICKETSCORE,batSumryDtl.BATSMANNAME,batSumryDtl.WICKETOVERNO,batSumryDtl.WICKETBALLNO];
                    
                }
                
                strFOW = strFOW.length>0?[NSString stringWithFormat:@"%@, %@",strFOW,strFOWTemp] :[NSString stringWithFormat:@"%@",strFOWTemp];
                
            }
        }
        
        
        
        
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:fallWktCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.wktOverCell;
            self.wktOverCell = nil;
        }
        
        
        cell.lbl_fall_of_wkt .text = strFOW;
        cell.lbl_fall_of_wkt.lineBreakMode = NSLineBreakByWordWrapping;
        cell.lbl_fall_of_wkt.numberOfLines = 0;
        
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if(bowlerHeaderPosition == indexPath.row){
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:bowlerHeaderCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.bowlerHeaderCell;
            self.bowlerHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if(indexPath.row >= bowlerPostion){
        BowlingSummaryDetailsForScoreBoard *bowlingSummaryForScoreBoard = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:indexPath.row-bowlerPostion];
        
        ScoreCardCellTVCell *bowlerCellTvc = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:bowlerCell];
        if (bowlerCellTvc == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            bowlerCellTvc = self.bowlerCell;
            self.bowlerCell = nil;
        }
        [bowlerCellTvc setBackgroundColor:[UIColor clearColor]];
        
        bowlerCellTvc.lbl_bowler_ecno.text =[NSString stringWithFormat:@"%.02f",[bowlingSummaryForScoreBoard.ECONOMY floatValue]];
        
        bowlerCellTvc.lbl_bowler_name.text = bowlingSummaryForScoreBoard.BOWLERNAME;
        
        bowlerCellTvc.lbl_bowler_over.text = bowlingSummaryForScoreBoard.OVERS;
        
        bowlerCellTvc.lbl_bowler_runs.text = bowlingSummaryForScoreBoard.RUNS;
        bowlerCellTvc.lbl_bowler_wide.text = bowlingSummaryForScoreBoard.WIDES;
        bowlerCellTvc.lbl_bowler_fours.text = bowlingSummaryForScoreBoard.FOURS;
        bowlerCellTvc.lbl_bowler_sixes.text = bowlingSummaryForScoreBoard.SIXES;
        bowlerCellTvc.lbl_bowler_maiden.text = bowlingSummaryForScoreBoard.MAIDENS;
        bowlerCellTvc.lbl_bowler_noball.text = bowlingSummaryForScoreBoard.NOBALLS;
        bowlerCellTvc.lbl_bowler_wicket.text = bowlingSummaryForScoreBoard.WICKETS;
        
        bowlerCellTvc.selectionStyle = UITableViewCellSelectionStyleNone;

        return bowlerCellTvc;
        
    }
    
    return nil;
    
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"index:%ld",(long)indexPath.row);
//    if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row)
//    {
//         NSLog(@"indexpath:%ld",(long)indexPath.row);
//    }
// //   [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    
    if(indexPath.row == 0){
        return 44;
    }else if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row){
        
        if (isexpanded)
            return 400;
        return 70;
    }else if(extraPostion == indexPath.row){
        return 44;
    }else if (overRunRatePostion == indexPath.row){
        return 44;
    }else if (didNotBatPostion == indexPath.row){
        return 70;
    }else if (fallOfWktHeaderPostion == indexPath.row){
        return 44;
    }else if (fallOfWktPostion == indexPath.row){
        return 70;
    }else if(bowlerHeaderPosition == indexPath.row){
        return 44;
    }else if(indexPath.row >= bowlerPostion){
        return 70;
    }
    
    return 70;
}

-(IBAction)didClickSpiderWagonAction:(id)sender
{
    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    HVTableView* view = (HVTableView*) cell.superview;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
    int row = indexPath.row;
    
    NSLog(@"Indexpath = %d",row);
    
    
    self.batsmanCell.pitch_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.sectorWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.spiderWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
}

-(IBAction)didClickSectorWagonAction:(id)sender
{
   
    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    HVTableView* view = (HVTableView*) cell.superview;
     CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
    int row = indexPath.row;

     NSLog(@"Indexpath = %d",row);
    
    self.batsmanCell.pitch_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.spiderWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.sectorWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
        self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
    
}

-(IBAction)didClickpitchAction:(id)sender
{
    
    
    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    HVTableView* view = (HVTableView*) cell.superview;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
    int row = indexPath.row;
    
    NSLog(@"Indexpath = %d",row);
    
    NSLog(@"Indexpath = %@",indexPath);
    
        self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"pichmapRH"];
    
    self.batsmanCell.sectorWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.spiderWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.pitch_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];

  
}

-(IBAction)didClickonSideAction:(id)sender
{
    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    HVTableView* view = (HVTableView*) cell.superview;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
    
    if([cell.wagonPitch_img.image  isEqual: @"LHWagon"] || [cell.wagonPitch_img.image  isEqual: @"RHWagon"])
    {
        
    }
    
    else if ([cell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [cell.wagonPitch_img.image  isEqual: @"pichmapLH"])
    {
        
    }
}

-(IBAction)didClickOffSideAction:(id)sender
{
    
}

-(IBAction)didClick1sAction:(id)sender
{
    
}

-(IBAction)didClick2sAction:(id)sender
{
    
}
-(IBAction)didClick3sAction:(id)sender
{
    
}

-(IBAction)didClick4sAction:(id)sender
{
    
}

-(IBAction)didClick6sAction:(id)sender
{
    
}

-(void)teamLogo{


    NSMutableArray *mTeam = [[NSMutableArray alloc]init];
    [mTeam addObject:self.matchCode];
    [mTeam addObject:fetchScorecard.CURRENTBATTINGTEAMCODE];


    selectedPlayerFilterArray = [[NSMutableArray alloc]initWithArray: selectedPlayerArray];


    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,fetchScorecard.CURRENTBATTINGTEAMCODE];


    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
    UIImage *img;
    if(isFileExist){
        img = [UIImage imageWithContentsOfFile:pngFilePath];
        self.img_firstIngsTeamName.image = img;
    }else{
        img  = [UIImage imageNamed: @"no_image.png"];
        _img_firstIngsTeamName.image = img;
    }



    NSFileManager *fileManagerB = [NSFileManager defaultManager];
    NSString *docDirB = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePathB = [NSString stringWithFormat:@"%@/%@.png", docDirB,fetchScorecard.CURRENTBOWLINGTEAMCODE];
    BOOL isFileExistB = [fileManagerB fileExistsAtPath:pngFilePathB];
    UIImage *imgB;
    if(isFileExistB){
        imgB = [UIImage imageWithContentsOfFile:pngFilePathB];
        _img_secIngsTeamName.image = imgB;
    }else{
        imgB  = [UIImage imageNamed: @"no_image.png"];
        _img_secIngsTeamName.image = imgB;
    }
}



//Check given file name exist in document directory
- (BOOL) checkFileExist:(NSString*) fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
    return [fileManager fileExistsAtPath:filePath];
}


- (IBAction)btn_fst_inns_action:(id)sender {
    self.lbl_strip.constant=0;
    inningsNo = @"1";
    [self reloadScroeCard];
    
}
- (IBAction)btn_sec_inns_action:(id)sender {
    self.lbl_strip.constant=self.btn_sec_inns_id.frame.origin.x;
    inningsNo = @"2";
    [self reloadScroeCard];
}
- (IBAction)btn_third_inns_action:(id)sender {
    self.lbl_strip.constant=self.btn_third_inns_id.frame.origin.x;
    inningsNo = @"3";
    [self reloadScroeCard];
}
- (IBAction)btn_fourth_inns_action:(id)sender {
    self.lbl_strip.constant=self.btn_fourth_inns_id.frame.origin.x;
    inningsNo = @"4";
    [self reloadScroeCard];
}






-(void) reloadScroeCard{
    @try {
        fetchScorecard = [[FetchScorecard alloc]init];
        [fetchScorecard FetchScoreBoard:competitionCode :matchCode :inningsNo];
        //Set Table Cell Position
        batsmanHeaderPosition = 0;
        batsmanPostion =fetchScorecard.BattingSummaryForScoreBoard.count > 0 ? 1 :0;
        extraPostion = fetchScorecard.BattingSummaryForScoreBoard.count>0?fetchScorecard.BattingSummaryForScoreBoard.count+1:1;
        overRunRatePostion = extraPostion+1;
        didNotBatPostion = overRunRatePostion+1;
        
        
        BOOL isFOW = NO;
        for (BattingSummaryDetailsForScoreBoard *batSumryDtl in fetchScorecard.BattingSummaryForScoreBoard) {
            
            if(batSumryDtl.WICKETTYPE !=nil && ![batSumryDtl.WICKETTYPE isEqual:@"(null)"] && ![batSumryDtl.WICKETTYPE isEqual:@""]){
                isFOW = YES;
                break;
            }
        }
        fallOfWktHeaderPostion = isFOW?didNotBatPostion+1:0;
        fallOfWktPostion = isFOW?fallOfWktHeaderPostion+1:0;
        
        bowlerHeaderPosition =isFOW?fallOfWktPostion+1:didNotBatPostion+1;
        bowlerPostion = bowlerHeaderPosition+1;
        

        
        [self.table reloadData];
    }
    @catch (NSException *exception) {
    }
    
    
    
}
@end
