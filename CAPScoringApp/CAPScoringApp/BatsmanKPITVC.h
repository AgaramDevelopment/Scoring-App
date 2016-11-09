//
//  BatsmanKPITVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatsmanKPITVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_striker_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_runs;
@property (strong, nonatomic) IBOutlet UILabel *lbl_balls;
@property (strong, nonatomic) IBOutlet UILabel *lbl_db;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ones;
@property (strong, nonatomic) IBOutlet UILabel *lbl_twos;
@property (strong, nonatomic) IBOutlet UILabel *lbl_threes;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b4;
@property (strong, nonatomic) IBOutlet UILabel *lbl_b6;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ones_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_twos_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_threes_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_fours_per;
@property (strong, nonatomic) IBOutlet UILabel *lbl_six_per;

@end
