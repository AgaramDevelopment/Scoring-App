//
//  PenaltygridVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/18/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PenaltyGridTVC.h"
#import "PenalityVC.h"
@interface PenaltygridVC : UIViewController

@property (strong, nonatomic) IBOutlet PenaltyGridTVC *penalty_gridCell;

@property (strong, nonatomic) IBOutlet UITableView *tbl_penaltyrecord;

@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;
@property(nonatomic,strong) NSString *inningsNo;
@property(nonatomic,strong) NSMutableArray *resultarray;
@property(nonatomic,strong)NSMutableArray *penaltyDetailsRecord;

- (IBAction)btn_addpenalty:(id)sender;
- (IBAction)btn_back:(id)sender;




@end
