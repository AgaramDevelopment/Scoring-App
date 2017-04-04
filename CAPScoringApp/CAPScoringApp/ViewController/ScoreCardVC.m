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
    //int bowlerIndex;
    
    int expendIndex;
    
    NSMutableArray * expendBattsmanCellArray;
    NSMutableArray * expendBowlerCellArray;
    
    BOOL isSectorEnableBatsman;
    BOOL isSectorEnableBowler;
    BOOL isScrollheight;
    CGFloat tableheight;

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
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //Show indicator
    [delegate showLoading];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(TimerStop)
                                   userInfo:nil
                                    repeats:NO];
   
}
-(void)TimerStop
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //Show indicator
    [delegate hideLoading];
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
        
      
        
        BowlingSummaryDetailsForScoreBoard *bowlingSummaryDetailsForSB = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:expendIndex-bowlerPostion];
       expendBowlerCellArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSWagon:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];
        
        BowlerRunArray =[objBowlingStatistics GetFETCHSBBOWLINGPLAYERSTATISTICSPitch:competitionCode :matchCode :inningsNo :bowlingSummaryDetailsForSB.BOWLERCODE];
        
        
        
        [self.bowlerCell.BowlerspiderWagon_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
   
    //self.tblView_Height.constant = self.table.contentSize.height+500;
    
    
//    self.tblView_Height.constant =self.table.contentSize.height+500;
//    [self.backScroll setContentSize:CGSizeMake(self.table.frame.size.width,self.tblView_Height.constant)];
   

    
   
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
        //self.tblView_Height.constant =tableheight-550;
        //[self.backScroll setContentSize:CGSizeMake(self.table.frame.size.width,tableheight-550)];
       
    }];
    //self.tblView_Height.constant = self.table.contentSize.height-500;
    //[self.table reloadData];
//    self.tblView_Height.constant =self.table.contentSize.height-500;
   // [self.backScroll setContentSize:CGSizeMake(self.table.frame.size.width,2000)];
  
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
        //if (cell == nil) {
        
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.batsmanCell;
           // self.batsmanCell = nil;
            
            
        //}
        
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
        if (isExpanded== NO) //prepare the cell as if it was collapsed! (without any animation!)
        {

            ExpandBattingview.hidden = YES;
        
            
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
        cell.lbl_batsman_mins.text = battingSummaryDetailsForSB.DURATION;
        
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
        //bowlerIndex = indexPath.row-bowlerPostion;
        
        ScoreCardCellTVCell *bowlerCellTvc = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:bowlerCell];
       // if (bowlerCellTvc == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            bowlerCellTvc = self.bowlerCell;
            //self.bowlerCell = nil;
        //}
        
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
        
        
        [bowlerCellTvc.BowlerWangonAll_Btn addTarget:self action:@selector(didClickAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
   
   
     NSLog(@"scroll=%ld",(long)self.tblView_Height.constant);
    
    if(indexPath.row == 0){
        return 44;
    }else if(batsmanPostion <= indexPath.row && extraPostion>indexPath.row){
        
        if (indexPath == selectedIndexPath && isexpanded==YES)
        {
            ExpandBattingview.hidden=NO;
            
            //self.tblView_Height.constant =tableheight+550;
            //[self.backScroll setContentSize:CGSizeMake(self.table.frame.size.width,self.table.contentSize.height+550)];
            return 550;
        }
        else{
            ExpandBattingview.hidden=YES;

//            if(indexPath.row == 0)
//            {
//                return 550;
//            }

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
           // self.tblView_Height.constant =tableheight+550;
           // [self.backScroll setContentSize:CGSizeMake(self.table.frame.size.width,tableheight+550)];
            NSLog(@"expendscroll=%ld",(long)self.tblView_Height.constant);
            return 550;
        }
        else{
            ExpandBowlerView.hidden=YES;
            return 70;
        }
        
    }
   

    return 0;
}

-(IBAction)didClickSpiderWagonAction:(id)sender
{
    isPitch_Img = NO;
    
     isSectorEnableBatsman=NO;
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
        [self.batsmanCell.onSide_Btn setTitle:@"OnSide" forState:UIControlStateNormal];
        [self.batsmanCell.offSide_Btn setTitle:@"OffSide" forState:UIControlStateNormal];
        
    }
    else
    {
        
        self.batsmanCell.wagonPitch_img.image=[UIImage imageNamed:@"RHWagon"];
        
        [self.batsmanCell.onSide_Btn setTitle:@"OffSide" forState:UIControlStateNormal];
        [self.batsmanCell.offSide_Btn setTitle:@"OnSide" forState:UIControlStateNormal];
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
        [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
        
    }
    }
    
}

