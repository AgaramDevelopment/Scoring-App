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
#import "AppDelegate.h"
#import "DBManagerBatsmanInOutTime.h"
#import "CommentaryVC.h"
#import "SpiderWagonReportVC.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPAD_PRO (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)

#define DEGREES_RADIANS(angle) ((angle) / 90.0 * M_PI)


@interface ScoreCardVC (){
    CustomNavigationVC *objCustomNavigation;
    BattingPlayerStatistics *objBattingPlayerStatistics;
    BowlingPlayerStatistics * objBowlingStatistics;
    NSString *wagonregiontext;
    NSString *regioncode;
    UIButton * Img_ball;
    BOOL isPitch_Img;
    
    NSIndexPath *selectedIndexPath;
    UIView * ExpandBattingview;
    UIView * ExpandBowlerView;
    NSMutableArray * BatmanRunsArray;
    NSMutableArray * BowlerRunArray;
    int zerocount;
    int Run1Count;
    int Run2Count;
    int Run3Count;
    int Run4Count;
    int Run6Count;
    
    
    
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
  
    
    int expendIndex;
    
    NSMutableArray * expendBattsmanCellArray;
    NSMutableArray * expendBowlerCellArray;
    
    CommentaryVC *cmntryView;
    SpiderWagonReportVC *spiderView;


    
    BOOL isSectorEnableBatsman;
    BOOL isSectorEnableBowler;
    BOOL isScrollheight;
    CGFloat tableheight;

    BOOL isFirstInn;
    BOOL isSecInn;
    BOOL isThirdInn;
    BOOL isFourthInn;
    BOOL isDone;
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

BOOL isReadMoreButtonTouched = NO;
int indexOfReadMoreButton = -1;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.table.HVTableViewDataSource = self;
    //self.table.HVTableViewDelegate = self;
    objBattingPlayerStatistics =[[BattingPlayerStatistics alloc]init];
    objBowlingStatistics       =[[BowlingPlayerStatistics alloc]init];
    muliteDayMatchtype =[[NSArray alloc]initWithObjects:@"MSC023",@"MSC114", nil];
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setScrollEnabled:YES];
    
    [self customnavigationmethod];
    
    [self scoreDetailsColorChange];
 
    //self.matchTypeCode = @"MSC115";
    
    
    fetchScorecard = [[FetchScorecard alloc]init];
    [fetchScorecard FetchScoreBoard:competitionCode :matchCode :inningsNo];
    
     fetchSEpage = [[FetchSEPageLoadRecord alloc]init];
    [fetchSEpage fetchSEPageLoadDetails:competitionCode :matchCode];
    
    //FOR BATSMAN DURATION 
    for (BattingSummaryDetailsForScoreBoard *batSumryDtl in fetchScorecard.BattingSummaryForScoreBoard) {
        
        DBManagerBatsmanInOutTime     *dbmanagerBatsmanInOutTime = [[DBManagerBatsmanInOutTime alloc]init];
       batSumryDtl.DURATION = [dbmanagerBatsmanInOutTime FETCHDURATION:competitionCode :matchCode :inningsNo :batSumryDtl.BATSMANCODE];
        
        
    }
    
    
    
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
    
    int rows = fetchScorecard.BowlingSummaryForScoreBoard.count+
    fetchScorecard.BattingSummaryForScoreBoard.count+
    (fallOfWktHeaderPostion==0?0:1) + (fallOfWktPostion==0?0:1) + 5;

    arrayForBool=[[NSMutableArray alloc]init];
    for (int i=0; i< rows; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    //self.fstInnShortName =fetchSEpage.FIRSTINNINGSSHORTNAME;
   // self.secInnShortName = fetchSEpage.BOWLTEAMSHORTNAME;
   // self.thrdInnShortName=fetchSEpage.FIRSTINNINGSSHORTNAME;
    //self.frthInnShortName =fetchSEpage.BOWLTEAMSHORTNAME;
    [self setInningsBySelection:@"1"];
    [self setInningsView];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.view layoutIfNeeded];
     //[self.backScroll setContentSize:CGSizeMake(self.table.frame.size.width, self.tblView_Height.constant)];
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
-(IBAction)batsmancellExpand:(id)sender
{
    UIButton *readMoreButton = (UIButton *)sender;

    
    if(indexOfReadMoreButton != -1)
        
    {
        indexOfReadMoreButton =-1;
        [self.table reloadData];

    }
    else{
    indexOfReadMoreButton = readMoreButton.tag;
    
   
//    else{
       isReadMoreButtonTouched=YES;
    //}
    BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:indexOfReadMoreButton-1];
        self.BatmenStyle = battingSummaryDetailsForSB.BATTINGSTYLE;
    expendBattsmanCellArray =[objBattingPlayerStatistics GetFETCHSBBATTINGPLAYERSTATISTICSWagon :competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BATSMANCODE];
    
    BatmanRunsArray =[objBattingPlayerStatistics GetFETCHSBBATTINGPLAYERSTATISTICSPitch :competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BATSMANCODE];
  
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
        
        [self.table reloadData];
        [cell.spiderWagon_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];

    }
    
//    [self.table beginUpdates];
//    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfReadMoreButton inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.table endUpdates];
    
}

-(IBAction) bowlerExpand:(id)sender
{
    UIButton *readMoreButton = (UIButton *)sender;
    
    if(indexOfReadMoreButton != -1)
        
    {
        indexOfReadMoreButton =-1;
        [self.table reloadData];

    }
    else{
        indexOfReadMoreButton = readMoreButton.tag;
    
    
    //indexOfReadMoreButton = readMoreButton.tag;
    isReadMoreButtonTouched=YES;
    
    
    BowlingSummaryDetailsForScoreBoard *bowlingSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:indexOfReadMoreButton-bowlerPostion];
        
    self.BatmenStyle = @"MSC013";

    expendBowlerCellArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];
    
    BowlerRunArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSPitch:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];

    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
        [self.table reloadData];
        [cell.BowlerspiderWagon_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];

    }
    
