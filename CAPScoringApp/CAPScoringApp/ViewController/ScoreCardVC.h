//
//  ScoreCardVC.h
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreCardCellTVCell.h"

@interface ScoreCardVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbl_scorecard;
@property (strong, nonatomic) IBOutlet ScoreCardCellTVCell *batsmanCell;

@property (strong, nonatomic) IBOutlet ScoreCardCellTVCell *batsManHeaderCell;
@property (strong, nonatomic) IBOutlet ScoreCardCellTVCell *bowlerHeaderCell;
@property (strong, nonatomic) IBOutlet ScoreCardCellTVCell *bowlerCell;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lbl_strip;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn_tab_fst_inns;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn_tab_second_inns;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn_tab_third_inns;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn_tab_fourth_inns;


@property (strong, nonatomic) IBOutlet UIButton *btn_fst_inns_id;
- (IBAction)btn_fst_inns_action:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_fst_div;


@property (strong, nonatomic) IBOutlet UIButton *btn_sec_inns_id;

- (IBAction)btn_sec_inns_action:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_sec_div;


@property (strong, nonatomic) IBOutlet UIButton *btn_third_inns_id;
- (IBAction)btn_third_inns_action:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_third_div;

@property (strong, nonatomic) IBOutlet UIButton *btn_fourth_inns_id;
- (IBAction)btn_fourth_inns_action:(id)sender;


@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamAfirstIngsScore;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamAfirstIngsOvs;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamBfirstIngsScore;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamBfirstIngsOvs;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamAsecIngsHeading;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamBsecIngsHeading;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamASecIngsScore;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamASecIngsOvs;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamBSecIngsScore;
@property (strong,nonatomic) IBOutlet UILabel  * lbl_teamBSecIngsOvs;


@property (weak, nonatomic) IBOutlet UILabel *lbl_battingShrtName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_battingScoreWkts;
@property (weak, nonatomic) IBOutlet UILabel *lbl_overs;
@property (weak, nonatomic) IBOutlet UILabel *lbl_runRate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_firstIngsTeamName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_secIngsTeamName;
@property (weak, nonatomic) IBOutlet UIImageView *img_firstIngsTeamName;
@property (weak, nonatomic) IBOutlet UIImageView *img_secIngsTeamName;


@property(nonatomic,assign)NSInteger *BATTEAMWICKETS;
@property(nonatomic,assign)NSInteger *BATTEAMOVERS;
@property(nonatomic,assign)NSInteger *BATTEAMOVRBALLS;
@property(nonatomic,assign)NSNumber *BATTEAMRUNRATE;


@property(nonatomic,assign)NSInteger *BATTEAMRUNS;
@property(nonatomic,assign)NSNumber *RUNSREQUIRED;


@property(strong,nonatomic) NSString *competitionCode;
@property(strong,nonatomic) NSString *matchCode;
@property(strong,nonatomic) NSString *matchTypeCode;


@property(strong,nonatomic) NSString *inningsNo;
@property(strong,nonatomic) NSString *BATTEAMSHORTNAME;
@property(strong,nonatomic) NSString *BOWLTEAMSHORTNAME;




@property(strong,nonatomic)NSString *FIRSTINNINGSTOTAL;
@property(strong,nonatomic)NSString *SECONDINNINGSTOTAL;
@property(strong,nonatomic)NSString *THIRDINNINGSTOTAL;
@property(strong,nonatomic)NSString *FOURTHINNINGSTOTAL;

@property(strong,nonatomic)NSString *FIRSTINNINGSWICKET;
@property(strong,nonatomic)NSString *SECONDINNINGSWICKET;
@property(strong,nonatomic)NSString *THIRDINNINGSWICKET;
@property(strong,nonatomic)NSString *FOURTHINNINGSWICKET;

@property(strong,nonatomic)NSString *FIRSTINNINGSSCORE;
@property(strong,nonatomic)NSString *SECONDINNINGSSCORE;
@property(strong,nonatomic)NSString *THIRDINNINGSSCORE;
@property(strong,nonatomic)NSString *FOURTHINNINGSSCORE;

@property(strong,nonatomic)NSString *FIRSTINNINGSOVERS;
@property(strong,nonatomic)NSString *SECONDINNINGSOVERS;
@property(strong,nonatomic)NSString *THIRDINNINGSOVERS;
@property(strong,nonatomic)NSString *FOURTHINNINGSOVERS;

@property(strong,nonatomic)NSString *FIRSTINNINGSSHORTNAME;
@property(strong,nonatomic)NSString *SECONDINNINGSSHORTNAME;

@property(strong,nonatomic)NSString *THIRDINNINGSSHORTNAME;
@property(strong,nonatomic)NSString *FOURTHINNINGSSHORTNAME;

@property(strong,nonatomic)NSString *AA;
@property(strong,nonatomic)NSString *BB;
@property(strong,nonatomic)NSString *AAWIC;
@property(strong,nonatomic)NSString *BBWIC;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn_fst_inn_x;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btn_sec_inn_x;

@end
