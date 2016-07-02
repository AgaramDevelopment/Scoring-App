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
@end

@interface FollowOn : UIViewController

@property(nonatomic,strong) id <FollowonDelegate> delegate;


@property (nonatomic,strong) NSString * compitionCode;
@property (nonatomic,strong) NSString * matchCode;
@property (nonatomic,strong) NSString * battingTeamName;
@property (nonatomic,strong) NSString * battingTeamCode;
@property (nonatomic,strong) NSString * BowlingTeamCode;




@property (strong, nonatomic) IBOutlet UIView *view_teamName;

@property (strong, nonatomic) IBOutlet UIView *view_striker;

@property (strong, nonatomic) IBOutlet UIView *view_nonStriker;

@property (strong, nonatomic) IBOutlet UIView *view_Bowler;

@property (strong, nonatomic) IBOutlet UIButton *btn_Striker;

@property (strong, nonatomic) IBOutlet UIButton *btn_nonStriker;

@property (strong, nonatomic) IBOutlet UIButton *btn_Bowler;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Striker;

@property (strong, nonatomic) IBOutlet UILabel *lbl_nonStriker;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Bowler;

@property(nonatomic,strong) IBOutlet UITableView *Tbl_Followon;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint * tbl_FollowonYposition;



@end
