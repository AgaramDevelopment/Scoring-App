//
//  FixtureAndResultsTVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 17/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixtureTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *month_txt;
@property (weak, nonatomic) IBOutlet UILabel *day_no_txt;
@property (weak, nonatomic) IBOutlet UILabel *day_txt;

@property (weak, nonatomic) IBOutlet UILabel *match_type;

@property (weak, nonatomic) IBOutlet UILabel *teamA_txt;

@property (weak, nonatomic) IBOutlet UILabel *teamB_txt;

@property (weak, nonatomic) IBOutlet UILabel *venu_txt;


@property (weak, nonatomic) IBOutlet UIImageView *teamA_img;

@property (weak, nonatomic) IBOutlet UIImageView *teamB_img;

@property (weak, nonatomic) IBOutlet UIView *strip_view;

@end
