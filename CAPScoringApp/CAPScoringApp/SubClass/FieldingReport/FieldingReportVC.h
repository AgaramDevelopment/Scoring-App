//
//  FieldingReportVC.h
//  CAPScoringApp
//
//  Created by APPLE on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldingReportVC : UIViewController

@property (strong,nonatomic) NSString * compitionCode;

@property (strong,nonatomic) NSString * matchCode;

@property (strong,nonatomic) NSString * matchTypeCode;

@property (strong,nonatomic) NSString * Teamcode;

@property (strong,nonatomic) NSString * fstInnShortName;

@property (strong,nonatomic) NSString * secInnShortName;

@property (strong,nonatomic) NSString * thrdInnShortName;

@property (strong,nonatomic) NSString * frthInnShortName;




@property (nonatomic,strong) IBOutlet UIButton * Inn1_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Inn2_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Inn3_Btn;

@property (nonatomic,strong) IBOutlet UIButton * Inn4_Btn;



@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inn1_btnWidth;

@property (nonatomic,strong)  IBOutlet NSLayoutConstraint * inns2_btnWidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns3_btnwidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns4_btnwidth;



@property (strong, nonatomic) IBOutlet UIView * hide_btn_view;

@property (nonatomic,strong) IBOutlet UIView * filter_view;

@property (nonatomic,strong) IBOutlet UIView * striker_view;

@property (nonatomic,strong) IBOutlet UIButton * innings1_Btn;

@property (nonatomic,strong) IBOutlet UIButton * innings2_Btn;

@property (nonatomic,strong) IBOutlet UIButton * innings3_Btn;

@property (nonatomic,strong) IBOutlet UIButton * innings4_Btn;

@property (nonatomic,strong) IBOutlet UITableView * striker_Tbl;

@property (nonatomic,strong) IBOutlet UILabel * striker_Lbl;

@property (nonatomic,strong)  UIView * detail_View;

@property (nonatomic,strong) IBOutlet UILabel * FielderName_lbl;


@end
