//
//  NewMatchSetUpVC.h
//  CAPScoringApp
//
//  Created by deepak on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NewMatchSetUpVC : UIViewController


@property (strong,nonatomic) NSMutableArray *matchSetUp;
@property(strong,nonatomic) NSString *teamA;
@property(strong,nonatomic) NSString *teamB;
@property(strong,nonatomic) NSString *matchType;
@property(strong,nonatomic) NSString *overs;
@property(strong,nonatomic) NSString *date;
@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *matchVenu;
@property(strong,nonatomic) NSString *month;
@property(strong,nonatomic) NSString *matchCode;
@property(strong,nonatomic) NSString *competitionCode;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSString *teamAcode;
@property(strong,nonatomic)NSString *teamBcode;

@property(assign,nonatomic) BOOL isEdit;


@property (weak, nonatomic) IBOutlet UIView *view_overs;
@property (weak, nonatomic) IBOutlet UITextField *txt_overs;

@property (weak, nonatomic) IBOutlet UILabel *lab_matchType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_monYear;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UILabel *lbl_venu;
@property (weak, nonatomic) IBOutlet UILabel *lbl_teamA;
@property (weak, nonatomic) IBOutlet UILabel *lbl_teamB;

@property (weak, nonatomic) IBOutlet UIImageView *img_teamALogo;
@property (weak, nonatomic) IBOutlet UIImageView *img_teamBLogo;

@property (strong, nonatomic) IBOutlet UIButton *btnUpdateOutlet;


@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelagate;
@property (weak, nonatomic) IBOutlet UIImageView *img_editIcon;
@property (weak, nonatomic) IBOutlet UIView *view_editOvers;

@property (weak, nonatomic) IBOutlet UIButton *btn_editOvers;
@property (weak, nonatomic) IBOutlet UIView *view_teamA;
@property (weak, nonatomic) IBOutlet UIView *view_teamB;


- (IBAction)btn_selectPlayersTeamA:(id)sender;
- (IBAction)btn_selectPlayersTeamB:(id)sender;
- (IBAction)btn_edit:(id)sender;
- (IBAction)btn_proceed:(id)sender;
- (IBAction)btn_back:(id)sender;
@property(nonatomic,strong) NSMutableArray *playingXIPlayers;
-(BOOL)textValidation:(NSString*) validation;

@end
