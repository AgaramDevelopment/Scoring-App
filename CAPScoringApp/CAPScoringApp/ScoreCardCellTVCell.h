//
//  ScoreCardCellTVCell.h
//  CAPScoringApp
//
//  Created by APPLE on 16/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCardCellTVCell : UITableViewCell
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

@end
