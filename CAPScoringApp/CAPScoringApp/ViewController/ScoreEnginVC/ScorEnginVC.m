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
#import "InitializeInningsScoreBoardRecord.h"
#import "AppealBatsmenRecord.h"

#import "ArchivesVC.h"
#import "BreakVC.h"
#import "EndInnings.h"
#import "RevicedOverVC.h"
#import "FixturesRecord.h"
#import "RevisedTarget.h"
#import "Reachability.h"
#import "PenalityVC.h"
#import "FetchLastBowler.h"
#import "LastBolwerDetailRecord.h"
#import "ScoreCardVC.h"
#import "EndInningsVC.h"
#import "MatchResultListVC.h"
#import "EndDayVC.h"
#import "DBManagerEndDay.h"
#import "PowerPlayGridVC.h"
#import "PenaltygridVC.h"
#import "AppealRecord.h"
#import "umpiretablecell.h"
#import "Batsmancell.h"
#import "AppealBatsmenRecord.h"
#import "DeclareInnings.h"
#import "OtherWicketVC.h"
#import "PowerPlayGridVC.h"
#import "Other_WicketVC.h"
#import "NewMatchSetUpVC.h"
#import "FETCHSEBALLCODEDETAILS.h"
#import "ScoreEnginEditRecord.h"
#import "ChangeTeamVC.h"
#import "InsertSEScoreEngine.h"
#import "Other_WicketgridVC.h"
#import "FollowOn.h"
#import "ChangeTossVC.h"
#import "UpdateScoreEngine.h"
#import "ArchivesVC.h"
#import "PushSyncDBMANAGER.h"
#import "EndSession.h"
#import "EditModeVC.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPAD_PRO (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)
//#define IS_IPAD (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1024.0)

@interface ScorEnginVC () <CDRTranslucentSideBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate,ChangeTeamDelegate,ChangeTossDelegate,FollowonDelegate,EditmodeDelegate,EndSedsessionDelegate,BreakVCDelagate,EndInningsVCDelagate,PenaltygridVCDelegate,DeclareInningsVCDelagate>
{   //appeal System
    BOOL isEnableTbl;
    NSMutableArray * AppealSystemSelectionArray;
    NSString*AppealSystemSelectCode;
    AppealSystemRecords *objAppealSystemEventRecord;
    NSMutableDictionary *appealEventDict;
    
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
    AppealBatsmenRecord *objAppealBatsmenEventRecord;
    
    NSString *StrikerPlayer;
    NSString *UmpireSelect;
    
    //Remark
    NSString *remarks;
    
    NSMutableArray *Btn_NameArray;
    BOOL isSelectleftview;
    UITableView* extrasTableView;
    UITableView* overThrowTableView;
    UITableView* currentBowlersTableView;
    UITableView* strickerTableView;
    UITableView* nonstrickerTableView;
    
    
    UITableView* objextras;
    //BallEventRecord *objBalleventRecord;
    NSArray *MuliteDayMatchtype;
    
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
    BOOL leftSlideSwipe;
    BOOL isCaught;
    BOOL isPitchmap;
    BOOL ispichmapSelectValue;
    
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
    NSString *selectedStrikernonstrikerCode;
    NSString *selectedWicketPlayerCode;
    NSString *selectedWicketEvent;
    BowlerEvent *selectedwicketBowlerlist;
    
    //Revised overs
    NSString *strovers;
    NSString *strcomments;
    
    //Revised target
    NSString *strtargetovers;
    NSString *strtargetruns;
    NSString *strtargetcomments;
    
    //
    NSString *strpenalityruns;
    
    
    UISwipeGestureRecognizer *RightsideGesture;
    UISwipeGestureRecognizer *LeftsideGesture;
    BreakVC * breakvc;
    UIView * fullview;
    
    BOOL isTargetReached;
    NSString * overStatus;
    NSString * Umpire1Code;
    NSString * umpire2Code;
    NSString  *TEAMAWICKETKEEPER;
    NSString  *TEAMBWICKETKEEPER;
    
    
    PowerPlayGridVC *powerplaygridvc;
    Other_WicketVC *otherwicketvc;
    Other_WicketgridVC *otherwikcetgricvc;
    RevicedOverVC * revicedOverVc ;
    RevisedTarget  *revisedTarget;
    PenalityVC *penalityVc;
    PenaltygridVC *penaltygridvc;
    
    
    NSString * alterviewSelect;
    DBManagerEndDay *objDBManagerEndDay;
    //BOOL isEditMode;
    BOOL isFreeHitBall;
    NSArray *ValidedMatchType;
      FETCHSEBALLCODEDETAILS *fetchSeBallCodeDetails;
    
}


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
@property(nonatomic,strong)NSDictionary *test;
@property(nonatomic,strong)NSDictionary *test1;
//wicketType
@property (nonatomic,strong)NSMutableArray *WicketTypeArray;
@property (nonatomic,strong)NSMutableArray *StrikerandNonStrikerArray;
@property (nonatomic,strong)NSMutableArray *WicketEventArray;
@property (nonatomic,strong)NSMutableArray *PlayerlistArray;

@property (nonatomic, weak) IBOutlet UIView *objcommonRemarkviews;

@property(nonatomic,strong)NSMutableArray *rightSlideArray;

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


FetchLastBowler *fetchLastBowler;
FetchSEPageLoadRecord *fetchSEPageLoadRecord;
EndInnings *endInnings;
EditModeVC * objEditModeVc;
- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize Matchtype Dictionary
    MuliteDayMatchtype =[[NSArray alloc]initWithObjects:@"MSC023",@"MSC114", nil];
    ValidedMatchType = [[NSArray alloc]initWithObjects:@"MSC022",@"MSC023",@"MSC024",@"MSC114",@"MSC115",@"MSC116", nil];
    
    NSLog(@"self.matchTypeCode%@",self.matchTypeCode);
    
    AppealBatsmenArray=[[NSMutableArray alloc]init];
    
    AppealUmpireArray=[[NSMutableArray alloc]init];
    
    
    objEditModeVc=[[EditModeVC alloc]init];
   
     
    objEditModeVc.delegate=self;
    if(self.isEditMode){//Edit
        [self loadViewOnEditMode];
        
    }else{//Live
        [self reloadBowlerTeamBatsmanDetails];
        [self AllBtndisableMethod];
        
    }    [self hideLabelBasedOnMatchType];
    
    //    FetchLastBallBowledPlayer *fetchLastBallBowledPlayer = [[FetchLastBallBowledPlayer alloc]init];
    
    
    //Get Last bowler details
    fetchLastBowler = [[FetchLastBowler alloc]init];
    [fetchLastBowler LastBowlerDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.INNINGSNO :[NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVERS] : [NSNumber numberWithInteger:fetchSEPageLoadRecord.BATTEAMOVRBALLS] :[NSNumber numberWithInteger:fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT]];
    NSLog(@"viewdidload batteamover=%d",fetchSEPageLoadRecord.BATTEAMOVERS);
    
    if(fetchLastBowler.GetLastBolwerDetails.count!=0){
        LastBolwerDetailRecord *lastBowlerDetailRecord = [fetchLastBowler.GetLastBolwerDetails objectAtIndex:0];
        
        
        self.lbl_last_bowler_name.text = lastBowlerDetailRecord.BOWLERNAME;
        self.lbl_last_bowler_runs.text = lastBowlerDetailRecord.OVERS;
        self.lbl_last_bowler_balls.text = lastBowlerDetailRecord.MAIDENOVERS;
        self.lbl_last_bowler_fours.text = lastBowlerDetailRecord.TOTALRUNS;
        self.lbl_last_bowler_sixs.text = lastBowlerDetailRecord.WICKETS;
        self.lbl_last_bowler_strickrate.text = [NSString stringWithFormat:@"%.01f",[lastBowlerDetailRecord.ECONOMY floatValue]];
        
    }else{
        self.lbl_last_bowler_name.text = @"-";
        self.lbl_last_bowler_runs.text = @"-";
        self.lbl_last_bowler_balls.text = @"-";
        self.lbl_last_bowler_fours.text = @"-";
        self.lbl_last_bowler_sixs.text = @"-";
        self.lbl_last_bowler_strickrate.text = @"-";
    }
    
    
    FetchLastBallBowledPlayer *fetchLastBallBowledPlayer = [[FetchLastBallBowledPlayer alloc]init];
    
    
    endInnings = [[EndInnings alloc]init];
    //
    //[endInnings fetchEndInnings:self.competitionCode :self.matchCode :@"TEA0000024":@"1"];
    
    
    
//
     NSString*Playerstickercode=fetchSEPageLoadRecord.strickerPlayerCode;
    NSString*PlayerstickerName=fetchSEPageLoadRecord.strickerPlayerName;
     NSString*Playernonstickercode=fetchSEPageLoadRecord.nonstrickerPlayerCode;
   NSString*Playernonstickername=fetchSEPageLoadRecord.nonstrickerPlayerName;
    
    NSMutableDictionary *Dict1=[[NSMutableDictionary alloc]init];
    [Dict1 setValue:Playerstickercode forKey:@"AppealBatsmenPlayerCode"];
    [Dict1 setValue:PlayerstickerName forKey:@"AppealBatsmenPlayerName"];

    
   NSMutableDictionary *Dict2=[[NSMutableDictionary alloc]init];
        [Dict2 setValue:Playernonstickercode forKey:@"AppealBatsmenPlayerCode"];
    [Dict2 setValue:Playernonstickername forKey:@"AppealBatsmenPlayerName"];

    
    
    AppealBatsmenArray=[[NSMutableArray alloc]initWithObjects:Dict1,Dict2 ,nil];
    
    NSString*umpire1code=fetchSEPageLoadRecord.UMPIRE1CODE;
    NSString*umpire1Name=fetchSEPageLoadRecord.UMPIRE1NAME;
    NSString*umpire2code=fetchSEPageLoadRecord.UMPIRE2CODE;
    NSString*umpire2name=fetchSEPageLoadRecord.UMPIRE2NAME;
    
    NSMutableDictionary *UmpireDict1=[[NSMutableDictionary alloc]init];
    [UmpireDict1 setValue:umpire1code forKey:@"AppealumpireCode"];
    [UmpireDict1 setValue:umpire1Name forKey:@"AppealumpireName"];
    
    
    NSMutableDictionary *UmpireDict2=[[NSMutableDictionary alloc]init];
    [UmpireDict2 setValue:umpire2code forKey:@"AppealumpireCode"];
    [UmpireDict2 setValue:umpire2name forKey:@"AppealumpireName"];
    
      AppealUmpireArray=[[NSMutableArray alloc]initWithObjects:UmpireDict1,UmpireDict2 ,nil];
    
    
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
    
     isTargetReached = (fetchSEPageLoadRecord.RUNSREQUIRED.intValue<=0 && [fetchSEPageLoadRecord.INNINGSNO intValue]==4)?YES:NO;
    
    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    self.sideBar.sideBarWidth = 200;
    self.sideBar.delegate = self;
    self.sideBar.tag = 0;
    
    // Create Right SideBar
    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
    self.rightSideBar.delegate = self;
    self.rightSideBar.translucentStyle = UIBarStyleBlack;
    self.rightSideBar.tag = 1;
    
    RightsideGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRightside:)];
    [RightsideGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:RightsideGesture];
    
    LeftsideGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeftside:)];
    [LeftsideGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:LeftsideGesture];
    
    
    
    self.sideviewXposition.constant =-300;
    self.commonViewXposition.constant=0;
    self.commonViewwidthposition.constant =self.view.frame.size.width;
    
    
    UITableView *tableView = [[UITableView alloc] init];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    v.backgroundColor = [UIColor clearColor];
    [tableView setTableHeaderView:v];
    [tableView setTableFooterView:v];
    
    //If you create UITableViewController and set datasource or delegate to it, don't forget to add childcontroller to this viewController.
    //[[self addChildViewController: @"your view controller"];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    
    _View_Appeal.hidden=YES;
    _view_table_select.hidden=YES;
    _AppealValuesArray=[[NSMutableArray alloc]init];
    _AppealValuesArray =[DBManager AppealRetrieveEventData];
    //_rightSlideArray = rightSideVc.rightSlideArray;
    leftSlideSwipe = NO;
    
    //OTW and RTW
    _otwRtwArray = [[NSMutableArray alloc]init];
    _otwRtwArray = [DBManager getOtwRtw];
    
    
    
    //RBW and Misc Filters
    
    
    
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
    
    
    
    
    [self.comments_txt.layer setBorderWidth:2.0];
    [self.comments_txt.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.comments_txt .layer setMasksToBounds:YES];
    //[_tanle_umpirename setHidden:YES];
    // AppealBatsmenArray=[[NSMutableArray alloc]initWithObjects:@"ADITYA TARE" ,nil];
    
    self.view_bowlType.hidden = YES;
    self.view_fastBowl.hidden = YES;
    self.view_aggressiveShot.hidden = YES;
    self.view_defensive.hidden = YES;
    [self.view_BallTicker setBackgroundColor:[UIColor colorWithRed:0
                                                             green:0
                                                              blue:0
                                                             alpha:0.36]];
    
    int inningsno =[fetchSEPageLoadRecord.INNINGSNO intValue];
    if(inningsno > 1)
    {
        _rightSlideArray = [[NSMutableArray alloc]initWithObjects:@"BREAK",@"CHANGE TEAM",@"DECLARE INNINGS",@"END DAY",@"END INNINGS",@"END SESSION",@"FOLLOW ON",@"PLAYING XI EDIT",@"MATCH RESULTS",@"OTHER WICKETS",@"PENALTY",@"POWER PLAY",@"REVISED OVERS",@"REVISED TARGET", nil];
        
    }
    else{
        _rightSlideArray = [[NSMutableArray alloc]initWithObjects:@"BREAK",@"CHANGE TOSS",@"DECLARE INNINGS",@"END DAY",@"END INNINGS",@"END SESSION",@"FOLLOW ON",@"PLAYING XI EDIT",@"MATCH RESULTS",@"OTHER WICKETS",@"PENALTY",@"POWER PLAY",@"REVISED OVERS",@"REVISED TARGET", nil];
    }

    
//    FETCHSEBALLCODEDETAILS *fetchSeBallCodeDetails;
//    fetchSeBallCodeDetails = [[FETCHSEBALLCODEDETAILS alloc]init];
//    [fetchSeBallCodeDetails FetchSEBallCodeDetails:self.competitionCode :self.matchCode :self.editBallCode];
    
}




-(void) loadViewOnEditMode{
    
    self.btn_StartOver.userInteractionEnabled = NO;
    self.btn_StartBall.userInteractionEnabled = YES;
    
    [self.btn_StartBall setTitle:@"END BALL" forState:UIControlStateNormal];
    self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
    
    [self disableButtonBg :self.btn_StartOver];
    
    FETCHSEBALLCODEDETAILS *fetchSeBallCodeDetails;
    fetchSeBallCodeDetails = [[FETCHSEBALLCODEDETAILS alloc]init];
    [fetchSeBallCodeDetails FetchSEBallCodeDetails:self.competitionCode :self.matchCode :self.editBallCode];
    
    
    //Wicket
    NSMutableArray *getWickets = [fetchSeBallCodeDetails GetWicketEventDetailsArray];
    if(getWickets.count>0){
        [self selectedViewBg:_btn_wkts];
        
        GetSEWicketDetailsForWicketEvents *record = [getWickets objectAtIndex:0];
        selectedWicketEvent = record.WICKETEVENT;
        
        
        selectedwickettype = [[WicketTypeRecord alloc]init];
        selectedwickettype.metasubcode = record.WICKETTYPE;
        
        selectedWicketPlayerCode = record.WICKETPLAYER;
        selectedwicketBowlerlist = [[BowlerEvent alloc]init];
        selectedwicketBowlerlist.BowlerCode = record.FIELDINGPLAYER;
        
        
        
    }
    
    //Appeals
    NSMutableArray *getAppealArray = [fetchSeBallCodeDetails GetAppealDetailsForAppealEventsArray];
    if(getAppealArray.count>0){
        GetSEAppealDetailsForAppealEvents *record = [[GetSEAppealDetailsForAppealEvents alloc]init];
        appealEventDict = [NSMutableDictionary dictionary];
        [appealEventDict setValue:record.APPEALSYSTEMCODE forKey:@"AppealSystemSelct"];
        [appealEventDict setValue:record.APPEALCOMPONENTCODE forKey:@"AppealComponentSelct"];
        [appealEventDict setValue:record.UMPIRECODE forKey:@"AppealUmpireSelct"];
        [appealEventDict setValue:record.BATSMANCODE forKey:@"AppealBatsmenSelct"];
        [appealEventDict setValue:record.BOWLERNAME forKey:@"AppealBowlerSelect"];
        [appealEventDict setValue:record.APPEALCOMMENTS forKey:@"Commenttext"];
        [appealEventDict setValue:record.APPEALTYPECODE forKey:@"AppealTypeCode"];
        
        
    }
    // GetSEAppealDetailsForAppealEvents
    //Penalty
    //GetSEPenaltyDetailsForPenaltyEvents
    
    //Fielding
    NSMutableArray *fieldingFactorArray = [fetchSeBallCodeDetails getFieldingFactorArray];
    if(fieldingFactorArray.count>0){
        
        
        selectedNRS = [fieldingFactorArray objectAtIndex:4];
        
        selectedfieldPlayer = [[BowlerEvent alloc]init];
        selectedfieldPlayer.BowlerCode =  [fieldingFactorArray objectAtIndex:0];
        selectedfieldPlayer.BowlerName =  [fieldingFactorArray objectAtIndex:1];
        
        selectedfieldFactor = [[FieldingFactorRecord alloc]init];
        selectedfieldFactor.fieldingfactorcode = [fieldingFactorArray objectAtIndex:3];
        
    }
    
    
    //Set data for Fetch SE page load
    fetchSEPageLoadRecord = [[FetchSEPageLoadRecord alloc]init];
    
    //Batting and bowling players
    fetchSEPageLoadRecord.getBattingTeamPlayers = fetchSeBallCodeDetails.GetBattingTeamPlayersArray;
    fetchSEPageLoadRecord.getBowlingTeamPlayers = fetchSeBallCodeDetails.GetBowlingTeamPlayersArray;
    
    NSMutableArray *strickerArray = fetchSeBallCodeDetails.currentStrickerDetail;
    NSMutableArray *nonstrickerArray = fetchSeBallCodeDetails.currentNonStrickerDetail;
    
    NSMutableArray *bowlerArray = fetchSeBallCodeDetails.currentbowlerDetail;
    
    //Current Striker
    if(strickerArray.count>0){
        GetSEStrikerDetailsForBallEvents *record = [strickerArray objectAtIndex:0];
        fetchSEPageLoadRecord.strickerPlayerName = record.PLAYERNAME;
        fetchSEPageLoadRecord.strickerTotalRuns = record.TOTALRUNS;
        fetchSEPageLoadRecord.strickerTotalBalls = fetchSeBallCodeDetails.STRIKERBALLS;
        fetchSEPageLoadRecord.strickerSixes = record.SIXES;
        fetchSEPageLoadRecord.strickerStrickRate = record.STRIKERATE;
        fetchSEPageLoadRecord.strickerFours = record.FOURS;
        fetchSEPageLoadRecord.strickerPlayerCode = record.PLAYERCODE;
        
    }
    
    //Non Striker Details
    if(nonstrickerArray.count>0){
        
        
        GetSENonStrikerDetailsForBallEvents *record = [nonstrickerArray objectAtIndex:0];
        fetchSEPageLoadRecord.nonstrickerPlayerName = record.PLAYERNAME;
        fetchSEPageLoadRecord.nonstrickerTotalRuns= record.TOTALRUNS;
        fetchSEPageLoadRecord.nonstrickerTotalBalls= fetchSeBallCodeDetails.NONSTRIKERBALLS;
        fetchSEPageLoadRecord.nonstrickerFours= record.FOURS;
        fetchSEPageLoadRecord.nonstrickerSixes= record.SIXES;
        fetchSEPageLoadRecord.nonstrickerStrickRate= record.STRIKERATE;
        fetchSEPageLoadRecord.nonstrickerPlayerCode = record.PLAYERCODE;
        
    }
    
    if(bowlerArray.count>0){
        GetSEBowlerDetailsForBallEvents *record = [bowlerArray objectAtIndex:0];
        
        fetchSEPageLoadRecord.currentBowlerPlayerName = record.BOWLERNAME;
        fetchSEPageLoadRecord.currentBowlerOver = record.OVERS;
        fetchSEPageLoadRecord.currentBowlerMaidan = fetchSeBallCodeDetails.MAIDENS;
        fetchSEPageLoadRecord.currentBowlerRuns = record.TOTALRUNS;
        fetchSEPageLoadRecord.currentBowlerWicket = fetchSeBallCodeDetails.WICKETS;
        fetchSEPageLoadRecord.currentBowlerEcoRate = record.ECONOMY;
        fetchSEPageLoadRecord.currentBowlerPlayerCode = record.BOWLERCODE;
        
    }
    
    
    //team score details display
    fetchSEPageLoadRecord.BATTEAMSHORTNAME = fetchSeBallCodeDetails.BATTEAMSHORTNAME;
    fetchSEPageLoadRecord.BOWLTEAMSHORTNAME = fetchSeBallCodeDetails.BOWLTEAMSHORTNAME;
    
    fetchSEPageLoadRecord.BATTEAMRUNS =fetchSeBallCodeDetails.BATTEAMRUNS.integerValue;
    fetchSEPageLoadRecord.BATTEAMWICKETS =fetchSeBallCodeDetails.BATTEAMWICKETS.integerValue;
    
    fetchSEPageLoadRecord.BATTEAMOVERS =fetchSeBallCodeDetails.BATTEAMOVERS.integerValue;
    fetchSEPageLoadRecord.BATTEAMOVRBALLS =fetchSeBallCodeDetails.BATTEAMOVRBALLS.integerValue;
    
    fetchSEPageLoadRecord.BATTEAMRUNRATE  =fetchSeBallCodeDetails.BATTEAMRUNRATE;
    fetchSEPageLoadRecord.RUNSREQUIRED =fetchSeBallCodeDetails.RUNSREQUIRED;
    
    
    //ALL Innings Details
    fetchSEPageLoadRecord.MATCHDATE = fetchSeBallCodeDetails.MATCHDATE;
    fetchSEPageLoadRecord.FIRSTINNINGSTOTAL = fetchSeBallCodeDetails.FIRSTINNINGSTOTAL;
    fetchSEPageLoadRecord.SECONDINNINGSTOTAL = fetchSeBallCodeDetails.SECONDINNINGSTOTAL;
    fetchSEPageLoadRecord.THIRDINNINGSTOTAL = fetchSeBallCodeDetails.THIRDINNINGSTOTAL;
    fetchSEPageLoadRecord.FOURTHINNINGSTOTAL = fetchSeBallCodeDetails.FOURTHINNINGSTOTAL;
    fetchSEPageLoadRecord.FIRSTINNINGSWICKET = fetchSeBallCodeDetails.FIRSTINNINGSWICKET;
    fetchSEPageLoadRecord.SECONDINNINGSWICKET = fetchSeBallCodeDetails.SECONDINNINGSWICKET;
    fetchSEPageLoadRecord.THIRDINNINGSWICKET = fetchSeBallCodeDetails.THIRDINNINGSWICKET;
    fetchSEPageLoadRecord.FOURTHINNINGSWICKET = fetchSeBallCodeDetails.FOURTHINNINGSWICKET;
    fetchSEPageLoadRecord.FIRSTINNINGSSCORE = fetchSeBallCodeDetails.FIRSTINNINGSOVERS;
    fetchSEPageLoadRecord.SECONDINNINGSSCORE = fetchSeBallCodeDetails.SECONDINNINGSSCORE;
    fetchSEPageLoadRecord.THIRDINNINGSSCORE = fetchSeBallCodeDetails.THIRDINNINGSSCORE;
    fetchSEPageLoadRecord.FOURTHINNINGSSCORE = fetchSeBallCodeDetails.FOURTHINNINGSSCORE;
    fetchSEPageLoadRecord.FIRSTINNINGSOVERS = fetchSeBallCodeDetails.FIRSTINNINGSOVERS;
    fetchSEPageLoadRecord.SECONDINNINGSOVERS = fetchSeBallCodeDetails.SECONDINNINGSOVERS;
    fetchSEPageLoadRecord.THIRDINNINGSOVERS = fetchSeBallCodeDetails.THIRDINNINGSOVERS;
    fetchSEPageLoadRecord.FOURTHINNINGSOVERS = fetchSeBallCodeDetails.FOURTHINNINGSOVERS;
    fetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME = fetchSeBallCodeDetails.FIRSTINNINGSSHORTNAME;
    fetchSEPageLoadRecord.SECONDINNINGSSHORTNAME = fetchSeBallCodeDetails.SECONDINNINGSSHORTNAME;
    fetchSEPageLoadRecord.THIRDINNINGSSHORTNAME = fetchSeBallCodeDetails.THIRDINNINGSSHORTNAME;
    fetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME = fetchSeBallCodeDetails.FOURTHINNINGSSHORTNAME;
    fetchSEPageLoadRecord.AA = fetchSeBallCodeDetails.AA;
    fetchSEPageLoadRecord.BB = fetchSeBallCodeDetails.BB;
    fetchSEPageLoadRecord.AAWIC = fetchSeBallCodeDetails.AAWIC;
    fetchSEPageLoadRecord.BBWIC = fetchSeBallCodeDetails.BBWIC;
    
    //Team Details
    
    fetchSEPageLoadRecord.BATTINGTEAMCODE = fetchSeBallCodeDetails.BATTINGTEAMCODE;
    fetchSEPageLoadRecord.INNINGSNO = fetchSeBallCodeDetails.INNINGSNO;
    fetchSEPageLoadRecord.SESSIONNO = fetchSeBallCodeDetails.SESSIONNO;
    fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT = fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT;
    
    
    
    
    GetBallDetailsForBallEventsBE *getBallDetailsForBallEventsBE =[fetchSeBallCodeDetails.GetBallDetailsForBallEventsArray objectAtIndex:0];
    
    
    self.ballEventRecord = [[BallEventRecord alloc] init];
    self.ballEventRecord.objTeamcode =getBallDetailsForBallEventsBE.TEAMCODE;
    
    self.ballEventRecord.objOverno=getBallDetailsForBallEventsBE.OVERNO;
    self.ballEventRecord.objBallno=getBallDetailsForBallEventsBE.BALLNO;
    self.ballEventRecord.objOverBallcount = getBallDetailsForBallEventsBE.BALLCOUNT;
    self.ballEventRecord.objBallcount=getBallDetailsForBallEventsBE.BALLCOUNT;;
    self.ballEventRecord.objBowlercode = getBallDetailsForBallEventsBE.BOWLERCODE;
    self.ballEventRecord.objStrikercode = getBallDetailsForBallEventsBE.STRIKERCODE;
    self.ballEventRecord.objNonstrikercode = getBallDetailsForBallEventsBE.NONSTRIKERCODE;
    self.ballEventRecord.objRbw =getBallDetailsForBallEventsBE.RBW;
    self.ballEventRecord.objIswtb=getBallDetailsForBallEventsBE.ISWTB;
    self.ballEventRecord.objIsuncomfort=getBallDetailsForBallEventsBE.ISUNCOMFORT;
    self.ballEventRecord.objIsreleaseshot=getBallDetailsForBallEventsBE.ISRELEASESHOT;
    self.ballEventRecord.objIsbeaten=getBallDetailsForBallEventsBE.ISBEATEN;
    self.ballEventRecord.objPMlengthcode=getBallDetailsForBallEventsBE.PMLENGTHCODE;
    self.ballEventRecord.objPMlinecode =getBallDetailsForBallEventsBE.PMLINECODE;
    self.ballEventRecord.objPMX1=getBallDetailsForBallEventsBE.PMX1;
    self.ballEventRecord.objPMY1=getBallDetailsForBallEventsBE.PMY1;
    self.ballEventRecord.objPMX2=getBallDetailsForBallEventsBE.PMX2;
    self.ballEventRecord.objPMY2=getBallDetailsForBallEventsBE.PMY2;
    self.ballEventRecord.objcompetitioncode =getBallDetailsForBallEventsBE.COMPETITIONCODE;
    
    self.ballEventRecord.objmatchcode =getBallDetailsForBallEventsBE.MATCHCODE;
    self.ballEventRecord.objInningsno =getBallDetailsForBallEventsBE.INNINGSNO;
    self.ballEventRecord.objSessionno =getBallDetailsForBallEventsBE.SESSIONNO;
    
    self.ballEventRecord.objWicketkeepercode =getBallDetailsForBallEventsBE.WICKETKEEPERCODE;
    self.ballEventRecord.objUmpire1code =getBallDetailsForBallEventsBE.UMPIRE1CODE;
    self.ballEventRecord.objUmpire2code =getBallDetailsForBallEventsBE.UMPIRE2CODE;
    self.ballEventRecord.objAtworotw =getBallDetailsForBallEventsBE.ATWOROTW;
    self.ballEventRecord.objBowlingEnd =getBallDetailsForBallEventsBE.BOWLINGEND;
    //self.ballEventRecord.bow =getBallDetailsForBallEventsBE.BOWLTYPECODE;
    
    self.ballEventRecord.objBowltype =getBallDetailsForBallEventsBE.BOWLTYPECODE;
    //self.ballEventRecord.bow =getBallDetailsForBallEventsBE.BOWLERTYPE;
    //self.ballEventRecord.objShottype =getBallDetailsForBallEventsBE.SHOTCODE;
    //self.ballEventRecord.objInningsno =getBallDetailsForBallEventsBE.SHOTNAME;
    self.ballEventRecord.objShottype =getBallDetailsForBallEventsBE.SHOTCODE;
    self.ballEventRecord.objShorttypecategory =getBallDetailsForBallEventsBE.SHOTTYPECATEGORY;
    self.ballEventRecord.objIslegalball =getBallDetailsForBallEventsBE.ISLEGALBALL;
    self.ballEventRecord.objIsFour =getBallDetailsForBallEventsBE.ISFOUR;
    
    self.ballEventRecord.objIssix =getBallDetailsForBallEventsBE.ISSIX;
    self.ballEventRecord.objRuns =getBallDetailsForBallEventsBE.RUNS;
    self.ballEventRecord.objOverthrow =getBallDetailsForBallEventsBE.OVERTHROW;
    self.ballEventRecord.objTotalruns =getBallDetailsForBallEventsBE.TOTALRUNS;
    self.ballEventRecord.objWide =getBallDetailsForBallEventsBE.WIDE;
    self.ballEventRecord.objNoball =getBallDetailsForBallEventsBE.NOBALL;
    self.ballEventRecord.objByes =getBallDetailsForBallEventsBE.BYES;
    self.ballEventRecord.objLegByes =getBallDetailsForBallEventsBE.LEGBYES;
    self.ballEventRecord.objPenalty =getBallDetailsForBallEventsBE.PENALTY;
    self.ballEventRecord.objTotalextras =getBallDetailsForBallEventsBE.TOTALEXTRAS;
    self.ballEventRecord.objGrandtotal =getBallDetailsForBallEventsBE.GRANDTOTAL;
    self.ballEventRecord.objPMStrikepoint =getBallDetailsForBallEventsBE.PMSTRIKEPOINT;
    self.ballEventRecord.objPMStrikepointlinecode =getBallDetailsForBallEventsBE.PMSTRIKEPOINTLINECODE;
    self.ballEventRecord.objWWREGION =getBallDetailsForBallEventsBE.WWREGION;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.REGIONNAME;
    self.ballEventRecord.objWWX1 =getBallDetailsForBallEventsBE.WWX1;
    self.ballEventRecord.objWWY1 =getBallDetailsForBallEventsBE.WWY1;
    self.ballEventRecord.objWWX2 =getBallDetailsForBallEventsBE.WWX2;
    self.ballEventRecord.objWWY2 =getBallDetailsForBallEventsBE.WWY2;
    self.ballEventRecord.objballduration =getBallDetailsForBallEventsBE.BALLDURATION;
    self.ballEventRecord.objIsappeal =getBallDetailsForBallEventsBE.ISAPPEAL;
    self.ballEventRecord.objUncomfortclassification =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFCATION;
    self.ballEventRecord.objMarkedforedit =getBallDetailsForBallEventsBE.MARKEDFOREDIT;
    self.ballEventRecord.objRemark =getBallDetailsForBallEventsBE.REMARKS;
    self.ballEventRecord.objBallspeed =getBallDetailsForBallEventsBE.BALLSPEED;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.BALLSPEEDTYPE;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.BALLSPEEDCODE;
    self.ballEventRecord.objUncomfortclassification =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFICATION;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFICATIONCODE;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFICATIONSUBCODE;
    
    
    
    
    
    
    //OTW and RTW
    
    if([self.ballEventRecord.objAtworotw isEqual:@"MSC148"]){
        [self selectedViewBg:_view_otw];
    }else if([self.ballEventRecord.objAtworotw isEqual:@"MSC149"]){
        [self selectedViewBg:_view_rtw];
    }
    
    //Misc filter
    if(self.ballEventRecord.objIsbeaten.intValue == 1 || self.ballEventRecord.objIsuncomfort.intValue == 1 || self.ballEventRecord.objIsreleaseshot.intValue == 1 || self.ballEventRecord.objIswtb.intValue == 1){
        [self selectedViewBg:_btn_miscFilter];
    }
    
    //    //Extras
    //    if(self.ballEventRecord.objNoball.intValue == 1 || self.ballEventRecord.objWide.intValue == 1 || self.ballEventRecord.objByes.intValue == 1 || self.ballEventRecord.objLegByes.intValue == 1){
    //        [self selectedViewBg:_btn_extras];
    //    }
    
    //Appeal
    if(self.ballEventRecord.objIsappeal.intValue == 1){
        [self selectedViewBg:_view_appeal];
        
        
        
    }
    
    //Remark
    if(self.ballEventRecord.objRemark!=nil && ![self.ballEventRecord.objRemark isEqual:@""]){
        [self selectedViewBg:_view_remark];
    }
    
    //Overthrow
    if(self.ballEventRecord.objOverthrow.intValue >0){
        [self selectedViewBg:_btn_overthrow];
        //isOverthrowSelected = YES;
        
    }
    
    
    //Wagon wheel
    
    if(!(self.ballEventRecord.objWWX1.intValue ==221 && self.ballEventRecord.objWWX2.intValue ==221 && self.ballEventRecord.objWWY1.intValue ==186 && self.ballEventRecord.objWWY2.intValue ==186) && !(self.ballEventRecord.objWWX1.intValue ==172 && self.ballEventRecord.objWWX2.intValue ==172 && self.ballEventRecord.objWWY1.intValue ==145 && self.ballEventRecord.objWWY2.intValue ==145)){
        
        [self selectedViewBg:_btn_wagonwheel];
        
        for (CALayer *layer in self.img_WagonWheel.layer.sublayers) {
            if ([layer.name isEqualToString:@"DrawLine"]) {
                [layer removeFromSuperlayer];
                break;
            }
        }
        
        CGMutablePathRef straightLinePath = CGPathCreateMutable();
        CGPathMoveToPoint(straightLinePath, NULL, self.ballEventRecord.objWWX1.intValue, self.ballEventRecord.objWWY1.intValue);
        CGPathAddLineToPoint(straightLinePath, NULL,self.ballEventRecord.objWWX2.intValue,self.ballEventRecord.objWWY2.intValue);
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = straightLinePath;
        UIColor *fillColor = [UIColor redColor];
        shapeLayer.fillColor = fillColor.CGColor;
        UIColor *strokeColor = [UIColor redColor];
        shapeLayer.strokeColor = strokeColor.CGColor;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.fillRule = kCAFillRuleNonZero;
        shapeLayer.name = @"DrawLine";
        [self.img_WagonWheel.layer addSublayer:shapeLayer];
        
    }
    
    
    //Pitch map
    
    if(!(self.ballEventRecord.objPMX2.intValue == 1 && self.ballEventRecord.objPMY2.intValue ==1)){
        [self selectedViewBg:_btn_pichmap];
        if(Img_ball != nil)
        {
            [Img_ball removeFromSuperview];
        }
        
        Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(self.ballEventRecord.objPMX2.floatValue,self.ballEventRecord.objPMY2.floatValue,20, 20)];
        Img_ball.image =[UIImage imageNamed:@"RedBall"];
        [self.img_pichmap addSubview:Img_ball];
        self.img_pichmap.hidden = YES;
    }
    
    
    
    
    
    //    //Short type
    //
    //    if ([ getBallDetailsForBallEventsBE.BOWLERTYPE isEqual: @"MSC005"])//Aggressive
    //    {
    //        [self selectedViewBg:_view_aggressive];
    //    }
    //    else if ([ self.ballEventRecord.objShottype isEqual:  @"MSC006"])//Defensive
    //    {
    //        [self selectedViewBg:_view_defensive];
    //    }
    //
    //
    //    //Bowl type
