//
//  PowerPlayVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/22/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerPlayTVCell.h"
#import "PowerPlayRecord.h"

@interface PowerPlayVC : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txt_startover;
@property (strong, nonatomic) IBOutlet UITextField *txt_endover;

@property (strong, nonatomic) IBOutlet UILabel *lbl_setpowerplay;
@property (strong, nonatomic) IBOutlet UITableView *tbl_powerplaytype;

@property (strong, nonatomic) IBOutlet UIView *view_powerplaytype;


@property (strong, nonatomic) IBOutlet PowerPlayTVCell *powerplay_cel;

@property (strong, nonatomic) IBOutlet UIButton *btn_submit;

@property (strong, nonatomic) IBOutlet UIButton *btn_delete;


- (IBAction)btn_submit:(id)sender;
- (IBAction)btn_delete:(id)sender;
- (IBAction)btn_touch:(id)sender;

@property(nonatomic,strong)PowerPlayRecord *powerplayrecord;

@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;
@property(nonatomic,strong) NSString *inningsNo;
@property(nonatomic,strong) NSString *powerplaystartover;
@property(nonatomic,strong) NSString *powerplayendover;
@property(nonatomic,strong) NSString *powerplaytyp;
@property(nonatomic,strong) NSString *powerplaycode;
@property(nonatomic,strong) NSString *recordstatus;
@property(nonatomic,strong) NSString *userid;
@property(nonatomic,strong) NSString *operationtype;


- (IBAction)btn_back:(id)sender;


@end
