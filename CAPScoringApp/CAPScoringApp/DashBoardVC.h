//
//  DashBoardVC.h
//  CAPScoringApp
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *view_syn_data;
@property (weak, nonatomic) IBOutlet UIView *view_new_Match;
@property (weak, nonatomic) IBOutlet UIView *view_archives;
@property (weak, nonatomic) IBOutlet UIView *view_reports;

@property (weak, nonatomic) IBOutlet UIImageView *img_synData;

@property (weak, nonatomic) IBOutlet UIImageView *img_newMatch;

@property (weak, nonatomic) IBOutlet UIImageView *img_archives;


@property (weak, nonatomic) IBOutlet UIImageView *img_reports;


- (IBAction)btn_syn_Data:(id)sender;
- (IBAction)btn_new_Match:(id)sender;
- (IBAction)btn_archives:(id)sender;
- (IBAction)btn_reports:(id)sender;

@end
