//
//  SessionReportCell.h
//  CAPScoringApp
//
//  Created by APPLE on 28/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionReportCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel * sessionno;

@property (nonatomic,strong) IBOutlet UILabel * BattingTeam;

@property (nonatomic,strong) IBOutlet UILabel * overs;

@property (nonatomic,strong) IBOutlet UILabel * Run;

@property (nonatomic,strong) IBOutlet UILabel * WKT;

@property (nonatomic,strong) IBOutlet UILabel * Run4s;

@property (nonatomic,strong) IBOutlet UILabel * Run6s;

@property (nonatomic,strong) IBOutlet UILabel * RunRate;

@property (nonatomic,strong) IBOutlet UILabel * BDRY;




@end
