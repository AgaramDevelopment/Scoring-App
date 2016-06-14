//
//  ScorEnginVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ScorEnginVC.h"
#import "CDRTranslucentSideBar.h"
#import "DBManager.h"
#import "BallEventRecord.h"
#import "AppealRecord.h"
#import "AppealCell.h"
#import "AppealSystemRecords.h"
#import "AppealComponentRecord.h"
#import "AppealUmpireRecord.h"
#import "FieldingFactorRecord.h"
#import "BowlerEvent.h"
#import "FastBowlTypeCell.h"
#import "BowlAndShotTypeRecords.h"
#import "BowlTypeCell.h"
#import "FastBowlTypeCell.h"
#import "AggressiveShotTypeCell.h"
#import "FieldingFactorCell.h"
#import "TossDeatilsEvent.h"
#import "WicketTypeRecord.h"
#import "FetchSEPageLoadRecord.h"
#import "SelectPlayerRecord.h"
#import "FetchLastBallBowledPlayer.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPAD_PRO (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)
//#define IS_IPAD (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1024.0)

@interface ScorEnginVC () <CDRTranslucentSideBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{   //appeal System
    BOOL isEnableTbl;
    NSMutableArray * AppealSystemSelectionArray;
    NSString*AppealSystemSelectCode;
    AppealSystemRecords *objAppealSystemEventRecord;
    
    //AppealComponent
    NSMutableArray * AppealComponentSelectionArray;
    NSString*AppealComponentSelectCode;
    AppealComponentRecord *objAppealComponentEventRecord;
    
    //AppealUmpire
    NSMutableArray * AppealUmpireSelectionArray;
    NSString*AppealUmpireSelectCode;
    AppealUmpireRecord *objAppealUmpireEventRecord;
    
    //AppealBatsmen
    NSMutableArray *AppealBatsmenSelectionArray;
    NSArray*AppealBatsmenSelectCode;
    
    
    
    NSMutableArray *Btn_NameArray;
    BOOL isSelectleftview;
    UITableView* extrasTableView;
    UITableView* overThrowTableView;
    UITableView* currentBowlersTableView;
    UITableView* strickerTableView;
    UITableView* nonstrickerTableView;

    
    UITableView* objextras;
    //BallEventRecord *objBalleventRecord;
    
    //RBW and Miscfilters
    UITableView* rbwTableview;
    UITableView* miscFiltersTableview;
    BOOL isRBWSelected;
    BOOL ismiscFilters;
    
    BOOL isMoreRunSelected;
    BOOL isExtrasSelected;
    BOOL isOverthrowSelected;
    BOOL isFieldingSelected;
    int fieldingOption;
    BOOL isOTWselected;
    BOOL isRTWselected;
    BOOL isSpinSelected;
    BOOL isFastSelected;
    BOOL isAggressiveSelected;
    BOOL isDefensiveSelected;
    BOOL isStrickerOpen;
    BOOL isNONStrickerOpen;
    BOOL isBowlerOpen;
    
    NSMutableArray *strickerList;
    NSMutableArray *nonStrickerList;
    
    
    NSString * ballnoStr;
    NSDate * startBallTime;
    
    FieldingFactorRecord *selectedfieldFactor;
    BowlerEvent *selectedfieldPlayer;
    NSString *selectedNRS;
    UIImageView * Img_ball;
    
    NSString *wagonregiontext;
    NSString *regioncode;
    
    //wicket type
    BOOL isWicketSelected;
    int wicketOption;
    WicketTypeRecord *selectedwickettype;
    NSString *selectedStrikernonstriker;
    NSString *selectedWicketEvent;
    BowlerEvent *selectedwicketBowlerlist;
    
}

@property(strong,nonatomic)NSString *matchTypeCode;
//team logo
@property (nonatomic,strong) NSMutableArray *selectedTeamArray;
@property (nonatomic,strong) NSMutableArray *selectedTeamFilterArray;

@property(nonatomic,strong) NSMutableArray *selectbtnvalueArray;
@property(nonatomic,strong) NSMutableArray *extrasOptionArray;
@property(nonatomic,strong) NSMutableArray *overThrowOptionArray;
@property(nonatomic,strong) NSMutableArray *otwRtwArray;
@property(nonatomic,strong) BallEventRecord *ballEventRecord;

//RBW and Miscfilters
@property(nonatomic,strong) NSMutableArray *rbwOptionArray;
@property(nonatomic,strong) NSMutableArray *miscfiltersOptionArray;

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
//@property(nonatomic,strong) NSMutableArray *selectbtnvalueArray;

//Fielding Factors
@property (nonatomic,strong)NSMutableArray *fieldingfactorArray;
@property (nonatomic,strong)NSMutableArray *fieldingPlayerArray;
@property (nonatomic,strong)NSMutableArray *nrsArray;



@property (nonatomic,strong)NSMutableArray *bowlTypeArray;
@property(nonatomic,strong)NSMutableArray *fastBowlTypeArray;
@property(nonatomic,strong)NSMutableArray *aggressiveShotTypeArray;
@property(nonatomic,strong)NSMutableArray *defensiveShotTypeArray;


//appeal
@property (nonatomic,strong)NSMutableArray*AppealSystemArray;
@property (nonatomic,strong)NSMutableArray*AppealComponentArray;
@property (nonatomic,strong)NSMutableArray*AppealUmpireArray;
@property(nonatomic,strong) NSMutableArray *AppealBatsmenArray;
@property(nonatomic,strong) NSMutableArray *AppealValuesArray;

//wicketType
@property (nonatomic,strong)NSMutableArray *WicketTypeArray;
@property (nonatomic,strong)NSMutableArray *StrikerandNonStrikerArray;
@property (nonatomic,strong)NSMutableArray *WicketEventArray;
@property (nonatomic,strong)NSMutableArray *PlayerlistArray;

@property (nonatomic, weak) IBOutlet UIView *objcommonRemarkviews;




@end

@implementation ScorEnginVC
@synthesize table_Appeal;
@synthesize tbl_bowlType;
@synthesize tbl_fastBowl;
@synthesize tbl_aggressiveShot;


//appeal
@synthesize AppealSystemArray;
@synthesize AppealComponentArray;
@synthesize AppealUmpireArray;
@synthesize AppealBatsmenArray;

FetchSEPageLoadRecord *fetchSEPageLoadRecord;

- (void)viewDidLoad {
    [super viewDidLoad];
     [self hideLabelBasedOnMatchType];
    
   // [self resetBallObject];
    
    fetchSEPageLoadRecord = [[FetchSEPageLoadRecord alloc]init];
    [fetchSEPageLoadRecord fetchSEPageLoadDetails:self.competitionCode :self.matchCode];
    
    FetchLastBallBowledPlayer *fetchLastBallBowledPlayer = [[FetchLastBallBowledPlayer alloc]init];
    
    
//    NSString *data= [NSString stringWithFormat:@"%d",fetchSEPageLoadRecord.BATTEAMOVERS];
//    
//    [fetchLastBallBowledPlayer getLastBallBowlerPlayer:self.competitionCode MATCHCODE:self.matchCode INNINGSNO:fetchSEPageLoadRecord.INNINGSNO OVERNO:data BATTINGTEAMCODE:fetchSEPageLoadRecord.BATTINGTEAMCODE];
   
    
    
    //Stricker Details
    self.lbl_stricker_name.text = fetchSEPageLoadRecord.strickerPlayerName;
    self.lbl_stricker_runs.text = fetchSEPageLoadRecord.strickerTotalRuns;
    self.lbl_stricker_balls.text = fetchSEPageLoadRecord.strickerTotalBalls;
    self.lbl_stricker_sixs.text = fetchSEPageLoadRecord.strickerSixes;
    self.lbl_stricker_strickrate.text = [NSString stringWithFormat:@"%.01f",[fetchSEPageLoadRecord.strickerStrickRate floatValue]];
    
    self.lbl_stricker_fours.text = fetchSEPageLoadRecord.strickerFours;
    
    //Non Stricker Details
    self.lbl_nonstricker_name.text = fetchSEPageLoadRecord.nonstrickerPlayerName;
    self.lbl_nonstricker_runs.text = fetchSEPageLoadRecord.nonstrickerTotalRuns;
    self.lbl_nonstricker_balls.text = fetchSEPageLoadRecord.nonstrickerTotalBalls;
    self.lbl_nonstricker_fours.text = fetchSEPageLoadRecord.nonstrickerFours;
    self.lbl_nonstricker_sixs.text = fetchSEPageLoadRecord.nonstrickerSixes;
    self.lbl_nonstricker_strickrate.text = [NSString stringWithFormat:@"%.01f",[fetchSEPageLoadRecord.nonstrickerStrickRate floatValue]];
    //[formatter stringFromNumber:fetchSEPageLoadRecord.nonstrickerStrickRate];
    
    //Bowler
    
   self.lbl_bowler_name.text = fetchSEPageLoadRecord.currentBowlerPlayerName;
   self.lbl_bowler_runs.text = fetchSEPageLoadRecord.currentBowlerOver;
   self.lbl_bowler_balls.text = fetchSEPageLoadRecord.currentBowlerMaidan;
   self.lbl_bowler_fours.text = fetchSEPageLoadRecord.currentBowlerRuns;
   self.lbl_bowler_sixs.text = fetchSEPageLoadRecord.currentBowlerWicket;
    self.lbl_bowler_strickrate.text = [NSString stringWithFormat:@"%.01f",[fetchSEPageLoadRecord.currentBowlerEcoRate floatValue]];

    //team score details display
    _lbl_battingShrtName.text = fetchSEPageLoadRecord.BATTEAMSHORTNAME;
    _lbl_firstIngsTeamName.text = fetchSEPageLoadRecord.BATTEAMSHORTNAME;
    
    _lbl_secIngsTeamName.text = fetchSEPageLoadRecord.BOWLTEAMSHORTNAME;
    
    
    
    _lbl_battingScoreWkts.text = [NSString stringWithFormat:@"%ld / %ld",(unsigned long)fetchSEPageLoadRecord.BATTEAMRUNS,(unsigned long)fetchSEPageLoadRecord.BATTEAMWICKETS];
    
    _lbl_overs.text = [NSString stringWithFormat:@"%ld.%ld OVS" ,(unsigned long)fetchSEPageLoadRecord.BATTEAMOVERS,(unsigned long)fetchSEPageLoadRecord.BATTEAMOVRBALLS];
    
    _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue], [fetchSEPageLoadRecord.RUNSREQUIRED floatValue]];
    
    
    

    //all innings details for team A and team B
    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.SECONDINNINGSTOTAL,fetchSEPageLoadRecord.SECONDINNINGSWICKET];
    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.SECONDINNINGSOVERS];
    
    
   // _lbl_teamASecIngsScore.text = 
    //_lbl_teamASecIngsOvs.text =
    
    
  //  _lbl_teamBSecIngsScore.text =
//    _lbl_teamBSecIngsOvs.text =
    
    _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",fetchSEPageLoadRecord.FIRSTINNINGSTOTAL,fetchSEPageLoadRecord.FIRSTINNINGSWICKET];
    _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FIRSTINNINGSOVERS];
    
    
    
  _view_Wagon_wheel.hidden=YES;
    //bowl type - spin array
    _bowlTypeArray=[[NSMutableArray alloc]init];
    _bowlTypeArray =[DBManager getBowlType];
    
    self.view_bowlType.hidden = YES;
    self.tbl_bowlType.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //fast bowl type
    
    _fastBowlTypeArray = [[NSMutableArray alloc]init];
    _fastBowlTypeArray = [DBManager getBowlFastType];
    
    self.view_fastBowl.hidden = YES;
    
    
    
    
    //aggressive shot type
    
    _aggressiveShotTypeArray = [[NSMutableArray alloc]init];
    _aggressiveShotTypeArray =[DBManager getAggressiveShotType];
    self.view_aggressiveShot.hidden = YES;
    
    
    
    //defensice shot type
    _defensiveShotTypeArray = [[NSMutableArray alloc]init];
    _defensiveShotTypeArray = [DBManager getDefenceShotType];
    self.view_defensive.hidden = YES;
    
    self.View_Appeal.hidden = YES;
    
    //
    //    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    //    self.sideBar.sideBarWidth = 200;
    //    self.sideBar.delegate = self;
    //    self.sideBar.tag = 0;
    
    // Create Right SideBar
    //    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
    //    self.rightSideBar.delegate = self;
    //    self.rightSideBar.translucentStyle = UIBarStyleBlack;
    //    self.rightSideBar.tag = 1;
    
    // Add PanGesture to Show SideBar by PanGesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    // Create Content of SideBar
    //    UITableView *tableView = [[UITableView alloc] init];
    //    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    //    v.backgroundColor = [UIColor clearColor];
    //    [tableView setTableHeaderView:v];
    //    [tableView setTableFooterView:v];
    //
    //    //If you create UITableViewController and set datasource or delegate to it, don't forget to add childcontroller to this viewController.
    //    //[[self addChildViewController: @"your view controller"];
    //    tableView.dataSource = self;
    //    tableView.delegate = self;
    //
    //    // Set ContentView in SideBar
    //    [self.sideBar setContentViewInSideBar:tableView];
    
    
    _View_Appeal.hidden=YES;
    _view_table_select.hidden=YES;
    _AppealValuesArray=[[NSMutableArray alloc]init];
    _AppealValuesArray =[DBManager AppealRetrieveEventData];
    
    
    //OTW and RTW
    _otwRtwArray = [[NSMutableArray alloc]init];
    _otwRtwArray = [DBManager getOtwRtw];

    
    
    //RBW and Misc Filters
    self.ballEventRecord = [[BallEventRecord alloc] init];
    self.ballEventRecord.objRbw =[NSNumber numberWithInt:0];
    self.ballEventRecord.objIswtb=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsuncomfort=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsreleaseshot=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsbeaten=[NSNumber numberWithInt:0];
    
    isRBWSelected = NO;
    ismiscFilters = NO;
    isFieldingSelected = NO;
    isSpinSelected = NO;
    isFastSelected = NO;
    isAggressiveSelected = NO;
    
    isWicketSelected=NO;
    
    fieldingOption = 0;
    wicketOption = 0;
    
    //Fielding Factor
    //_fieldingfactorArray=[[NSMutableArray alloc]init];
    // _fieldingfactorArray =[DBManager RetrieveFieldingFactorData];
    
    //    self.view_fieldingfactor.hidden = YES;
    //    self.view_fieldername.hidden = YES;
    //    self.view_nrs.hidden=YES;
    
    
    
    //Appeal
    
    [self.view_AppealSystem.layer setBorderWidth:2.0];
    [self.view_AppealSystem.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealSystem .layer setMasksToBounds:YES];
    [_table_AppealSystem setHidden:YES];
    
    
    [self.view_AppealComponent.layer setBorderWidth:2.0];
    [self.view_AppealComponent.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealComponent .layer setMasksToBounds:YES];
    [_table_AppealComponent setHidden:YES];
    
    
    
    [self.view_umpireName.layer setBorderWidth:2.0];
    [self.view_umpireName.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_umpireName .layer setMasksToBounds:YES];
    [_tanle_umpirename setHidden:YES];
    
    
    [self.view_batsmen.layer setBorderWidth:2.0];
    [self.view_batsmen.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_batsmen .layer setMasksToBounds:YES];
    [_table_BatsmenName setHidden:YES];
    
    AppealBatsmenArray=[[NSMutableArray alloc]initWithObjects:@"ADITYA TARE" ,nil];
    
    self.view_bowlType.hidden = YES;
    self.view_fastBowl.hidden = YES;
    self.view_aggressiveShot.hidden = YES;
    self.view_defensive.hidden = YES;
    [self.view_BallTicker setBackgroundColor:[UIColor colorWithRed:0
                                                             green:0
                                                              blue:0
                                                             alpha:0.36]];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.btn_StartBall.userInteractionEnabled=NO;
    [self AllBtndisableMethod];
    
    
    
    //Appeal
    
    [self.view_AppealSystem.layer setBorderWidth:2.0];
    [self.view_AppealSystem.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealSystem .layer setMasksToBounds:YES];
    [_table_AppealSystem setHidden:YES];
    
    
    [self.view_AppealComponent.layer setBorderWidth:2.0];
    [self.view_AppealComponent.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealComponent .layer setMasksToBounds:YES];
    [_table_AppealComponent setHidden:YES];
    
    
    
    [self.view_umpireName.layer setBorderWidth:2.0];
    [self.view_umpireName.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_umpireName .layer setMasksToBounds:YES];
    [_tanle_umpirename setHidden:YES];
    
    
    [self.view_batsmen.layer setBorderWidth:2.0];
    [self.view_batsmen.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_batsmen .layer setMasksToBounds:YES];
    [_table_BatsmenName setHidden:YES];
    isEnableTbl=YES;
//    TossDeatilsEvent*objEvent=(TossDeatilsEvent*)[self.strikerArray objectAtIndex:0];
//    self.lbl_Batsmen1Name.text=objEvent.PlaerNameStrike_nonStrike;
//    TossDeatilsEvent*objEvent1=(TossDeatilsEvent*)[self.non_StrikerArray objectAtIndex:0];
//    self.lbl_Batsmen2Name.text=objEvent1.PlaerNameStrike_nonStrike;
    
}
-(void)SaveBallEventREcordvalue
{
    self.ballEventRecord=[[BallEventRecord alloc]init];
    
    NSMutableArray * teamCodeArray=[DBManager getTeamCodemethod];
    if(teamCodeArray.count > 0 && teamCodeArray != NULL)
    {
        NSString * objTeamCode = [NSString stringWithFormat:@"%@",teamCodeArray.lastObject];
        self.ballEventRecord.objTeamcode =objTeamCode;
    }
    
    NSMutableArray * inningsNoArray=[DBManager getInningsNomethod];
    if(inningsNoArray.count > 0 && inningsNoArray != NULL)
    {
        NSString * objInningsno = [NSString stringWithFormat:@"%@",inningsNoArray.lastObject];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        self.ballEventRecord.objInningsno = [f numberFromString:objInningsno];
        
    }
    
    [self getDayNOValue];
    NSMutableArray * ballCodevalueArray=[DBManager getballcodemethod];
    NSLog(@"array : %@",[ballCodevalueArray lastObject]);
    if(ballCodevalueArray.count > 0 && ballCodevalueArray!= NULL)
    {
        
        NSString*ballcode= [NSString stringWithFormat:@"%@",ballCodevalueArray.lastObject];
        if([ballcode isEqualToString:@"(null)"])
            
        {
            [ballCodevalueArray removeLastObject];
            ballcode=[NSString stringWithFormat:@"%@",ballCodevalueArray.lastObject];
            [ballCodevalueArray removeLastObject];
             ballcode=[NSString stringWithFormat:@"%@",ballCodevalueArray.lastObject];
        }
        
        
        NSString *code = [ballcode substringFromIndex: [ballcode length] - 10];
        
        NSString * myURL = [NSString stringWithFormat:@"1%@",code];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * myNumber = [f numberFromString:myURL];
        NSInteger value = [myNumber integerValue]+1;
        NSString *addcode = [@(value) stringValue];
        
        NSString * ballno = [addcode substringFromIndex:1];
        
        
        ballnoStr = [self.matchCode stringByAppendingFormat:@"%@",ballno];
        NSLog(@"array : %@",ballnoStr);
        
        
    }
    else{
        NSString * myURL = [NSString stringWithFormat:@"10000000001"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * myNumber = [f numberFromString:myURL];
        NSInteger value = [myNumber integerValue];
        NSString *ballno1 = [@(value) stringValue];
        NSString * ballno = [ballno1 substringFromIndex:1];
        ballnoStr = [self.matchCode stringByAppendingFormat:@"%@",ballno];
        NSLog(@"array : %@",ballnoStr);
        
    }
    
    
    self.ballEventRecord.objBallcode   = ballnoStr;
    self.ballEventRecord.objmatchcode=self.matchCode;
    self.ballEventRecord.objcompetitioncode=self.competitionCode;
}

-(void)getDayNOValue
{
    NSMutableArray * DayNoArray=[DBManager getDayNomethod];
    NSString * objDayno;
    if(DayNoArray.count > 0 && DayNoArray != NULL)
    {
        objDayno = [NSString stringWithFormat:@"%@",DayNoArray.lastObject];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * myNumber = [f numberFromString:objDayno];
        NSInteger value = [myNumber integerValue]+1;
        self.ballEventRecord.objDayno = [NSNumber numberWithInteger:value];
        self.ballEventRecord.objSessionno = [NSNumber numberWithInteger:value];
    }
    else{
        objDayno = @"1";
        self.ballEventRecord.objDayno=@1;
        self.ballEventRecord.objSessionno=@1;
    }
    
    
}


#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    // if you have left and right sidebar, you can control the pan gesture by start point.
    //    if (recognizer.state == UIGestureRecognizerStateBegan) {
    //        CGPoint startPoint = [recognizer locationInView:self.view];
    //
    //        // Left SideBar
    //        if (startPoint.x < self.view.bounds.size.width / 2.0) {
    //            self.sideBar.isCurrentPanGestureTarget = YES;
    //        }
    //        // Right SideBar
    //        else {
    //            self.rightSideBar.isCurrentPanGestureTarget = YES;
    //        }
    //    }
    //
    //    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
    //    [self.rightSideBar handlePanGestureToShow:recognizer inViewController:self];
    //
    // if you have only one sidebar, do like following
    
    // self.sideBar.isCurrentPanGestureTarget = YES;
    //[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar did appear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar did appear");
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar will appear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar will appear");
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar did disappear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar did disappear");
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar will disappear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar will disappear");
    }
}

