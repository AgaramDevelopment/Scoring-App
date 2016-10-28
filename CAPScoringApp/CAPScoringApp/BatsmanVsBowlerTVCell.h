//
//  BatsmanVsBowlerTVCell.h
//  CAPScoringApp
//
//  Created by Mac on 28/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatsmanVsBowlerTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_team_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_runs;
@property (weak, nonatomic) IBOutlet UILabel *lbl_balls;
@property (weak, nonatomic) IBOutlet UILabel *lbl_zeros;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ones;
@property (weak, nonatomic) IBOutlet UILabel *lbl_twos;
@property (weak, nonatomic) IBOutlet UILabel *lbl_threes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_b4;
@property (weak, nonatomic) IBOutlet UILabel *lbl_b6;
@property (weak, nonatomic) IBOutlet UILabel *lbl_unc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_btn;
@property (weak, nonatomic) IBOutlet UILabel *lbl_wtb;
@property (weak, nonatomic) IBOutlet UILabel *lbl_wicket_type;

@end