//        if ([ self.ballEventRecord.objBowltype isEqual: @"MSC015"])//Fast
//        {
//           [self selectedViewBg:_view_fast];
//        }
//        else if ([ self.ballEventRecord.objBowltype isEqual: @"MSC016"])//Spin
//        {
//           [self selectedViewBg:_view_spin];
//        }
    
    
    
    //Mark for edit
    if(self.ballEventRecord.objMarkedforedit.integerValue == 1){
        [self selectedViewBg:_view_medit];
    }
    
    //Runs
    
    int runs =0;
    
    if (self.ballEventRecord.objNoball.intValue !=0)
    {
        if (self.ballEventRecord.objNoball.intValue > 1 && self.ballEventRecord.objRuns.intValue == 0)
        {
            self.ballEventRecord.objNoball.intValue;
            if (self.ballEventRecord.objNoball.intValue - 1 == 1)
                [self selectedViewBg:_btn_run1];
            else if (self.ballEventRecord.objNoball.intValue  - 1 == 2)
                [self selectedViewBg:_btn_run2];
            else if (self.ballEventRecord.objNoball.intValue  - 1 == 3)
                [self selectedViewBg:_btn_run3];
            //self.ballEventRecord.objRuns = [NSNumber numberWithInt: self.ballEventRecord.objNoball.intValue  - 1];
            runs = self.ballEventRecord.objNoball.intValue  - 1;
        }
        [self selectedViewBg:_btn_extras];
        //isExtrasSelected = YES;
        self.ballEventRecord.objIslegalball = [NSNumber numberWithInt: 0];
    }
    if (self.ballEventRecord.objWide.intValue !=0)
    {
        [self selectedViewBg: _btn_extras];
        // isExtrasSelected = YES;
        self.ballEventRecord.objIslegalball = [NSNumber numberWithInt: 0];
        
        if (self.ballEventRecord.objWide.intValue  > 1 && self.ballEventRecord.objRuns.intValue == 0)
        {
            self.ballEventRecord.objWide = [NSNumber numberWithInt: self.ballEventRecord.objWide.intValue - self.ballEventRecord.objOverthrow.intValue];
            if (self.ballEventRecord.objWide.intValue  - 1 == 1)
                [self selectedViewBg: _btn_run1];
            else if (self.ballEventRecord.objWide.intValue  - 1 == 2)
                [self selectedViewBg:_btn_run2];
            else if (self.ballEventRecord.objWide.intValue  - 1 == 3)
                [self selectedViewBg:_btn_run3];
            //self.ballEventRecord.objRuns = [NSNumber numberWithInt: self.ballEventRecord.objWide.intValue  - 1];
            runs = self.ballEventRecord.objWide.intValue  - 1;
        }
        
        
        [self disableButtonBg :_btn_B4];
        _btn_B4.userInteractionEnabled = NO;
        [self disableButtonBg :_btn_B6];
        _btn_B6.userInteractionEnabled = NO;
        
        //btnLB.Opacity = 0.4;
        //btnLB.IsEnabled = false;
    }
    
    if (self.ballEventRecord.objLegByes.intValue !=0)
    {
        [self selectedViewBg: _btn_extras];
        //isExtrasSelected = YES;
        if (self.ballEventRecord.objLegByes.intValue  > 0 && self.ballEventRecord.objRuns.intValue  == 0)
        {
            // self.ballEventRecord.objRuns = [NSNumber numberWithInt:self.ballEventRecord.objLegByes.intValue - self.ballEventRecord.objOverthrow.intValue];
            runs =  self.ballEventRecord.objLegByes.intValue - self.ballEventRecord.objOverthrow.intValue;
            if (runs == 1)
                [self selectedViewBg:_btn_run1];
            else if (runs == 2)
                [self selectedViewBg:_btn_run2];
            else if (runs == 3)
                [self selectedViewBg:_btn_run3];
        }
        [self disableButtonBg :_btn_B6];
        _btn_B6.userInteractionEnabled = NO;
        
    }
    
    if (self.ballEventRecord.objByes.intValue !=0)
    {
        [self selectedViewBg: _btn_extras];
        // isExtrasSelected = YES;
        if (self.ballEventRecord.objByes.intValue > 0 && self.ballEventRecord.objRuns.intValue == 0)
        {
            //self.ballEventRecord.objRuns = [NSNumber numberWithInt: self.ballEventRecord.objByes.intValue - self.ballEventRecord.objOverthrow.intValue];
            runs = self.ballEventRecord.objByes.intValue - self.ballEventRecord.objOverthrow.intValue;
            if (runs == 1)
                [self selectedViewBg:_btn_run1];
            else if (runs == 2)
                [self selectedViewBg:_btn_run2];
            else if (runs == 3)
                [self selectedViewBg:_btn_run3];
        }
        [self disableButtonBg :_btn_B6];
        _btn_B6.userInteractionEnabled = NO;
    }
    
    if (self.ballEventRecord.objIsFour.intValue ==1)
    {
        [self selectedViewBg: _btn_B4];
        self.ballEventRecord.objIsFour = [NSNumber numberWithInt: 1];
        if (self.ballEventRecord.objByes.intValue <= 0 && self.ballEventRecord.objLegByes.intValue <= 0)
            //                Runs = int.Parse(drballdetails["RUNS"].ToString());
            
            [self disableButtonBg : _btn_overthrow];
        _btn_overthrow.userInteractionEnabled = NO;
        
    }
    else if (self.ballEventRecord.objIssix.intValue ==1)
    {
        
        [self selectedViewBg: _btn_B6];
        //isExtrasSelected = YES;
        
        self.ballEventRecord.objIssix = [NSNumber numberWithInt: 1];
        
        [self disableButtonBg : _btn_overthrow];
        _btn_overthrow.userInteractionEnabled = NO;
        //            btnWD.Opacity = 0.4;
        //            btnWD.IsEnabled = false;
        //            btnB.Opacity = 0.4;
        //            btnB.IsEnabled = false;
        //            btnLB.Opacity = 0.4;
        //            btnLB.IsEnabled = false;
        
    }
    else
    {
        if (self.ballEventRecord.objRuns.intValue == 1)
            [self selectedViewBg:_btn_run1];
        else if (self.ballEventRecord.objRuns.intValue == 2)
            [self selectedViewBg:_btn_run2];
        else if (self.ballEventRecord.objRuns.intValue == 3)
            [self selectedViewBg:_btn_run3];
        
        runs = runs + self.ballEventRecord.objRuns.intValue;
        
        if (runs > 3)
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
            
            if (runs == 4)
                [self selectedViewBg:_btn_run1];
            else if (runs == 5)
                [self selectedViewBg:_btn_run2];
            else if (runs == 6)
                [self selectedViewBg:_btn_run3];
            else if (runs == 7)
                [self selectedViewBg:_btn_B4];
            else if (runs == 8)
                [self selectedViewBg:_btn_B6];
            
        }
        
    }
    self.ballEventRecord.objRuns = [NSNumber numberWithInt:runs];
    
    
    //RBW
    if(self.ballEventRecord.objRbw.integerValue!=0){
        [self selectedViewBg:_view_Rbw];
    }
    
    //Spin
    if ([getBallDetailsForBallEventsBE.BOWLERTYPE isEqual: @"MSC015"])//Fast
    {
        [self selectedViewBg:_view_fast];
        isFastSelected = YES;
    }
    else if ([getBallDetailsForBallEventsBE.BOWLERTYPE isEqual: @"MSC016"])//Spin
    {
        [self selectedViewBg:_view_spin];
        isSpinSelected = YES;
    }
    
    
    if ([getBallDetailsForBallEventsBE.SHOTTYPE isEqual: @"MSC005"])//Aggressive
    {
        [self selectedViewBg:_view_aggressive];
        isAggressiveSelected = YES;
        
    }
    else if ([getBallDetailsForBallEventsBE.SHOTTYPE isEqual: @"MSC006"])//Defensive
    {
        [self selectedViewBg:_view_defense];
        isDefensiveSelected = YES;
        
    }
    
    
    
    //Free hit dialog
    if(fetchSeBallCodeDetails.ISFREEHIT.intValue ==1){
        
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Free Hit Ball" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
        [alter setTag:10000];
    }
    
    
    //Striker Details
    self.lbl_stricker_name.text = fetchSEPageLoadRecord.strickerPlayerName;
    self.lbl_stricker_runs.text = fetchSEPageLoadRecord.strickerTotalRuns;
    self.lbl_stricker_balls.text = fetchSEPageLoadRecord.strickerTotalBalls;
    self.lbl_stricker_sixs.text = fetchSEPageLoadRecord.strickerSixes;
    self.lbl_stricker_strickrate.text = fetchSEPageLoadRecord.strickerStrickRate;
    self.lbl_stricker_fours.text = fetchSEPageLoadRecord.strickerFours;
    self.BatmenStyle = fetchSEPageLoadRecord.strickerBattingStyle;
    
    //Non Striker Details
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
    
    _lbl_overs.text = [NSString stringWithFormat:@"%d.%d OVS" ,fetchSEPageLoadRecord.BATTEAMOVERS,fetchSEPageLoadRecord.BATTEAMOVRBALLS];
    
//    _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue], [fetchSEPageLoadRecord.RUNSREQUIRED floatValue]];
//    
    if(fetchSEPageLoadRecord.INNINGSNO.intValue>1){
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue], [fetchSEPageLoadRecord.REQRUNRATE floatValue]];
    }else{
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue]];
    }
    
    
    
    //all innings details for team A and team B
    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.SECONDINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSTOTAL,fetchSEPageLoadRecord.SECONDINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSWICKET];
    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.SECONDINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSOVERS];
    
    
    _lbl_teamASecIngsScore.text = @"";
    _lbl_teamASecIngsOvs.text = @"";
    
    
    _lbl_teamBSecIngsScore.text =@"";
    _lbl_teamBSecIngsOvs.text =@"";
    
    _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",fetchSEPageLoadRecord.FIRSTINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSTOTAL,fetchSEPageLoadRecord.FIRSTINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSWICKET];
    _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FIRSTINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSOVERS];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    // self.btn_StartBall.userInteractionEnabled=NO;
    
    
    
    
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





