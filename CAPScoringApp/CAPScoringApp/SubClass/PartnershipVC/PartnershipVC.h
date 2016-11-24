//
//  PartnershipVC.h
//  CAPScoringApp
//
//  Created by APPLE on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnershipVC : UIViewController

@property (nonatomic,strong) NSString * matchcode;

@property (nonatomic,strong) NSString * compitioncode;

@property (nonatomic,strong) NSString * matchtypecode;

@property (nonatomic,strong) NSString * teamcode;

@property (nonatomic,strong) IBOutlet UITableView * PShip_tbl;

@property (nonatomic,strong) IBOutlet UIButton * innings1_Btn;

@property (nonatomic,strong) IBOutlet UIButton * innings2_Btn;

@property (nonatomic,strong) IBOutlet UIButton * innings3_Btn;

@property (nonatomic,strong) IBOutlet UIButton * innings4_Btn;

@property(strong,nonatomic)NSString *fstInnShortName;
@property(strong,nonatomic)NSString *secInnShortName;
@property(strong,nonatomic)NSString *thrdInnShortName;
@property(strong,nonatomic)NSString *frthInnShortName;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inn1_btnWidth;

@property (nonatomic,strong)  IBOutlet NSLayoutConstraint * inns2_btnWidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns3_btnwidth;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint * inns4_btnwidth;



@end
