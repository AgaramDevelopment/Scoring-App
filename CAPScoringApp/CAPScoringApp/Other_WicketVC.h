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

- (IBAction)Wicket_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Wicket_lbl;
- (IBAction)add_btn:(id)sender;

- (IBAction)back_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *Wicket_tableview;

@property (strong, nonatomic) IBOutlet UIButton *Wicket_btn;

@property (strong, nonatomic) IBOutlet UIButton *button_touch;


- (IBAction)check:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *selectplayer_lbl;

@property (strong, nonatomic) IBOutlet UITableView *tbl_playername;
@property (strong, nonatomic) IBOutlet UIView *Player_view;

@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSNumber*INNINGSNO;
@property(strong,nonatomic)NSString*TEAMCODE;
@property(strong,nonatomic)NSString*STRIKERCODE;
@property(strong,nonatomic)NSString*NONSTRIKERCODE;

@end
