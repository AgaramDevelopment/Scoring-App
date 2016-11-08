//
//  BowlingKPITVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 08/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BowlingKPITVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbl_bowler_name;

@property (strong, nonatomic) IBOutlet UILabel *lbl_over;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ball;
@property (strong, nonatomic) IBOutlet UILabel *lbl_runs;
@property (strong, nonatomic) IBOutlet UILabel *lbl_eco;
@property (strong, nonatomic) IBOutlet UILabel *lbl_dB;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ones;
@property (strong, nonatomic) IBOutlet UILabel *lbl_twos;
@property (strong, nonatomic) IBOutlet UILabel *lbl_threes;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b4;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b6;
@property (strong, nonatomic) IBOutlet UILabel *lbl_one_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_two_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_three_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b4_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b6_per;

@end
