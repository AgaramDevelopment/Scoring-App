//
//  ChanceTeamVCViewController.h
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanceTeamVC : UIViewController
@property(nonatomic,strong) NSString * compitionCode;
@property(nonatomic,strong) NSString * MatchCode;


@property(nonatomic,strong) IBOutlet UILabel *lbl_SelectTeamName;
@property(nonatomic,strong) IBOutlet UILabel *lbl_ChangeInnings;
@property(nonatomic,strong) IBOutlet UILabel *lbl_StrikerName;
@property(nonatomic,strong) IBOutlet UILabel *lbl_NonStrikerName;
@property(nonatomic,strong) IBOutlet UILabel *lbl_BowlerName;
@property(nonatomic,strong) IBOutlet UIView * view_striker;
@property(nonatomic,strong) IBOutlet UIView * view_nonstriker;
@property(nonatomic,strong) IBOutlet UIView * view_Bowler;
@property(nonatomic,strong) IBOutlet UIView * view_SelectTeamName;
@property(nonatomic,strong) IBOutlet UIView * view_ChangeInnings;
@property(nonatomic,strong) IBOutlet UITableView * tbl_strikerlist;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *tbl_yposition;


@end
