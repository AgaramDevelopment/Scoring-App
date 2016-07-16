//
//  MatchResultListVC.h
//  CAPScoringApp
//
//  Created by APPLE on 22/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MatchResultListVCDelagate <NSObject>
@required

- (void) MatchResultFinishBtnAction;


@end

@interface MatchResultListVC : UIViewController



@property(nonatomic,strong) id <MatchResultListVCDelagate> delegate;
- (IBAction)btn_back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_result_type;
- (IBAction)btn_result_type:(id)sender;
- (IBAction)btn_done:(id)sender;
- (IBAction)btn_revert:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_result_type_frame;
@property (strong, nonatomic) IBOutlet UIView *view_result_type;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_team;
- (IBAction)btn_team:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtf_comments;
@property (strong, nonatomic) IBOutlet UILabel *lbl_man_of_the_match;
- (IBAction)btn_man_of_the_match:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_man_of_the_series;
- (IBAction)btn_man_of_the_series:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btn_team_id;

@property (strong, nonatomic) IBOutlet UIView *view_team_layer;
@property (strong, nonatomic) IBOutlet UIView *view_man_of_the_match;
@property (strong, nonatomic) IBOutlet UIView *view_man_of_the_series;
@property (strong, nonatomic) IBOutlet UIView *view_best_batsman;
@property (strong, nonatomic) IBOutlet UIView *view_best_bowler;
@property (strong, nonatomic) IBOutlet UIView *view_best_allrounder;
@property (strong, nonatomic) IBOutlet UIView *view_most_wicket;

@property (strong, nonatomic) IBOutlet UIButton *btn_submit_id;

@property (strong, nonatomic) IBOutlet UITextField *txtf_team_a_point;
@property (strong, nonatomic) IBOutlet UILabel *lbl_team_a_point;
@property (strong, nonatomic) IBOutlet UITextField *txtf_team_b_point;
@property (strong, nonatomic) IBOutlet UILabel *lbl_team_b_point;
@property (strong, nonatomic) IBOutlet UILabel *lbl_select_best_batsman;
- (IBAction)btn_best_batsman:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_select_best_bowler;
- (IBAction)btn_best_bowler:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_select_allrounder;
- (IBAction)btn_allrounder:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lbl_select_most_valu_player;

- (IBAction)btn_most_valu_player:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_back;

@property (strong, nonatomic) IBOutlet UIButton *btn_revert_id;



@property(strong,nonatomic) NSString *competitionCode;
@property(strong,nonatomic) NSString *matchCode;
@property(strong,nonatomic) NSString *TEAMACODE;
@property(strong,nonatomic) NSNumber *INNINGSNO;


@end
