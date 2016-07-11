//
//  TossDetailsVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 26/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorunamentVC.h"
#import "MatchOfficalsVC.h"
@interface TossDetailsVC : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray *matchSetUp;

@property (strong, nonatomic) IBOutlet UIView *view_Wonby;
@property (strong, nonatomic) IBOutlet UITableView *Wonby_table;
@property (strong,nonatomic) IBOutlet  NSLayoutConstraint * wonbyTbl_height;
- (IBAction)Wonbytouch_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Wonby_lbl;


@property (strong, nonatomic) IBOutlet UIView *view_Electedto;
@property (strong, nonatomic) IBOutlet UITableView *electedTo_table;
@property (strong,nonatomic) IBOutlet  NSLayoutConstraint * electedTbl_height;
- (IBAction)electedTo_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *electedTo_lbl;

@property (nonatomic,strong) NSNumber * ISINNINGSREVERT;
@property(nonatomic,assign)NSNumber *STRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *NONSTRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *BOWLERPOSITIONNO;


@property (strong, nonatomic) IBOutlet UIView *view_Striker;
@property (strong, nonatomic) IBOutlet UITableView *Striker_table;
@property (strong,nonatomic) IBOutlet  NSLayoutConstraint * strikerTbl_height;
- (IBAction)Striker_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Striker_lbl;





@property (strong, nonatomic)
IBOutlet UIView *nonStriker;

@property (strong, nonatomic) IBOutlet UITableView *nonStriker_table;
@property (strong,nonatomic) IBOutlet  NSLayoutConstraint * nonStrikerTbl_height;
- (IBAction)nonStriker_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nonStriker_lbl;





@property (strong, nonatomic) IBOutlet UIView *view_Bowler;
@property (strong, nonatomic) IBOutlet UITableView *Bowler_table;
@property (strong,nonatomic) IBOutlet  NSLayoutConstraint * bowlerTbl_height;
- (IBAction)Bowler_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Bowler_lbl;

- (IBAction)Btn_Proceed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *outlet_btn_proceed;
@property(nonatomic,strong)NSString*MATCHCODE;
@property(nonatomic,strong) NSString * CompetitionCode;
@property(nonatomic,strong) NSString * matchTypeCode;

-(IBAction)Back_BtnAction:(id)sender;

@property(nonatomic,strong) IBOutlet UIButton *Btn_Nearend;
@property(nonatomic,strong) IBOutlet UIButton *Btn_FairEnd;


-(void)radiobuttonSelected:(id)sender;
@end
