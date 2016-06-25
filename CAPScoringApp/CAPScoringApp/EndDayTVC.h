//
//  EndDayTVC.h
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndDayTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_team_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_day;
@property (strong, nonatomic) IBOutlet UILabel *lbl_innings;
@property (strong, nonatomic) IBOutlet UILabel *lbl_runs;
@property (strong, nonatomic) IBOutlet UILabel *lbl_overs;
@property (strong, nonatomic) IBOutlet UILabel *lbl_wickets;

@end