// This is just a sample for tableview menu
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == strickerTableView && fetchSEPageLoadRecord != nil){
        return  strickerList.count;
    }
    if(tableView == nonstrickerTableView && fetchSEPageLoadRecord != nil){
        return  nonStrickerList.count;
    }
    if(tableView == currentBowlersTableView && fetchSEPageLoadRecord != nil){
      return  fetchSEPageLoadRecord.getBowlingTeamPlayers.count;
    }
    //wicket type
    if(isWicketSelected && wicketOption == 1){
        return [self.WicketTypeArray count];
    }
    if(isWicketSelected && wicketOption ==2){
        return [self.StrikerandNonStrikerArray count];
    }
    if(isWicketSelected && wicketOption ==3){
        return [self.WicketEventArray count];
    }
    if(isWicketSelected && wicketOption ==4){
        return [self.PlayerlistArray count];
    }
    
    //Fielding array
    if(isFieldingSelected && fieldingOption == 1)
    {
        return [self.fieldingfactorArray count];
    }
    if(isFieldingSelected && fieldingOption == 2)
    {
        return [self.fieldingPlayerArray count];
    }
    if(isFieldingSelected && fieldingOption == 3)
    {
        return [self.nrsArray count];
    }
    
    
    if(extrasTableView == tableView){
        return self.extrasOptionArray.count;
    }else if(overThrowTableView == tableView){
        return self.overThrowOptionArray.count;
    }
    
    if([self.selectbtnvalueArray count] > 0)
    {
        return self.selectbtnvalueArray.count;
        
    }else if (tableView == table_Appeal) {
        
        return self.AppealValuesArray.count;
        
    }else if(tableView == tbl_bowlType){
        
        return self.bowlTypeArray.count;
        
    }else if(tableView == tbl_fastBowl){
        return [self.fastBowlTypeArray count];
    }else if(tableView == tbl_aggressiveShot){
        return[self.aggressiveShotTypeArray count];
        
    }else if(tableView == _tbl_defensive){
        return [self.defensiveShotTypeArray count];
    }
    
    //Rbw,miscfilters and fieldingfactor
    if(rbwTableview == tableView)
    {
        return self.rbwOptionArray.count;
    }
    
    if(miscFiltersTableview == tableView)
    {
        return self.miscfiltersOptionArray.count;
    }
    
    if (tableView == self.table_AppealSystem)
    {
        return [AppealSystemArray count];
    }
    
    if (tableView == self.table_AppealComponent)
    {
        return [AppealComponentArray count];
    }
    
    
    if (tableView == self.tanle_umpirename)
    {
        return [AppealUmpireArray count];
    }
    
    
    if (tableView == self.table_BatsmenName)
    {
        return [AppealBatsmenArray count];
    }
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        
        
        //wicket type
        if (isWicketSelected && wicketOption == 1){
            
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *wicketTypeCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            WicketTypeRecord *objFieldingFactorRecord=(WicketTypeRecord*)[_WicketTypeArray objectAtIndex:indexPath.row];
            wicketTypeCell.lbl_fastBowl.text = objFieldingFactorRecord.metasubcodedescription;
            self.lbl_fast.text=@"Wicket Type";
            
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            wicketTypeCell.selectedBackgroundView =  customColorView;
            
            return wicketTypeCell;
            
            
        }
        if(isWicketSelected && wicketOption==2){
            
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *strikerNonstrikerCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            NSString *strikerandnonstriker=(NSString*)[_StrikerandNonStrikerArray objectAtIndex:indexPath.row];
            strikerNonstrikerCell.lbl_fastBowl.text = strikerandnonstriker;
            self.lbl_fast.text=@"Batting Players";
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            strikerNonstrikerCell.selectedBackgroundView =  customColorView;
            return strikerNonstrikerCell;


        }
        if(isWicketSelected && wicketOption==3){
            
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *wicketEventCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                      forIndexPath:indexPath];
            NSString *wicketevent=(NSString*)[_WicketEventArray objectAtIndex:indexPath.row];
            wicketEventCell.lbl_fastBowl.text = wicketevent;
            self.lbl_fast.text=@"Wicket Events";
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            wicketEventCell.selectedBackgroundView =  customColorView;
            return wicketEventCell;
            
            
        }
        if (isWicketSelected && wicketOption == 4){
            
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *playerlistCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                               forIndexPath:indexPath];
            BowlerEvent *objPlayerlistRecord=(BowlerEvent*)[_PlayerlistArray objectAtIndex:indexPath.row];
            playerlistCell.lbl_fastBowl.text = objPlayerlistRecord.BowlerName;
            self.lbl_fast.text=@"Bowlers";
            
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            playerlistCell.selectedBackgroundView =  customColorView;
            
            return playerlistCell;
            
            
        }

        
        
        //Fielding factor
        if(isFieldingSelected && fieldingOption == 1)
        {
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *fieldFactorCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            FieldingFactorRecord *objFieldingFactorRecord=(FieldingFactorRecord*)[_fieldingfactorArray objectAtIndex:indexPath.row];
            fieldFactorCell.lbl_fastBowl.text = objFieldingFactorRecord.fieldingfactor;
            self.lbl_fast.text=@"Fielding Factor";
            
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            fieldFactorCell.selectedBackgroundView =  customColorView;
            
            return fieldFactorCell;
        }
        if(isFieldingSelected && fieldingOption == 2)
        {
            static NSString *CellIdentifier = @"fastBowlCell";
            FastBowlTypeCell *fieldFactorCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            BowlerEvent *bowlerEvent=(BowlerEvent*)[_fieldingPlayerArray objectAtIndex:indexPath.row];
            fieldFactorCell.lbl_fastBowl.text = bowlerEvent.BowlerName;
            self.lbl_fast.text=@"Bowlers";
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            fieldFactorCell.selectedBackgroundView =  customColorView;
            return fieldFactorCell;
        }
        if(isFieldingSelected && fieldingOption == 3)
        {
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *fieldFactorCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            NSString *nrs=(NSString*)[_nrsArray objectAtIndex:indexPath.row];
            fieldFactorCell.lbl_fastBowl.text = nrs;
            self.lbl_fast.text=@"Net Run Saved";
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            fieldFactorCell.selectedBackgroundView =  customColorView;
            return fieldFactorCell;
        }
        
        
        
        
    }
    if(tableView == extrasTableView){
        cell.textLabel.text = [self.extrasOptionArray objectAtIndex:indexPath.row];
    }else if(tableView == overThrowTableView){
        cell.textLabel.text = [self.overThrowOptionArray objectAtIndex:indexPath.row];
    }else if(tableView == currentBowlersTableView){
        BowlerEvent *bowlerEvent = [fetchSEPageLoadRecord.getBowlingTeamPlayers objectAtIndex:indexPath.row];
        cell.textLabel.text = bowlerEvent.BowlerName;
    }else if(tableView == nonstrickerTableView){
        SelectPlayerRecord *battingEvent = [nonStrickerList objectAtIndex:indexPath.row];
        cell.textLabel.text = battingEvent.playerName;
    }else if(tableView == strickerTableView){
        SelectPlayerRecord *battingEvent = [strickerList objectAtIndex:indexPath.row];
        cell.textLabel.text = battingEvent.playerName;
    }else {
        cell.textLabel.text = [self.selectbtnvalueArray objectAtIndex:indexPath.row];
    }
    
    if (tableView == table_Appeal) {
        
        static NSString *CellIdentifier = @"Cell";
        AppealCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                           forIndexPath:indexPath];
        
        AppealRecord *objAppealrecord=(AppealRecord*)[_AppealValuesArray objectAtIndex:indexPath.row];
        
        
        cell.AppealName_lbl.text=objAppealrecord.MetaSubCodeDescriptision;
        return cell;
        
    } else if(tableView == tbl_bowlType){
        static NSString *CellIdentifier = @"cell";
        
        BowlTypeCell *bowlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                 forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objBowlRecord=(BowlAndShotTypeRecords*)[_bowlTypeArray objectAtIndex:indexPath.row];
        
        
        bowlCell.lbl_BowlTypeOdd.text = objBowlRecord.BowlType;
        
        // this is where you set your color view
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                          green:161/255.0
                                                           blue:79/255.0
                                                          alpha:0.5];
        bowlCell.selectedBackgroundView =  customColorView;
        
        
        return bowlCell;
    }else if (tableView == tbl_fastBowl){
        
        static NSString *CellIdentifier = @"fastBowlCell";
        
        FastBowlTypeCell *fastBowlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                         forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objBowlRecord=(BowlAndShotTypeRecords*)[_fastBowlTypeArray objectAtIndex:indexPath.row];
        
        
        fastBowlCell.lbl_fastBowl.text = objBowlRecord.BowlType;
        
        // this is where you set your color view
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                          green:161/255.0
                                                           blue:79/255.0
                                                          alpha:0.5];
        fastBowlCell.selectedBackgroundView =  customColorView;
        
        return fastBowlCell;
        
        
    }else if (tableView == tbl_aggressiveShot){
        
        
        static NSString *CellIdentifier = @"aggressiveCell";
        
        AggressiveShotTypeCell *aggressiveCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                 forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objShotRecord=(BowlAndShotTypeRecords*)[_aggressiveShotTypeArray objectAtIndex:indexPath.row];
        
        
        aggressiveCell.lbl_aggressive.text = objShotRecord.ShotType;
        
        // this is where you set your color view
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                          green:161/255.0
                                                           blue:79/255.0
                                                          alpha:0.5];
        aggressiveCell.selectedBackgroundView =  customColorView;
        
        return aggressiveCell;
        
    }else if(tableView == _tbl_defensive){
        
        static NSString *CellIdentifier = @"defensiveCell";
        
        AggressiveShotTypeCell *aggressiveCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                 forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objShotRecord=(BowlAndShotTypeRecords*)[_defensiveShotTypeArray objectAtIndex:indexPath.row];
        
        
        aggressiveCell.lbl_defensive.text = objShotRecord.ShotType;
        
        // this is where you set your color view
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                          green:161/255.0
                                                           blue:79/255.0
                                                          alpha:0.5];
        aggressiveCell.selectedBackgroundView =  customColorView;
        
        return aggressiveCell;
    }
    
    if(tableView == rbwTableview){
        cell.textLabel.text = [self.rbwOptionArray objectAtIndex:indexPath.row];
    }else if(tableView == miscFiltersTableview){
        cell.textLabel.text = [self.miscfiltersOptionArray objectAtIndex:indexPath.row];
    }
    
    
    if (tableView == self.table_AppealSystem)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objAppealSystemEventRecord=(AppealSystemRecords*)[AppealSystemArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objAppealSystemEventRecord.AppealSystemMetaSubCodeDescription;
        return cell;
    }
    
    
    
    if (tableView == self.table_AppealComponent)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objAppealComponentEventRecord=(AppealComponentRecord*)[AppealComponentArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objAppealComponentEventRecord.AppealComponentMetaSubCodeDescription;
        return cell;
    }
    
    
    if (tableView == self.tanle_umpirename)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        
        objAppealUmpireEventRecord=(AppealUmpireRecord*)[AppealUmpireArray objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text =objAppealUmpireEventRecord.AppealUmpireName1;
        cell.textLabel.text =objAppealUmpireEventRecord.AppealUmpireName2;
        return cell;
    }
    
    
    
    
    if (tableView == self.table_BatsmenName)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        // ll.textLabel.text=[AppealComponentArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =[AppealBatsmenArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(IBAction)DidClickStartBall:(id)sender
{
    NSLog(@"btnname=%@",self.btn_StartBall.currentTitle);
    
   
    if([self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
    {
       
        startBallTime = [NSDate date];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
       
        
        NSString *time =[dateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        startBallTime= [dateFormatter1 dateFromString:time];
        [self.btn_StartBall setTitle:@"END BALL" forState:UIControlStateNormal];
        self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
        self.btn_StartOver.userInteractionEnabled=NO;
        [self AllBtnEnableMethod];
        
        [self resetBallEventObject];
        [self resetAllButtonOnEndBall];
        
    }
    else
    {
        [self.btn_StartBall setTitle:@"START BALL" forState:UIControlStateNormal];
        self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
        self.btn_StartOver.userInteractionEnabled=YES;
        //        self.btn_StartBall.userInteractionEnabled=NO;
         [self SaveBallEventREcordvalue];
        [self AllBtndisableMethod];
        
        
        [self timeLeftSinceDate:startBallTime];
        
        
        [DBManager saveBallEventData:self.ballEventRecord];
        [DBManager insertBallCodeAppealEvent:self.ballEventRecord];
        [DBManager insertBallCodeFieldEvent: self.ballEventRecord bowlerEvent:selectedfieldPlayer fieldingFactor: selectedfieldFactor nrs :selectedNRS];
        [DBManager insertBallCodeWicketEvent:self.ballEventRecord];
        [DBManager GetBallDetails :_competitionCode :_matchCode];
        
        
    }
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

- (UIView *) CreateBallTickerInstance: (NSString *) content : (bool) isExtras : (bool) isSpecialEvents : (bool) isMarkedForEdit : (NSString *) ballno : (CGFloat) xposition
{
    //Hints
    //WD NB LB B = Width="55" BorderBrush="#5283AE" Background="Transparent" (Foreground="#5283AE")
    //0 = Width="30" BorderBrush="#5283AE" Background="Transparent" (Foreground="#5283AE")
    //6 = Width="30" BorderBrush="#9434E3" Background="#9434E3" (Foreground="White")
    //4 = Width="30" BorderBrush="#017EFE" Background="#017EFE" (Foreground="White")
    //W = Width="30" BorderBrush="#FB3536" Background="#FB3536" (Foreground="White")
    
    // Border Brushes
    UIColor *runBrushBDR = [self colorWithHexString : @"#5283AE"];
    UIColor *extrasBrushBDR = [self colorWithHexString : @"#FF4DA6"];
    UIColor *fourBrushBDR = [self colorWithHexString : @"#017EFE"];
    UIColor *sixBrushBDR = [self colorWithHexString : @"#9434E3"];
    UIColor *wicketBrushBDR = [self colorWithHexString : @"#FB3536"];
    UIColor *markedForEditBrushBDR = [self colorWithHexString : @"#EDC03C"];
    
    
    // Background Brushes
    UIColor *runBrushBG = [UIColor clearColor];
    UIColor *extrasBrushBG = [self colorWithHexString : @"#FF4DA6"];
    UIColor *fourBrushBG = [self colorWithHexString : @"#017EFE"];
    UIColor *sixBrushBG = [self colorWithHexString : @"#9434E3"];
    UIColor *wicketBrushBG = [self colorWithHexString : @"#FB3536"];
    
    // Foreground Brushes
    UIColor *brushFGNormal = [self colorWithHexString : @"#5283AE"];
    UIColor *brushFGSplEvents = [UIColor whiteColor];
    
    content = [content  isEqual: @"0 W"] ? @"W" : content;
    content = [content  isEqual: @"0 NB"] ? @"NB" : content;
    content = [content  isEqual: @"0 WD"] ? @"WD" : content;
    content = [content  isEqual: @"0 RH"] ? @"RH" : content;
    double singleInstanceWidth = isExtras ? 70 : 47;
    double totalWidth = singleInstanceWidth;
    if (content.length > 5)
        totalWidth = 15 * content.length;
    
    UIView *BallTicker = [[UIView alloc] initWithFrame: CGRectMake(xposition, 0, totalWidth, 57)];
    
    // Border Control
    UIButton *btnborder = [UIButton buttonWithType:UIButtonTypeCustom];
    btnborder.frame     = CGRectMake(0, 0, BallTicker.frame.size.width, 47);
    btnborder.layer.cornerRadius = btnborder.frame.size.width / 2; // this value vary as per your desire
    btnborder.clipsToBounds = NO;
    btnborder.layer.borderWidth = 4.5;
    btnborder.layer.borderColor = [UIColor greenColor].CGColor;
    btnborder.layer.masksToBounds = YES;
    
    if ([content isEqual : @"4"])//Fours
    {
        btnborder.layer.borderColor = (isSpecialEvents ? fourBrushBDR : runBrushBDR).CGColor;
        btnborder.layer.backgroundColor = (isSpecialEvents ? fourBrushBDR : (isExtras ? extrasBrushBG : runBrushBG)).CGColor;
    }
    else if([content isEqual : @"6"])//Sixes
    {
        btnborder.layer.borderColor = (isSpecialEvents ? sixBrushBDR : runBrushBDR).CGColor;
        btnborder.layer.backgroundColor = (isSpecialEvents ? sixBrushBDR : (isExtras ? extrasBrushBG : runBrushBG)).CGColor;
    }else if([content isEqual : @"W"])//Wickets
    {
        btnborder.layer.borderColor = wicketBrushBDR.CGColor;
        btnborder.layer.backgroundColor = wicketBrushBG.CGColor;
    }
    else
    {
        btnborder.layer.borderColor = (isExtras ? extrasBrushBDR : runBrushBDR).CGColor;
        btnborder.layer.backgroundColor =(isExtras ? extrasBrushBG : runBrushBG).CGColor;
    }
    
    if (isMarkedForEdit)
        btnborder.layer.borderColor = markedForEditBrushBDR.CGColor;
    
    [btnborder setTitle:content forState:UIControlStateNormal];
    //for showing different color in ballticker text based on event
    //    [btnborder setTitleColor:(isSpecialEvents || isExtras) ? ((content.length > 1 && !isExtras) ? brushFGNormal : brushFGSplEvents) : brushFGNormal forState:UIControlStateNormal] ;
    [btnborder setTitleColor:brushFGSplEvents forState:UIControlStateNormal] ;
    btnborder.titleLabel.font = [UIFont systemFontOfSize:20 weight:12];
    
    UILabel *BallTickerNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, totalWidth, 10)];
    BallTickerNo.textAlignment = NSTextAlignmentCenter;
    BallTickerNo.font = [UIFont systemFontOfSize:15 weight:10];
    [BallTickerNo setText:content];
    [BallTickerNo setTextColor:brushFGSplEvents];
    
    
    [BallTicker addSubview:btnborder];
    [BallTicker insertSubview:BallTickerNo atIndex:0];
    return BallTicker;
    
}

- (void) CreateBallTickers: (NSMutableArray *) arrayBallDetails
{
    [self.view_BallTicker.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UIScrollView *ScrollViewer = [[UIScrollView alloc] init];
    CGFloat xposition = 0;
    for (BallEventRecord *drballdetails in arrayBallDetails)
    {
        NSMutableDictionary *dicBall = [[NSMutableDictionary alloc] init];
        int _overthrow = [drballdetails.objOverthrow intValue];
        int _runs = [drballdetails.objRuns intValue] + _overthrow;
        int _noball = [drballdetails.objNoball intValue];
        int _wide = [drballdetails.objWide intValue];
        int _legbyes = [drballdetails.objLegByes intValue];
        int _byes = [drballdetails.objByes intValue];
        
        _noball = _noball > 1 ? _noball - 1 : _noball;
        
        if ([drballdetails.objIsFour intValue] == 1)//Boundary Four
            [dicBall setValue:@"4" forKey: @"RUNS"];
        else if ([drballdetails.objIssix intValue] == 1)//Boundary Six
            [dicBall setValue:@"6" forKey: @"RUNS"];
        else
            [dicBall setValue:[NSString stringWithFormat:@"%i", _runs] forKey: @"RUNS"];
        
        if (_noball != 0)//Ball ticker for no balls.
        {
            if (_noball > 0)
            {
                [dicBall removeObjectForKey:@"RUNS"];
                [dicBall setValue:[NSString stringWithFormat:@"%i", (_runs + _noball - 1)] forKey: @"RUNS"];
            }
            [dicBall setValue:@"NB" forKey: @"EXTRAS-NB"];
        }
        
        if (_wide != 0)//Ball ticker for wide balls.
        {
            if (_wide > 0)
            {
                [dicBall removeObjectForKey:@"RUNS"];
                [dicBall setValue:[NSString stringWithFormat:@"%i", (_wide - 1)] forKey: @"RUNS"];
            }
            [dicBall setValue:@"WD" forKey: @"EXTRAS"];
        }
        
        if (_legbyes != 0)//Ball ticker for leg byes.
        {
            if (_legbyes > 0)
            {
                [dicBall removeObjectForKey:@"RUNS"];
                [dicBall setValue:[NSString stringWithFormat:@"%i", (_legbyes + /*_overthrow +*/ (_noball == 0 ? 0 : _noball - 1))] forKey: @"RUNS"];
            }
            if (_noball == 0)
                [dicBall setValue:@"LB" forKey: @"EXTRAS"];
        }
        
        if (_byes != 0)//Ball ticker for byes.
        {
            if (_byes > 0)
            {
                [dicBall removeObjectForKey:@"RUNS"];
                [dicBall setValue:[NSString stringWithFormat:@"%i", (_byes + /*_overthrow +*/ (_noball == 0 ? 0 : _noball - 1))] forKey: @"RUNS"];
            }
            if (_noball == 0)
                [dicBall setValue:@"B" forKey: @"EXTRAS"];
        }
        if ([drballdetails.objWicketno intValue] > 0)
        {
            if ([drballdetails.objWicketType  isEqual: @"MSC102"])
                [dicBall setValue:@"RH" forKey: @"WICKETS"];
            else
                [dicBall setValue:@"W" forKey: @"WICKETS"];
        }
        //MSC134 - BATTING, MSC135 - BOWLING
        int _penalty;
        NSString* _penaltyLabel = drballdetails.objPenaltytypecode;
        _penalty = [drballdetails.objPenalty intValue];
        if (_penaltyLabel.length && _penalty > 0)
        {
            _penaltyLabel = [_penaltyLabel isEqual: @"MSC134"] ?
            ([@"BP " stringByAppendingString: [NSString stringWithFormat:@"%i", _penalty]]) :
            ([_penaltyLabel isEqual: @"MSC135"] ?
             ([@"FP " stringByAppendingString: [NSString stringWithFormat:@"%i", _penalty]]) :
             @"");
            [dicBall setValue:_penaltyLabel forKey: @"PENALTY"];
        }
        
        NSString* content = [[NSString alloc] init];
        bool isExtras = false;
        bool isSix = [drballdetails.objIssix intValue] == 1;
        bool isFour = [drballdetails.objIsFour intValue] == 1;
        bool isSpecialEvents = isFour || isSix || !([[NSString stringWithFormat:@"%i",[drballdetails.objWicketno intValue]]  isEqual: @"0"]);
        
        for (NSString* kvpItem in dicBall)
        {
            isExtras = [[dicBall objectForKey:kvpItem] isEqual : @"WD"] ||
            [[dicBall objectForKey:kvpItem] isEqual : @"NB"] ||
            [[dicBall objectForKey:kvpItem] isEqual : @"B"] ||
            [[dicBall objectForKey:kvpItem] isEqual : @"LB"] ||
            [[dicBall objectForKey:kvpItem] isEqual : @"PENALTY"];
            
            if ([kvpItem isEqual: @"RUNS"] && [[dicBall objectForKey:kvpItem] isEqual : @"0"] && dicBall.count > 1)
                content = [content stringByAppendingString: content];
            else
                content =
                [content stringByAppendingString: [[dicBall objectForKey:kvpItem] stringByAppendingString:@" "]];
        }
        
        //To Create ball tiker for each row.
       [ScrollViewer insertSubview: [self CreateBallTickerInstance
         :[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
         :isExtras
         :isSpecialEvents
         :(int)drballdetails.objMarkedforedit == 1
         :[NSString stringWithFormat:@"%i", (int)drballdetails.objBallno]
         :xposition] atIndex:0];
        if (content.length > 5)
            xposition = xposition + 7 + (15 * content.length);
        else
            xposition = xposition + (isExtras ? 77 : 55);
    }
    [ScrollViewer setContentSize:CGSizeMake(xposition, [ScrollViewer bounds].size.height)];
}

-(NSMutableString*) timeLeftSinceDate: (NSDate *) dateT{
    
    NSMutableString *timeLeft = [[NSMutableString alloc]init];
    
    NSDate *today10am =[NSDate date];
    
    NSInteger seconds = [today10am timeIntervalSinceDate:dateT];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    if(days) {
        [timeLeft appendString:[NSString stringWithFormat:@"%ld Days", (long)days*-1]];
        
        self.ballEventRecord.objballduration=[NSNumber numberWithInteger:days];
    }
    
    if(hours) {
        [timeLeft appendString:[NSString stringWithFormat: @"%ld H", (long)hours*-1]];
        self.ballEventRecord.objballduration=[NSNumber numberWithInteger:hours];
    }
    
    if(minutes) {
        [timeLeft appendString: [NSString stringWithFormat: @"%ld M",(long)minutes*-1]];
        self.ballEventRecord.objballduration=[NSNumber numberWithInteger:minutes];
    }
    
    if(seconds) {
        [timeLeft appendString:[NSString stringWithFormat: @"%lds", (long)seconds*1]];
        self.ballEventRecord.objballduration=[NSNumber numberWithInteger:seconds];
    }
    
    return timeLeft;
}


-(IBAction)DidClickStartOver:(id)sender
{
    NSLog(@"btnname%@",self.btn_StartOver.currentTitle);
    if([self.btn_StartOver.currentTitle isEqualToString:@"START OVER"])
    {
        self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
        [self.btn_StartOver setTitle:@"END OVER" forState:UIControlStateNormal];
        if(![self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
            [self DidClickStartBall : self.btn_StartBall];
        self.btn_StartBall.userInteractionEnabled=YES;
        
    }
    else
    {
        [self.btn_StartOver setTitle:@"START OVER" forState:UIControlStateNormal];
        self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
        self.btn_StartBall.userInteractionEnabled=NO;
        [self AllBtndisableMethod];
    }
}

-(void)AllBtnEnableMethod
{
    self.btn_run1.userInteractionEnabled=YES;
    self.btn_run2.userInteractionEnabled=YES;
    self.btn_run3.userInteractionEnabled=YES;
    self.btn_highRun.userInteractionEnabled=YES;
    self.btn_B4.userInteractionEnabled=YES;
    self.btn_B6.userInteractionEnabled=YES;
    self.btn_extras.userInteractionEnabled=YES;
    self.btn_wkts.userInteractionEnabled=YES;
    self.btn_overthrow.userInteractionEnabled=YES;
    self.btn_miscFilter.userInteractionEnabled=YES;
    self.btn_pichmap.userInteractionEnabled=YES;
    self.btn_wagonwheel.userInteractionEnabled=YES;
    self.btn_OTW.userInteractionEnabled=YES;
    self.btn_RTW.userInteractionEnabled=YES;
    self.btn_Spin.userInteractionEnabled=YES;
    self.btn_Fast.userInteractionEnabled=YES;
    self.btn_Aggressive.userInteractionEnabled=YES;
    self.btn_Defensive.userInteractionEnabled=YES;
    self.btn_Fielding.userInteractionEnabled=YES;
    self.btn_RBW.userInteractionEnabled=YES;
    self.btn_Remarks.userInteractionEnabled=YES;
    self.btn_Edit.userInteractionEnabled=YES;
    self.btn_Appeals.userInteractionEnabled=YES;
    self.btn_lastinstance.userInteractionEnabled=YES;
    
    
}
-(void)AllBtndisableMethod
{
    self.btn_run1.userInteractionEnabled=NO;
    self.btn_run2.userInteractionEnabled=NO;
    self.btn_run3.userInteractionEnabled=NO;
    self.btn_highRun.userInteractionEnabled=NO;
    self.btn_B4.userInteractionEnabled=NO;
    self.btn_B6.userInteractionEnabled=NO;
    self.btn_extras.userInteractionEnabled=NO;
    self.btn_wkts.userInteractionEnabled=NO;
    self.btn_overthrow.userInteractionEnabled=NO;
    self.btn_miscFilter.userInteractionEnabled=NO;
    self.btn_pichmap.userInteractionEnabled=NO;
    self.btn_wagonwheel.userInteractionEnabled=NO;
    self.btn_OTW.userInteractionEnabled=NO;
    self.btn_RTW.userInteractionEnabled=NO;
    self.btn_Spin.userInteractionEnabled=NO;
    self.btn_Fast.userInteractionEnabled=NO;
    self.btn_Aggressive.userInteractionEnabled=NO;
    self.btn_Defensive.userInteractionEnabled=NO;
    self.btn_Fielding.userInteractionEnabled=NO;
    self.btn_RBW.userInteractionEnabled=NO;
    self.btn_Remarks.userInteractionEnabled=NO;
    self.btn_Edit.userInteractionEnabled=NO;
    self.btn_Appeals.userInteractionEnabled=NO;
    self.btn_lastinstance.userInteractionEnabled=NO;
}

-(void)BtndisableforWicketsMethod{
    self.btn_run1.userInteractionEnabled=NO;
    self.btn_run2.userInteractionEnabled=NO;
    self.btn_run3.userInteractionEnabled=NO;
    self.btn_highRun.userInteractionEnabled=NO;
    self.btn_B4.userInteractionEnabled=NO;
    self.btn_B6.userInteractionEnabled=NO;
    
}

-(IBAction)didClickLeftSideBtn_Action:(id)sender
{
    if(objextras!=nil)
    {
        [objextras removeFromSuperview];
    }
    self.PichMapTittle.hidden=YES;
    //    if(extrasTableView !=nil){
    //        [extrasTableView removeFromSuperview];
    //    }
    //
    //    if(overThrowTableView !=nil){
    //        [overThrowTableView removeFromSuperview];
    //    }
    UIButton *selectBtnTag=(UIButton*)sender;
    
    if(isExtrasSelected && selectBtnTag.tag!=106){//Already open state
        
        
        if(self.ballEventRecord.objNoball.integerValue ==0 && self.ballEventRecord.objWide.integerValue ==0 && self.ballEventRecord.objByes.integerValue ==0 && self.ballEventRecord.objLegByes.integerValue ==0){//Nothing selected
            
            [self unselectedButtonBg:self.btn_extras];
        }else{//If any one selected
            
            [self selectedButtonBg:self.btn_extras];
        }
        
        if(extrasTableView!=nil){
            [extrasTableView removeFromSuperview];
        }
        
        
        isExtrasSelected = NO;
        
    }
    
    if(isOverthrowSelected  && selectBtnTag.tag!=108){// Already open state
        if(overThrowTableView!=nil){
            [overThrowTableView removeFromSuperview];
        }
        
        if(self.ballEventRecord.objOverthrow.integerValue!=0){
            [self selectedButtonBg:self.btn_overthrow];
        }else{
            [self unselectedButtonBg:self.btn_overthrow];
        }
        
        isOverthrowSelected = NO;
        
    }
    
    if(isFieldingSelected && fieldingOption>0){
        fieldingOption = 0;
    }
    
    if(isWicketSelected && wicketOption>0){
        wicketOption = 0;
    }
    
    if (isRBWSelected) {
        if(self.ballEventRecord.objRbw!=0){
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            
        }else{
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            
        }
        [rbwTableview removeFromSuperview];
        
        isRBWSelected = NO;
    }
    
    if (ismiscFilters) {
        if(self.ballEventRecord.objIsbeaten.integerValue ==0 && self.ballEventRecord.objIswtb.integerValue ==0 && self.ballEventRecord.objIsuncomfort.integerValue ==0 && self.ballEventRecord.objIsreleaseshot.integerValue ==0){
            self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Black
            
            
        }else{
            
            self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Green
        }
        [miscFiltersTableview removeFromSuperview];
        
        ismiscFilters = NO;
    }
    
    if(selectBtnTag.tag==100)//Run one
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==101)// Run two
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==102)// Run three
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==103)//More Runs
    {
        [self calculateRuns:selectBtnTag.tag];
        
    }
    else if(selectBtnTag.tag==104)// B4
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==105)// B6
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==106)//Extras
    {
        [self extrasPopupMenu:selectBtnTag];
        //[self selectBtncolor_Action:@"106" :self.btn_extras :0];
        //self.selectbtnvalueArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
        //[self selelectbtnPop_View:selectBtnTag];
    }
    else if(selectBtnTag.tag==107)   //wicket
    {
        //[self selectBtncolor_Action:@"107" :self.btn_wkts :0];
        
        
       //self.view_bowlType.hidden = YES;
        if(isWicketSelected){
            
           
            selectedwickettype = nil;
            
            isWicketSelected = NO;
            wicketOption = 0;
            self.view_aggressiveShot.hidden = YES;
            self.view_defensive.hidden = YES;
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = YES;
            [self unselectedButtonBg:selectBtnTag];
            
        }else{
        
            _WicketTypeArray=[[NSMutableArray alloc]init];
            NSMutableArray *tempWickettypeArray  =[DBManager RetrieveWicketType];
            
            
            if(self.ballEventRecord.objIssix.intValue == 1){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"wicket not possible in B6"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if(self.ballEventRecord.objIsFour.intValue == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"wicket not possible in B4"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {if(self.ballEventRecord.objNoball.intValue !=0){
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                    if ([wicketTypeRecord.metasubcode isEqual:@"MSC097"] || [wicketTypeRecord.metasubcode isEqual:@"MSC100"]|| [wicketTypeRecord.metasubcode isEqual:@"MSC103"] || [wicketTypeRecord.metasubcode isEqual:@"MSC106"]) {
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                }
             }else if(self.ballEventRecord.objWide.intValue !=0){
                 for(int i=0;i<tempWickettypeArray.count;i++){
                     WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                     if([wicketTypeRecord.metasubcode isEqual:@"MSC097"] || [wicketTypeRecord.metasubcode isEqual:@"MSC104"] ||[wicketTypeRecord.metasubcode isEqual:@"MSC099"] || [wicketTypeRecord.metasubcode isEqual:@"MSC106"] ){
                         [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                     }
                 }
             }else if(self.ballEventRecord.objRuns.intValue != 0){
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord  = [tempWickettypeArray objectAtIndex:i];
                    if([wicketTypeRecord.metasubcode isEqual: @"MSC097"]){
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                }
            }else if(self.ballEventRecord.objLegByes.intValue !=0){
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                    if([wicketTypeRecord.metasubcode isEqual: @"MSC097"]){
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                }
            }else if(self.ballEventRecord.objByes.intValue !=0){
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                    if([wicketTypeRecord.metasubcode isEqual:@"MSC097"]){
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                }
            }else{
                _WicketTypeArray  = [[NSMutableArray alloc]initWithArray:tempWickettypeArray];
                
            }
            
            [self selectedButtonBg:selectBtnTag];
            
            isWicketSelected = YES;
            wicketOption = 1;
            // [self BtndisableforWicketsMethod];
                
            self.view_aggressiveShot.hidden = YES;
            self.view_defensive.hidden = YES;
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = NO;
            
            [self.tbl_fastBowl reloadData];
            }
//            if(selectedNRS!=nil){
//                
//                int indx=0;
//                int selectePosition = -1;
//                for (FieldingFactorRecord *record in _fieldingfactorArray)
//                {
//                    bool chk = ([[record fieldingfactorcode] isEqualToString:selectedfieldFactor.fieldingfactorcode]);
//                    if (chk)
//                    {
//                        selectePosition = indx;
//                        break;
//                    }
//                    indx ++;
//                }
//                
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
//                [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//                
//                [tbl_fastBowl scrollToRowAtIndexPath:indexPath
//                                    atScrollPosition:UITableViewScrollPositionTop
//                                            animated:YES];
//                
//            }
        }
        
    
        
        
    }
    else if(selectBtnTag.tag==108)//Overthrow
    {
        
        [self overThrowPopupMenu:selectBtnTag];
        
        //  [self selectBtncolor_Action:@"108" :self.btn_overthrow :0];
        //  self.selectbtnvalueArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
        //  [self selelectbtnPop_View:selectBtnTag];
    }
    else if(selectBtnTag.tag==109)//Misc Filter
    {
        if (ismiscFilters) {
            if(self.ballEventRecord.objIsbeaten.integerValue ==0 && self.ballEventRecord.objIswtb.integerValue ==0 && self.ballEventRecord.objIsuncomfort.integerValue ==0 && self.ballEventRecord.objIsreleaseshot.integerValue ==0){
                self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Black
                
                
            }else{
                
                self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Green
            }
            [miscFiltersTableview removeFromSuperview];
            
            ismiscFilters = NO;
        }else{
            ismiscFilters = YES;
            
            
            
            self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            self.miscfiltersOptionArray=[[NSMutableArray alloc]initWithObjects:@"Uncomfort",@"Beaten",@"Release Shot",@"WTB", nil];
            
            
            miscFiltersTableview=[[UITableView alloc]initWithFrame:CGRectMake(selectBtnTag.frame.origin.x+selectBtnTag.frame.size.width+10, selectBtnTag.frame.origin.y-50,150,200)];
            miscFiltersTableview.backgroundColor=[UIColor whiteColor];
            
            miscFiltersTableview.dataSource = self;
            miscFiltersTableview.delegate = self;
            [self.commonleftrightview addSubview:miscFiltersTableview];
            miscFiltersTableview.allowsMultipleSelection = YES;
            [miscFiltersTableview reloadData];
            
            
            if(self.ballEventRecord.objIsuncomfort.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            if(self.ballEventRecord.objIsbeaten.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            if(self.ballEventRecord.objIsreleaseshot.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            if(self.ballEventRecord.objIswtb.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        
    }
    else if(selectBtnTag.tag==110)
    {
        
                [self selectBtncolor_Action:@"110" :self.btn_pichmap :0];
             if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    [self.img_pichmap setImage:[UIImage imageNamed:@"pichmapRH"]];
                }
            else{
                    [self.img_pichmap setImage:[UIImage imageNamed:@"pichmapLH"]];
                }
                UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickPichmapTapAction:)];
                tapRecognizer.numberOfTapsRequired = 1;
                tapRecognizer.numberOfTouchesRequired=1;
                tapRecognizer.delegate=self;
                [self.img_pichmap addGestureRecognizer:tapRecognizer];
                [self.img_pichmap setUserInteractionEnabled:YES];
        self.PichMapTittle =[[UILabel alloc]initWithFrame:CGRectMake(self.commonleftrightview.frame.origin.x-20,self.Allvaluedisplayview.frame.origin.y-75,self.Allvaluedisplayview.frame.size.width, 35)];
        self.PichMapTittle.text=@"PICHMAP";
        self.PichMapTittle.font=[UIFont fontWithName:@"RAJDHANI-MEDIUM" size:20];
        self.PichMapTittle.textColor=[UIColor whiteColor];
        self.PichMapTittle.textAlignment=NSTextAlignmentCenter;
        self.PichMapTittle.backgroundColor=[UIColor colorWithRed:(49/255.0f) green:(72/255.0f) blue:(159/255.0f) alpha:1.0f];
        self.PichMapTittle.hidden=NO;
        [self.Allvaluedisplayview addSubview:self.PichMapTittle];
        
        
                   _View_Appeal.hidden=YES;
                self.view_bowlType.hidden = YES;
                self.view_fastBowl.hidden = YES;
                self.view_aggressiveShot.hidden = YES;
                self.view_defensive.hidden = YES;
                self.view_Wagon_wheel.hidden=YES;
        
        
    }
    else if(selectBtnTag.tag==111)
    {
                [self selectBtncolor_Action:@"111" :self.btn_wagonwheel :0];
                //[self.img_pichmap setImage:[UIImage imageNamed:@"WagonWheel_img"]];
                 _View_Appeal.hidden=YES;
          _view_Wagon_wheel.hidden=NO;
        
        if(IS_IPAD_PRO)
        {
            self.height.constant=450;
            self.width.constant=450;
        }
        else{
            self.height.constant=350;
            self.width.constant=350;
        }
        
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            [self.img_WagonWheel setImage:[UIImage imageNamed:@"LHWagon"]];
        }
        else{
            [self.img_WagonWheel setImage:[UIImage imageNamed:@"RHWagon"]];
        }
        
        if (IS_IPAD_PRO) {
                    self.centerlbl=[[UILabel alloc]initWithFrame:CGRectMake(self.img_WagonWheel.frame.size.width/2+46, self.img_WagonWheel.frame.size.width/2+11, 5, 5)];
        }
        else
            
        self.centerlbl=[[UILabel alloc]initWithFrame:CGRectMake(self.img_WagonWheel.frame.size.width/2-3, self.img_WagonWheel.frame.size.width/2-30, 5, 5)];
      
        [self.centerlbl setBackgroundColor:[UIColor clearColor]];
        [self.img_WagonWheel addSubview:self.centerlbl];

        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickWagonWheelmapTapAction:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired=1;
        tapRecognizer.delegate=self;
        [self.view_DrawlineWagon addGestureRecognizer:tapRecognizer];
        [self.view_DrawlineWagon setUserInteractionEnabled:YES];
                self.view_bowlType.hidden = YES;
                self.view_fastBowl.hidden = YES;
                self.view_aggressiveShot.hidden = YES;
                self.view_defensive.hidden = YES;
        
        
    }
}






- (void)didClickPichmapTapAction:(UIGestureRecognizer *)pichmapGesture
   {
      
       if(Img_ball != nil)
       {
           [Img_ball removeFromSuperview];
       }

       CGPoint p = [pichmapGesture locationInView:self.img_pichmap];
       NSLog(@"pointx=%f,pointY=%f",p.x,p.y);
       float Xposition = p.x-10;
       float Yposition = p.y-10;
      
       if(IS_IPAD_PRO)
       {
        Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(Xposition,Yposition,20, 20)];

     if(Xposition > 205 && Yposition > 85 && Xposition < 455 && Yposition < 200)
       {

          Img_ball.image =[UIImage imageNamed:@"RedBall"];
           [self.img_pichmap addSubview:Img_ball];
           _ballEventRecord.objPMX1=@1;
           _ballEventRecord.objPMY1=@1;
           _ballEventRecord.objPMX2=@(Xposition);
           _ballEventRecord.objPMY2=@(Yposition);
       }
       else if ((Xposition > 183 && Yposition > 200 && Xposition < 465 && Yposition < 238))
       {
           if(Xposition > 183 && Yposition > 200 && Xposition < 264)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"yorker wide0.0");
               }
               else{
                    NSLog(@"yorker wide D.L");
               }
               
           }
         
          else if(Xposition >270 && Yposition >200 && Xposition < 304)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                    NSLog(@"yorker outside OFF");
               }
           else{
                  NSLog(@"yorker outside LEG");
               }
           }
          else if(Xposition >310 && Yposition >200 && Xposition < 341)
          {
              
                 NSLog(@"yorker Middle");
              
          }
          else if(Xposition >342 && Yposition >200 && Xposition < 377)
          {
              if([self.BatmenStyle isEqualToString:@"MSC013"])
              {
                  NSLog(@"yorker outside LEG");
              }
          else{
                  NSLog(@"yorker outside off");
              }
          }
          else if(Xposition >375 && Yposition >200 && Xposition < 463)
          {
              if([self.BatmenStyle isEqualToString:@"MSC013"])
              {
                  NSLog(@"yorker wide D.L");
              }
          else{
              
                  NSLog(@"yorker wide 0.0");
              }
          }


           Img_ball.image =[UIImage imageNamed:@"RedBall"];
           [self.img_pichmap addSubview:Img_ball];
           _ballEventRecord.objPMX1=@1;
           _ballEventRecord.objPMY1=@1;
           _ballEventRecord.objPMX2=@(Xposition);
           _ballEventRecord.objPMY2=@(Yposition);
       }
       else if ((Xposition > 172 && Yposition > 240 && Xposition < 479 && Yposition < 290))
       {
           if(Xposition > 172 && Yposition > 240 && Xposition < 246)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"Full wide0.0");
               }
               else{
                   NSLog(@"Full wide D.L");
               }
               
           }
           else if(Xposition >265 && Yposition >240 && Xposition < 296)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"full outside OFF");
               }
               else{
                   NSLog(@"full outside LEG");
               }
               
           }

           else if(Xposition >300 && Yposition >240 && Xposition < 343)
           {
               NSLog(@"full Middle");
           }
           else if(Xposition >343 && Yposition >240 && Xposition < 390)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"full outside LEG");
               }
               else{
                   NSLog(@"full outside off");
               }
               
           }
           else if(Xposition >385 && Yposition >240 && Xposition < 479)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"full wide D.L");
               }
               else{
                   
                   NSLog(@"full wide 0.0");
               }
              
           }
           
           Img_ball.image =[UIImage imageNamed:@"RedBall"];
           [self.img_pichmap addSubview:Img_ball];
           _ballEventRecord.objPMX1=@1;
           _ballEventRecord.objPMY1=@1;
           _ballEventRecord.objPMX2=@(Xposition);
           _ballEventRecord.objPMY2=@(Yposition);
       }
       else if ((Xposition > 158 && Yposition >297 && Xposition < 505 && Yposition < 389))
       {
           if(Xposition > 158 && Yposition > 297 && Xposition < 223)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"good wide0.0");
               }
               else{
                   NSLog(@"good wide D.L");
               }
              
           }
           else if(Xposition >249 && Yposition >297 && Xposition < 290)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"good outside OFF");
               }
               else{
                   NSLog(@"good outside LEG");
               }
            }
           
           else if(Xposition >300 && Yposition >297 && Xposition < 350)
           {
               NSLog(@"good Middle");
           }
           else if(Xposition >350 && Yposition >297 && Xposition < 409)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"good outside LEG");
               }
               else{
                   NSLog(@"good outside off");
               }
               
           }
           else if(Xposition >395 && Yposition >298 && Xposition < 505)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"good wide D.L");
               }
               else{
                   
                   NSLog(@"good wide 0.0");
               }
               //NSLog(@"good wide 0.0");
           }
           Img_ball.image =[UIImage imageNamed:@"RedBall"];
           [self.img_pichmap addSubview:Img_ball];
           _ballEventRecord.objPMX1=@1;
           _ballEventRecord.objPMY1=@1;
           _ballEventRecord.objPMX2=@(Xposition);
           _ballEventRecord.objPMY2=@(Yposition);
       }
       else if ((Xposition > 130 && Yposition >398 && Xposition < 535 && Yposition < 500))
       {
           if(Xposition > 130 && Yposition > 398 && Xposition < 192)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"short wide0.0");
               }
               else{
                   NSLog(@"short wide D.L");
               }
              
           }
           else if(Xposition >226 && Yposition >398 && Xposition < 275)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"short outside OFF");
               }
               else{
                   NSLog(@"short outside LEG");
               }
           }
           else if(Xposition >291 && Yposition >398 && Xposition < 400)
           {
               NSLog(@"short Middle");
           }
           else if(Xposition >356 && Yposition >398 && Xposition < 435)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"short outside LEG");
               }
               else{
                   NSLog(@"short outside off");
               }

           }
           else if(Xposition >423 && Yposition >398 && Xposition < 535)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"short wide D.L");
               }
               else{
                   
                   NSLog(@"short wide 0.0");
               }
              
           }
           Img_ball.image =[UIImage imageNamed:@"RedBall"];
           [self.img_pichmap addSubview:Img_ball];
           _ballEventRecord.objPMX1=@1;
           _ballEventRecord.objPMY1=@1;
           _ballEventRecord.objPMX2=@(Xposition);
           _ballEventRecord.objPMY2=@(Yposition);
       }
       else if ((Xposition > 100 && Yposition >500 && Xposition < 555 && Yposition < 578))
       {
           if(Xposition >100 && Yposition > 500 && Xposition < 175)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"Bouncer wide0.0");
               }
               else{
                   NSLog(@"Bouncer wide D.L");
               }
              
           }
           else if(Xposition >196 && Yposition >500 && Xposition < 267)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"Bouncer outside OFF");
               }
               else{
                   NSLog(@"Bouncer outside LEG");
               }
            }
           else if(Xposition >280 && Yposition >500 && Xposition < 363)
           {
               NSLog(@"Bouncer Middle");
           }
           else if(Xposition >368 && Yposition >500 && Xposition < 455)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"Bouncer outside LEG");
               }
               else{
                   NSLog(@"Bouncer outside off");
               }

            }
           else if(Xposition >447 && Yposition >500 && Xposition < 553)
           {
               if([self.BatmenStyle isEqualToString:@"MSC013"])
               {
                   NSLog(@"Bouncer wide D.L");
               }
               else{
                   
                   NSLog(@"Bouncer wide 0.0");
               }
               
           }
           Img_ball.image =[UIImage imageNamed:@"RedBall"];
           [self.img_pichmap addSubview:Img_ball];
           _ballEventRecord.objPMX1=@1;
           _ballEventRecord.objPMY1=@1;
           _ballEventRecord.objPMX2=@(Xposition);
           _ballEventRecord.objPMY2=@(Yposition);
       }
       }
       else{
            Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(Xposition,Yposition,15, 15)];
           
