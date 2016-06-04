//
//  MatchOfficalsVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 5/27/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMatchSetUpVC.h"

@interface MatchOfficalsVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view_umpire;
@property (strong, nonatomic) IBOutlet UIView *view_umpier1;
@property (strong, nonatomic) IBOutlet UIView *view_umpier2;
@property (strong, nonatomic) IBOutlet UIView *view_matchrefree;
@property (strong, nonatomic) IBOutlet UIView *view_scorer1;
@property (strong, nonatomic) IBOutlet UIView *view_scorer2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_umpire1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_umpire2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_umpire3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_matchreferee;
@property (strong, nonatomic) IBOutlet UILabel *lbl_scorer1;


@property(strong,nonatomic)NSString*Matchcode;
@property(strong,nonatomic)NSString*competitionCode;


- (IBAction)btn_proceed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_scorer2;
@end
