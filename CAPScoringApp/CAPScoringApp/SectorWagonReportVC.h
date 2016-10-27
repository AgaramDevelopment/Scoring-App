//
//  SectorWagonReportVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 27/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectorWagonReportVC : UIViewController

@property(nonatomic,strong) NSString * compititionCode;
@property (nonatomic,strong) NSString * matchCode;
@property (nonatomic,strong) NSString * matchTypeCode;
@property (nonatomic,strong) NSString * teamCode;

@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;

@property (nonatomic,strong) NSString * selectStrikerCode;
@property (nonatomic,strong) NSString * selectBowlerCode;
@property (nonatomic,strong) NSString *selectBattingStyle;


@property (strong, nonatomic) IBOutlet UIImageView *img_sector;

@property (strong, nonatomic) IBOutlet UIView *hide_btn_view;
@property (strong, nonatomic) IBOutlet UIView *filter_view;

@property (strong, nonatomic) IBOutlet UIButton *inns_one;
@property (strong, nonatomic) IBOutlet UIButton *inns_two;
@property (strong, nonatomic) IBOutlet UIButton *inns_three;
@property (strong, nonatomic) IBOutlet UIButton *inns_four;

@property (strong, nonatomic) IBOutlet UIView *striker_view;
@property (strong, nonatomic) IBOutlet UIView *bowler_view;

@property (strong, nonatomic) IBOutlet UILabel *lbl_striker;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler;


@property (strong, nonatomic) IBOutlet UIButton *one_run;
@property (strong, nonatomic) IBOutlet UIButton *two_run;
@property (strong, nonatomic) IBOutlet UIButton *three_run;
@property (strong, nonatomic) IBOutlet UIButton *four_run;
@property (strong, nonatomic) IBOutlet UIButton *six_runs;
@property (strong, nonatomic) IBOutlet UIButton *btn_onSide;
@property (strong, nonatomic) IBOutlet UIButton *btn_offSide;


@property (strong, nonatomic) IBOutlet UITableView *tbl_players;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_two_width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_one_width;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * strikerTblYposition; 
- (IBAction)btn_done:(id)sender;

- (IBAction)ones:(id)sender;
- (IBAction)twos:(id)sender;
- (IBAction)threes:(id)sender;
- (IBAction)fours:(id)sender;
- (IBAction)six:(id)sender;
- (IBAction)onSide:(id)sender;
- (IBAction)offSide:(id)sender;


- (IBAction)btn_first_inns:(id)sender;
- (IBAction)btn_sec_inns:(id)sender;
- (IBAction)btn_third_inns:(id)sender;
- (IBAction)btn_fourth_inns:(id)sender;
- (IBAction)hide_Filer_view:(id)sender;
- (IBAction)didClickStricker:(id)sender;
- (IBAction)didClickBowler:(id)sender;

@end
