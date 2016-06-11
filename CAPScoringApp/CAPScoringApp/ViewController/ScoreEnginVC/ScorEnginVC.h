//
//  ScorEnginVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScorEnginVC : UIViewController<UIGestureRecognizerDelegate>


@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;
//@property(nonatomic,strong) NSMutableArray * strikerArray;
//@property(nonatomic,strong) NSMutableArray *non_StrikerArray;


@property(nonatomic,strong) NSString * BatmenStyle;

@property (nonatomic,strong) IBOutlet UIView *CommonView;
@property (nonatomic,strong) IBOutlet UIView *TopView;
@property (nonatomic,strong) IBOutlet UIView *TopScorView;
@property (nonatomic,strong) IBOutlet UIView *TopFirstInsView;
@property (nonatomic,strong) IBOutlet UIView *TopSecondInsView;

// BATSMENVIEW
@property(nonatomic,strong) IBOutlet UIView * BatsmenView;
@property(nonatomic,strong) IBOutlet UIView * BatsmenTopView;
@property(nonatomic,strong) IBOutlet UILabel* selectBatsmenName;
//CurrentBatsmenScoredisplaylable
@property(nonatomic,strong) IBOutlet UIView * Batsmen1ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen14s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen16s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1SR;


@property(nonatomic,strong) IBOutlet UIView * Batsmen2ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen24s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen26s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2SR;



//BOWLERVIEW
@property(nonatomic,strong) IBOutlet UIView * BowlerView;
@property(nonatomic,strong) IBOutlet UIView * BowlerTopView;
@property(nonatomic,strong) IBOutlet UILabel* selectBowlerName;

//CurrentBowlerScoredisplaylable
@property(nonatomic,strong) IBOutlet UIView * Bowler1ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler14s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler16s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1SR;



@property(nonatomic,strong) IBOutlet UIView * Bowler2ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler24s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler26s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2SR;


@property(nonatomic,strong) IBOutlet UIButton * btn_StartBall;
@property(nonatomic,strong) IBOutlet UIButton * btn_StartOver;

@property(nonatomic,strong) IBOutlet UIView * leftsideview;
@property(nonatomic,strong) IBOutlet UIView * Rightsideview;
@property(nonatomic,strong) IBOutlet UIView * Allvaluedisplayview;



@property(nonatomic,strong) IBOutlet UIView *commonleftrightview;
@property(nonatomic,strong)  UILabel * PichMapTittle;

// Buttons left property

@property(nonatomic,strong) IBOutlet UIButton* btn_run1;
@property(nonatomic,strong) IBOutlet UIButton* btn_run2;
@property(nonatomic,strong) IBOutlet UIButton* btn_run3;
@property(nonatomic,strong) IBOutlet UIButton* btn_highRun;
@property(nonatomic,strong) IBOutlet UIButton* btn_B4;
@property(nonatomic,strong) IBOutlet UIButton* btn_B6;
@property(nonatomic,strong) IBOutlet UIButton* btn_extras;
@property(nonatomic,strong) IBOutlet UIButton* btn_wkts;
@property(nonatomic,strong) IBOutlet UIButton* btn_overthrow;
@property(nonatomic,strong) IBOutlet UIButton* btn_miscFilter;
@property(nonatomic,strong) IBOutlet UIButton* btn_pichmap;
@property(nonatomic,strong) IBOutlet UIButton* btn_wagonwheel;

// Buttons right property
@property(nonatomic,strong) IBOutlet UIButton* btn_OTW;
@property(nonatomic,strong) IBOutlet UIButton* btn_RTW;
@property(nonatomic,strong) IBOutlet UIButton* btn_Spin;
@property(nonatomic,strong) IBOutlet UIButton* btn_Fast;
@property(nonatomic,strong) IBOutlet UIButton* btn_Aggressive;
@property(nonatomic,strong) IBOutlet UIButton* btn_Defensive;
@property(nonatomic,strong) IBOutlet UIButton* btn_Fielding;
@property(nonatomic,strong) IBOutlet UIButton* btn_RBW;
@property(nonatomic,strong) IBOutlet UIButton* btn_Remarks;
@property(nonatomic,strong) IBOutlet UIButton* btn_Edit;
@property(nonatomic,strong) IBOutlet UIButton* btn_Appeals;
@property(nonatomic,strong) IBOutlet UIButton* btn_lastinstance;

