//
//  EndSessionRecords.h
//  CAPScoringApp
//
//  Created by deepak on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EndSessionRecords : NSObject


@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *BATTINGTEAMNAME;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMNAME;
@property(strong,nonatomic)NSString *METASUBCODE;
@property(strong,nonatomic)NSString *METADESCRIPTION;


@property(strong,nonatomic)NSString *SESSIONSTARTTIME;
@property(strong,nonatomic)NSString *SESSIONENDTIME;
@property(strong,nonatomic)NSNumber *INNINGSNO;
@property(strong,nonatomic)NSString *TEAMNAME;
@property(strong,nonatomic)NSString *SHORTTEAMNAME;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *TOTALWICKETS;
@property(strong,nonatomic)NSString *DOMINANTNAME;
@property(strong,nonatomic)NSString *STARTOVER;
@property(strong,nonatomic)NSString *ENDOVER;
@property(strong,nonatomic)NSString *SESSIONOVER;
@property(strong,nonatomic)NSString *DURATION;


@property(nonatomic,assign)NSNumber *INNINGSNOS;
@property(nonatomic,retain)NSNumber *SESSIONNO;
@property(nonatomic,assign)NSNumber *STARTOVERNO;

@property(nonatomic,assign)NSNumber *NEWSTARTOVERNO;
@property(nonatomic,assign)NSNumber *STARTBALLNO;
@property(nonatomic,assign)NSNumber *ENDOVERNO;
@property(nonatomic,assign)NSNumber *ENDBALLNO;
@property(nonatomic,assign)NSNumber *STARTOVERBALLNO;
@property(nonatomic,assign)NSNumber *ENDOVERBALLNO;
@property(nonatomic,assign)NSNumber *RUNSSCORED;
@property(strong,nonatomic)NSString *WICKETLOST;
@property(strong,nonatomic)NSString *TEAMNAMES;
@property(strong,nonatomic)NSString *OVERSTATUS;
@property(strong,nonatomic)NSString *PENALITYRUNS;
@property(strong,nonatomic)NSString *DAYNO;
@property(strong,nonatomic)NSString *ISCHECKDAYNIGHT;

@property(strong,nonatomic)NSString *COMPETITIONCODE;

@property(strong,nonatomic)NSString *MATCHCODE;




@property(strong,nonatomic)NSString *STARTTIME;
@property(strong,nonatomic)NSString *ENDTIME;

@property(strong,nonatomic)NSString *OVERBALLNO;
@property(strong,nonatomic)NSString *MATCHTYPE;
@property(strong,nonatomic)NSString *WICKETS;
@property(strong,nonatomic)NSString *RUNS;
@property(strong,nonatomic)NSString *OVERNO;
@property(strong,nonatomic)NSString *BALLNO;

@property(strong,nonatomic)NSString *OVERSPLAYED;
@property(strong,nonatomic)NSDate *CHECKSTARTDATE;




@property(strong,nonatomic)NSMutableArray *GetBattingTeamDetails;
@property(strong,nonatomic)NSMutableArray *GetSessionEventDetails;
@property(strong,nonatomic)NSMutableArray *getSessionArray;
@property(strong,nonatomic)NSMutableArray *GetDateDayWiseDetails;
@property(strong,nonatomic)NSMutableArray *getBattingTeamUsingBowlingCode;
@property(strong,nonatomic)NSMutableArray *getMetaSubCode;



-(void) FetchEndSession:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)INNINGSNO :(NSString*)BATTINGTEAMCODE :(NSString*)BOWLINGTEAMCODE;

-(void) InsertEndSession:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)DAYNO:(NSString*)SESSIONNO :(NSString *)SESSIONSTARTTIME:(NSString*)SESSIONENDTIME :(NSString*)STARTOVER:(NSString*)ENDOVER:(NSString*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString*)DOMINANTTEAMCODE;

-(void) UpdateEndSession:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSNumber*)INNINGSNO:(NSString*)DAYNO:(NSString*)SESSIONNO :(NSString *)SESSIONSTARTTIME:(NSString*)SESSIONENDTIME: (NSString*)DOMINANTTEAMCODE : (NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE :(NSString*)DAYNO;

-(void) DeleteEndSession:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)DAYNO:(NSString*)sesaksionNo;

@end
