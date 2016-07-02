//
//  FollowOn.h
//  CAPScoringApp
//
//  Created by mac on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowOn : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view_teamName;

@property (strong, nonatomic) IBOutlet UIView *view_striker;

@property (strong, nonatomic) IBOutlet UIView *view_nonStriker;

@property (strong, nonatomic) IBOutlet UIView *view_Bowler;

@property (strong, nonatomic) IBOutlet UIButton *btn_Striker;

@property (strong, nonatomic) IBOutlet UIButton *btn_nonStriker;

@property (strong, nonatomic) IBOutlet UIButton *btn_Bowler;

@property (strong, nonatomic) IBOutlet UILabel *lbl_nonStriker;
@end