//           if(Xposition > 103 && Yposition > -19 && Xposition < 243 && Yposition < 60)
//           {
//               Img_ball.image =[UIImage imageNamed:@"RedBall"];
//               [self.img_pichmap addSubview:Img_ball];
//           }
           
          if(Xposition >96 && Yposition > 37 && Xposition < 265 && Yposition < 105)
           {
               
               Img_ball.image =[UIImage imageNamed:@"RedBall"];
               [self.img_pichmap addSubview:Img_ball];
               
           }
           else if ((Xposition > 100 && Yposition > 93 && Xposition < 271 && Yposition < 128))
           {
               if(Xposition > 100 && Yposition > 93 && Xposition < 151)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"yorker wide0.0");
                   }
                   else{
                       NSLog(@"yorker wide D.L");
                   }
                }
               else if(Xposition >156 && Yposition >105 && Xposition < 177)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"yorker outside OFF");
                   }
                   else{
                       NSLog(@"yorker outside LEG");
                   }
                   
               }
               else if(Xposition >177 && Yposition >105 && Xposition < 198)
               {
                   NSLog(@"yorker Middle");
               }
               else if(Xposition >198 && Yposition >105 && Xposition < 219)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"yorker outside LEG");
                   }
                   else{
                       NSLog(@"yorker outside off");
                   }
                  
               }
               else if(Xposition >216 && Yposition >105 && Xposition < 270)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"yorker wide D.L");
                   }
                   else{
                       
                       NSLog(@"yorker wide 0.0");
                   }
               }

               Img_ball.image =[UIImage imageNamed:@"RedBall"];
               [self.img_pichmap addSubview:Img_ball];
           }
           else if ((Xposition > 98 && Yposition > 127 && Xposition < 279 && Yposition < 160))
           {
               if(Xposition > 98 && Yposition > 127 && Xposition < 145)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"Full wide0.0");
                   }
                   else{
                       NSLog(@"Full wide D.L");
                   }
               }
               else if(Xposition >93 && Yposition >127 && Xposition < 174)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"full outside OFF");
                   }
                   else{
                       NSLog(@"full outside LEG");
                   }
                   
               }
               else if(Xposition >175 && Yposition >127 && Xposition < 197)
               {
                   NSLog(@"full Middle");
               }
               else if(Xposition >198 && Yposition >127 && Xposition < 227)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"full outside LEG");
                   }
                   else{
                       NSLog(@"full outside off");
                   }
                  
               }
               else if(Xposition >220 && Yposition >127 && Xposition < 281)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"full wide D.L");
                   }
                   else{
                       
                       NSLog(@"full wide 0.0");
                   }
               }
               Img_ball.image =[UIImage imageNamed:@"RedBall"];
               [self.img_pichmap addSubview:Img_ball];
           }
           else if ((Xposition > 85 && Yposition > 160 && Xposition < 294 && Yposition < 217))
           {
               if(Xposition > 85 && Yposition > 160 && Xposition < 127)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"good wide0.0");
                   }
                   else{
                       NSLog(@"good wide D.L");
                   }
                  
               }
               else if(Xposition > 130 && Yposition > 160 && Xposition < 166)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"good outside OFF");
                   }
                   else{
                       NSLog(@"good outside LEG");
                   }
               }
               else if(Xposition >162 && Yposition >160 && Xposition < 203)
               {
                   NSLog(@"good Middle");
               }
               else if(Xposition >203 && Yposition >160 && Xposition < 239)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"good outside LEG");
                   }
                   else{
                       NSLog(@"good outside off");
                   }
               }
               else if(Xposition >215 && Yposition >134 && Xposition < 294)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"good wide D.L");
                   }
                   else{
                       
                       NSLog(@"good wide 0.0");
                   }
               }
               Img_ball.image =[UIImage imageNamed:@"RedBall"];
               [self.img_pichmap addSubview:Img_ball];
           }
           else if ((Xposition > 70 && Yposition > 220 && Xposition < 315 && Yposition < 286))
           {
               if(Xposition > 70 && Yposition > 220 && Xposition < 111)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"short wide0.0");
                   }
                   else{
                       NSLog(@"short wide D.L");
                   }
                   
               }
               else if(Xposition >125 && Yposition >220 && Xposition < 160)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"short outside OFF");
                   }
                   else{
                       NSLog(@"short outside LEG");
                   }
                  
               }
               else if(Xposition >163 && Yposition >220 && Xposition < 210)
               {
                   NSLog(@"short Middle");
               }
               else if(Xposition >207 && Yposition >220 && Xposition < 255)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"short outside LEG");
                   }
                   else{
                       NSLog(@"short outside off");
                   }
                   
               }
               else if(Xposition >246 && Yposition >220 && Xposition < 315)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"short wide D.L");
                   }
                   else{
                       
                       NSLog(@"short wide 0.0");
                   }
                   
               }
               Img_ball.image =[UIImage imageNamed:@"RedBall"];
               [self.img_pichmap addSubview:Img_ball];
           }
           else if ((Xposition > 54 && Yposition > 288 && Xposition < 325 && Yposition < 331))
           {
               if(Xposition >54 && Yposition > 288 && Xposition < 100)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"Bouncer wide0.0");
                   }
                   else{
                       NSLog(@"Bouncer wide D.L");
                   }
                   
               }
               else if(Xposition >110 && Yposition >288 && Xposition < 156)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"Bouncer outside OFF");
                   }
                   else{
                       NSLog(@"Bouncer outside LEG");
                   }

                }
               else if(Xposition >159 && Yposition >290 && Xposition < 213)
               {
                   NSLog(@"Bouncer Middle");
               }
               else if(Xposition >213 && Yposition >290 && Xposition < 268)
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"Bouncer outside LEG");
                   }
                   else{
                       NSLog(@"Bouncer outside off");
                   }
               }
               else if(Xposition >260 && Yposition >290 && Xposition < 325 )
               {
                   if([self.BatmenStyle isEqualToString:@"MSC013"])
                   {
                       NSLog(@"Bouncer wide D.L");
                   }
                   else{
                       
                       NSLog(@"Bouncer wide 0.0");
                   }
               }
               Img_ball.image =[UIImage imageNamed:@"RedBall"];
               [self.img_pichmap addSubview:Img_ball];
           }
           _ballEventRecord.objPMX1=@1;
           _ballEventRecord.objPMY1=@1;
           _ballEventRecord.objPMX2=@(Xposition);
           _ballEventRecord.objPMY2=@(Yposition);
       }
       
    }
