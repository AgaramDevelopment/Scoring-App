//
//  BreakVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreakTableViewCell.h"

@interface BreakVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tablView;
- (IBAction)addbreak_btn:(id)sender;
@property(nonatomic,strong)NSMutableArray*resultarray;
@property (strong, nonatomic) IBOutlet BreakTableViewCell *GridBreakcell;

- (IBAction)Back_btn:(id)sender;
@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSString*INNINGSNO;
@end
