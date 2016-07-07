//
//  PowerPlayGridVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/25/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerPlayGridTVC.h"
#import "PowerPlayRecord.h"

@interface PowerPlayGridVC : UIViewController

@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;
@property(nonatomic,strong) NSString *inningsNo;

@property(nonatomic,strong) NSMutableArray *resultarray;

- (IBAction)btn_addppowerplay:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tbl_powerplay;

@property(nonatomic,strong)PowerPlayRecord *powerplayrecord;
//@property (strong, nonatomic) IBOutlet PowerPlayGridTVC *POWERPLAY_CELL;
@property (strong, nonatomic) IBOutlet PowerPlayGridTVC *powerplay_cell;

@property(nonatomic,strong) NSString *powerplaystartover;
@property(nonatomic,strong) NSString *powerplayendover;
@property(nonatomic,strong) NSString *powerplaytyp;

@end
