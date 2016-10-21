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
- (IBAction)did_click_inn_one:(id)sender;
- (IBAction)did_click_inn_four:(id)sender;
- (IBAction)did_click_inn_two:(id)sender;
- (IBAction)did_click_inn_three:(id)sender;


@end
