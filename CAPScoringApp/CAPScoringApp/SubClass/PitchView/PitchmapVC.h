//
//  PitchmapViewViewController.h
//  CAPScoringApp
//
//  Created by APPLE on 20/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PitchmapVC : UIViewController


@property(nonatomic,strong) NSString * compititionCode;

@property (nonatomic,strong) NSString * matchCode;

@property (nonatomic,strong) NSString * matchTypecode;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inn1_btnWidth;

@property (nonatomic,strong)  IBOutlet NSLayoutConstraint * inns2_btnWidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns3_btnwidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns4_btnwidth;


@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;









@property (nonatomic,strong) IBOutlet UIView * filter_view;

@property (nonatomic,strong) IBOutlet UIButton * all_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Run1_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Run2_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Run3_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Run4_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Run6_Btn;



@property (nonatomic,strong) IBOutlet UIButton * ball_Btn;

@property (nonatomic,strong) IBOutlet UIButton * dotball_Btn;

@property (nonatomic,strong) IBOutlet UIButton * wicket_Btn;







@property (nonatomic,strong) IBOutlet UIView * striker_view;

@property (nonatomic,strong) IBOutlet UIView * length_View;

@property (nonatomic,strong) IBOutlet UIView * line_Vew;

@property (nonatomic,strong) IBOutlet UILabel * striker_Lbl;

@property (nonatomic,strong) IBOutlet UILabel * length_Lbl;

@property (nonatomic,strong) IBOutlet UILabel * line_lbl;

@property (nonatomic,strong) IBOutlet UIImageView * pitch_Img;

@property (nonatomic,strong) IBOutlet UIButton * allInn_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Inn1_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Inn2_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Inn3_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Inn4_Btn;

@property (nonatomic,strong) IBOutlet UIButton * standard_Btn;

@property (nonatomic,strong) IBOutlet UIButton * statistics_Btn;

@property (nonatomic,strong) IBOutlet UIButton * showFilter_Btn;

@property (nonatomic,strong) IBOutlet UIButton * filter_Btn;

@property (nonatomic,strong) IBOutlet UITableView * striker_Tbl;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * strikerTblYposition;
@property (strong, nonatomic) IBOutlet UIView *show_view;



@end