//    [self.table beginUpdates];
//    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfReadMoreButton inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.table endUpdates];
    }
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static NSString *cellid=@"hello";
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
            }
            else if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row){//Batsman display
                BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:indexPath.row - 1];
        
                ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:batsmanCell];
                if (cell == nil) {
        
                    [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
                    cell = self.batsmanCell;
                   // self.batsmanCell = nil;
        
        
                }
//                if(isPitch_Img ==NO)
//                {
//                    self.batsmanCell.pitchMap_img.hidden=YES;
//                }
                //ExpandBattingview = (UIView *)[cell viewWithTag:10];
                
                [[cell btn_expand] setTag:[indexPath row]];
                NSLog(@"btn%ld",(long)cell.btn_expand.tag);
                 [[cell sectorWagon_Btn] setTag:[indexPath row]];
                 [[cell spiderWagon_Btn] setTag:[indexPath row]];
                 [[cell pitch_Btn] setTag:[indexPath row]];
                 [[cell WangonAll_Btn] setTag:[indexPath row]];
                 [[cell wangon1s_Btn] setTag:[indexPath row]];
                 [[cell wangon2s_Btn] setTag:[indexPath row]];
                 [[cell wangon3s_Btn] setTag:[indexPath row]];
                 [[cell wangon4s_Btn] setTag:[indexPath row]];
                 [[cell wangon6s_Btn] setTag:[indexPath row]];
                 [[cell onSide_Btn] setTag:[indexPath row]];
                 [[cell offSide_Btn] setTag:[indexPath row]];
//                if(isReadMoreButtonTouched && [indexPath row]== indexOfReadMoreButton)
//                {
                    [cell.btn_expand addTarget:self action:@selector(batsmancellExpand:) forControlEvents:UIControlEventTouchUpInside];
                //}
                
                cell.expand_View.hidden =YES;
                
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
                    cell.lbl_batsman_mins.textColor =[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(115/255.0f) alpha:1.0f];
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
                    cell.lbl_batsman_mins.textColor =[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
        
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
                cell.lbl_batsman_mins.text = battingSummaryDetailsForSB.DURATION;
                if(indexPath.row == indexOfReadMoreButton)
                {
//                    if(isPitch_Img ==NO)
//                    {
                    
                    //}
                    cell.expand_View.hidden =NO;
                    cell.pitchMap_img.hidden=YES;

                                        //

                    
                    if([battingSummaryDetailsForSB.BATTINGSTYLE isEqualToString:@"MSC012"])
                    {
                        
                        //self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
                        cell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
                        
                    }
                    else
                    {
                        
                        cell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
                        
                    }
                    
                    

                }
                
        
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
        
                cell.lbl_extras.text = [NSString stringWithFormat:@"(B: %@, NB: %@, LB: %@, WD: %@, P: %@)", fetchScorecard.BYES,fetchScorecard.NOBALLS,fetchScorecard.LEGBYES,fetchScorecard.WIDES,fetchScorecard.PENALTIES];
            
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
        
                for (BattingSummaryDetailsForScoreBoard *batSumryDtl in fetchScorecard.BattingSummaryForScoreBoardWkt) {
        
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
                }
        

                bowlerCellTvc.expandBowler_View.hidden =YES;

                [[bowlerCellTvc btn_expand] setTag:[indexPath row]];
                
                [[bowlerCellTvc BowlersectorWagon_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc BowlerspiderWagon_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc Bowlerpitch_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc BowlerWangonAll_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc Bowlerwangon1s_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc Bowlerwangon2s_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc Bowlerwangon3s_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc Bowlerwangon4s_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc Bowlerwangon6s_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc BowleronSide_Btn] setTag:[indexPath row]];
                [[bowlerCellTvc BowleroffSide_Btn] setTag:[indexPath row]];
                
                
                [bowlerCellTvc.btn_expand addTarget:self action:@selector(bowlerExpand:) forControlEvents:UIControlEventTouchUpInside];
        
                [bowlerCellTvc.BowlerspiderWagon_Btn addTarget:self action:@selector(didClickBowlingSpiderWagonAction:) forControlEvents:UIControlEventTouchUpInside];
        
                [bowlerCellTvc.BowlersectorWagon_Btn addTarget:self action:@selector(didClickBowlingSectorWagonAction:) forControlEvents:UIControlEventTouchUpInside];
        
                [bowlerCellTvc.Bowlerpitch_Btn addTarget:self action:@selector(didClickBowlingpitchAction:) forControlEvents:UIControlEventTouchUpInside];
        
                [bowlerCellTvc.BowleronSide_Btn addTarget:self action:@selector(didClickBowlingonSideAction:) forControlEvents:UIControlEventTouchUpInside];
        
                [bowlerCellTvc.BowleroffSide_Btn addTarget:self action:@selector(didClickBowlingOffSideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
                [bowlerCellTvc.BowlerWangonAll_Btn addTarget:self action:@selector(didClickAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [bowlerCellTvc.Bowlerwangon1s_Btn addTarget:self action:@selector(didClickBowling1sAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [bowlerCellTvc.Bowlerwangon2s_Btn addTarget:self action:@selector(didClickBowling2sAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [bowlerCellTvc.Bowlerwangon3s_Btn addTarget:self action:@selector(didClickBowling3sAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [bowlerCellTvc.Bowlerwangon4s_Btn addTarget:self action:@selector(didClickBowling4sAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [bowlerCellTvc.Bowlerwangon6s_Btn addTarget:self action:@selector(didClickBowling6sAction:) forControlEvents:UIControlEventTouchUpInside];
            
                
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
                
                if(indexPath.row == indexOfReadMoreButton)
                {
                     bowlerCellTvc.expandBowler_View.hidden =NO;
                     bowlerCellTvc.wagonPitch_img.hidden=YES;
//                    if([battingSummaryDetailsForSB.BATTINGSTYLE isEqualToString:@"MSC012"])
//                    {
//                        
//                        //self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
//                        cell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
//                        
//                    }
//                    else
//                    {
                    
                        bowlerCellTvc.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
                        
                    //}
                    

                }
                
                bowlerCellTvc.selectionStyle = UITableViewCellSelectionStyleNone;
                return bowlerCellTvc;
                
            }
   // }
      return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*************** Close the section, once the data is selected ***********************************/
    //[arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    // [_expandableTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        
        NSInteger row=  fetchScorecard.BowlingSummaryForScoreBoard.count+
        fetchScorecard.BattingSummaryForScoreBoard.count+
        (fallOfWktHeaderPostion==0?0:1) + (fallOfWktPostion==0?0:1) + 5;
        for (int i=0; i<row; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.table reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
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
    
     isReadMoreButtonTouched = NO;
     indexOfReadMoreButton = -1;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   
    // NSLog(@"scroll=%ld",(long)self.tblView_Height.constant);
    
    if(indexPath.row == 0){
        return 44;
    }
    
    else if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row){
        
        if([indexPath row] == indexOfReadMoreButton)
        {
                return 550.0f;
        }
        else
        {
            return 70.0f;
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
        if(isReadMoreButtonTouched && [indexPath row]== indexOfReadMoreButton)
        {
            return 550.0f;
        }
        else
        {
            return 70.0f;
        }

    }
   

    return 0;
}

-(IBAction)didClickSpiderWagonAction:(id)sender
{
    isPitch_Img = NO;
    
     isSectorEnableBatsman=NO;
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];

    
     cell.pitch_Btn.backgroundColor =[UIColor clearColor];
    cell.sectorWagon_Btn.backgroundColor =[UIColor clearColor];
    cell.spiderWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    
    cell.pitchMap_img.hidden=YES;
    cell.wagonPitch_img.hidden=NO;
    fineleg_lbl.hidden =YES;
    squareleg_lbl.hidden =YES;
    midWicket_lbl.hidden=YES;
    longon_lbl.hidden =YES;
    longoff_lbl.hidden =YES;
    cover_lbl.hidden =YES;
    point_lbl.hidden =YES;
    Thirdman_lbl.hidden =YES;
    
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    

    for(int i=0; i<expendBattsmanCellArray.count;i++)
    {
        BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
        
        if([objRecord.RUNS isEqualToString:@"1"])
        {
            Run1Count++;
        }
        else if ([objRecord.RUNS isEqualToString:@"0"])
        {
            zerocount++;
        }
        else if ([objRecord.RUNS isEqualToString:@"2"])
        {
            Run2Count++;
        }
        else if ([objRecord.RUNS isEqualToString:@"3"])
        {
            Run3Count++;
        }
        else if ([objRecord.RUNS isEqualToString:@"4"])
        {
            Run4Count++;
        }
        else if ([objRecord.RUNS isEqualToString:@"6"])
        {
            Run6Count++;
        }
    }
    
    NSString * line1 = (Run1Count != 0)?[NSString stringWithFormat:@"1s | %d",Run1Count]:@"1s | 0";
    NSString * line2 =(Run2Count !=0)? [NSString stringWithFormat:@"2s | %d",Run2Count]:@"2s | 0";
    NSString * line3 = (Run3Count !=0)?[NSString stringWithFormat:@"3s | %d",Run3Count]:@"3s | 0";
    NSString * line4 =  (Run4Count !=0)?[NSString stringWithFormat:@"4s | %d",Run4Count]:@"4s | 0";
    NSString * line5 = (Run6Count !=0)?[NSString stringWithFormat:@"6s | %d",Run6Count]:@"6s | 0";
    
    
    [cell.BowlerWangonAll_Btn setTitle:@"All" forState:UIControlStateNormal];
    [cell.wangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [cell.wangon2s_Btn setTitle:line2 forState:UIControlStateNormal];
    
    [cell.wangon3s_Btn setTitle:line3 forState:UIControlStateNormal];
    
    [cell.wangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [cell.wangon6s_Btn setTitle:line5 forState:UIControlStateNormal];
    

    
    
    
    if([self.BatmenStyle isEqualToString:@"MSC012"])
    {
      
        //self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
        cell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon.png"];
        [cell.onSide_Btn setTitle:@"OnSide" forState:UIControlStateNormal];
        [cell.offSide_Btn setTitle:@"OffSide" forState:UIControlStateNormal];
        
    }
    else
    {
        
        cell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon.png"];
        
        [cell.onSide_Btn setTitle:@"OffSide" forState:UIControlStateNormal];
        [cell.offSide_Btn setTitle:@"OnSide" forState:UIControlStateNormal];
    }
    

    int x1position;
    int x2position;
    int y1position;
    int y2position;
    
    for (CALayer *layer in cell.wagonPitch_img.layer.sublayers) {
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
        
        
    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)&& ![objRecord.WWRegion isEqualToString:@""]){
        
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
        
        
        if ([objRecord.RUNS isEqualToString: @"1"]) {
            
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
            
        }else if ([objRecord.RUNS isEqualToString: @"2"]){
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(6/255.0f) blue:(250/255.0f) alpha:1.0f];
        }else if ([objRecord.RUNS isEqualToString: @"3"]){
            strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
            
        }else if ([objRecord.RUNS isEqualToString: @"4"]){
            strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
            
        }else if ([objRecord.RUNS isEqualToString: @"5"]){
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
            
        }else if ([objRecord.RUNS isEqualToString: @"6"]){
           strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

        }else if ([objRecord.RUNS isEqualToString: @"0"]){
            
            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
            
       }
    //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
//            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
//        }

        
        shapeLayer.strokeColor = strokeColor.CGColor;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.fillRule = kCAFillRuleNonZero;
        shapeLayer.name = @"DrawLine";
        [cell.wagonPitch_img.layer addSublayer:shapeLayer];
        
    }
    }
    
}

-(IBAction)didClickSectorWagonAction:(id)sender
{
    isPitch_Img = NO;
    isSectorEnableBatsman=YES;
    
       // ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [sender superview].superview;
    //CGPoint location            = [sender locationInView:self.table];
    //NSIndexPath *indexPath      = [self.table indexPathForRowAtPoint:location];
    //ScoreCardCellTVCell *cell  = [self.table cellForRowAtIndexPath:sender];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
   // self.batsmanCell =cell;
    cell.wagonPitch_img.hidden=NO;
    cell.pitchMap_img.hidden=YES;
    
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
    
    cell.wagonPitch_img.image=[UIImage imageNamed:@"Sector_Img"];
    cell.pitch_Btn.backgroundColor =[UIColor clearColor];
    cell.spiderWagon_Btn.backgroundColor =[UIColor clearColor];
    cell.sectorWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    

    
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
    
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
   




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
        
        for(int i=0; i<expendBattsmanCellArray.count;i++)
        {
        for (CALayer *layer in cell.wagonPitch_img.layer.sublayers) {
            if ([layer.name isEqualToString:@"DrawLine"]) {
                [layer removeFromSuperlayer];
                break;
            }
        }
        }
        [self sectorWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS :cell];
        
    }
    }

}

-(IBAction)didClickpitchAction:(id)sender
{
    isPitch_Img = YES;
    isSectorEnableBatsman=NO;
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];

    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    
    for(int i=0; i<BatmanRunsArray.count;i++)
    {
        BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
        
        if([objRecord.Runs isEqualToString:@"1"])
        {
            Run1Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"0"])
        {
            zerocount++;
        }
        else if ([objRecord.Runs isEqualToString:@"2"])
        {
            Run2Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"3"])
        {
            Run3Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"4"])
        {
            Run4Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"6"])
        {
            Run6Count++;
        }
    }
    
    NSString * line1 = (Run1Count != 0)?[NSString stringWithFormat:@"1s | %d",Run1Count]:@"1s | 0";
    NSString * line2 =(Run2Count !=0)? [NSString stringWithFormat:@"2s | %d",Run2Count]:@"2s | 0";
    NSString * line3 = (Run3Count !=0)?[NSString stringWithFormat:@"3s | %d",Run3Count]:@"3s | 0";
    NSString * line4 =  (Run4Count !=0)?[NSString stringWithFormat:@"4s | %d",Run4Count]:@"4s | 0";
    NSString * line5 = (Run6Count !=0)?[NSString stringWithFormat:@"6s | %d",Run6Count]:@"6s | 0";

    
    cell.sectorWagon_Btn.backgroundColor =[UIColor clearColor];
    cell.spiderWagon_Btn.backgroundColor =[UIColor clearColor];
    cell.pitch_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];

    cell.wagonPitch_img.hidden=YES;
    cell.pitchMap_img.hidden=NO;
    
    if(Img_ball != nil)
    {
        [Img_ball removeFromSuperview];
    }
    
    [cell.onSide_Btn setTitle:@"" forState:UIControlStateNormal];
    [cell.offSide_Btn setTitle:@"" forState:UIControlStateNormal];


    if([self.BatmenStyle isEqualToString:@"MSC013"])
    {
        cell.pitchMap_img.image=[UIImage imageNamed:@"pichmapRH"];
    }
    else{
        
        cell.pitchMap_img.image=[UIImage imageNamed:@"pichmapLH"];
        
    }
    
    [cell.WangonAll_Btn setTitle:@"ALL" forState:UIControlStateNormal];
    
    [cell.wangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [cell.wangon2s_Btn setTitle:line2 forState:UIControlStateNormal];

    [cell.wangon3s_Btn setTitle:line3 forState:UIControlStateNormal];

    [cell.wangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [cell.wangon6s_Btn setTitle:line5 forState:UIControlStateNormal];

            if(Img_ball != nil)
            {
                [Img_ball removeFromSuperview];
            }
    
    
    
    int xposition;
    int yposition;

    for(int i=0; i<BatmanRunsArray.count;i++)
    {
        BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMy2 intValue];
        
    if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
        
        
//        if(Img_ball != nil)
//        {
//            [Img_ball removeFromSuperview];
//        }
//
        Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition+20,yposition-30,20, 20)];
        Img_ball.layer.cornerRadius =10;
        Img_ball.layer.masksToBounds=YES;
        //Img_ball.image =[UIImage imageNamed:@"RedBall"];
        
        if ([objRecord.Runs isEqualToString: @"1"]) {
            
            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
            
        }else if ([objRecord.Runs isEqualToString: @"2"]){
            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
           // Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];

        }else if ([objRecord.Runs isEqualToString: @"3"]){
            Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
            
        }else if ([objRecord.Runs isEqualToString: @"4"]){
            Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
            
        }else if ([objRecord.Runs isEqualToString: @"5"]){
            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
            
        }else if ([objRecord.Runs isEqualToString: @"6"]){
            Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

        }else if ([objRecord.Runs isEqualToString: @"0"]){
            
            Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
        }

        [cell.pitchMap_img addSubview:Img_ball];
        
        
    }
    }
  
}

-(IBAction)didClickonSideAction:(id)sender
{
    
    isPitch_Img = NO;
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    

    
    if(cell.wagonPitch_img.hidden == NO)
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
            
          
            for(int i=0; i<expendBattsmanCellArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.SECTORREGIONCODE;
                if([regionCode isEqualToString:@"MDT036"] || [regionCode isEqualToString:@"MDT037"] ||[regionCode isEqualToString:@"MDT038"] || [regionCode isEqualToString:@"MDT039"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }

            
            for(int i=0 ;i<expendBattsmanCellArray.count;i++)
            {
                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
               if(isSectorEnableBatsman == YES)
               {
                   
                   
                   [self SectorReplaceLableMethod];
                   for(int i=0; i< onsideRegionValue.count;i++)
                   {
                       BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                       x1position = [objRecord.WWX1 intValue];
                       y1position = [objRecord.WWY1 intValue];
                       x2position  =[objRecord .WWX2 intValue];
                       y2position  =[objRecord.WWY2 intValue];
                       
                       
                       if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                           
                           [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS:cell];
                       }
                   }
               }

               else
               {
                for(int i=0; i< onsideRegionValue.count;i++)
                {
                    BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                    x1position = [objRecord.WWX1 intValue];
                    y1position = [objRecord.WWY1 intValue];
                    x2position  =[objRecord .WWX2 intValue];
                    y2position  =[objRecord.WWY2 intValue];
                    
                    
                    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                        
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
                        
                        
                        if ([objRecord.RUNS isEqualToString: @"1"]) {
                            
                            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                            
                        }else if ([objRecord.RUNS isEqualToString: @"2"]){
                            //strokeColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                            
                        }else if ([objRecord.RUNS isEqualToString: @"3"]){
                            strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                            
                        }else if ([objRecord.RUNS isEqualToString: @"4"]){
                            strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                            
                        }else if ([objRecord.RUNS isEqualToString: @"5"]){
                            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                            
                        }else if ([objRecord.RUNS isEqualToString: @"6"]){
                            strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                            
                        }else if ([objRecord.RUNS isEqualToString: @"0"]){
                            
                            strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                            
                        }
                        
                        shapeLayer.strokeColor = strokeColor.CGColor;
                        shapeLayer.lineWidth = 2.0f;
                        shapeLayer.fillRule = kCAFillRuleNonZero;
                        shapeLayer.name = @"DrawLine";
                        [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                        
                    }
                }
        }
        
        }
        else{
            NSLog(@"RH");
            
            
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
            
            
            for(int i=0; i<expendBattsmanCellArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.SECTORREGIONCODE;
                if([regionCode isEqualToString:@"MDT041"] || [regionCode isEqualToString:@"MDT042"] || [regionCode isEqualToString:@"MDT043"] || [regionCode isEqualToString:@"MDT044"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }
            
            
            for(int i=0 ;i<expendBattsmanCellArray.count;i++)
            {
                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
            
            if(isSectorEnableBatsman == YES)
            {
                
                
                [self SectorReplaceLableMethod];
                for(int i=0; i< onsideRegionValue.count;i++)
                {
                    BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                    x1position = [objRecord.WWX1 intValue];
                    y1position = [objRecord.WWY1 intValue];
                    x2position  =[objRecord .WWX2 intValue];
                    y2position  =[objRecord.WWY2 intValue];
                    
                    
                    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS:cell];
                    }
                }
            }
            
            else
            {

            for(int i=0; i< onsideRegionValue.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
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
                    
                    
                    if ([objRecord.RUNS isEqualToString: @"1"]) {
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"2"]){
                        //strokeColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"3"]){
                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"4"]){
                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"5"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"6"]){
                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"0"]){
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }
                    
                    
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }

        }
            }
        
    }
    }
    else if ([cell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [cell.wagonPitch_img.image  isEqual: @"pichmapLH"])
    {
        if([self.BatmenStyle isEqualToString:@"MSC013"])
        {
            NSLog(@"pichmapRH");
            
        }
        else{
            
           NSLog(@"pichmapLH");
            
        }
    }
}

