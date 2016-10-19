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
#import "ResultMatchCell.h"

@interface FixtureAndResultsVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *matchListview;

@property (nonatomic,strong) IBOutlet UITableView * FixResult_Tbl;

@property (strong, nonatomic) IBOutlet LiveMatchCell * livematchCell;
@property (strong, nonatomic) IBOutlet ResultMatchCell *resultmatchCell;
@property (strong, nonatomic) IBOutlet FixtureTVC *fixtureCell;


@property (nonatomic,strong) IBOutlet UILabel * sepratorlbl;
@property (nonatomic,strong) IBOutlet UIButton * btn_compitionselect;
@property (nonatomic,strong) IBOutlet UILabel * lbl_compition;


@property (nonatomic,strong) IBOutlet NSLayoutConstraint * sepratorYposition;

@property (nonatomic,strong) IBOutlet UIButton * Result_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Live_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Fixture_Btn;

@end
