//
//  ScoreCardVC.h
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreCardCellTVCell.h"

@interface ScoreCardVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbl_scorecard;
@property (strong, nonatomic) IBOutlet ScoreCardCellTVCell *batsmanCell;

@property (strong, nonatomic) IBOutlet ScoreCardCellTVCell *batsManHeaderCell;

@property(strong,nonatomic) NSString *competitionCode;
@property(strong,nonatomic) NSString *matchCode;

@property(strong,nonatomic) NSString *inningsNo;

@end
