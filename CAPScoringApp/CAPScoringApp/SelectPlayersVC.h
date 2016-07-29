//
//  SelectPlayersVC.h
//  CAPScoringApp
//
//  Created by APPLE on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMatchSetUpVC.h"


@interface SelectPlayersVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)btn_cancel:(id)sender;
- (IBAction)btn_select:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_select_count;
@property (strong, nonatomic) IBOutlet UITextField *txt_search;

- (IBAction)btn_search:(id)sender;
- (IBAction)btn_back:(id)sender;

@property(strong,nonatomic) NSString *teamA;
@property(strong,nonatomic) NSString *teamB;
@property(strong,nonatomic) NSString *matchType;
@property(strong,nonatomic) NSString *overs;
@property(strong,nonatomic) NSString *ballOver;
@property(strong,nonatomic) NSString *date;
@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *matchVenu;
@property(strong,nonatomic) NSString *month;
@property(strong,nonatomic) NSString *matchCode;
@property(strong,nonatomic) NSString *competitionCode;
@property(strong,nonatomic) NSString *matchTypeCode;
@property(strong,nonatomic) NSString *teamAcode;
@property(strong,nonatomic) NSString *teamBcode;


@property(nonatomic,strong) NSMutableArray *playingXIPlayers;

@property (strong,nonatomic) NSString *SelectTeamCode;

@property(strong,nonatomic) NSString *chooseTeam;
//@property (strong,nonatomic) NSString *matchCode;
@property(assign,nonatomic) BOOL isEdit;





@end
