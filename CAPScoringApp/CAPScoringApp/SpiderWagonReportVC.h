//
//  SpiderWagonReportVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 22/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpiderWagonReportVC : UIViewController

- (IBAction)btn_first_inns:(id)sender;

- (IBAction)btn_sec_inns:(id)sender;

- (IBAction)btn_third_inns:(id)sender;

- (IBAction)btn_fourth_inns:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *img_wagon;
@property (strong, nonatomic) IBOutlet UIView *filter_view;

@end
