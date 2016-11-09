//
//  BowlingKPIVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 01/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BowlingKPITVC.h"

@interface BowlingKPIVC : UIViewController

@property(nonatomic,strong) NSString * compititionCode;
@property (nonatomic,strong) NSString * matchCode;
@property (nonatomic,strong) NSString * matchTypeCode;
@property (nonatomic,strong) NSString * teamCode;

@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;

@property (strong, nonatomic) IBOutlet UITableView *tbl_details;


@property (strong, nonatomic) IBOutlet BowlingKPITVC *bowlingKPIcell;


@property (strong, nonatomic) IBOutlet UIButton *inns_one;
@property (strong, nonatomic) IBOutlet UIButton *inns_two;
@property (strong, nonatomic) IBOutlet UIButton *inns_three;
@property (strong, nonatomic) IBOutlet UIButton *inns_four;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_two_width;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inns_one_width;

- (IBAction)btn_first_inns:(id)sender;
- (IBAction)btn_sec_inns:(id)sender;
- (IBAction)btn_third_inns:(id)sender;
- (IBAction)btn_fourth_inns:(id)sender;

@end
