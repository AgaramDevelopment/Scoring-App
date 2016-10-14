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
#import "BattingPlayerStatistics.h"
#import "BattingPayerStatisticsRecord.h"
#import "BattingStatisticsPitchRecord.h"
#import "BowlingPlayerStatistics.h"
#import "BowlerStaticsRecord.h"
#import "BowlerStrickPitchRecord.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPAD_PRO (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)

@interface ScoreCardVC (){
    CustomNavigationVC *objCustomNavigation;
    BattingPlayerStatistics *objBattingPlayerStatistics;
    BowlingPlayerStatistics * objBowlingStatistics;
    NSString *wagonregiontext;
    NSString *regioncode;
    UIImageView * Img_ball;
    BOOL isPitch_Img;
    
    NSIndexPath *selectedIndexPath;
    UIView * ExpandBattingview;
    UIView * ExpandBowlerView;
    NSMutableArray * BatmanRunsArray;
    NSMutableArray * BowlerRunArray;
    int ThirdmanCount;
    int point;
    int cover;
    int longoff;
    int longon;
    int midWicket;
    int squareleg;
    int fineleg;
    
    
    UILabel * fineleg_lbl;
    UILabel * squareleg_lbl;
    UILabel * midWicket_lbl;
    UILabel * longon_lbl;
    UILabel * longoff_lbl;
    UILabel * cover_lbl;
    UILabel * point_lbl;
    UILabel * Thirdman_lbl;
    
    int ThirdmanCountRun;
    int pointRun;
    int coverRun;
    int longoffRun;
    int longonRun;
    int midWicketRun;
    int squarelegRun;
    int finelegRun;
    
    int battsmanIndex;
    //int bowlerIndex;
    
    int expendIndex;
    
    NSMutableArray * expendBattsmanCellArray;
    NSMutableArray * expendBowlerCellArray;

}
@property (strong, nonatomic) IBOutlet UILabel *cener_lbl;
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
    objBattingPlayerStatistics =[[BattingPlayerStatistics alloc]init];
    objBowlingStatistics       =[[BowlingPlayerStatistics alloc]init];
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
-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath {
    
    
    selectedIndexPath=indexPath;
    expendIndex =indexPath.row;
    
    NSLog(@"expandindex=%d",expendIndex);
    

    //UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIView * expendbattingview = (UIView *)[cell viewWithTag:10];
    
     UIView * expendbowlerview = (UIView *)[cell viewWithTag:11];
    
    expendbattingview.alpha = 0;
    expendbattingview.hidden = NO;
    
    expendbowlerview.alpha = 0;
    expendbowlerview.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        
        expendbattingview.alpha = 1;
         expendbowlerview.alpha = 1;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }];
    
    if(batsmanPostion <= expendIndex && extraPostion> expendIndex){
        
        
        //expendBowlerCellArray =[[NSMutableArray alloc]init];
        //BatmanRunsArray =[[NSMutableArray alloc]init];
        
        BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:expendIndex-1];
        expendBattsmanCellArray =[objBattingPlayerStatistics GetFETCHSBBATTINGPLAYERSTATISTICSWagon :competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BATSMANCODE];
        
        BatmanRunsArray =[objBattingPlayerStatistics GetFETCHSBBATTINGPLAYERSTATISTICSPitch :competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BATSMANCODE];
        self.BatmenStyle=battingSummaryDetailsForSB.BATTINGSTYLE;
        
       
    [self.batsmanCell.spiderWagon_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    else if(expendIndex >= bowlerPostion){
        
       // expendBowlerCellArray=[[NSMutableArray alloc]init];
       // BowlerRunArray =[[NSMutableArray alloc]init];
        
        BowlingSummaryDetailsForScoreBoard *bowlingSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:expendIndex-bowlerPostion];
       expendBowlerCellArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];
        
        BowlerRunArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSPitch:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];
        
        
        
        [self.bowlerCell.BowlerspiderWagon_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
   // [tableView reloadData];
}

