//
//  LiveMatchCell.h
//  CAPScoringApp
//
//  Created by APPLE on 18/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveMatchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_month;
@property (strong, nonatomic) IBOutlet UILabel *lbl_day;
@property (strong, nonatomic) IBOutlet UILabel *lbl_week_day;
@property (strong, nonatomic) IBOutlet UIImageView *img_team_a_logo;
@property (strong, nonatomic) IBOutlet UILabel *lbl_team_a_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_match_type;
@property (strong, nonatomic) IBOutlet UILabel *lbl_team_b_name;
@property (strong, nonatomic) IBOutlet UIImageView *lbl_team_b_logo;

@end
