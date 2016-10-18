//
//  FixtureAndResultsVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 17/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveMatchCell.h"
#import "ResultMatchCell.h"
#import "FixtureTVC.h"

@interface FixtureAndResultsVC : UIViewController

@property (nonatomic,strong) IBOutlet UITableView * FixResult_Tbl;

@property (strong, nonatomic) IBOutlet LiveMatchCell * livematchCell;
@property (strong, nonatomic) IBOutlet ResultMatchCell *resultmatchCell;
@property (strong, nonatomic) IBOutlet FixtureTVC *fixtureCell;


@end
