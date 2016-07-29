//
//  BreakVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BreakTableViewCell.h"
#import "ScorEnginVC.h"

@protocol BreakVCDelagate <NSObject>
@required

- (void) ChangeVCBackBtnAction;

@end
@interface BreakVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tablView;
- (IBAction)addbreak_btn:(id)sender;
@property(nonatomic,strong)NSMutableArray*resultarray;
//@property(nonatomic,strong)NSMutableArray*UpdateBreaksArray;
@property (strong, nonatomic) IBOutlet BreakTableViewCell *GridBreakcell;
- (IBAction)btn_back:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btn_back;


@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSString*INNINGSNO;
@property(strong,nonatomic)NSString*MATCHDATE;
@property(strong,nonatomic)NSString*Duration;
@property(strong,nonatomic) id <BreakVCDelagate> delegate;
- (IBAction)backbtn:(id)sender;

@end