-(void)displaystrickerdetailsmethod
{
    fetchSEPageLoadRecord = [[FetchSEPageLoadRecord alloc]init];
    
    [fetchSEPageLoadRecord fetchSEPageLoadDetails:self.competitionCode :self.matchCode];
    
    //    FetchLastBallBowledPlayer *fetchLastBallBowledPlayer = [[FetchLastBallBowledPlayer alloc]init];
    
    
    //Get Last bowler details
    fetchLastBowler = [[FetchLastBowler alloc]init];
    
    NSLog(@"displaystrickerdetailsmethod batteamover=%d",fetchSEPageLoadRecord.BATTEAMOVERS);
    
    [fetchLastBowler LastBowlerDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.INNINGSNO :[NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVERS] : [NSNumber numberWithInteger:fetchSEPageLoadRecord.BATTEAMOVRBALLS] :[NSNumber numberWithInteger:fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT]];
    
    if(fetchLastBowler.GetLastBolwerDetails.count!=0){
        LastBolwerDetailRecord *lastBowlerDetailRecord = [fetchLastBowler.GetLastBolwerDetails objectAtIndex:0];
        
        
        self.lbl_last_bowler_name.text = lastBowlerDetailRecord.BOWLERNAME;
        self.lbl_last_bowler_runs.text = lastBowlerDetailRecord.OVERS;
        self.lbl_last_bowler_balls.text = lastBowlerDetailRecord.MAIDENOVERS;
        self.lbl_last_bowler_fours.text = lastBowlerDetailRecord.TOTALRUNS;
        self.lbl_last_bowler_sixs.text = lastBowlerDetailRecord.WICKETS;
        self.lbl_last_bowler_strickrate.text = [NSString stringWithFormat:@"%.01f",[lastBowlerDetailRecord.ECONOMY floatValue]];
        
    }else{
        self.lbl_last_bowler_name.text = @"-";
        self.lbl_last_bowler_runs.text = @"-";
        self.lbl_last_bowler_balls.text = @"-";
        self.lbl_last_bowler_fours.text = @"-";
        self.lbl_last_bowler_sixs.text = @"-";
        self.lbl_last_bowler_strickrate.text = @"-";
    }
    
    
    FetchLastBallBowledPlayer *fetchLastBallBowledPlayer = [[FetchLastBallBowledPlayer alloc]init];
    
    
    
    
    //Striker Details
    self.lbl_stricker_name.text = fetchSEPageLoadRecord.strickerPlayerName;
    self.lbl_stricker_runs.text = fetchSEPageLoadRecord.strickerTotalRuns;
    self.lbl_stricker_balls.text = fetchSEPageLoadRecord.strickerTotalBalls;
    self.lbl_stricker_sixs.text = fetchSEPageLoadRecord.strickerSixes;
    self.lbl_stricker_strickrate.text = [NSString stringWithFormat:@"%.01f",[fetchSEPageLoadRecord.strickerStrickRate floatValue]];
    
    self.lbl_stricker_fours.text = fetchSEPageLoadRecord.strickerFours;
    self.BatmenStyle = fetchSEPageLoadRecord.strickerBattingStyle;
    
    //Non Striker Details
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
    fetchSEPageLoadRecord.BATTEAMOVERS = (fetchSEPageLoadRecord.BATTEAMOVERS == nil) ? (int)0 : fetchSEPageLoadRecord.BATTEAMOVERS;
    
    
    
    _lbl_overs.text = [NSString stringWithFormat:@"%d.%d OVS" ,fetchSEPageLoadRecord.BATTEAMOVERS ,fetchSEPageLoadRecord.BATTEAMOVRBALLS];
    
//    _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue], [fetchSEPageLoadRecord.RUNSREQUIRED floatValue]];
    
    if(fetchSEPageLoadRecord.INNINGSNO.intValue>1){
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue], [fetchSEPageLoadRecord.REQRUNRATE floatValue]];
    }else{
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue]];
    }
    
    
    
    
    //all innings details for team A and team B
    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.SECONDINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSTOTAL,fetchSEPageLoadRecord.SECONDINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSWICKET];
    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.SECONDINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSOVERS];
    
    
    _lbl_teamASecIngsScore.text = @"";
    _lbl_teamASecIngsOvs.text = @"";
    
    
    _lbl_teamBSecIngsScore.text =@"";
    _lbl_teamBSecIngsOvs.text =@"";
    
    _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",fetchSEPageLoadRecord.FIRSTINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSTOTAL,fetchSEPageLoadRecord.FIRSTINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSWICKET];
    _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FIRSTINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSOVERS];
    
}
-(void)SaveBallEventREcordvalue
{
    //self.ballEventRecord=[[BallEventRecord alloc]init];
    
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
    NSString * ballCodevalue=[DBManager getballcodemethod:self.matchCode];
    // NSLog(@"array : %@",[ballCodevalueArray lastObject]);
    if(![ballCodevalue isEqualToString: @""])
    {
        
        NSString*ballcode= [NSString stringWithFormat:@"%@",ballCodevalue];
        if([ballcode isEqualToString:@"(null)"])
            
        {
            // [ballCodevalueArray removeLastObject];
            ballcode=[NSString stringWithFormat:@"%@",ballCodevalue];
            // [ballCodevalueArray removeLastObject];
            ballcode=[NSString stringWithFormat:@"%@",ballCodevalue];
        }
        
        
        NSString *code = [ballcode substringFromIndex: [ballcode length] - 10];
        
        NSInteger add =[code intValue];
        add = add+1;
        
        NSString *ballcodeValue = [NSString stringWithFormat:@"%010d",add];
        //NSString * addCode=[NSString stringWithFormat:@"%d",add];
        
        //NSInteger sum = 1000000000;
        
        //sum += [addCode intValue];
        //NSMutableString *addValue;
        //NSString * matchcodeaddValue =[NSString stringWithFormat:@"%d",sum];
        //       NSString* adds = nil;
        //        if([matchcodeaddValue hasPrefix:@"1"]) {
        //            adds = [matchcodeaddValue substringFromIndex:1];
        //           addValue = [NSMutableString stringWithString:adds];
        //            [addValue insertString:@"0" atIndex:1];
        //        }
        
        //NSString* addValue = [matchcodeaddValue stringByReplacingOccurrencesOfString:@"1"
        // withString:@"0"];
        
        
        
        //
        //        NSString * myURL = [NSString stringWithFormat:@"1%@",code];
        //        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        //        f.numberStyle = NSNumberFormatterDecimalStyle;
        //        NSNumber * myNumber = [f numberFromString:myURL];
        //        NSInteger value = [myNumber integerValue]+1;
        //        NSString *addcode = [@(value) stringValue];
        //
        //        NSString * ballno = [addcode substringFromIndex:1];
        
        
        ballnoStr = [self.matchCode stringByAppendingFormat:@"%@",ballcodeValue];
        NSLog(@"array : %@",ballnoStr);
        
        
    }
    else{
        
        
        NSString *ballcodeValue = [NSString stringWithFormat:@"%010d",1];
        
        //NSString * myURL = [NSString stringWithFormat:@"0000000001"];
        //        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        //        f.numberStyle = NSNumberFormatterDecimalStyle;
        //        NSNumber * myNumber = [f numberFromString:myURL];
        //        NSInteger value = [myNumber integerValue];
        //        NSString *ballno1 = [@(value) stringValue];
        //NSString * ballno = [ballno1 substringFromIndex:1];
        ballnoStr = [self.matchCode stringByAppendingFormat:@"%@",ballcodeValue];
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

// End ball process



#pragma mark - Gesture Handler

- (void)handleSwipeFromRightside:(UISwipeGestureRecognizer *)recognizer
{
    
    [UIView animateWithDuration:5.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ self.sideviewXposition.constant =-300;
        self.commonViewXposition.constant=0;
        self.commonViewwidthposition.constant =self.view.frame.size.width;
        leftSlideSwipe = NO;
    } completion:^(BOOL finished){ }];
    
    
}
- (void)handleSwipeFromLeftside:(UISwipeGestureRecognizer *)recognizer
{
    
    self.sideviewXposition.constant =0;
    self.commonViewXposition.constant=300;
    self.commonViewwidthposition.constant =768;
    self.CommonviewRightsideposition.constant =self.view.frame.size.width+300;
    leftSlideSwipe = YES;
    [self.sideviewtable reloadData];
    
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    if(leftSlideSwipe ==NO)
    {
        self.sideviewXposition.constant =0;
        self.commonViewXposition.constant=300;
        self.commonViewwidthposition.constant =768;
        self.CommonviewRightsideposition.constant =self.view.frame.size.width+300;
        leftSlideSwipe = YES;
    }
    else{
        self.sideviewXposition.constant =-300;
        self.commonViewXposition.constant=0;
        self.commonViewwidthposition.constant =self.view.frame.size.width;
        leftSlideSwipe = NO;
    }
    
 
}



// This is just a sample for tableview menu
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(leftSlideSwipe == YES){
        return _rightSlideArray.count;
        
    }
    
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
            self.tbl_fastBowl.separatorStyle = UITableViewCellSeparatorStyleNone;
             [tbl_fastBowl setSeparatorColor:[UIColor blackColor]];
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
            self.tbl_fastBowl.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            self.tbl_fastBowl.separatorStyle = UITableViewCellSeparatorStyleNone;
            return wicketEventCell;
            
            
        }
        if (isWicketSelected && wicketOption == 4){
            
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *playerlistCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                               forIndexPath:indexPath];
            BowlerEvent *objPlayerlistRecord=(BowlerEvent*)[_PlayerlistArray objectAtIndex:indexPath.row];
            playerlistCell.lbl_fastBowl.text = objPlayerlistRecord.BowlerName;
            self.lbl_fast.text=@"Fielders";
            
            // this is where you set your color view
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            playerlistCell.selectedBackgroundView =  customColorView;
            self.tbl_fastBowl.separatorStyle = UITableViewCellSeparatorStyleNone;
            
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
    if(tableView == self.sideviewtable)
    {
        cell.textLabel.text = [self.rightSlideArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
        return cell;
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
    
        
        AppealRecord *objAppealrecord=(AppealRecord*)[self.AppealValuesArray objectAtIndex:indexPath.row];
        
        
        cell.AppealName_lbl.text=objAppealrecord.MetaSubCodeDescriptision;
        
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                          green:161/255.0
                                                           blue:79/255.0
                                                          alpha:0.5];
        cell.selectedBackgroundView =  customColorView;
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
        self.tbl_fastBowl.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
        static NSString *CellIdentifier = @"umpirecell";
        umpiretablecell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
        
        
       _test=[AppealUmpireArray objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text =[_test valueForKey:@"AppealumpireName"];
        
        UmpireSelect=cell.textLabel.text;
        UmpireSelect=[_test valueForKey:@"AppealumpireCode"];
        return cell;
    }
    
    
    
    if (tableView == self.table_BatsmenName)
    {
        static NSString *CellIdentifier = @"Batsmancell";
        Batsmancell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
        
        _test1=[AppealBatsmenArray objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text =[_test1 valueForKey:@"AppealBatsmenPlayerName"];
        
        StrikerPlayer=cell.textLabel.text;
        StrikerPlayer=[_test1 valueForKey:@"AppealBatsmenPlayerCode"];
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

-(BOOL) checkRunsByLB_B{
    
    if(_ballEventRecord.objLegByes.intValue == 1 && _ballEventRecord.objRuns.intValue == 0 && _ballEventRecord.objOverthrow.intValue == 0){
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Legbyes is not possible with out runs" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
        [alter setTag:10100];
        return NO;
    }else if(_ballEventRecord.objByes.intValue == 1 && _ballEventRecord.objRuns.intValue == 0 && _ballEventRecord.objOverthrow.intValue == 0){
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Byes is not possible with out runs" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
        [alter setTag:10101];
        return NO;
    }
    
    return YES;
}

-(BOOL)iswicketPending{
    if(wicketOption !=0){
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Please complete wicket Option" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
        [alter setTag:10102];
        return NO;
        
    }
    return YES;
}

-(IBAction)DidClickStartBall:(id)sender
{
    NSLog(@"btnname=%@",self.btn_StartBall.currentTitle);
    
    if(self.isEditMode){ //Edit Mode
        
        if([self checkRunsByLB_B] && [self iswicketPending]){
        [self calculateRunsOnEndBall];
        
        UpdateScoreEngine *updatescore = [[UpdateScoreEngine alloc]init];
        
        
        [updatescore UpdateScoreEngine :self.editBallCode :
         self.competitionCode :
         self.matchCode :
         fetchSEPageLoadRecord.BATTINGTEAMCODE :
         fetchSEPageLoadRecord.INNINGSNO :
         [NSNumber numberWithInteger:fetchSEPageLoadRecord.BATTEAMOVERS] :
         [NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVRBALLS]  :
         [NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT] :
         fetchSEPageLoadRecord.SESSIONNO :
         fetchSEPageLoadRecord.strickerPlayerCode :
         fetchSEPageLoadRecord.nonstrickerPlayerCode :
         fetchSEPageLoadRecord.currentBowlerPlayerCode:
         ([fetchSEPageLoadRecord.BATTINGTEAMCODE isEqualToString : fetchSEPageLoadRecord.TEAMACODE] ? fetchSEPageLoadRecord.TEAMAWICKETKEEPER : fetchSEPageLoadRecord.TEAMBWICKETKEEPER) :
         @"":
         
         @"":
         self.ballEventRecord.objAtworotw :
         self.ballEventRecord.objBowlingEnd :
         self.ballEventRecord.objBowltype :
         self.ballEventRecord.objShottype :
         self.ballEventRecord.objShorttypecategory :
         self.ballEventRecord.objIslegalball :
         self.ballEventRecord.objIsFour :
         self.ballEventRecord.objIssix :
         self.ballEventRecord.objRuns :
         self.ballEventRecord.objOverthrow :
         self.ballEventRecord.objTotalruns :
         self.ballEventRecord.objWide :
         self.ballEventRecord.objNoball :
         self.ballEventRecord.objByes :
         self.ballEventRecord.objLegByes :
         self.ballEventRecord.objPenalty :
         self.ballEventRecord.objTotalextras :
         self.ballEventRecord.objGrandtotal :
         self.ballEventRecord.objRbw :
         self.ballEventRecord.objPMlinecode :
         self.ballEventRecord.objPMlengthcode :
         self.ballEventRecord.objPMStrikepoint :
         self.ballEventRecord.objPMStrikepointlinecode :
         self.ballEventRecord.objPMX1 :
         self.ballEventRecord.objPMY1 :
         self.ballEventRecord.objPMX2 :
         self.ballEventRecord.objPMY2 :
         self.ballEventRecord.objPMX3 :
         self.ballEventRecord.objPMY3 :
         self.ballEventRecord.objWWREGION :
         self.ballEventRecord.objWWX1 :
         self.ballEventRecord.objWWY1 :
         self.ballEventRecord.objWWX2 :
         self.ballEventRecord.objWWY2 :
         self.ballEventRecord.objballduration :
         self.ballEventRecord.objIsappeal :
         self.ballEventRecord.objIsbeaten :
         self.ballEventRecord.objIsuncomfort :
         self.ballEventRecord.objIswtb :
         self.ballEventRecord.objIsreleaseshot :
         self.ballEventRecord.objMarkedforedit :
         self.ballEventRecord.objRemark :
         @"" :
         self.ballEventRecord.objWicketType :
         @"" :
         @"" :
         @"" :
         @"1" :
         @"" :
         self.ballEventRecord.objPenaltytypecode :
         @"" :
         self.ballEventRecord.objBallspeed :
         self.ballEventRecord.objUncomfortclassification :
         @""];
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
        }
    }else if([self.btn_StartOver.currentTitle isEqualToString:@"END OVER"]){ // Check Is Over started
        
        if([self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
        {
            
            if(fetchSEPageLoadRecord.currentBowlerPlayerName==nil){
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Please select bowler" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alter show];
                [alter setTag:10001];
            }else if(fetchSEPageLoadRecord.strickerPlayerName==nil){
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Please select Striker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alter show];
                [alter setTag:10002];
            }else if(fetchSEPageLoadRecord.nonstrickerPlayerName==nil){
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Please select non Striker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alter show];
                [alter setTag:10003];
            }else{
                
                startBallTime = [NSDate date];
                
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                
                NSString *time =[dateFormatter stringFromDate:[NSDate date]];
                
                NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
                [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                startBallTime= [dateFormatter1 dateFromString:time];
                [self EndBallMethod];
                [self.btn_StartBall setTitle:@"END BALL" forState:UIControlStateNormal];
                self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
                self.btn_StartOver.userInteractionEnabled=NO;
                [self AllBtnEnableMethod];
                
                [self resetBallEventObject];
                [self resetAllButtonOnEndBall];
                //show free hit
                
                if(fetchSEPageLoadRecord.ISFREEHIT.intValue==1){
                     UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Free Hit Ball" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Free Hit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Alert", nil];
                    [alter show];
                    [alter setTag:10200];
                    
                }
            }
            
        }
        else
        {
            
            if([self checkRunsByLB_B] && [self iswicketPending]){// Check before end ball
           // [self calculateRunsOnEndBall];
            [self EndBallMethod];
            
            [self.btn_StartBall setTitle:@"START BALL" forState:UIControlStateNormal];
            self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            self.btn_StartOver.userInteractionEnabled=YES;
            //        self.btn_StartBall.userInteractionEnabled=NO;
            //        [self SaveBallEventREcordvalue];
            
            [self AllBtndisableMethod];
            
            
            [self timeLeftSinceDate:startBallTime];
            NSLog(@"DidClickStartBall batteamover=%d",fetchSEPageLoadRecord.BATTEAMOVERS);
            int overNo = ((int)fetchSEPageLoadRecord.BATTEAMOVERS);
            int ballNo = ((int)fetchSEPageLoadRecord.BATTEAMOVRBALLS)+1;//Check isillegal ball for pervious ball
            int overballNo = ((int)fetchSEPageLoadRecord.BATTEAMOVRBALLS)+1;
            
            self.ballEventRecord.objOverno=[NSNumber numberWithInt:fetchSEPageLoadRecord.BATTEAMOVERS];
            self.ballEventRecord.objBallno=[NSNumber numberWithInt:ballNo];
            self.ballEventRecord.objOverBallcount = [NSNumber numberWithInt:overballNo];
            self.ballEventRecord.objBallcount=@1;
            self.ballEventRecord.objBowlercode = fetchSEPageLoadRecord.currentBowlerPlayerCode;
            self.ballEventRecord.objStrikercode = fetchSEPageLoadRecord.strickerPlayerCode;
            self.ballEventRecord.objNonstrikercode = fetchSEPageLoadRecord.nonstrickerPlayerCode;
            
            
            
            //        [DBManager saveBallEventData:self.ballEventRecord];
            //        [DBManager insertBallCodeAppealEvent:self.ballEventRecord];
            //        [DBManager insertBallCodeFieldEvent: self.ballEventRecord bowlerEvent:selectedfieldPlayer fieldingFactor: selectedfieldFactor nrs :selectedNRS];
            //        [DBManager insertBallCodeWicketEvent:self.ballEventRecord];
            //        [DBManager GetBallDetails :_competitionCode :_matchCode];
            //
            [self reloadBowlerTeamBatsmanDetails];
            // [ self AssignControlValues :YES:@""];
                
                
            //Check for Striker, non Striker and bower present
                
                if(fetchSEPageLoadRecord.strickerPlayerName == nil){
                    [self btn_stricker_names:0];
                }else if(fetchSEPageLoadRecord.nonstrickerPlayerName == nil){
                    [self btn_nonstricker_name:0];
                }else if(fetchSEPageLoadRecord.currentBowlerPlayerName == nil){
                    [self btn_bowler_name:0];
                }
                
             
            [self resetBallEventObject];
            [self resetAllButtonOnEndBall];
            }
            
        }
    }
}

-(void)EndBallMethod
{
    if([fetchSEPageLoadRecord.SESSIONNO intValue] <4)
    {
        if([self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
        {
            if([self IsTeamALLOUT] == YES)
            {
                if(self.ballEventRecord.objBallno > 6)
                {
                    [self.btn_StartOver sendActionsForControlEvents:UIControlEventTouchUpInside];
                    // btb_overclick action
                }
                NSLog(@"Open Endinnings");
            }
            if(fetchSEPageLoadRecord.BATTEAMOVRBALLS > 5)
            {
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Six legitimate balls already bowled.\nDo you want to continue?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                [altert show];
                [altert setTag:2003];
            }

            else if(fetchSEPageLoadRecord.INNINGSSTATUS== 1)
            {
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"All Innings has been Completed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                [alter show];
                [alter setTag:2001];
            }
            else if (isTargetReached)
            {
                UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Target achieved do you want to continue?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                [alter show];
                [alter setTag:2002];
                
                //                if([alterviewSelect isEqualToString:@"YES"])
                //                {
                if([self.ballEventRecord.objBallno intValue] > 6)
                {
                    UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Six legitimate balls already bowled.\nDo you want to continue?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                    [altert show];
                    [alter setTag:2003];
                    if([alterviewSelect isEqualToString:@"YES"])
                    {
                        if([self.lbl_stricker_name.text isEqualToString:@""] )
                        {
                            UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Select Striker " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                            [altert show];
                            [alter setTag:2004];
                        }
                        else if ([self.lbl_nonstricker_name.text isEqualToString:@""])
                        {
                            UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Select nonStriker " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                            [altert show];
                            [alter setTag:2005];
                        }
                        else if ([self.lbl_bowler_name.text isEqualToString:@""])
                        {
                            UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Select Bowler " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                            [altert show];
                            [alter setTag:2006];
                        }
                        else
                        {
                            // display freehit alter
                            //end ball
                        }
                        
                        
                        
                    }
                    else if ([alterviewSelect isEqualToString:@"NO"])
                    {
                        // btboverclickaction
                    }
                    //}
                    
                }
            }
            
        }
        else {
            if([self.lbl_stricker_name.text isEqualToString:@""] )
            {
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Select Striker " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [altert show];
                [altert setTag:2007];
            }
            else if ([self.lbl_nonstricker_name.text isEqualToString:@""])
            {
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Select nonStricker " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [altert show];
                [altert setTag:2008];
            }
            else if ([self.lbl_bowler_name.text isEqualToString:@""])
            {
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Select Bowler " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [altert show];
                [altert setTag:2009];
            }
            else
            {
                [ self insertBallDetails:@"" :@""];
            }
            
        }
    }
    else{
        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Already three sessions has been completed for the particular day. Please proceed after resuming the third session or complete the particular day. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
        [altert show];
        
    }
}

-(void)insertBallDetails :(NSString*) BallCode :(NSString *) insertType
{
    [self calculateRunsOnEndBall];
    
    if(_isEditMode && [insertType isEqualToString:@""])
    {
        self.ballEventRecord.objBallcode = self.editBallCode;
        //Update Score Engine SP Call
        
        //(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT;
        
        
        UpdateScoreEngine *updatescore = [[UpdateScoreEngine alloc]init];
        
        //
        //    -(void) UpdateScoreEngine:(NSString *)BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEN:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT;
        
        
        
        [updatescore UpdateScoreEngine :self.editBallCode :self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO : [NSNumber numberWithInteger:fetchSEPageLoadRecord.BATTEAMOVERS] : [NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVRBALLS]  :[NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT] :fetchSEPageLoadRecord.SESSIONNO :fetchSEPageLoadRecord.strickerPlayerCode :fetchSEPageLoadRecord.currentBowlerPlayerCode : ([fetchSEPageLoadRecord.BATTINGTEAMCODE isEqualToString : fetchSEPageLoadRecord.TEAMACODE] ?fetchSEPageLoadRecord.TEAMAWICKETKEEPER : fetchSEPageLoadRecord.TEAMBWICKETKEEPER) :@"":@"": self.ballEventRecord.objAtworotw :self.ballEventRecord.objBowlingEnd :self.ballEventRecord.objBowltype :self.ballEventRecord.objShottype :self.ballEventRecord.objShorttypecategory :self.ballEventRecord.objIslegalball : self.ballEventRecord.objIsFour :  self.ballEventRecord.objIssix :self.ballEventRecord.objRuns :self.ballEventRecord.objOverthrow :self.ballEventRecord.objTotalruns :self.ballEventRecord.objWide : self.ballEventRecord.objNoball :self.ballEventRecord.objByes : self.ballEventRecord.objLegByes : self.ballEventRecord.objPenalty :self.ballEventRecord.objTotalextras :self.ballEventRecord.objGrandtotal :self.ballEventRecord.objRbw :self.ballEventRecord.objPMlinecode :self.ballEventRecord.objPMlengthcode :self.ballEventRecord.objPMStrikepoint :self.ballEventRecord.objPMStrikepointlinecode :self.ballEventRecord.objPMX1 :self.ballEventRecord.objPMY1 :self.ballEventRecord.objPMX2 :self.ballEventRecord.objPMY2 : self.ballEventRecord.objPMX3 :self.ballEventRecord.objPMY3 :self.ballEventRecord.objWWREGION :self.ballEventRecord.objWWX1 :self.ballEventRecord.objWWY2 :self.ballEventRecord.objWWX2 :self.ballEventRecord.objWWY2 :self.ballEventRecord.objballduration :self.ballEventRecord.objIsbeaten :self.ballEventRecord.objIsuncomfort :self.ballEventRecord.objIswtb :self.ballEventRecord.objIsreleaseshot :self.ballEventRecord.objMarkedforedit :self.ballEventRecord.objRemark :@"" : self.ballEventRecord.objWicketType :@"" :@"" :@"" :@"" :@"" : self.ballEventRecord.objPenaltytypecode :@"" : self.ballEventRecord.objBallspeed :self.ballEventRecord.objUncomfortclassification :@"" :@"" :@""];
        
        
    }
    else
    {
        if(_isEditMode){
            
        }
        
           // [objEditModeVc insertAfterAndBeforeMode :self.editBallCode];
            
//            fetchSeBallCodeDetails = [[FETCHSEBALLCODEDETAILS alloc]init];
//            [fetchSeBallCodeDetails FetchSEBallCodeDetails:self.competitionCode :self.matchCode:self.editBallCode];
            
        
        
        
        NSNumber *temp = [NSNumber numberWithInteger:fetchSEPageLoadRecord.BATTEAMOVRBALLS];

        
        int ballCount = ((int)fetchSEPageLoadRecord.BATTEAMOVRBALLS)+1;
        
        //InsertSEScoreEngine* _InsertSEScoreEngine = [[InsertSEScoreEngine alloc] init];
        //_InsertSEScoreEngine.BOWLINGTEAMCODE = fetchSEPageLoadRecord.BOWLINGTEAMCODE;
        
        [InsertSEScoreEngine InsertScoreEngine :
         self.competitionCode :
         self.matchCode  :
         fetchSEPageLoadRecord.BATTINGTEAMCODE :
         [NSNumber numberWithInt : fetchSEPageLoadRecord.INNINGSNO.intValue] :
         BallCode :
         [NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVERS] :
         [NSNumber numberWithInt: ballCount] :
         [NSNumber numberWithInt:1] : //default BALLCOUNT for Live mode
          fetchSEPageLoadRecord.DAYNO :
         fetchSEPageLoadRecord.SESSIONNO :
         fetchSEPageLoadRecord.strickerPlayerCode:
         fetchSEPageLoadRecord.nonstrickerPlayerCode:
         fetchSEPageLoadRecord.currentBowlerPlayerCode:
         
         ([fetchSEPageLoadRecord.BATTINGTEAMCODE isEqualToString :
           fetchSEPageLoadRecord.TEAMACODE] ?
          fetchSEPageLoadRecord.TEAMAWICKETKEEPER :
          fetchSEPageLoadRecord.TEAMBWICKETKEEPER):
         
         fetchSEPageLoadRecord.UMPIRE1CODE :
         fetchSEPageLoadRecord.UMPIRE2CODE :
         self.ballEventRecord.objAtworotw :
         self.ballEventRecord.objBowlingEnd :
         self.ballEventRecord.objBowltype :
         self.ballEventRecord.objShottype:
         self.ballEventRecord.objShorttypecategory :
         self.ballEventRecord.objIslegalball:
         self.ballEventRecord.objIsFour :
         self.ballEventRecord.objIssix :
         self.ballEventRecord.objRuns :
         self.ballEventRecord.objOverthrow :
         self.ballEventRecord.objTotalruns :
         self.ballEventRecord.objWide :
         self.ballEventRecord.objNoball :
         self.ballEventRecord.objByes:
         self.ballEventRecord.objLegByes:
         self.ballEventRecord.objPenalty:
         self.ballEventRecord.objTotalextras:
         self.ballEventRecord.objGrandtotal:
         self.ballEventRecord.objRbw:
         self.ballEventRecord.objPMlinecode:
         self.ballEventRecord.objPMlengthcode:
         self.ballEventRecord.objPMStrikepoint:
         self.ballEventRecord.objPMX1:
         self.ballEventRecord.objPMY1:
         self.ballEventRecord.objPMX2:
         self.ballEventRecord.objPMY2:
         self.ballEventRecord.objPMX3:
         self.ballEventRecord.objPMY3:
         self.ballEventRecord.objWWREGION:
         self.ballEventRecord.objWWX1:
         self.ballEventRecord.objWWY1:
         self.ballEventRecord.objWWX2:
         self.ballEventRecord.objWWY2:
         self.ballEventRecord.objballduration:
         self.ballEventRecord.objIsappeal:
         self.ballEventRecord.objIsbeaten:
         self.ballEventRecord.objIsuncomfort:
         self.ballEventRecord.objIswtb:
         self.ballEventRecord.objIsreleaseshot:
         self.ballEventRecord.objMarkedforedit:
         self.ballEventRecord.objRemark:
         self.ballEventRecord.objVideoFile:
         isWicketSelected == YES ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0]:
         selectedwickettype.metasubcode:
         (selectedStrikernonstrikerCode.length <= 0 ? fetchSEPageLoadRecord.strickerPlayerCode : selectedStrikernonstrikerCode):
         selectedwicketBowlerlist.BowlerCode:
                                      insertType:
         @""://Awarded Team:
         self.ballEventRecord.objPenalty:
         self.ballEventRecord.objPenaltytypecode:
         @""://(NSString *)PENALTYREASONCODE:
         @""://(NSString *)BALLSPEED:
         @""://(NSString *)UNCOMFORTCLASSIFCATION:
         selectedWicketEvent];
        //Insert Score Engine SP Call
        
            [self reloadBowlerTeamBatsmanDetails];
        
    }
    if([self.ballEventRecord.objIslegalball intValue] == 0)
    {
        if([self.ballEventRecord.objWide intValue] !=0)
        {
            int wide =[self.ballEventRecord.objRuns intValue]+[self.ballEventRecord.objOverthrow intValue]+1;
            self.ballEventRecord.objWide=[NSString stringWithFormat:@"%d",wide];
            self.ballEventRecord.objRuns=@"0";
        }
        else if ([self.ballEventRecord.objNoball intValue] !=0)
        {
            if([self.ballEventRecord.objByes intValue] !=0 || [self.ballEventRecord.objLegByes intValue] !=0)
            {
                self.ballEventRecord.objNoball =@"1";
                int byes;
                int LegByes;
               byes=([self.ballEventRecord.objByes intValue] >0)?([self.ballEventRecord.objRuns intValue]+[self.ballEventRecord.objOverthrow intValue]):[self.ballEventRecord.objByes intValue];
                self.ballEventRecord.objByes=[NSString stringWithFormat:@"%d",byes];
                
                LegByes=([self.ballEventRecord.objLegByes intValue] >0)?([self.ballEventRecord.objRuns intValue]+[self.ballEventRecord.objOverthrow intValue]):[self.ballEventRecord.objLegByes intValue];
                 self.ballEventRecord.objLegByes=[NSString stringWithFormat:@"%d",LegByes];
                self.ballEventRecord.objRuns=@"0";
                
            }
            else{
                self.ballEventRecord.objNoball=@"1";
            }
        }
    }
    else{
        if([self.ballEventRecord.objByes intValue] !=0 || [self.ballEventRecord.objLegByes intValue] !=0)
        {
            int byes;
            int LegByes;
            byes=([self.ballEventRecord.objByes intValue] >0)?([self.ballEventRecord.objRuns intValue]+[self.ballEventRecord.objOverthrow intValue]):[self.ballEventRecord.objByes intValue];
            self.ballEventRecord.objByes=[NSString stringWithFormat:@"%d",byes];
            
            LegByes=([self.ballEventRecord.objLegByes intValue] >0)?([self.ballEventRecord.objRuns intValue]+[self.ballEventRecord.objOverthrow intValue]):[self.ballEventRecord.objLegByes intValue];
            self.ballEventRecord.objLegByes=[NSString stringWithFormat:@"%d",LegByes];
            self.ballEventRecord.objRuns=@"0";
        }
        
        else{
            
//            [DBManagerEndBall UpdateScoreEngine:self.ballEventRecord.objBallcode :self.ballEventRecord.objcompetitioncode:self.ballEventRecord.objmatchcode :self.ballEventRecord.objTeamcode :self.ballEventRecord.objInningsno :self.ballEventRecord.objOverno :self.ballEventRecord.objBallno :self.ballEventRecord.objBallcount :self.ballEventRecord.objSessionno :self.ballEventRecord.objStrikercode :self.ballEventRecord.objNonstrikercode :self.ballEventRecord.objBowlercode :self.ballEventRecord.objWicketkeepercode :self.ballEventRecord.objUmpire1code :self.ballEventRecord.objUmpire2code :self.ballEventRecord.objAtworotw :self.ballEventRecord.objBowlingEnd :self.ballEventRecord.objBowltype :self.ballEventRecord.objShottype :self.ballEventRecord.objShorttypecategory :self.ballEventRecord.objIslegalball :self.ballEventRecord.objIsFour :self.ballEventRecord.objIssix :self.ballEventRecord.objRuns :self.ballEventRecord.objOverthrow :self.ballEventRecord.objTotalruns :self.ballEventRecord.objWide :self.ballEventRecord.objNoball :self.ballEventRecord.objByes :self.ballEventRecord.objLegByes :self.ballEventRecord.objPenalty :self.ballEventRecord.objTotalextras :self.ballEventRecord.objGrandtotal :self.ballEventRecord.objRbw :self.ballEventRecord.objPMlinecode :self.ballEventRecord.objPMlengthcode: self.ballEventRecord.objPMStrikepoint:self.ballEventRecord.objPMStrikepointlinecode :self.ballEventRecord.objPMX1 :self.ballEventRecord.objPMY1 :self.ballEventRecord.objPMX1 :self.ballEventRecord.objPMY1 :self.ballEventRecord.objballduration :self.ballEventRecord.objIsappeal :self.ballEventRecord.objIsbeaten :self.ballEventRecord.objIsuncomfort :self.ballEventRecord.objIswtb :self.ballEventRecord.objIsreleaseshot :self.ballEventRecord.objMarkedforedit :self.ballEventRecord.objRemark :self.ballEventRecord.objWicketno :self.ballEventRecord.objWicketType :self.ballEventRecord.objWicketkeepercode : @"":@"" :@"" :@"":@"":@"" :@"" :@"" :@"" :@"":self.ballEventRecord.objPenalty :self.ballEventRecord.objPenaltytypecode :@"" :self.ballEventRecord.objBallspeed :self.ballEventRecord.objUncomfortclassification :@""];
       
        }
        
    }
    
    NSMutableArray * objUmpireArray =[DBManager GETUMPIRE:self.competitionCode :self.matchCode ];
    Umpire1Code =[objUmpireArray objectAtIndex:0];
    umpire2Code =[objUmpireArray objectAtIndex:1];
    TEAMAWICKETKEEPER =[objUmpireArray objectAtIndex:2];
    TEAMBWICKETKEEPER=[objUmpireArray objectAtIndex:3];
    NSString * wicketkeepercode ;
    NSString * battingTeamCode =fetchSEPageLoadRecord.BATTINGTEAMCODE;
    NSString * teamAcode       =fetchSEPageLoadRecord.TEAMACODE;
    NSString * teamBcode       =fetchSEPageLoadRecord.TEAMBCODE;
   // Matchtype       =fetchSEPageLoadRecord.MATCHTYPE;
    if([battingTeamCode isEqualToString:teamAcode])
    {
        wicketkeepercode=TEAMAWICKETKEEPER;
    }
    else if([battingTeamCode isEqualToString:teamBcode])
    {
        wicketkeepercode=TEAMBWICKETKEEPER;
    }
    else{
        wicketkeepercode =@"";
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
    
    //    int Startoveroverno = fetchSEPageLoadRecord.BATTEAMOVERS;
    
    if([self.btn_StartOver.currentTitle isEqualToString:@"START OVER"])
    {
        
        
        if(fetchSEPageLoadRecord.currentBowlerPlayerName==nil){
            UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Please select bowler" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alter show];
            [alter setTag:10001];
        }else if(fetchSEPageLoadRecord.strickerPlayerName==nil){
            UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Please select Striker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alter show];
            [alter setTag:10002];
        }else if(fetchSEPageLoadRecord.nonstrickerPlayerName==nil){
            UIAlertView * alter =[[UIAlertView alloc]initWithTitle:nil message:@"Please select non Striker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alter show];
            [alter setTag:10003];
        }else{
            [self overEVENT];
            self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
            [self.btn_StartOver setTitle:@"END OVER" forState:UIControlStateNormal];
            if(![self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
                [self DidClickStartBall : self.btn_StartBall];
            self.btn_StartBall.userInteractionEnabled=YES;
        }
        
    }
    else
    {
        [self overEVENT];
        
        //Check for Striker, non Striker and bower present
        
        if(fetchSEPageLoadRecord.currentBowlerPlayerName  == nil){
            [self btn_bowler_name:0];

        }else if(fetchSEPageLoadRecord.strickerPlayerName == nil){
            [self btn_stricker_names:0];
        }else if( fetchSEPageLoadRecord.nonstrickerPlayerName == nil){
            [self btn_nonstricker_name:0];

        }
        
        //        [self.btn_StartOver setTitle:@"START OVER" forState:UIControlStateNormal];
        //        self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
        //        self.btn_StartBall.userInteractionEnabled=NO;
        //        [self AllBtndisableMethod];
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //NSMutableArray * objUmpireArray =[DBManager GETUMPIRE:self.competitionCode :self.matchCode ];
    
    
    
    
    //NSString * Umpire1Code =[objUmpireArray objectAtIndex:0];
    //NSString * umpire2Code =[objUmpireArray objectAtIndex:1];
    
    //    endInnings=[[EndInnings alloc]init ];
    //
    //    [endInnings manageSeOverDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO :fetchSEPageLoadRecord :[NSString stringWithFormat:@"%d",getOverStatus] :Umpire1Code :umpire2Code];
    
}
-(void)overEVENT
{
    
    //endInnings=[[EndInnings alloc]init ];
    NSLog(@"matchtype=%@",self.matchTypeCode);
    NSString * Matchtype;
    // NSArray * MuliteDayMatchtype ;
    //NSArray  * ValidedMatchType;
    NSString *matchoversvalue= fetchSEPageLoadRecord.MATCHTYPE;
    NSInteger currentover =fetchSEPageLoadRecord.BATTEAMOVERS;
    int overNoint =(int)currentover;
    
    NSMutableArray * objUmpireArray =[DBManager GETUMPIRE:self.competitionCode :self.matchCode ];
    Umpire1Code =[objUmpireArray objectAtIndex:0];
    umpire2Code =[objUmpireArray objectAtIndex:1];
    TEAMAWICKETKEEPER =[objUmpireArray objectAtIndex:2];
    TEAMBWICKETKEEPER=[objUmpireArray objectAtIndex:3];
    NSString * wicketkeepercode ;
    NSString * battingTeamCode =fetchSEPageLoadRecord.BATTINGTEAMCODE;
    NSString * teamAcode       =fetchSEPageLoadRecord.TEAMACODE;
    NSString * teamBcode       =fetchSEPageLoadRecord.TEAMBCODE;
    Matchtype       =fetchSEPageLoadRecord.MATCHTYPE;
    if([battingTeamCode isEqualToString:teamAcode])
    {
        wicketkeepercode=TEAMAWICKETKEEPER;
    }
    else if([battingTeamCode isEqualToString:teamBcode])
    {
        wicketkeepercode=TEAMBWICKETKEEPER;
    }
    else{
        wicketkeepercode =@"";
    }
    
    
    self.ballEventRecord.objAtworotw =(self.ballEventRecord.objAtworotw== nil)?@"":self.ballEventRecord.objAtworotw;
    self.ballEventRecord.objBowlingEnd =(self.ballEventRecord.objBowlingEnd== nil)?@"":self.ballEventRecord.objBowlingEnd;
    if([fetchSEPageLoadRecord.SESSIONNO intValue] < 4)
    {
        
        
        if([self.btn_StartOver.currentTitle isEqualToString:@"START OVER"])
        {
            //MuliteDayMatchtype =[[NSArray alloc]initWithObjects:@"MSC023",@"MSC114", nil];
            
            
            if([self IsTeamALLOUT] == YES)
            {
                //NSLog(@"ENDINNINGS");
                [self ENDINNINGS];
            }
            
            
            else if([ValidedMatchType containsObject:fetchSEPageLoadRecord.MATCHTYPE] && fetchSEPageLoadRecord.BATTEAMOVERS >=[fetchSEPageLoadRecord.MATCHOVERS intValue]  && ![MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE])
            {
                NSLog(@"%@",self.matchTypeCode);
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Inning is Completed " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                [altert setTag:1001];
                [altert show];
                
                if([fetchSEPageLoadRecord.INNINGSNO intValue] == 2)
                {
                    //NSLog(@"Match Result");
                    [self MatchResult];
                }
                else
                {
                    //NSLog(@"ENNDings");
                    [self ENDINNINGS];
                }
                
            }
            
            else if ([fetchSEPageLoadRecord.INNINGSSTATUS intValue] ==1 )
            {
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"All Innings has been Completed " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                [altert show];
                [altert setTag:1002];
            }
            
            else
            {
                
                
                if(isTargetReached == YES)
                {
                    UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Target Achived do you want Continue? " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                    [altert show];
                    [altert setTag:1003];
                }else{
                    if ([self.lbl_bowler_name.text isEqualToString:@""])
                    {
                        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Select Bowler " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                        [altert show];
                        //[altert setTag:1006];
                    }else{
                        overStatus = @"0";
                        
                        [endInnings manageSeOverDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO :self.ballEventRecord :overStatus :Umpire1Code :umpire2Code :[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVERS]:fetchSEPageLoadRecord.strickerPlayerCode :fetchSEPageLoadRecord.nonstrickerPlayerCode];
                        
                    }
                }
            }
            
        }
        
        else
        {
            if([self IsTeamALLOUT] == YES)
            {
                NSLog(@"ENDINNINGS");
                [self ENDINNINGS];
            }
            else{
                if([self.lbl_stricker_name.text isEqualToString:@""] ||self.lbl_stricker_name.text == nil)
                {
                    UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Select Striker " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                    [altert show];
                    [altert setTag:1004];
                }
                else if ([self.lbl_nonstricker_name.text isEqualToString:@""])
                {
                    UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Select nonStriker " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                    [altert show];
                    [altert setTag:1005];
                }
                else if ([self.lbl_bowler_name.text isEqualToString:@""])
                {
                    UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Select Bowler " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                    [altert show];
                    [altert setTag:1006];
                }
                else{
                    NSLog(@"BallNo =%d",[fetchSEPageLoadRecord.MATCHOVERS intValue]);
                    
                    if(fetchSEPageLoadRecord.BATTEAMOVRBALLS <6)
                    {
                        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Six Legal ball not bowled \n Are you sure you want to End Over?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                        [altert show];
                        [altert setTag:1007];
                    }else{
                        {
                            if([self.btn_StartBall.currentTitle isEqualToString:@"END BALL"])
                            {
                                [self.btn_StartBall sendActionsForControlEvents:UIControlEventTouchUpInside];
                            }
                            overStatus=@"1";
                            [endInnings manageSeOverDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO :self.ballEventRecord :overStatus :Umpire1Code :umpire2Code :[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVERS]:fetchSEPageLoadRecord.strickerPlayerCode :fetchSEPageLoadRecord.nonstrickerPlayerCode];
                            [self reloadBowlerTeamBatsmanDetails];
//                            if(![ValidedMatchType containsObject:fetchSEPageLoadRecord.MATCHTYPE] && fetchSEPageLoadRecord.BATTEAMOVERS >= [fetchSEPageLoadRecord.MATCHOVERS intValue] &&[MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE])
//                                
                            if(![fetchSEPageLoadRecord.ISOTHERSMATCHTYPE isEqual:@"MSC117"] && fetchSEPageLoadRecord.BATTEAMOVERS >= [fetchSEPageLoadRecord.MATCHOVERS intValue] &&![MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE])
                            {
                                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Innings Completed " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                                [altert show];
                                if((![MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE] && fetchSEPageLoadRecord.INNINGSNO ==2) ||([MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE] && fetchSEPageLoadRecord.INNINGSNO ==4))
                                {
                                    [self MatchResult];
                                }
                                else{
                                    [self ENDINNINGS];
                                }
                            }
                            else{
                                if([self.lbl_bowler_name.text isEqualToString:@""] ||self.lbl_bowler_name.text == nil)
                                {
                                    //bowerbtn
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    //ballticker clear
                    
                    if(![ValidedMatchType containsObject: [NSString stringWithFormat:@"%d",fetchSEPageLoadRecord.MATCHTYPE]] &&[self.ballEventRecord.objOverno intValue] >= fetchSEPageLoadRecord.MATCHTYPE && ![MuliteDayMatchtype containsObject: [NSString stringWithFormat:@"%d",fetchSEPageLoadRecord.MATCHTYPE]])
                    {
                        
                        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Enning is Completed " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                        [altert show];
                        [altert setTag:1008];
                        if(fetchSEPageLoadRecord.INNINGSNO == 2)
                        {
                            NSLog(@"Match Result");
                        }
                        else
                        {
                            NSLog(@"ENNDings");
                        }
                    }
                    else{
                        if([self.lbl_bowler_name.text isEqualToString:@""])
                        {
                            [self.btn_bowlername sendActionsForControlEvents:UIControlEventTouchUpInside];
                        }
                    }
                    
                }
            }
        }
    }
    else {
        
        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Already three sessions has been completed for the particular day. Please proceed after resuming the third session or complete the particular day. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
        [altert show];
    }
    
    
}


-(BOOL)IsTeamALLOUT
{
    int NoofWickets=0;
    
    NSArray* obj= [self.lbl_battingScoreWkts.text componentsSeparatedByString:@"/"];
    NSString *objs =[obj objectAtIndex:1];
    NoofWickets =[objs intValue];
    if(NoofWickets >=10)
    {
        UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"No More Wicket to play " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
        [altert show];
        return YES;
    }
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)//OK button pressed
    {
        
        if(alertView.tag == 1001)
        {
        }
        else if (alertView.tag ==1003)
        {
            if([_lbl_bowler_name.text isEqualToString:@""]||_lbl_bowler_name.text == nil)
            {
                
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Select Bowler " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [altert show];
                //[btn_bowler_name ]
            }
            else{
                overStatus=@"0";
                
                [endInnings manageSeOverDetails: self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO :self.ballEventRecord :overStatus :Umpire1Code :umpire2Code:[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVERS]:fetchSEPageLoadRecord.strickerPlayerCode:fetchSEPageLoadRecord.nonstrickerPlayerCode];
            }
        }
        else if(alertView.tag == 1007)
        {
            NSLog(@"dfjbgb");
            if([self.btn_StartBall.currentTitle isEqualToString:@"END BALL"])
            {
                [self.btn_StartBall sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            overStatus=@"1";
            [endInnings manageSeOverDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO :self.ballEventRecord :overStatus :Umpire1Code :umpire2Code:[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVERS]:fetchSEPageLoadRecord.strickerPlayerCode:fetchSEPageLoadRecord.nonstrickerPlayerCode];
            [self reloadBowlerTeamBatsmanDetails];
            
            
            //Check batsman and bowler empty
            if(fetchSEPageLoadRecord.currentBowlerPlayerName  == nil){
                [self btn_bowler_name:0];
                
            }else if(fetchSEPageLoadRecord.strickerPlayerName == nil){
                [self btn_stricker_names:0];
            }else if( fetchSEPageLoadRecord.nonstrickerPlayerName == nil){
                [self btn_nonstricker_name:0];
                
            }
            
            
            if(![ValidedMatchType containsObject:fetchSEPageLoadRecord.MATCHTYPE] && fetchSEPageLoadRecord.BATTEAMOVERS >= [fetchSEPageLoadRecord.MATCHOVERS intValue] &&[MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE])
            {
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Innings Completed " delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [altert show];
                if((![MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE] && fetchSEPageLoadRecord.INNINGSNO ==2) ||([MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE] && fetchSEPageLoadRecord.INNINGSNO ==4))
                {
                    [self MatchResult];
                }
                else{
                    [self ENDINNINGS];
                }
            }
            else{
                if([self.lbl_bowler_name.text isEqualToString:@""] ||self.lbl_bowler_name.text == nil)
                {
                    //bowerbtn
                }
            }
            
            
            
        }
        else if(alertView.tag == 1008)
        {
            NSLog(@"dfjbgb");
            [self.btn_StartOver setTitle:@"START OVER" forState:UIControlStateNormal];
            self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            self.btn_StartBall.userInteractionEnabled=NO;
            [self AllBtndisableMethod];
            //overStatus=@"1";
            //[endInnings manageSeOverDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO :self.ballEventRecord :overStatus :Umpire1Code :umpire2Code];
            
            //change btnname start over
            [self reloadBowlerTeamBatsmanDetails];
        }
        
        
        alterviewSelect=@"Yes";
        //        if(fetchSEPageLoadRecord.INNINGSNO ==2 )
        //        {
        //            NSLog(@"MatchResult");
        //        }
        //        else{
        //            NSLog(@"ENDINNINGS");
        //        }
        
        if(isTargetReached==YES)
        {
            if([self.lbl_bowler_name.text isEqualToString:@""])
            {
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"please select bowler " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
                [altert show];
            }
            else{
                overStatus=@"0";
                
                [endInnings manageSeOverDetails:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.INNINGSNO:self.ballEventRecord:overStatus :Umpire1Code :umpire2Code:[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVERS]:fetchSEPageLoadRecord.strickerPlayerCode:fetchSEPageLoadRecord.nonstrickerPlayerCode];
                
            }
            
            
        }
        // start ball
        //        if([self.ballEventRecord.objBallno intValue] > 6)
        //        {
        //            UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score ENgin" message:@"Six legitimate balls already bowled.\nDo you want to continue?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Warning", nil];
        //            [altert show];
        //        }
        //do something
    }
    else if(buttonIndex == 1)//Annul button pressed.
    {
        if(alertView.tag == 1001)
        {
            
        }
        if(alertView.tag == 1003)
        {
            [self MatchResult];
            
        }
        else if(alertView.tag == 1007)
        {
            NSLog(@"vhdgdfgd");
        }
        
        
        alterviewSelect=@"NO";
        //do something
        if(isTargetReached==YES)
        {
            NSLog(@"MAtchResut");
        }
        else
        {
            //endball
            
            
        }
        //        if([self.ballEventRecord.objBallno intValue] > 6)
        //           {
        //               //btnoverclick call
        //           }
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
    else if(ispichmapSelectValue==NO)
    {
          [self unselectedButtonBg:self.btn_pichmap];
           
    }
        
    else if(ispichmapSelectValue==YES)
    {
        [self selectedButtonBg:self.btn_pichmap];
        
    }
    
    
    _View_Appeal.hidden=YES;
    self.view_bowlType.hidden = YES;
    self.view_fastBowl.hidden = YES;
    self.view_aggressiveShot.hidden = YES;
    self.view_defensive.hidden = YES;
    self.img_pichmap.hidden=YES;
    self.PichMapTittle.hidden=YES;
    self.view_Wagon_wheel.hidden=YES;
    self.objcommonRemarkview.hidden=YES;
    
    
    //    if(extrasTableView !=nil){
    //        [extrasTableView removeFromSuperview];
    //    }
    //
    //    if(overThrowTableView !=nil){
    //        [overThrowTableView removeFromSuperview];
    //    }
    UIButton *selectBtnTag=(UIButton*)sender;
    
    //wicket
    if(isWicketSelected && selectBtnTag.tag != 107 && wicketOption !=0){
        
        isWicketSelected= NO;
        selectedwickettype = nil;
        selectedWicketEvent = nil;
        selectedStrikernonstriker = nil;
        selectedwicketBowlerlist =nil;
        [self unselectedButtonBg:self.btn_wkts];
    
        
    }
    
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
    
    if (isRBWSelected && selectBtnTag.tag!=119) {
        if(self.ballEventRecord.objRbw!=0){
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            
        }else{
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            
        }
        [rbwTableview removeFromSuperview];
        
        isRBWSelected = NO;
    }
    
    if (ismiscFilters && selectBtnTag.tag!=109 ) {
        
        
        if(self.ballEventRecord.objIsbeaten.integerValue ==0 && self.ballEventRecord.objIswtb.integerValue ==0 && self.ballEventRecord.objIsuncomfort.integerValue ==0 && self.ballEventRecord.objIsreleaseshot.integerValue ==0)
        {

             self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Black
            
            
        }else{
            
                       self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Green
            
        }
        [miscFiltersTableview removeFromSuperview];
        
        ismiscFilters = NO;
    }
    
    if(selectBtnTag.tag==100)//Run one
    {
        if([self checkRunOut] && [self checkBeatenOnRuns])
        {
     [self calculateRuns:selectBtnTag.tag];
        }
        
    }
    else if(selectBtnTag.tag==101 && [self checkBeatenOnRuns])// Run two
    {
        if([self checkRunOut])
        {
            [self calculateRuns:selectBtnTag.tag];
        }
        
    }
    else if(selectBtnTag.tag==102 && [self checkBeatenOnRuns])// Run three
    {
        if([self checkRunOut])
        {
            [self calculateRuns:selectBtnTag.tag];
        }
    }
    else if(selectBtnTag.tag==103 && [self checkBeatenOnRuns])//More Runs
    {
        if([self checkRunOut])
        {
            [self calculateRuns:selectBtnTag.tag];
        }
    
    }
    else if(selectBtnTag.tag==104)// B4
    {
        
        if([self checkBeatenOnRuns]){
        if(isWicketSelected == YES)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Run not possible"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        else{
            
            [self calculateRuns:selectBtnTag.tag];
        }
        }
    }
    else if(selectBtnTag.tag==105)// B6
    {
        if([self checkBeatenOnRuns]){

        if(isWicketSelected == YES)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Run not possible"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        else{
            
            [self calculateRuns:selectBtnTag.tag];
        }
        }
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
            [self unselectedButtonBg:self.btn_B4];
            [self unselectedButtonBg:self.btn_B6];
            isCaught=NO;
            self.btn_B6.userInteractionEnabled =YES;
            self.btn_B4.userInteractionEnabled= YES;
            
            selectedwickettype = nil;
            
            isWicketSelected = NO;
            wicketOption = 0;
            self.view_aggressiveShot.hidden = YES;
            self.view_defensive.hidden = YES;
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = YES;
            selectedwickettype = nil;
            selectedWicketEvent = nil;
            selectedStrikernonstriker = nil;
            selectedwicketBowlerlist =nil;
            
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
        }
    }
    else if(selectBtnTag.tag==108)//Overthrow
    {
        
        [self overThrowPopupMenu:selectBtnTag];
        
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
            miscFiltersTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
             [miscFiltersTableview setSeparatorColor:[UIColor whiteColor]];
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
        if(isPitchmap==NO)
        {
        [self selectedButtonBg:selectBtnTag];
        
        // [self selectBtncolor_Action:@"110" :self.btn_pichmap :0];
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
        self.PichMapTittle.text=@"PITCHMAP";
        self.PichMapTittle.font=[UIFont fontWithName:@"RAJDHANI-MEDIUM" size:20];
        self.PichMapTittle.textColor=[UIColor whiteColor];
        self.PichMapTittle.textAlignment=NSTextAlignmentCenter;
        self.PichMapTittle.backgroundColor=[UIColor colorWithRed:(49/255.0f) green:(72/255.0f) blue:(159/255.0f) alpha:1.0f];
        self.PichMapTittle.hidden=NO;
        [self.Allvaluedisplayview addSubview:self.PichMapTittle];
        
        
        self.img_pichmap.hidden=NO;
            isPitchmap=YES;
        
        }
        else
        {
            [self unselectedButtonBg:self.btn_pichmap];
             self.PichMapTittle.hidden=YES;
            self.img_pichmap.hidden=YES;
            isPitchmap=NO;
        }
    }
    else if(selectBtnTag.tag==111)
    {
        [self selectedButtonBg:selectBtnTag];
        // [self selectBtncolor_Action:@"111" :self.btn_wagonwheel :0];
        //[self.img_pichmap setImage:[UIImage imageNamed:@"WagonWheel_img"]];
        // _View_Appeal.hidden=YES;
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
        
        if([self.BatmenStyle isEqualToString:@"MSC013"])
        {
            [self.img_WagonWheel setImage:[UIImage imageNamed:@"RHWagon"]];
        }
        else{
            [self.img_WagonWheel setImage:[UIImage imageNamed:@"LHWagon"]];
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
    [self DisplayCommentmethod];
}

-(void)DisplayCommentmethod
{
    NSString * runSix =@"";
    NSString * runFour =@"";
    NSString *  Extras =@"";
    NSString *  Wicket = @"";
    NSString *  overthrow=@"";
    NSString *  unComfort=@"";
    NSString *  beaten=@"";
    NSString * Shottype=@"";
    if([self.ballEventRecord.objIssix intValue] == 1)
    {
        runSix= (self.ballEventRecord.objIssix == NULL)?@"":self.ballEventRecord.objIssix;
    }
    else if ([self.ballEventRecord.objIsFour intValue] == 1)
    {
        runFour=(self.ballEventRecord.objIsFour==NULL)?@"":@"4";
    }
    else if (self.ballEventRecord.objWide == 1)
    {
        Extras=self.ballEventRecord.objWide;
    }
    else if (self.ballEventRecord.objLegByes == 1)
    {
        Extras=self.ballEventRecord.objLegByes;
    }
    else if (self.ballEventRecord.objNoball == 1)
    {
        Extras=self.ballEventRecord.objNoball;
    }
    else if (self.ballEventRecord.objByes == 1)
    {
        Extras=self.ballEventRecord.objByes;
    }
    else if (self.ballEventRecord.objWicketno > 0)
    {
        Wicket=self.ballEventRecord.objWicketno;
    }
    else if (self.ballEventRecord.objOverthrow > 0)
    {
        overthrow=self.ballEventRecord.objOverthrow;
    }
    else if (self.ballEventRecord.objIsuncomfort == 1)
    {
        unComfort=self.ballEventRecord.objIsuncomfort;
    }
    else if(self.ballEventRecord.objIsbeaten ==1)
    {
        beaten =self.ballEventRecord.objIsbeaten;
    }
    else if(self.ballEventRecord.objShottype ==1)
    {
        Shottype =self.ballEventRecord.objShottype;
    }
    self.txt_Commantry.text=[NSString stringWithFormat:@" %@ %@ %@ %@ %@ %@ %@ %@",runSix,runFour,Extras,Wicket,overthrow,unComfort,beaten,Shottype];
}




- (void)didClickPichmapTapAction:(UIGestureRecognizer *)pichmapGesture
{
    
    if(Img_ball != nil)
    {
        [Img_ball removeFromSuperview];
    }
    ispichmapSelectValue=YES;
    CGPoint p = [pichmapGesture locationInView:self.img_pichmap];
    NSLog(@"pointx=%f,pointY=%f",p.x,p.y);
    float Xposition = p.x-10;
    float Yposition = p.y-10;
    
    if(IS_IPAD_PRO)
    {
        Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(Xposition,Yposition,20, 20)];
        
        if(Xposition > 187 && Yposition > 85 && Xposition < 455 && Yposition < 200)
        {
            if(Xposition > 187 && Yposition > 85 && Xposition < 268)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full toss wide0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"full toss wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            
            else if(Xposition >270 && Yposition >85 && Xposition < 304)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full toss outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"full toss outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
            }
            else if(Xposition > 304 && Yposition >85 && Xposition < 341)
            {
                
                NSLog(@"full toss Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC037";
                self.ballEventRecord.objPMlinecode =@"MSC026";
                
            }
            else if(Xposition >342 && Yposition >85 && Xposition < 366)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full toss outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"full toss outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
            }
            else if(Xposition >366 && Yposition >85 && Xposition < 455)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full toss wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"full toss wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
            }
            
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
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"yorker wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            
            else if(Xposition >270 && Yposition >200 && Xposition < 304)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"yorker outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
            }
            else if(Xposition >310 && Yposition >200 && Xposition < 341)
            {
                
                NSLog(@"yorker Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC036";
                self.ballEventRecord.objPMlinecode =@"MSC026";
                
            }
            else if(Xposition >342 && Yposition >200 && Xposition < 377)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"yorker outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
            }
            else if(Xposition >375 && Yposition >200 && Xposition < 463)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"yorker wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"Full wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            else if(Xposition >265 && Yposition >240 && Xposition < 296)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"full outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                
            }
            
            else if(Xposition >300 && Yposition >240 && Xposition < 343)
            {
                NSLog(@"full Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC035";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >343 && Yposition >240 && Xposition < 390)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"full outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                
            }
            else if(Xposition >385 && Yposition >240 && Xposition < 479)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"full wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"good wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            else if(Xposition >249 && Yposition >297 && Xposition < 290)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"good outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"good outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
            }
            
            else if(Xposition >300 && Yposition >297 && Xposition < 350)
            {
                NSLog(@"good Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC034";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >350 && Yposition >297 && Xposition < 409)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"good outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"good outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                
            }
            else if(Xposition >395 && Yposition >298 && Xposition < 505)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"good wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"good wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"short wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            else if(Xposition >226 && Yposition >398 && Xposition < 275)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"short outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"short outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
            }
            else if(Xposition >291 && Yposition >398 && Xposition < 358)
            {
                NSLog(@"short Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC033";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >358 && Yposition >398 && Xposition < 435)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"short outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"short outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                
            }
            else if(Xposition >423 && Yposition >398 && Xposition < 535)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"short wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"short wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"Bouncer wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            else if(Xposition >196 && Yposition >500 && Xposition < 267)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Bouncer outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"Bouncer outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
            }
            else if(Xposition >280 && Yposition >500 && Xposition < 363)
            {
                NSLog(@"Bouncer Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC032";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >368 && Yposition >500 && Xposition < 455)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Bouncer outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"Bouncer outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                
            }
            else if(Xposition >447 && Yposition >500 && Xposition < 553)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Bouncer wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"Bouncer wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
            if(Xposition > 96 && Yposition > 37 && Xposition < 158)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Full over wide0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"Full over wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
            }
            else if(Xposition >157 && Yposition >37 && Xposition < 177)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Full over outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"Full over outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                
            }
            else if(Xposition >177 && Yposition >37 && Xposition < 196)
            {
                NSLog(@"Full over Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC037";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >195 && Yposition >37 && Xposition < 218)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Full over outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"Full over outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                
            }
            else if(Xposition >217 && Yposition >37 && Xposition < 260)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"yorker wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC037";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
            }
            
            Img_ball.image =[UIImage imageNamed:@"RedBall"];
            [self.img_pichmap addSubview:Img_ball];
            self.ballEventRecord.objPMlengthcode=@"MSC037";
            self.ballEventRecord.objPMlinecode =@"MSC031";
            
        }
        else if ((Xposition > 100 && Yposition > 104 && Xposition < 271 && Yposition < 128))
        {
            if(Xposition > 100 && Yposition > 104 && Xposition < 151)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker wide0.0");
                    self.ballEventRecord.objPMlengthcode=@"msc036";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"yorker wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
            }
            else if(Xposition >156 && Yposition >104 && Xposition < 177)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"yorker outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                
            }
            else if(Xposition >177 && Yposition >104 && Xposition < 198)
            {
                NSLog(@"yorker Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC036";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >197 && Yposition >104 && Xposition < 219)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"yorker outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                
            }
            else if(Xposition >216 && Yposition >104 && Xposition < 267)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"yorker wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"yorker wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC036";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"Full wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
            }
            else if(Xposition >93 && Yposition >127 && Xposition < 174)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"full outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                
            }
            else if(Xposition >175 && Yposition >127 && Xposition < 197)
            {
                NSLog(@"full Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC035";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >198 && Yposition >127 && Xposition < 227)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    NSLog(@"full outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                
            }
            else if(Xposition >220 && Yposition >127 && Xposition < 281)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"full wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"full wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC035";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"good wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            else if(Xposition > 130 && Yposition > 160 && Xposition < 166)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"good outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"good outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
            }
            else if(Xposition >162 && Yposition >160 && Xposition < 203)
            {
                NSLog(@"good Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC034";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >203 && Yposition >160 && Xposition < 239)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"good outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"good outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
            }
            else if(Xposition >215 && Yposition >134 && Xposition < 294)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"good wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"good wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC034";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"short wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            else if(Xposition >125 && Yposition >220 && Xposition < 160)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"short outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"short outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                
            }
            else if(Xposition >163 && Yposition >220 && Xposition < 207)
            {
                NSLog(@"short Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC033";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >207 && Yposition >220 && Xposition < 250)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"short outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"short outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                
            }
            else if(Xposition >250 && Yposition >220 && Xposition < 315)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"short wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"short wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC033";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
                }
                else{
                    NSLog(@"Bouncer wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                
            }
            else if(Xposition >110 && Yposition >288 && Xposition < 156)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Bouncer outside OFF");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
                else{
                    NSLog(@"Bouncer outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                
            }
            else if(Xposition >159 && Yposition >290 && Xposition < 213)
            {
                NSLog(@"Bouncer Middle");
                self.ballEventRecord.objPMlengthcode=@"MSC032";
                self.ballEventRecord.objPMlinecode =@"MSC026";
            }
            else if(Xposition >213 && Yposition >290 && Xposition < 268)
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Bouncer outside LEG");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC029";
                }
                else{
                    NSLog(@"Bouncer outside off");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC028";
                }
            }
            else if(Xposition >260 && Yposition >290 && Xposition < 325 )
            {
                if([self.BatmenStyle isEqualToString:@"MSC013"])
                {
                    NSLog(@"Bouncer wide D.L");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC030";
                }
                else{
                    
                    NSLog(@"Bouncer wide 0.0");
                    self.ballEventRecord.objPMlengthcode=@"MSC032";
                    self.ballEventRecord.objPMlinecode =@"MSC031";
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
    
    
    _View_Appeal.hidden=YES;
    self.view_bowlType.hidden = YES;
    self.view_fastBowl.hidden = YES;
    self.view_aggressiveShot.hidden = YES;
    self.view_defensive.hidden = YES;
    self.img_pichmap.hidden=YES;
    self.PichMapTittle.hidden=YES;
    self.view_Wagon_wheel.hidden=YES;
    self.objcommonRemarkview.hidden=YES;
    
    if (ispichmapSelectValue== NO)
    {
        [self unselectedButtonBg:self.btn_pichmap];
    }

    //wicket
    if(isWicketSelected && selectBtnTag.tag != 107 && wicketOption !=0){
        
        isWicketSelected= NO;
        selectedwickettype = nil;
        selectedWicketEvent = nil;
        selectedStrikernonstriker = nil;
        selectedwicketBowlerlist =nil;
        [self unselectedButtonBg:self.btn_wkts];
        
        
    }
    
    
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
    
    if (isRBWSelected && selectBtnTag.tag!=119) {
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
        //[self selectBtncolor_Action:@"114"];
     
        
        self.view_bowlType.hidden = NO;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden = YES;
        
        if(isSpinSelected && self.ballEventRecord.objBowltype != nil){
            [self selectedViewBg:_view_spin];
            
            int indx=0;
            int selectePosition = -1;
            for (BowlAndShotTypeRecords *record in self.bowlTypeArray)
            {
                bool chk = ([[record BowlTypeCode] isEqualToString:self.ballEventRecord.objBowltype]);
                if (chk)
                {
                    selectePosition = indx;
                    break;
                }
                indx ++;
            }
            
            if(selectePosition!=-1){
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
                [tbl_bowlType selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_bowlType scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
            }
        }else if(isSpinSelected && self.ballEventRecord.objBowltype == nil){
            
            [self unselectedViewBg:_view_spin];
            self.view_bowlType.hidden = YES;
            isSpinSelected = NO;
            
        }else{
            
            self.ballEventRecord.objBowltype = nil;
            isSpinSelected = YES;
            isFastSelected = NO;
            
            [self selectedViewBg:_view_spin];
            [tbl_bowlType reloadData];
            
        }
        
        [self unselectedViewBg:_view_fast];
        
        
    }
    else if(selectBtnTag.tag==115)//fast
    {
        //[self selectBtncolor_Action:@"115" :nil :204];
        self.view_aggressiveShot.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        self.view_defensive.hidden = YES;
        
        self.lbl_fast.text=@"Fast";
        //[tbl_fastBowl reloadData];
        
        if(isFastSelected && self.ballEventRecord.objBowltype != nil){
            [self selectedViewBg:_view_fast];
            
            int indx=0;
            int selectePosition = -1;
            for (BowlAndShotTypeRecords *record in self.bowlTypeArray)
            {
                bool chk = ([[record BowlTypeCode] isEqualToString:self.ballEventRecord.objBowltype]);
                if (chk)
                {
                    selectePosition = indx;
                    break;
                }
                indx ++;
            }
            
            if(selectePosition!=-1){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
                [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
            }
        }
        else if(isFastSelected && self.ballEventRecord.objBowltype == nil){
            
            [self unselectedViewBg:_view_fast];
            self.view_fastBowl.hidden = YES;
            isFastSelected = NO;
            
        }else{
            
            self.ballEventRecord.objBowltype = nil;
            isFastSelected = YES;
            isSpinSelected = NO;
            
            [self selectedViewBg:_view_fast];
            [tbl_fastBowl reloadData];
            
        }
        
        [self unselectedViewBg:_view_spin];

//        }else{
//            self.ballEventRecord.objBowltype = nil;
//            [tbl_fastBowl reloadData];
//        }
//        
//        //View
//        _view_fast.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
//        
//        _view_spin.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        
        
    }
    else if(selectBtnTag.tag==116)//aggressive
    {
        //[self selectBtncolor_Action:@"116" :nil :205];
        self.view_aggressiveShot.hidden = NO;
        self.view_fastBowl.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_defensive.hidden = YES;
        
        if(isAggressiveSelected && self.ballEventRecord.objShottype != nil){
            [self selectedViewBg:_view_aggressive];
            int indx=0;
            int selectePosition = -1;
            for (BowlAndShotTypeRecords *record in self.aggressiveShotTypeArray)
            {
                bool chk = ([[record ShotType] isEqualToString:self.ballEventRecord.objShottype]);
                if (chk)
                {
                    selectePosition = indx;
                    break;
                }
                indx ++;
            }
            
            if(selectePosition!=-1){
                
                //   NSInteger position = [self.aggressiveShotTypeArray indexOfObject:self.ballEventRecord.objShottype];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
                [tbl_aggressiveShot selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_aggressiveShot scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionTop
                                                  animated:YES];
            }
        }else if(isAggressiveSelected && self.ballEventRecord.objShottype == nil){
            
            [self unselectedViewBg:_view_aggressive];
            self.view_aggressiveShot.hidden = YES;
            isAggressiveSelected = NO;
            
        }else{
            
            self.ballEventRecord.objShottype = nil;
            isAggressiveSelected = YES;
            isDefensiveSelected = NO;
            
            [self selectedViewBg:_view_aggressive];
            [tbl_aggressiveShot reloadData];
            
        }
        
        [self unselectedViewBg:_view_defense];
        
        
    }
    else if(selectBtnTag.tag==117)//Defensive
    {
        //[self selectBtncolor_Action:@"117" :nil :206];
        self.view_defensive.hidden = NO;
        self.view_aggressiveShot.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_bowlType.hidden = YES;
       
        if(isDefensiveSelected && self.ballEventRecord.objShottype != nil){
            
            [self selectedViewBg:_view_defense];
              
            int indx=0;
            int selectePosition = -1;
            for (BowlAndShotTypeRecords *record in self.defensiveShotTypeArray)
            {
                bool chk = ([[record ShotType] isEqualToString:self.ballEventRecord.objShottype]);
                if (chk)
                {
                    selectePosition = indx;
                    break;
                }
                indx ++;
            }
                       if(selectePosition!=-1){
                
                //  NSInteger position = [self.defensiveShotTypeArray indexOfObject:self.ballEventRecord.objShottype];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
                [_tbl_defensive selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [_tbl_defensive scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
                

            }
        }else if(isDefensiveSelected && self.ballEventRecord.objShottype == nil){
            
            [self unselectedViewBg:_view_defense];
            self.view_defensive.hidden = YES;
            isDefensiveSelected = NO;

        }else{
            
            self.ballEventRecord.objShottype = nil;
            isDefensiveSelected = YES;
            isAggressiveSelected = NO;
           
            [self selectedViewBg:_view_defense];
           [_tbl_defensive reloadData];
           
        }
        
        [self unselectedViewBg:_view_aggressive];
        
        //View
        //_view_defense.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
      //  _view_aggressive.backgroundColor = [UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];//Normal
        
        
        
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
                if(selectePosition >=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
                [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
                }
                
            }
        }
        
    }
    else if(selectBtnTag.tag==119)//RBW
    {
        
        
        
        
        if (isRBWSelected) {
            if(self.ballEventRecord.objRbw.intValue!=0){
                
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
                
            }else{
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
                
            }
            if(rbwTableview!=nil){
                [rbwTableview removeFromSuperview];
            }
            
            isRBWSelected = NO;
  
        }else{
            isRBWSelected = YES;
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            self.rbwOptionArray=[[NSMutableArray alloc]initWithObjects:@"-5",@"-4",@"-3",@"-2",@"-1",@"1",@"2",@"3",@"4",@"5", nil];
            
            
            rbwTableview=[[UITableView alloc]initWithFrame:CGRectMake(self.commonleftrightview.frame.size.width-180, self.btn_RBW.frame.origin.y-80,100,250)];
            rbwTableview.backgroundColor=[UIColor whiteColor];
            rbwTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
             [rbwTableview setSeparatorColor:[UIColor whiteColor]];
            
            
            rbwTableview.dataSource = self;
            rbwTableview.delegate = self;
            [self.commonleftrightview addSubview:rbwTableview];
            [rbwTableview reloadData];
            
            
            if(self.ballEventRecord.objRbw!=0){
                NSInteger position = [self.rbwOptionArray indexOfObject:self.ballEventRecord.objRbw];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
                [rbwTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [rbwTableview scrollToRowAtIndexPath:indexPath
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
                
            }
        }
    }
    else if(selectBtnTag.tag==120)
    {
        //  [self selectBtncolor_Action:@"120" :nil :209];
        
        
        [self selectedViewBg: _view_remark];
        [self RemarkMethode];
        
    }
    else if(selectBtnTag.tag==121)
    {
        //   [self selectBtncolor_Action:@"121" :nil :210];
    }
    else if(selectBtnTag.tag==122)//Appels
    {
        //  [self selectBtncolor_Action:@"122" :nil :211];
        
//        if( _view_appeal.hidden) {
//            _View_Appeal.hidden = false;
//        } else {
//            _View_Appeal.hidden = true;
//        }
//        
        
    _View_Appeal.hidden=NO;
        
        
        
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        [self selectedViewBg:_view_appeal];
        
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
    self.objcommonRemarkview=[[UIView alloc]initWithFrame:CGRectMake(self.Allvaluedisplayview.frame.origin.x-110,self.Allvaluedisplayview.frame.origin.y+50, self.Allvaluedisplayview.frame.size.width-100, 200)];
    [self.objcommonRemarkview setBackgroundColor:[UIColor grayColor]];
    self.txt_Remark=[[UITextView alloc]initWithFrame:CGRectMake(self.objcommonRemarkview.frame.origin.x-30,self.objcommonRemarkview.frame.origin.y-110, self.objcommonRemarkview.frame.size.width-40,120)];
    [_txt_Remark setBackgroundColor:[UIColor whiteColor]];
    
    [self.objcommonRemarkview addSubview:_txt_Remark];
    
    [self.Allvaluedisplayview addSubview:self.objcommonRemarkview];
    
    
    if(self.ballEventRecord.objRemark!=nil){
        self.txt_Remark.text = self.ballEventRecord.objRemark;
    }
    
    
    
    UIButton *btn_save=[[UIButton alloc]initWithFrame:CGRectMake(self.objcommonRemarkview.frame.origin.x-10,self.objcommonRemarkview.frame.size.height-50,50,50)];
    //[btn_save setBackgroundColor:[UIColor whiteColor]];
    [btn_save setTitle:@"Save" forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(didClickRemarkSave_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.objcommonRemarkview addSubview:btn_save];
    self.objcommonRemarkview.hidden=NO;
    
    UIButton *btn_Cancel=[[UIButton alloc]initWithFrame:CGRectMake(self.objcommonRemarkview.frame.size.width-90,self.objcommonRemarkview.frame.size.height-50,60,50)];
    [btn_Cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    //[btn_Cancel setBackgroundColor:[UIColor whiteColor]];
    [btn_Cancel addTarget:self action:@selector(didClickRemarkCancel_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.objcommonRemarkview addSubview:btn_Cancel];
    btn_Cancel.userInteractionEnabled=YES;
   
    
}
-(IBAction)didClickRemarkSave_Action:(id)sender
{
    
    self.ballEventRecord.objRemark=self.txt_Remark.text;
    NSLog(@"remarks : %@",remarks);
    self.objcommonRemarkview.hidden=YES;
}
-(IBAction)didClickRemarkCancel_Action:(id)sender
{
    
    self.objcommonRemarkview.hidden=YES;
}
//
//-(void)selectBtncolor_Action:(NSString*)select_Btntag :(UIButton *)select_BtnName :(NSInteger)selectview
//{
//    if(select_BtnName!= 0)
//    {
//        for (id obj in self.leftsideview.subviews) {
//
//            NSString *classStr = NSStringFromClass([obj class]);
//
//            if ([classStr isEqualToString:@"UIButton"]) {
//                UIButton *button = (UIButton*)obj;
//                NSLog(@"tag=%ld",(long)button.tag);
//                button.backgroundColor=[UIColor blackColor];
//                if(button.tag== select_BtnName.tag)
//                {
//
//                    if(isSelectleftview==NO)
//                    {
//                        for (id obj in self.Rightsideview.subviews) {
//
//                            NSString *classStr = NSStringFromClass([obj class]);
//
//                            if ([classStr isEqualToString:@"UIView"]) {
//                                UIView *button = (UIView*)obj;
//                                NSLog(@"tag=%ld",(long)button.tag);
//                                button.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
//                            }
//                        }
//
//                    }
//                    isSelectleftview=YES;
//                    button.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
//
//                }
//            }
//        }
//
//    }
//    else{
//        for (id obj in self.Rightsideview.subviews) {
//
//            NSString *classStr = NSStringFromClass([obj class]);
//
//            if ([classStr isEqualToString:@"UIView"]) {
//                UIView *button = (UIView*)obj;
//                NSLog(@"tag=%ld",(long)button.tag);
//                button.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
//                if(button.tag== selectview)
//                {
//
//                    if(isSelectleftview==YES)
//                    {
//                        for (id obj in self.leftsideview.subviews) {
//
//                            NSString *classStr = NSStringFromClass([obj class]);
//
//                            if ([classStr isEqualToString:@"UIButton"]) {
//                                UIButton *button = (UIButton*)obj;
//                                NSLog(@"tag=%ld",(long)button.tag);
//                                button.backgroundColor=[UIColor blackColor];
//                            }
//                        }
//
//                    }
//                    isSelectleftview=NO;
//
//                    button.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
//                }
//
//            }
//        }
//
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Sathish

-(void) resetBallEventObject{
    self.ballEventRecord = [[BallEventRecord alloc] init];
    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:0];
    self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
    
    
    self.ballEventRecord.objByes = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objWide = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objNoball = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:1];
    
    
    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objTotalruns = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objPenalty = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objTotalextras = [NSNumber numberWithInt:0];;
    self.ballEventRecord.objGrandtotal = [NSNumber numberWithInt:0];
    
    self.ballEventRecord.objRemark = @"";
    
    
    
    self.ballEventRecord.objOverno=[NSNumber numberWithInt:fetchSEPageLoadRecord.BATTEAMOVERS];
    self.ballEventRecord.objBallno=[NSNumber numberWithInteger: fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT];
    self.ballEventRecord.objOverBallcount = [NSNumber numberWithInteger: 0 ];
    self.ballEventRecord.objBallcount=@1;
    self.ballEventRecord.objBowlercode = fetchSEPageLoadRecord.currentBowlerPlayerCode;
    self.ballEventRecord.objStrikercode = fetchSEPageLoadRecord.strickerPlayerCode;
    self.ballEventRecord.objNonstrikercode = fetchSEPageLoadRecord.nonstrickerPlayerCode;
    
    self.ballEventRecord.objRbw =[NSNumber numberWithInt:0];
    self.ballEventRecord.objIswtb=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsuncomfort=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsreleaseshot=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsbeaten=[NSNumber numberWithInt:0];
    self.ballEventRecord.objPMlengthcode=@"";
    self.ballEventRecord.objPMlinecode =@"";
    self.ballEventRecord.objPMX1=@1;
    self.ballEventRecord.objPMY1=@1;
    self.ballEventRecord.objPMX2=@1;
    self.ballEventRecord.objPMY2=@1;
    if (IS_IPAD_PRO) {
        _ballEventRecord.objWWX1=@(221);
        _ballEventRecord.objWWY1=@(186);
        _ballEventRecord.objWWX2=@(221);
        _ballEventRecord.objWWY2=@(186);
    }
    else{
        
        _ballEventRecord.objWWX1=@(172);
        _ballEventRecord.objWWY1=@(145);
        _ballEventRecord.objWWX2=@(172);
        _ballEventRecord.objWWY2=@(145);
        
    }
    
    self.ballEventRecord.objWWREGION=@"";
    // self.ballEventRecord.objOverno=fetchSEPageLoadRecord.MATCHOVERS;
    self.ballEventRecord.objBowlercode=fetchSEPageLoadRecord.currentBowlerPlayerCode;
    
    
    isMoreRunSelected = NO;
    isExtrasSelected = NO;
    isOverthrowSelected = NO;
    
   
    
    //Wicket
    isWicketSelected = NO;
    selectedStrikernonstriker = nil;
    selectedStrikernonstrikerCode = nil;
    wicketOption = 0;
    selectedwickettype =nil;
    selectedWicketPlayerCode = nil;
    selectedWicketEvent = nil;
    selectedwicketBowlerlist=nil;
    
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
    [extrasTableView removeFromSuperview ];
    [self unselectedButtonBg: self.btn_wkts];
    [self unselectedButtonBg: self.btn_overthrow];
    [self unselectedButtonBg: self.btn_miscFilter];
    [self unselectedButtonBg: self.btn_pichmap];
    self.img_pichmap.hidden=YES;
    self.PichMapTittle.hidden=YES;
    [self unselectedButtonBg: self.btn_wagonwheel];
    self.view_Wagon_wheel.hidden=YES;
    
    //Right buttons
    [self unselectedViewBg: self.view_otw];
    [self unselectedViewBg: self.view_rtw];
    [self unselectedViewBg: self.view_spin];
    [self.tbl_bowlType reloadData];
    [self unselectedViewBg: self.view_fast];
    [self.tbl_fastBowl reloadData];
    [self unselectedViewBg: self.view_aggressive];
    [self.tbl_aggressiveShot reloadData];
    self.view_aggressiveShot.hidden=YES;
    isAggressiveSelected=NO;
    [self unselectedViewBg:self.view_defense];
    [_tbl_defensive reloadData];
    self.view_defensive.hidden=YES;
    isDefensiveSelected=NO;
    [self unselectedViewBg: self.view_fielding_factor];
     selectedfieldFactor = [[FieldingFactorRecord alloc]init];
    [self unselectedViewBg: self.view_Rbw];
    [self unselectedViewBg: self.view_remark];
    self.objcommonRemarkview.hidden=YES;
  //[self unselectedViewBg: self.view_edit];   need to set reference
    [self unselectedViewBg:self.view_appeal];
    self.View_Appeal.hidden=YES;
    isEnableTbl=NO;
    isPitchmap =NO;
  //[self unselectedViewBg: self.View_Appeal];
  //[self unselectedViewBg: self.view_lastinstance];
    
    if(Img_ball != nil)
    {
        [Img_ball removeFromSuperview];
    }
    for (CALayer *layer in self.img_WagonWheel.layer.sublayers) {
        if ([layer.name isEqualToString:@"DrawLine"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    
    //More option
    //Set up toggle image
    [self.btn_highRun setImage:[UIImage imageNamed:@"moreRuns"] forState:UIControlStateNormal];
    
    //Set run button values
    [self.btn_run1 setTitle:@"1" forState:UIControlStateNormal];
    [self.btn_run2 setTitle:@"2" forState:UIControlStateNormal];
    [self.btn_run3 setTitle:@"3" forState:UIControlStateNormal];
    [self.btn_B4 setTitle:@"B4" forState:UIControlStateNormal];
    [self.btn_B6 setTitle:@"B6" forState:UIControlStateNormal];
    
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
    
    if (self.tanle_umpirename.hidden ==YES) {
        
        self.tanle_umpirename.hidden=NO;
        
    }
    else
        self.tanle_umpirename.hidden=YES;

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
    
    NSString * run1value;
    NSString * run2value;
    NSString * run3value;
    NSString * run4value;
    NSString * run5value;
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
                NSString * run1value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                self.txt_Commantry.text =run1value;
                
            }else if(self.ballEventRecord.objRuns.integerValue == 4){// If runs has four
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:1];
                    [self selectedButtonBg: self.btn_run1];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run1];
                }
                NSString * run1value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                self.txt_Commantry.text =run1value;
                
                
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?4:1];
                [self selectedButtonBg: self.btn_run1];
                NSString * run1value =[NSString stringWithFormat:@"RUN FOR %@",self.ballEventRecord.objRuns];
                self.txt_Commantry.text =run1value;
                NSLog(@"%@",run1value);
                
                
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
                NSString * run2value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                self.txt_Commantry.text =run2value;
                
            }else if(self.ballEventRecord.objRuns.integerValue == 5){// If runs has five
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:2];
                    [self selectedButtonBg: self.btn_run2];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run2];
                }
                //                NSString * run2value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run2value;
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?5:2];
                [self selectedButtonBg: self.btn_run2];
                //                NSString * run2value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run2value;
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
                //                NSString * run3value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run3value;
            }else if(self.ballEventRecord.objRuns.integerValue == 6){// If runs has six
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:3];
                    [self selectedButtonBg: self.btn_run3];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run3];
                }
                //                NSString * run3value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run3value;
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?6:3];
                [self selectedButtonBg: self.btn_run3];
                //                NSString * run3value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run3value;
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
                //                NSString * run4value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run4value;
                
            } else if( self.ballEventRecord.objRuns.integerValue == 7){// If runs has seven
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B4];
                }else{
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:1];
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:4];
                    
                    [self selectedButtonBg: self.btn_B4];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
                //                NSString * run4value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run4value;
            }
            else{//Other run selected
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:7];
                }else{
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:1];
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:4];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                    
                }
                
                [self selectedButtonBg: self.btn_B4];
                //                NSString * run4value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run4value;
                
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
                //                NSString * run5value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run5value;
                
            } else if( self.ballEventRecord.objRuns.integerValue == 8){// If runs has eight
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B6];
                }else{
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:1];
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:6];
                    [self selectedButtonBg: self.btn_B6];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
                //                NSString * run5value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run5value;
            }
            else{//Other run selected
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:8];
                }else{
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:1];
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:6];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
                
                [self selectedButtonBg: self.btn_B6];
                //                NSString * run5value =[NSString stringWithFormat:@" RUN FOR %@",self.ballEventRecord.objRuns];
                //                self.txt_Commantry.text =run5value;
            }
            
            break;
        default:
            break;
    }
    //self.txt_Commantry.text =[NSString stringWithFormat:@"%@ "];
    
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
-(void) disableButtonBg :(UIButton *) select_btn{
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
        if(self.ballEventRecord.objRuns.integerValue == 4 && self.ballEventRecord.objIsFour.integerValue != 1){
            [self selectedButtonBg: self.btn_run1];
        }else if(self.ballEventRecord.objRuns.integerValue == 5){
            [self selectedButtonBg: self.btn_run2];
        }else if(self.ballEventRecord.objRuns.integerValue == 6 && self.ballEventRecord.objIssix.integerValue != 1){
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
    }
    else if (isWicketSelected==YES && isCaught==YES)
    {
        extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide", nil];
    }
    else{// Default
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
        //extrasTableView.allowsMultipleSelection=NO;
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
    
    
    if(tableView == table_Appeal){
        if(appealEventDict==nil){
            appealEventDict = [NSMutableDictionary dictionary];
        }
        AppealComponentRecord *appealRecord=(AppealComponentRecord*)[AppealComponentArray objectAtIndex:indexPath.row];
        [appealEventDict setValue:appealRecord.AppealComponentMetaSubCode forKey:@"AppealTypeCode"];
        
        _view_table_select.hidden=NO;
    }
    
    if(breakvc.view != nil)
    {
        [breakvc.view removeFromSuperview];
    }
    
    
    
    if(leftSlideSwipe == YES){
        
        if(indexPath.row == 0)
        {
            NSLog(@"1");
            
            [self BreakviewMethod];
        }
        else if(indexPath.row == 1)
        {
            NSLog(@"2");
            [self ChangeTeam];
        }
        else if(indexPath.row == 2)
        {
            NSLog(@"3");
            [self DeclearINNINGS];
        }
        else if(indexPath.row == 3)
        {
            NSLog(@"4");
            [self ENDDAY];
        }
        else if(indexPath.row == 4)
        {
            NSLog(@"5");
            [self ENDINNINGS];
        }
        else if(indexPath.row == 5)
        {
            NSLog(@"6");
            [self ENDSession];
        }
        else if(indexPath.row == 6)
        {
            NSLog(@"7");
            [self FollowOn];
        }
        else if(indexPath.row == 7)
        {
            NSLog(@"8");
            [self matchInfoEdit];
        }
        else if(indexPath.row == 8)
        {
            NSLog(@"9");
            [self MatchResult];
        }
        else if(indexPath.row == 9)
        {
            NSLog(@"10");
            [self OtherWicket];
        }
        else if(indexPath.row == 10)
        {
            NSLog(@"11");
            [self Penalty];
        }
        
        else if(indexPath.row == 11)
        {
            NSLog(@"12");
            [self PowerPlay];
        }
        else if(indexPath.row == 12)
        {
            NSLog(@"13");
            [self revisedoverview];
        }
        else if(indexPath.row == 13)
        {
            NSLog(@"14");
            [self revisiedTarget];
        }
        
        
    }
    
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
        
        umpiretablecell *cell = (umpiretablecell *)[tableView cellForRowAtIndexPath:indexPath];
        self.lbl_umpirename.text =cell.textLabel.text;
          _test=[AppealUmpireArray objectAtIndex:indexPath.row];
        UmpireSelect=  self.lbl_umpirename.text;
        
      UmpireSelect=[_test valueForKey:@"AppealumpireCode"];
        
      
        self.tanle_umpirename.hidden=YES;
        isEnableTbl=YES;
    }
    
    if (tableView == self.table_BatsmenName)
    {
        Batsmancell *cell = (Batsmancell *)[tableView cellForRowAtIndexPath:indexPath];
       self.lbl_batsmen.text =cell.textLabel.text;
        
        _test1=[AppealBatsmenArray objectAtIndex:indexPath.row];
      StrikerPlayer=self.lbl_batsmen.text;
        
        StrikerPlayer=[_test1 valueForKey:@"AppealBatsmenPlayerCode"];
       
        
        self.table_BatsmenName.hidden=YES;
        isEnableTbl=YES;
        
        
        
        
        
    }
    
    
    
    
    //wicket type
    if(isWicketSelected && wicketOption == 1)
    {
        selectedwickettype = [self.WicketTypeArray objectAtIndex:indexPath.row];
        if([selectedwickettype.metasubcode isEqualToString:@"MSC097"]|| [selectedwickettype.metasubcode isEqualToString:@"MSC106"])
        {
            self.StrikerandNonStrikerArray=[[NSMutableArray alloc]initWithObjects:fetchSEPageLoadRecord.strickerPlayerName,fetchSEPageLoadRecord.nonstrickerPlayerName, nil];
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
            self.WicketEventArray=[[NSMutableArray alloc]initWithObjects:@"Tough",@"Medium",@"Easy", nil];
            
            [self disableButtonBg:self.btn_B6];
            [self disableButtonBg:self.btn_B4];
            isCaught=YES;
            
            self.btn_B6.userInteractionEnabled =NO;
            self.btn_B4.userInteractionEnabled= NO;
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
        
        if([selectedStrikernonstriker isEqual:fetchSEPageLoadRecord.strickerPlayerName]){
            selectedStrikernonstrikerCode = fetchSEPageLoadRecord.strickerPlayerCode;
        }else{
            selectedStrikernonstrikerCode = fetchSEPageLoadRecord.nonstrickerPlayerCode;
        }
        
        self.WicketEventArray=[[NSMutableArray alloc]initWithObjects:@"Tough",@"Medium",@"Easy", nil];
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
            // _PlayerlistArray =[DBManager RetrievePlayerData:self.ma];
            _PlayerlistArray=[DBManager RetrievePlayerData:self.matchCode :fetchSEPageLoadRecord.BOWLINGTEAMCODE];
            
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
            
           // isWicketSelected = NO;
        }
        
    }else if(isWicketSelected && wicketOption == 4)
    {
        
        selectedwicketBowlerlist = [self.PlayerlistArray objectAtIndex:indexPath.row];
        
        wicketOption = 0;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden =YES;
        
      //  isWicketSelected = NO;
    }else if(isFieldingSelected && fieldingOption == 1) //Fielding Factor
    {
        selectedfieldFactor = [self.fieldingfactorArray objectAtIndex:indexPath.row];
        
        _fieldingPlayerArray=[[NSMutableArray alloc]init];
        _fieldingPlayerArray =[DBManager RetrieveFieldingPlayerData:self.matchCode:fetchSEPageLoadRecord.BATTINGTEAMCODE];
        
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
    }else if (tbl_fastBowl == tableView){ // Fast bowling
        
        //        isFastSelected = YES;
        //        isSpinSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.fastBowlTypeArray objectAtIndex:indexPath.row];
        //self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        if(!isFastSelected && self.ballEventRecord.objBowltype==nil){
            isFastSelected = YES;
            isSpinSelected = NO;
            self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
            
        }else if(isFastSelected && self.ballEventRecord.objBowltype!=nil && self.ballEventRecord.objBowltype == bowlAndShortTypeRecord.BowlTypeCode){
            isFastSelected = NO;
            self.ballEventRecord.objBowltype = nil;
            [self unselectedViewBg:_view_fast];
            
        }
        else{
            isFastSelected = YES;
            isSpinSelected = NO;
            self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        }
        
        
        
        self.view_fastBowl.hidden = YES;
        
        
        
    }
    
    // _view_table_select.hidden=NO;
    NSLog(@"Index Path %d",indexPath.row);
    
    if(tableView == extrasTableView){//Extras table view
        
        if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"NoBall"]){//No ball
            
            if(isWicketSelected ==YES)
            {
                _WicketTypeArray=[[NSMutableArray alloc]init];
                NSMutableArray *tempWickettypeArray  =[DBManager RetrieveWicketType];
                
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                    if([wicketTypeRecord.metasubcode isEqual:@"MSC097"]||[wicketTypeRecord.metasubcode isEqual:@"MSC100"]||[wicketTypeRecord.metasubcode isEqual:@"MSC103" ]||[wicketTypeRecord.metasubcode isEqual:@"MSC106"]){
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                    
                }
                self.view_aggressiveShot.hidden = YES;
                self.view_defensive.hidden = YES;
                self.view_bowlType.hidden = YES;
                self.view_fastBowl.hidden = NO;
                isWicketSelected =YES;
                wicketOption = 1;
                [self.tbl_fastBowl reloadData];
            }
            //B6
            else{
                
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
            }
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Wide"]){//Wide
            
            if(isWicketSelected ==YES)
            {
                _WicketTypeArray=[[NSMutableArray alloc]init];
                NSMutableArray *tempWickettypeArray  =[DBManager RetrieveWicketType];
                
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                    if([wicketTypeRecord.metasubcode isEqual:@"MSC097"] ||[wicketTypeRecord.metasubcode isEqual:@"MSC104"]||[wicketTypeRecord.metasubcode isEqual:@"MSC099"]||[wicketTypeRecord.metasubcode isEqual:@"MSC106"]){
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                    
                }
                self.view_aggressiveShot.hidden = YES;
                self.view_defensive.hidden = YES;
                self.view_bowlType.hidden = YES;
                self.view_fastBowl.hidden = NO;
                isWicketSelected =YES;
                wicketOption = 1;
                [self.tbl_fastBowl reloadData];
            }
            //B6
            else{
                
                
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
            }
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Byes"]){//Byes
            //B6
            if(isWicketSelected ==YES)
            {
                _WicketTypeArray=[[NSMutableArray alloc]init];
                NSMutableArray *tempWickettypeArray  =[DBManager RetrieveWicketType];
                
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                    if([wicketTypeRecord.metasubcode isEqual:@"MSC097"]){
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                    
                }
                self.view_aggressiveShot.hidden = YES;
                self.view_defensive.hidden = YES;
                self.view_bowlType.hidden = YES;
                self.view_fastBowl.hidden = NO;
                isWicketSelected =YES;
                wicketOption = 1;
                [self.tbl_fastBowl reloadData];
            }
            //B6
            else{
                
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
            }
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"LegByes"]){//Legbyes
            
            
            if (_ballEventRecord.objIsbeaten.intValue == 1)// Check beaten selected
            {
                
                UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Legbyes is not possible with Beaten. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [altert show];
                [altert setTag:10402];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [extrasTableView deselectRowAtIndexPath:indexPath animated:NO];
                
            }
            else{
            
            
            //B6
            if(isWicketSelected ==YES)
            {
                _WicketTypeArray=[[NSMutableArray alloc]init];
                NSMutableArray *tempWickettypeArray  =[DBManager RetrieveWicketType];
                
                for(int i=0;i<tempWickettypeArray.count;i++){
                    WicketTypeRecord *wicketTypeRecord =[tempWickettypeArray objectAtIndex:i];
                    if([wicketTypeRecord.metasubcode isEqual:@"MSC097"]){
                        [_WicketTypeArray addObject:[tempWickettypeArray objectAtIndex:i]];
                    }
                    
                }
                self.view_aggressiveShot.hidden = YES;
                self.view_defensive.hidden = YES;
                self.view_bowlType.hidden = YES;
                self.view_fastBowl.hidden = NO;
                isWicketSelected =YES;
                wicketOption = 1;
                [self.tbl_fastBowl reloadData];
            }
            //B6
            else{
                
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
            }
            
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
            
            if([self checkBeatenOnSelect]){ //Check run is selected
                self.ballEventRecord.objIsbeaten = [NSNumber numberWithInt:1];
            }else{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [miscFiltersTableview deselectRowAtIndexPath:indexPath animated:NO];
                
            }
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Release Shot"]){
            self.ballEventRecord.objIsreleaseshot = [NSNumber numberWithInt:1];
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"WTB"]){
            self.ballEventRecord.objIswtb = [NSNumber numberWithInt:1];
        }
    }else if(tbl_bowlType == tableView){
        
//        isSpinSelected = YES;
//        isFastSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.bowlTypeArray objectAtIndex:indexPath.row];
       // self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        
        if(!isSpinSelected && self.ballEventRecord.objBowltype==nil){
            isSpinSelected = YES;
            isFastSelected = NO;
            self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
            
        }else if(isSpinSelected && self.ballEventRecord.objBowltype!=nil && self.ballEventRecord.objBowltype == bowlAndShortTypeRecord.BowlTypeCode){
            isSpinSelected = NO;
            self.ballEventRecord.objBowltype = nil;
            [self unselectedViewBg:_view_spin];
            
        }
        else{
            isSpinSelected = YES;
            isFastSelected = NO;
            self.ballEventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        }
        
        
        
        self.view_bowlType.hidden = YES;
        
        

        
        
        
        
        //        if([bowlAndShortTypeRecord.BowlTypeCode  isEqualToString:objBalleventRecord.objBowltype])
        //        {
        //            objBalleventRecord.objBowltype = nil;
        //            [tbl_bowlType reloadData];
        //        }
        
        
    }else if (tbl_aggressiveShot == tableView){
        
        
//        isAggressiveSelected = YES;
//        isDefensiveSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.aggressiveShotTypeArray objectAtIndex:indexPath.row];
        
        //self.ballEventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
        
        if(!isAggressiveSelected && self.ballEventRecord.objShottype==nil){
            isAggressiveSelected = YES;
            isDefensiveSelected = NO;
            self.ballEventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
            
        }else if(isAggressiveSelected && self.ballEventRecord.objShottype!=nil && self.ballEventRecord.objShottype == bowlAndShortTypeRecord.ShotTypeCode){
            isAggressiveSelected = NO;
            self.ballEventRecord.objShottype = nil;
            [self unselectedViewBg:_view_aggressive];
            
        }
        else{
            isAggressiveSelected = YES;
            isDefensiveSelected = NO;
            self.ballEventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
        }
        
        
        
        self.view_aggressiveShot.hidden = YES;
        
        
        
    }else if (_tbl_defensive == tableView){
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.defensiveShotTypeArray objectAtIndex:indexPath.row];

