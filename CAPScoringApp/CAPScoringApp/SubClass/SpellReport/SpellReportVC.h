//
//  SpellReportVC.h
//  CAPScoringApp
//
//  Created by APPLE on 19/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "SpellReportCell.h"
@interface SpellReportVC : UIViewController


@property (strong,nonatomic) IBOutlet SpellReportCell * spellReport;

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

@property (nonatomic,strong) IBOutlet SKSTableView * spellReport_Tbl;


@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inn1_btnWidth;

@property (nonatomic,strong)  IBOutlet NSLayoutConstraint * inns2_btnWidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns3_btnwidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns4_btnwidth;





@end