-(void)selelectbtnPop_View:(UIButton *)btn_selection
{
    objextras=[[UITableView alloc]initWithFrame:CGRectMake(btn_selection.frame.origin.x+btn_selection.frame.size.width+10, btn_selection.frame.origin.y-50,100,200)];
    objextras.backgroundColor=[UIColor whiteColor];
    
    objextras.dataSource = self;
    objextras.delegate = self;
    [self.commonleftrightview addSubview:objextras];
    [objextras reloadData];
    
}

-(IBAction)didClickRightSideBtn_Action:(id)sender
{
    UIButton *selectBtnTag=(UIButton*)sender;
    
    
    if(isExtrasSelected && selectBtnTag.tag!=106){//Already open state
        
        
        if(self.ballEventRecord.objNoball.integerValue ==0 && self.ballEventRecord.objWide.integerValue ==0 && self.ballEventRecord.objByes.integerValue ==0 && self.ballEventRecord.objLegByes.integerValue ==0){//Nothing selected
            
            [self unselectedButtonBg:self.btn_extras];
        }else{//If any one selected
            
            [self selectedButtonBg:self.btn_extras];
        }
        
        if(extrasTableView!=nil){
            [extrasTableView removeFromSuperview];
        }
        
        
        isExtrasSelected = NO;
        
    }
    
    if(isOverthrowSelected  && selectBtnTag.tag!=108){// Already open state
        if(overThrowTableView!=nil){
            [overThrowTableView removeFromSuperview];
        }
        
        if(self.ballEventRecord.objOverthrow.integerValue!=0){
            [self selectedButtonBg:self.btn_overthrow];
        }else{
            [self unselectedButtonBg:self.btn_overthrow];
        }
        
        isOverthrowSelected = NO;
        
    }
    
    
    if(isFieldingSelected && fieldingOption>0){
        fieldingOption = 0;
    }
    
    if(isWicketSelected && wicketOption>0){
        wicketOption = 0;
    }
    
    if (isRBWSelected) {
        if(self.ballEventRecord.objRbw!=0){
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            
        }else{
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            
        }
        [rbwTableview removeFromSuperview];
        
        isRBWSelected = NO;
    }
    
    if (ismiscFilters) {
        if(self.ballEventRecord.objIsbeaten.integerValue ==0 && self.ballEventRecord.objIswtb.integerValue ==0 && self.ballEventRecord.objIsuncomfort.integerValue ==0 && self.ballEventRecord.objIsreleaseshot.integerValue ==0){
            self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Black
            
            
        }else{
            
            self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Green
        }
        [miscFiltersTableview removeFromSuperview];
        
        ismiscFilters = NO;
    }
    
    //isSelectleftview=NO;
    if(selectBtnTag.tag==112)
    {
        
        
        [self otwSelectAndDeselect];
        
    }
    else if(selectBtnTag.tag==113)
    {
        [self rtwSelectAndDeselect];
        
    }
    else if(selectBtnTag.tag==114)
    {
        //  [self selectBtncolor_Action:@"114" :nil :203];
        
        self.view_bowlType.hidden = NO;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden = YES;
        
        if(isSpinSelected){
            
            NSInteger position = [self.bowlTypeArray indexOfObject:self.ballEventRecord.objBowltype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_bowlType selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_bowlType scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }else{
            self.ballEventRecord.objBowltype = nil;
            [tbl_bowlType reloadData];
        }
        
        //View
        _view_spin.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_fast.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        
        
        
    }
    else if(selectBtnTag.tag==115)//fast
    {
        //[self selectBtncolor_Action:@"115" :nil :204];
        self.view_aggressiveShot.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        self.view_defensive.hidden = YES;
        
        if(isFastSelected){
            
            NSInteger position = [self.bowlTypeArray indexOfObject:self.ballEventRecord.objBowltype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }else{
            self.ballEventRecord.objBowltype = nil;
            [tbl_bowlType reloadData];
        }
        
        //View
        _view_fast.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_spin.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        
        
    }
    else if(selectBtnTag.tag==116)//aggressive
    {
        //[self selectBtncolor_Action:@"116" :nil :205];
        self.view_aggressiveShot.hidden = NO;
        self.view_fastBowl.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_defensive.hidden = YES;
        
        if(isAggressiveSelected){
            
            NSInteger position = [self.aggressiveShotTypeArray indexOfObject:self.ballEventRecord.objShottype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_aggressiveShot selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_aggressiveShot scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
        }else{
            self.ballEventRecord.objShottype = nil;
            [tbl_aggressiveShot reloadData];
        }
        
        //View
        _view_aggressive.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_defense.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        
        
        
        
    }
    else if(selectBtnTag.tag==117)
    {
        //[self selectBtncolor_Action:@"117" :nil :206];
        self.view_defensive.hidden = NO;
        self.view_aggressiveShot.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_bowlType.hidden = YES;
        
        if(isDefensiveSelected){
            
            NSInteger position = [self.defensiveShotTypeArray indexOfObject:self.ballEventRecord.objShottype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [_tbl_defensive selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [_tbl_defensive scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        }else{
            self.ballEventRecord.objShottype = nil;
            [_tbl_defensive reloadData];
        }
        
        //View
        _view_defense.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_aggressive.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        
        
        
    }
    else if(selectBtnTag.tag==118) //fielding factor
    {
        //[self selectBtncolor_Action:@"118" :nil :207];
        
        if(isFieldingSelected){
            
            selectedNRS = nil;
            selectedfieldPlayer = nil;
            selectedfieldFactor = nil;
            
            isFieldingSelected = NO;
            fieldingOption = 0;
            self.view_aggressiveShot.hidden = YES;
            self.view_defensive.hidden = YES;
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = YES;
            //[self unselectedButtonBg:selectBtnTag];
            
            _view_fielding_factor.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(4/255.0f) alpha:1.0f];//Normal
            
        }else{
            //Fielding Factor
            _fieldingfactorArray=[[NSMutableArray alloc]init];
            _fieldingfactorArray =[DBManager RetrieveFieldingFactorData];
            
            _view_fielding_factor.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
            
            isFieldingSelected = YES;
            fieldingOption = 1;
            
            self.view_aggressiveShot.hidden = YES;
            self.view_defensive.hidden = YES;
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = NO;
            
            [self.tbl_fastBowl reloadData];
            
            if(selectedNRS!=nil){
                
                int indx=0;
                int selectePosition = -1;
                for (FieldingFactorRecord *record in _fieldingfactorArray)
                {
                    bool chk = ([[record fieldingfactorcode] isEqualToString:selectedfieldFactor.fieldingfactorcode]);
                    if (chk)
                    {
                        selectePosition = indx;
                        break;
                    }
                    indx ++;
                }
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
                [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
                
            }
        }
        
    }
    else if(selectBtnTag.tag==119)//RBW
    {
        if (isRBWSelected) {
            if(self.ballEventRecord.objRbw!=0){
                
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
                
            }else{
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
                
            }
            [rbwTableview removeFromSuperview];
            
            isRBWSelected = NO;
        }else{
            isRBWSelected = YES;
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            self.rbwOptionArray=[[NSMutableArray alloc]initWithObjects:@"-5",@"-4",@"-3",@"-2",@"-1",@"1",@"2",@"3",@"4",@"5", nil];
            
            
            rbwTableview=[[UITableView alloc]initWithFrame:CGRectMake(self.commonleftrightview.frame.size.width-180, self.btn_RBW.frame.origin.y-80,100,250)];
            rbwTableview.backgroundColor=[UIColor whiteColor];
            
            rbwTableview.dataSource = self;
            rbwTableview.delegate = self;
            [self.commonleftrightview addSubview:rbwTableview];
            [rbwTableview reloadData];
            
            
            if(self.ballEventRecord.objRbw!=0){
                NSInteger position = [self.rbwOptionArray indexOfObject:self.ballEventRecord.objRbw];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
                [rbwTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    else if(selectBtnTag.tag==120)
    {
         [self selectBtncolor_Action:@"120" :nil :209];
         [self RemarkMethode];
        
    }
    else if(selectBtnTag.tag==121)
    {
        //   [self selectBtncolor_Action:@"121" :nil :210];
    }
    else if(selectBtnTag.tag==122)//Appels
    {
        //  [self selectBtncolor_Action:@"122" :nil :211];
        _View_Appeal.hidden=NO;
        
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        
    }
    else if(selectBtnTag.tag==123)
    {
        //  [self selectBtncolor_Action:@"123" :nil :212];
    }
    
}


//otw select,deselect and reset values
-(void)otwSelectAndDeselect{
    
    //    NSString *otw;
    //
    //    AppealRecord *objRtwRecord = (AppealRecord*)[_otwRtwArray objectAtIndex:0];
    //    otw = objRtwRecord.MetaSubCode;
    //
    
    if ([self.ballEventRecord.objAtworotw isEqual: @"MSC148"]){
        
        // _btn_OTW.selected = YES;
        
        _view_otw.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        self.ballEventRecord.objAtworotw = nil;
        
        
    }else{
        _view_otw.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        _view_rtw.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        self.ballEventRecord.objAtworotw = @"MSC148";
        
    }
    
    
    
}

//rtw select,deselect and reset values
-(void)rtwSelectAndDeselect{
    if ([self.ballEventRecord.objAtworotw isEqual: @"MSC149"]){
        
        // _btn_OTW.selected = YES;
        
        _view_rtw.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        self.ballEventRecord.objAtworotw = nil;
        
        
    }else{
        _view_rtw.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        _view_otw.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        self.ballEventRecord.objAtworotw = @"MSC149";
        
    }
    
    
}



-(void)RemarkMethode
{
    UIView *objcommonRemarkview=[[UIView alloc]initWithFrame:CGRectMake(self.Allvaluedisplayview.frame.origin.x-110,self.Allvaluedisplayview.frame.origin.y+50, self.Allvaluedisplayview.frame.size.width-100, 200)];
    [objcommonRemarkview setBackgroundColor:[UIColor grayColor]];
    UITextView *txt_Remark=[[UITextView alloc]initWithFrame:CGRectMake(objcommonRemarkview.frame.origin.x-30,objcommonRemarkview.frame.origin.y-110, objcommonRemarkview.frame.size.width-40,120)];
    [txt_Remark setBackgroundColor:[UIColor whiteColor]];
    
    [objcommonRemarkview addSubview:txt_Remark];
    
    [self.Allvaluedisplayview addSubview:objcommonRemarkview];
    
    
    
    UIButton *btn_save=[[UIButton alloc]initWithFrame:CGRectMake(objcommonRemarkview.frame.origin.x-10,objcommonRemarkview.frame.size.height-50,50,50)];
    //[btn_save setBackgroundColor:[UIColor whiteColor]];
    [btn_save setTitle:@"Save" forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(didClickRemarkSave_Action:) forControlEvents:UIControlEventTouchUpInside];
    [objcommonRemarkview addSubview:btn_save];
    
    UIButton *btn_Cancel=[[UIButton alloc]initWithFrame:CGRectMake(objcommonRemarkview.frame.size.width-90,objcommonRemarkview.frame.size.height-50,60,50)];
    [btn_Cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    //[btn_Cancel setBackgroundColor:[UIColor whiteColor]];
    [btn_Cancel addTarget:self action:@selector(didClickRemarkCancel_Action:) forControlEvents:UIControlEventTouchUpInside];
    [objcommonRemarkview addSubview:btn_Cancel];
     btn_Cancel.userInteractionEnabled=YES;
    
}

-(IBAction)didClickRemarkSave_Action:(id)sender
{
    
}
-(IBAction)didClickRemarkCancel_Action:(id)sender
{
 
    [[self.view viewWithTag:120] setHidden:YES];
}

-(void)selectBtncolor_Action:(NSString*)select_Btntag :(UIButton *)select_BtnName :(NSInteger)selectview
{
    if(select_BtnName!= 0)
    {
        for (id obj in self.leftsideview.subviews) {
            
            NSString *classStr = NSStringFromClass([obj class]);
            
            if ([classStr isEqualToString:@"UIButton"]) {
                UIButton *button = (UIButton*)obj;
                NSLog(@"tag=%ld",(long)button.tag);
                button.backgroundColor=[UIColor blackColor];
                if(button.tag== select_BtnName.tag)
                {
                    
                    if(isSelectleftview==NO)
                    {
                        for (id obj in self.Rightsideview.subviews) {
                            
                            NSString *classStr = NSStringFromClass([obj class]);
                            
                            if ([classStr isEqualToString:@"UIView"]) {
                                UIView *button = (UIView*)obj;
                                NSLog(@"tag=%ld",(long)button.tag);
                                button.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
                            }
                        }
                        
                    }
                    isSelectleftview=YES;
                    button.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
                    
                }
            }
        }
        
    }
    else{
        for (id obj in self.Rightsideview.subviews) {
            
            NSString *classStr = NSStringFromClass([obj class]);
            
            if ([classStr isEqualToString:@"UIView"]) {
                UIView *button = (UIView*)obj;
                NSLog(@"tag=%ld",(long)button.tag);
                button.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
                if(button.tag== selectview)
                {
                    
                    if(isSelectleftview==YES)
                    {
                        for (id obj in self.leftsideview.subviews) {
                            
                            NSString *classStr = NSStringFromClass([obj class]);
                            
                            if ([classStr isEqualToString:@"UIButton"]) {
                                UIButton *button = (UIButton*)obj;
                                NSLog(@"tag=%ld",(long)button.tag);
                                button.backgroundColor=[UIColor blackColor];
                            }
                        }
                        
                    }
                    isSelectleftview=NO;
                    
                    button.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
                }
                
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Sathish

-(void) resetBallEventObject{
    self.ballEventRecord = [[BallEventRecord alloc] init];
    self.ballEventRecord.objIsFour = 0;
    self.ballEventRecord.objIssix = 0;
    self.ballEventRecord.objRuns = 0;
    
    
    self.ballEventRecord.objByes = 0;
    self.ballEventRecord.objLegByes = 0;
    self.ballEventRecord.objWide = 0;
    self.ballEventRecord.objNoball = 0;
    self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:1];
    
    
    self.ballEventRecord.objOverthrow = 0;
    self.ballEventRecord.objTotalruns = 0;
    self.ballEventRecord.objPenalty = 0;
    self.ballEventRecord.objTotalextras = 0;
    self.ballEventRecord.objGrandtotal = 0;
    
    isMoreRunSelected = NO;
    isExtrasSelected = NO;
    isOverthrowSelected = NO;
}


-(void) resetAllButtonOnEndBall{
    
    //Left buttons
    [self unselectedButtonBg: self.btn_run1];
    [self unselectedButtonBg: self.btn_run2];
    [self unselectedButtonBg: self.btn_run3];
    [self unselectedButtonBg: self.btn_highRun];
    [self unselectedButtonBg: self.btn_B4];
    [self unselectedButtonBg: self.btn_B6];
    [self unselectedButtonBg: self.btn_extras];
    [self unselectedButtonBg: self.btn_wkts];
    [self unselectedButtonBg: self.btn_overthrow];
    [self unselectedButtonBg: self.btn_miscFilter];
    [self unselectedButtonBg: self.btn_pichmap];
    [self unselectedButtonBg: self.btn_wagonwheel];

    //Right buttons
    [self unselectedViewBg: self.view_otw];
    [self unselectedViewBg: self.view_rtw];
    [self unselectedViewBg: self.view_spin];
    [self unselectedViewBg: self.view_fast];
    [self unselectedViewBg: self.view_aggressive];
    [self unselectedViewBg: self.view_defensive];
    [self unselectedViewBg: self.view_fielding_factor];
    [self unselectedViewBg: self.view_Rbw];
    //[self unselectedViewBg: self.view_remark]; need to set reference
    //[self unselectedViewBg: self.view_edit];
    //[self unselectedViewBg: self.View_Appeal);
    //[self unselectedViewBg: self.view_lastinstance];
    
  }






//Set to normal background for runs button
-(void) resetRunsBoundriesView{
    [self unselectedButtonBg: self.btn_run1];
    [self unselectedButtonBg: self.btn_run2];
    [self unselectedButtonBg: self.btn_run3];
    [self unselectedButtonBg: self.btn_B4];
    
    if(!isMoreRunSelected && (self.ballEventRecord.objLegByes.integerValue==1 || self.ballEventRecord.objWide.integerValue==1 || self.ballEventRecord.objByes.integerValue==1)){//Check for LB,WD,B selected
        [self disableButtonBg: self.btn_B6];
    }else{
        [self unselectedButtonBg: self.btn_B6];
    }
    
    
}


- (IBAction)appeal_btn:(id)sender {
    if(isEnableTbl==YES)
    {
        AppealSystemArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchAppealSystemArray =[DBManager AppealSystemRetrieveEventData];
        for(int i=0; i < [FetchAppealSystemArray count]; i++)
        {
            
            objAppealSystemEventRecord=(AppealSystemRecords*)[FetchAppealSystemArray objectAtIndex:i];
            
            [AppealSystemArray addObject:objAppealSystemEventRecord];
            
            
        }
        
        
        [self.table_AppealSystem reloadData];
        self.table_AppealSystem.hidden=NO;
        isEnableTbl=NO;
    }
    
    
}
- (IBAction)btn_AppealComponent:(id)sender {
    
    if(isEnableTbl==YES)
    {
        AppealComponentArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchAppealComponentArray =[DBManager AppealComponentRetrieveEventData];
        for(int i=0; i < [FetchAppealComponentArray count]; i++)
        {
            
            objAppealComponentEventRecord=(AppealComponentRecord*)[FetchAppealComponentArray objectAtIndex:i];
            
            [AppealComponentArray addObject:objAppealComponentEventRecord];
            
            
        }
        
        
        [self.table_AppealComponent reloadData];
        self.table_AppealComponent.hidden=NO;
        isEnableTbl=NO;
    }
}
- (IBAction)btn_umpireName:(id)sender {
    
    
    if(isEnableTbl==YES)
    {
        AppealUmpireArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchAppealumpireArray =[DBManager AppealUmpireRetrieveEventData:_competitionCode :_matchCode];
        for(int i=0; i < [FetchAppealumpireArray count]; i++)
        {
            
            objAppealUmpireEventRecord=(AppealUmpireRecord*)[FetchAppealumpireArray objectAtIndex:i];
            
            [AppealUmpireArray addObject:objAppealUmpireEventRecord];
            
            
        }
        
        
        [self.tanle_umpirename reloadData];
        self.tanle_umpirename.hidden=NO;
        isEnableTbl=NO;
    }
    
}
- (IBAction)btn_batsmen:(id)sender {
    if (self.table_BatsmenName.hidden ==YES) {
        
        self.table_BatsmenName.hidden=NO;
        
    }
    else
        self.table_BatsmenName.hidden=YES;
}

//Reset boundries and runs values
-(void) resetRunsBoundriesValue{
    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
    self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:0];
}


-(void) calculateRuns:(long) tagNumber{
    
    switch ((int)tagNumber) {
        case 100: // One, Four
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objRuns.integerValue == 1){// If runs has one
                [self resetRunsBoundriesValue];
                
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:4];
                    [self selectedButtonBg: self.btn_run1];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run1];
                }
                
            }else if(self.ballEventRecord.objRuns.integerValue == 4){// If runs has four
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:1];
                    [self selectedButtonBg: self.btn_run1];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run1];
                }
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?4:1];
                [self selectedButtonBg: self.btn_run1];
            }
            
            break;
        case 101: // Two, Five
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objRuns.integerValue == 2){// If runs has two
                [self resetRunsBoundriesValue];
                
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:5];
                    [self selectedButtonBg: self.btn_run2];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run2];
                }
                
            }else if(self.ballEventRecord.objRuns.integerValue == 5){// If runs has five
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:2];
                    [self selectedButtonBg: self.btn_run2];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run2];
                }
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?5:2];
                [self selectedButtonBg: self.btn_run2];
                
            }
            
            break;
        case 102: // Three, Six
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objRuns.integerValue == 3){// If runs has three
                [self resetRunsBoundriesValue];
                
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:6];
                    [self selectedButtonBg: self.btn_run3];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run3];
                }
                
            }else if(self.ballEventRecord.objRuns.integerValue == 6){// If runs has six
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:3];
                    [self selectedButtonBg: self.btn_run3];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run3];
                }
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?6:3];
                [self selectedButtonBg: self.btn_run3];
                
            }
            
            break;
        case 103: // More runs
            [self didSelectMoreRuns];
            break;
        case 104: // B4, Seven
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objIsFour.integerValue == 1){// If isFour has one
                [self resetRunsBoundriesValue];
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B4];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:7];
                    [self selectedButtonBg: self.btn_B4];
                }
                
            } else if( self.ballEventRecord.objRuns.integerValue == 7){// If runs has seven
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B4];
                }else{
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:1];
                    [self selectedButtonBg: self.btn_B4];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
            }
            else{//Other run selected
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:7];
                }else{
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:1];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                    
                }
                
                [self selectedButtonBg: self.btn_B4];
                
            }
            
            break;
        case 105: // B6, Eight
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            
            if(self.ballEventRecord.objIssix.integerValue == 1){// If isSix has one
                [self resetRunsBoundriesValue];
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B6];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:8];
                    [self selectedButtonBg: self.btn_B6];
                }
                
            } else if( self.ballEventRecord.objRuns.integerValue == 8){// If runs has eight
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B6];
                }else{
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:1];
                    [self selectedButtonBg: self.btn_B6];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
            }
            else{//Other run selected
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:8];
                }else{
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:1];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
                
                [self selectedButtonBg: self.btn_B6];
                
            }
            
            break;
        default:
            break;
    }
    
}

