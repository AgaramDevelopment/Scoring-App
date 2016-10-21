//
//  CommentaryTVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 20/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentaryTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_header_over;
@property (strong, nonatomic) IBOutlet UILabel *lbl_runs_wicks;
@property (strong, nonatomic) IBOutlet UILabel *lbl_team_score;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ball_ticker;
@property (strong, nonatomic) IBOutlet UILabel *lbl_over;
@property (strong, nonatomic) IBOutlet UILabel *lbl_players_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_commentary;
@property (strong, nonatomic) IBOutlet UIView *view_header;
@end