//perform your collapse stuff (may include animation) for cell here. It will be called when the user touches an expanded cell so it gets collapsed or the table is in the expandOnlyOneCell satate and the user touches another item, So the last expanded item has to collapse
-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
   
    NSLog(@"collapse=%d",indexPath.row);
    
    UIView *expendBatmanview = (UIButton *)[cell viewWithTag:10];
    UIView * expendbowlerview = (UIView *)[cell viewWithTag:11];
    [UIView animateWithDuration:.5 animations:^{
       
        expendBatmanview.alpha = 0;
        expendbowlerview.alpha=0;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(-3.14);
    } completion:^(BOOL finished) {
        expendBatmanview.hidden = YES;
        expendbowlerview.hidden=YES;
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
        
        if(isPitch_Img ==NO)
        {
            self.batsmanCell.pitchMap_img.hidden=YES;
        }
        
        ExpandBattingview = (UIView *)[cell viewWithTag:10];
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
        
        [cell.WangonAll_Btn addTarget:self action:@selector(didClickAll_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //
        

        
        
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
        if (isExpanded== NO) //prepare the cell as if it was collapsed! (without any animation!)
        {
            //[cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
            ExpandBattingview.hidden = YES;
            // [cell.spiderWagon_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            
        }
        else ///prepare the cell as if it was expanded! (without any animation!)
        {
            ExpandBattingview.hidden = NO;
            
            

        }
        
        
        if([battingSummaryDetailsForSB.BATTINGSTYLE isEqualToString:@"MSC012"])
        {
            
            //self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
            self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
            
        }
        else
        {
            
            self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
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
        //bowlerIndex = indexPath.row-bowlerPostion;
        
        ScoreCardCellTVCell *bowlerCellTvc = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:bowlerCell];
        if (bowlerCellTvc == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            bowlerCellTvc = self.bowlerCell;
            //self.bowlerCell = nil;
        }
        
        if(isPitch_Img ==NO)
        {
            self.bowlerCell.BowlerwagonPitch_img.hidden=YES;
        }
        
         ExpandBowlerView = (UIView *)[bowlerCellTvc viewWithTag:11];
        
        [bowlerCellTvc.BowlerspiderWagon_Btn addTarget:self action:@selector(didClickBowlingSpiderWagonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.BowlersectorWagon_Btn addTarget:self action:@selector(didClickBowlingSectorWagonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.Bowlerpitch_Btn addTarget:self action:@selector(didClickBowlingpitchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.BowleronSide_Btn addTarget:self action:@selector(didClickBowlingonSideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.BowleroffSide_Btn addTarget:self action:@selector(didClickBowlingOffSideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.Bowlerwangon1s_Btn addTarget:self action:@selector(didClickBowling1sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.Bowlerwangon2s_Btn addTarget:self action:@selector(didClickBowling2sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.Bowlerwangon3s_Btn addTarget:self action:@selector(didClickBowling3sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.Bowlerwangon4s_Btn addTarget:self action:@selector(didClickBowling4sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [bowlerCellTvc.Bowlerwangon6s_Btn addTarget:self action:@selector(didClickBowling6sAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (!isExpanded) //prepare the cell as if it was collapsed! (without any animation!)
        {
            //[cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
            ExpandBowlerView.hidden = YES;
            
            //[bowlerCellTvc.BowlerspiderWagon_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else ///prepare the cell as if it was expanded! (without any animation!)
        {
            ExpandBowlerView.hidden = NO;
            
            
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"index:%ld",(long)indexPath.row);
//    if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row)
//    {
//         NSLog(@"indexpath:%ld",(long)indexPath.row);
//    }
// //   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    
    if(indexPath.row == 0){
        return 44;
    }else if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row){
        
        if (indexPath == selectedIndexPath && isexpanded==YES)
        {
            ExpandBattingview.hidden=NO;
            return 550;
        }
        else{
             ExpandBattingview.hidden=YES;
           return 70;
        }
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
        
        if (indexPath == selectedIndexPath && isexpanded== YES)
        {
            ExpandBowlerView.hidden=NO;
            return 550;
        }
        else{
            ExpandBowlerView.hidden=YES;
            return 70;
        }
    }
    
    return 70;
}

-(IBAction)didClickSpiderWagonAction:(id)sender
{
    isPitch_Img = NO;
    
    
    //ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    
//    HVTableView* view = (HVTableView*) cell.superview;
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
//    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
//    int row = indexPath.section;
//    
//    NSLog(@"Indexpath = %d",row);
    
    self.batsmanCell.pitch_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.sectorWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.spiderWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    
    self.batsmanCell.pitchMap_img.hidden=YES;
    self.batsmanCell.wagonPitch_img.hidden=NO;
    fineleg_lbl.hidden =YES;
    squareleg_lbl.hidden =YES;
    midWicket_lbl.hidden=YES;
    longon_lbl.hidden =YES;
    longoff_lbl.hidden =YES;
    cover_lbl.hidden =YES;
    point_lbl.hidden =YES;
    Thirdman_lbl.hidden =YES;
    
//  BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:expendIndex-1];
//  NSMutableArray * objArray =[objBattingPlayerStatistics GetFETCHSBBATTINGPLAYERSTATISTICSWagon :competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BATSMANCODE];
    
   // int drawlincount =0;
//    for(int i=0; i<objArray.count;i++)
//    {
//        BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[objArray objectAtIndex:i];
//        
//        if(objRecord.SECTORREGIONCODE!=nil && ![objRecord.SECTORREGIONCODE isEqualToString:@""])
//        {
//            drawlincount++;
//        }
//    }
    
    NSString * line1 = (expendBattsmanCellArray.count ==1)?@"1s | 6":@"0s | 6";
    NSString * line2 =(expendBattsmanCellArray.count ==2)? @"2s | 6":@"0s | 6";
    NSString * line3 = (expendBattsmanCellArray.count ==3)?@"3s | 6":@"0s | 6";
    NSString * line4 =  (expendBattsmanCellArray.count ==4)?@"4s | 6":@"0s | 6";
    NSString * line5 = (expendBattsmanCellArray.count ==5)?@"5s | 6":@"0s | 6";
    
    
    [self.batsmanCell.BowlerWangonAll_Btn setTitle:@"All" forState:UIControlStateNormal];
    [self.batsmanCell.wangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon2s_Btn setTitle:line2 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon3s_Btn setTitle:line3 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon6s_Btn setTitle:line5 forState:UIControlStateNormal];
    

    
    
    
    if([self.BatmenStyle isEqualToString:@"MSC012"])
    {
      
        //self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
        self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
        
    }
    else
    {
        
        self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
    }
    

    int x1position;
    int x2position;
    int y1position;
    int y2position;
    
    for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers) {
        if ([layer.name isEqualToString:@"DrawLine"]) {
              [layer removeFromSuperlayer];
            break;
        }
    }
    
    for(int i=0; i<expendBattsmanCellArray.count;i++)
    {
        BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
        x1position = [objRecord.WWX1 intValue];
        y1position = [objRecord.WWY1 intValue];
        x2position  =[objRecord .WWX2 intValue];
        y2position  =[objRecord.WWY2 intValue];
        
        
    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
        
        
//        for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers) {
//            if ([layer.name isEqualToString:@"DrawLine"]) {
//              //  [layer removeFromSuperlayer];
//                break;
//            }
//        }
        
        //CGPoint p = [sender locationInView:self.batsmanCell.wagonPitch_img];
        int Xposition = x1position+28;
        int Yposition = y1position;
        CGMutablePathRef straightLinePath = CGPathCreateMutable();
        CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
        CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = straightLinePath;
        UIColor *fillColor = [UIColor redColor];
        shapeLayer.fillColor = fillColor.CGColor;
        UIColor *strokeColor = [UIColor redColor];
        shapeLayer.strokeColor = strokeColor.CGColor;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.fillRule = kCAFillRuleNonZero;
        shapeLayer.name = @"DrawLine";
        [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
        
    }
    }
    
}

-(IBAction)didClickSectorWagonAction:(id)sender
{
    isPitch_Img = NO;
   
   // ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    //HVTableView* view = (HVTableView*) cell.superview;
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
//   // NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
//    //int row = indexPath.row;
//
//    // NSLog(@"Indexpath = %d",row);
     self.batsmanCell.wagonPitch_img.hidden=NO;
     self.batsmanCell.pitchMap_img.hidden=YES;
    
    if(fineleg_lbl != nil)
    {
        [fineleg_lbl removeFromSuperview];
    }
   
   if(squareleg_lbl != nil)
    {
        [squareleg_lbl removeFromSuperview];
    }
    
    if(midWicket_lbl != nil)
    {
        [midWicket_lbl removeFromSuperview];
    }
   
     if(longon_lbl != nil)
    {
        [longon_lbl removeFromSuperview];
    }
    
     if(longoff_lbl != nil)
    {
        [longoff_lbl removeFromSuperview];
    }
    
     if(cover_lbl != nil)
    {
        [cover_lbl removeFromSuperview];
    }
     if(point_lbl != nil)
    {
        [point_lbl removeFromSuperview];
    }
     if(Thirdman_lbl != nil)
    {
        [Thirdman_lbl removeFromSuperview];
    }
    
    
   // Thirdman_lbl.hidden =NO;
    
    self.batsmanCell.pitch_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.spiderWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.sectorWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
        self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"Sector_Img"];
    
//    BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:expendIndex-1];
//    NSMutableArray * objArray =[objBattingPlayerStatistics GetFETCHSBBATTINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BATSMANCODE];
    
    int x1position;
    int x2position;
    int y1position;
    int y2position;
    
    
    
    
    finelegRun =0;
    squarelegRun=0;
    midWicketRun=0;
    longonRun=0;
    longoffRun=0;
    coverRun =0;
    pointRun=0;
    ThirdmanCountRun=0;



    for(int i=0; i<expendBattsmanCellArray.count;i++)
    {
        
        fineleg_lbl.hidden =NO;
        squareleg_lbl.hidden =NO;
        midWicket_lbl.hidden=NO;
        longon_lbl.hidden =NO;
        longoff_lbl.hidden =NO;
        cover_lbl.hidden =NO;
        point_lbl.hidden =NO;
        Thirdman_lbl.hidden =NO;
        
        
        BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
        x1position = [objRecord.WWX1 intValue];
        y1position = [objRecord.WWY1 intValue];
        x2position  =[objRecord .WWX2 intValue];
        y2position  =[objRecord.WWY2 intValue];
    
    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
        
        
        for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers) {
            if ([layer.name isEqualToString:@"DrawLine"]) {
                [layer removeFromSuperlayer];
                break;
            }
        }
        [self sectorWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
        
//        CGMutablePathRef straightLinePath = CGPathCreateMutable();
//        CGPathMoveToPoint(straightLinePath, NULL, x1position, y1position);
//        CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        shapeLayer.path = straightLinePath;
//        UIColor *fillColor = [UIColor redColor];
//        shapeLayer.fillColor = fillColor.CGColor;
//        UIColor *strokeColor = [UIColor redColor];
//        shapeLayer.strokeColor = strokeColor.CGColor;
//        shapeLayer.lineWidth = 2.0f;
//        shapeLayer.fillRule = kCAFillRuleNonZero;
//        shapeLayer.name = @"DrawLine";
//        [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
        
    }
    }

}

-(IBAction)didClickpitchAction:(id)sender
{
    isPitch_Img = YES;
   

//    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
//    HVTableView* view = (HVTableView*) cell.superview;
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
//    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
//    int row = indexPath.row;
//    
//    NSLog(@"Indexpath = %d",row);
    
    self.batsmanCell.sectorWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.spiderWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.pitch_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];

    self.batsmanCell.wagonPitch_img.hidden=YES;
    self.batsmanCell.pitchMap_img.hidden=NO;
    
    if(Img_ball != nil)
    {
        [Img_ball removeFromSuperview];
    }
    
 //BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:expendIndex-1];
    if([self.BatmenStyle isEqualToString:@"MSC013"])
    {
        self.batsmanCell.pitchMap_img.image=[UIImage imageNamed:@"pichmapRH"];
        
    }
    else{
        
        self.batsmanCell.pitchMap_img.image=[UIImage imageNamed:@"pichmapLH"];
        
    }

   // BatmanRunsArray =[objBattingPlayerStatistics GetFETCHSBBATTINGPLAYERSTATISTICSPitch :competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BATSMANCODE];
    
    NSString * line1 = (BatmanRunsArray.count ==1)?@"1s | 6":@"0s | 6";
    
    NSString * line2 = (BatmanRunsArray.count ==2)?@"2s | 6":@"0s | 6";
    
    NSString * line3 = (BatmanRunsArray.count ==3)?@"3s | 6":@"0s | 6";
    
    NSString * line4 = (BatmanRunsArray.count ==4)?@"4s | 6":@"0s | 6";
    
    NSString * line5 = (BatmanRunsArray.count ==5)?@"5s | 6":@"0s | 6";
    
    
    [self.batsmanCell.WangonAll_Btn setTitle:@"ALL" forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon2s_Btn setTitle:line2 forState:UIControlStateNormal];

    [self.batsmanCell.wangon3s_Btn setTitle:line3 forState:UIControlStateNormal];

    [self.batsmanCell.wangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon6s_Btn setTitle:line5 forState:UIControlStateNormal];

    
    
    
    int xposition;
    int yposition;

    for(int i=0; i<BatmanRunsArray.count;i++)
    {
        BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMy2 intValue];
        
    if(!(xposition == 1 && yposition ==1)){
        
        
//        if(Img_ball != nil)
//        {
//            [Img_ball removeFromSuperview];
//        }
//
        Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
        Img_ball.image =[UIImage imageNamed:@"RedBall"];
        [self.batsmanCell.pitchMap_img addSubview:Img_ball];
        
        
    }
    }
  
}

-(IBAction)didClickonSideAction:(id)sender
{
    
    isPitch_Img = NO;
    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    HVTableView* view = (HVTableView*) cell.superview;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
    
    int row = indexPath.row;
    if([self.batsmanCell.wagonPitch_img.image  isEqual: @"LHWagon"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"RHWagon"])
    {
        
    }
    
    else if ([self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapLH"])
    {
        
    }
}

-(IBAction)didClickOffSideAction:(id)sender
{
    
}


-(IBAction)didClickAll_BtnAction:(id)sender
{
    
    if(BatmanRunsArray.count > 0)
    {
        
        int xposition;
        int yposition;
        
        for(int i=0; i<BatmanRunsArray.count;i++)
        {
            
            BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMy2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                //        if(Img_ball != nil)
                //        {
                //            [Img_ball removeFromSuperview];
                //        }
                //
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+10,yposition-20,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                
            }
        }
        
    }

}

-(IBAction)didClick1sAction:(id)sender
{
    if(BatmanRunsArray.count==1)
    {
        
        int xposition;
        int yposition;
        
        
            BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMy2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                //        if(Img_ball != nil)
                //        {
                //            [Img_ball removeFromSuperview];
                //        }
                //
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+10,yposition-20,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                
            }
        }
else
{
    self.batsmanCell.wangon1s_Btn.titleLabel.text=@"0s| 6";
}
    
}

-(IBAction)didClick2sAction:(id)sender
{
    
    if(BatmanRunsArray.count==2)
    {
        
        int xposition;
        int yposition;
        
        for(int i=0; i<2;i++)
        {

        BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:0];
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMy2 intValue];
        
        if(!(xposition == 1 && yposition ==1)){
            
            
            //        if(Img_ball != nil)
            //        {
            //            [Img_ball removeFromSuperview];
            //        }
            //
            Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+10,yposition-20,20, 20)];
            Img_ball.image =[UIImage imageNamed:@"RedBall"];
            [self.batsmanCell.pitchMap_img addSubview:Img_ball];
            
        }
    }
    
    }
    else
    {
        self.batsmanCell.wangon2s_Btn.titleLabel.text=@"0s| 6";
    }

}
-(IBAction)didClick3sAction:(id)sender
{
    if(BatmanRunsArray.count==3)
    {
        
        int xposition;
        int yposition;
        
        for(int i=0; i< 3;i++)
        {
            
            BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMy2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                //        if(Img_ball != nil)
                //        {
                //            [Img_ball removeFromSuperview];
                //        }
                //
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+10,yposition-20,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                
            }
        }
        
    }
    else
    {
        self.batsmanCell.wangon3s_Btn.titleLabel.text=@"0s| 6";
    }

}

-(IBAction)didClick4sAction:(id)sender
{
    if(BatmanRunsArray.count==4)
    {
        
        int xposition;
        int yposition;
        
        for(int i=0; i<4;i++)
        {
            
            BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMy2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                //        if(Img_ball != nil)
                //        {
                //            [Img_ball removeFromSuperview];
                //        }
                //
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+10,yposition-20,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                
            }
        }
        
    }
    else
    {
        self.batsmanCell.wangon4s_Btn.titleLabel.text=@"0s| 6";
    }

}

-(IBAction)didClick6sAction:(id)sender
{
    if(BatmanRunsArray.count==5)
    {
        
        int xposition;
        int yposition;
        
        for(int i=0; i<5;i++)
        {
            
            BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMy2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                //        if(Img_ball != nil)
                //        {
                //            [Img_ball removeFromSuperview];
                //        }
                //
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+10,yposition-20,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                
            }
        }
        
    }
    else
    {
        self.batsmanCell.wangon6s_Btn.titleLabel.text=@"0s| 6";
    }

}
-(IBAction)didClickBowlingSpiderWagonAction:(id)sender
{
    
    isPitch_Img = NO;
    
    //ScoreCardCellTVCell *clickedCell = (ScoreCardCellTVCell *)[[sender superview] superview];
    //NSIndexPath *clickedButtonPath = [self.table indexPathForCell:clickedCell];
//    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
//    HVTableView* view = (HVTableView*) cell.superview;
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
//    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
//    int row = indexPath.row;
//    
//    NSLog(@"Indexpath = %d",row);
    self.bowlerCell.BowlerwagonPitch_img.hidden=YES;
    self.bowlerCell.wagonPitch_img.hidden=NO;

    fineleg_lbl.hidden =YES;
    squareleg_lbl.hidden =YES;
    midWicket_lbl.hidden=YES;
    longon_lbl.hidden =YES;
    longoff_lbl.hidden =YES;
    cover_lbl.hidden =YES;
    point_lbl.hidden =YES;
    Thirdman_lbl.hidden =YES;
    
    
    
    self.bowlerCell.Bowlerpitch_Btn.backgroundColor =[UIColor clearColor];
    self.bowlerCell.BowlersectorWagon_Btn.backgroundColor =[UIColor clearColor];
    self.bowlerCell.BowlerspiderWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    
    
    //BowlingSummaryDetailsForScoreBoard *bowlingSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:bowlerIndex];
    //NSMutableArray * objArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];
    
    if([self.BatmenStyle isEqualToString:@"MSC013"])
    {
        self.bowlerCell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
        
    }
    else{
        
        self.bowlerCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
        
    }

    
    
    int drawlincount =0;
    for(int i=0; i<expendBowlerCellArray.count;i++)
    {
        BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
        
        if(objRecord.Sectorregioncode!=nil && ![objRecord.Sectorregioncode isEqualToString:@""])
        {
            drawlincount++;
        }
    }
    NSString * line1=(drawlincount ==1)?@"1s | 6":@"0s | 6";
    NSString * line2 =(drawlincount ==2)?@"2s | 6":@"0s | 6";
    NSString * line3 =(drawlincount ==3)?@"3s | 6":@"0s | 6";
    NSString * line4 =(drawlincount ==4)?@"4s | 6":@"0s | 6";
    NSString * line5 =(drawlincount ==5)?@"5s | 6":@"0s | 6";
    
    [self.bowlerCell.BowlerWangonAll_Btn setTitle:@"ALL" forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon2s_Btn setTitle:line2 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon3s_Btn setTitle:line3 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon6s_Btn setTitle:line5 forState:UIControlStateNormal];
    

    for (CALayer *layer in self.bowlerCell.BowlerwagonPitch_img.layer.sublayers) {
        if ([layer.name isEqualToString:@"DrawLine"]) {
            [layer removeFromSuperlayer];
            
        }
    }
    
    int x1position;
    int x2position;
    int y1position;
    int y2position;
    for(int i=0; i<expendBowlerCellArray.count;i++)
    {
        BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
        x1position = [objRecord.WWX1 intValue];
        y1position = [objRecord.WWY1 intValue];
        x2position  =[objRecord .WWX2 intValue];
        y2position  =[objRecord.WWY2 intValue];
        
        
        if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
            
            
            for (CALayer *layer in self.bowlerCell.BowlerwagonPitch_img.layer.sublayers) {
                if ([layer.name isEqualToString:@"DrawLine"]) {
                    //[layer removeFromSuperlayer];
                    break;
                }
            }
            
            //CGPoint p = [sender locationInView:self.batsmanCell.wagonPitch_img];
            int Xposition = x1position+28;
            int Yposition = y1position;
            CGMutablePathRef straightLinePath = CGPathCreateMutable();
            CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
            CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = straightLinePath;
            UIColor *fillColor = [UIColor redColor];
            shapeLayer.fillColor = fillColor.CGColor;
            UIColor *strokeColor = [UIColor redColor];
            shapeLayer.strokeColor = strokeColor.CGColor;
            shapeLayer.lineWidth = 2.0f;
            shapeLayer.fillRule = kCAFillRuleNonZero;
            shapeLayer.name = @"DrawLine";
            [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
            
        }
    }
}

-(IBAction)didClickBowlingSectorWagonAction:(id)sender
{
//    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
//    HVTableView* view = (HVTableView*) cell.superview;
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
//    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
//    int row = indexPath.row;
//    
//
//    
//    NSLog(@"Indexpath = %d",row);
    self.bowlerCell.wagonPitch_img.hidden=NO;
    self.bowlerCell.BowlerwagonPitch_img.hidden=YES;
    
    
    
    self.bowlerCell.Bowlerpitch_Btn.backgroundColor =[UIColor clearColor];
    self.bowlerCell.BowlersectorWagon_Btn.backgroundColor =[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    self.bowlerCell.BowlerspiderWagon_Btn.backgroundColor=[UIColor clearColor];
    self.bowlerCell.wagonPitch_img.image=[UIImage imageNamed:@"Sector_Img"];

    
    //BowlingSummaryDetailsForScoreBoard *bowlerSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:bowlerIndex];
    //NSMutableArray * objArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :bowlerSummaryDetailsForSB.BOWLERCODE];
    
    int x1position;
    int x2position;
    int y1position;
    int y2position;
    
    
    if(fineleg_lbl != nil)
    {
        [fineleg_lbl removeFromSuperview];
    }
    
    else if(squareleg_lbl != nil)
    {
        [squareleg_lbl removeFromSuperview];
    }
    
    else if(midWicket_lbl != nil)
    {
        [midWicket_lbl removeFromSuperview];
    }
    
    else if(longon_lbl != nil)
    {
        [longon_lbl removeFromSuperview];
    }
    
    else if(longoff_lbl != nil)
    {
        [longoff_lbl removeFromSuperview];
    }
    
    else if(cover_lbl != nil)
    {
        [cover_lbl removeFromSuperview];
    }
    else if(point_lbl != nil)
    {
        [point_lbl removeFromSuperview];
    }
    else if(Thirdman_lbl != nil)
    {
        [Thirdman_lbl removeFromSuperview];
    }
    
    

    
//    fineleg =0;
//    squareleg=0;
//    midWicket=0;
//    longon=0;
//    longoff=0;
//    cover =0;
//    point=0;
//    ThirdmanCount=0;
    
    
    finelegRun =0;
    squarelegRun=0;
    midWicketRun=0;
    longonRun=0;
    longoffRun=0;
    coverRun =0;
    pointRun=0;
    ThirdmanCountRun=0;
    
//    for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers) {
//        if ([layer.name isEqualToString:@"DrawLine"]) {
//            [layer removeFromSuperlayer];
//           
//        }
//    }

    
    for(int i=0; i<expendBowlerCellArray.count;i++)
    {
        
        fineleg_lbl.hidden =NO;
        squareleg_lbl.hidden =NO;
        midWicket_lbl.hidden=NO;
        longon_lbl.hidden =NO;
        longoff_lbl.hidden =NO;
        cover_lbl.hidden =NO;
        point_lbl.hidden =NO;
        Thirdman_lbl.hidden =NO;
        
        
        BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
        x1position = [objRecord.WWX1 intValue];
        y1position = [objRecord.WWY1 intValue];
        x2position  =[objRecord .WWX2 intValue];
        y2position  =[objRecord.WWY2 intValue];
        
        if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
            
            
            for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers) {
                if ([layer.name isEqualToString:@"DrawLine"]) {
                    [layer removeFromSuperlayer];
                   break;
                }
            }
            [self BowlersectorWagonwheel :objRecord.Sectorregioncode :objRecord.Runs];

    
        }
    
   }

}

-(IBAction)didClickBowlingpitchAction:(id)sender
{
//    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
//    HVTableView* view = (HVTableView*) cell.superview;
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
//    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
//    int row = indexPath.row;
//    
//    NSLog(@"Indexpath = %d",row);
//    
//    NSLog(@"Indexpath = %@",indexPath);
    
    self.bowlerCell.BowlerwagonPitch_img.hidden=NO;
    self.bowlerCell.wagonPitch_img.hidden=YES;
    
    if([self.BatmenStyle isEqualToString:@"MSC013"])
    {
        //self.batsmanCell.pitchMap_img.image=[UIImage imageNamed:@"pichmapRH"];
        self.bowlerCell.BowlerwagonPitch_img.image=[UIImage imageNamed:@"pichmapRH"];

    }
    else{
        self.bowlerCell.BowlerwagonPitch_img.image=[UIImage imageNamed:@"pichmapLH"];

           }

    
    self.bowlerCell.Bowlerpitch_Btn.backgroundColor =[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    self.bowlerCell.BowlerspiderWagon_Btn.backgroundColor =[UIColor clearColor];
    self.bowlerCell.BowlersectorWagon_Btn.backgroundColor=[UIColor clearColor];
    //BowlingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:bowlerIndex];
  // BowlerRunArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSPitch:competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BOWLERCODE];
    
    NSString * line1 = (BowlerRunArray.count ==1)?@"1s | 6":@"0s | 6";
    NSString * line2 = (BowlerRunArray.count ==2)?@"2s | 6":@"0s | 6";
    NSString * line3 = (BowlerRunArray.count ==3)?@"3s | 6":@"0s | 6";
    NSString * line4 = (BowlerRunArray.count ==4)?@"4s | 6":@"0s | 6";
    NSString * line5 = (BowlerRunArray.count ==5)?@"5s | 6":@"0s | 6";
    
    [self.bowlerCell.BowlerWangonAll_Btn setTitle:@"ALL" forState:UIControlStateNormal];
    [self.bowlerCell.Bowlerwangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon2s_Btn setTitle:line2 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon3s_Btn setTitle:line3 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [self.bowlerCell.Bowlerwangon6s_Btn setTitle:line5 forState:UIControlStateNormal];
    
    
    
    if(Img_ball != nil)
    {
        [Img_ball removeFromSuperview];
    }
    
    int xposition;
    int yposition;
    
    for(int i=0; i<BowlerRunArray.count;i++)
    {
        BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMY2 intValue];
        
        if(!(xposition == 1 && yposition ==1)){
            
//            
//            if(Img_ball != nil)
//            {
//                [Img_ball removeFromSuperview];
//            }
            
            Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
            Img_ball.image =[UIImage imageNamed:@"RedBall"];
            [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
            
        }
    }

}

-(IBAction)didClickBowlingonSideAction:(id)sender
{
    
}

-(IBAction)didClickBowlingOffSideAction:(id)sender
{
    
}

-(IBAction)didClickBowling1sAction:(id)sender
{
    if(BowlerRunArray.count == 1)
    {
        int xposition;
        int yposition;
        
        
            BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMY2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                if(Img_ball != nil)
                {
                    [Img_ball removeFromSuperview];
                }
                
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                
            }
        }
        
}

-(IBAction)didClickBowling2sAction:(id)sender
{
    if(BowlerRunArray.count == 2)
    {
        int xposition;
        int yposition;
        
        for(int i=0; i<2;i++)
        {

        BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:0];
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMY2 intValue];
        
        if(!(xposition == 1 && yposition ==1)){
            
            
            if(Img_ball != nil)
            {
                [Img_ball removeFromSuperview];
            }
            
            Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
            Img_ball.image =[UIImage imageNamed:@"RedBall"];
            [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
            
        }
    }
    }

}
-(IBAction)didClickBowling3sAction:(id)sender
{
    if(BowlerRunArray.count == 3)
    {
        int xposition;
        int yposition;
        
        for(int i=0; i<3;i++)
        {
            
            BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMY2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                if(Img_ball != nil)
                {
                    [Img_ball removeFromSuperview];
                }
                
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                
            }
        }
    }

}

-(IBAction)didClickBowling4sAction:(id)sender
{
    if(BowlerRunArray.count == 4)
    {
        int xposition;
        int yposition;
        
        for(int i=0; i<4;i++)
        {
            
            BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMY2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                if(Img_ball != nil)
                {
                    [Img_ball removeFromSuperview];
                }
                
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                
            }
        }
    }

}