-(IBAction)didClickOffSideAction:(id)sender
{
    isPitch_Img = NO;
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    if(cell.wagonPitch_img.hidden == NO)
    {
        if([_BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
            
            
            for(int i=0; i<expendBattsmanCellArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.SECTORREGIONCODE;
               if([regionCode isEqualToString:@"MDT041"] || [regionCode isEqualToString:@"MDT042"] || [regionCode isEqualToString:@"MDT043"] || [regionCode isEqualToString:@"MDT044"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }
            
            
            for(int i=0 ;i<expendBattsmanCellArray.count;i++)
            {
                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
            
            
            if(isSectorEnableBatsman == YES)
            {
                
                
                [self SectorReplaceLableMethod];
                for(int i=0; i< onsideRegionValue.count;i++)
                {
                    BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                    x1position = [objRecord.WWX1 intValue];
                    y1position = [objRecord.WWY1 intValue];
                    x2position  =[objRecord .WWX2 intValue];
                    y2position  =[objRecord.WWY2 intValue];
                    
                    
                    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS:cell];
                    }
                }
            }
            
            else
            {

            for(int i=0; i< onsideRegionValue.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
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
                    
                    
                    if ([objRecord.RUNS isEqualToString: @"1"]) {
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"2"]){
                        //strokeColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"3"]){
                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"4"]){
                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"5"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"6"]){
                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"0"]){
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }
                    //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
                    //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
                    //        }
                    
                    
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            }
            
        }
        else{
            NSLog(@"RH");
            
            
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
            
            
            for(int i=0; i<expendBattsmanCellArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.SECTORREGIONCODE;
               if([regionCode isEqualToString:@"MDT036"] || [regionCode isEqualToString:@"MDT037"] ||[regionCode isEqualToString:@"MDT038"] || [regionCode isEqualToString:@"MDT039"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }
            
            
            for(int i=0 ;i<expendBattsmanCellArray.count;i++)
            {
                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
            
            if(isSectorEnableBatsman == YES)
            {
                
                
                [self SectorReplaceLableMethod];
                for(int i=0; i< onsideRegionValue.count;i++)
                {
                    BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                    x1position = [objRecord.WWX1 intValue];
                    y1position = [objRecord.WWY1 intValue];
                    x2position  =[objRecord .WWX2 intValue];
                    y2position  =[objRecord.WWY2 intValue];
                    
                    
                    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS:cell];
                    }
                }
            }
            
            else
            {

            for(int i=0; i< onsideRegionValue.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[onsideRegionValue objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
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
                    
                    
                    if ([objRecord.RUNS isEqualToString: @"1"]) {
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"2"]){
                        //strokeColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"3"]){
                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"4"]){
                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"5"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"6"]){
                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.RUNS isEqualToString: @"0"]){
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }
                    //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
                    //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
                    //        }
                    
                    
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
            }
            
        }
    }
    else if ([cell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [cell.wagonPitch_img.image  isEqual: @"pichmapLH"])
    {
        if([self.BatmenStyle isEqualToString:@"MSC013"])
        {
            NSLog(@"pichmapRH");
            
        }
        else{
            
            NSLog(@"pichmapLH");
            
        }
    }

}


-(IBAction)didClickAll_BtnAction:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
    
    if(cell.wagonPitch_img.hidden == NO)
    {
        
        for(int i=0 ;i<expendBattsmanCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        if(isSectorEnableBatsman == YES)
        {
            [self SectorReplaceLableMethod];
            for(int i=0; i< expendBattsmanCellArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS:cell];
                }
            }

        }
        else
        {
        for(int i=0; i< expendBattsmanCellArray.count;i++)
        {
            BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
            x1position = [objRecord.WWX1 intValue];
            y1position = [objRecord.WWY1 intValue];
            x2position  =[objRecord .WWX2 intValue];
            y2position  =[objRecord.WWY2 intValue];
            
            
            if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                

                int Xposition = x1position+28;
                int Yposition = y1position;
                CGMutablePathRef straightLinePath = CGPathCreateMutable();
                CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.path = straightLinePath;
                UIColor *fillColor = [UIColor redColor];
                shapeLayer.fillColor = fillColor.CGColor;
                UIColor *strokeColor = [UIColor whiteColor];
                
                if ([objRecord.RUNS isEqualToString: @"1"]) {
                    
                    strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.RUNS isEqualToString: @"2"]){
                    strokeColor = [UIColor colorWithRed:(255/255.0f) green:(6/255.0f) blue:(250/255.0f) alpha:1.0f];
                }else if ([objRecord.RUNS isEqualToString: @"3"]){
                    strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.RUNS isEqualToString: @"4"]){
                    strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.RUNS isEqualToString: @"5"]){
                    strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.RUNS isEqualToString: @"6"]){
//                    strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                      strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                }else if ([objRecord.RUNS isEqualToString: @"0"]){
                    
                    strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                    
                }

                
                shapeLayer.strokeColor = strokeColor.CGColor;
                shapeLayer.lineWidth = 2.0f;
                shapeLayer.fillRule = kCAFillRuleNonZero;
                shapeLayer.name = @"DrawLine";
                [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                
            }
        }
        }
    }
    else
    {
        for(UIImageView * obj in [cell.pitchMap_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }

        if(BatmanRunsArray.count > 0)
        {
            for(int i=0; i< BatmanRunsArray.count;i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMy2 intValue];
                
               if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
                    
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition+20,yposition-30,20, 20)];
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            for(UIImageView * obj in [cell.pitchMap_img subviews])
            {
                NSLog(@"%@",obj);
                [obj removeFromSuperview];
            }
        }
        NSLog(@"pitch");
    }

}

-(IBAction)didClick1sAction:(id)sender
{
    
    NSMutableArray * Run1CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run1CountpitchArray =[[NSMutableArray alloc]init];

    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    

    
         if(cell.wagonPitch_img.hidden == NO)
    {
        
        if(expendBattsmanCellArray > 0)
        {
            for(int i=0; i< expendBattsmanCellArray.count; i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                if([objRecord.RUNS isEqualToString:@"1"])
                {
                    [Run1CountwagonArray addObject:objRecord];
                }
            }
        }

        
        
        for(int i=0 ;i<expendBattsmanCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;

        if(isSectorEnableBatsman == YES)
        {
           
            
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run1CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run1CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){

            [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS :cell];
                }
            }
        }
        else
        {
            
                for(int i=0; i< Run1CountwagonArray.count;i++)
                    {
                        BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run1CountwagonArray objectAtIndex:i];
                        x1position = [objRecord.WWX1 intValue];
                        y1position = [objRecord.WWY1 intValue];
                        x2position  =[objRecord .WWX2 intValue];
                        y2position  =[objRecord.WWY2 intValue];
                       
        
                        if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
        
        
                            int Xposition = x1position+28;
                            int Yposition = y1position;
                            CGMutablePathRef straightLinePath = CGPathCreateMutable();
                            CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                            CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                            shapeLayer.path = straightLinePath;
                            UIColor *fillColor = [UIColor redColor];
                            shapeLayer.fillColor = fillColor.CGColor;
                            UIColor *strokeColor = [UIColor colorWithRed:(255/255.0f) green:(109/255.0f) blue:(37/255.0f) alpha:1.0f];
                            shapeLayer.strokeColor = strokeColor.CGColor;
                            shapeLayer.lineWidth = 2.0f;
                            shapeLayer.fillRule = kCAFillRuleNonZero;
                            shapeLayer.name = @"DrawLine";
                            [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                            
                        }
             
                    }
        }
    }
    else
    {
        
        if(BatmanRunsArray > 0)
        {
            for(UIImageView * obj in [cell.pitchMap_img subviews])
            {
                NSLog(@"%@",obj);
                [obj removeFromSuperview];
            }
            
            for(int i=0; i< BatmanRunsArray.count; i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"1"])
                {
                    [Run1CountpitchArray addObject:objRecord];
                }
            }
        }
        
        

        if(Run1CountpitchArray.count > 0)
        {
           for(int i=0; i< Run1CountpitchArray.count;i++)
        {
            BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[Run1CountpitchArray objectAtIndex:i];
            
            int xposition;
            int yposition;
            
          
            xposition = [objRecord.PMX2 intValue];
            yposition = [objRecord.PMy2 intValue];
            
            if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
            
            
            Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition+20,yposition-30,20, 20)];
           // Img_ball.image =[UIImage imageNamed:@"RedBall"];
                Img_ball.layer.cornerRadius =10;
                Img_ball.layer.masksToBounds=YES;
                //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                
                if ([objRecord.Runs isEqualToString: @"1"]) {
                    
                    Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.Runs isEqualToString: @"2"]){
                    Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.Runs isEqualToString: @"3"]){
                    Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.Runs isEqualToString: @"4"]){
                    Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.Runs isEqualToString: @"5"]){
                    Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                    
                }else if ([objRecord.Runs isEqualToString: @"6"]){
                    //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                    Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                }else if ([objRecord.Runs isEqualToString: @"0"]){
                    
                    Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                    
                }

            [cell.pitchMap_img addSubview:Img_ball];
                            

        }
        }
        }
        else{
           
                for(UIImageView * obj in [cell.pitchMap_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
            
            
        }
        NSLog(@"pitch");
    }
    
    
}

