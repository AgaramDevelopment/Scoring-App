//
//  EditModeVC.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditModeVC : UIViewController

@property (nonatomic,strong) NSString *Comptitioncode;
@property (nonatomic,strong) NSString *matchCode;
@property (nonatomic,strong) NSString *inningsNo;
@property (nonatomic,strong) NSString *matchTypeCode;



@property(nonatomic,strong) IBOutlet UILabel * selectbtnhighlight;

@property(nonatomic,strong) IBOutlet UIButton *Btn_innings1team1;
@property(nonatomic,strong) IBOutlet UIButton *Btn_innings1team2;
@property(nonatomic,strong) IBOutlet UIButton *Btn_inning2steam1;
@property(nonatomic,strong) IBOutlet UIButton *Btn_innings2team2;
@property (nonatomic,strong) IBOutlet UITableView * tbl_innnings;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inningsviewWidth;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint * highlightbtnxposition;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint * btn_innings1Widthposition;


@property(nonatomic,strong) IBOutlet NSLayoutConstraint * btn_innings2xposition;



@end