//        isDefensiveSelected = YES;
//        isAggressiveSelected = NO;
//        
        if(!isDefensiveSelected && self.ballEventRecord.objShottype==nil){
            isDefensiveSelected = YES;
            isAggressiveSelected = NO;
            self.ballEventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;

        }else if(isDefensiveSelected && self.ballEventRecord.objShottype!=nil && self.ballEventRecord.objShottype == bowlAndShortTypeRecord.ShotTypeCode){
            isDefensiveSelected = NO;
            self.ballEventRecord.objShottype = nil;
            [self unselectedViewBg:_view_defense];
            
        }
        else{
            isDefensiveSelected = YES;
            isAggressiveSelected = NO;
            self.ballEventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
        }
        

       
        self.view_defensive.hidden = YES;
        
        
        
    }else if(tableView == currentBowlersTableView){
        
        BowlerEvent *bowlEvent = [fetchSEPageLoadRecord.getBowlingTeamPlayers objectAtIndex:indexPath.row];
        //InitializeInningsScoreBoardRecord *initializeInningsScoreBoardRecord = [[InitializeInningsScoreBoardRecord alloc]init];
        
        [InitializeInningsScoreBoardRecord UpdatePlayers:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.INNINGSNO :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.BOWLINGTEAMCODE :fetchSEPageLoadRecord.strickerPlayerCode :fetchSEPageLoadRecord.nonstrickerPlayerCode :bowlEvent.BowlerCode];
        
        //        [DBManager updateBOWLERCODE:self.competitionCode MATCHCODE:self.matchCode INNINGSNO:fetchSEPageLoadRecord.INNINGSNO BOWLERCODE:bowlEvent.BowlerCode];
        //
        [currentBowlersTableView removeFromSuperview];
        isBowlerOpen = NO;
        isNONStrickerOpen = NO;
        isStrickerOpen = NO;
        [self reloadBowlerTeamBatsmanDetails];
        
    }else if(tableView == nonstrickerTableView){
        SelectPlayerRecord *selectPlayer = [nonStrickerList objectAtIndex:indexPath.row];
        //InitializeInningsScoreBoardRecord *initializeInningsScoreBoardRecord = [[InitializeInningsScoreBoardRecord alloc]init];
        
        
        [InitializeInningsScoreBoardRecord UpdatePlayers:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.INNINGSNO :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.BOWLINGTEAMCODE : fetchSEPageLoadRecord.strickerPlayerCode:selectPlayer.playerCode   :fetchSEPageLoadRecord.currentBowlerPlayerCode];
        //        [DBManager updateNONSTRIKERCODE:self.competitionCode MATCHCODE:self.matchCode INNINGSNO:fetchSEPageLoadRecord.INNINGSNO NONSTRIKERCODE:selectPlayer.playerCode];
        isBowlerOpen = NO;
        isNONStrickerOpen = NO;
        isStrickerOpen = NO;
        [nonstrickerTableView removeFromSuperview];
        [self reloadBowlerTeamBatsmanDetails];
        
    }else if(tableView == strickerTableView){
        SelectPlayerRecord *selectPlayer = [strickerList objectAtIndex:indexPath.row];
        //InitializeInningsScoreBoardRecord *initializeInningsScoreBoardRecord = [[InitializeInningsScoreBoardRecord alloc]init];
        
        [InitializeInningsScoreBoardRecord UpdatePlayers:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.INNINGSNO :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.BOWLINGTEAMCODE :selectPlayer.playerCode :fetchSEPageLoadRecord.nonstrickerPlayerCode :fetchSEPageLoadRecord.currentBowlerPlayerCode];
        
        
        
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

-(BOOL) checkRunOut{
    if(isWicketSelected  && ![selectedwickettype.metasubcode isEqualToString:@"MSC097"]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Run not possible"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    
        return NO;
    
    }

    
    return YES;
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
            
            if(self.ballEventRecord.objIsbeaten.intValue == 1){
                
                self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                self.ballEventRecord.objRuns  = [NSNumber numberWithInt:0];
                self.ballEventRecord.objIssix  = [NSNumber numberWithInt:0];
                self.ballEventRecord.objIsFour = [NSNumber numberWithInt:0];
                self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];
                self.ballEventRecord.objNoball = [NSNumber numberWithInt:0];
                self.ballEventRecord.objRbw = [NSNumber numberWithInt:0];
                self.ballEventRecord.objWide = [NSNumber numberWithInt:0];
                
                
                
                [self unselectedButtonBg: self.btn_run1];
                [self unselectedButtonBg: self.btn_run2];
                [self unselectedButtonBg: self.btn_run3];
                [self unselectedButtonBg: self.btn_B4];
                [self unselectedButtonBg: self.btn_B6];
                [self unselectedViewBg:self.view_Rbw];
               // [self unselectedButtonBg: self.btn_extras];
               // btnMarkForEdit.Background = blueBrush;
                
                [extrasTableView reloadData];
                [self unselectedButtonBg: self.btn_overthrow];
                
//                isExtrasSelected = NO;
                isOverthrowSelected = NO;
                isRBWSelected = NO;

                
            }
            
            
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

// Sidemenuview action

-(void) BreakviewMethod
{
    breakvc = [[BreakVC alloc]initWithNibName:@"BreakVC" bundle:nil];
    
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    //fullview.alpha=0.9;
    
    breakvc.MATCHCODE=self.matchCode;
    breakvc.COMPETITIONCODE=self.competitionCode;
    breakvc.INNINGSNO=fetchSEPageLoadRecord.INNINGSNO;
    breakvc.MATCHDATE=fetchSEPageLoadRecord.MATCHDATE;
     breakvc.delegate =self;
    
    [self.view addSubview:fullview];
    //     BreakVC = [[intialBreakVC alloc]initWithNibName:@"intialBreakVC" bundle:nil];
    //
    [fullview addSubview:breakvc.view];
    
    [self addChildViewController:breakvc];
    breakvc.view.frame =CGRectMake(90, 200, breakvc.view.frame.size.width, breakvc.view.frame.size.height);
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [fullview addSubview:breakvc.view];
    breakvc.view.alpha = 0;
    [breakvc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         breakvc.view.alpha = 1;
     }
                     completion:nil];
    
    
    
    if (IS_IPAD_PRO) {
        
        breakvc.view.frame =CGRectMake(250, 500, breakvc.view.frame.size.width, breakvc.view.frame.size.height);
        [self.view addSubview:breakvc.view];
        breakvc.view.alpha = 0;
        [breakvc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             breakvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    else{
        
        
        breakvc.view.frame =CGRectMake(100, 200, breakvc.view.frame.size.width, breakvc.view.frame.size.height);
        //[self.view addSubview:add.view];
        breakvc.view.alpha = 0;
        [breakvc didMoveToParentViewController:self];
        //  Back_btn
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             breakvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
}

-(void)ChangeTeam
{
    int inningsNo=[fetchSEPageLoadRecord.INNINGSNO intValue ];
     int ballcount =fetchSEPageLoadRecord.BATTEAMOVRBALLS ;
    
    if(ballcount == 0 && fetchSEPageLoadRecord.BATTEAMRUNS==0 && fetchSEPageLoadRecord.BATTEAMWICKETS==0)
    {
        
    
    if(inningsNo > 1)
    {
        ChangeTeamVC *objChanceTeamVC =[[ChangeTeamVC alloc]initWithNibName:@"ChangeTeamVC" bundle:nil];
        objChanceTeamVC.compitionCode=self.competitionCode;
        objChanceTeamVC.MatchCode   =self.matchCode;
        objChanceTeamVC.delegate =self;
        
        
        fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
        fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
        UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
        
        [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
        //fullview.alpha=0.9;
        
        objChanceTeamVC.view.alpha = 0;
        [objChanceTeamVC didMoveToParentViewController:self];
        objChanceTeamVC.view.frame =CGRectMake(90, 200, objChanceTeamVC.view.frame.size.width, objChanceTeamVC.view.frame.size.height);
        [fullview addSubview:Btn_Fullview];
        [self.view addSubview:fullview];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             objChanceTeamVC.view.alpha = 1;
         }
                         completion:nil];
        [self addChildViewController:objChanceTeamVC];
        [fullview addSubview:objChanceTeamVC.view];
        
    }
    else if (inningsNo == 1){
       
        if(ballcount < 1)
        {
            ChangeTossVC*objChangeTossVC =[[ChangeTossVC alloc]initWithNibName:@"ChangeTossVC" bundle:nil];
            objChangeTossVC.CompitisonCode=self.competitionCode;
            objChangeTossVC.MatchCode   =self.matchCode;
            objChangeTossVC.delegate =self;
            
            
            fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
            fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
            UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
            
            [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
            //fullview.alpha=0.9;
            
            objChangeTossVC.view.alpha = 0;
            [objChangeTossVC didMoveToParentViewController:self];
            objChangeTossVC.view.frame =CGRectMake(90, 200, objChangeTossVC.view.frame.size.width, objChangeTossVC.view.frame.size.height);
            [fullview addSubview:Btn_Fullview];
            [self.view addSubview:fullview];
            
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
             {
                 objChangeTossVC.view.alpha = 1;
             }
                             completion:nil];
            [self addChildViewController:objChangeTossVC];
            [fullview addSubview:objChangeTossVC.view];
            
        }
    }
    }
    
}
-(void)ENDINNINGS
{
    
    
    EndInningsVC *endInning = [[EndInningsVC alloc]initWithNibName:@"EndInningsVC" bundle:nil];
    endInning.MATCHCODE=self.matchCode;
    endInning.delegate =self;
    // endInnings = [[EndInnings alloc]init];
    
    //[endInnings fetchEndInnings:self.competitionCode :self.matchCode :@"TEA0000024":@"1"];
    
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    //fullview.alpha=0.9;
    
    [self.view addSubview:fullview];
    [fullview addSubview:revisedTarget.view];
    
    
    //vc2 *viewController = [[vc2 alloc]init];
    [self addChildViewController:endInning];
    endInning.view.frame =CGRectMake(90, 200, endInning.view.frame.size.width, endInning.view.frame.size.height);
    
    
    [fullview addSubview:endInning.view];
    endInning.view.alpha = 0;
    [endInning didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         endInning.view.alpha = 1;
     }
                     completion:nil];
    
    
    
    [endInning fetchPageload:fetchSEPageLoadRecord :self.competitionCode :self.matchCode];
}
-(void)ENDDAY
{
    
    
    EndDayVC *endDayVC = [[EndDayVC alloc]initWithNibName:@"EndDayVC" bundle:nil];
    endDayVC.COMPETITIONCODE = self.competitionCode;
    endDayVC.MATCHCODE = self.matchCode;
    endDayVC.TEAMCODE = fetchSEPageLoadRecord.BATTINGTEAMCODE;
    endDayVC.INNINGSNO = fetchSEPageLoadRecord.INNINGSNO;
    
    
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    //fullview.alpha=0.9;
    
    [self.view addSubview:fullview];
    [fullview addSubview:revisedTarget.view];
    
    
    //vc2 *viewController = [[vc2 alloc]init];
    [self addChildViewController:endDayVC];
    endDayVC.view.frame =CGRectMake(90, 200, endDayVC.view.frame.size.width, endDayVC.view.frame.size.height);
    
    
    [fullview addSubview:endDayVC.view];
    endDayVC.view.alpha = 0;
    [endDayVC didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         endDayVC.view.alpha = 1;
     }
                     completion:nil];
    
}
-(void)ENDSession
{
   if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"])
   {
       fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
       fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
       UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
       [fullview addSubview:Btn_Fullview];
       [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
       //fullview.alpha=0.9;
       
       [self.view addSubview:fullview];
       EndSession *endSession = [[EndSession alloc]initWithNibName:@"EndSession" bundle:nil];
//       endSession.matchcode =self.matchCode;
//        endSession.compitionCode =self.competitionCode;
//        endSession.fetchpagedetail=fetchSEPageLoadRecord;
       endSession.delegate=self;
       
       
       if (IS_IPAD_PRO) {
           endSession.view.frame =CGRectMake(250, 500, endSession.view.frame.size.width, endSession.view.frame.size.height);
           //[fullview addSubview:endSession.view];
           endSession.view.alpha = 0;
           [endSession didMoveToParentViewController:self];
           
           [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
            {
                endSession.view.alpha = 1;
            }
                            completion:nil];
       }
       
       
       else{
           
           endSession.view.frame =CGRectMake(100, 200, endSession.view.frame.size.width, endSession.view.frame.size.height);
           //endSession.view.alpha = 0;
           //[endSession didMoveToParentViewController:self];
           
           [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
            {
              //  endSession.view.alpha = 1;
            }
                            completion:nil];
       }
       
       [self addChildViewController:endSession];
        [fullview addSubview:endSession.view];
       
       [endSession fetchPageEndSession:fetchSEPageLoadRecord :self.competitionCode:self.matchCode];
       
       
       
       
       
       
       
       
//       
//    EndSession *endSession = [[EndSession alloc]initWithNibName:@"EndSession" bundle:nil];
//       endSession.matchcode =self.matchCode;
//       endSession.compitionCode =self.competitionCode;
//       endSession.fetchpagedetail=fetchSEPageLoadRecord;
//       //endSession.bowlingCode    = fetchSEPageLoadRecord.BOWLINGTEAMCODE;
//    endSession.view.frame =CGRectMake(90, 200, endSession.view.frame.size.width, endSession.view.frame.size.height);
//       endSession.delegate=self;
//    
//    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
//    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
//    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
//    [fullview addSubview:Btn_Fullview];
//    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
//    //fullview.alpha=0.9;
//    
//    [self.view addSubview:fullview];
//    
//
//    //    [fullview addSubview:endSession.view];
//    endSession.view.alpha = 0;
//    //    [endSession didMoveToParentViewController:self];
//    
//    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//     {
//         endSession.view.alpha = 1;
//     }
//                     completion:nil];
//    
//    [endSession.btn_dropDown addTarget:self action:@selector(btn_dropDown:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//       [self addChildViewController:endSession];
//       
//       [fullview addSubview:endSession.view];

    
    
    }
    
    
    
}
-(void)FollowOn
{
    if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"])
    {
        int inningscount =[fetchSEPageLoadRecord.INNINGSNO intValue];
        if(inningscount > 1)
        {
            FollowOn *objFollowOn =[[FollowOn alloc]initWithNibName:@"FollowOn" bundle:nil];
            objFollowOn.compitionCode=self.competitionCode;
            objFollowOn.MatchCode   =self.matchCode;
            objFollowOn.battingTeamName =fetchSEPageLoadRecord.BATTEAMNAME;
            objFollowOn.battingTeamCode =fetchSEPageLoadRecord.BATTINGTEAMCODE;
            objFollowOn.BowlingTeamCode = fetchSEPageLoadRecord.BOWLINGTEAMCODE;
            objFollowOn.inningsno       = fetchSEPageLoadRecord.INNINGSNO;
            objFollowOn. inningsStatus      =fetchSEPageLoadRecord.INNINGSSTATUS;
            objFollowOn.objBowlingTeamdetail =fetchSEPageLoadRecord.getBowlingTeamPlayers;
            objFollowOn.delegate =self;
            
            
            fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
            fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
            UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
            
            [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
            //fullview.alpha=0.9;
            
            objFollowOn.view.alpha = 0;
            [objFollowOn didMoveToParentViewController:self];
            objFollowOn.view.frame =CGRectMake(90, 300, objFollowOn.view.frame.size.width, objFollowOn.view.frame.size.height);
            [fullview addSubview:Btn_Fullview];
            [self.view addSubview:fullview];
            
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
             {
                 objFollowOn.view.alpha = 1;
             }
                             completion:nil];
            [self addChildViewController:objFollowOn];
            [fullview addSubview:objFollowOn.view];
        }
    }
}
-(void) matchInfoEdit
{
    
    
    NSMutableArray *getPlayerRecord = [DBManager getPlayedPlayersForPlayerXI:self.matchCode COMPETITIOMCODE:self.competitionCode OVERNO:[NSString stringWithFormat:@"%d",fetchSEPageLoadRecord.BATTEAMOVERS] BALLNO:[NSString stringWithFormat:@"%d",fetchSEPageLoadRecord.BATTEAMOVRBALLS] ];
    
    NewMatchSetUpVC *detail = [[NewMatchSetUpVC alloc]init];
    
    detail =  (NewMatchSetUpVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"matchSetUpSBID"];
    FixturesRecord *objFixtureRecord=(FixturesRecord*)[self.matchSetUp objectAtIndex:0];
    
    NSString*teamAcode = fetchSEPageLoadRecord.TEAMACODE;
    NSString*teamBcode = fetchSEPageLoadRecord.TEAMBCODE;
    
    NSString*teamA =  fetchSEPageLoadRecord.BATTEAMNAME;
    NSString*teamB = fetchSEPageLoadRecord.BOWLTEAMNAME;
    NSString*matchType = objFixtureRecord.matchTypeName;
    NSString*matchCode = self.matchCode;
    NSString*competitionCode = self.competitionCode;
    NSString*matchTypeCode = objFixtureRecord.matchTypeCode;
    NSString*overs = objFixtureRecord.overs;
    NSString *MatchStatus = objFixtureRecord.MatchStatus;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *date = [formatter dateFromString:objFixtureRecord.matchdate];
    [formatter setDateFormat:@"dd"];
    NSString *newDate = [formatter stringFromDate:date];
    
    
    
    
    //NSDate *monthYY = [formatter dateFromString:objFixtureRecord.matchdate];
    [formatter setDateFormat:@"MMM ''yy"];
    NSString*newMonth = [formatter stringFromDate:date];
    
    
    
    // NSDate *time = [formatter dateFromString:objFixtureRecord.matchdate];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *newTime = [formatter stringFromDate:date];
    
    
    
    NSString*matchVenu = objFixtureRecord.city;
    
    
    
    detail.matchSetUp = self.matchSetUp;
    detail.teamA = teamA;
    detail.teamB = teamB;
    detail.date = newDate;
    detail.matchVenu = matchVenu;
    detail.matchType = matchType;
    detail.overs = overs;
    detail.month = newMonth;
    detail.time = newTime;
    detail.matchCode = matchCode;
    detail.competitionCode = competitionCode;
    detail.matchTypeCode = matchTypeCode;
    detail.teamAcode = teamAcode;
    detail.teamBcode = teamBcode;
    detail.isEdit = YES;
    detail.playingXIPlayers = getPlayerRecord;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)DeclearINNINGS
{
    
    
    DeclareInnings *declareInning = [[DeclareInnings alloc]initWithNibName:@"DeclareInnings" bundle:nil];
    declareInning.COMPETITIONCODE = self.competitionCode;
    declareInning.MATCHCODE = self.matchCode;
    declareInning.INNINGSNO = fetchSEPageLoadRecord.INNINGSNO;
    declareInning.TEAMCODE = fetchSEPageLoadRecord.BATTINGTEAMCODE;
    declareInning.BOWLINGTEAMCODE = fetchSEPageLoadRecord.BOWLINGTEAMCODE;

     declareInning.delegate =self;
    
    
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,250)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    //fullview.alpha=0.9;
    
    [self.view addSubview:fullview];
   // [fullview addSubview:revisedTarget.view];
    
    
    //vc2 *viewController = [[vc2 alloc]init];
    [self addChildViewController:declareInning];
    declareInning.view.frame =CGRectMake(90, 200, declareInning.view.frame.size.width, declareInning.view.frame.size.height);
    
    
    [fullview addSubview:declareInning.view];
    declareInning.view.alpha = 0;
    [declareInning didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         declareInning.view.alpha = 1;
     }
                     completion:nil];
    
    
    
    
    
    
}
-(void)MatchResult
{
    
    MatchResultListVC *matchResult = [[MatchResultListVC alloc]initWithNibName:@"MatchResultListVC" bundle:nil];
    matchResult.competitionCode = self.competitionCode;
    matchResult.matchCode = self.matchCode;
    
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    //fullview.alpha=0.9;
    
    [self.view addSubview:fullview];
   // [fullview addSubview:revisedTarget.view];
    
    
    //vc2 *viewController = [[vc2 alloc]init];
    [self addChildViewController:matchResult];
    matchResult.view.frame =CGRectMake(90, 200, matchResult.view.frame.size.width, matchResult.view.frame.size.height);
    [matchResult.btn_back addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [fullview addSubview:matchResult.view];
    matchResult.view.alpha = 0;
    [matchResult didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         matchResult.view.alpha = 1;
     }
                     completion:nil];
    
    
    
}
-(void)OtherWicket
{
    otherwikcetgricvc = [[Other_WicketgridVC alloc]initWithNibName:@"Other_WicketgridVC" bundle:nil];
    otherwikcetgricvc.COMPETITIONCODE=self.competitionCode;
    otherwikcetgricvc.MATCHCODE =self.matchCode;
    otherwikcetgricvc.INNINGSNO =fetchSEPageLoadRecord.INNINGSNO;
    otherwikcetgricvc.TEAMCODE=fetchSEPageLoadRecord.BATTINGTEAMCODE;
    otherwikcetgricvc.STRIKERCODE=fetchSEPageLoadRecord.strickerPlayerCode;
    otherwikcetgricvc.NONSTRIKERCODE=fetchSEPageLoadRecord.nonstrickerPlayerCode;
    otherwikcetgricvc.MAXOVER=[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVERS];
    otherwikcetgricvc.MAXBALL=[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVRBALLS];
    otherwikcetgricvc.BALLCOUNT=[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMOVRBALLSCNT];
    otherwikcetgricvc.N_WICKETNO=[NSString stringWithFormat:@"%d", fetchSEPageLoadRecord.BATTEAMWICKETS];
    otherwikcetgricvc.BALLCODE=fetchSEPageLoadRecord.BOWLTYPECODE;
    
    
    //  otherwicketvc.PLAYERNAME=
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fullview];
    [fullview addSubview:otherwikcetgricvc.view];
    
    otherwikcetgricvc.view.frame =CGRectMake(90, 200, otherwikcetgricvc.view.frame.size.width, otherwikcetgricvc.view.frame.size.height);
    
    otherwikcetgricvc.view.alpha = 0;
    [otherwikcetgricvc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         otherwikcetgricvc.view.alpha = 1;
     }
                     completion:nil];
    
    
    
    if (IS_IPAD_PRO) {
        
        otherwikcetgricvc.view.frame =CGRectMake(250, 500, otherwikcetgricvc.view.frame.size.width, otherwikcetgricvc.view.frame.size.height);
        otherwikcetgricvc.view.alpha = 0;
        [otherwikcetgricvc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             otherwikcetgricvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    else{
        otherwikcetgricvc.view.frame =CGRectMake(100, 200, otherwikcetgricvc.view.frame.size.width, otherwikcetgricvc.view.frame.size.height);
        otherwikcetgricvc.view.alpha = 0;
        [otherwikcetgricvc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             otherwikcetgricvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
}
-(void)Penalty
{
    penaltygridvc = [[PenaltygridVC alloc]initWithNibName:@"PenaltygridVC" bundle:nil];
   
    penaltygridvc.competitionCode=self.competitionCode;
    penaltygridvc.matchCode =self.matchCode;
    penaltygridvc.inningsNo =fetchSEPageLoadRecord.INNINGSNO;
    penaltygridvc.teamcode=fetchSEPageLoadRecord.BATTINGTEAMCODE;
    penaltygridvc.bowlingTeamCode = fetchSEPageLoadRecord.BOWLINGTEAMCODE;
    
    penaltygridvc.delegate=self;
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fullview];
    [fullview addSubview:penaltygridvc.view];
    
    penaltygridvc.view.frame =CGRectMake(90, 200, penaltygridvc.view.frame.size.width, penaltygridvc.view.frame.size.height);
    
    penaltygridvc.view.alpha = 0;
    [penaltygridvc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         penaltygridvc.view.alpha = 1;
     }
                     completion:nil];
    
    
    
    if (IS_IPAD_PRO) {
        
        penaltygridvc.view.frame =CGRectMake(250, 500, penaltygridvc.view.frame.size.width, penaltygridvc.view.frame.size.height);
        penaltygridvc.view.alpha = 0;
        [penaltygridvc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             penaltygridvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    else{
        penaltygridvc.view.frame =CGRectMake(100, 200, penaltygridvc.view.frame.size.width, penaltygridvc.view.frame.size.height);
        penaltygridvc.view.alpha = 0;
        [penaltygridvc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             penaltygridvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    
}
-(void)PowerPlay
{
    powerplaygridvc = [[PowerPlayGridVC alloc]initWithNibName:@"PowerPlayGridVC" bundle:nil];
    powerplaygridvc.competitionCode=self.competitionCode;
    powerplaygridvc.matchCode =self.matchCode;
    powerplaygridvc.inningsNo =fetchSEPageLoadRecord.INNINGSNO;
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fullview];
    [fullview addSubview:powerplaygridvc.view];
    
    powerplaygridvc.view.frame =CGRectMake(90, 200, powerplaygridvc.view.frame.size.width, powerplaygridvc.view.frame.size.height);
    
    powerplaygridvc.view.alpha = 0;
    [powerplaygridvc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         powerplaygridvc.view.alpha = 1;
     }
                     completion:nil];
    
    
    
    if (IS_IPAD_PRO) {
        
        powerplaygridvc.view.frame =CGRectMake(250, 500, powerplaygridvc.view.frame.size.width, powerplaygridvc.view.frame.size.height);
        powerplaygridvc.view.alpha = 0;
        [powerplaygridvc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             powerplaygridvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    else{
        powerplaygridvc.view.frame =CGRectMake(100, 200, powerplaygridvc.view.frame.size.width, powerplaygridvc.view.frame.size.height);
        powerplaygridvc.view.alpha = 0;
        [powerplaygridvc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             powerplaygridvc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    
}

-(void) revisiedTarget
{
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    //fullview.alpha=0.9;
    
    [self.view addSubview:fullview];
    revisedTarget = [[RevisedTarget alloc]initWithNibName:@"RevisedTarget" bundle:nil];
    revisedTarget.competitionCode=self.competitionCode;
    revisedTarget.matchCode =self.matchCode;
    [fullview addSubview:revisedTarget.view];
    
    
    if (IS_IPAD_PRO) {
        revisedTarget.view.frame =CGRectMake(250, 500, revisedTarget.view.frame.size.width, revisedTarget.view.frame.size.height);
        [self.view addSubview:revisedTarget.view];
        revisedTarget.view.alpha = 0;
        [revisedTarget didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             revisedTarget.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    else{
        
        revisedTarget.view.frame =CGRectMake(100, 200, revisedTarget.view.frame.size.width, revisedTarget.view.frame.size.height);
        revisedTarget.view.alpha = 0;
        [revisedTarget didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             revisedTarget.view.alpha = 1;
         }
                         completion:nil];
    }
    
}
-(IBAction)FullviewHideMethod:(id)sender
{
    [fullview removeFromSuperview];
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
            self.ballEventRecord.objRuns =  [NSNumber numberWithInt:0];
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
    
    int totalRns =  self.ballEventRecord.objRuns.intValue+(( self.ballEventRecord.objByes.intValue == 0 &&  self.ballEventRecord.objLegByes.intValue == 0 &&  self.ballEventRecord.objWide.intValue == 0) ? self.ballEventRecord.objOverthrow.intValue: 0);
    
    self.ballEventRecord.objTotalruns =[NSNumber numberWithInt:totalRns]
    ;
    //Total runs scored for the particular ball including byes or legbyes.
    
    int totalExtras = (self.ballEventRecord.objNoball.intValue +self.ballEventRecord.objWide.intValue+self.ballEventRecord.objByes.intValue+self.ballEventRecord.objLegByes.intValue+self.ballEventRecord.objPenalty.intValue);
    self.ballEventRecord.objTotalextras = [NSNumber numberWithInt: totalExtras];
    
    self.ballEventRecord.objGrandtotal =[NSNumber numberWithInt: totalRns+totalExtras];
    NSNumber * overballCount =(self.ballEventRecord.objBallno == nil)?[NSNumber numberWithInt:0]:[NSNumber numberWithInt:self.ballEventRecord.objNoball];
    //
    /*+ ((Byes > 0 || Legbyes > 0) ? Overthrow : 0)*/;
}




- (IBAction)btn_AppealSave:(id)sender {
    
    // UIColor colorWithRed:84 green:106 blue:126 alpha:0
    NSString *commentText =[NSString stringWithFormat:@"%@",[_comments_txt text]];
    if(appealEventDict==nil){
        appealEventDict = [NSMutableDictionary dictionary];
    }
    
    [appealEventDict setValue:AppealSystemSelectCode forKey:@"AppealSystemSelct"];
    [appealEventDict setValue:AppealComponentSelectCode forKey:@"AppealComponentSelct"];
    [appealEventDict setValue:UmpireSelect forKey:@"AppealUmpireSelct"];
    [appealEventDict setValue:StrikerPlayer forKey:@"AppealBatsmenSelct"];
    NSString*AppealBowlercode=fetchSEPageLoadRecord.currentBowlerPlayerCode;
    [appealEventDict setValue:AppealBowlercode forKey:@"AppealBowlerSelect"];
    [appealEventDict setValue:commentText forKey:@"Commenttext"];
    
    
    [self.view_table_select setHidden:YES];
}


-(void)teamLogo{
    //logo image
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
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,fetchSEPageLoadRecord.TEAMACODE];
    
    
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
    NSString *pngFilePathB = [NSString stringWithFormat:@"%@/%@.png", docDirB,fetchSEPageLoadRecord.TEAMBCODE];
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
-(void) addImageInAppDocumentLocation:(NSString*) fileName{
    
    BOOL success = [self checkFileExist:fileName];
    
    if(!success) {//If file not exist
        
        UIImage  *newImage = [UIImage imageNamed:fileName];
        NSData *imageData = UIImagePNGRepresentation(newImage);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
        
        if (![imageData writeToFile:imagePath atomically:NO])
        {
            NSLog((@"Failed to cache image data to disk"));
        }else
        {
            NSLog(@"the cachedImagedPath is %@",imagePath);
        }
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
-(void)hideLabelBasedOnMatchType{
    
    //self.matchTypeCode = @"MSC115";
    
    if ([fetchSEPageLoadRecord.MATCHTYPE isEqualToString:@"MSC115"] || [fetchSEPageLoadRecord.MATCHTYPE isEqualToString:@"MSC116"] ||
        [fetchSEPageLoadRecord.MATCHTYPE isEqualToString:@"MSC022"] || [fetchSEPageLoadRecord.MATCHTYPE isEqualToString:@"MSC024"]) {
        
        
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
                
                bool chk = ([[record playerCode] isEqualToString:fetchSEPageLoadRecord.strickerPlayerCode]);
                if (chk)
                {
                    selectePosition = indx;
                    //   break;
                }
                indx ++;
            }
            
           
        }
        
        [strickerTableView reloadData];
        
        if(selectePosition!=-1){
            
        
            //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
            [strickerTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [strickerTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
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
                
                bool chk = ([[record playerCode] isEqualToString:fetchSEPageLoadRecord.nonstrickerPlayerCode]);
                if (chk)
                {
                    selectePosition = indx;
                    //    break;
                }
                indx ++;
            }
            
        
        }
        [nonstrickerTableView reloadData];
        //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
        if(selectePosition!=-1){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
            [nonstrickerTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [nonstrickerTableView scrollToRowAtIndexPath:indexPath
                                        atScrollPosition:UITableViewScrollPositionTop
                                                animated:YES];
        }
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
        if(selectePosition!=-1){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
            [currentBowlersTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [currentBowlersTableView scrollToRowAtIndexPath:indexPath
                                           atScrollPosition:UITableViewScrollPositionTop
                                                   animated:YES];
        }
    }else{
        isStrickerOpen = NO;
        isNONStrickerOpen = NO;
        isBowlerOpen = NO;
    }
}
- (IBAction)btn_last_bowler_name:(id)sender {
}

-(IBAction)didclickcloseSideMenu:(id)sender
{
    self.sideviewXposition.constant =-300;
    self.commonViewXposition.constant=0;
    self.commonViewwidthposition.constant =self.view.frame.size.width;
}
-(void) reloadBowlerTeamBatsmanDetails{
    //[self EndBallMethod];
    fetchSEPageLoadRecord = [[FetchSEPageLoadRecord alloc]init];
    [fetchSEPageLoadRecord fetchSEPageLoadDetails:self.competitionCode :self.matchCode];
    
    
    //Striker Details
    self.lbl_stricker_name.text = fetchSEPageLoadRecord.strickerPlayerName;
    self.lbl_stricker_runs.text = fetchSEPageLoadRecord.strickerTotalRuns;
    self.lbl_stricker_balls.text = fetchSEPageLoadRecord.strickerTotalBalls;
    self.lbl_stricker_sixs.text = fetchSEPageLoadRecord.strickerSixes;
    self.lbl_stricker_strickrate.text = fetchSEPageLoadRecord.strickerStrickRate;
    self.lbl_stricker_fours.text = fetchSEPageLoadRecord.strickerFours;
    self.BatmenStyle = fetchSEPageLoadRecord.strickerBattingStyle;
    
    //Non Striker Details
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
    
    _lbl_overs.text = [NSString stringWithFormat:@"%d.%d OVS" ,fetchSEPageLoadRecord.BATTEAMOVERS,fetchSEPageLoadRecord.BATTEAMOVRBALLS];
    
    if(fetchSEPageLoadRecord.INNINGSNO.intValue>1){
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue] < 0 ? @"0.0".floatValue: [fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue], [fetchSEPageLoadRecord.REQRUNRATE floatValue] < 0 ? @"0.0".floatValue: [fetchSEPageLoadRecord.REQRUNRATE floatValue]];
    }else{
        _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f",[fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue]];
    }
    
    
    
    //all innings details for team A and team B
    //    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.SECONDINNINGSTOTAL,fetchSEPageLoadRecord.SECONDINNINGSWICKET];
    //    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.SECONDINNINGSOVERS];
    //
    //
    //    // _lbl_teamASecIngsScore.text =
    //    //_lbl_teamASecIngsOvs.text =
    //
    //
    //    //  _lbl_teamBSecIngsScore.text =
    //    //    _lbl_teamBSecIngsOvs.text =
    //
    //    _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",fetchSEPageLoadRecord.FIRSTINNINGSTOTAL,fetchSEPageLoadRecord.FIRSTINNINGSWICKET];
    //    _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FIRSTINNINGSOVERS];
    //
    
    
    //all innings details for team A and team B
    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", fetchSEPageLoadRecord.SECONDINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSTOTAL,fetchSEPageLoadRecord.SECONDINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSWICKET];
    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.SECONDINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSOVERS];
    
    
    _lbl_teamASecIngsScore.text = @"";
    _lbl_teamASecIngsOvs.text = @"";
    
    
    _lbl_teamBSecIngsScore.text =@"";
    _lbl_teamBSecIngsOvs.text =@"";
    
    _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",fetchSEPageLoadRecord.FIRSTINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSTOTAL,fetchSEPageLoadRecord.FIRSTINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSWICKET];
    _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",fetchSEPageLoadRecord.FIRSTINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSOVERS];
    
    
    if(!self.isEditMode)
    {
        if((int)fetchSEPageLoadRecord.ISOVERCOMPLETE ==0)
        {
            [self.btn_StartOver setTitle:@"END OVER" forState:UIControlStateNormal];
            self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
            
            self.btn_StartBall.userInteractionEnabled=YES;
            
            
        }
        else{
            
            [self.btn_StartOver setTitle:@"START OVER" forState:UIControlStateNormal];
            
            self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(16/255.0f) green:(21/255.0f) blue:(24/255.0f) alpha:1.0f];
            self.btn_StartOver.userInteractionEnabled=YES;
            
        }
    }
    
    
    if([fetchSEPageLoadRecord INNINGSNO].intValue>1){
    
    if([MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE]){//Multi day
        
        isTargetReached = (fetchSEPageLoadRecord.RUNSREQUIRED.intValue<=0 && [fetchSEPageLoadRecord.INNINGSNO intValue]==4)?YES:NO;
        
        NSString *targetLeftValue = @"";
        NSString *targetRightValue = @"";
        
        if([fetchSEPageLoadRecord.INNINGSNO intValue] == 4){
            targetLeftValue = @"Target:";
        }else{
            targetLeftValue = fetchSEPageLoadRecord.RUNSREQUIRED.intValue > 0 ? @"Trail By":(fetchSEPageLoadRecord.RUNSREQUIRED.intValue <0 ? @"Lead by:":@"Score level");
        }
        
        targetRightValue =  fetchSEPageLoadRecord.INNINGSNO.intValue == 4 ? fetchSEPageLoadRecord.TARGETRUNS : (fetchSEPageLoadRecord.RUNSREQUIRED.intValue == 0 ? @"" : fetchSEPageLoadRecord.RUNSREQUIRED);
        
 
        _lbl_target.text = [NSString stringWithFormat:@"%@ %@",targetLeftValue,targetRightValue];

        NSString *runsReqForBalls = fetchSEPageLoadRecord.INNINGSNO.intValue == 4 ? (isTargetReached ? @"Target achieved" : ([NSString stringWithFormat:@"%@ runs to win",fetchSEPageLoadRecord.RUNSREQUIRED])) : @"Required run rate:";
        _lbl_runs_required.text = runsReqForBalls;
    }else{// ODI / T20
        
        isTargetReached = (fetchSEPageLoadRecord.RUNSREQUIRED.intValue <=0 && [fetchSEPageLoadRecord.INNINGSNO intValue]>1)?YES:NO;
        
        NSString *targetLeftValue = @"";
        NSString *targetRightValue = @"";
        targetLeftValue = @"Target:";
        targetRightValue =   fetchSEPageLoadRecord.TARGETRUNS;
        
        
        _lbl_target.text = [NSString stringWithFormat:@"%@ %@",targetLeftValue,targetRightValue];
        
        
        NSString *runsReqForBalls =  [NSString  stringWithFormat:@"Runs required %@ in %@ balls",fetchSEPageLoadRecord.RUNSREQUIRED.intValue<0?@"0":fetchSEPageLoadRecord.RUNSREQUIRED,fetchSEPageLoadRecord.REMBALLS.intValue<0?@"0":fetchSEPageLoadRecord.REMBALLS];
        
        _lbl_runs_required.text = runsReqForBalls;
    }
    }
    
    
        if(self.img_firstIngsTeamName.image !=@"") //battingteamlogo
        {
            [self teamLogo];
        }
        else
        {
            
        }
        if(self.img_secIngsTeamName.image !=@"") //bowlingteamlogo
        {
            [self teamLogo];
        }
        else{
            
        }
        if([self.ballEventRecord.objAtworotw isEqualToString:@"MSC149"])
        {
            //change green color AtW
            self.view_rtw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        }
        else if ([self.ballEventRecord.objAtworotw isEqualToString:@"MSC148"])
        {
            //change green color rotw
            // [self.btn_OTW setBackgroundColor: [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
        }
        if([self.ballEventRecord.objBowlingEnd isEqualToString:@"MSC150"])
        {
            //change green color rbnearend
            //[self.btn_rb setBackgroundColor:[UIColor greenColor]];
        }
        else if ([self.ballEventRecord.objBowlingEnd isEqualToString:@"MSC151"])
        {
            //change green color rbFearend
        }
        isFreeHitBall = ((fetchSEPageLoadRecord.ISFREEHIT == @1) && ![MuliteDayMatchtype containsObject:fetchSEPageLoadRecord.MATCHTYPE ])? YES:NO;
   
}
- (IBAction)btn_swap:(id)sender {
    //InitializeInningsScoreBoardRecord *initializeInningsScoreBoardRecord = [[InitializeInningsScoreBoardRecord alloc]init];
    
    
    [InitializeInningsScoreBoardRecord UpdatePlayers:self.competitionCode :self.matchCode :fetchSEPageLoadRecord.INNINGSNO :fetchSEPageLoadRecord.BATTINGTEAMCODE :fetchSEPageLoadRecord.BOWLINGTEAMCODE :fetchSEPageLoadRecord.nonstrickerPlayerCode :fetchSEPageLoadRecord.strickerPlayerCode  :fetchSEPageLoadRecord.currentBowlerPlayerCode];
    
    isBowlerOpen = NO;
    isNONStrickerOpen = NO;
    isStrickerOpen = NO;
    
    [nonstrickerTableView removeFromSuperview];
    [strickerTableView removeFromSuperview];
    [currentBowlersTableView removeFromSuperview];
    
    
    [self reloadBowlerTeamBatsmanDetails];
}



-(void)didClickWagonWheelmapTapAction:(UIGestureRecognizer *)wagon_Wheelgesture {
    
    for (CALayer *layer in self.img_WagonWheel.layer.sublayers) {
        if ([layer.name isEqualToString:@"DrawLine"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    
    CGPoint p = [wagon_Wheelgesture locationInView:self.img_WagonWheel];
    int Xposition = p.x;
    int Yposition = p.y;
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
    shapeLayer.name = @"DrawLine";
    [self.img_WagonWheel.layer addSublayer:shapeLayer];
    //
    //    CGPoint p = [wagon_Wheelgesture locationInView:self.img_WagonWheel];
    //    float Xposition = p.x;
    //    float Yposition = p.y;
    //    CGMutablePathRef straightLinePath = CGPathCreateMutable();
    //    CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
    //    CGPathAddLineToPoint(straightLinePath, NULL,self.centerlbl.center.x,self.centerlbl.center.y);
    
    
    
    
    
    
    
    
    
    
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
    
    if (IS_IPAD_PRO) {
        _ballEventRecord.objWWX1=@(221);
        _ballEventRecord.objWWY1=@(186);
        _ballEventRecord.objWWX2=@(Xposition);
        _ballEventRecord.objWWY2=@(Yposition);
        _ballEventRecord.objWWREGION=regioncode;
    }
    else{
        
        _ballEventRecord.objWWX1=@(172);
        _ballEventRecord.objWWY1=@(145);
        _ballEventRecord.objWWX2=@(Xposition);
        _ballEventRecord.objWWY2=@(Yposition);
        _ballEventRecord.objWWREGION=regioncode;
        
    }
    
    
    
    
    //    if (IS_IPAD_PRO)
    //    {
    //
    //        if (( Xposition < 220 && Xposition > 172 && Yposition > 20 && Yposition <57))
    //        {
    //            wagonregiontext = @"Third Man - Fine";
    //            regioncode = @"MSC215";
    //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //        }
    //        //
    //        //        else if(( Xposition >222 && Yposition <0)) {
    //        //            wagonregiontext = @"Long Stop";
    //        //            regioncode = @"MSC154";
    //        //
    //        //            NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //        //
    //        //        }
    //    }
    //    else if((Xposition < 170 && Xposition > 135 && Yposition > 20 && Yposition <41))
    //
    //    {
    //        wagonregiontext = @"Third Man - Fine";
    //        regioncode = @"MSC215";
    //        NSLog(@"pointx=%@,pointY=%@",wagonregiontext,regioncode);
    //    }
    //
    //
    
    
}

////Revised overs
//
-(void) revisedoverview{
    fullview=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    fullview.backgroundColor =[UIColor colorWithRed:(4.0/255.0f) green:(6.0/255.0f) blue:(6.0/255.0f) alpha:0.8];
    UIButton * Btn_Fullview=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height)];
    [fullview addSubview:Btn_Fullview];
    [Btn_Fullview addTarget:self action:@selector(FullviewHideMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:fullview];
    revicedOverVc = [[RevicedOverVC alloc]initWithNibName:@"RevicedOverVC" bundle:nil];
    revicedOverVc.matchCode=self.matchCode;
    revicedOverVc.competitionCode =self.competitionCode;
    // revicedOverVc.inningsNo = self.;
    [fullview addSubview:revicedOverVc.view];
    
    //[revicedOverVc.btn_submit addTarget:self action:@selector(btn_submit:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (IS_IPAD_PRO) {
        
        
        
        
        //vc2 *viewController = [[vc2 alloc]init];
        
        
        revicedOverVc.view.frame =CGRectMake(250, 500, revicedOverVc.view.frame.size.width, revicedOverVc.view.frame.size.height);
        //[self.view addSubview:BreakVC.view];
        revicedOverVc.view.alpha = 0;
        
        [revicedOverVc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             revicedOverVc.view.alpha = 1;
         }
                         completion:nil];
    }
    
    
    else{
        //intialBreakVC *add = [[intialBreakVC alloc]initWithNibName:@"intialBreakVC" bundle:nil];
        
        
        
        //vc2 *viewController = [[vc2 alloc]init];
        // [self addChildViewController:add];
        
        revicedOverVc.view.frame =CGRectMake(100, 200, revicedOverVc.view.frame.size.width, revicedOverVc.view.frame.size.height);
        //[self.view addSubview:add.view];
        revicedOverVc.view.alpha = 0;
        [revicedOverVc didMoveToParentViewController:self];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             revicedOverVc.view.alpha = 1;
         }
                         completion:nil];
    }
}
//
- (IBAction)btn_submit:(id)sender
{
    if(self.checkInternetConnection){
        NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.49:8079/CAPMobilityService.svc/REVISEOVER/%@/%@/TEA0000013/1/%@/%@",self.competitionCode,self.matchCode,strovers,strcomments];
        
        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSMutableArray *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        
        
    }else{
        
        [DBManager updateRevisedOvers:strovers comments:strcomments matchCode:self.matchCode competitionCode:self.competitionCode];
    }
}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
//
//    if(textField.tag == 21)
//    {
//
//        if (![string isEqualToString:@""]) {
//            strovers=[textField.text stringByAppendingString:string];
//            return YES;
//
//        }
//    }
//    else if (textField.tag == 22)
//    {
//        if (![string isEqualToString:@""]) {
//            strcomments=[textField.text stringByAppendingString:string];
//            return YES;
//
//        }
//
//    }
//    return YES;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"textFieldShouldReturn:");
//    if (textField.tag == 21) {
//        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
//        [passwordTextField becomeFirstResponder];
//    }
//    else if(textField.tag== 22){
//        [textField resignFirstResponder];
//    }
//    return YES;
//}
//
//
//
//- (IBAction)btn_reviseover:(id)sender {
//    [self revisedoverview];
//}

////Revised Target
//-(void) revisedtargetview{
//
//    RevisedTarget *revisedtargetVc = [[RevisedTarget alloc]initWithNibName:@"RevisedTarget" bundle:nil];
//
//    revisedtargetVc.matchCode =self.matchCode;
//    revisedtargetVc.competitionCode =self.competitionCode;
//
//    [self.view addSubview:revisedtargetVc.view];
//    revisedtargetVc.txt_overs.delegate=self;
//    revisedtargetVc.txt_target.delegate=self;
//    revisedtargetVc.txt_comments.delegate=self;
//
//    [revisedtargetVc.btn_targetok addTarget:self action:@selector(btn_targetok:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//
//- (IBAction)btn_revisetarget:(id)sender {
//    [self revisedtargetview ];
//}
//
////Check internet connection
//- (BOOL)checkInternetConnection
//{
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
//    return networkStatus != NotReachable;
//}
//
//- (IBAction)btn_targetok:(id)sender {
//
//    if(self.checkInternetConnection){
//        NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.49:8079/CAPMobilityService.svc/SETREVISETARGET/%@/%@/'TEA0000024'/%@/%@/%@/'2'",self.competitionCode,self.matchCode,strtargetruns,strtargetovers,strtargetcomments];
//
//        NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSURLResponse *response;
//        NSError *error;
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//
//
//        NSMutableArray *rootDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//
//
//    }else{
//
//         [DBManager updateRevisedTarget:strtargetovers runs:strtargetruns comments:strtargetcomments matchCode:self.matchCode competitionCode:self.competitionCode];
//
//    }
//
//
//
//
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
//
//    if(textField.tag == 23)
//    {
//
//        if (![string isEqualToString:@""]) {
//            strtargetovers=[textField.text stringByAppendingString:string];
//            return YES;
//
//        }
//    }
//    else if (textField.tag == 24)
//    {
//        if (![string isEqualToString:@""]) {
//            strtargetruns=[textField.text stringByAppendingString:string];
//            return YES;
//        }
//        } else if (textField.tag == 25)
//        {
//            if (![string isEqualToString:@""]) {
//                strtargetcomments=[textField.text stringByAppendingString:string];
//                return YES;
//
//            }
//
//    }
//return YES;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"textFieldShouldReturn:");
//    if (textField.tag == 23) {
//        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:3];
//        [passwordTextField becomeFirstResponder];
//    }
//    else if(textField.tag== 24){
//        [textField resignFirstResponder];
//    }
//    else if(textField.tag== 25){
//        [textField resignFirstResponder];
//    }
//    return YES;
//}



- (IBAction)btn_show_scorecard:(id)sender {
    //ScoreCard
    ScoreCardVC *scoreCardVC = [[ScoreCardVC alloc]init];
    
    scoreCardVC =  (ScoreCardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"scorecard_sbid"];
    if(fetchSEPageLoadRecord!=nil){
        
        scoreCardVC.BATTEAMWICKETS= fetchSEPageLoadRecord.BATTEAMWICKETS;
        scoreCardVC.BATTEAMOVERS= fetchSEPageLoadRecord.BATTEAMOVERS;
        scoreCardVC.BATTEAMOVRBALLS= fetchSEPageLoadRecord.BATTEAMOVRBALLS;
        //scoreCardVC.BATTEAMRUNRATE= fetchSEPageLoadRecord.BATTEAMRUNRATE;
        
     // NSString *Runrate = [NSString stringWithFormat:@"RR %.02f",fetchSEPageLoadRecord.BATTEAMRUNRATE];
     
        
        //scoreCardVC.RunRate = [fetchSEPageLoadRecord.BATTEAMRUNRATE floatValue];
        
        scoreCardVC.BATTEAMRUNS= fetchSEPageLoadRecord.BATTEAMRUNS;
        
        //    scoreCardVC.RUNSREQUIRED= fetchSEPageLoadRecord.RUNSREQUIRED;
       // scoreCardVC.RUNSREQUIRED= @"0.0";
        
        
        scoreCardVC.competitionCode= self.competitionCode;
        scoreCardVC.matchCode = self.matchCode;
        
        scoreCardVC.matchTypeCode = fetchSEPageLoadRecord.MATCHTYPE;
        
        
        scoreCardVC.inningsNo = fetchSEPageLoadRecord.INNINGSNO;
        scoreCardVC.BATTEAMSHORTNAME = fetchSEPageLoadRecord.BATTEAMSHORTNAME;
        scoreCardVC.BOWLTEAMSHORTNAME = fetchSEPageLoadRecord.BOWLTEAMSHORTNAME;
        
        
        scoreCardVC.FIRSTINNINGSTOTAL = fetchSEPageLoadRecord.FIRSTINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSTOTAL;
        scoreCardVC.SECONDINNINGSTOTAL = fetchSEPageLoadRecord.SECONDINNINGSTOTAL==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSTOTAL;
        scoreCardVC.THIRDINNINGSTOTAL = fetchSEPageLoadRecord.THIRDINNINGSTOTAL;
        scoreCardVC.FOURTHINNINGSTOTAL = fetchSEPageLoadRecord.FOURTHINNINGSTOTAL;
        
        scoreCardVC.FIRSTINNINGSWICKET = fetchSEPageLoadRecord.FIRSTINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSWICKET;
        scoreCardVC.SECONDINNINGSWICKET = fetchSEPageLoadRecord.SECONDINNINGSWICKET==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSWICKET;
        scoreCardVC.THIRDINNINGSWICKET = fetchSEPageLoadRecord.THIRDINNINGSWICKET;
        scoreCardVC.FOURTHINNINGSWICKET = fetchSEPageLoadRecord.FOURTHINNINGSWICKET;
        
        scoreCardVC.FIRSTINNINGSSCORE = fetchSEPageLoadRecord.FIRSTINNINGSSCORE;
        scoreCardVC.SECONDINNINGSSCORE = fetchSEPageLoadRecord.SECONDINNINGSSCORE;
        scoreCardVC.THIRDINNINGSSCORE = fetchSEPageLoadRecord.THIRDINNINGSSCORE;
        scoreCardVC.FOURTHINNINGSSCORE = fetchSEPageLoadRecord.FOURTHINNINGSSCORE;
        
        scoreCardVC.FIRSTINNINGSOVERS =  fetchSEPageLoadRecord.FIRSTINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.FIRSTINNINGSOVERS;
        scoreCardVC.SECONDINNINGSOVERS = fetchSEPageLoadRecord.SECONDINNINGSOVERS==nil?@"0":fetchSEPageLoadRecord.SECONDINNINGSOVERS;
        scoreCardVC.THIRDINNINGSOVERS = fetchSEPageLoadRecord.THIRDINNINGSOVERS;
        scoreCardVC.FOURTHINNINGSOVERS = fetchSEPageLoadRecord.FOURTHINNINGSOVERS;
        
        scoreCardVC.FIRSTINNINGSSHORTNAME = fetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME;
        scoreCardVC.SECONDINNINGSSHORTNAME = fetchSEPageLoadRecord.SECONDINNINGSSHORTNAME;
        
        scoreCardVC.THIRDINNINGSSHORTNAME = fetchSEPageLoadRecord.THIRDINNINGSSHORTNAME;
        scoreCardVC.FOURTHINNINGSSHORTNAME = fetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME;
        
        
        
    }
    
    
    
    
    
    [self.navigationController pushViewController:scoreCardVC animated:YES];
    
    
    
}

-(void) penalityview{
    
    penalityVc = [[PenalityVC alloc]initWithNibName:@"PenalityVC" bundle:nil];
    
    penalityVc.matchCode=self.matchCode;
    penalityVc.competitionCode=self.competitionCode;
    penalityVc.teamcode = fetchSEPageLoadRecord.BATTINGTEAMCODE;
    penalityVc.bowlingTeamCode = fetchSEPageLoadRecord.BOWLINGTEAMCODE;
    [self.view addSubview:penalityVc.view];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    
    if(textField.tag == 26)
    {
        
        if (![string isEqualToString:@""]) {
            strpenalityruns=[textField.text stringByAppendingString:string];
            return YES;
            
        }
    }
    else
    {
        return YES;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 23) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:3];
        [passwordTextField becomeFirstResponder];
    }
    else {
        
        return YES;
    }
    return YES;
}


- (IBAction)btn_penality:(id)sender {
    [self penalityview];
    
}
-(void)processSuccessful
{
    fullview.hidden=YES;
    ArchivesVC * objArchiveVC=[[ArchivesVC alloc]init];
    objArchiveVC=(ArchivesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
    
    objArchiveVC.CompitionCode=self.competitionCode;
    [self.navigationController pushViewController:objArchiveVC animated:YES];
}
-(void)RedirectScorEngin
{
    fullview.hidden=YES;
    ArchivesVC * objArchiveVC=[[ArchivesVC alloc]init];
    objArchiveVC=(ArchivesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
    
    objArchiveVC.CompitionCode=self.competitionCode;
    [self.navigationController pushViewController:objArchiveVC animated:YES];
    [self reloadBowlerTeamBatsmanDetails];
}
-(void) RedirectFollowOnPage
{
    fullview.hidden=YES;
   [self reloadBowlerTeamBatsmanDetails];
}
- (IBAction)SyncData_btn:(id)sender {
    
    NSMutableArray*MatcRegistraionGetArray=[PushSyncDBMANAGER RetrieveMATCHREGISTRATIONData:_competitionCode :_matchCode];
    
    NSMutableArray*MatchTeamplayerDetailsGetArray=[PushSyncDBMANAGER RetrieveMATCHTEAMPLAYERDETAILSData:_matchCode];
    NSMutableArray*MatchresultGetArray=[PushSyncDBMANAGER RetrieveMATCHRESULTData:_competitionCode :_matchCode];
    NSMutableArray*MatchEventGetArray=[PushSyncDBMANAGER RetrieveMATCHEVENTSData:_competitionCode :_matchCode];
    NSMutableArray*InningsSummeryGetArray= [PushSyncDBMANAGER RetrieveINNINGSSUMMARYData:_competitionCode :_matchCode];
    
    NSMutableArray*InningsEventGetArray= [PushSyncDBMANAGER RetrieveINNINGSEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*InningsBreakEventGetArray= [PushSyncDBMANAGER RetrieveIINNINGSBREAKEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*BallEventGetArray= [PushSyncDBMANAGER RetrieveBALLEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*BattingSummeryGetArray= [PushSyncDBMANAGER RetrieveBATTINGSUMMARYData:_competitionCode :_matchCode];
    
    NSMutableArray*OverEventGetArray= [PushSyncDBMANAGER RetrieveOVEREVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*BowlingSummeryGetArray= [PushSyncDBMANAGER RetrieveBOWLINGSUMMARYData:_competitionCode :_matchCode];
    
    NSMutableArray*BowlingMaidenSummeryGetArray= [PushSyncDBMANAGER RetrieveBOWLINGMAIDENSUMMARYData:_competitionCode :_matchCode];
    
    NSMutableArray*BowlingOverDetailsGetArray= [PushSyncDBMANAGER RetrieveBOWLEROVERDETAILSData:_competitionCode :_matchCode];
    
    
    NSMutableArray*FieldingEventGetArray= [PushSyncDBMANAGER RetrieveFIELDINGEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*DayEventGetArray= [PushSyncDBMANAGER RetrieveDAYEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*SessionEventGetArray= [PushSyncDBMANAGER RetrieveSESSIONEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*AppealEventGetArray= [PushSyncDBMANAGER RetrieveAPPEALEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*WicketEventGetArray= [PushSyncDBMANAGER RetrieveWICKETEVENTSData:_competitionCode :_matchCode];
    
    NSMutableArray*PowerPlayGetArray= [PushSyncDBMANAGER RetrievePOWERPLAYData:_competitionCode :_matchCode];
    
    NSMutableArray*PlayerInOutTimeGetArray= [PushSyncDBMANAGER RetrievePLAYERINOUTTIMEData:_competitionCode :_matchCode];
    
    
    NSMutableArray*PenalitydetailsGetArray= [PushSyncDBMANAGER RetrievePENALTYDETAILSData:_competitionCode :_matchCode];
    
    NSMutableArray*CapTransactionLogEntryGetArray= [PushSyncDBMANAGER RetrieveCAPTRANSACTIONSLOGENTRYData:_competitionCode :_matchCode];
    
    
    NSMutableDictionary *PushDict =[[NSMutableDictionary alloc]init];
    [PushDict setObject:MatcRegistraionGetArray forKey:@"MatcRegistraion"];
    [PushDict setObject:MatchTeamplayerDetailsGetArray forKey:@"MatchTeamplayerDetails"];
     [PushDict setObject:MatchresultGetArray forKey:@"Matchresult"];
     [PushDict setObject:MatchEventGetArray forKey:@"MatchEvent"];
     [PushDict setObject:InningsSummeryGetArray forKey:@"InningsSummery"];
     [PushDict setObject:InningsEventGetArray forKey:@"InningsEvent"];
     [PushDict setObject:InningsBreakEventGetArray forKey:@"InningsBreakEvent"];
     [PushDict setObject:BallEventGetArray forKey:@"BallEvent"];
     [PushDict setObject:BattingSummeryGetArray forKey:@"BattingSummery"];
     [PushDict setObject:OverEventGetArray forKey:@"OverEvent"];
     [PushDict setObject:BowlingSummeryGetArray forKey:@"BowlingSummery"];
     [PushDict setObject:BowlingMaidenSummeryGetArray forKey:@"BowlingMaidenSummery"];
     [PushDict setObject:BowlingOverDetailsGetArray forKey:@"BowlingOverDetails"];
     [PushDict setObject:FieldingEventGetArray forKey:@"FieldingEvent"];
     [PushDict setObject:DayEventGetArray forKey:@"DayEvent"];
     [PushDict setObject:SessionEventGetArray forKey:@"SessionEvent"];
    [PushDict setObject:AppealEventGetArray forKey:@"AppealEvent"];
    [PushDict setObject:WicketEventGetArray forKey:@"WicketEvent"];
    [PushDict setObject:PowerPlayGetArray forKey:@"PowerPlay"];
    [PushDict setObject:PlayerInOutTimeGetArray forKey:@"PlayerInOutTime"];
    [PushDict setObject:PenalitydetailsGetArray forKey:@"Penalitydetails"];
    [PushDict setObject:CapTransactionLogEntryGetArray forKey:@"CapTransactionLogEntry"];
    
    
    
//    NSData *data = [NSJSONSerialization dataWithJSONObject:PushDict options:0 error:nil];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://url"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionUploadTask *dataTask = [session uploadTaskWithRequest: request
//                                                             fromData: data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                 NSLog(@"%@", json);
//                                                             }];
    
}
- (IBAction)Exit_btn:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ScoreEnginExit"];
    
    ArchivesVC *Archivevc = [[ArchivesVC alloc]init];
    Archivevc =  (ArchivesVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
   // Archivevc.matchCode=self.matchCode;
    Archivevc.CompitionCode=self.competitionCode;
    [self.navigationController pushViewController:Archivevc animated:YES];
}

- (void) ChangeVCBackBtnAction
{
    [fullview removeFromSuperview];
}

-(void) EndInningsBackBtnAction{
    
    [fullview removeFromSuperview];
    int inningsno =[fetchSEPageLoadRecord.INNINGSNO intValue];
    if(inningsno > 1)
    {
        _rightSlideArray = [[NSMutableArray alloc]initWithObjects:@"BREAK",@"CHANGE TEAM",@"DECLARE INNINGS",@"END DAY",@"END INNINGS",@"END SESSION",@"FOLLOW ON",@"PLAYING XI EDIT",@"MATCH RESULTS",@"OTHER WICKETS",@"PENALTY",@"POWER PLAY",@"REVISED OVERS",@"REVISED TARGET", nil];
        
    }
    else{
        _rightSlideArray = [[NSMutableArray alloc]initWithObjects:@"BREAK",@"CHANGE TOSS",@"DECLARE INNINGS",@"END DAY",@"END INNINGS",@"END SESSION",@"FOLLOW ON",@"PLAYING XI EDIT",@"MATCH RESULTS",@"OTHER WICKETS",@"PENALTY",@"POWER PLAY",@"REVISED OVERS",@"REVISED TARGET", nil];
    }
    [self.sideviewtable reloadData];
}

-(void) EndInningsSaveBtnAction{
    
    [fullview removeFromSuperview];
    ArchivesVC *Archivevc = [[ArchivesVC alloc]init];
    Archivevc =  (ArchivesVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
    // Archivevc.matchCode=self.matchCode;
    Archivevc.CompitionCode=self.competitionCode;
    [self.navigationController pushViewController:Archivevc animated:YES];
}

-(void)declareSaveBtnAction{
    [fullview removeFromSuperview];
    ArchivesVC *Archivevc = [[ArchivesVC alloc]init];
    Archivevc =  (ArchivesVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
    // Archivevc.matchCode=self.matchCode;
    Archivevc.CompitionCode=self.competitionCode;
    [self.navigationController pushViewController:Archivevc animated:YES];
}

-(void)declareBackBtnAction{
    
    [fullview removeFromSuperview];
}

-(void)declareRevertBtnAction{
    [fullview removeFromSuperview];
    ArchivesVC *Archivevc = [[ArchivesVC alloc]init];
    Archivevc =  (ArchivesVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
    // Archivevc.matchCode=self.matchCode;
    Archivevc.CompitionCode=self.competitionCode;
    [self.navigationController pushViewController:Archivevc animated:YES];
}
-(BOOL) checkBeatenOnSelect{

        if (_ballEventRecord.objIsbeaten.intValue == 0)
        {
            if (_ballEventRecord.objByes.intValue == 0)
            {
                if ((_ballEventRecord.objRuns.intValue + _ballEventRecord.objOverthrow.intValue) > 0)
                {
                    UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Beaten is not possible with Runs. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [altert show];
                    [altert setTag:10400];
                    
                    
                    return NO;
                }
                else if (_ballEventRecord.objLegByes.intValue > 0)
                {
                    
                    UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Beaten is not possible with Legbyes. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [altert show];
                    [altert setTag:10401];
                    
                    return NO;
                }
            }
        }
    return YES;
}

-(BOOL) checkBeatenOnRuns{
    
    
    //string[] Ids = { "btnNB", "btnWD", "btnLB", "btnB" };
   
        if (_ballEventRecord.objIsbeaten.intValue == 1 && _ballEventRecord.objByes.intValue == 0)
        {
            
            UIAlertView *altert =[[UIAlertView alloc]initWithTitle:@"Score Engine" message:@"Runs are not possible with Beaten. " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [altert show];
            [altert setTag:10403];
            
            return NO;
        }
    
    

    return YES;
}




@end