-(IBAction)didClick2sAction:(id)sender
{
    
    
    NSMutableArray * Run2CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run2CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    

    
       if(cell.wagonPitch_img.hidden == NO)
    {
        if(expendBattsmanCellArray > 0)
        {
            for(int i=0; i< expendBattsmanCellArray.count; i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                if([objRecord.RUNS isEqualToString:@"2"])
                {
                    [Run2CountwagonArray addObject:objRecord];
                }
            }
        }

        
        for(int i=0 ;i<expendBattsmanCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        if(isSectorEnableBatsman == YES)
        {
            
            
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run2CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run2CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS :cell];
                }
            }
        }
        else
        {
            
            for(int i=0; i< Run2CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run2CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    int Xposition = x1position+28;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    UIColor *strokeColor = [UIColor colorWithRed:(255/255.0f) green:(6/255.0f) blue:(250/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    
       else
    {
        for(UIImageView * obj in [cell.pitchMap_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }
        
         if(BatmanRunsArray > 0)
        {
            for(int i=0; i< BatmanRunsArray.count; i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"2"])
                {
                    [Run2CountpitchArray addObject:objRecord];
                }
            }
        }

        
        if(Run2CountpitchArray.count > 0)
        {
            for(int i=0; i< Run2CountpitchArray.count;i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[Run2CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMy2 intValue];
                
               if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
                    
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition+20,yposition-30,20, 20)];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                   
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
                for(UIImageView * obj in [cell.pitchMap_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
            
        }
        NSLog(@"pitch");
    }

}
-(IBAction)didClick3sAction:(id)sender
{
    NSMutableArray * Run3CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run3CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    

    
        if(cell.wagonPitch_img.hidden == NO)
    {
        
        if(expendBattsmanCellArray > 0)
        {
            for(int i=0; i< expendBattsmanCellArray.count; i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                if([objRecord.RUNS isEqualToString:@"3"])
                {
                    [Run3CountwagonArray addObject:objRecord];
                }
            }
        }

        
        for(int i=0 ;i<expendBattsmanCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        if(isSectorEnableBatsman == YES)
        {
            
            
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run3CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run3CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS :cell];
                }
            }
        }
        else
        {
            
            for(int i=0; i< Run3CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run3CountwagonArray objectAtIndex:i];
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
                    UIColor * strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
;
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    
    else
    {
        for(UIImageView * obj in [cell.pitchMap_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }
        if(BatmanRunsArray > 0)
        {
            for(int i=0; i< BatmanRunsArray.count; i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"3"])
                {
                    [Run3CountpitchArray addObject:objRecord];
                }
            }
        }

        if(Run3CountpitchArray.count > 0)
        {
            for(int i=0; i< Run3CountpitchArray.count;i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[Run3CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMy2 intValue];
                
                if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
                    
                    
                    //        if(Img_ball != nil)
                    //        {
                    //            [Img_ball removeFromSuperview];
                    //        }
                    //
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition+20,yposition-30,20, 20)];
                   // Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                       // Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
                for(UIImageView * obj in [cell.pitchMap_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
        }
        NSLog(@"pitch");
    }
}

-(IBAction)didClick4sAction:(id)sender
{
    NSMutableArray * Run4CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run4CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
    if(cell.wagonPitch_img.hidden == NO)
    {
        
        if(expendBattsmanCellArray > 0)
        {
            for(int i=0; i< expendBattsmanCellArray.count; i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                if([objRecord.RUNS isEqualToString:@"4"])
                {
                    [Run4CountwagonArray addObject:objRecord];
                }
            }
        }

        
        for(int i=0 ;i<expendBattsmanCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        if(isSectorEnableBatsman == YES)
        {
            
            
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run4CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run4CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS :cell];
                }
            }
        }
        else
        {
            
            for(int i=0; i< Run4CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run4CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    

                    int Xposition = x1position+28;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    UIColor *strokeColor = [UIColor colorWithRed:(217/255.0f) green:(32/255.0f) blue:(35/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    else
    {
        for(UIImageView * obj in [cell.pitchMap_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }
        
        if(BatmanRunsArray > 0)
        {
            for(int i=0; i< BatmanRunsArray.count; i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"4"])
                {
                    [Run4CountpitchArray addObject:objRecord];
                }
            }
        }

        
        if(Run4CountpitchArray.count > 0)
        {
            for(int i=0; i< Run4CountpitchArray.count;i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[Run4CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMy2 intValue];
                
                if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
                    
                    
                    //        if(Img_ball != nil)
                    //        {
                    //            [Img_ball removeFromSuperview];
                    //        }
                    //
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition+20,yposition-30,20, 20)];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                  //  Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    [cell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
                for(UIImageView * obj in [cell.pitchMap_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
            
        }
        NSLog(@"pitch");
    }
}

-(IBAction)didClick6sAction:(id)sender
{
    NSMutableArray * Run6CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run6CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    

    
       if(cell.wagonPitch_img.hidden == NO)
    {
        if(expendBattsmanCellArray > 0)
        {
            for(int i=0; i< expendBattsmanCellArray.count; i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[expendBattsmanCellArray objectAtIndex:i];
                if([objRecord.RUNS isEqualToString:@"6"])
                {
                    [Run6CountwagonArray addObject:objRecord];
                }
            }
        }

        
        for(int i=0 ;i<expendBattsmanCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        if(isSectorEnableBatsman == YES)
        {
            
            
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run6CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run6CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS :cell];
                }
            }
        }
        else
        {
            
            for(int i=0; i< Run6CountwagonArray.count;i++)
            {
                BattingPayerStatisticsRecord * objRecord =(BattingPayerStatisticsRecord *)[Run6CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                
                    int Xposition = x1position+28;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    UIColor *strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    else
    {
        for(UIImageView * obj in [cell.pitchMap_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }
        if(BatmanRunsArray > 0)
        {
            for(int i=0; i< BatmanRunsArray.count; i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[BatmanRunsArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"6"])
                {
                    [Run6CountpitchArray addObject:objRecord];
                }
            }
        }

        if(Run6CountpitchArray.count > 0)
        {
            for(int i=0; i< Run6CountpitchArray.count;i++)
            {
                BattingStatisticsPitchRecord * objRecord =(BattingStatisticsPitchRecord *)[Run6CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMy2 intValue];
                
                if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
                    
                    
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition+20,yposition-30,20, 20)];
                   
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                    }

                    [cell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            for(UIImageView * obj in [cell.pitchMap_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
        }
        NSLog(@"pitch");
    }
}
-(IBAction)didClickBowlingSpiderWagonAction:(id)sender
{
    
    isPitch_Img = NO;
    isSectorEnableBowler =NO;
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    

   
    cell.BowlerwagonPitch_img.hidden=YES;
    cell.wagonPitch_img.hidden=NO;

    fineleg_lbl.hidden =YES;
    squareleg_lbl.hidden =YES;
    midWicket_lbl.hidden=YES;
    longon_lbl.hidden =YES;
    longoff_lbl.hidden =YES;
    cover_lbl.hidden =YES;
    point_lbl.hidden =YES;
    Thirdman_lbl.hidden =YES;
   
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    
    cell.Bowlerpitch_Btn.backgroundColor =[UIColor clearColor];
    cell.BowlersectorWagon_Btn.backgroundColor =[UIColor clearColor];
    cell.BowlerspiderWagon_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    
    
    //BowlingSummaryDetailsForScoreBoard *bowlingSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:bowlerIndex];
    //NSMutableArray * objArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];
    
//    if([self.BatmenStyle isEqualToString:@"MSC013"])
//    {
        cell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
        [cell.BowleronSide_Btn setTitle:@"OffSide" forState:UIControlStateNormal];
        [cell.BowleroffSide_Btn setTitle:@"OnSide" forState:UIControlStateNormal];
//    }
//    else{
//        
//        cell.wagonPitch_img.image=[UIImage imageNamed:@"LHWagon"];
//        
//    }

    
    
    for(int i=0; i<BowlerRunArray.count;i++)
    {
        BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[BowlerRunArray objectAtIndex:i];
        
        if([objRecord.Runs isEqualToString:@"1"])
        {
            Run1Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"0"])
        {
            zerocount++;
        }
        else if ([objRecord.Runs isEqualToString:@"2"])
        {
            Run2Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"3"])
        {
            Run3Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"4"])
        {
            Run4Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"6"])
        {
            Run6Count++;
        }
    }
    
    NSString * line1 = (Run1Count != 0)?[NSString stringWithFormat:@"1s | %d",Run1Count]:@"1s | 0";
    NSString * line2 =(Run2Count !=0)? [NSString stringWithFormat:@"2s | %d",Run2Count]:@"2s | 0";
    NSString * line3 = (Run3Count !=0)?[NSString stringWithFormat:@"3s | %d",Run3Count]:@"3s | 0";
    NSString * line4 =  (Run4Count !=0)?[NSString stringWithFormat:@"4s | %d",Run4Count]:@"4s | 0";
    NSString * line5 = (Run6Count !=0)?[NSString stringWithFormat:@"6s | %d",Run6Count]:@"6s | 0";
    
    [cell.BowlerWangonAll_Btn setTitle:@"ALL" forState:UIControlStateNormal];
    
    [cell.Bowlerwangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon2s_Btn setTitle:line2 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon3s_Btn setTitle:line3 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon6s_Btn setTitle:line5 forState:UIControlStateNormal];
    
    for (CALayer *layer in cell.wagonPitch_img.layer.sublayers) {
        if ([layer.name isEqualToString:@"DrawLine"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    int x1position;
    int x2position;
    int y1position;
    int y2position;
    
    int BASE_X = 150;
    
    
    for(int i=0; i<expendBowlerCellArray.count;i++)
    {
        BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
        x1position = [objRecord.WWX1 intValue];
        y1position = [objRecord.WWY1 intValue];
        x2position  =[objRecord .WWX2 intValue];
        y2position  =[objRecord.WWY2 intValue];
        //objRecord.BattingStyle =@"MSC013";
        
        //int Xposition;
        //int Yposition;
       // if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
        
        
        
        if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
            
            x2position = BASE_X + (BASE_X - x2position);
            
        }
        int Xposition = x1position;
        int Yposition = y1position;
        
        
        CGMutablePathRef straightLinePath = CGPathCreateMutable();
        CGPathMoveToPoint(straightLinePath, NULL, Xposition+30, Yposition);
        CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = straightLinePath;
        UIColor *strokeColor = [UIColor redColor];
        shapeLayer.fillColor = strokeColor.CGColor;
        

        
            if ([objRecord.Runs isEqualToString: @"1"]) {
                
                strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"2"]){
                strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"3"]){
                strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"4"]){
                strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"5"]){
                strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"6"]){
                //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

            }else if ([objRecord.Runs isEqualToString: @"0"]){
                
                strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                
            }
            //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
            //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
            //        }
            

            shapeLayer.strokeColor = strokeColor.CGColor;
            shapeLayer.lineWidth = 2.0f;
            shapeLayer.fillRule = kCAFillRuleNonZero;
            shapeLayer.name = @"DrawLine";
            [cell.wagonPitch_img.layer addSublayer:shapeLayer];
            
        }
    //}
}

-(IBAction)didClickBowlingSectorWagonAction:(id)sender
{
    
    isSectorEnableBowler = YES;

    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
    
    cell.wagonPitch_img.hidden=NO;
    cell.BowlerwagonPitch_img.hidden=YES;
    
    
    
    cell.Bowlerpitch_Btn.backgroundColor =[UIColor clearColor];
    cell.BowlersectorWagon_Btn.backgroundColor =[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
   cell.BowlerspiderWagon_Btn.backgroundColor=[UIColor clearColor];
    cell.wagonPitch_img.image=[UIImage imageNamed:@"Sector_Img"];

    
    //BowlingSummaryDetailsForScoreBoard *bowlerSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:bowlerIndex];
    //NSMutableArray * objArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :bowlerSummaryDetailsForSB.BOWLERCODE];
    
    int x1position;
    int x2position;
    int y1position;
    int y2position;
    
    
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    
    
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
    
    
    
    
    finelegRun =0;
    squarelegRun=0;
    midWicketRun=0;
    longonRun=0;
    longoffRun=0;
    coverRun =0;
    pointRun=0;
    ThirdmanCountRun=0;
   // RHlongonRun =0;
    
    

    
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
            
            
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers) {
                if ([layer.name isEqualToString:@"DrawLine"]) {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
            [self BowlersectorWagonwheel :objRecord.Sectorregioncode:@"MSC013" : objRecord.Runs: cell];

    
        }
    
   }

}

-(IBAction)didClickBowlingpitchAction:(id)sender
{
    
    isSectorEnableBowler =NO;

    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
    
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    
    for(int i=0; i<BowlerRunArray.count;i++)
    {
         BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
        
        if([objRecord.Runs isEqualToString:@"1"])
        {
            Run1Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"0"])
        {
            zerocount++;
        }
        else if ([objRecord.Runs isEqualToString:@"2"])
        {
            Run2Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"3"])
        {
            Run3Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"4"])
        {
            Run4Count++;
        }
        else if ([objRecord.Runs isEqualToString:@"6"])
        {
            Run6Count++;
        }
    }
    
    NSString * line1 = (Run1Count != 0)?[NSString stringWithFormat:@"1s | %d",Run1Count]:@"1s | 0";
    NSString * line2 =(Run2Count !=0)? [NSString stringWithFormat:@"2s | %d",Run2Count]:@"2s | 0";
    NSString * line3 = (Run3Count !=0)?[NSString stringWithFormat:@"3s | %d",Run3Count]:@"3s | 0";
    NSString * line4 =  (Run4Count !=0)?[NSString stringWithFormat:@"4s | %d",Run4Count]:@"4s | 0";
    NSString * line5 = (Run6Count !=0)?[NSString stringWithFormat:@"5s | %d",Run6Count]:@"6s | 0";
    
    cell.BowlerwagonPitch_img.hidden=NO;
    cell.wagonPitch_img.hidden=YES;
    
    
    [cell.onSide_Btn setTitle:@"" forState:UIControlStateNormal];
    [cell.offSide_Btn setTitle:@"" forState:UIControlStateNormal];

    
    if([self.BatmenStyle isEqualToString:@"MSC013"])
    {
        //self.batsmanCell.pitchMap_img.image=[UIImage imageNamed:@"pichmapRH"];
        cell.BowlerwagonPitch_img.image=[UIImage imageNamed:@"pichmapRH"];

    }
    else{
        cell.BowlerwagonPitch_img.image=[UIImage imageNamed:@"pichmapLH"];

           }

    
    cell.Bowlerpitch_Btn.backgroundColor =[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];
    cell.BowlerspiderWagon_Btn.backgroundColor =[UIColor clearColor];
    cell.BowlersectorWagon_Btn.backgroundColor=[UIColor clearColor];
    //BowlingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:bowlerIndex];
  // BowlerRunArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSPitch:competitionCode :matchCode :inningsNo :battingSummaryDetailsForSB.BOWLERCODE];
    
    [cell.BowlerWangonAll_Btn setTitle:@"ALL" forState:UIControlStateNormal];
    [cell.Bowlerwangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon2s_Btn setTitle:line2 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon3s_Btn setTitle:line3 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [cell.Bowlerwangon6s_Btn setTitle:line5 forState:UIControlStateNormal];
    
    
    
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
        
        if(!(xposition == 1 && yposition ==1)&& (xposition!=0 && yposition !=0)){
            
//            
//            if(Img_ball != nil)
//            {
//                [Img_ball removeFromSuperview];
//            }
            
            Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition-10,yposition-40,20, 20)];
           // Img_ball.image =[UIImage imageNamed:@"RedBall"];
            Img_ball.layer.cornerRadius =10;
            Img_ball.layer.masksToBounds=YES;
            //Img_ball.image =[UIImage imageNamed:@"RedBall"];
            
            if ([objRecord.Runs isEqualToString: @"1"]) {
                
                Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"2"]){
                Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"3"]){
                Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"4"]){
                Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"5"]){
                Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                
            }else if ([objRecord.Runs isEqualToString: @"6"]){
                //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

            }else if ([objRecord.Runs isEqualToString: @"0"]){
                
                Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                
            }

            [cell.BowlerwagonPitch_img addSubview:Img_ball];
            
        }
    }

}