@property(nonatomic,strong) IBOutlet UIImageView * img_pichmap;


//Appeal
@property (strong, nonatomic) IBOutlet UIView *View_Appeal;

@property (strong, nonatomic) IBOutlet UITableView *table_Appeal;
@property (strong, nonatomic) IBOutlet UIView *view_table_select;
@property (strong, nonatomic) IBOutlet UITableView *table_AppealSystem;
@property (strong, nonatomic) IBOutlet UITableView *table_AppealComponent;
@property (strong, nonatomic) IBOutlet UITableView *tanle_umpirename;
@property (strong, nonatomic) IBOutlet UITableView *table_BatsmenName;
@property (strong, nonatomic) IBOutlet UIView *view_AppealSystem;
@property (strong, nonatomic) IBOutlet UILabel *lbl_appealsystem;
- (IBAction)appeal_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view_AppealComponent;
- (IBAction)btn_AppealComponent:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lbl_appealComponent;

@property (strong, nonatomic) IBOutlet UIView *view_umpireName;
- (IBAction)btn_umpireName:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_umpirename;
@property (strong, nonatomic) IBOutlet UIView *view_batsmen;
- (IBAction)btn_batsmen:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_batsmen;
- (IBAction)btn_AppealSave:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *comments_txt;

//bowltype
@property (weak, nonatomic) IBOutlet UITableView *tbl_bowlType;
@property (weak, nonatomic) IBOutlet UIView *view_bowlType;



//fast bowl type
@property (weak, nonatomic) IBOutlet UIView *view_fastBowl;
@property (weak, nonatomic) IBOutlet UITableView *tbl_fastBowl;


//aggressive shot type
@property (weak, nonatomic) IBOutlet UITableView *tbl_aggressiveShot;
@property (weak, nonatomic) IBOutlet UIView *view_aggressiveShot;
//fielding factor
//@property (strong, nonatomic) IBOutlet UIView *view_fieldingfactor;
//@property (strong, nonatomic) IBOutlet UITableView *tbl_fieldingfactor;
//@property (strong, nonatomic) IBOutlet UIView *view_fieldername;  //fielding factor playername
//@property (strong, nonatomic) IBOutlet UIView *view_nrs;   //fileiding factor netruns

//defensive shot type

@property(nonatomic,strong) UILabel *centerlbl;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint* height;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint* width;
@property (weak, nonatomic) IBOutlet UITableView *tbl_defensive;
@property (weak, nonatomic) IBOutlet UIView *view_defensive;
@property (strong, nonatomic) IBOutlet UIView *view_Rbw;

@property (weak, nonatomic) IBOutlet UIView *view_otw;
@property (weak, nonatomic) IBOutlet UIView *view_rtw;
@property (weak, nonatomic) IBOutlet UIView *view_spin;
@property (weak, nonatomic) IBOutlet UIView *view_fast;
@property (strong, nonatomic) IBOutlet UILabel *lbl_fast;
@property (strong, nonatomic) IBOutlet UILabel *lbl_fast1;


@property (weak, nonatomic) IBOutlet UIView *view_aggressive;

@property (weak, nonatomic) IBOutlet UIView *view_defense;

@property (weak, nonatomic) IBOutlet UIView *view_fielding_factor;

@property (weak, nonatomic) IBOutlet UIView *view_BallTicker;

@property (strong, nonatomic) IBOutlet UIView *view_Wagon_wheel;

@property (strong, nonatomic) IBOutlet UIImageView *img_WagonWheel;

- (IBAction)WagonwheelTuch_btn:(id)sender forEvent:(UIEvent *)event;
    
@property (strong, nonatomic) IBOutlet UIView *view_DrawlineWagon;

@property (strong, nonatomic) IBOutlet UILabel *lbl_centerpoint;


@property (weak, nonatomic) IBOutlet UILabel *lbl_battingShrtName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_battingScoreWkts;

@property (weak, nonatomic) IBOutlet UILabel *lbl_overs;

@property (weak, nonatomic) IBOutlet UILabel *lbl_runRate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_firstIngsTeamName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_secIngsTeamName;
@property (weak, nonatomic) IBOutlet UIImageView *img_firstIngsTeamName;
@property (weak, nonatomic) IBOutlet UIImageView *img_secIngsTeamName;

@end