-(IBAction)didClickSectorWagonAction:(id)sender
{
    isPitch_Img = NO;
    isSectorEnableBatsman=YES;
   
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
        for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers) {
            if ([layer.name isEqualToString:@"DrawLine"]) {
                [layer removeFromSuperlayer];
                break;
            }
        }
        }
        [self sectorWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
        
    }
    }

}

-(IBAction)didClickpitchAction:(id)sender
{
    isPitch_Img = YES;
    isSectorEnableBatsman=NO;
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

    
    self.batsmanCell.sectorWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.spiderWagon_Btn.backgroundColor =[UIColor clearColor];
    self.batsmanCell.pitch_Btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(143/255.0f) blue:(73/255.0f) alpha:1.0f];

    self.batsmanCell.wagonPitch_img.hidden=YES;
    self.batsmanCell.pitchMap_img.hidden=NO;
    
    if(Img_ball != nil)
    {
        [Img_ball removeFromSuperview];
    }
    
    [self.batsmanCell.onSide_Btn setTitle:@"" forState:UIControlStateNormal];
    [self.batsmanCell.offSide_Btn setTitle:@"" forState:UIControlStateNormal];


    if([self.BatmenStyle isEqualToString:@"MSC013"])
    {
        self.batsmanCell.pitchMap_img.image=[UIImage imageNamed:@"pichmapRH"];
    }
    else{
        
        self.batsmanCell.pitchMap_img.image=[UIImage imageNamed:@"pichmapLH"];
        
    }
    
    [self.batsmanCell.WangonAll_Btn setTitle:@"ALL" forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon1s_Btn setTitle:line1 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon2s_Btn setTitle:line2 forState:UIControlStateNormal];

    [self.batsmanCell.wangon3s_Btn setTitle:line3 forState:UIControlStateNormal];

    [self.batsmanCell.wangon4s_Btn setTitle:line4 forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon6s_Btn setTitle:line5 forState:UIControlStateNormal];

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

        [self.batsmanCell.pitchMap_img addSubview:Img_ball];
        
        
    }
    }
  
}

