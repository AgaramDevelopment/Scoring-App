//
//  FollowOn.h
//  CAPScoringApp
//
//  Created by mac on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FollowonDelegate <NSObject>
@required
- (void) RedirectFollowOnPage;
- (void) ChangeVCBackBtnAction;
@end

@interface FollowOn : UIViewController

@property(nonatomic,strong) id <FollowonDelegate> delegate;


@property (nonatomic,strong) NSString * compitionCode;
@property (nonatomic,strong) NSString * matchCode;
@property (nonatomic,strong) NSString * battingTeamName;
@property (nonatomic,strong) NSString * battingTeamCode;
@property (nonatomic,strong) NSString * BowlingTeamCode;
@property (nonatomic,strong) NSString * bowlingPlayercode;
@property (nonatomic,strong) NSString * strickerCode;
@property (nonatomic,strong) NSString * nonStrickerCode;
@property (nonatomic,strong) NSString * inningsno;
@property (nonatomic,assign) NSString * inningsStatus;
@property (nonatomic,strong) NSMutableArray *objBowlingTeamdetail;

@property (nonatomic,strong) NSString *strikerName;
@property (nonatomic,strong) NSString * nonStrikerName;
@property (nonatomic,strong) NSString *bowlerName;
@property (nonatomic,strong) NSString *Revertstrikercode;
@property (nonatomic,strong) NSString *RevertnonStrikercode;
@property (nonatomic,strong) NSString *Revertbowlercode;


@property (nonatomic,strong) NSNumber * ISINNINGSREVERT;
@property(nonatomic,assign)NSNumber *STRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *NONSTRIKERPOSITIONNO;
@property(nonatomic,assign)NSNumber *BOWLERPOSITIONNO;

@property(strong,nonatomic)NSString *TEAMCODE;
@property(strong,nonatomic)NSString *TEAMNAME;

@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString * OVERNO;
@property(strong,nonatomic)NSString * BALLNO;
@property(strong,nonatomic)NSString * OVERBALLNO;
@property(strong,nonatomic)NSString * TOTALRUN;
@property(strong,nonatomic)NSString * WICKETS;
@property(strong,nonatomic)NSString * OVERSTATUS;
@property(strong,nonatomic)NSString * BOWLINGTEAMCODE;
@property(strong,nonatomic)NSNumber *INNINGSSCORECARD;


@property (strong, nonatomic) IBOutlet UIView *view_teamName;

@property (strong, nonatomic) IBOutlet UIView *view_striker;

@property (strong, nonatomic) IBOutlet UIView *view_nonStriker;

@property (strong, nonatomic) IBOutlet UIView *view_Bowler;

@property (strong, nonatomic) IBOutlet UIButton *btn_Striker;

@property (strong, nonatomic) IBOutlet UIButton *btn_nonStriker;

@property (strong, nonatomic) IBOutlet UIButton *btn_Bowler;

@property (strong, nonatomic) IBOutlet UIButton *btn_Proceed;

@property (strong, nonatomic) IBOutlet UIButton *btn_Revert;

@property (nonatomic,strong) IBOutlet UILabel *lbl_Teamname;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Striker;

@property (strong, nonatomic) IBOutlet UILabel *lbl_nonStriker;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Bowler;

@property(nonatomic,strong) IBOutlet UITableView *Tbl_Followon;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint * tbl_FollowonYposition;



@end
