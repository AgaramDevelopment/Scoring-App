//
//  DBManagerLastBowler.h
//  CAPScoringApp
//
//  Created by APPLE on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerLastBowler : NSObject

+(NSString*) GetBowlerCodeForBowlerDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT;

+(NSString*) GetTopBowlerCodeForBowlerDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT:(NSString*) CURRENTBOWLERCODE;

+(NSNumber*) GetWicketNoForBowlerDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT:(NSString*) PREVIOUSBOWLERCODE;

+(NSNumber*) GetLastBowlerOverNoForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PREVIOUSBOWLERCODE:(NSNumber*) OVERNO;

+(NSNumber*) GetBatTeamOversForOverEvents: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO;

+(NSNumber*) GetBowlerCodeForIsPartialOver:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PREVIOUSBOWLERCODE:(NSNumber*) BATTEAMOVERS;

+(NSNumber*) GetBowlerSpellForBallEvents:(NSNumber*) V_SPELLNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PREVIOUSBOWLERCODE:(NSNumber*) OVERNO;

+(NSMutableArray*) GETTOTALBALLSBOWLMAIDENSBOWLERRUNSForLastBowlDetails: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) PREVIOUSBOWLERCODE :(NSNumber*)  OVERNO;

+(NSNumber*) GetlastBowlerOverballNoForlastBowlDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSNumber*) PREVIOUSBOWLERCODE :(NSNumber*) LASTBOWLEROVERNO ;

+(NSNumber*) GetlastBowlerOverballNoWithExtraForlastBowlDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSNumber*) PREVIOUSBOWLERCODE :(NSNumber*) LASTBOWLEROVERNO ;

+(NSNumber*) GetlastballCountForlastBowlDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSNumber*) PREVIOUSBOWLERCODE :(NSNumber*) LASTBOWLEROVERNO :(NSNumber*) LASTBOWLEROVERBALLNOWITHEXTRAS;

+(NSMutableArray*) GetBallEventForLastBowlerDetails: (NSNumber*)  BOWLERSPELL :(NSNumber*)  BOWLERRUNS :(NSNumber*)  ISPARTIALOVER :(NSNumber*)  TOTALBALLSBOWL : (NSNumber*) MAIDENS :(NSNumber*)  WICKETS:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) INNINGSNO: (NSNumber*) PREVIOUSBOWLERCODE: (NSNumber*) OVERNO:(NSNumber *)LASTBOWLEROVERBALLNO;

@end
