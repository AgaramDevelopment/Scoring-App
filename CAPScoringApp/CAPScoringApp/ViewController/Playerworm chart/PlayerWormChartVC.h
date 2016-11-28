//
//  PlayerWormChartVC.h
//  CAPScoringApp
//
//  Created by Mac on 26/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerWormChartVC : UIViewController


@property(strong,nonatomic)NSString *matchCode;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSString *compititionCode;

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



@property (weak, nonatomic) IBOutlet UITableView *tableview_batsman;
@property (weak, nonatomic) IBOutlet UIButton *btn_filter_ok;

@property (weak, nonatomic) IBOutlet UIView *view_filter;

@property (weak, nonatomic) IBOutlet UILabel *lbl_filter_batsman_name;
- (IBAction)did_click_filter_batsman:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *view_open_filter;

- (IBAction)did_click_open_filter:(id)sender;

- (IBAction)did_click_filter_ok:(id)sender;

- (IBAction)did_click_close_filter:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *view_filter_batsman;



@end