-(IBAction)didClickonSideAction:(id)sender
{
    
    isPitch_Img = NO;
    //ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    //HVTableView* view = (HVTableView*) cell.superview;
    //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
    //NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
    
    //int row = indexPath.row;
    //if([self.batsmanCell.wagonPitch_img.image  isEqual: @"LHWagon"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"RHWagon"])
    if(self.bowlerCell.wagonPitch_img.hidden == NO)
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
                if([regionCode isEqualToString:@"MDT036"] || [regionCode isEqualToString:@"MDT037"] ||[regionCode isEqualToString:@"MDT038"] || [regionCode isEqualToString:@"MDT039"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }

            
            for(int i=0 ;i<expendBattsmanCellArray.count;i++)
            {
                for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                           
                           [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                        [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                        
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
                for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }

        }
            }
        
    }
    }
    else if ([self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapLH"])
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
    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
    HVTableView* view = (HVTableView*) cell.superview;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
    
    int row = indexPath.row;
    //if([self.batsmanCell.wagonPitch_img.image  isEqual: @"LHWagon"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"RHWagon"])
    if(self.bowlerCell.wagonPitch_img.hidden == NO)
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
                for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
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
                for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
            }
            
        }
    }
    else if ([self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapLH"])
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
    
    if(self.batsmanCell.wagonPitch_img.hidden == NO)
    {
        
        for(int i=0 ;i<expendBattsmanCellArray.count;i++)
        {
            for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                    
                   [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    strokeColor = [UIColor colorWithRed:(35/255.0f) green:(116/255.0f) blue:(205/255.0f) alpha:1.0f];
                    
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
                [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                
            }
        }
        }
    }
    else
    {
        for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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

                    [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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

    
    
         if(self.batsmanCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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

            [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                            [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                            
                        }
             
                    }
        }
    }
    else
    {
        
        if(BatmanRunsArray > 0)
        {
            for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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

            [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                            

        }
        }
        }
        else{
           
                for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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
    
    
    
       if(self.batsmanCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    
       else
    {
        for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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

                    [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
                for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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
    
    
        if(self.batsmanCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    
    else
    {
        for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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

                    [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
                for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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
    
    
    
    if(self.batsmanCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    else
    {
        for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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
                    [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
                for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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
    
    
    
       if(self.batsmanCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.batsmanCell.wagonPitch_img.layer.sublayers)
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
                    
                    [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
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
                    [self.batsmanCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
                
            }
        }
    }
    else
    {
        for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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

                    [self.batsmanCell.pitchMap_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            for(UIImageView * obj in [self.batsmanCell.pitchMap_img subviews])
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
    
    zerocount=0;
    Run1Count=0;
    Run2Count=0;
    Run3Count=0;
    Run4Count=0;
    Run6Count=0;
    
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
            [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
            
        }
    }
}

-(IBAction)didClickBowlingSectorWagonAction:(id)sender
{
    
    isSectorEnableBowler = YES;

    
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
            [self BowlersectorWagonwheel :objRecord.Sectorregioncode:objRecord.BattingStyle :objRecord.Runs];

    
        }
    
   }

}

-(IBAction)didClickBowlingpitchAction:(id)sender
{
    
    isSectorEnableBowler =NO;

    
//    ScoreCardCellTVCell* cell = (ScoreCardCellTVCell*) [self.table superview].superview;
//    HVTableView* view = (HVTableView*) cell.superview;
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:view];
//    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonPosition];
//    int row = indexPath.row;
//    
//    NSLog(@"Indexpath = %d",row);
//    
//    NSLog(@"Indexpath = %@",indexPath);
    
    
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
    
    self.bowlerCell.BowlerwagonPitch_img.hidden=NO;
    self.bowlerCell.wagonPitch_img.hidden=YES;
    
    
    [self.bowlerCell.onSide_Btn setTitle:@"" forState:UIControlStateNormal];
    [self.bowlerCell.offSide_Btn setTitle:@"" forState:UIControlStateNormal];

    
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

            [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
            
        }
    }

}

-(IBAction)didClickBowlingonSideAction:(id)sender
{
    isPitch_Img = NO;
       if(self.bowlerCell.wagonPitch_img.hidden == NO)
    {
        if([_BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
            
            
            for(int i=0; i<expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.Sectorregioncode;
                if([regionCode isEqualToString:@"MDT036"] || [regionCode isEqualToString:@"MDT037"] ||[regionCode isEqualToString:@"MDT038"] || [regionCode isEqualToString:@"MDT039"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }
            
            
            for(int i=0 ;i<expendBowlerCellArray.count;i++)
            {
                for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
                    }
                }
            }
            
            else
            {

            for(int i=0; i<onsideRegionValue.count;i++)
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
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
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
            
            
            for(int i=0; i<expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.Sectorregioncode;
                if([regionCode isEqualToString:@"MDT041"] || [regionCode isEqualToString:@"MDT042"] || [regionCode isEqualToString:@"MDT043"] || [regionCode isEqualToString:@"MDT044"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }
            
            
            for(int i=0 ;i<expendBowlerCellArray.count;i++)
            {
                for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                        
                        [self sectorRunReplaceWagonwheel :objRecord.SECTORREGIONCODE :self.BatmenStyle:objRecord.RUNS];
                    }
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
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    
//                    for (CALayer *layer in self.bowlerCell.BowlerwagonPitch_img.layer.sublayers) {
//                        if ([layer.name isEqualToString:@"DrawLine"]) {
//                            //[layer removeFromSuperlayer];
//                            break;
//                        }
//                    }
                    
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
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            }
            
        }
    }
    else if ([self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapLH"])
    {
        if([self.BatmenStyle isEqualToString:@"MSC013"])
        {
            NSLog(@"pichmapRH");
            
        }
        else{
            
            NSLog(@"pichmapLH");
            
        }
    }}

-(IBAction)didClickBowlingOffSideAction:(id)sender
{
    isPitch_Img = NO;
    if(self.bowlerCell.wagonPitch_img.hidden == NO)
    {
        if([_BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            int x1position;
            int x2position;
            int y1position;
            int y2position;
            NSMutableArray * onsideRegionValue =[[NSMutableArray alloc]init];
            
            
            for(int i=0; i<expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.Sectorregioncode;
                if([regionCode isEqualToString:@"MDT036"] || [regionCode isEqualToString:@"MDT037"] ||[regionCode isEqualToString:@"MDT038"] || [regionCode isEqualToString:@"MDT039"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }
            
            
            for(int i=0 ;i<expendBowlerCellArray.count;i++)
            {
                for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
            
            for(int i=0; i<onsideRegionValue.count;i++)
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
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
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
            
            
            for(int i=0; i<expendBowlerCellArray.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[expendBowlerCellArray objectAtIndex:i];
                NSString * regionCode = objRecord.Sectorregioncode;
                if([regionCode isEqualToString:@"MDT041"] || [regionCode isEqualToString:@"MDT042"] || [regionCode isEqualToString:@"MDT043"] || [regionCode isEqualToString:@"MDT044"])
                {
                    [onsideRegionValue addObject:objRecord];
                }
            }
            
            
            for(int i=0 ;i<expendBowlerCellArray.count;i++)
            {
                for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
                {
                    if ([layer.name isEqualToString:@"DrawLine"])
                    {
                        [layer removeFromSuperlayer];
                        break;
                    }
                }
            }
            
            for(int i=0; i<onsideRegionValue.count;i++)
            {
                BowlerStaticsRecord * objRecord =(BowlerStaticsRecord *)[onsideRegionValue objectAtIndex:i];
                x1position = [objRecord.WWX1 intValue];
                y1position = [objRecord.WWY1 intValue];
                x2position  =[objRecord .WWX2 intValue];
                y2position  =[objRecord.WWY2 intValue];
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    
                    //                    for (CALayer *layer in self.bowlerCell.BowlerwagonPitch_img.layer.sublayers) {
                    //                        if ([layer.name isEqualToString:@"DrawLine"]) {
                    //                            //[layer removeFromSuperlayer];
                    //                            break;
                    //                        }
                    //                    }
                    
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
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }            }
            
        }
    }
    else if ([self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapRH"] || [self.batsmanCell.wagonPitch_img.image  isEqual: @"pichmapLH"])
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
    if(self.bowlerCell.wagonPitch_img.hidden == NO)
    {
        
        for(int i=0 ;i<expendBowlerCellArray.count;i++)
        {
            for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode :self.BatmenStyle:objRecord.Runs];
                }
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
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    
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
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
        }
    }
    else
    {
        for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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

                    [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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
    
    
    
    if(self.bowlerCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:objRecord.BattingStyle :objRecord.Runs];
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
                    UIColor *strokeColor = [UIColor colorWithRed:(255/255.0f) green:(109/255.0f) blue:(37/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        }
        
    }
    else
    {
        
        if(BowlerRunArray > 0)
        {
            for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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

                    [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
            
            for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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
    
    
    
        if(self.bowlerCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:objRecord.BattingStyle :objRecord.Runs];
                }
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
                    UIColor * strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(255/255.0f) alpha:1.0f];

                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        }
        
    }
    else
    {
        for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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

                    [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
           
                for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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
    
    
   
    
       if(self.bowlerCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:objRecord.BattingStyle :objRecord.Runs];
                }
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
                    UIColor *strokeColor = [UIColor colorWithRed:(188/255.0f) green:(182/255.0f) blue:(49/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        }
        
    }
    else
    {
        for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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

                    [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
             for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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
    
    
    if(self.bowlerCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:objRecord.BattingStyle :objRecord.Runs];
                }
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
                    UIColor *strokeColor = [UIColor colorWithRed:(217/255.0f) green:(32/255.0f) blue:(35/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        }
        
    }
    else
    {
        for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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

                    [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
               for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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
    
       if(self.bowlerCell.wagonPitch_img.hidden == NO)
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
            for (CALayer *layer in self.bowlerCell.wagonPitch_img.layer.sublayers)
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
                
                
                if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
                    
                    [self BowlersectorRunReplaceWagonwheel :objRecord.Sectorregioncode:objRecord.BattingStyle :objRecord.Runs];
                }
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
                    UIColor *strokeColor = [UIColor colorWithRed:(61/255.0f) green:(27/255.0f) blue:(207/255.0f) alpha:1.0f];
                    shapeLayer.strokeColor = strokeColor.CGColor;
                    shapeLayer.lineWidth = 2.0f;
                    shapeLayer.fillRule = kCAFillRuleNonZero;
                    shapeLayer.name = @"DrawLine";
                    [self.bowlerCell.wagonPitch_img.layer addSublayer:shapeLayer];
                    
                }
            }
            
        }
        
    }
    else
    {
        for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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

                    [self.bowlerCell.BowlerwagonPitch_img addSubview:Img_ball];
                    
                    
                }
            }
        }
        else{
              for(UIImageView * obj in [self.bowlerCell.BowlerwagonPitch_img subviews])
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
        
        if(fineleg_lbl !=nil)
        {
             [fineleg_lbl removeFromSuperview];
        }
        
//        fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
        fineleg_lbl.textColor=[UIColor whiteColor];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        [self.batsmanCell.wagonPitch_img addSubview:fineleg_lbl];
       // self.batsmanCell.WangonAll_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",finelegRun];
        
        
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
        
        
        //squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,110,35, 35)];
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [self.batsmanCell.wagonPitch_img addSubview:squareleg_lbl];
        // self.batsmanCell.wangon1s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",squarelegRun];
        
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
        
        

        
//        midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [self.batsmanCell.wagonPitch_img addSubview:midWicket_lbl];
     //   self.batsmanCell.wangon2s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",midWicketRun];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT039"])
    {
        if([batmanStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
           // longon++;
            longonRun =longonRun+[Run intValue];
            longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,270,35, 35)];

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
        
//         longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [self.batsmanCell.wagonPitch_img addSubview:longon_lbl];
        // self.batsmanCell.wangon3s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longonRun];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT041"])
    {
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
        
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }
        
//        longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        [self.batsmanCell.wagonPitch_img addSubview:longoff_lbl];
       // self.batsmanCell.wangon4s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longoffRun];

        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT042"])
    {
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
        
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
        
//        cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [self.batsmanCell.wagonPitch_img addSubview:cover_lbl];
        // self.batsmanCell.wangon6s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",coverRun];
        
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
        
        
        //point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [self.batsmanCell.wagonPitch_img addSubview:point_lbl];
        
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
        
        
//        Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [self.batsmanCell.wagonPitch_img addSubview:Thirdman_lbl];
       
    }
 
     [self.batsmanCell.WangonAll_Btn setTitle:[NSString stringWithFormat:@"ALL"] forState:UIControlStateNormal];
    
    
    [self.batsmanCell.wangon1s_Btn setTitle:[NSString stringWithFormat:@"1s|%d",Run1Count] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon2s_Btn setTitle:[NSString stringWithFormat:@"2s|%d",Run2Count] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon3s_Btn setTitle:[NSString stringWithFormat:@"3s|%d",Run3Count] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon4s_Btn setTitle:[NSString stringWithFormat:@"4s|%d",Run4Count] forState:UIControlStateNormal];
    
    [self.batsmanCell.wangon6s_Btn setTitle:[NSString stringWithFormat:@"6s|%d",Run6Count] forState:UIControlStateNormal];
    

}

-(void)BowlersectorWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) BatmenStyle :(NSString *) Run
        
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
                
                if([BatmenStyle isEqualToString:@"MSC012"])
                {
                    NSLog(@"LH");
            //        fineleg++;
                    finelegRun = [Run intValue]+finelegRun;
                    fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50, 30,35, 35)];

                }
                else
                {
          //          fineleg++;
                    NSLog(@"RH");
                    finelegRun = [Run intValue]+finelegRun;
                    fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];

                }
                
                
                //fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
                fineleg_lbl.textColor=[UIColor whiteColor];
                fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
                [self.bowlerCell.wagonPitch_img addSubview:fineleg_lbl];
               // self.bowlerCell.BowlerWangonAll_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",finelegRun];
                
               
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
                
                
//                squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(300,110,35, 35)];
                squareleg_lbl.textColor=[UIColor whiteColor];
                squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
                [self.bowlerCell.wagonPitch_img addSubview:squareleg_lbl];
                //self.bowlerCell.Bowlerwangon1s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",squarelegRun];
               
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
                
               // midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
                midWicket_lbl.textColor=[UIColor whiteColor];
                midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
                [self.bowlerCell.wagonPitch_img addSubview:midWicket_lbl];
                //self.bowlerCell.Bowlerwangon2s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",midWicketRun];
               
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
                    longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,270,35, 35)];

                }
                else
                {
                    NSLog(@"RH");
        //            longon++;
                    longonRun =longonRun+[Run intValue];
                    longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];

                }
                
//                longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
                longon_lbl.textColor=[UIColor whiteColor];
                longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
                [self.bowlerCell.wagonPitch_img addSubview:longon_lbl];
               // self.bowlerCell.Bowlerwangon3s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longonRun];
                
            }
            else if([secotorwognwheelcode isEqualToString:@"MDT041"])
            {
                if(longoff_lbl !=nil)
                {
                    [longoff_lbl removeFromSuperview];
                }
                if([BatmenStyle isEqualToString:@"MSC012"])
                {
                    NSLog(@"LH");
          //          longoff++;
                    longoffRun =longoffRun +[Run intValue];
                    longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];

                }
                else
                {
                    NSLog(@"RH");
//                    longoff++;
                    longoffRun =longoffRun +[Run intValue];
                    longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];

                }
                
                
                
//                longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];
                longoff_lbl.textColor=[UIColor whiteColor];
                longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
                [self.bowlerCell.wagonPitch_img addSubview:longoff_lbl];
                //self.bowlerCell.Bowlerwangon4s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longoffRun];
               
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
                    cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,100,35, 35)];

                }
                else
                {
                   // NSLog(@"RH");
                    //cover++;
                    coverRun = coverRun+[Run intValue];
                    cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];

                }
                
                
//                cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];
                cover_lbl.textColor=[UIColor whiteColor];
                cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
                [self.bowlerCell.wagonPitch_img addSubview:cover_lbl];
                //self.bowlerCell.Bowlerwangon6s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",coverRun];
               
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
                    point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,120,35, 35)];

                    //point++;
                }
                else
                {
                    NSLog(@"RH");
                    pointRun=pointRun+[Run intValue];
                    point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];

               //     point++;
                }
                
                
               
