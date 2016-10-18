//
//  FixtureAndResultsTVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 17/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixtureTVC : UITableViewCell



@property (strong, nonatomic) IBOutlet UILabel *month_txt;

@property (strong, nonatomic) IBOutlet UILabel *day_no_txt;

@property (strong, nonatomic) IBOutlet UILabel *day_txt;
@property (strong, nonatomic) IBOutlet UIImageView *teamA_img;

@property (strong, nonatomic) IBOutlet UILabel *teamA_txt;

@property (strong, nonatomic) IBOutlet UILabel *match_type;

@property (strong, nonatomic) IBOutlet UILabel *teamB_txt;
@property (strong, nonatomic) IBOutlet UILabel *venu_txt;
@property (strong, nonatomic) IBOutlet UIImageView *teamB_img;

@property (strong, nonatomic) IBOutlet UIView *strip_view;

@end
