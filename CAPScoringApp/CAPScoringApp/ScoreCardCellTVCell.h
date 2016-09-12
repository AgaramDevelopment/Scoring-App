//
//  ScoreCardCellTVCell.h
//  CAPScoringApp
//
//  Created by APPLE on 16/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCardCellTVCell : UITableViewCell

@property (strong,nonatomic) IBOutlet UIView * expand_View;
@property (strong,nonatomic) IBOutlet UIImageView * wagonPitch_img;
@property (strong,nonatomic) IBOutlet UIButton * spiderWagon_Btn;
@property (strong,nonatomic) IBOutlet UIButton * sectorWagon_Btn;
@property (strong,nonatomic) IBOutlet UIButton * pitch_Btn;
@property (strong,nonatomic) IBOutlet UIButton * onSide_Btn;
@property (strong,nonatomic) IBOutlet UIButton * offSide_Btn;
@property (strong,nonatomic) IBOutlet UIButton * wangon1s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * wangon2s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * wangon3s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * wangon4s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * wangon6s_Btn;



@property (strong,nonatomic) IBOutlet UIView * expandBowler_View;
@property (strong,nonatomic) IBOutlet UIImageView * BowlerwagonPitch_img;
@property (strong,nonatomic) IBOutlet UIButton * BowlerspiderWagon_Btn;
@property (strong,nonatomic) IBOutlet UIButton * BowlersectorWagon_Btn;
@property (strong,nonatomic) IBOutlet UIButton * Bowlerpitch_Btn;
@property (strong,nonatomic) IBOutlet UIButton * BowleronSide_Btn;
@property (strong,nonatomic) IBOutlet UIButton * BowleroffSide_Btn;
@property (strong,nonatomic) IBOutlet UIButton * Bowlerwangon1s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * Bowlerwangon2s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * Bowlerwangon3s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * Bowlerwangon4s_Btn;
@property (strong,nonatomic) IBOutlet UIButton * Bowlerwangon6s_Btn;





@property (strong, nonatomic) IBOutlet UIButton *btn_expand;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dot_ball_percent;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dot_ball;
@property (strong, nonatomic) IBOutlet UILabel *lbl_rss;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b_sixes;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b_fours;
@property (strong, nonatomic) IBOutlet UILabel *lbl_sr;
@property (strong, nonatomic) IBOutlet UILabel *lbl_balls;
@property (strong, nonatomic) IBOutlet UILabel *lbl_runs;
@property (strong, nonatomic) IBOutlet UIImageView *img_expand;
@property (strong, nonatomic) IBOutlet UILabel *lbl_player_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_how_out;

//Bowler
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_over;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_noball;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_wide;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_ecno;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_fours;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_sixes;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_wicket;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_maiden;
@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_runs;


//Extras
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalExtra_runs;

@property (weak, nonatomic) IBOutlet UILabel *lbl_extras;

//Over runs

@property (weak, nonatomic) IBOutlet UILabel *lbl_over_run_rate;

//Did Not Bat
@property (weak, nonatomic) IBOutlet UILabel *lbl_didNotBat;

//Fall of Wkt
@property (weak, nonatomic) IBOutlet UILabel *lbl_fall_of_wkt;


@end
