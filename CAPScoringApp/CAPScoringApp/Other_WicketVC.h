//
//  Other_WicketVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScorEnginVC.h"

@interface Other_WicketVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *WICKET_VIEW;

@property (strong, nonatomic) IBOutlet UILabel *Wicket_lbl;
@property (strong, nonatomic) IBOutlet UIButton *button_touch;
@property (strong, nonatomic) IBOutlet UITableView *Wicket_tableview;


- (IBAction)add_btn:(id)sender;

- (IBAction)back_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *Player_view;

@property (strong, nonatomic) IBOutlet UILabel *selectplayer_lbl;
@property (strong, nonatomic) IBOutlet UIButton *touch_player;
@property (strong, nonatomic) IBOutlet UITableView *tbl_playername;



@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSNumber*INNINGSNO;
@property(strong,nonatomic)NSString*TEAMCODE;
@property(strong,nonatomic)NSString*STRIKERCODE;
@property(strong,nonatomic)NSString*NONSTRIKERCODE;
@property(strong,nonatomic)NSString*NONSTRIKERNAME;

@property(strong,nonatomic)NSString*WICKETTYPE;
@property(strong,nonatomic)NSString*WICKETPLAYER;
@property(strong,nonatomic)NSNumber*WICKETNO;
@property(assign,nonatomic)BOOL ISEDITMODE;


@property (strong, nonatomic) IBOutlet UIButton *btn_delete;



@property (strong, nonatomic) IBOutlet UIButton *btn_save;


- (IBAction)btn_save:(id)sender;


@property(nonatomic,strong)NSString *MAXOVER;
@property(nonatomic,strong)NSString *MAXBALL;
@property(nonatomic,strong)NSString *BALLCODE;
@property(nonatomic,strong)NSString *BALLCOUNT;
@property(nonatomic,strong)NSNumber *MAXID;
@property(nonatomic,strong)NSNumber *N_WICKETNO;
@property(nonatomic,strong)NSString *N_WICKETTYPE;
@property(nonatomic,strong)NSNumber *N_FIELDERCODE;
@property(nonatomic,strong)NSNumber *BATTINGPOSITIONNO;


@property (strong, nonatomic) IBOutlet UILabel *WICKET_NO_LBL;


@end
