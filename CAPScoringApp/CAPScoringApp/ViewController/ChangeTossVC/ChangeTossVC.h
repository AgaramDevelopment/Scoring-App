//
//  ChanceTossVC.h
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChangeTossDelegate <NSObject>
@required
- (void) RedirectScorEngin;
- (void) ChangeVCBackBtnAction;
@end


@interface ChangeTossVC : UIViewController

@property(nonatomic,strong) id <ChangeTossDelegate> delegate;

@property(nonatomic,strong)NSString *CompitisonCode;
@property(nonatomic,strong)NSString *matchCode;


@property (nonatomic,strong) NSNumber * ISINNINGSREVERT;
@property(nonatomic,assign)NSNumber *STRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *NONSTRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *BOWLERPOSITIONNO;

@property(nonatomic,strong) IBOutlet UILabel *lbl_Tosswon;
@property (nonatomic,strong) IBOutlet UILabel *lbl_ElectedTo;
@property (nonatomic,strong) IBOutlet UILabel *lbl_Stricker;
@property(nonatomic,strong) IBOutlet UILabel * lbl_NonStricker;
@property(nonatomic,strong) IBOutlet UILabel * lbl_Bowler;
@property(nonatomic,strong) IBOutlet UITableView *Tbl_toss;

@property(nonatomic,strong) IBOutlet UIView *view_TossWon;
@property(nonatomic,strong) IBOutlet UIView *view_ElectedTo;
@property(nonatomic,strong) IBOutlet UIView *view_Stricker;
@property(nonatomic,strong) IBOutlet UIView *view_NonStricker;
@property(nonatomic,strong) IBOutlet UIView *view_Bowler;

@property(nonatomic,strong) IBOutlet UIButton *Btn_Nearend;
@property(nonatomic,strong) IBOutlet UIButton *Btn_FairEnd;


@property(nonatomic,strong) IBOutlet NSLayoutConstraint * tbl_tossYposition;


@end
