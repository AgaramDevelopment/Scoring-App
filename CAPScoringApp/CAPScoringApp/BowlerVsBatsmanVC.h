//
//  BowlerVsBatsmanVC.h
//  CAPScoringApp
//
//  Created by Mac on 01/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BowlerVsBatsmanTVCell.h"

@interface BowlerVsBatsmanVC : UIViewController


@property(strong,nonatomic)NSString *matchCode;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSString *compititionCode;

@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;

- (IBAction)did_click_inn_one:(id)sender;
- (IBAction)did_click_inn_four:(id)sender;
- (IBAction)did_click_inn_two:(id)sender;
- (IBAction)did_click_inn_three:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *inns_one;

@property (strong, nonatomic) IBOutlet UIButton *inns_four;
@property (strong, nonatomic) IBOutlet UIButton *inns_three;
@property (strong, nonatomic) IBOutlet UIButton *inns_two;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_two_width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_one_width;
@property (weak, nonatomic) IBOutlet UIImageView *img_bowler_photo;
@property (weak, nonatomic) IBOutlet UILabel *batsman_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dots;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ones;
@property (weak, nonatomic) IBOutlet UILabel *lbl_twos;
@property (weak, nonatomic) IBOutlet UILabel *lbl_threes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_fours;

@property (weak, nonatomic) IBOutlet UILabel *lbl_fives;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sixes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sevens;
@property (weak, nonatomic) IBOutlet UILabel *lbl_b4s;
@property (weak, nonatomic) IBOutlet UILabel *lbl_b6s;
@property (weak, nonatomic) IBOutlet UILabel *lbl_unc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_btn;
@property (weak, nonatomic) IBOutlet UILabel *lbl_wtb;
@property (weak, nonatomic) IBOutlet UILabel *lbl_balls;
@property (weak, nonatomic) IBOutlet UILabel *lbl_runs;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sr;

@property (strong, nonatomic) IBOutlet BowlerVsBatsmanTVCell *bowl_vs_bats_tvcell;

@property (weak, nonatomic) IBOutlet UITableView *tableview_batsman;
@property (weak, nonatomic) IBOutlet UIButton *btn_filter_ok;

@property (weak, nonatomic) IBOutlet UIView *view_filter;
@property (weak, nonatomic) IBOutlet UITableView *tableview_filter_bowler;
@property (weak, nonatomic) IBOutlet UILabel *lbl_filter_bowler_name;
- (IBAction)did_click_filter_bowler:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_open_filter;

- (IBAction)did_click_open_filter:(id)sender;

- (IBAction)did_click_filter_ok:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_bowler_details;
@property (weak, nonatomic) IBOutlet UIView *view_batsman_header;

- (IBAction)did_click_close_filter:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *view_filter_bowler;

@end