//                point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
                point_lbl.textColor=[UIColor whiteColor];
                point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
                [self.bowlerCell.wagonPitch_img addSubview:point_lbl];
               
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
                
               
                
//                Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
                Thirdman_lbl.textColor=[UIColor whiteColor];
                Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
                [self.bowlerCell.wagonPitch_img addSubview:Thirdman_lbl];
            
            }
            
            [self.bowlerCell.BowlerWangonAll_Btn setTitle:[NSString stringWithFormat:@"ALL"] forState:UIControlStateNormal];
            
           [self.bowlerCell.Bowlerwangon1s_Btn setTitle:[NSString stringWithFormat:@"1s|%d",Run1Count] forState:UIControlStateNormal];
            
            [self.bowlerCell.Bowlerwangon2s_Btn setTitle:[NSString stringWithFormat:@"2s|%d",Run2Count] forState:UIControlStateNormal];
            
            [self.bowlerCell.Bowlerwangon3s_Btn setTitle:[NSString stringWithFormat:@"3s|%d",Run3Count] forState:UIControlStateNormal];
            
          [self.bowlerCell.Bowlerwangon4s_Btn setTitle:[NSString stringWithFormat:@"4s|%d",Run4Count] forState:UIControlStateNormal];
            
            [self.bowlerCell.Bowlerwangon6s_Btn setTitle:[NSString stringWithFormat:@"6s|%d",Run6Count] forState:UIControlStateNormal];

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
-(void)sectorRunReplaceWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) batmanStyle :(NSString *) Run
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
        
        
        //fineleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(230, 30,35, 35)];
        fineleg_lbl.textColor=[UIColor whiteColor];
        fineleg_lbl.text =[NSString stringWithFormat:@"%d",finelegRun];
        [self.batsmanCell.wagonPitch_img addSubview:fineleg_lbl];
        // self.batsmanCell.WangonAll_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",finelegRun];
        
        
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
        
        
        //squareleg_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,110,35, 35)];
        squareleg_lbl.textColor=[UIColor whiteColor];
        squareleg_lbl.text =[NSString stringWithFormat:@"%d",squarelegRun];
        [self.batsmanCell.wagonPitch_img addSubview:squareleg_lbl];
        // self.batsmanCell.wangon1s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",squarelegRun];
        
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
        
        
        
        
//        midWicket_lbl=[[UILabel alloc]initWithFrame:CGRectMake(280,190,35, 35)];
        midWicket_lbl.textColor=[UIColor whiteColor];
        midWicket_lbl.text =[NSString stringWithFormat:@"%d",midWicketRun];
        [self.batsmanCell.wagonPitch_img addSubview:midWicket_lbl];
        //   self.batsmanCell.wangon2s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",midWicketRun];
        
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
        
        
       // longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [self.batsmanCell.wagonPitch_img addSubview:longon_lbl];
        // self.batsmanCell.wangon3s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longonRun];
        
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
        
        
//        longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        [self.batsmanCell.wagonPitch_img addSubview:longoff_lbl];
        // self.batsmanCell.wangon4s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longoffRun];
        
        
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
        
        
        //cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [self.batsmanCell.wagonPitch_img addSubview:cover_lbl];
        // self.batsmanCell.wangon6s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",coverRun];
        
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
        
        
//        point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [self.batsmanCell.wagonPitch_img addSubview:point_lbl];
        
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
        
