//
//  SessionReportVC.h
//  CAPScoringApp
//
//  Created by APPLE on 26/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"

@interface SessionReportVC : UIViewController

@property (nonatomic,strong) NSString * compitioncode;

@property (nonatomic,strong) NSString * matchcode;

@property (nonatomic,strong) IBOutlet SKSTableView * tableView;

@end
