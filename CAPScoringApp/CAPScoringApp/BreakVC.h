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
@property (strong, nonatomic) IBOutlet BreakTableViewCell *GridBreakcell;



@property(strong,nonatomic)NSString*MATCHCODE;
@property(strong,nonatomic)NSString*COMPETITIONCODE;
@property(strong,nonatomic)NSString*INNINGSNO;
@property(strong,nonatomic)NSString*MATCHDATE;

@property(nonatomic,strong) id <BreakVCDelagate> delegate;
- (IBAction)backbtn:(id)sender;

@end