//        Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [self.batsmanCell.wagonPitch_img addSubview:Thirdman_lbl];
        
    }
}

-(void)BowlersectorRunReplaceWagonwheel:(NSString *) secotorwognwheelcode :(NSString *) BatmenStyle :(NSString *) Run
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
        [self.bowlerCell.wagonPitch_img addSubview:fineleg_lbl];
        // self.bowlerCell.BowlerWangonAll_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",finelegRun];
        
        
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
        [self.bowlerCell.wagonPitch_img addSubview:squareleg_lbl];
        //self.bowlerCell.Bowlerwangon1s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",squarelegRun];
        
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
        [self.bowlerCell.wagonPitch_img addSubview:midWicket_lbl];
        //self.bowlerCell.Bowlerwangon2s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",midWicketRun];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT039"])
    {
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
            //   longon++;
            longonRun =longonRun+[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            //            longon++;
            longonRun =longonRun+[Run intValue];
        }
        if(longon_lbl !=nil)
        {
            [longon_lbl removeFromSuperview];
        }
        longon_lbl=[[UILabel alloc]initWithFrame:CGRectMake(220,270,35, 35)];
        longon_lbl.textColor=[UIColor whiteColor];
        longon_lbl.text =[NSString stringWithFormat:@"%d",longonRun];
        [self.bowlerCell.wagonPitch_img addSubview:longon_lbl];
        // self.bowlerCell.Bowlerwangon3s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longonRun];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT041"])
    {
        if([BatmenStyle isEqualToString:@"MSC012"])
        {
            NSLog(@"LH");
           
            longoffRun =longoffRun +[Run intValue];
        }
        else
        {
            NSLog(@"RH");
            //                    longoff++;
            longoffRun =longoffRun +[Run intValue];
        }
        
        if(longoff_lbl !=nil)
        {
            [longoff_lbl removeFromSuperview];
        }
        
        longoff_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,190,35, 35)];
        longoff_lbl.textColor=[UIColor whiteColor];
        longoff_lbl.text =[NSString stringWithFormat:@"%d",longoffRun];
        [self.bowlerCell.wagonPitch_img addSubview:longoff_lbl];
        //self.bowlerCell.Bowlerwangon4s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",longoffRun];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT042"])
    {
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
        
        if(cover_lbl !=nil)
        {
            [cover_lbl removeFromSuperview];
        }
        
        cover_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,100,35, 35)];
        cover_lbl.textColor=[UIColor whiteColor];
        cover_lbl.text =[NSString stringWithFormat:@"%d",coverRun];
        [self.bowlerCell.wagonPitch_img addSubview:cover_lbl];
        //self.bowlerCell.Bowlerwangon6s_Btn.titleLabel.text=[NSString stringWithFormat:@"%d",coverRun];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT043"])
    {
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
        
        
        if(point_lbl !=nil)
        {
            [point_lbl removeFromSuperview];
        }
        point_lbl=[[UILabel alloc]initWithFrame:CGRectMake(50,120,35, 35)];
        point_lbl.textColor=[UIColor whiteColor];
        point_lbl.text =[NSString stringWithFormat:@"%d",pointRun];
        [self.bowlerCell.wagonPitch_img addSubview:point_lbl];
        
    }
    else if([secotorwognwheelcode isEqualToString:@"MDT044"])
    {
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
        
        if(Thirdman_lbl !=nil)
        {
            [Thirdman_lbl removeFromSuperview];
        }
        
        Thirdman_lbl=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
        Thirdman_lbl.textColor=[UIColor whiteColor];
        Thirdman_lbl.text =[NSString stringWithFormat:@"%d",ThirdmanCountRun];
        [self.bowlerCell.wagonPitch_img addSubview:Thirdman_lbl];
        
    }

}
@end
