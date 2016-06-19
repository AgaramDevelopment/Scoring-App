//
//  PenalityVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/16/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PenalityTVC.h"

//@protocol penalityDelegate <NSObject>
//- (void)RightSideEditBtnAction;
//
//@end

@interface PenalityVC : UIViewController

//@property (nonatomic, weak) id <penalityDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *txt_penalityruns;
@property (strong, nonatomic) IBOutlet UIView *view_batting;
@property (strong, nonatomic) IBOutlet UIView *view_bowling;
@property (strong, nonatomic) IBOutlet UIButton *btn_batting;
@property (strong, nonatomic) IBOutlet UIButton *btn_bowling;
@property (strong, nonatomic) IBOutlet UIView *view_penalityreason;
@property (strong, nonatomic) IBOutlet UIButton *btn_touch;
@property (strong, nonatomic) IBOutlet UIButton *btn_submitpenality;
@property (strong, nonatomic) IBOutlet UITableView *tbl_penality;

- (IBAction)btn_batting:(id)sender;
- (IBAction)btn_bowling:(id)sender;
- (IBAction)btn_touch:(id)sender;
- (IBAction)btn_submitpenality:(id)sender;

@property(nonatomic,strong) NSString *metadatatypecode;

@property (strong, nonatomic) IBOutlet PenalityTVC *penality_cell;
@property (strong, nonatomic) IBOutlet UILabel *lbl_penaltytype;

@property(nonatomic,strong) NSString *matchcode;
@property(nonatomic,strong) NSString *competitioncode;
@property(nonatomic,strong) NSString *inningsno;
@property(nonatomic,strong) NSString *metasubcode;
@property (nonatomic,strong)NSDictionary *test;
@property(nonatomic,strong) NSDictionary *sample;

@end