-(IBAction)didClickBowling6sAction:(id)sender
{
    if(BowlerRunArray.count == 5)
    {
        int xposition;
        int yposition;
        
        for(int i=0; i<5;i++)
        {
            
            BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:0];
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMY2 intValue];
            
            if(!(xposition == 1 && yposition ==1)){
                
                
                if(Img_ball != nil)
                {
                    [Img_ball removeFromSuperview];
                }
                
                Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
                Img_ball.image =[UIImage imageNamed:@"RedBall"];
                [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                
            }
        }
    }
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


//-(void)wagonwheel:(UIImageView *) wagonwheelImg :(int ) x1position :(int ) y1position :(int ) x2position :(int ) y2position
//
//{
//    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
//        
//        
//        for (CALayer *layer in wagonwheelImg.layer.sublayers) {
//            if ([layer.name isEqualToString:@"DrawLine"]) {
//                [layer removeFromSuperlayer];
//                break;
//            }
//        }
//        
//        CGMutablePathRef straightLinePath = CGPathCreateMutable();
//        CGPathMoveToPoint(straightLinePath, NULL, x1position, y1position);
//        CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        shapeLayer.path = straightLinePath;
//        UIColor *fillColor = [UIColor redColor];
//        shapeLayer.fillColor = fillColor.CGColor;
//        UIColor *strokeColor = [UIColor redColor];
//        shapeLayer.strokeColor = strokeColor.CGColor;
//        shapeLayer.lineWidth = 2.0f;
//        shapeLayer.fillRule = kCAFillRuleNonZero;
//        shapeLayer.name = @"DrawLine";
//        [wagonwheelImg.layer addSublayer:shapeLayer];
//        
//    }
//
//}