-(IBAction)didClickBowlingonSideAction:(id)sender
{
    isPitch_Img = NO;
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    

    
       if(cell.wagonPitch_img.hidden == NO)
    {
  //      if([self.BatmenStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//            int x1position;
//            int x2position;
//            int y1position;
//            int y2position;
//            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
//            
//            
//            for(int i=0; i<expendBowlerCellArray.count;i++)
//            {
//                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
//                NSString * batstyle = objRecord.BattingStyle;
//                NSString * wwregion   =objRecord.WWRegion;
//                if([batstyle isEqualToString:self.BatmenStyle])
//                {
//                   // if([wwregion isEqualToString:@"MSC216"] ||[wwregion isEqualToString:@"MSC194"] ||[wwregion isEqualToString:@"MSC189"] ||[wwregion isEqualToString:@"MSC185"])
//                    ///{
//                        [onsideRegionValue addObject:objRecord];
//                    //}
//                }
//            }
//            
//            
//            for(int i=0 ;i<expendBowlerCellArray.count;i++)
//            {
//                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
//                {
//                    if ([layer.name isEqualToString:@"DrawLine"])
//                    {
//                        [layer removeFromSuperlayer];
//                        break;
//                    }
//                }
//            }
//            if(isSectorEnableBowler == YES)
//            {
//                
//                
//                [self SectorReplaceLableMethod];
//                for(int i=0; i< onsideRegionValue.count;i++)
//                {
//                    BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[onsideRegionValue objectAtIndex:i];
//                    x1position = [objRecord.WWX1 intValue];
//                    y1position = [objRecord.WWY1 intValue];
//                    x2position  =[objRecord .WWX2 intValue];
//                    y2position  =[objRecord.WWY2 intValue];
//                    
//                    
//                    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
//                        
//                        [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode :self.BatmenStyle:objRecord.Runs:cell];
//                    }
//                }
//            }
//            
//            else
//            {
//
//            for(int i=0; i<onsideRegionValue.count;i++)
//            {
//                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
//                x1position = [objRecord.WWX1 intValue];
//                y1position = [objRecord.WWY1 intValue];
//                x2position  =[objRecord .WWX2 intValue];
//                y2position  =[objRecord.WWY2 intValue];
//                
//                
//                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
//                    
//                    
//                    for (CALayer *layer in cell.BowlerwagonPitch_img.layer.sublayers) {
//                        if ([layer.name isEqualToString:@"DrawLine"]) {
//                            //[layer removeFromSuperlayer];
//                            break;
//                        }
//                    }
//                    
//                    //CGPoint p = [sender locationInView:self.batsmanCell.wagonPitch_img];
//                    int Xposition = x1position+28;
//                    int Yposition = y1position;
//                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
//                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
//                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
//                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//                    shapeLayer.path = straightLinePath;
//                    UIColor *fillColor = [UIColor redColor];
//                    shapeLayer.fillColor = fillColor.CGColor;
//                    UIColor *strokeColor = [UIColor redColor];
//                    
//                    if ([objRecord.Runs isEqualToString: @"1"]) {
//                        
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"2"]){
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"3"]){
//                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"4"]){
//                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"5"]){
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"6"]){
//                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
//                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"0"]){
//                        
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
//                        
//                    }
//                    //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
//                    //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
//                    //        }
//                    
//                    
//                    
//                    
//                    shapeLayer.strokeColor = strokeColor.CGColor;
//                    shapeLayer.lineWidth = 2.0f;
//                    shapeLayer.fillRule = kCAFillRuleNonZero;
//                    shapeLayer.name = @"DrawLine";
//                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
//                    
//                }
//            }
//            }
//            
//        }
      //  else{
            NSLog(@"RH");
            
            
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            
             int BASE_X = 160;
            
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
            
            
            for(int i=0; i<expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                NSString * batstyle = objRecord.BattingStyle;
                NSString * wwregion = objRecord.Sectorregioncode;
                if(![batstyle isEqualToString:self.BatmenStyle])
                {
                    
                    //if([wwregion isEqualToString:@"MDT036"] || [wwregion isEqualToString:@"MDT037"] ||[wwregion isEqualToString:@"MDT038"] || [wwregion isEqualToString:@"MDT039"])
                     if([wwregion isEqualToString:@"MDT041"] ||[wwregion isEqualToString:@"MDT042"] ||[wwregion isEqualToString:@"MDT043"] ||[wwregion isEqualToString:@"MDT044"])
                    {
                        [onsideRegionValue addObject:objRecord];
                    }
                }
            }
            
            
            for(int i=0 ;i<expendBowlerCellArray.count;i++)
            {
                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
            if(isSectorEnableBowler == YES)
            {
                
                
                [self SectorReplaceLableMethod];
                for(int i=0; i< onsideRegionValue.count;i++)
                {
                    BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[onsideRegionValue objectAtIndex:i];
                    x1position = [objRecord.WWX1 intValue];
                    y1position = [objRecord.WWY1 intValue];
                    x2position  =[objRecord .WWX2 intValue];
                    y2position  =[objRecord.WWY2 intValue];
                    
                    
                    //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                        
                        [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode :@"MSC013":objRecord.Runs:cell];
                    //}
                }
            }
            
            else
            {

            for(int i=0; i<onsideRegionValue.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[onsideRegionValue objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }

                
             //   if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    

                    int Xposition = x1position+30;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor * strokeColor = [UIColor redColor];
                    shapeLayer.fillColor = strokeColor.CGColor;
                
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }
                
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
        
            }
            
       // }
   // }
    else if ([cell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [cell.wagonPitch_img.image  isEqual: @"pichmapLH"])
    {
        if([self.BatmenStyle isEqualToString:@"MSC013"])
        {
            NSLog(@"pichmapRH");
            
        }
        else{
            
            NSLog(@"pichmapLH");
            
        }
    }
}

-(IBAction)didClickBowlingOffSideAction:(id)sender
{
    isPitch_Img = NO;
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
    

    
    if(cell.wagonPitch_img.hidden == NO)
    {
 //       if([self.BatmenStyle isEqualToString:@"MSC012"])
//        {
//            NSLog(@"LH");
//            int x1position;
//            int x2position;
//            int y1position;
//            int y2position;
//            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
//            
//            
//            for(int i=0; i<expendBowlerCellArray.count;i++)
//            {
//                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
//                NSString * batstyle = objRecord.BattingStyle;
//                NSString * wwregion   =objRecord.WWRegion;
//                if([batstyle isEqualToString:self.BatmenStyle])
//              
//                {
//                    //if([wwregion isEqualToString:@"MSC178"] ||[wwregion isEqualToString:@"MSC171"] ||[wwregion isEqualToString:@"MSC163"] ||[wwregion isEqualToString:@"MSC156"])
//                   // {
//                        [onsideRegionValue addObject:objRecord];
//                   // }
//                    
//                }
//            }
//            
//            
//            for(int i=0 ;i<expendBowlerCellArray.count;i++)
//            {
//                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
//                {
//                    if ([layer.name isEqualToString:@"DrawLine"])
//                    {
//                        [layer removeFromSuperlayer];
//                        break;
//                    }
//                }
//            }
//            if(isSectorEnableBowler ==YES)
//            {
//                [self SectorReplaceLableMethod];
//                for(int i=0; i< onsideRegionValue.count;i++)
//                {
//                    BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[onsideRegionValue objectAtIndex:i];
//                    x1position = [objRecord.WWX1 intValue];
//                    y1position = [objRecord.WWY1 intValue];
//                    x2position  =[objRecord .WWX2 intValue];
//                    y2position  =[objRecord.WWY2 intValue];
//                    
//                    
//                    if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
//                        
//                        [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:objRecord.BattingStyle :objRecord.Runs:cell];
//                    }
//                }
//                
//            }
//            else{
//            for(int i=0; i<onsideRegionValue.count;i++)
//            {
//                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
//                x1position = [objRecord.WWX1 intValue];
//                y1position = [objRecord.WWY1 intValue];
//                x2position  =[objRecord .WWX2 intValue];
//                y2position  =[objRecord.WWY2 intValue];
//                
//                
//                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
//                    
//                    
//                    for (CALayer *layer in cell.BowlerwagonPitch_img.layer.sublayers) {
//                        if ([layer.name isEqualToString:@"DrawLine"]) {
//                            //[layer removeFromSuperlayer];
//                            break;
//                        }
//                    }
//                    
//                    //CGPoint p = [sender locationInView:self.batsmanCell.wagonPitch_img];
//                    int Xposition = x1position+28;
//                    int Yposition = y1position;
//                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
//                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
//                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
//                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//                    shapeLayer.path = straightLinePath;
//                    UIColor *fillColor = [UIColor redColor];
//                    shapeLayer.fillColor = fillColor.CGColor;
//                    UIColor *strokeColor = [UIColor redColor];
//                    
//                    if ([objRecord.Runs isEqualToString: @"1"]) {
//                        
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"2"]){
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"3"]){
//                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"4"]){
//                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"5"]){
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"6"]){
//                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
//                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
//                        
//                    }else if ([objRecord.Runs isEqualToString: @"0"]){
//                        
//                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
//                        
//                    }
//                    //        else if ([objRecord.WICKETTYPE isEqualToString:@"0"]){
//                    //            strokeColor = [UIColor colorWithRed:(150/255.0f) green:(57/255.0f) blue:(57/255.0f) alpha:1.0f];
//                    //        }
//                    
//                    
//                    
//                    
//                    shapeLayer.strokeColor = strokeColor.CGColor;
//                    shapeLayer.lineWidth = 2.0f;
//                    shapeLayer.fillRule = kCAFillRuleNonZero;
//                    shapeLayer.name = @"DrawLine";
//                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
//                    
//                }
//            }
//            }
//            
//        }
       // else{
            NSLog(@"RH");
            
            
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
             int BASE_X = 150;
            
            for(int i=0; i<expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                NSString * batsmanstyle = objRecord.BattingStyle;
                NSString * wwregion  =objRecord.Sectorregioncode;
                if(![batsmanstyle isEqualToString:self.BatmenStyle])
               
                {
                   
                    //if([wwregion isEqualToString:@"MDT041"] ||[wwregion isEqualToString:@"MDT042"] ||[wwregion isEqualToString:@"MDT043"] ||[wwregion isEqualToString:@"MDT044"])
                    if([wwregion isEqualToString:@"MDT036"] || [wwregion isEqualToString:@"MDT037"] ||[wwregion isEqualToString:@"MDT038"] || [wwregion isEqualToString:@"MDT039"])
                    {
                        [onsideRegionValue addObject:objRecord];
                    }
                }
            }
            
            
            for(int i=0 ;i<expendBowlerCellArray.count;i++)
            {
                for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
            
            if(isSectorEnableBowler ==YES)
            {
                [self SectorReplaceLableMethod];
                for(int i=0; i< onsideRegionValue.count;i++)
                {
                    BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[onsideRegionValue objectAtIndex:i];
                    x1position = [objRecord.WWX1 intValue];
                    y1position = [objRecord.WWY1 intValue];
                    x2position  =[objRecord .WWX2 intValue];
                    y2position  =[objRecord.WWY2 intValue];
                    
                    
                    //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                        
                        [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:@"MSC013" :objRecord.Runs:cell];
                    //}
                }
                
            }
       else
        {
            for(int i=0; i<onsideRegionValue.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[onsideRegionValue objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
               // if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }

    
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
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }
                
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
//}
        //}
    }
    else if ([cell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [cell.wagonPitch_img.image  isEqual: @"pichmapLH"])
    {
        if([self.BatmenStyle isEqualToString:@"MSC013"])
        {
            NSLog(@"pichmapRH");
            
        }
        else{
            
            NSLog(@"pichmapLH");
            
        }
    }

}
-(IBAction)didClickAllButtonAction:(id)sender
{
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    

    
    
    if(cell.wagonPitch_img.hidden == NO)
    {
        
        for(int i=0 ;i<expendBowlerCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        int BASE_X = 150;
        
        
        if(isSectorEnableBowler == YES)
        {
            [self SectorReplaceLableMethod];
            for(int i=0; i< expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
               // if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode :@"MSC013":objRecord.Runs:cell];
               // }
            }
            
        }
        else
        {
            for(int i=0; i< expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }
                //int Xposition = x1position;
                //int Yposition = y1position;
                

               // if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    
                    int Xposition = x1position+28;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    UIColor *strokeColor = [UIColor whiteColor];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(6/255.0f) blue:(250/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        strokeColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        strokeColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        strokeColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            //}
        }
    }
    else
    {
        for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }
        
        if(BowlerRunArray.count > 0)
        {
            for(int i=0; i< BowlerRunArray.count;i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMY2 intValue];
                
                if(!(xposition == 1 && yposition ==1)){
                    
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition-10,yposition-40,20, 20)];
                 //   Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
            {
                NSLog(@"%@",obj);
                [obj removeFromSuperview];
            }
        }
        NSLog(@"pitch");
    }
}

-(IBAction)didClickBowling1sAction:(id)sender
{
    NSMutableArray * Run1CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run1CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
    

    
    if(cell.wagonPitch_img.hidden == NO)
    {
        
        if(expendBowlerCellArray > 0)
        {
            for(int i=0; i< expendBowlerCellArray.count; i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"1"])
                {
                    [Run1CountwagonArray addObject:objRecord];
                }
            }
        }
        
        
        for(int i=0 ;i<expendBowlerCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        int BASE_X = 150;
        
        
        if(isSectorEnableBowler ==YES)
        {
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run1CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run1CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:@"MSC013" :objRecord.Runs:cell];
                }
            }
            
        }
        else
        {
            
            for(int i=0; i< Run1CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run1CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }
                
                //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    int Xposition = x1position+28;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    UIColor *strokeColor = [UIColor colorWithRed:(255/255.0f) green:(109/255.0f) blue:(37/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        //}
        
    }
    else
    {
        
        if(BowlerRunArray > 0)
        {
            for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
            {
                NSLog(@"%@",obj);
                [obj removeFromSuperview];
            }
            
            for(int i=0; i< BowlerRunArray.count; i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"1"])
                {
                    [Run1CountpitchArray addObject:objRecord];
                }
            }
        }
        
        
        
        if(Run1CountpitchArray.count > 0)
        {
            for(int i=0; i< Run1CountpitchArray.count;i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[Run1CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMY2 intValue];
                
                if(!(xposition == 1 && yposition ==1) && (xposition!=0 && yposition !=0)){
                    
                    
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition-10,yposition-40,20, 20)];
              //      Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                       // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
            for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
            {
                NSLog(@"%@",obj);
                [obj removeFromSuperview];
            }
            
            
        }
        NSLog(@"pitch");
    }

}

