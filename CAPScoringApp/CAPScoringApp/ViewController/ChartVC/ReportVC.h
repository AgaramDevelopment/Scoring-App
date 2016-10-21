//
//  ChartVC.h
//  CAPScoringApp
//
//  Created by APPLE on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportVC : UIViewController

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sepratoryposition;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolllistview;


@property (nonatomic, weak) IBOutlet UIView *referencedView;

@property(strong,nonatomic)NSString *matchCode;
@property(strong,nonatomic)NSString *competitionCode;


@end
