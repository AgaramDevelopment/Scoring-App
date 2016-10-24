//
//  SpiderWagonReportVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 22/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpiderWagonReportVC : UIViewController


@property(nonatomic,strong) NSString * compititionCode;
@property (nonatomic,strong) NSString * matchCode;
@property (nonatomic,strong) NSString * matchTypeCode;
@property (nonatomic,strong) NSString * teamCode;

@property (nonatomic,strong) NSString * selectStrikerCode;
@property (nonatomic,strong) NSString * selectBowlerCode;

@property (nonatomic,strong) NSString *selectBattingStyle;

@property (strong, nonatomic) IBOutlet UIView *striker_view;
@property (strong, nonatomic) IBOutlet UIView *bowler_view;

@property (nonatomic,strong) IBOutlet UIButton * btn_first_inns;

- (IBAction)btn_first_inns:(id)sender;

- (IBAction)btn_sec_inns:(id)sender;

- (IBAction)btn_third_inns:(id)sender;

- (IBAction)btn_fourth_inns:(id)sender;

- (IBAction)hide_Filer_view:(id)sender;

- (IBAction)didClickStricker:(id)sender;

- (IBAction)didClickBowler:(id)sender;

- (IBAction)demo_Ww:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *lbl_striker;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler;

@property (strong, nonatomic) IBOutlet UITableView *tbl_players;

@property (strong, nonatomic) IBOutlet UIView *filter_view;
@property (strong, nonatomic) IBOutlet UIImageView *img_wagon;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * strikerTblYposition;


@end
