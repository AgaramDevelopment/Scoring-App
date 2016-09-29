//
//  BatsManINOutTime.h
//  CAPScoringApp
//
//  Created by APPLE on 28/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatsManINOutTime : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_PlayerName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_StartTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EndTime;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Duration;

@end
