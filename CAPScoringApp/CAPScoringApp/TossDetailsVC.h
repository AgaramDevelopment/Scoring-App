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



@property (strong, nonatomic) IBOutlet UIView *view_Wonby;
@property (strong, nonatomic) IBOutlet UITableView *Wonby_table;
- (IBAction)Wonbytouch_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Wonby_lbl;


@property (strong, nonatomic) IBOutlet UIView *view_Electedto;
@property (strong, nonatomic) IBOutlet UITableView *electedTo_table;
- (IBAction)electedTo_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *electedTo_lbl;




@property (strong, nonatomic) IBOutlet UIView *view_Striker;
@property (strong, nonatomic) IBOutlet UITableView *Striker_table;
- (IBAction)Striker_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Striker_lbl;





@property (strong, nonatomic)
IBOutlet UIView *nonStriker;

@property (strong, nonatomic) IBOutlet UITableView *nonStriker_table;
- (IBAction)nonStriker_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nonStriker_lbl;





@property (strong, nonatomic) IBOutlet UIView *view_Bowler;
@property (strong, nonatomic) IBOutlet UITableView *Bowler_table;
- (IBAction)Bowler_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *Bowler_lbl;

- (IBAction)Btn_Proceed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *outlet_btn_proceed;
@property(nonatomic,strong)NSString*MATCHCODE;
@property(nonatomic,strong) NSString * CompetitionCode;

-(IBAction)Back_BtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *radiobutton1;

//@property(strong, nonatomic) UIButton *radiobutton1;
//@property(strong, nonatomic) UIButton *radiobutton2;
@property (strong, nonatomic) IBOutlet UIButton *radiobutton2;
-(void)radiobuttonSelected:(id)sender;
@end
