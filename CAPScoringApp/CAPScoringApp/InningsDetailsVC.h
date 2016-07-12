//
//  InningsDetailsVC.h
//  CAPScoringApp
//
//  Created by Stephen on 08/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InningsDetailsVC : UIViewController
@property (strong,nonatomic) NSMutableArray *matchSetUp;
@property (strong, nonatomic) IBOutlet UIView *Team_View;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Team;

@property (strong, nonatomic) IBOutlet UIView *Striker_View;
- (IBAction)btn_Striker:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Striker;


@property (strong, nonatomic) IBOutlet UIView *NonStriker_View;
@property (strong, nonatomic) IBOutlet UILabel *lbl_NonStriker;
- (IBAction)btn_Nonstriker:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *Bowler_tableview;
@property (strong, nonatomic) IBOutlet UITableView *NonStriker_tableview;
@property (strong, nonatomic) IBOutlet UITableView *Striker_tableview;

@property (strong, nonatomic) IBOutlet UIView *Bowler_View;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Bowler;
- (IBAction)btn_Bowler:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Near_btn;
@property (strong, nonatomic) IBOutlet UIButton *Far_btn;
- (IBAction)Finish_btn:(id)sender;

@property(nonatomic,strong)NSString*MATCHCODE;
@property(nonatomic,strong) NSString * CompetitionCode;
@property(nonatomic,strong) NSString * matchTypeCode;
@end