//-(void)pitchMap :(int) xposition :(int) yposition :(UIImageView *) pitchMap
//
//{
//    if(!(xposition == 1 && yposition ==1)){
//       
//        
//        if(Img_ball != nil)
//        {
//            [Img_ball removeFromSuperview];
//        }
//        
//        Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition,yposition,20, 20)];
//        Img_ball.image =[UIImage imageNamed:@"RedBall"];
//        [pitchMap addSubview:Img_ball];
//        
//    }
//
//}


-(void)sectorWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) batmanStyle :(NSString *) Run

{
    
    
    if([secotorwognwheelcode isEqualToString:@"MDT036"])
    {
//        if([batmanStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//           // fineleg++;
//            finelegRun = [Run intValue]+finelegRun;
//        }
//        else
//        {
//           // fineleg++;
//             NSLog(@"RH");
            finelegRun = [Run intValue]+finelegRun;
        //}
        
        if(fineleg_lbl !=nil)
        {
             [fineleg_lbl removeFromSuperview];
        }
        
        fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
        fineleg_lbl.textColor=[UIColor whiteColor];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        [self.batsmanCell.wagonPitch_img addSubview:fineleg_lbl];
       // self.batsmanCell.WangonAll_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",finelegRun];
        
         NSLog(@"fineleg=%d",fineleg);
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT037"])
    {
//        if([batmanStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//            //squareleg++;
//            squarelegRun =squarelegRun+[Run intValue];
//        }
//        else
//        {
//            NSLog(@"RH");
//            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
        //}
        
        if(squareleg_lbl !=nil)
        {
            [squareleg_lbl removeFromSuperview];
        }
        
        squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(300,110,35, 35)];
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [self.batsmanCell.wagonPitch_img addSubview:squareleg_lbl];
        // self.batsmanCell.wangon1s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",squarelegRun];
         NSLog(@"squareleg=%d",squareleg);
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT038"])
    {
//        if([batmanStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//            ///midWicket++;
//            midWicketRun =midWicketRun+[Run intValue];
//        }
//        else
//        {
//            NSLog(@"RH");
            //midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
       // }
        
        if(midWicket_lbl !=nil)
        {
            [midWicket_lbl removeFromSuperview];
        }

        
        midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [self.batsmanCell.wagonPitch_img addSubview:midWicket_lbl];
     //   self.batsmanCell.wangon2s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",midWicketRun];
         NSLog(@"%d",midWicket);
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT039"])
    {
//        if([batmanStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//           // longon++;
//            longonRun =longonRun+[Run intValue];
//        }
//        else
//        {
//            NSLog(@"RH");
//longon++;
            longonRun =longonRun+[Run intValue];
        //}
        
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }
        
         longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(250,250,35, 35)];
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [self.batsmanCell.wagonPitch_img addSubview:longon_lbl];
        // self.batsmanCell.wangon3s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longonRun];
         NSLog(@"%d",longon);
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT041"])
    {
//        if([batmanStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//           // longoff++;
//            longoffRun =longoffRun +[Run intValue];
//        }
//        else
//        {
//            NSLog(@"RH");
           // longoff++;
            longoffRun =longoffRun +[Run intValue];
        //}
        
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }
        
        longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(100,190,35, 35)];
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        [self.batsmanCell.wagonPitch_img addSubview:longoff_lbl];
       // self.batsmanCell.wangon4s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longoffRun];

         NSLog(@"%d",longoff);
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT042"])
    {
        //if([batmanStyle isEqualToString:@"MSC012"])
        //{
//            NSLog(@"LH");
//            //cover++;
//            coverRun = coverRun+[Run intValue];
//        }
//        else
//        {
//            NSLog(@"RH");
//           // cover++;
            coverRun = coverRun+[Run intValue];
    //    }
        
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
        
        cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(100,150,35, 35)];
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [self.batsmanCell.wagonPitch_img addSubview:cover_lbl];
        // self.batsmanCell.wangon6s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",coverRun];
         NSLog(@"%d",cover);
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT043"])
    {
//        if([batmanStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//           // point++;
//            pointRun = pointRun+[Run intValue];
//
//        }
//        else
//        {
//            NSLog(@"RH");
//            //point++;
            pointRun = pointRun+[Run intValue];
        //}
        
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }

        
        point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [self.batsmanCell.wagonPitch_img addSubview:point_lbl];
         NSLog(@"%d",point);
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT044"])
    {
//        if([batmanStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//           // ThirdmanCount++;
//            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
//        }
//        else
//        {
//            NSLog(@"RH");
//            //ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];

            
       // }
        
        
        if(Thirdman_lbl !=nil)
        {
            [Thirdman_lbl removeFromSuperview];
        }
        
        Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [self.batsmanCell.wagonPitch_img addSubview:Thirdman_lbl];
        NSLog(@"%d",ThirdmanCount);
    }
    
    [self.batsmanCell.WangonAll_Btn setTitle:[NSString stringWithFormat:@"%d",finelegRun] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon1s_Btn setTitle:[NSString stringWithFormat:@"%d",squarelegRun] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon2s_Btn setTitle:[NSString stringWithFormat:@"%d",midWicketRun] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon3s_Btn setTitle:[NSString stringWithFormat:@"%d",longonRun] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon4s_Btn setTitle:[NSString stringWithFormat:@"%d",longoffRun] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon6s_Btn setTitle:[NSString stringWithFormat:@"%d",coverRun] forState:UIControlStateNormal];
    

}

