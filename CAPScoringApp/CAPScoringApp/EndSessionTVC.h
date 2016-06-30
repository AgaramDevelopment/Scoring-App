//
//  EndSessionTVC.h
//  CAPScoringApp
//
//  Created by mac on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndSessionTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_startSessionTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_endSessionTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_teamName;

@property (weak, nonatomic) IBOutlet UILabel *lbl_dayNo;

@property (weak, nonatomic) IBOutlet UILabel *lbl_sessionNo;

@end