-(void) resetOverthrowViewAndValue{
    if(self.ballEventRecord.objIssix.integerValue == 1 || self.ballEventRecord.objIsFour.integerValue == 1){
        [self unselectedButtonBg: self.btn_overthrow];
        self.btn_overthrow.userInteractionEnabled=YES;
        self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
    }
}


   
    //Selected background for view
    -(void) selectedViewBg:(UIView *) view{
        view.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected

    }
    
    //Normal background for view
    -(void) unselectedViewBg:(UIView *) view{
        
       view.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
    }


//Selected background for button
-(void) selectedButtonBg:(UIButton *) select_btn{
    select_btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
}

//Normal background for button
-(void) unselectedButtonBg:(UIButton *) select_btn{
    
    select_btn.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
}

//Disable background for button
-(void) disableButtonBg:(UIButton *) select_btn{
    select_btn.backgroundColor=[UIColor colorWithRed:(139/255.0f) green:(137/255.0f) blue:(137/255.0f) alpha:1.0f];
}

//-(void) didSelectOTWRTW
//{
//    [self unselectedButtonBg:self.btn_OTW];
//    [self unselectedButtonBg:self.btn_RTW];
//
//    if(!isOTWselected)
//    {
//        [self selectedButtonBg:self.btn_OTW];
//        isOTWselected = YES;
//
//    }
//}


//Toggle for more runs
-(void) didSelectMoreRuns
{
    
    //[self resetRunsBoundriesView];
    [self unselectedButtonBg: self.btn_run1];
    [self unselectedButtonBg: self.btn_run2];
    [self unselectedButtonBg: self.btn_run3];
    [self unselectedButtonBg: self.btn_B4];
    [self unselectedButtonBg: self.btn_B6];
    
    
    if(!isMoreRunSelected)//Not selected state
    {
        //Set down toggle image
        [self.btn_highRun setImage:[UIImage imageNamed:@"dropDown"] forState:UIControlStateNormal];
        [self selectedButtonBg: self.btn_highRun];
        isMoreRunSelected = YES;
        
        //Set run button name
        [self.btn_run1 setTitle:@"4" forState:UIControlStateNormal];
        [self.btn_run2 setTitle:@"5" forState:UIControlStateNormal];
        [self.btn_run3 setTitle:@"6" forState:UIControlStateNormal];
        [self.btn_B4 setTitle:@"7" forState:UIControlStateNormal];
        [self.btn_B6 setTitle:@"8" forState:UIControlStateNormal];
        
        //Set run button highlight
        if(self.ballEventRecord.objRuns.integerValue == 4){
            [self selectedButtonBg: self.btn_run1];
        }else if(self.ballEventRecord.objRuns.integerValue == 5){
            [self selectedButtonBg: self.btn_run2];
        }else if(self.ballEventRecord.objRuns.integerValue == 6){
            [self selectedButtonBg: self.btn_run3];
        }else if(self.ballEventRecord.objRuns.integerValue == 7){
            [self selectedButtonBg: self.btn_B4];
        }else if(self.ballEventRecord.objRuns.integerValue == 8){
            [self selectedButtonBg: self.btn_B6];
        }
        
        self.btn_B6.userInteractionEnabled=YES;
    }
    else{//Selected state
        
        //Set up toggle image
        [self.btn_highRun setImage:[UIImage imageNamed:@"moreRuns"] forState:UIControlStateNormal];
        [self unselectedButtonBg: self.btn_highRun];
        isMoreRunSelected = NO;
        
        //Set run button values
        [self.btn_run1 setTitle:@"1" forState:UIControlStateNormal];
        [self.btn_run2 setTitle:@"2" forState:UIControlStateNormal];
        [self.btn_run3 setTitle:@"3" forState:UIControlStateNormal];
        [self.btn_B4 setTitle:@"B4" forState:UIControlStateNormal];
        [self.btn_B6 setTitle:@"B6" forState:UIControlStateNormal];
        
        //Set run button highlight
        if(self.ballEventRecord.objRuns.integerValue == 1){
            [self selectedButtonBg: self.btn_run1];
        }else if(self.ballEventRecord.objRuns.integerValue == 2){
            [self selectedButtonBg: self.btn_run2];
        }else if(self.ballEventRecord.objRuns.integerValue == 3){
            [self selectedButtonBg: self.btn_run3];
        }else if(self.ballEventRecord.objIsFour.integerValue == 1){
            [self selectedButtonBg: self.btn_B4];
        }
        
        if(self.ballEventRecord.objIssix.integerValue == 1){
            [self selectedButtonBg: self.btn_B6];
        }else{
            if(self.ballEventRecord.objLegByes.integerValue==1 || self.ballEventRecord.objWide.integerValue==1 || self.ballEventRecord.objByes.integerValue==1){//Check for LB,WD,B selected
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;
            }
        }
        
        
    }
}

// Fetch extras list based on perviously selected option
-(NSMutableArray*) getExtrasOptionArray{
    
    NSMutableArray *extrasOptionArray;
    
    if(self.ballEventRecord.objWide.integerValue == 1){//if wide enable
        extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide", nil];
    }else if(self.ballEventRecord.objIssix.integerValue == 1){//if B6 enable
        extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall", nil];
    }else{// Default
        extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
    }
    
    return extrasOptionArray;
}