-(IBAction)didClickBowling2sAction:(id)sender
{
    NSMutableArray * Run2CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run2CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    

    
        if(cell.wagonPitch_img.hidden == NO)
    {
        
        if(expendBowlerCellArray > 0)
        {
            for(int i=0; i< expendBowlerCellArray.count; i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"2"])
                {
                    [Run2CountwagonArray addObject:objRecord];
                }
            }
        }

        
        for(int i=0 ;i<expendBowlerCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        int BASE_X = 150;

        
        
        if(isSectorEnableBowler ==YES)
        {
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run2CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run2CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:@"MSC013" :objRecord.Runs:cell];
               // }
            }
            
        }
        else
        {
            
            for(int i=0; i< Run2CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run2CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }
                
              //  if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    
                
                    int Xposition = x1position+28;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    UIColor * strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];

                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
       // }
        
    }
    else
    {
        for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }

        if(BowlerRunArray > 0)
        {
            for(int i=0; i< BowlerRunArray.count; i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"2"])
                {
                    [Run2CountpitchArray addObject:objRecord];
                }
            }
        }

        
        if(Run2CountpitchArray.count > 0)
        {
            for(int i=0; i< Run2CountpitchArray.count;i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[Run2CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMY2 intValue];
                
                if(!(xposition == 1 && yposition ==1) && (xposition!=0 && yposition !=0)){
                    
                    
                    //        if(Img_ball != nil)
                    //        {
                    //            [Img_ball removeFromSuperview];
                    //        }
                    //
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition-10,yposition-40,20, 20)];
                 //   Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                        //Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
           
                for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
                
                
            
        }
        NSLog(@"pitch");
    }

}
-(IBAction)didClickBowling3sAction:(id)sender
{
    NSMutableArray * Run3CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run3CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
       if(cell.wagonPitch_img.hidden == NO)
    {
        if(expendBowlerCellArray > 0)
        {
            for(int i=0; i< expendBowlerCellArray.count; i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"3"])
                {
                    [Run3CountwagonArray addObject:objRecord];
                }
            }
        }
        
        for(int i=0 ;i<expendBowlerCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        int BASE_X = 150;
        
        if(isSectorEnableBowler ==YES)
        {
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run3CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run3CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
               // if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:@"MSC013":objRecord.Runs:cell];
               // }
            }
            
        }
        else
        {
            
            for(int i=0; i< Run3CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run3CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }
                
               // if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                
                    int Xposition = x1position+28;
                    int Yposition = y1position;
                    CGMutablePathRef straightLinePath = CGPathCreateMutable();
                    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
                    CGPathAddLineToPoint(straightLinePath, NULL,x2position+28,y2position);
                    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                    shapeLayer.path = straightLinePath;
                    UIColor *fillColor = [UIColor redColor];
                    shapeLayer.fillColor = fillColor.CGColor;
                    UIColor *strokeColor = [UIColor colorWithRed:(188/255.0f) green:(182/255.0f) blue:(49/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        //}
        
    }
    else
    {
        for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }

        if(BowlerRunArray > 0)
        {
            for(int i=0; i< BowlerRunArray.count; i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"3"])
                {
                    [Run3CountpitchArray addObject:objRecord];
                }
            }
        }

        
        if(Run3CountpitchArray.count > 0)
        {
            for(int i=0; i< Run3CountpitchArray.count;i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[Run3CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMY2 intValue];
                
                if(!(xposition == 1 && yposition ==1) && (xposition!=0 && yposition !=0)){
                    
                    
                    //        if(Img_ball != nil)
                    //        {
                    //            [Img_ball removeFromSuperview];
                    //        }
                    //
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition-10,yposition-40,20, 20)];
                   // Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                       // Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
             for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
            
        }
        NSLog(@"pitch");
    }

}

-(IBAction)didClickBowling4sAction:(id)sender
{
    NSMutableArray * Run4CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run4CountpitchArray =[[NSMutableArray alloc]init];
    
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    

    if(cell.wagonPitch_img.hidden == NO)
    {
        if(expendBowlerCellArray > 0)
        {
            for(int i=0; i< expendBowlerCellArray.count; i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"4"])
                {
                    [Run4CountwagonArray addObject:objRecord];
                }
            }
        }

        
        for(int i=0 ;i<expendBowlerCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        int BASE_X = 150;
        
        if(isSectorEnableBowler ==YES)
        {
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run4CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run4CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:@"MSC013" :objRecord.Runs:cell];
               // }
            }
            
        }
        else
        {
            
            for(int i=0; i< Run4CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run4CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }
                
                
                //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    
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
                    UIColor *strokeColor = [UIColor colorWithRed:(217/255.0f) green:(32/255.0f) blue:(35/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        //}
        
    }
    else
    {
        for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }

        if(BowlerRunArray > 0)
        {
            for(int i=0; i< BowlerRunArray.count; i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"4"])
                {
                    [Run4CountpitchArray addObject:objRecord];
                }
            }
        }
        
        
        if(Run4CountpitchArray.count > 0)
        {
            for(int i=0; i< Run4CountpitchArray.count;i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[Run4CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMY2 intValue];
                
                if(!(xposition == 1 && yposition ==1) && (xposition!=0 && yposition !=0)){
                    
                    
                    //        if(Img_ball != nil)
                    //        {
                    //            [Img_ball removeFromSuperview];
                    //        }
                    //
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition-10,yposition-40,20, 20)];
                //    Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                      //  Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
 
                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
               for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
            
        }
        NSLog(@"pitch");
    }

}

-(IBAction)didClickBowling6sAction:(id)sender
{
    NSMutableArray * Run6CountwagonArray =[[NSMutableArray alloc]init];
    
    NSMutableArray * Run6CountpitchArray =[[NSMutableArray alloc]init];
    UIButton *button = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    ScoreCardCellTVCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    
    
       if(cell.wagonPitch_img.hidden == NO)
    {
        
        if(expendBowlerCellArray > 0)
        {
            for(int i=0; i< expendBowlerCellArray.count; i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"6"])
                {
                    [Run6CountwagonArray addObject:objRecord];
                }
            }
        }

        
        for(int i=0 ;i<expendBowlerCellArray.count;i++)
        {
            for (CALayer *layer in cell.wagonPitch_img.layer.sublayers)
            {
                if ([layer.name isEqualToString:@"DrawLine"])
                {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
        
        int x1position;
        int y1position;
        int x2position;
        int y2position;
        
        int BASE_X = 150;
        
        if(isSectorEnableBowler ==YES)
        {
            [self SectorReplaceLableMethod];
            for(int i=0; i< Run6CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run6CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:@"MSC013" :objRecord.Runs:cell];
                //}
            }
            
        }
        else
        {
            
            for(int i=0; i< Run6CountwagonArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[Run6CountwagonArray objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                if ([objRecord.BattingStyle isEqualToString:@"MSC012"]) {
                    
                    x2position = BASE_X + (BASE_X - x2position);
                    
                }
                
                //if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    
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
                    UIColor *strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [cell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        //}
        
    }
    else
    {
        for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
        {
            NSLog(@"%@",obj);
            [obj removeFromSuperview];
        }

        if(BowlerRunArray > 0)
        {
            for(int i=0; i< BowlerRunArray.count; i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[BowlerRunArray objectAtIndex:i];
                if([objRecord.Runs isEqualToString:@"6"])
                {
                    [Run6CountpitchArray addObject:objRecord];
                }
            }
        }

        if(Run6CountpitchArray.count > 0)
        {
            for(int i=0; i< Run6CountpitchArray.count;i++)
            {
                BowlerStrickPitchRecord * objRecord =(BowlerStrickPitchRecord *)[Run6CountpitchArray objectAtIndex:i];
                
                int xposition;
                int yposition;
                
                
                xposition = [objRecord.PMX2 intValue];
                yposition = [objRecord.PMY2 intValue];
                
                if(!(xposition == 1 && yposition ==1) && (xposition!=0 && yposition !=0)){
                    
                    
                    //        if(Img_ball != nil)
                    //        {
                    //            [Img_ball removeFromSuperview];
                    //        }
                    //
                    Img_ball =[[UIButton alloc]initWithFrame:CGRectMake(xposition-10,yposition-40,20, 20)];
                   // Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    Img_ball.layer.cornerRadius =10;
                    Img_ball.layer.masksToBounds=YES;
                    //Img_ball.image =[UIImage imageNamed:@"RedBall"];
                    
                    if ([objRecord.Runs isEqualToString: @"1"]) {
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(108/255.0f) blue:(0/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"2"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"3"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(221/255.0f) green:(245/255.0f) blue:(10/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"4"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(208/255.0f) green:(31/255.0f) blue:(27/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"5"]){
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(204/255.0f) blue:(153/255.0f) alpha:1.0f];
                        
                    }else if ([objRecord.Runs isEqualToString: @"6"]){
                      //  Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];
                        Img_ball.backgroundColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];

                    }else if ([objRecord.Runs isEqualToString: @"0"]){
                        
                        Img_ball.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1.0f];
                        
                    }

                    [cell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
              for(UIImageView * obj in [cell.BowlerwagonPitch_img subviews])
                {
                    NSLog(@"%@",obj);
                    [obj removeFromSuperview];
                }
        }
        NSLog(@"pitch");
    }
}

-(void)teamLogo{


    NSMutableArray *mTeam = [[NSMutableArray alloc]init];
    [mTeam addObject:self.matchCode];
    if(fetchScorecard.CURRENTBATTINGTEAMCODE > 0)
    {
    [mTeam addObject:fetchScorecard.CURRENTBATTINGTEAMCODE];

    }
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

-(UIColor*)colorWithHexString:(NSString*)hex
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0f];
    
    return color;
}

-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2374CD"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#000000"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}


-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.btn_fst_inns_id];
    [self setInningsButtonUnselect:self.btn_sec_inns_id];
    [self setInningsButtonUnselect:self.btn_third_inns_id];
    [self setInningsButtonUnselect:self.btn_fourth_inns_id];
    
    
    [self.btn_fst_inns_id setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.fstInnShortName] forState:UIControlStateNormal];
    [self.btn_sec_inns_id setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.secInnShortName] forState:UIControlStateNormal];
    [self.btn_third_inns_id setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.thrdInnShortName] forState:UIControlStateNormal];
    [self.btn_fourth_inns_id setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.frthInnShortName] forState:UIControlStateNormal];
    
    
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.btn_fst_inns_id];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.btn_sec_inns_id];
        
    }else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.btn_third_inns_id];
        
    }else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.btn_fourth_inns_id];
        
    }
}
-(void) setInningsView{
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){//T20
        
        self.btn_fst_inns_id.hidden = NO;
        self.btn_sec_inns_id.hidden = NO;
        self.btn_third_inns_id.hidden = YES;
        self.btn_fourth_inns_id.hidden = YES;
        
        //   [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //[self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        self.inns_one_width.constant = 384;
        self.inns_two_width.constant = 384;
        
        
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){//ODI
        self.btn_fst_inns_id.hidden = NO;
        self.btn_sec_inns_id.hidden = NO;
        self.btn_third_inns_id.hidden = YES;
        self.btn_fourth_inns_id.hidden = YES;
        
        
        self.inns_one_width.constant = 384;
        self.inns_two_width.constant = 384;
        
        //   [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //   [self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        
    }else if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){//Test
        
        self.btn_fst_inns_id.hidden = NO;
        self.btn_sec_inns_id.hidden = NO;
        self.btn_third_inns_id.hidden = NO;
        self.btn_fourth_inns_id.hidden = NO;
    }
}