-(void)BowlersectorWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) Run
        
        {
            
            if([secotorwognwheelcode isEqualToString:@"MDT036"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                    NSLog(@"LH");
//                    fineleg++;
                    finelegRun = [Run intValue]+finelegRun;
//                }
//                else
//                {
//                    fineleg++;
//                    NSLog(@"RH");
//                    finelegRun = [Run intValue]+finelegRun;
//                }
                
                if(fineleg_lbl !=nil)
                {
                    [fineleg_lbl removeFromSuperview];
                }
                
                fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
                fineleg_lbl.textColor=[UIColor whiteColor];
                fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
                [self.bowlerCell.wagonPitch_img addSubview:fineleg_lbl];
               // self.bowlerCell.BowlerWangonAll_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",finelegRun];
                
                NSLog(@"fineleg=%d",fineleg);
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT037"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                    NSLog(@"LH");
//                    squareleg++;
//                    squarelegRun =squarelegRun+[Run intValue];
//                }
//                else
//                {
//                    NSLog(@"RH");
//                    squareleg++;
                    squarelegRun =squarelegRun+[Run intValue];
                //}
                
                if(squareleg_lbl !=nil)
                {
                    [squareleg_lbl removeFromSuperview];
                }

                squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(300,110,35, 35)];
                squareleg_lbl.textColor=[UIColor whiteColor];
                squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
                [self.bowlerCell.wagonPitch_img addSubview:squareleg_lbl];
                //self.bowlerCell.Bowlerwangon1s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",squarelegRun];
                NSLog(@"squareleg=%d",squareleg);
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT038"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                   NSLog(@"LH");
//                    midWicket++;
//                    midWicketRun =midWicketRun+[Run intValue];
//                }
//                else
//                {
//                    NSLog(@"RH");
//                    midWicket++;
                    midWicketRun =midWicketRun+[Run intValue];
                //}
                if(midWicket_lbl !=nil)
                {
                    [midWicket_lbl removeFromSuperview];
                }
                
                midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
                midWicket_lbl.textColor=[UIColor whiteColor];
                midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
                [self.bowlerCell.wagonPitch_img addSubview:midWicket_lbl];
                //self.bowlerCell.Bowlerwangon2s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",midWicketRun];
                NSLog(@"%d",midWicket);
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT039"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                    NSLog(@"LH");
//                    longon++;
//                    longonRun =longonRun+[Run intValue];
//                }
//                else
//                {
//                    NSLog(@"RH");
//                    longon++;
                    longonRun =longonRun+[Run intValue];
                //}
                if(longon_lbl !=nil)
                {
                    [longon_lbl removeFromSuperview];
                }
                longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(250,250,35, 35)];
                longon_lbl.textColor=[UIColor whiteColor];
                longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
                [self.bowlerCell.wagonPitch_img addSubview:longon_lbl];
               // self.bowlerCell.Bowlerwangon3s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longonRun];
                NSLog(@"%d",longon);
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT041"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                    NSLog(@"LH");
//                    longoff++;
//                    longoffRun =longoffRun +[Run intValue];
//                }
//                else
//                {
//                    NSLog(@"RH");
//                    longoff++;
                    longoffRun =longoffRun +[Run intValue];
               // }
                
                if(longoff_lbl !=nil)
                {
                    [longoff_lbl removeFromSuperview];
                }
                
                longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(100,190,35, 35)];
                longoff_lbl.textColor=[UIColor whiteColor];
                longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
                [self.bowlerCell.wagonPitch_img addSubview:longoff_lbl];
                //self.bowlerCell.Bowlerwangon4s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longoffRun];
                
                NSLog(@"%d",longoff);
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT042"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                    NSLog(@"LH");
//                    cover++;
//                    coverRun = coverRun+[Run intValue];
//                }
//                else
//                {
                   // NSLog(@"RH");
                    //cover++;
                    coverRun = coverRun+[Run intValue];
               // }
                
                if(cover_lbl !=nil)
                {
                    [cover_lbl removeFromSuperview];
                }

                cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(100,150,35, 35)];
                cover_lbl.textColor=[UIColor whiteColor];
                cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
                [self.bowlerCell.wagonPitch_img addSubview:cover_lbl];
                //self.bowlerCell.Bowlerwangon6s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",coverRun];
                NSLog(@"%d",cover);
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT043"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                    NSLog(@"LH");
//                    point++;
//                }
//                else
//                {
//                    NSLog(@"RH");
//                    point++;
//                }
                pointRun=pointRun+[Run intValue];
                
                if(point_lbl !=nil)
                {
                    [point_lbl removeFromSuperview];
                }
                point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
                point_lbl.textColor=[UIColor whiteColor];
                point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
                [self.bowlerCell.wagonPitch_img addSubview:point_lbl];
                NSLog(@"%d",point);
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT044"])
            {
//                if([self.BatmenStyle isEqualToString:@"MSC012"])
//                {
//                    NSLog(@"LH");
//                    ThirdmanCount++;
//                    th
//                }
//                else
//                {
//                    NSLog(@"RH");
                    //ThirdmanCount++;
                ThirdmanCountRun=ThirdmanCountRun+[Run intValue];
                    
           //     }
                
                if(Thirdman_lbl !=nil)
                {
                    [Thirdman_lbl removeFromSuperview];
                }
                
                Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
                Thirdman_lbl.textColor=[UIColor whiteColor];
                Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
                [self.bowlerCell.wagonPitch_img addSubview:Thirdman_lbl];
                NSLog(@"%d",ThirdmanCount);
            }
            
            [self.bowlerCell.BowlerWangonAll_Btn setTitle:[NSString stringWithFormat:@"%d",finelegRun] forState:UIControlStateNormal];
            
           [self.bowlerCell.Bowlerwangon1s_Btn setTitle:[NSString stringWithFormat:@"%d",squarelegRun] forState:UIControlStateNormal];
            
            [self.bowlerCell.Bowlerwangon2s_Btn setTitle:[NSString stringWithFormat:@"%d",midWicketRun] forState:UIControlStateNormal];
            
            [self.bowlerCell.Bowlerwangon3s_Btn setTitle:[NSString stringWithFormat:@"%d",longonRun] forState:UIControlStateNormal];
            
          [self.bowlerCell.Bowlerwangon4s_Btn setTitle:[NSString stringWithFormat:@"%d",longoffRun] forState:UIControlStateNormal];
            
            [self.bowlerCell.Bowlerwangon6s_Btn setTitle:[NSString stringWithFormat:@"%d",coverRun] forState:UIControlStateNormal];

        }


@end