//Extras popup screen
-(void) extrasPopupMenu:(UIButton *)btn_selection
{
    
    if(isExtrasSelected){//Already open state
        
        
        if(self.ballEventRecord.objNoball.integerValue ==0 && self.ballEventRecord.objWide.integerValue ==0 && self.ballEventRecord.objByes.integerValue ==0 && self.ballEventRecord.objLegByes.integerValue ==0){//Nothing selected
            
            [self unselectedButtonBg:btn_selection];
        }else{//If any one selected
            
            [self selectedButtonBg:btn_selection];
        }
        
        if(extrasTableView!=nil){
            [extrasTableView removeFromSuperview];
        }
        
        
        isExtrasSelected = NO;
        
    }else{ // Not open state
        //Extras option array
        self.extrasOptionArray=[self getExtrasOptionArray];
        
        //Table view
        extrasTableView=[[UITableView alloc]initWithFrame:CGRectMake(btn_selection.frame.origin.x+btn_selection.frame.size.width+10, btn_selection.frame.origin.y-50,100,200)];
        extrasTableView.backgroundColor=[UIColor whiteColor];
        extrasTableView.allowsMultipleSelection = YES;
        extrasTableView.dataSource = self;
        extrasTableView.delegate = self;
        [self.commonleftrightview addSubview:extrasTableView];
        [extrasTableView reloadData];
        
        //Set highlight for selected options
        if(self.ballEventRecord.objNoball.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if(self.ballEventRecord.objWide.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if(self.ballEventRecord.objByes.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if(self.ballEventRecord.objLegByes.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //  [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //         indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //
        
        [self selectedButtonBg:btn_selection];
        isExtrasSelected = YES;
    }
    
}

//Shows popup for over throw
-(void) overThrowPopupMenu:(UIButton *)btn_selection
{
    
    if(isOverthrowSelected){// Already open state
        if(overThrowTableView!=nil){
            [overThrowTableView removeFromSuperview];
        }
        
        if(self.ballEventRecord.objOverthrow.integerValue!=0){
            [self selectedButtonBg:btn_selection];
        }else{
            [self unselectedButtonBg:btn_selection];
        }
        
        isOverthrowSelected = NO;
        
    }else{ // Not open state
        //Overthrow option array
        self.overThrowOptionArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
        
        //Table view
        overThrowTableView=[[UITableView alloc]initWithFrame:CGRectMake(btn_selection.frame.origin.x+btn_selection.frame.size.width+10, btn_selection.frame.origin.y-50,100,200)];
        overThrowTableView.backgroundColor=[UIColor whiteColor];
        overThrowTableView.dataSource = self;
        overThrowTableView.delegate = self;
        [self.commonleftrightview addSubview:overThrowTableView];
        [overThrowTableView reloadData];
        
        if(self.ballEventRecord.objOverthrow!=0){
            NSInteger position = [self.overThrowOptionArray indexOfObject:self.ballEventRecord.objOverthrow];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [overThrowTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [overThrowTableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
        }
        
        //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //  [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //         indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //
        
        [self selectedButtonBg:btn_selection];
        isOverthrowSelected = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    _view_table_select.hidden=NO;
    
    
    if (tableView == self.table_AppealSystem)
    {
        
        
        AppealSystemSelectionArray=[[NSMutableArray alloc]init];
        objAppealSystemEventRecord=(AppealSystemRecords*)[AppealSystemArray objectAtIndex:indexPath.row];
        
        self.lbl_appealsystem.text =objAppealSystemEventRecord.AppealSystemMetaSubCodeDescription;
        // selectTeam=self.Wonby_lbl.text;
        AppealSystemSelectCode=objAppealSystemEventRecord.AppealSystemMetaSubCode;
        [AppealSystemSelectionArray addObject:objAppealSystemEventRecord];
        
        self.table_AppealSystem.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    
    if (tableView == self.table_AppealComponent)
    {
        
        
        AppealComponentSelectionArray=[[NSMutableArray alloc]init];
        objAppealComponentEventRecord=(AppealComponentRecord*)[AppealComponentArray objectAtIndex:indexPath.row];
        
        self.lbl_appealComponent.text =objAppealComponentEventRecord.AppealComponentMetaSubCodeDescription;
        // selectTeam=self.Wonby_lbl.text;
        AppealComponentSelectCode=objAppealComponentEventRecord.AppealComponentMetaSubCode;
        [AppealComponentSelectionArray addObject:objAppealComponentEventRecord];
        
        self.table_AppealComponent.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    if (tableView == self.tanle_umpirename)
    {
        
        
        AppealUmpireSelectionArray=[[NSMutableArray alloc]init];
        objAppealUmpireEventRecord=(AppealUmpireRecord*)[AppealUmpireArray objectAtIndex:indexPath.row];
        
        self.lbl_umpirename.text =objAppealUmpireEventRecord.AppealUmpireName1;
        self.lbl_umpirename.text =objAppealUmpireEventRecord.AppealUmpireName2;
        // selectTeam=self.Wonby_lbl.text;
        AppealUmpireSelectCode=objAppealUmpireEventRecord.AppealUmpireCode1;
        AppealUmpireSelectCode=objAppealUmpireEventRecord.AppealUmpireCode2;
        [AppealUmpireSelectionArray addObject:objAppealUmpireEventRecord];
        
        self.tanle_umpirename.hidden=YES;
        isEnableTbl=YES;
    }
    
    if (tableView == self.table_BatsmenName)
    {
        
        
        AppealUmpireSelectionArray=[[NSMutableArray alloc]init];
        // objAppealComponentEventRecord=(AppealComponentRecord*)[AppealBatsmenArray objectAtIndex:indexPath.row];
        
        self.lbl_batsmen.text =[AppealBatsmenArray objectAtIndex:indexPath.row];
        // selectTeam=self.Wonby_lbl.text;
        AppealComponentSelectCode=@"PYCOOOO050";
        //   [AppealComponentSelectionArray addObject:objAppealComponentEventRecord];
        
        self.table_BatsmenName.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    
    //wicket type
    if(isWicketSelected && wicketOption == 1)
    {
        selectedwickettype = [self.WicketTypeArray objectAtIndex:indexPath.row];
        if([selectedwickettype.metasubcode isEqualToString:@"MSC097"]|| [selectedwickettype.metasubcode isEqualToString:@"MSC106"])
        {
            self.StrikerandNonStrikerArray=[[NSMutableArray alloc]initWithObjects:@"ABHINAV MUKHUND",@"APARAJITH BABA", nil];
            isWicketSelected = YES;
            wicketOption = 2;
            
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = NO;
            
            [self.tbl_fastBowl reloadData];
            
            if(selectedStrikernonstriker!=nil){
                NSInteger position = [self.StrikerandNonStrikerArray indexOfObject:selectedStrikernonstriker];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
                [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
            }
 
        } else{
            self.WicketEventArray=[[NSMutableArray alloc]initWithObjects:@"Typical",@"Strong",@"Medium", nil];
            
            
            isWicketSelected = YES;
            wicketOption = 3;
            
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = NO;
            
            [self.tbl_fastBowl reloadData];
            
            if(selectedWicketEvent!=nil){
                NSInteger position = [self.WicketEventArray indexOfObject:selectedWicketEvent];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
                [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
            }

            
        }
    
        
    }else if(isWicketSelected && wicketOption == 2)
    {
        selectedStrikernonstriker = [self.StrikerandNonStrikerArray objectAtIndex:indexPath.row];
        
        self.WicketEventArray=[[NSMutableArray alloc]initWithObjects:@"Typical",@"Strong",@"Medium", nil];
        isWicketSelected = YES;
        wicketOption = 3;
        
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        
        [self.tbl_fastBowl reloadData];
        
        if(selectedWicketEvent!=nil){
            NSInteger position = [self.WicketEventArray indexOfObject:selectedWicketEvent];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }
        
        }else if(isWicketSelected && wicketOption == 3){
        selectedWicketEvent = [self.WicketEventArray objectAtIndex:indexPath.row];
            if([selectedwickettype.metasubcode isEqualToString:@"MSC097"]|| [selectedwickettype.metasubcode isEqualToString:@"MSC095"])
            {
        _PlayerlistArray=[[NSMutableArray alloc]init];
        _PlayerlistArray =[DBManager RetrievePlayerData];
        
        isWicketSelected = YES;
        wicketOption = 4;
        
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        
        [self.tbl_fastBowl reloadData];
        
        if(selectedwicketBowlerlist!=nil){
            
            int indx=0;
            int selectePosition = -1;
            for (BowlerEvent *record in _PlayerlistArray)
            {
                bool chk = ([[record BowlerCode] isEqualToString:selectedwicketBowlerlist.BowlerCode]);
                if (chk)
                {
                    selectePosition = indx;
                    break;
                }
                indx ++;
            }
            
            //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
            [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }
            }else{
                wicketOption = 0;
                self.view_bowlType.hidden = YES;
                self.view_fastBowl.hidden = YES;
                self.view_aggressiveShot.hidden = YES;
                self.view_defensive.hidden =YES;
                
                isWicketSelected = NO;
            }
           
    }else if(isWicketSelected && wicketOption == 4)
    {
        
        selectedwicketBowlerlist = [self.PlayerlistArray objectAtIndex:indexPath.row];
        
        wicketOption = 0;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden =YES;
        
        isWicketSelected = NO;
    }
    
    

   
    
    //Fielding Factor
    if(isFieldingSelected && fieldingOption == 1)
    {
        selectedfieldFactor = [self.fieldingfactorArray objectAtIndex:indexPath.row];
        
        _fieldingPlayerArray=[[NSMutableArray alloc]init];
        _fieldingPlayerArray =[DBManager RetrieveFieldingPlayerData];
        
        isFieldingSelected = YES;
        fieldingOption = 2;
        
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        
        [self.tbl_fastBowl reloadData];
        
        if(selectedfieldPlayer!=nil){
            
            int indx=0;
            int selectePosition = -1;
            for (BowlerEvent *record in _fieldingPlayerArray)
            {
                bool chk = ([[record BowlerCode] isEqualToString:selectedfieldPlayer.BowlerCode]);
                if (chk)
                {
                    selectePosition = indx;
                    break;
                }
                indx ++;
            }
            
            //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
            [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }
        
        
    }else if(isFieldingSelected && fieldingOption == 2)
    {
        selectedfieldPlayer = [self.fieldingPlayerArray objectAtIndex:indexPath.row];
        
        
        self.nrsArray=[[NSMutableArray alloc]initWithObjects:@"-6",@"-5",@"-4",@"-3",@"-2",@"-1",@"0",@"1",@"2",@"3",@"4",@"5",@"6", nil];
        isFieldingSelected = YES;
        fieldingOption = 3;
        
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        
        [self.tbl_fastBowl reloadData];
        
        if(selectedNRS!=nil){
            NSInteger position = [self.nrsArray indexOfObject:selectedNRS];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }
    }else if(isFieldingSelected && fieldingOption == 3)
    {
        
        selectedNRS = [self.nrsArray objectAtIndex:indexPath.row];
        
        fieldingOption = 0;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden =YES;
        
        isFieldingSelected = NO;
    }
    
    _view_table_select.hidden=NO;
    NSLog(@"Index Path %d",indexPath.row);
    
    if(tableView == extrasTableView){//Extras table view
        
        if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"NoBall"]){//No ball
            
            
            //Wide
            self.ballEventRecord.objWide = [NSNumber numberWithInt:0];
            // NSIndexPath *wideIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            //[extrasTableView deselectRowAtIndexPath:wideIndexPath animated:NO];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            //B6
            if(self.ballEventRecord.objIssix.integerValue == 0){//Six un selected
                
                if(!isMoreRunSelected){//Normal state
                    
                    if(self.ballEventRecord.objLegByes.integerValue==1 || self.ballEventRecord.objWide.integerValue==1 || self.ballEventRecord.objByes.integerValue==1){//Check for LB,WD,B selected
                        [self disableButtonBg:self.btn_B6];
                        self.btn_B6.userInteractionEnabled=NO;
                    }
                    else{
                        [self unselectedButtonBg:self.btn_B6];
                        self.btn_B6.userInteractionEnabled=YES;
                        
                    }
                }
                
            }
            
            //Noball
            NSIndexPath *noballIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [extrasTableView selectRowAtIndexPath:noballIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.ballEventRecord.objNoball = [NSNumber numberWithInt:1];
            
            //Is Legal ball
            self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:0];
            
            //Byes Select
            if(self.ballEventRecord.objByes.integerValue !=0){
                NSIndexPath *byesIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [extrasTableView selectRowAtIndexPath:byesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            //Legbyes Select
            if(self.ballEventRecord.objLegByes.integerValue !=0){
                NSIndexPath *legbyesIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [extrasTableView selectRowAtIndexPath:legbyesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Wide"]){//Wide
            
            //B6
            self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
            if(!isMoreRunSelected){
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;
            }
            //Legbyes
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];
            
            //Byes
            self.ballEventRecord.objByes = [NSNumber numberWithInt:0];
            
            //Noball
            self.ballEventRecord.objNoball = [NSNumber numberWithInt:0];
            
            //Wide Value
            self.ballEventRecord.objWide = [NSNumber numberWithInt:1];
            
            //is Legal ball
            self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:0];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            //Wide Selector
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Byes"]){//Byes
            //B6
            self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
            if(!isMoreRunSelected){
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;
            }
            //Legbyes
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];
            NSIndexPath *legbyesIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [extrasTableView deselectRowAtIndexPath:legbyesIndexPath animated:NO];
            
            //Byes
            self.ballEventRecord.objByes = [NSNumber numberWithInt:1];
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"LegByes"]){//Legbyes
            //B6
            self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
            if(!isMoreRunSelected){
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;
                
            }
            
            //Byes
            self.ballEventRecord.objByes = [NSNumber numberWithInt:0];
            NSIndexPath *byesIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [extrasTableView deselectRowAtIndexPath:byesIndexPath animated:NO];
            
            //Legbyes
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:1];
            
            
        }
    }else if(tableView == overThrowTableView){//Over throw table view
        if( self.ballEventRecord.objOverthrow != [self.overThrowOptionArray objectAtIndex:indexPath.row]){
            self.ballEventRecord.objOverthrow = [self.overThrowOptionArray objectAtIndex:indexPath.row];
            [overThrowTableView removeFromSuperview];
            isOverthrowSelected = NO;
            
            if(self.ballEventRecord.objOverthrow!=0){
                [self selectedButtonBg:self.btn_overthrow];
                //self.btn_RBW.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:0.5f];
            }else{
                [self unselectedButtonBg:self.btn_overthrow];
                // self.btn_RBW.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:0.5f];
            }
        }else{
            self.ballEventRecord.objOverthrow = [NSNumber numberWithInteger:0];
            [overThrowTableView removeFromSuperview];
            [self unselectedButtonBg:self.btn_overthrow];
            // self.btn_RBW.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:0.5f];
            
            isOverthrowSelected = NO;
        }
        
    } else if(rbwTableview == tableView){
        
        if( self.ballEventRecord.objRbw != [self.rbwOptionArray objectAtIndex:indexPath.row]){
            self.ballEventRecord.objRbw = [self.rbwOptionArray objectAtIndex:indexPath.row];
            [rbwTableview removeFromSuperview];
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            isRBWSelected = NO;
            
            if(self.ballEventRecord.objRbw!=0){
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            }else{
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            }
        }else{
            self.ballEventRecord.objRbw = [NSNumber numberWithInteger:0];
            [rbwTableview removeFromSuperview];
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            
            isRBWSelected = NO;
        }
        
    }else if(miscFiltersTableview == tableView){
        
        if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Uncomfort"]){
            self.ballEventRecord.objIsuncomfort = [NSNumber numberWithInt:1];
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Beaten"]){
            self.ballEventRecord.objIsbeaten = [NSNumber numberWithInt:1];
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Release Shot"]){
            self.ballEventRecord.objIsreleaseshot = [NSNumber numberWithInt:1];
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"WTB"]){
            self.ballEventRecord.objIswtb = [NSNumber numberWithInt:1];
        }
    }else if(tbl_bowlType == tableView){
        
        isSpinSelected = YES;
        isFastSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.bowlTypeArray objectAtIndex:indexPath.row];
        self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        
        //        if([bowlAndShortTypeRecord.BowlTypeCode  isEqualToString:objBalleventRecord.objBowltype])
        //        {
        //            objBalleventRecord.objBowltype = nil;
        //            [tbl_bowlType reloadData];
        //        }
        
        
    }else if (tbl_fastBowl == tableView){
        
        isFastSelected = YES;
        isSpinSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.fastBowlTypeArray objectAtIndex:indexPath.row];
        self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        
        
    }else if (tbl_aggressiveShot == tableView){
        isAggressiveSelected = YES;
        isDefensiveSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.aggressiveShotTypeArray objectAtIndex:indexPath.row];
        
        self.ballEventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
    }else if (_tbl_defensive == tableView){
        isDefensiveSelected = YES;
        isAggressiveSelected = NO;
        
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.defensiveShotTypeArray objectAtIndex:indexPath.row];
        
        self.ballEventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
        
    }else if(tableView == currentBowlersTableView){
        
        BowlerEvent *bowlEvent = [fetchSEPageLoadRecord.getBowlingTeamPlayers objectAtIndex:indexPath.row];
        [DBManager updateBOWLERCODE:self.competitionCode MATCHCODE:self.matchCode INNINGSNO:fetchSEPageLoadRecord.INNINGSNO BOWLERCODE:bowlEvent.BowlerCode];
        
        [currentBowlersTableView removeFromSuperview];
        isBowlerOpen = NO;
        isNONStrickerOpen = NO;
        isStrickerOpen = NO;
        [self reloadBowlerTeamBatsmanDetails];
        
    }else if(tableView == nonstrickerTableView){
        SelectPlayerRecord *selectPlayer = [nonStrickerList objectAtIndex:indexPath.row];
        
        [DBManager updateNONSTRIKERCODE:self.competitionCode MATCHCODE:self.matchCode INNINGSNO:fetchSEPageLoadRecord.INNINGSNO NONSTRIKERCODE:selectPlayer.playerCode];
        isBowlerOpen = NO;
        isNONStrickerOpen = NO;
        isStrickerOpen = NO;
        [nonstrickerTableView removeFromSuperview];
        [self reloadBowlerTeamBatsmanDetails];
        
    }else if(tableView == strickerTableView){
        
        SelectPlayerRecord *selectPlayer = [strickerList objectAtIndex:indexPath.row];
        
        [DBManager updateStricker:self.competitionCode MATCHCODE:self.matchCode INNINGSNO:fetchSEPageLoadRecord.INNINGSNO STRIKERCODE:selectPlayer.playerCode];
        isBowlerOpen = NO;
        isNONStrickerOpen = NO;
        isStrickerOpen = NO;
        [strickerTableView removeFromSuperview];
        [self reloadBowlerTeamBatsmanDetails];
        
    }
    
    
    
    
    NSLog(@"Index Path %d",indexPath.row);
    
    for (NSIndexPath *indexPath in rbwTableview.indexPathsForSelectedRows) {
        NSLog(@"Loop %d",indexPath.row);
    }
    //    for (NSIndexPath *indexPath in extrasTableView.indexPathsForSelectedRows) {
    //        NSLog(@"Loop %d",indexPath.row);
    //    }
    //  rowcount = count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"D Index Path %d",indexPath.row);
    if(tableView == extrasTableView){//Extras Table view
        if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"NoBall"]){//No ball
            
            //Noball
            self.ballEventRecord.objNoball = [NSNumber numberWithInt:0];
            
            //Legalball
            self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:1];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            
            //            if(self.ballEventRecord.objIssix.integerValue == 0){
            //                [self unselectedButtonBg:self.btn_B6];
            //                self.btn_B6.userInteractionEnabled=YES;
            //            }
            
            
            //Byes Select
            if(self.ballEventRecord.objByes.integerValue !=0){
                NSIndexPath *byesIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [extrasTableView selectRowAtIndexPath:byesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            //Legbyes Select
            if(self.ballEventRecord.objLegByes.integerValue !=0){
                NSIndexPath *legbyesIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [extrasTableView selectRowAtIndexPath:legbyesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Wide"]){//Wide
            
            
            //B6
            self.btn_B6.userInteractionEnabled=YES;
            if(!isMoreRunSelected){
                [self unselectedButtonBg:self.btn_B6];
            }
            
            //Wide
            self.ballEventRecord.objWide = [NSNumber numberWithInt:0];
            //Is Legal ball
            self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:1];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Byes"]){//Byes
            
            //B6
            [self unselectedButtonBg:self.btn_B6];
            self.btn_B6.userInteractionEnabled=YES;
            
            //Wide
            self.ballEventRecord.objByes = [NSNumber numberWithInt:0];
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"LegByes"]){
            
            //B6
            [self unselectedButtonBg:self.btn_B6];
            self.btn_B6.userInteractionEnabled=YES;
            
            //Wide
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];
            
        }
    }else  if(rbwTableview == tableView){
        
    }else if(miscFiltersTableview == tableView){
        if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Uncomfort"]){
            self.ballEventRecord.objIsuncomfort = [NSNumber numberWithInt:0];
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Beaten"]){
            self.ballEventRecord.objIsbeaten = [NSNumber numberWithInt:0];
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Release Shot"]){
            self.ballEventRecord.objIsreleaseshot = [NSNumber numberWithInt:0];
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"WTB"]){
            self.ballEventRecord.objIswtb = [NSNumber numberWithInt:0];
        }
    }
    
    //    for (NSIndexPath *indexPath in extrasTableView.indexPathsForSelectedRows) {
    //        NSLog(@"D Loop %d",indexPath.row);
    //    }
}


-(void) selectExtrasOption{
    
    [extrasTableView reloadData];
    
    if([self.ballEventRecord objNoball].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
    if([self.ballEventRecord objWide].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    if([self.ballEventRecord objLegByes].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
    if([self.ballEventRecord objByes].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
}


-(void) calculateRunsOnEndBall   {
    //Wides and Noball calculation.
    if (self.ballEventRecord.objIslegalball.integerValue == 0)//Illegal ball.
    {
        if (self.ballEventRecord.objWide.integerValue != 0)
        {
            self.ballEventRecord.objWide = [NSNumber numberWithInt: (self.ballEventRecord.objRuns.intValue + self.ballEventRecord.objOverthrow.intValue) + 1];
            self.ballEventRecord.objRuns = 0;
        }
        else if (self.ballEventRecord.objNoball.integerValue != 0)
        {
            if (self.ballEventRecord.objByes.integerValue != 0 || self.ballEventRecord.objLegByes.integerValue != 0)
            {
                
                self.ballEventRecord.objNoball = [NSNumber numberWithInt:1];
                
                self.ballEventRecord.objByes = self.ballEventRecord.objByes.integerValue > 0 ?  [NSNumber numberWithInt: (self.ballEventRecord.objRuns.intValue + self.ballEventRecord.objOverthrow.intValue)] : self.ballEventRecord.objByes;
                
                self.ballEventRecord.objLegByes =  self.ballEventRecord.objLegByes.integerValue>0?
                [NSNumber numberWithInt: self.ballEventRecord.objRuns.intValue+ self.ballEventRecord.objOverthrow.intValue]:
                self.ballEventRecord.objLegByes;
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
            }
            else
            {
                self.ballEventRecord.objNoball = [NSNumber numberWithInt:1];
            }
        }
    }
    else//Legal ball.
    {
        
        if (self.ballEventRecord.objByes.integerValue != 0 || self.ballEventRecord.objLegByes.integerValue != 0)
        {
            
            self.ballEventRecord.objByes = self.ballEventRecord.objByes.integerValue > 0 ?  [NSNumber numberWithInt: self.ballEventRecord.objRuns.intValue + self.ballEventRecord.objOverthrow.intValue] : self.ballEventRecord.objByes;
            
            self.ballEventRecord.objLegByes =  self.ballEventRecord.objLegByes.integerValue>0?
            [NSNumber numberWithInt: self.ballEventRecord.objRuns.intValue+ self.ballEventRecord.objOverthrow.intValue]:
            self.ballEventRecord.objLegByes;
            self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
        }
    }
    
    self.ballEventRecord.objTotalruns =
    (self.ballEventRecord.objRuns.intValue+( self.ballEventRecord.objByes.intValue == 0 &&  self.ballEventRecord.objLegByes.intValue == 0 &&  self.ballEventRecord.objWide.intValue == 0)) ? [NSNumber numberWithInt: self.ballEventRecord.objOverthrow.intValue]: [NSNumber numberWithInt:0];
    //Total runs scored for the particular ball including byes or legbyes.
    
    int totalExtras = 0;
    self.ballEventRecord.objTotalextras = [NSNumber numberWithInt: self.ballEventRecord.objNoball.intValue +self.ballEventRecord.objWide.intValue+self.ballEventRecord.objByes.intValue+self.ballEventRecord.objLegByes.intValue+self.ballEventRecord.objPenalty.intValue];
    /*+ ((Byes > 0 || Legbyes > 0) ? Overthrow : 0)*/;
}




- (IBAction)btn_AppealSave:(id)sender {
    
    // UIColor colorWithRed:84 green:106 blue:126 alpha:0
    NSString *commentText =[NSString stringWithFormat:@"%@",[_comments_txt text]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:AppealSystemSelectCode forKey:@"AppealSystemSelct"];
    [dic setValue:AppealComponentSelectCode forKey:@"AppealComponentSelct"];
    [dic setValue:AppealUmpireSelectCode forKey:@"AppealUmpireSelct"];
    [dic setValue:AppealBatsmenSelectCode forKey:@"AppealBatsmenSelct"];
    [dic setValue:commentText forKey:@"Commenttext"];
}


//-(void)teamLogo{
//    //logo image
//    NSMutableArray *teamCode = [[NSMutableArray alloc]init];
//    
//    [teamCode addObject:@"TEA0000005"];
//    [teamCode addObject:@"TEA0000006"];
//    [teamCode addObject:@"TEA0000008"];
//
//    
//    for(int i=0;i<[teamCode count];i++){
//        
//        [self addImageInAppDocumentLocation:[teamCode objectAtIndex:i]];
//    }
//    
//    
//    
//    NSMutableArray *mTeam = [[NSMutableArray alloc]init];
//    [mTeam addObject:self.matchCode];
//    [mTeam addObject:self.teamAcode];
//    
//    
//    self.selectedTeamFilterArray = [[NSMutableArray alloc]initWithArray: self.selectedTeamArray];
//    
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,self.teamAcode];
//    
//    
//    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
//    UIImage *img;
//    if(isFileExist){
//        img = [UIImage imageWithContentsOfFile:pngFilePath];
//        self.img_firstIngsTeamName.image = img;
//    }else{
//        img  = [UIImage imageNamed: @"no_image.png"];
//        _img_firstIngsTeamName.image = img;
//    }
//    
//    
//    
//    
//    NSFileManager *fileManagerB = [NSFileManager defaultManager];
//    NSString *docDirB = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *pngFilePathB = [NSString stringWithFormat:@"%@/%@.png", docDirB,self.teamBcode];
//    BOOL isFileExistB = [fileManagerB fileExistsAtPath:pngFilePathB];
//    UIImage *imgB;
//    if(isFileExistB){
//        imgB = [UIImage imageWithContentsOfFile:pngFilePathB];
//        _img_secIngsTeamName.image = imgB;
//    }else{
//        imgB  = [UIImage imageNamed: @"no_image.png"];
//        _img_secIngsTeamName.image = imgB;
//    }
//}
//-(void) addImageInAppDocumentLocation:(NSString*) fileName{
//    
//    BOOL success = [self checkFileExist:fileName];
//    
//    if(!success) {//If file not exist
//        
//        UIImage  *newImage = [UIImage imageNamed:fileName];
//        NSData *imageData = UIImagePNGRepresentation(newImage);
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
//        
//        if (![imageData writeToFile:imagePath atomically:NO])
//        {
//            NSLog((@"Failed to cache image data to disk"));
//        }else
//        {
//            NSLog(@"the cachedImagedPath is %@",imagePath);
//        }
//    }
//}
//
////Check given file name exist in document directory
//- (BOOL) checkFileExist:(NSString*) fileName{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//    NSString *documentsDir = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
//    return [fileManager fileExistsAtPath:filePath];
//}
-(void)hideLabelBasedOnMatchType{
    
    self.matchTypeCode = @"MSC115";
    
    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
        
        
        _lbl_teamAsecIngsHeading.hidden = YES;
        _lbl_teamBsecIngsHeading.hidden = YES;
        
        _lbl_teamASecIngsScore.hidden = YES;
        _lbl_teamASecIngsOvs.hidden = YES;
        _lbl_teamBSecIngsScore.hidden = YES;
        _lbl_teamBSecIngsOvs.hidden = YES;
        
    }else{
        _lbl_teamAsecIngsHeading.hidden = NO;
        _lbl_teamBsecIngsHeading.hidden = NO;
        
        _lbl_teamASecIngsScore.hidden = NO;
        _lbl_teamASecIngsOvs.hidden = NO;
        _lbl_teamBSecIngsScore.hidden = NO;
        _lbl_teamBSecIngsOvs.hidden = NO;
        
    }
    
}

-(void) resetBowlerBatsmanTableView{
    [strickerTableView removeFromSuperview];
    [currentBowlersTableView removeFromSuperview];
    [nonstrickerTableView removeFromSuperview];
}

- (IBAction)btn_stricker_names:(id)sender {
    [self resetBowlerBatsmanTableView];
    if(!isStrickerOpen){
        isStrickerOpen = YES;
        isNONStrickerOpen = NO;
        isBowlerOpen = NO;
    strickerTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.BatsmenView.frame.origin.x, self.BatsmenView.frame.origin.y+75,300,300)];
    strickerTableView.backgroundColor=[UIColor whiteColor];
    strickerTableView.dataSource = self;
    strickerTableView.delegate = self;
    [self.view addSubview:strickerTableView];
    
        strickerList = [[NSMutableArray alloc]init];
    int indx=0;
    int selectePosition = -1;
    for (SelectPlayerRecord *record in fetchSEPageLoadRecord.getBattingTeamPlayers)
    {
          bool chkNonStricker = ([[record playerCode] isEqualToString:fetchSEPageLoadRecord.nonstrickerPlayerCode]);
        if(!chkNonStricker){
            [strickerList addObject:record];
        }
        
        bool chk = ([[record playerCode] isEqualToString:fetchSEPageLoadRecord.strickerPlayerCode]);
        if (chk)
        {
            selectePosition = indx;
           // break;
        }
        indx ++;
    }
        
        [strickerTableView reloadData];
        
    
    //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
    [strickerTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [strickerTableView scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
    }else{
        isStrickerOpen = NO;
        isNONStrickerOpen = NO;
        isBowlerOpen = NO;
    }


}
- (IBAction)btn_nonstricker_name:(id)sender {
    [self resetBowlerBatsmanTableView];
    if(!isNONStrickerOpen){
        isStrickerOpen = NO;
        isNONStrickerOpen = YES;
        isBowlerOpen = NO;
    nonstrickerTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.BatsmenView.frame.origin.x, self.BatsmenView.frame.origin.y+100,300,300)];
    nonstrickerTableView.backgroundColor=[UIColor whiteColor];
    nonstrickerTableView.dataSource = self;
    nonstrickerTableView.delegate = self;
    [self.view addSubview:nonstrickerTableView];
    
    
         nonStrickerList = [[NSMutableArray alloc]init];
    int indx=0;
    int selectePosition = -1;
    for (SelectPlayerRecord *record in fetchSEPageLoadRecord.getBattingTeamPlayers)
    {
          bool chkStricker = ([[record playerCode] isEqualToString:fetchSEPageLoadRecord.strickerPlayerCode]);
        if(!chkStricker){
            [nonStrickerList addObject:record];
        }
        
        bool chk = ([[record playerCode] isEqualToString:fetchSEPageLoadRecord.nonstrickerPlayerCode]);
        if (chk)
        {
            selectePosition = indx;
           // break;
        }
        indx ++;
    }
    [nonstrickerTableView reloadData];
    //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
    [nonstrickerTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [nonstrickerTableView scrollToRowAtIndexPath:indexPath
                                   atScrollPosition:UITableViewScrollPositionTop
                                           animated:YES];
    }else{
        isStrickerOpen = NO;
        isNONStrickerOpen = NO;
        isBowlerOpen = NO;
    }
}
- (IBAction)btn_bowler_name:(id)sender {
    
    [self resetBowlerBatsmanTableView];
    if(!isBowlerOpen){
        isStrickerOpen = NO;
        isNONStrickerOpen = NO;
        isBowlerOpen = YES;
    
    currentBowlersTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.BowlerView.frame.origin.x, self.BowlerView.frame.origin.y+80,300,300)];
    currentBowlersTableView.backgroundColor=[UIColor whiteColor];
    currentBowlersTableView.dataSource = self;
    currentBowlersTableView.delegate = self;
    [self.view addSubview:currentBowlersTableView];
    [currentBowlersTableView reloadData];
    
    
    int indx=0;
    int selectePosition = -1;
    for (BowlerEvent *record in fetchSEPageLoadRecord.getBowlingTeamPlayers)
    {
        bool chk = ([[record BowlerCode] isEqualToString:fetchSEPageLoadRecord.currentBowlerPlayerCode]);
        if (chk)
        {
            selectePosition = indx;
            break;
        }
        indx ++;
    }
    
    //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
    [currentBowlersTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [currentBowlersTableView scrollToRowAtIndexPath:indexPath
                        atScrollPosition:UITableViewScrollPositionTop
                                animated:YES];
    }else{
        isStrickerOpen = NO;
        isNONStrickerOpen = NO;
        isBowlerOpen = NO;
    }
}
- (IBAction)btn_last_bowler_name:(id)sender {
}


-(void) reloadBowlerTeamBatsmanDetails{
    
    fetchSEPageLoadRecord = [[FetchSEPageLoadRecord alloc]init];
    [fetchSEPageLoadRecord fetchSEPageLoadDetails:self.competitionCode :self.matchCode];
    
    
    //Stricker Details
    self.lbl_stricker_name.text = fetchSEPageLoadRecord.strickerPlayerName;
    self.lbl_stricker_runs.text = fetchSEPageLoadRecord.strickerTotalRuns;
    self.lbl_stricker_balls.text = fetchSEPageLoadRecord.strickerTotalBalls;
    self.lbl_stricker_sixs.text = fetchSEPageLoadRecord.strickerSixes;
    self.lbl_stricker_strickrate.text = fetchSEPageLoadRecord.strickerStrickRate;
    self.lbl_stricker_fours.text = fetchSEPageLoadRecord.strickerFours;
    
    //Non Stricker Details
    self.lbl_nonstricker_name.text = fetchSEPageLoadRecord.nonstrickerPlayerName;
    self.lbl_nonstricker_runs.text = fetchSEPageLoadRecord.nonstrickerTotalRuns;
    self.lbl_nonstricker_balls.text = fetchSEPageLoadRecord.nonstrickerTotalBalls;
    self.lbl_nonstricker_fours.text = fetchSEPageLoadRecord.nonstrickerFours;
    self.lbl_nonstricker_sixs.text = fetchSEPageLoadRecord.nonstrickerSixes;
    self.lbl_nonstricker_strickrate.text = fetchSEPageLoadRecord.nonstrickerStrickRate;
    
    //Bowler
    
    self.lbl_bowler_name.text = fetchSEPageLoadRecord.currentBowlerPlayerName;
    self.lbl_bowler_runs.text = fetchSEPageLoadRecord.currentBowlerOver;
    self.lbl_bowler_balls.text = fetchSEPageLoadRecord.currentBowlerMaidan;
    self.lbl_bowler_fours.text = fetchSEPageLoadRecord.currentBowlerRuns;
    self.lbl_bowler_sixs.text = fetchSEPageLoadRecord.currentBowlerWicket;
    self.lbl_bowler_strickrate.text = fetchSEPageLoadRecord.currentBowlerEcoRate;
    
    
    
    //team score details display
    _lbl_battingShrtName.text = fetchSEPageLoadRecord.BATTEAMSHORTNAME;
    _lbl_firstIngsTeamName.text = fetchSEPageLoadRecord.BATTEAMSHORTNAME;
    _lbl_secIngsTeamName.text = fetchSEPageLoadRecord.BOWLTEAMSHORTNAME;
    _lbl_battingScoreWkts.text = [NSString stringWithFormat:@"%ld / %ld",(unsigned long)fetchSEPageLoadRecord.BATTEAMRUNS,(unsigned long)fetchSEPageLoadRecord.BATTEAMWICKETS];
    
    _lbl_overs.text = [NSString stringWithFormat:@"%ld.%ld OVS" ,(unsigned long)fetchSEPageLoadRecord.BATTEAMOVERS,(unsigned long)fetchSEPageLoadRecord.BATTEAMOVRBALLS];
    
    _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue], [fetchSEPageLoadRecord.RUNSREQUIRED floatValue]];
    
    
    
    
    //all innings details for team A and team B
    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.SECONDINNINGSTOTAL,fetchSEPageLoadRecord.SECONDINNINGSWICKET];
    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.SECONDINNINGSOVERS];
    
    
    // _lbl_teamASecIngsScore.text =
    //_lbl_teamASecIngsOvs.text =
    
    
    //  _lbl_teamBSecIngsScore.text =
    //    _lbl_teamBSecIngsOvs.text =
    
    _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",fetchSEPageLoadRecord.FIRSTINNINGSTOTAL,fetchSEPageLoadRecord.FIRSTINNINGSWICKET];
    _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FIRSTINNINGSOVERS];
    
    
}
- (IBAction)btn_swap:(id)sender {
}