- (IBAction)btn_fst_inns_action:(id)sender {
   // self.lbl_strip.constant=0;
    //inningsNo = @"1";
//    [self reloadScroeCard];
    
    
    
    isFirstInn = YES;
    isSecInn = NO;
    isThirdInn = NO;
    isFourthInn = NO;
    //isDone = NO;
    
    [self setInningsBySelection:@"1"];
    [self setInningsView];
    [self reloadScroeCard:@"1"];
    
    //self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
   // _bowlerArray = [objDBManagerSpiderWagonReport getBowlerdetail:self.matchCode :_teamBcode:@"1"];
    
   // _sectorWagonArray = [objDBManagerSpiderWagonReport getSectorWagon:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"1" :@"" :@"" :@"" :@"" :@"" :@""];
    
   // _totalRuns =  [objDBManagerSpiderWagonReport getTotalRuns:self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode :@"1"];
   // _tRuns = [NSNumber numberWithInt:[_totalRuns intValue]];
    
    
   // [self displayRuns];
    
    //[self.tbl_players reloadData];

    
}
- (IBAction)btn_sec_inns_action:(id)sender {
    //self.lbl_strip.constant=self.btn_sec_inns_id.frame.origin.x;
//inningsNo = @"2";
    
    isFirstInn = NO;
    isSecInn = YES;
    isThirdInn = NO;
    isFourthInn = NO;
    //isDone = NO;
    
    [self setInningsBySelection:@"2"];
    [self setInningsView];
    [self reloadScroeCard:@"2"];
}
- (IBAction)btn_third_inns_action:(id)sender {
    //self.lbl_strip.constant=self.btn_third_inns_id.frame.origin.x;
    //inningsNo = @"3";
    
    isFirstInn = NO;
    isSecInn = NO;
    isThirdInn = YES;
    isFourthInn = NO;
    //isDone = NO;
    
    [self setInningsBySelection:@"3"];
    [self setInningsView];
    [self reloadScroeCard:@"3"];
}
- (IBAction)btn_fourth_inns_action:(id)sender {
    //self.lbl_strip.constant=self.btn_fourth_inns_id.frame.origin.x;
    //inningsNo = @"4";
    
    isFirstInn = NO;
    isSecInn = NO;
    isThirdInn = NO;
    isFourthInn = YES;
    //isDone = NO;
    
    [self setInningsBySelection:@"4"];
    [self setInningsView];
    [self reloadScroeCard:@"4"];
}

-(IBAction)didClickScoreCardAction:(id)sender
{
    self.lbl_header_strip.constant=0;
    self.view_common.hidden =NO;
    if(spiderView!=nil)
    {
        [spiderView.view removeFromSuperview];
    }
    if(cmntryView!=nil)
    {
        [cmntryView.view removeFromSuperview];
    }
}

-(IBAction)didClickCommentryAction:(id)sender
{
    self.lbl_header_strip.constant=self.btn_commentry.frame.origin.x;
    self.view_common.hidden =YES;
    if(spiderView!=nil)
    {
        [spiderView.view removeFromSuperview];
    }
    [self setCommentaryView];

}

-(IBAction)didClickWagonAction:(id)sender
{
    self.lbl_header_strip.constant=self.btn_wangonWheel.frame.origin.x;
     self.view_common.hidden =YES;
    if(cmntryView!=nil)
    {
        [cmntryView.view removeFromSuperview];
    }

    [self setSpiderView];
}

-(void) setCommentaryView{
    cmntryView = [[CommentaryVC alloc]initWithNibName:@"CommentaryVC" bundle:nil];
    cmntryView.matchCode = self.matchCode;
    cmntryView.matchTypeCode =self.matchTypeCode;
    
    cmntryView.fstInnShortName = self.fstInnShortName;
    cmntryView.secInnShortName = self.secInnShortName;
    cmntryView.thrdInnShortName = self.thrdInnShortName;
    cmntryView.frthInnShortName = self.frthInnShortName;
    cmntryView.scordSelectCmty =YES;
    cmntryView.view.frame =CGRectMake(0,self.view_common.frame.origin.y+self.view_headerview.frame.size.height+30,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:cmntryView.view];
}

-(void) setSpiderView{
    
    spiderView = [[SpiderWagonReportVC alloc]initWithNibName:@"SpiderWagonReportVC" bundle:nil];
    spiderView.matchCode = self.matchCode;
    spiderView.compititionCode = self.competitionCode;
    spiderView.matchTypeCode = self.matchTypeCode;
    
    
    spiderView.fstInnShortName = self.fstInnShortName;
    spiderView.secInnShortName = self.secInnShortName;
    spiderView.thrdInnShortName = self.thrdInnShortName;
    spiderView.frthInnShortName = self.frthInnShortName;
    spiderView.scordtoSelectview =YES;
    
    spiderView.view.frame =CGRectMake(0,self.view_common.frame.origin.y+self.view_headerview.frame.size.height+30,self.view.frame.size.width,self.view.frame.size.height-180);
    
    //    spiderView.view.frame =CGRectMake(0,180,self.view.frame.size.width,self.view.frame.size.height-180);
    [self.view addSubview:spiderView.view];
    
}


-(void) reloadScroeCard :(NSString *) inningsno{
    @try {
        fetchScorecard = [[FetchScorecard alloc]init];
        [fetchScorecard FetchScoreBoard:competitionCode :matchCode :inningsno];
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



-(void)sectorWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) batmanStyle :(NSString *) Run :(ScoreCardCellTVCell *)cell;

{
    
    if([Run isEqualToString:@"1"])
    {
        Run1Count++;
    }
    else if ([Run isEqualToString:@"0"])
    {
        zerocount++;
    }
    else if ([Run isEqualToString:@"2"])
    {
        Run2Count++;
    }
    else if ([Run isEqualToString:@"3"])
    {
        Run3Count++;
    }
    else if ([Run isEqualToString:@"4"])
    {
        Run4Count++;
    }
    else if ([Run isEqualToString:@"6"])
    {
        Run6Count++;
    }

    
    if([secotorwognwheelcode isEqualToString:@"MDT036"])
    {
        if(fineleg_lbl !=nil)
        {
            [fineleg_lbl removeFromSuperview];
        }

        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
           // fineleg++;
            finelegRun = [Run intValue]+finelegRun;
            fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(110, 30,35, 35)];

        }
        else
        {
           // fineleg++;
             NSLog(@"RH");
            finelegRun = [Run intValue]+finelegRun;
            fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];

        }
        
        
        fineleg_lbl.textColor=[UIColor whiteColor];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        [cell.wagonPitch_img addSubview:fineleg_lbl];
        
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT037"])
    {
        
        if(squareleg_lbl !=nil)
        {
            [squareleg_lbl removeFromSuperview];
        }

        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
            squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,110,35, 35)];

        }
        else
        {
            NSLog(@"RH");
//            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
            squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,110,35, 35)];

        }
        
        
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [cell.wagonPitch_img addSubview:squareleg_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT038"])
    {
        if(midWicket_lbl !=nil)
        {
            [midWicket_lbl removeFromSuperview];
        }
        
        
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            ///midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
            midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];

        }
        else
        {
            NSLog(@"RH");
            //midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
            midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];

        }
       

        
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [cell.wagonPitch_img addSubview:midWicket_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT039"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
           // longon++;
            longonRun =longonRun+[Run intValue];
            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,270,35, 35)];

        }
        else
        {
//            NSLog(@"RH");
//longon++;
            longonRun =longonRun+[Run intValue];
            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];

        }
        
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }
        
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [cell.wagonPitch_img addSubview:longon_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT041"])
    {
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }

        
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
           // longoff++;
            longoffRun =longoffRun +[Run intValue];
            longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,260,35, 35)];

        }
        else
        {
//            NSLog(@"RH");
           // longoff++;
            longoffRun =longoffRun +[Run intValue];
            longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(110,260,35, 35)];

        }
        
        
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        [cell.wagonPitch_img addSubview:longoff_lbl];

        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT042"])
    {
        
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //cover++;
            coverRun = coverRun+[Run intValue];
            cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,200,35, 35)];

        }
        else
        {
//            NSLog(@"RH");
//           // cover++;
            coverRun = coverRun+[Run intValue];
            cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,200,35, 35)];

        }
        
        
        
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [cell.wagonPitch_img addSubview:cover_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT043"])
    {
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }
        

        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
           // point++;
            pointRun = pointRun+[Run intValue];
            point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,120,35, 35)];


        }
        else
        {
//            NSLog(@"RH");
//            //point++;
            pointRun = pointRun+[Run intValue];
            point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];

        }
        
        
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [cell.wagonPitch_img addSubview:point_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT044"])
    {
        if(Thirdman_lbl !=nil)
        {
            [Thirdman_lbl removeFromSuperview];
        }
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
           // ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
            Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,40,35, 35)];

        }
        else
        {
            NSLog(@"RH");
//            //ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
            Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];

        }
        
        
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [cell.wagonPitch_img addSubview:Thirdman_lbl];
       
    }
 
     [cell.WangonAll_Btn setTitle:[NSString stringWithFormat:@"ALL"] forState:UIControlStateNormal];
    
    
    [cell.wangon1s_Btn setTitle:[NSString stringWithFormat:@"1s|%d",Run1Count] forState:UIControlStateNormal];
    
    [cell.wangon2s_Btn setTitle:[NSString stringWithFormat:@"2s|%d",Run2Count] forState:UIControlStateNormal];
    
    [cell.wangon3s_Btn setTitle:[NSString stringWithFormat:@"3s|%d",Run3Count] forState:UIControlStateNormal];
    
    [cell.wangon4s_Btn setTitle:[NSString stringWithFormat:@"4s|%d",Run4Count] forState:UIControlStateNormal];
    
    [cell.wangon6s_Btn setTitle:[NSString stringWithFormat:@"6s|%d",Run6Count] forState:UIControlStateNormal];
    

}

-(void)BowlersectorWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) BatmenStyle :(NSString *) Run :(ScoreCardCellTVCell *) cell
        
