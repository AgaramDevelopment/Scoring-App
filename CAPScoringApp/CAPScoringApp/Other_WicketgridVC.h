//
//  Other_WicketgridVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/2/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Other_WicketgridTVC.h"
#import "Other_WicketVC.h"

@interface Other_WicketgridVC : UIViewController
@property (strong, nonatomic) IBOutlet Other_WicketgridTVC *Other_WicketCell;
@property (strong, nonatomic) IBOutlet UITableView *tbl_otherwicketgrid;
@property (strong, nonatomic) IBOutlet UIButton *btn_addotherwickets;
- (IBAction)btn_addotherwickets:(id)sender;
@property (strong, nonatomic)NSMutableArray* GetWicketEventsPlayerDetails;
@property (strong, nonatomic)NSMutableArray* GetPlayerDetails;


@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSNumber*INNINGSNO;

@property(strong,nonatomic)NSString*TEAMCODE;
@property(strong,nonatomic)NSString*STRIKERCODE;
@property(strong,nonatomic)NSString*NONSTRIKERCODE;

@property(nonatomic,strong)NSString *MAXOVER;
@property(nonatomic,strong)NSString *MAXBALL;
@property(nonatomic,strong)NSString *BALLCODE;
@property(nonatomic,strong)NSString *BALLCOUNT;
@property(nonatomic,strong)NSNumber *MAXID;
@property(nonatomic,strong)NSNumber *N_WICKETNO;
@property(nonatomic,strong)NSString *N_WICKETTYPE;
@property(nonatomic,strong)NSNumber *N_FIELDERCODE;
@property(nonatomic,strong)NSNumber *BATTINGPOSITIONNO;







//@property (strong, nonatomic)NSMutableArray* GetWicketDetails;
@end
