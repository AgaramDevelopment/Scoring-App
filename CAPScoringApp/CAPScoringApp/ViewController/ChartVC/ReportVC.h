//
//  ChartVC.h
//  CAPScoringApp
//
//  Created by APPLE on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportVC : UIViewController
@property (nonatomic,strong) IBOutlet UIView * chartList_view;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolllistview;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint * chartviewwidth;

@end
