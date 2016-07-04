//
//  DeclareInnings.h
//  CAPScoringApp
//
//  Created by mac on 27/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeclareInnings : UIViewController


@property (strong,nonatomic) NSString *TEAMNAME;
@property (strong,nonatomic) NSString *OVERNO;
@property (strong,nonatomic) NSString *BALLNO;
@property (strong,nonatomic) NSString *OVERBALLNO;
@property (strong,nonatomic) NSString *TOTALRUN;
@property (strong,nonatomic) NSString *WICKETS;
@property (strong,nonatomic) NSString *OVERSTATUS;


@property (strong,nonatomic) NSString *COMPETITIONCODE;
@property (strong,nonatomic) NSString *MATCHCODE;
@property (strong,nonatomic) NSString *TEAMCODE;
@property (strong,nonatomic) NSString *BOWLINGTEAMCODE;
@property (strong,nonatomic) NSString *INNINGSNO;
@property (strong,nonatomic) NSString *ISDECLARE;



- (IBAction)btn_yes:(id)sender;

-(void) UpdateDeclareInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*)TEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)INNINGSNO:(NSString*)ISDECLARE;

@end
