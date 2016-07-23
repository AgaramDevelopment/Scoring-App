//
//  DBManagerInsertUpdateMatchResult.h
//  CAPScoringApp
//
//  Created by APPLE on 21/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManagerInsertUpdateMatchResult : NSObject
-(BOOL) UpdateCompetitionForInsertMatchResult:(NSString*) MANOFTHESERIESCODE:(NSString*) BESTBATSMANCODE:(NSString*) BESTBOWLERCODE:(NSString*) BESTALLROUNDERCODE:(NSString*) MOSTVALUABLEPLAYERCODE:(NSString*) COMPETITIONCODE;

-(NSString*) GetMatchresultCodeForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BUTTONNAME ;

-(BOOL) UpdateMatchRegistrationForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(BOOL) DeleteMatchResultForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE ;

-(NSString*) GetMatchresultCodeInElseIfForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BUTTONNAME ;

-(BOOL) InsertMatchResultForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS :(NSString*) MANOFTHEMATCHCODE :(NSString*) COMMENTS;

-(BOOL) UpdatematchRegistrationElseifForInsertMatchResult:(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS : COMPETITIONCODE:(NSString*) MATCHCODE ;

-(BOOL) UpdatematchResultForInsertMatchResult:(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS :(NSString*) MANOFTHEMATCHCODE :(NSString*) COMMENTS : COMPETITIONCODE:(NSString*) MATCHCODE ;

-(BOOL) UpdatematchRegistrationinElseForInsertMatchResult:(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS: COMPETITIONCODE:(NSString*) MATCHCODE ;





@end
