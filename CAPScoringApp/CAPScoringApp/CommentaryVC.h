//
//  CommentaryVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 20/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentaryTVC.h"

@interface CommentaryVC : UIViewController
@property (strong, nonatomic) IBOutlet CommentaryTVC *commentry_tvc;
@property (strong, nonatomic) IBOutlet UITableView *commentary_tableview;
@property(strong,nonatomic)NSString *matchCode;
@property(strong,nonatomic)NSString *matchTypeCode;

@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;

- (IBAction)did_click_inn_one:(id)sender;
- (IBAction)did_click_inn_four:(id)sender;
- (IBAction)did_click_inn_two:(id)sender;
- (IBAction)did_click_inn_three:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *inns_one;

@property (strong, nonatomic) IBOutlet UIButton *inns_four;
@property (strong, nonatomic) IBOutlet UIButton *inns_three;
@property (strong, nonatomic) IBOutlet UIButton *inns_two;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_two_width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_one_width;

@end
