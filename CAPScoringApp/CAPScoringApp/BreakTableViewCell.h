//
//  BreakTableViewCell.h
//  CAPScoringApp
//
//  Created by Lexicon on 18/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreakTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *checklbl;
@property (strong, nonatomic) IBOutlet UILabel *test;

@property (strong, nonatomic) IBOutlet UILabel *Starttime_lbl;
@property (strong, nonatomic) IBOutlet UILabel *Endtime_lbl;

@property (strong, nonatomic) IBOutlet UIImageView *durationimg;
@property (strong, nonatomic) IBOutlet UILabel *duration_lbl;

@end