{
    
    if([Run isEqualToString:@"1"])
    {
        Run1Count++;
    }
    else if ([Run isEqualToString:@"0"])
    {
        zerocount++;
    }
    else if ([Run isEqualToString:@"2"])
    {
        Run2Count++;
    }
    else if ([Run isEqualToString:@"3"])
    {
        Run3Count++;
    }
    else if ([Run isEqualToString:@"4"])
    {
        Run4Count++;
    }
    else if ([Run isEqualToString:@"6"])
    {
        Run6Count++;
    }

            
    if([secotorwognwheelcode isEqualToString:@"MDT036"])
    {
        
        

        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //        fineleg++;
            finelegRun = [Run intValue]+finelegRun;
            fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(100, 30,35, 35)];
            fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
            
        }
        else
        {
            //          fineleg++;
            NSLog(@"RH");
            finelegRun = [Run intValue]+finelegRun;
            fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
            fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
           // finelegRun =finelegRun-finelegRun;
            
        }
        
        if(fineleg_lbl !=nil)
        {
            [fineleg_lbl removeFromSuperview];
        }
        fineleg_lbl.textColor=[UIColor whiteColor];
        
        [cell.wagonPitch_img addSubview:fineleg_lbl];
        
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT037"])
    {
        if(squareleg_lbl !=nil)
        {
            [squareleg_lbl removeFromSuperview];
        }
        
        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
            squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,110,35, 35)];
            
        }
        else
        {
            NSLog(@"RH");
            //  squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
            squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(300,110,35, 35)];
            
        }
        
        
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [cell.wagonPitch_img addSubview:squareleg_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT038"])
    {
        
        if(midWicket_lbl !=nil)
        {
            [midWicket_lbl removeFromSuperview];
        }
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //     midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
            midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];
            
        }
        else
        {
            NSLog(@"RH");
            ////                    midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
            midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
            
        }
        
        
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [cell.wagonPitch_img addSubview:midWicket_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT039"])
    {
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }

        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //   longon++;
            longonRun =longonRun+[Run intValue];
            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(100,270,35, 35)];
            
        }
        else
        {
            NSLog(@"RH");
            //            longon++;
            longonRun =longonRun+[Run intValue];
            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
            
        }
        
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [cell.wagonPitch_img addSubview:longon_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT041"])
    {
        
        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //          longoff++;
            longoffRun =longoffRun +[Run intValue];
            
//            if(longoff_lbl !=nil)
//            {
//                [longoff_lbl removeFromSuperview];
//            }

            
            longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
            longoff_lbl.textColor=[UIColor whiteColor];
            longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
            

             [cell.wagonPitch_img addSubview:longoff_lbl];
            
        }
        else
        {
            NSLog(@"RH");
            //                    longoff++;
            longoffRun = longoffRun +[Run intValue];
            
            

            longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(110,270,35, 35)];
            longoff_lbl.textColor=[UIColor whiteColor];
            longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
            

             [cell.wagonPitch_img addSubview:longoff_lbl];
            
        }
        
        
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT042"])
    {
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
        
        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //  cover++;
            coverRun = coverRun+[Run intValue];
            cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,180,35, 35)];
            
        }
        else
        {
            // NSLog(@"RH");
            //cover++;
            coverRun = coverRun+[Run intValue];
            cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,180,35, 35)];
            
        }
        
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [cell.wagonPitch_img addSubview:cover_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT043"])
    {
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }
        
        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //
            pointRun=pointRun+[Run intValue];
            point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,100,35, 35)];
            
            //point++;
        }
        else
        {
            NSLog(@"RH");
            pointRun=pointRun+[Run intValue];
            point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];
            
            //     point++;
        }
        
        
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [cell.wagonPitch_img addSubview:point_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT044"])
    {
        if(Thirdman_lbl !=nil)
        {
            [Thirdman_lbl removeFromSuperview];
        }

        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //    ThirdmanCount++;
            ThirdmanCountRun=ThirdmanCountRun+[Run intValue];
            Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,40,35, 35)];
            
        }
        else
        {
            NSLog(@"RH");
            //ThirdmanCount++;
            ThirdmanCountRun=ThirdmanCountRun+[Run intValue];
            Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            
            
        }
        
        
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [cell.wagonPitch_img addSubview:Thirdman_lbl];
        
    }
    
    [cell.BowlerWangonAll_Btn setTitle:[NSString stringWithFormat:@"ALL"] forState:UIControlStateNormal];
    
    [cell.Bowlerwangon1s_Btn setTitle:[NSString stringWithFormat:@"1s|%d",Run1Count] forState:UIControlStateNormal];
    
    [cell.Bowlerwangon2s_Btn setTitle:[NSString stringWithFormat:@"2s|%d",Run2Count] forState:UIControlStateNormal];
    
    [cell.Bowlerwangon3s_Btn setTitle:[NSString stringWithFormat:@"3s|%d",Run3Count] forState:UIControlStateNormal];
    
    [cell.Bowlerwangon4s_Btn setTitle:[NSString stringWithFormat:@"4s|%d",Run4Count] forState:UIControlStateNormal];
    
    [cell.Bowlerwangon6s_Btn setTitle:[NSString stringWithFormat:@"6s|%d",Run6Count] forState:UIControlStateNormal];
    
}

-(void) SectorReplaceLableMethod
{
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

    finelegRun =0;
    squarelegRun=0;
    midWicketRun=0;
    longonRun=0;
    longoffRun=0;
    coverRun =0;
    pointRun=0;
    ThirdmanCountRun=0;
    
    
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    
   


}
-(void)sectorRunReplaceWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) batmanStyle :(NSString *) Run :(ScoreCardCellTVCell *) cell
{
    if([Run isEqualToString:@"1"])
    {
        Run1Count++;
    }
    else if ([Run isEqualToString:@"0"])
    {
        zerocount++;
    }
    else if ([Run isEqualToString:@"2"])
    {
        Run2Count++;
    }
    else if ([Run isEqualToString:@"3"])
    {
        Run3Count++;
    }
    else if ([Run isEqualToString:@"4"])
    {
        Run4Count++;
    }
    else if ([Run isEqualToString:@"6"])
    {
        Run6Count++;
    }
    
    
    if([secotorwognwheelcode isEqualToString:@"MDT036"])
    {
        if(fineleg_lbl !=nil)
        {
            [fineleg_lbl removeFromSuperview];
        }

        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // fineleg++;
            finelegRun = [Run intValue]+finelegRun;
            fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50, 30,35, 35)];

        }
        else
        {
            // fineleg++;
            NSLog(@"RH");
            finelegRun = [Run intValue]+finelegRun;
            fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];

        }
        
        
        fineleg_lbl.textColor=[UIColor whiteColor];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        [cell.wagonPitch_img addSubview:fineleg_lbl];
        
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT037"])
    {
        if(squareleg_lbl !=nil)
        {
            [squareleg_lbl removeFromSuperview];
        }
        
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
            squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,110,35, 35)];

        }
        else
        {
            NSLog(@"RH");
            //            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
            squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,110,35, 35)];

        }
        
        
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [cell.wagonPitch_img addSubview:squareleg_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT038"])
    {
        if(midWicket_lbl !=nil)
        {
            [midWicket_lbl removeFromSuperview];
        }
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            ///midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
            midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];

        }
        else
        {
            NSLog(@"RH");
            //midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
            midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];

        }
        
        
        
        
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [cell.wagonPitch_img addSubview:midWicket_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT039"])
    {
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }
        
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // longon++;
            longonRun =longonRun+[Run intValue];
            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(60,270,35, 35)];

        }
        else
        {
            //            NSLog(@"RH");
            //longon++;
            longonRun =longonRun+[Run intValue];
            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];

        }
        
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [cell.wagonPitch_img addSubview:longon_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT041"])
    {
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }

        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // longoff++;
            longoffRun =longoffRun +[Run intValue];
            longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];

        }
        else
        {
            //            NSLog(@"RH");
            // longoff++;
            longoffRun =longoffRun +[Run intValue];
            longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];

        }
        
        
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        [cell.wagonPitch_img addSubview:longoff_lbl];
        
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT042"])
    {
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }

        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //cover++;
            coverRun = coverRun+[Run intValue];
            cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,100,35, 35)];

        }
        else
        {
            //            NSLog(@"RH");
            //           // cover++;
            coverRun = coverRun+[Run intValue];
            cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];

        }
        
        
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [cell.wagonPitch_img addSubview:cover_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT043"])
    {
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }

        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // point++;
            pointRun = pointRun+[Run intValue];
            point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,120,35, 35)];

            
        }
        else
        {
            //            NSLog(@"RH");
            //            //point++;
            pointRun = pointRun+[Run intValue];
            point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];

        }
        
        
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [cell.wagonPitch_img addSubview:point_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT044"])
    {
        if(Thirdman_lbl !=nil)
        {
            [Thirdman_lbl removeFromSuperview];
        }
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            // ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
            Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,40,35, 35)];

        }
        else
        {
            NSLog(@"RH");
            //            //ThirdmanCount++;
            ThirdmanCountRun = ThirdmanCountRun+[Run intValue];
            Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];

            
            
        }
        
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [cell.wagonPitch_img addSubview:Thirdman_lbl];
        
    }
}

-(void)BowlersectorRunReplaceWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) BatmenStyle :(NSString *) Run:(ScoreCardCellTVCell *) cell
{
    if([Run isEqualToString:@"1"])
    {
        Run1Count++;
    }
    else if ([Run isEqualToString:@"0"])
    {
        zerocount++;
    }
    else if ([Run isEqualToString:@"2"])
    {
        Run2Count++;
    }
    else if ([Run isEqualToString:@"3"])
    {
        Run3Count++;
    }
    else if ([Run isEqualToString:@"4"])
    {
        Run4Count++;
    }
    else if ([Run isEqualToString:@"6"])
    {
        Run6Count++;
    }
    
    
    if([secotorwognwheelcode isEqualToString:@"MDT036"])
    {
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //        fineleg++;
            finelegRun = [Run intValue]+finelegRun;
        }
        else
        {
            //          fineleg++;
            NSLog(@"RH");
            finelegRun = [Run intValue]+finelegRun;
        }
        
        if(fineleg_lbl !=nil)
        {
            [fineleg_lbl removeFromSuperview];
        }
        
        fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
        fineleg_lbl.textColor=[UIColor whiteColor];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        [cell.wagonPitch_img addSubview:fineleg_lbl];
        
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT037"])
    {
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            //  squareleg++;
            squarelegRun =squarelegRun+[Run intValue];
        }
        
        if(squareleg_lbl !=nil)
        {
            [squareleg_lbl removeFromSuperview];
        }
        
        squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(300,110,35, 35)];
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [cell.wagonPitch_img addSubview:squareleg_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT038"])
    {
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //     midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            ////                    midWicket++;
            midWicketRun =midWicketRun+[Run intValue];
        }
        if(midWicket_lbl !=nil)
        {
            [midWicket_lbl removeFromSuperview];
        }
        
        midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [cell.wagonPitch_img addSubview:midWicket_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT039"])
    {
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
        
            longonRun =longonRun+[Run intValue];
        
        }
        else
        {
            longonRun =longonRun+[Run intValue];
            
        }
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }
        longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [cell.wagonPitch_img addSubview:longon_lbl];
        

        
            }
    else if([secotorwognwheelcode isEqualToString:@"MDT041"])
    {
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }
        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            
            longoffRun =longoffRun +[Run intValue];
            
        }
        else
        {
           
            longoffRun =longoffRun +[Run intValue];
            
       }
        longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(110,270,35, 35)];
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        
        
        [cell.wagonPitch_img addSubview:longoff_lbl];

        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT042"])
    {
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
 
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //  cover++;
            coverRun = coverRun+[Run intValue];
        }
        else
        {
            // NSLog(@"RH");
            //cover++;
            coverRun = coverRun+[Run intValue];
        }
        
        
        cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [cell.wagonPitch_img addSubview:cover_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT043"])
    {
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }
        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //
            pointRun=pointRun+[Run intValue];
            //point++;
        }
        else
        {
            NSLog(@"RH");
            pointRun=pointRun+[Run intValue];
            //     point++;
        }
        
        
       
        point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [cell.wagonPitch_img addSubview:point_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT044"])
    {
        
        if(Thirdman_lbl !=nil)
        {
            [Thirdman_lbl removeFromSuperview];
        }
        
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //    ThirdmanCount++;
            ThirdmanCountRun=ThirdmanCountRun+[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            //ThirdmanCount++;
            ThirdmanCountRun=ThirdmanCountRun+[Run intValue];
            
        }
        
        
        
        Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [cell.wagonPitch_img addSubview:Thirdman_lbl];
        
    }

}
@end