-(void)didClickWagonWheelmapTapAction:(UIGestureRecognizer *)wagon_Wheelgesture
{
    CGPoint p = [wagon_Wheelgesture locationInView:self.img_WagonWheel];
    float Xposition = p.x;
    float Yposition = p.y;
    CGMutablePathRef straightLinePath = CGPathCreateMutable();
    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
    CGPathAddLineToPoint(straightLinePath, NULL,self.centerlbl.center.x,self.centerlbl.center.y);
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = straightLinePath;
    UIColor *fillColor = [UIColor redColor];
    shapeLayer.fillColor = fillColor.CGColor;
    UIColor *strokeColor = [UIColor redColor];
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.fillRule = kCAFillRuleNonZero;
    
    [self.img_WagonWheel.layer addSublayer:shapeLayer];
    
    
    //Long Stop Third Man
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <225 && Xposition  > 210   && Yposition > 12 && Yposition <39))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Long Stop";
            regioncode = @"MSC217";
            
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Long Stop";
                regioncode = @"MSC217";
                
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
    
        else if(( Xposition >222 && Yposition <0)) {
            wagonregiontext = @"Long Stop";
            regioncode = @"MSC217";
            
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
    }
    
    else if(( Xposition <185 && Xposition  > 180   && Yposition > 19 && Yposition <33))
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
   
    {
        wagonregiontext = @"Long Stop";
        regioncode = @"MSC217";
        
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
        
        else{
            wagonregiontext = @"Long Stop";
            regioncode = @"MSC217";
            
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        
    }
    
    
    else if ( Xposition >168 && Yposition <0)
        
    {
        wagonregiontext = @"Long Stop";
        regioncode = @"MSC217";
        
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    
    
    
    
    //Fine Leg Straight
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <265 && Xposition  > 250   && Yposition > 50 && Yposition <62))
        {
            wagonregiontext = @"Straight";
            regioncode = @"MSC244";
            
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    
    }
    
    else if(( Xposition <208 && Xposition  > 197   && Yposition > 41 && Yposition <49))
        
        
    {
        wagonregiontext = @"Straight";
        regioncode = @"MSC244";
        
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    //
    //    else if ( Xposition >168 && Yposition <0)
    //
    //    {
    //        wagonregiontext = @"Long Stop";
    //        regioncode = @"MSC154";
    //
    //        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //    }
    
    
    
    // Fine Leg Long Leg
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <315 && Xposition  > 289   && Yposition > 30 && Yposition <50))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Long Leg";
            regioncode = @"MSC155";
            
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Third Man - Fine";
                regioncode = @"MSC215";
                
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
        
    }
    
    else if(( Xposition <235 && Xposition  > 223   && Yposition > 23 && Yposition <33))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Long Leg";
            regioncode = @"MSC155";
            
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Third Man - Fine";
            regioncode = @"MSC215";
            
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    
    
    
    //Fine Leg
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <300 && Xposition  > 289   && Yposition > 60 && Yposition <70))
        {
             if([self.BatmenStyle isEqualToString:@"MSC012"])
             {
            wagonregiontext = @"Fine Leg";
            regioncode = @"MSC156";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
             }
            else
            {
                wagonregiontext = @"Third Man";
                regioncode = @"MSC216";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition <233 && Xposition  > 220   && Yposition > 44 && Yposition <55))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Fine Leg";
            regioncode = @"MSC156";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Third Man";
            regioncode = @"MSC216";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }

    }
    
    //
    //    else if ( Xposition >168 && Yposition <0)
    //
    //    {
    //        wagonregiontext = @"Long Stop";
    //        regioncode = @"MSC154";
    //
    //        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //    }
    
    
    
    // Fine Leg Deep
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <342 && Xposition  > 330   && Yposition > 50 && Yposition <68))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Fine Leg";
            regioncode = @"MSC157";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else
            {
                wagonregiontext = @"Third Man - Deep";
                regioncode = @"MSC214";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
        
    }
    
    else if(( Xposition <270 && Xposition  > 253   && Yposition > 37 && Yposition <50))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Fine Leg";
            regioncode = @"MSC157";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Third Man - Deep";
            regioncode = @"MSC214";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    //Short Fine Leg
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <270 && Xposition  > 255   && Yposition > 100 && Yposition <120))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Short Fine Leg";
            regioncode = @"MSC158";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Short Third Man";
                regioncode = @"MSC212";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
       
    }
    
    else if(( Xposition <215 && Xposition  > 195   && Yposition > 79 && Yposition <93))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Short Fine Leg";
            regioncode = @"MSC158";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Short Third Man";
            regioncode = @"MSC212";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    //
    //    else if ( Xposition >168 && Yposition <0)
    //
    //    {
    //        wagonregiontext = @"Long Stop";
    //        regioncode = @"MSC154";
    //
    //        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //    }
    
    
    
    
    
    // Backward Short Leg
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <262 && Xposition  > 245   && Yposition > 130 && Yposition <150))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Backward Short Leg";
            regioncode = @"MSC159";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Fly Slip";
                regioncode = @"MSC211";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
        
    }
    
    else if(( Xposition <213 && Xposition  > 193   && Yposition > 110 && Yposition <120))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Backward Short Leg";
            regioncode = @"MSC159";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Fly Slip";
            regioncode = @"MSC211";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    // Leg Gully
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <265 && Xposition  > 255   && Yposition > 152 && Yposition <165))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Leg Gully";
            regioncode = @"MSC160";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Gully";
                regioncode = @"MSC201";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
     
    }
    
    else if(( Xposition <213 && Xposition  > 200   && Yposition > 120 && Yposition <130))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Leg Gully";
            regioncode = @"MSC160";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Gully";
            regioncode = @"MSC201";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }

    }
    
    
    
    //Leg Slip
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <245 && Xposition  > 233   && Yposition > 158 && Yposition <170))
        {
            wagonregiontext = @"Leg Slip";
            regioncode = @"MSC161";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <195 && Xposition  > 185   && Yposition > 123 && Yposition <136))
        
        
    {
        wagonregiontext = @"Leg Slip";
        regioncode = @"MSC161";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    //
    //    else if ( Xposition >168 && Yposition <0)
    //
    //    {
    //        wagonregiontext = @"Long Stop";
    //        regioncode = @"MSC154";
    //
    //        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //    }
    
    
    
    // SQUARE LEG Short Leg
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <245 && Xposition  > 233   && Yposition > 175 && Yposition <185))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Short Leg";
            regioncode = @"MSC162";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Silly Point";
                regioncode = @"MSC193";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition <190 && Xposition  > 182   && Yposition > 135 && Yposition <141))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Short Leg";
            regioncode = @"MSC162";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Silly Point";
            regioncode = @"MSC193";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    //
    //    else if ( Xposition >168 && Yposition <0)
    //
    //    {
    //        wagonregiontext = @"Long Stop";
    //        regioncode = @"MSC154";
    //
    //        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //    }
    
    
    //Wicket Keeper
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <230 && Xposition  > 220   && Yposition > 174 && Yposition <181))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            
            wagonregiontext = @"Wicket Keeper";
            regioncode = @"MSC152";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Wicket Keeper";
                regioncode = @"MSC152";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
       
    }
    
    else if(( Xposition <180 && Xposition  > 170   && Yposition > 132 && Yposition <143))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            
            wagonregiontext = @"Wicket Keeper";
            regioncode = @"MSC152";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Wicket Keeper";
            regioncode = @"MSC152";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    // Slip 1  THIRD MAN
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <222 && Xposition  > 219   && Yposition > 144 && Yposition <149))
        {
            wagonregiontext = @"Slip 1";
            regioncode = @"MSC202";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <171 && Xposition  > 168   && Yposition > 114 && Yposition <118))
        
        
    {
        wagonregiontext = @"Slip 1";
        regioncode = @"MSC202";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    
    
    // Slip 2  THIRD MAN
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <217 && Xposition  > 212  && Yposition > 149 && Yposition <150))
        {
            wagonregiontext = @"Slip 2";
            regioncode = @"MSC203";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <168 && Xposition  > 165   && Yposition > 116 && Yposition <118))
        
        
    {
        wagonregiontext = @"Slip 2";
        regioncode = @"MSC203";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    
    
    
    // Slip 3  THIRD MAN
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <212 && Xposition  > 207  && Yposition > 150 && Yposition <153))
        {
            wagonregiontext = @"Slip 3";
            regioncode = @"MSC204";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <165 && Xposition  > 163   && Yposition > 113 && Yposition <116))
        
        
    {
        wagonregiontext = @"Slip 3";
        regioncode = @"MSC204";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    
    //Slip 4
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <207 && Xposition  >202  && Yposition > 154 && Yposition <156))
        {
            wagonregiontext = @"Slip 4";
            regioncode = @"MSC205";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <163 && Xposition  > 160   && Yposition > 116 && Yposition <118))
        
        
    {
        wagonregiontext = @"Slip 4";
        regioncode = @"MSC205";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    
    
    
    //Slip 5
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <202 && Xposition  > 195  && Yposition > 118 && Yposition <120))
        {
            wagonregiontext = @"Slip 5";
            regioncode = @"MSC206";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <160 && Xposition  > 157   && Yposition > 120 && Yposition <121))
        
        
    {
        wagonregiontext = @"Slip 5";
        regioncode = @"MSC206";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    
    //Slip 6
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <195 && Xposition  > 190  && Yposition > 121 && Yposition <122))
        {
            wagonregiontext = @"Slip 6";
            regioncode = @"MSC207";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <157 && Xposition  > 154   && Yposition > 122 && Yposition <123))
        
        
    {
        wagonregiontext = @"Slip 6";
        regioncode = @"MSC207";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    //Slip 7
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <190 && Xposition  > 188  && Yposition > 160 && Yposition <162))
        {
            wagonregiontext = @"Slip 7";
            regioncode = @"MSC208";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <154 && Xposition  > 151   && Yposition > 123 && Yposition <126))
        
        
    {
        wagonregiontext = @"Slip 6";
        regioncode = @"MSC208";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    
    
    // Slip 8
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <188 && Xposition  > 187  && Yposition > 162 && Yposition <163))
        {
            wagonregiontext = @"Slip 8";
            regioncode = @"MSC209";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <150 && Xposition  > 148  && Yposition > 126 && Yposition <127))
        
        
    {
        wagonregiontext = @"Slip 8";
        regioncode = @"MSC209";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    // Slip 9
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <195 && Xposition  > 193  && Yposition > 163 && Yposition <166))
        {
            wagonregiontext = @"Slip 9";
            regioncode = @"MSC210";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <148 && Xposition  > 145   && Yposition > 127 && Yposition <128))
        
        
    {
        wagonregiontext = @"Slip 9";
        regioncode = @"MSC210";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }
    
    //  FINE LEG Square
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <378 && Xposition  > 353   && Yposition > 79 && Yposition <95))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Square";
            regioncode = @"MSC243";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Third Man - Square";
                regioncode = @"MSC213";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);

            }
        }
           }
    
    else if(( Xposition <295 && Xposition  > 275   && Yposition > 60 && Yposition <75))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Square";
            regioncode = @"MSC243";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Third Man - Square";
            regioncode = @"MSC213";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
    }
    
    
    
    
    //Deep Backward Square Leg  SQUARE LEG
    
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <405 && Xposition  > 385   && Yposition > 113 && Yposition <132))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Backward Square Leg";
            regioncode = @"MSC166";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
            else{
                wagonregiontext = @"Deep Backward Point";
                regioncode = @"MSC199";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
        
    }
    
    else if(( Xposition <315 && Xposition  > 298   && Yposition > 82 && Yposition <98))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Backward Square Leg";
            regioncode = @"MSC166";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Deep Backward Point";
            regioncode = @"MSC199";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    // Deep Square Leg  SQUARE LEG
    
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <415 && Xposition  > 385   && Yposition > 150 && Yposition <170))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Square Leg";
            regioncode = @"MSC164";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                
                wagonregiontext = @"Deep Point";
                regioncode = @"MSC198";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition <412 && Xposition  > 388   && Yposition > 150 && Yposition <170))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Square Leg";
            regioncode = @"MSC164";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            
            wagonregiontext = @"Deep Point";
            regioncode = @"MSC198";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    // SQUARE LEG Deep Forward Square Leg
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <418 && Xposition  > 390   && Yposition > 185 && Yposition <220))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Forward Square Leg";
            regioncode = @"MSC168";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Deep Farward Point";
                regioncode = @"MSC200";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition <412 && Xposition  > 388   && Yposition > 150 && Yposition <170))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Forward Square Leg";
            regioncode = @"MSC168";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Deep Farward Point";
            regioncode = @"MSC200";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    // SQUARE LEG  Backward Square Leg
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <308 && Xposition  > 290   && Yposition > 155 && Yposition <170))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Backward Square Leg";
            regioncode = @"MSC165";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{ wagonregiontext = @"Backward Point";
                regioncode = @"MSC196";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
       
    }
    
    else if(( Xposition <242 && Xposition  > 225   && Yposition > 118 && Yposition <135))
        
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Backward Square Leg";
            regioncode = @"MSC165";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{ wagonregiontext = @"Backward Point";
            regioncode = @"MSC196";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    
    //Square Leg
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <317 && Xposition  > 298   && Yposition > 175 && Yposition <195))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Square Leg";
            regioncode = @"MSC163";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Point";
                regioncode = @"MSC194";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
      
    }
    
    else if(( Xposition <248 && Xposition  > 223   && Yposition > 130 && Yposition <145))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Square Leg";
            regioncode = @"MSC163";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Point";
            regioncode = @"MSC194";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }    }
    
    
    
    //Forward Square Leg
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <325 && Xposition  > 291   && Yposition > 182 && Yposition <205))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Forward Square Leg";
            regioncode = @"MSC167";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Farward Point";
                regioncode = @"MSC197";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    
    else if(( Xposition <247 && Xposition  > 223   && Yposition > 145 && Yposition <156))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Forward Square Leg";
            regioncode = @"MSC167";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Farward Point";
            regioncode = @"MSC197";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //Short MID WICKET
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <286 && Xposition  > 260   && Yposition > 225 && Yposition <205))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Short Mid Wicket";
            regioncode = @"MSC170";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Short Covers";
                regioncode = @"MSC188";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);

            }
        }
        
    }
    
    else if(( Xposition <220 && Xposition  > 200   && Yposition > 155 && Yposition <175))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Short Mid Wicket";
            regioncode = @"MSC170";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Short Covers";
            regioncode = @"MSC188";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
    }
    
    
    
    //Mid Wicket
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <320 && Xposition  > 290   && Yposition > 225 && Yposition <260))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Mid Wicket";
            regioncode = @"MSC171";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Covers";
                regioncode = @"MSC189";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
       
    }
    
    else if(( Xposition <248 && Xposition  > 222   && Yposition > 185 && Yposition <210))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Mid Wicket";
            regioncode = @"MSC171";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Covers";
            regioncode = @"MSC189";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //  Deep Mid Wicket (Sweeper)
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <423 && Xposition  > 393   && Yposition > 245 && Yposition <280))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Mid Wicket (Sweeper)";
            regioncode = @"MSC172";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else
            {
                wagonregiontext = @"Deep Cover";
                regioncode = @"MSC191";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition <335 && Xposition  > 302   && Yposition > 185 && Yposition <216))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Cover";
            regioncode = @"MSC172";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Deep Mid Wicket (Sweeper)";
            regioncode = @"MSC191";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //Deep Forward (Sweeper)
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition <388 && Xposition  > 350   && Yposition > 320 && Yposition <360))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            
            wagonregiontext = @"Deep Forward (Sweeper)";
            regioncode = @"MSC173";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Deep Extra Cover (Sweeper)";
                regioncode = @"MSC192";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
       
    }
    
    else if(( Xposition <315 && Xposition  > 277   && Yposition > 242 && Yposition <280))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            
            wagonregiontext = @"Deep Forward (Sweeper)";
            regioncode = @"MSC173";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Deep Extra Cover (Sweeper)";
            regioncode = @"MSC192";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //Silly Mid On
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 250 && Xposition > 230 && Yposition > 203 && Yposition <225))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Silly Mid On";
            regioncode = @"MSC169";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                
                wagonregiontext = @"Silly Mid Off";
                regioncode = @"MSC187";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition < 195 && Xposition  > 185   && Yposition > 160 && Yposition <174))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Silly Mid On";
            regioncode = @"MSC169";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            
            wagonregiontext = @"Silly Mid Off";
            regioncode = @"MSC187";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    // Short Mid On
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 260 && Xposition > 235 && Yposition > 236 && Yposition <254))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Short Mid On";
            regioncode = @"MSC174";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Short Mid Off";
                regioncode = @"MSC182";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition < 195 && Xposition  > 185   && Yposition > 184 && Yposition <200))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Short Mid On";
            regioncode = @"MSC174";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Short Mid Off";
            regioncode = @"MSC182";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    
    
    //  Long on Mid On
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 265 && Xposition > 245 && Yposition > 263 && Yposition <285))
        {
             if([self.BatmenStyle isEqualToString:@"MSC012"])
             {
            wagonregiontext = @"Mid On";
            regioncode = @"MSC175";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
             }
            else
            {
                wagonregiontext = @"Mid Off";
                regioncode = @"MSC181";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
            }
        }
          }
    
    else if(( Xposition < 205 && Xposition  > 193   && Yposition > 205 && Yposition <216))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Mid On";
            regioncode = @"MSC175";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Mid Off";
            regioncode = @"MSC181";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
        
    }
    
    
    //Deep Mid On
    
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 280 && Xposition > 253 && Yposition > 282 && Yposition <317))
        {
            
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Mid On";
            regioncode = @"MSC176";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Deep Mid Off";
                regioncode = @"MSC186";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition < 220 && Xposition  > 193   && Yposition > 220 && Yposition <250))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Mid On";
            regioncode = @"MSC176";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Deep Mid Off";
            regioncode = @"MSC186";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    
    //Wide Mid On  LONG ON
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 355 && Xposition > 317 && Yposition > 362 && Yposition <402))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Wide Long On";
            regioncode = @"MSC179";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Wide Long Off";
                regioncode = @"MSC186";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            
        }
            }
    
    else if(( Xposition < 278 && Xposition  > 256   && Yposition > 288 && Yposition <310))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Wide Long On";
            regioncode = @"MSC179";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Wide Long Off";
            regioncode = @"MSC186";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    //Long On LONG ON
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 313 && Xposition > 273 && Yposition > 370 && Yposition <418))
        {
               if([self.BatmenStyle isEqualToString:@"MSC012"])
               {
            wagonregiontext = @"Long On";
            regioncode = @"MSC178";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
               }
               else{
                   wagonregiontext = @"Long Off";
                   regioncode = @"MSC185";
                   NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
                   
               }
            
        }
       
    }
    
    else if(( Xposition < 242 && Xposition  > 215   && Yposition > 288 && Yposition <330))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Long On";
            regioncode = @"MSC178";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Long Off";
            regioncode = @"MSC185";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
        
    }
    
    
    
    //Straight  LONG ON
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 268 && Xposition > 230 && Yposition > 370 && Yposition <428))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Straight";
            regioncode = @"MSC242";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Straight";
                regioncode = @"MSC241";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
       
    }
    
    else if(( Xposition < 210 && Xposition  > 182   && Yposition > 293 && Yposition <335))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Straight";
            regioncode = @"MSC242";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Straight";
            regioncode = @"MSC241";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //Straight  STRAIGHT
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 238 && Xposition > 213 && Yposition > 400 && Yposition <435))
        {
            if([self.BatmenStyle isEqualToString:@"MSC013"])
        {
            wagonregiontext = @"Straight";
            regioncode = @"MSC180";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Straight";
            regioncode = @"MSC180";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
            
        }
       
    }
    
    else if(( Xposition < 185 && Xposition  > 165   && Yposition > 303 && Yposition <335))
        
    {
         if([self.BatmenStyle isEqualToString:@"MSC013"])
         {
        
        wagonregiontext = @"Straight";
        regioncode = @"MSC180";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
         }
        else
        {
            wagonregiontext = @"Straight";
            regioncode = @"MSC180";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    // LONG OFF Short Mid Off
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 210 && Xposition > 186 && Yposition > 226 && Yposition <260))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Short Mid Off";
            regioncode = @"MSC182";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else
            {
                wagonregiontext = @"Short Mid On";
                regioncode = @"MSC174";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
            }
        }
        
    }
    
    else if(( Xposition < 170 && Xposition  > 150   && Yposition > 172 && Yposition <195))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Short Mid Off";
            regioncode = @"MSC182";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Short Mid On";
            regioncode = @"MSC174";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
        
    }
    
    
    //  LONG OFF Mid Off
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 215 && Xposition > 181 && Yposition > 260 && Yposition <295))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Mid Off";
            regioncode = @"MSC181";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Mid On";
                regioncode = @"MSC175";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);

            }
        }
       
    }
    
    else if(( Xposition < 162 && Xposition  > 140   && Yposition > 205 && Yposition <230))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Mid Off";
            regioncode = @"MSC181";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Mid On";
            regioncode = @"MSC175";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }

        
    }
    
    //Deep Mid Off LONG OFF
    
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 192 && Xposition > 165 && Yposition > 282 && Yposition <315))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Mid Off";
            regioncode = @"MSC184";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Deep Mid On";
                regioncode = @"MSC176";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition <160 && Xposition  > 133   && Yposition > 212 && Yposition <250))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Mid Off";
            regioncode = @"MSC184";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Deep Mid On";
            regioncode = @"MSC176";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    //Wide Long Off
    
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 145 && Xposition > 90 && Yposition > 350 && Yposition <407))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Wide Long Off";
            regioncode = @"MSC186";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Wide Long On";
                regioncode = @"MSC179";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);

            }
        }
            }
    
    else if(( Xposition <120 && Xposition  > 95   && Yposition > 285 && Yposition <320))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Wide Long Off";
            regioncode = @"MSC186";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Wide Long On";
            regioncode = @"MSC179";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }    }
    
    
    //Long Off
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 182 && Xposition > 135 && Yposition > 365 && Yposition <423))
        {
                  if([self.BatmenStyle isEqualToString:@"MSC012"])
                  {
            wagonregiontext = @"Long Off";
            regioncode = @"MSC185";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
                  }
            
                  else{
                      wagonregiontext = @"Long On";
                      regioncode = @"MSC178";
                      NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
                  }
            
            
        }
      
    }
    
    else if(( Xposition <141 && Xposition  > 115   && Yposition > 296 && Yposition <335))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Long Off";
            regioncode = @"MSC185";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Long On";
            regioncode = @"MSC178";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }

    }
    
    
    
    //Straight LONG OFF
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 217 && Xposition > 183 && Yposition > 383 && Yposition <428))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Straight";
            regioncode = @"MSC241";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Straight";
                regioncode = @"MSC242";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition <170 && Xposition  > 140   && Yposition > 310 && Yposition <335))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Straight";
            regioncode = @"MSC241";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Straight";
            regioncode = @"MSC242";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    //COVERS  Silly Mid Off
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 165 && Xposition > 155 && Yposition > 160 && Yposition <168))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Silly Mid Off";
            regioncode = @"MSC187";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Silly Mid On";
                regioncode = @"MSC169";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition < 175 && Xposition  > 163   && Yposition > 201 && Yposition <226))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Silly Mid Off";
            regioncode = @"MSC187";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Silly Mid On";
            regioncode = @"MSC169";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    
    
    //Short Covers
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 200 && Xposition > 163 && Yposition > 203 && Yposition <240))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Short Covers";
            regioncode = @"MSC188";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Short Mid Wicket";
                regioncode = @"MSC170";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition < 165 && Xposition  > 202   && Yposition > 201 && Yposition <232))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Short Covers";
            regioncode = @"MSC188";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Short Mid Wicket";
            regioncode = @"MSC170";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    
    
    
    
    //Covers
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 165 && Xposition > 180 && Yposition > 208 && Yposition <241))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Covers";
            regioncode = @"MSC189";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Mid Wicket";
                regioncode = @"MSC171";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
    
    }
    
    else if(( Xposition < 135 && Xposition  > 110   && Yposition > 162 && Yposition <195))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Covers";
            regioncode = @"MSC189";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Mid Wicket";
            regioncode = @"MSC171";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    
    //Extra Cover COVERS
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 170 && Xposition > 145 && Yposition > 240 && Yposition <280))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Extra Cover";
            regioncode = @"MSC190";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Extra Cover";
            regioncode = @"MSC190";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
            
        }
          }
    
    else if(( Xposition < 135 && Xposition  > 110   && Yposition > 187 && Yposition <215))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Extra Cover";
            regioncode = @"MSC190";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Extra Cover";
            regioncode = @"MSC190";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    //Deep Cover  COVERS
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 94 && Xposition > 22 && Yposition > 234 && Yposition <299))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Cover";
            regioncode = @"MSC191";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
            else{
                wagonregiontext = @"Deep Mid Wicket (Sweeper)";
                regioncode = @"MSC172";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
           }
    
    else if(( Xposition < 55 && Xposition  > 15   && Yposition > 202 && Yposition <240))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Cover";
            regioncode = @"MSC191";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Deep Mid Wicket (Sweeper)";
            regioncode = @"MSC172";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    //Deep Extra Cover (Sweeper)  COVERS
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 112 && Xposition > 50 && Yposition > 304 && Yposition <374))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Extra Cover (Sweeper)";
            regioncode = @"MSC192";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else
            {
                wagonregiontext = @"Deep Forward (Sweeper)";
                regioncode = @"MSC173";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
            }
    
    else if(( Xposition < 81 && Xposition  > 44   && Yposition > 250 && Yposition <294))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Extra Cover (Sweeper)";
            regioncode = @"MSC192";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Deep Forward (Sweeper)";
            regioncode = @"MSC173";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //Cover Point  POINT
    if (IS_IPAD_PRO)
    {
        
        
        if (( Xposition < 162 && Xposition > 144 && Yposition > 190 && Yposition <207))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Cover Point";
            regioncode = @"MSC195";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Cover Point";
                regioncode = @"MSC195";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition < 127 && Xposition  > 110   && Yposition > 152 && Yposition <160))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Cover Point";
            regioncode = @"MSC195";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Cover Point";
            regioncode = @"MSC195";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    //Farward Point POINT
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 169 && Xposition > 146 && Yposition > 178 && Yposition <190))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Farward Point";
            regioncode = @"MSC197";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else
            {
                wagonregiontext = @"Forward Square Leg";
                regioncode = @"MSC167";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);

            }
        }
        
    }
    
    else if(( Xposition < 134 && Xposition  > 110   && Yposition > 140 && Yposition <150))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Farward Point";
            regioncode = @"MSC197";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else
        {
            wagonregiontext = @"Forward Square Leg";
            regioncode = @"MSC167";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
        
    }
    
    //Point POINT
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 170 && Xposition > 147 && Yposition > 170 && Yposition <185))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Point";
            regioncode = @"MSC194";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Square Leg";
                regioncode = @"MSC163";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
        }
       
    }
    
    else if(( Xposition < 135 && Xposition  > 115   && Yposition > 126 && Yposition <145))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Point";
            regioncode = @"MSC194";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Square Leg";
            regioncode = @"MSC163";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    
    //Backward Point POINT
    
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 178 && Xposition > 143 && Yposition > 152 && Yposition <178))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Backward Point";
            regioncode = @"MSC196";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Backward Square Leg";
                regioncode = @"MSC165";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition < 135 && Xposition  > 115   && Yposition > 115 && Yposition <135))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Backward Point";
            regioncode = @"MSC196";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Backward Square Leg";
            regioncode = @"MSC165";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //Silly Point POINT
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 210 && Xposition > 192 && Yposition > 170 && Yposition <185))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            
            wagonregiontext = @"Silly Point";
            regioncode = @"MSC193";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
            
                wagonregiontext = @"Short Leg";
                regioncode = @"MSC162";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
       
    }
    
    else if(( Xposition < 166 && Xposition  > 150   && Yposition > 133 && Yposition <147))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            
            wagonregiontext = @"Silly Point";
            regioncode = @"MSC193";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            
            wagonregiontext = @"Short Leg";
            regioncode = @"MSC162";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
    }
    
    
    
    //Deep Farward Point
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 65 && Xposition > 19 && Yposition > 185 && Yposition <218))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Farward Point";
            regioncode = @"MSC200";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Deep Forward Square Leg";
                regioncode = @"MSC168";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
      
    }
    
    else if(( Xposition < 50 && Xposition  > 16   && Yposition > 147 && Yposition <178))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Farward Point";
            regioncode = @"MSC200";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Deep Forward Square Leg";
            regioncode = @"MSC168";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    //Deep Point
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 85 && Xposition > 25 && Yposition > 143 && Yposition <178))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Point";
            regioncode = @"MSC198";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Deep Square Leg";
                regioncode = @"MSC164";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
            }
        }
           }
    
    else if(( Xposition < 70 && Xposition  > 18   && Yposition > 115 && Yposition <145))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Point";
            regioncode = @"MSC198";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Deep Square Leg";
            regioncode = @"MSC164";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
    }
    
    
    //Deep Backward Point
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 100 && Xposition > 40 && Yposition > 105 && Yposition <145))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Deep Backward Point";
            regioncode = @"MSC199";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Deep Backward Square Leg";
                regioncode = @"MSC166";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
       
    }
    
    else if(( Xposition < 75 && Xposition  > 33   && Yposition > 85 && Yposition <125))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Deep Backward Point";
            regioncode = @"MSC199";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Deep Backward Square Leg";
            regioncode = @"MSC166";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    //  THIRD MAN  Fly Slip
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 216 && Xposition > 205 && Yposition > 148 && Yposition <133))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
                    wagonregiontext = @"Fly Slip";
            regioncode = @"MSC211";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                
                wagonregiontext = @"Backward Short Leg";
                regioncode = @"MSC159";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if(( Xposition < 165 && Xposition  > 145   && Yposition > 15 && Yposition <102))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Fly Slip";
            regioncode = @"MSC211";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            
            wagonregiontext = @"Backward Short Leg";
            regioncode = @"MSC159";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }

    }
    
    
    
    //Gully THIRDMAN
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 210 && Xposition > 175 && Yposition > 160 && Yposition <175))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Gully";
            regioncode = @"MSC201";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
            
                wagonregiontext = @"Leg Gully";
                regioncode = @"MSC160";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
            }
    
    else if(( Xposition < 160 && Xposition  > 135   && Yposition > 120 && Yposition <135))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Gully";
            regioncode = @"MSC201";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            
            wagonregiontext = @"Leg Gully";
            regioncode = @"MSC160";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    //Short Third Man
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 190 && Xposition > 165 && Yposition > 100 && Yposition <125))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Short Third Man";
            regioncode = @"MSC212";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Short Fine Leg";
                regioncode = @"MSC158";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
           }
    
    else if(( Xposition < 145 && Xposition  > 115   && Yposition > 79 && Yposition <96))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Short Third Man";
            regioncode = @"MSC212";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Short Fine Leg";
            regioncode = @"MSC158";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //THIRD MAN
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 180 && Xposition > 143 && Yposition > 60 && Yposition <93))
        {
              if([self.BatmenStyle isEqualToString:@"MSC012"])
              {
            wagonregiontext = @"Third Man";
            regioncode = @"MSC216";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
              }
              else{
                  wagonregiontext = @"Fine Leg";
                  regioncode = @"MSC156";
                  NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
              }
        }
        
    }
    
    else if(( Xposition < 135 && Xposition > 100 && Yposition > 45 && Yposition <75))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Third Man";
            regioncode = @"MSC216";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Fine Leg";
            regioncode = @"MSC156";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    //Third Man - Square
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 130 && Xposition > 90 && Yposition > 80 && Yposition <120))
        {
           if([self.BatmenStyle isEqualToString:@"MSC012"])
           {
            wagonregiontext = @"Third Man - Square";
            regioncode = @"MSC213";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
           }
           else{
               wagonregiontext = @"Square";
               regioncode = @"MSC243";
               NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
           
           }
        }
           }
    
    else if(( Xposition < 100 && Xposition > 50 && Yposition > 60 && Yposition <85))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Third Man - Square";
            regioncode = @"MSC213";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Square";
            regioncode = @"MSC243";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
        }
    }
    
    
    //Third Man - Deep
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 158 && Xposition > 113 && Yposition > 35 && Yposition <75))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Third Man - Deep";
            regioncode = @"MSC214";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            else{
                wagonregiontext = @"Deep Fine Leg";
                regioncode = @"MSC157";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
        }
        
    }
    
    else if((Xposition < 126 && Xposition > 99 && Yposition > 25 && Yposition <50))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Third Man - Deep";
            regioncode = @"MSC214";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        else{
            wagonregiontext = @"Deep Fine Leg";
            regioncode = @"MSC157";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    
    
    
    //Third Man - Fine
    
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 220 && Xposition > 172 && Yposition > 20 && Yposition <57))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Third Man - Fine";
            regioncode = @"MSC215";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else{
                wagonregiontext = @"Long Leg";
                regioncode = @"MSC155";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);

            
            }
        }
   
    }
    
    else if((Xposition < 170 && Xposition > 135 && Yposition > 20 && Yposition <41))
        
    {
        if([self.BatmenStyle isEqualToString:@"MSC012"])
        {
            wagonregiontext = @"Third Man - Fine";
            regioncode = @"MSC215";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        
        else{
            wagonregiontext = @"Long Leg";
            regioncode = @"MSC155";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            
            
        }
    }
    
    
    
   //Long Stop Fine Leg
    
    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 246 && Xposition > 226 && Yposition > 39 && Yposition <68))
        {
            if([self.BatmenStyle isEqualToString:@"MSC012"])
            {
            wagonregiontext = @"Long Stop";
            regioncode = @"MSC154";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }
            
            else
            {
                wagonregiontext = @"Long Stop";
                regioncode = @"MSC154";
                NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
            }

        }
            }
    
    else if((Xposition < 187 && Xposition > 171 && Yposition > 19 && Yposition <36))
        
    {
         if([self.BatmenStyle isEqualToString:@"MSC012"])
         {
        wagonregiontext = @"Long Stop";
        regioncode = @"MSC154";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
         }
        else
        {
            wagonregiontext = @"Long Stop";
            regioncode = @"MSC154";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
    }
    


    if (IS_IPAD_PRO)
    {
        
        if (( Xposition < 220 && Xposition > 172 && Yposition > 20 && Yposition <57))
        {
            wagonregiontext = @"Third Man - Fine";
            regioncode = @"MSC215";
            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        }
        //
        //        else if(( Xposition >222 && Yposition <0)) {
        //            wagonregiontext = @"Long Stop";
        //            regioncode = @"MSC154";
        //
        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
        //
        //        }
    }
    else if((Xposition < 170 && Xposition > 135 && Yposition > 20 && Yposition <41))
        
    {
        wagonregiontext = @"Third Man - Fine";
        regioncode = @"MSC215";
        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    }

    
    
    
}




@end
