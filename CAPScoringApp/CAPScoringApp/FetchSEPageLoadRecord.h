//
//  FetchSEPageLoadRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 11/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FetchSEPageLoadRecord : NSObject


@property(strong,nonatomic)NSString *INNINGSPROGRESS;
@property(strong,nonatomic)NSString *TEAMACODE;
@property(strong,nonatomic)NSString *TEAMBCODE;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *INNINGSSTATUS;
@property(strong,nonatomic)NSString *SESSIONNO;
@property(strong,nonatomic)NSString *DAYNO;
@property(strong,nonatomic)NSString *BATTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BOWLTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BATTEAMNAME;
@property(strong,nonatomic)NSString *BOWLTEAMNAME;
@property(strong,nonatomic)NSString *MATCHOVERS;
@property(strong,nonatomic)NSString *BATTEAMLOGO;
@property(strong,nonatomic)NSString *BOWLTEAMLOGO;
@property(strong,nonatomic)NSString *MATCHTYPE;
@property(strong,nonatomic)NSString *ISOTHERSMATCHTYPE;



@property(strong,nonatomic)NSNumber *T_TARGETRUNS;
@property(strong,nonatomic)NSNumber *T_TARGETOVERS;



@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *TEAMAWICKETKEEPER;
@property(strong,nonatomic)NSString *TEAMBWICKETKEEPER;
@property(strong,nonatomic)NSString *TEAMACAPTAIN;
@property(strong,nonatomic)NSString *TEAMBCAPTAIN;
@property(strong,nonatomic)NSString *ISDEFAULTORLASTINSTANCE;
@property(nonatomic,strong)NSMutableArray *teamAndoverArray;






@property(strong,nonatomic)NSString *BOWLTYPECODE;
@property(strong,nonatomic)NSString *BOWLTYPE;
@property(strong,nonatomic)NSString *METASUBCODEDESCRIPTION;
@property(strong,nonatomic)NSString *METASUBCODE;


@property(strong,nonatomic)NSString *SHOTCODE;
@property(strong,nonatomic)NSString *SHOTNAME;
@property(strong,nonatomic)NSString *SHOTTYPE;


//@property(nonatomic,strong)NSString *teamAcode;
//@property(nonatomic,strong)NSString *teamBcode;


@property(strong,nonatomic)NSString *TEAMCODE;

-(void) fetchSEPageLoadDetails :(NSString*) COMPETITIONCODE :(NSString *)MATCHCODE;

@end
