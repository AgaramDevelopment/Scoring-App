//
//  EndInningsTVC.h
//  CAPScoringApp
//
//  Created by mac on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndInningsTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_startTime;

@property (weak, nonatomic) IBOutlet UILabel *lbl_endTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;

@end
