//
//  DBManagerEndBall.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerEndBall.h"
#import "UpdateScoreEngineRecord.h"
#import "UpdateScoreEngine.h"
#import "PushSyncDBMANAGER.h"
#import "Utitliy.h"

@implementation DBManagerEndBall

@synthesize BATTINGTEAMCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize BATTEAMSHORTNAME;
@synthesize BOWLTEAMSHORTNAME;
@synthesize BATTEAMNAME;
@synthesize BOWLTEAMNAME;
@synthesize MATCHOVERS;
@synthesize BATTEAMLOGO;
@synthesize BOWLTEAMLOGO;
@synthesize MATCHTYPE;
@synthesize OLDISLEGALBALL;
@synthesize OLDBOWLERCODE;
@synthesize OLDSTRIKERCODE;
@synthesize OLDNONSTRIKERCODE;


//SP_UPDATESCOREBOARD

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

//Copy database to application document
- (void) copyDatabaseIfNotExist{
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
    
    //NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {//If file not exist
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLITE_FILE_NAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


-(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}





//DBManager.h
//UpdateScoreCard
//DBManager.M
//UpdateScoreCard


-(NSMutableArray*) SELECTALLUPSC :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) BALLCODE
{
    
    
    NSMutableArray *GetDataArrayUpdateScoreEngine=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STRIKERCODE, BOWLERCODE, ISLEGALBALL, OVERNO, BALLNO, RUNS, OVERTHROW, ISFOUR, ISSIX , WIDE, NOBALL, BYES, LEGBYES, PENALTY FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND	MATCHCODE = '%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UpdateScoreEngine *record=[[UpdateScoreEngine alloc]init];
                
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.ISLEGALBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                record.BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.OVERTHROW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.ISFOUR=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                record.ISSIX=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.WIDE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.NOBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.BYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                record.LEGBYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.PENALTY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                
                [GetDataArrayUpdateScoreEngine addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return GetDataArrayUpdateScoreEngine;
}





-(BOOL)  UPDATEBATTINGSUMMARYUPSC : (NSNumber*)F_WIDE: (NSNumber *) F_BYES : (NSNumber*)F_LEGBYES: (NSNumber*)F_RUNS: (NSNumber*) F_OVERTHROW :(NSNumber*)F_ISFOUR:(NSNumber*)F_ISSIX:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*) F_STRIKERCODE{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET RUNS = CASE WHEN ('%@' = 0 AND '%@' = 0 AND '%@' = 0) THEN (RUNS - ('%@' + '%@')) ELSE (RUNS - '%@') END,BALLS = CASE WHEN %@ = 0 THEN (BALLS - 1) ELSE BALLS END,ONES = CASE WHEN ('%@' + '%@' = 1) AND ('%@' = 0 AND '%@' = 0 AND '%@' = 0) THEN (ONES - 1) ELSE ONES END,TWOS = CASE WHEN ('%@' + '%@' = 2) AND ('%@' = 0 AND '%@' = 0 AND '%@' = 0) THEN (TWOS - 1) ELSE TWOS END,THREES = CASE WHEN ('%@' + '%@' = 3) AND ('%@' = 0 AND '%@' = 0 AND '%@' = 0) THEN (THREES - 1) ELSE THREES END,FOURS = CASE WHEN ('%@' = 1 AND '%@' = 0 AND '%@' = 0 AND '%@' = 0) THEN (FOURS - 1) ELSE FOURS END,SIXES = CASE WHEN ('%@' = 1 AND '%@' = 0 AND '%@' = 0 AND '%@' = 0) THEN (SIXES - 1) ELSE SIXES END,DOTBALLS = CASE WHEN (%@ = 0 AND %@ = 0) THEN (DOTBALLS - 1) ELSE DOTBALLS END  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@'",F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_OVERTHROW,F_RUNS,F_WIDE,F_RUNS,F_OVERTHROW,F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_OVERTHROW,F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_OVERTHROW,F_WIDE,F_BYES,F_LEGBYES,F_ISFOUR,F_WIDE,F_BYES,F_LEGBYES,F_ISSIX,F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_WIDE, COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,F_STRIKERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                NSString *updateSQLForOnline = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET RUNS = CASE WHEN (%@ = 0 AND %@ = 0 AND %@ = 0) THEN (RUNS - (%@ + %@)) ELSE (RUNS - %@) END,BALLS = CASE WHEN %@ = 0 THEN (BALLS - 1) ELSE BALLS END,ONES = CASE WHEN (%@ + %@ = 1) AND (%@ = 0 AND %@ = 0 AND %@ = 0) THEN (ONES - 1) ELSE ONES END,TWOS = CASE WHEN (%@ + %@ = 2) AND (%@ = 0 AND %@ = 0 AND %@ = 0) THEN (TWOS - 1) ELSE TWOS END,THREES = CASE WHEN (%@ + %@ = 3) AND (%@ = 0 AND %@ = 0 AND %@ = 0) THEN (THREES - 1) ELSE THREES END,FOURS = CASE WHEN (%@ = 1 AND %@ = 0 AND %@ = 0 AND %@ = 0) THEN (FOURS - 1) ELSE FOURS END,SIXES = CASE WHEN (%@ = 1 AND %@ = 0 AND %@ = 0 AND %@ = 0) THEN (SIXES - 1) ELSE SIXES END,DOTBALLS = CASE WHEN (%@ = 0 AND %@ = 0) THEN (DOTBALLS - 1) ELSE DOTBALLS END  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@'",F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_OVERTHROW,F_RUNS,F_WIDE,F_RUNS,F_OVERTHROW,F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_OVERTHROW,F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_OVERTHROW,F_WIDE,F_BYES,F_LEGBYES,F_ISFOUR,F_WIDE,F_BYES,F_LEGBYES,F_ISSIX,F_WIDE,F_BYES,F_LEGBYES,F_RUNS,F_WIDE, COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,F_STRIKERCODE];
                
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC251" :updateSQLForOnline];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(BOOL)  UPDATEBATTINGSUMBYINNUPSC : (NSNumber*) O_RUNS: (NSNumber*) N_RUNS: (NSNumber*)F_OVERS: (NSNumber *)F_BALLS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETSCORE = WICKETSCORE - ('%@' - '%@')	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND ((WICKETOVERNO || '.' || WICKETBALLNO) >= (%@ || '.' || %@))",O_RUNS,N_RUNS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,F_OVERS,F_BALLS];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                
                NSString *updateSQLForOnline = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETSCORE = WICKETSCORE - (%@ - %@)	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND ((cast(WICKETOVERNO as varchar))+ '.' +(cast(WICKETBALLNO as varchar)))  >= ((cast(%@ as varchar)) +'.'+ (cast(%@ AS varchar)))",O_RUNS,N_RUNS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,F_OVERS,F_BALLS];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC251" :updateSQLForOnline];
                
//                
//                UPDATE BATTINGSUMMARY SET WICKETSCORE = WICKETSCORE - (4 - 0)	WHERE COMPETITIONCODE = 'UCC0000001' AND MATCHCODE = 'IMSC024B8975AA55AB900123' AND BATTINGTEAMCODE = 'TEA0000073'	AND INNINGSNO = 2 AND ((cast(WICKETOVERNO as varchar))+ '.' +(cast(WICKETBALLNO as varchar)))  >= ((cast(%@ as varchar)) +'.'+ (cast(%@ AS varchar)))
                
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
        }
        
        sqlite3_close(dataBase);
        
    }
    return NO;
}


-(BOOL) UPDATEINNINGSSUMMARYUPSC : (NSNumber*) F_NOBALL: (NSNumber*) F_BYES:(NSNumber*)F_NOBALL:(NSNumber*)F_LEGBYES:(NSNumber*) F_WIDE: (NSNumber*)F_PENALTY:(NSNumber*)F_RUNS: (NSNumber*)F_OVERTHROW:(NSNumber*)F_ISWICKET:(NSNumber*)F_WICKETTYPE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET BYES = BYES - (CASE WHEN %@ > 0 AND %@ > 0 THEN 0 ELSE '%@' END),LEGBYES = LEGBYES - (CASE WHEN %@ > 0 AND %@ > 0 THEN 0 ELSE '%@' END),NOBALLS = NOBALLS - (CASE	WHEN %@ > 0 AND '%@' > 0 THEN '%@' + '%@' WHEN '%@' > 0 AND '%@' > 0 THEN %@ + '%@' ELSE '%@' END),WIDES = WIDES - (CASE WHEN %@ > 0 THEN '%@' ELSE '%@' END),PENALTIES = PENALTIES - %@, INNINGSTOTAL = INNINGSTOTAL - (%@ + (CASE WHEN %@ > 0 OR %@ > 0 OR %@ > 0 THEN 0 ELSE '%@' END) + %@ + %@ + %@ + %@ + %@),INNINGSTOTALWICKETS = CASE WHEN (%@ = 1 AND '%@' <> 'MSC102') OR (%@ = 0 AND '%@' IN ('MSC107', 'MSC108', 'MSC133')) THEN (INNINGSTOTALWICKETS - 1) ELSE INNINGSTOTALWICKETS END WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@'",F_NOBALL,F_BYES,F_BYES,F_NOBALL,F_LEGBYES,F_LEGBYES,F_NOBALL,F_BYES,F_NOBALL,F_BYES,F_NOBALL,F_LEGBYES,F_NOBALL,F_LEGBYES,F_NOBALL,F_WIDE,F_WIDE,F_WIDE,F_PENALTY,F_RUNS,F_BYES,F_LEGBYES,F_WIDE,F_OVERTHROW,F_BYES,F_LEGBYES,F_NOBALL,F_WIDE,F_PENALTY,F_ISWICKET,F_WICKETTYPE,F_ISWICKET,F_WICKETTYPE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                 NSString *updateSQLForOnline = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET BYES = BYES - (CASE WHEN %@ > 0 AND %@ > 0 THEN 0 ELSE %@ END),LEGBYES = LEGBYES - (CASE WHEN %@ > 0 AND %@ > 0 THEN 0 ELSE %@ END),NOBALLS = NOBALLS - (CASE	WHEN %@ > 0 AND %@ > 0 THEN %@ + %@ WHEN %@ > 0 AND %@ > 0 THEN %@ + %@ ELSE %@  END),WIDES = WIDES - (CASE WHEN %@ > 0 THEN %@ ELSE %@ END),PENALTIES = PENALTIES - %@, INNINGSTOTAL = INNINGSTOTAL - (%@ + (CASE WHEN %@ > 0 OR %@ > 0 OR %@ > 0 THEN 0 ELSE %@ END) + %@ + %@ + %@ + %@ + %@),INNINGSTOTALWICKETS = CASE WHEN (%@ = 1 AND '%@' <> 'MSC102') OR (%@ = 0 AND '%@' IN ('MSC107', 'MSC108', 'MSC133')) THEN (INNINGSTOTALWICKETS - 1) ELSE INNINGSTOTALWICKETS END WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@'",F_NOBALL,F_BYES,F_BYES,F_NOBALL,F_LEGBYES,F_LEGBYES,F_NOBALL,F_BYES,F_NOBALL,F_BYES,F_NOBALL,F_LEGBYES,F_NOBALL,F_LEGBYES,F_NOBALL,F_WIDE,F_WIDE,F_WIDE,F_PENALTY,F_RUNS,F_BYES,F_LEGBYES,F_WIDE,F_OVERTHROW,F_BYES,F_LEGBYES,F_NOBALL,F_WIDE,F_PENALTY,F_ISWICKET,F_WICKETTYPE,F_ISWICKET,F_WICKETTYPE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSSUMMARY" :@"MSC251" :updateSQLForOnline];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}





-(NSMutableArray*) SELECTINNBOWLEROVERSUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BOWLINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*) BOWLERCODE
{
    
    
    NSMutableArray *GetDataArrayUpdateScoreEngine=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERS, BALLS, PARTIALOVERBALLS, RUNS, WICKETS, MAIDENS, NOBALLS, WIDES, DOTBALLS, FOURS, SIXES FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UpdateScoreEngine *record=[[UpdateScoreEngine alloc]init];
                
                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.PARTIALOVERBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.MAIDENS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                record.DOTBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                
                [GetDataArrayUpdateScoreEngine addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    return GetDataArrayUpdateScoreEngine;
}




-(NSString*) GETISOVERCOMPLETE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*) F_OVERS
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@' AND INNINGSNO= '%@' AND OVERNO= '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,F_OVERS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"0";
    
}

-(NSString*) GETBALLCOUNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BOWLERCODE) AS BOWLERCOUNT FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
    
}

-(NSString*) ISBALLEXISTS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT (CASE WHEN COUNT(BALLCODE) > 1 THEN 1 ELSE 0 END) AS BALLCODECOUNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
    
}


-(NSString*) BALLCOUNTUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)OVERSNO
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) BALLCOUNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *ballCount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return ballCount;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
    
}




-(NSString*) SMAIDENOVER : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO :(NSString*)  F_OVERS :(NSString*) BALLCODE
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN (IFNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END  AS SMAIDENOVER FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,F_OVERS,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
    
}


-(BOOL)  GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  OVERS{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERS FROM BOWLINGMAIDENSUMMARY WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@'	AND INNINGSNO= '%@'	AND OVERS= '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(BOOL) DELBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO :(NSString*)  OVERS{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGMAIDENSUMMARY WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@'	AND INNINGSNO= '%@'	AND OVERS= '%@'	",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGMAIDENSUMMARY" :@"MSC252" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return NO;
}


-(BOOL)   INSERTBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO : (NSString*) BOWLERCODE:(NSString*)  F_OVERS{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY(COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,OVERS)VALUES('%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,F_OVERS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGMAIDENSUMMARY" :@"MSC250" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}


-(BOOL) UPDATEBOWLINGSUMMARY : (NSString*) U_BOWLEROVERS :(NSString*) U_BOWLERBALLS : (NSString*) U_BOWLERPARTIALOVERBALLS :(NSString*) U_BOWLERMAIDENS :(NSString*) U_BOWLERRUNS :(NSString*) U_BOWLERWICKETS :(NSString*) U_BOWLERNOBALLS :(NSString*) U_BOWLERWIDES :(NSString*) U_BOWLERDOTBALLS :(NSString*) U_BOWLERFOURS :(NSString*) U_BOWLERSIXES :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSString*) BOWLINGTEAMCODE:(NSNumber*)  F_BOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = '%@',BALLS = '%@',PARTIALOVERBALLS = '%@',MAIDENS = '%@',RUNS = '%@',WICKETS = '%@',	NOBALLS = '%@',WIDES = '%@',DOTBALLS = '%@',FOURS = '%@',SIXES = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",U_BOWLEROVERS,U_BOWLERBALLS,U_BOWLERPARTIALOVERBALLS,U_BOWLERMAIDENS,U_BOWLERRUNS,U_BOWLERWICKETS,U_BOWLERNOBALLS,U_BOWLERWIDES,U_BOWLERDOTBALLS,U_BOWLERFOURS,U_BOWLERSIXES,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,F_BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}




-(NSString*) WICKETNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*)  WICKETPLAYER
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETNO FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"0";
    
}



-(BOOL)   UPDATEBATTINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSString*) WICKETPLAYER{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = NULL,WICKETTYPE = NULL,FIELDERCODE = NULL,BOWLERCODE = NULL,WICKETOVERNO = NULL,WICKETBALLNO = NULL 	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(BOOL)   UPDATEBATTINGSUMMARYO_WICNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSString*) O_WICKETNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = WICKETNO - 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND WICKETNO > '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BATTINGTEAMCODE,INNINGSNO,O_WICKETNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(NSString*) BOWLEROVERBALLCNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSNumber*)  OVERNO:(NSString*) F_BOWLERCODE
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALLCODE) AS BOWLEROVERBALLCNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1 AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,F_BOWLERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return 0;
    
}



-(BOOL)  GETBOWLERCODE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:  (NSString*) BATTINGTEAMCODE:(NSNumber*)  INNINGSNO :(NSNumber*)  OVERNO:(NSString*) BOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE FROM BOWLEROVERDETAILS WHERE	COMPETITIONCODE = '%@' AND MATCHCODE =	'%@' AND TEAMCODE =	'%@'AND	INNINGSNO =	'%@' AND OVERNO	= '%@' AND BOWLERCODE =	'%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
    }
    return NO;
}


-(BOOL)   INSERTBOWLEROVERDETAILS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSNumber*) OVERNO :(NSString*) BOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLEROVERDETAILS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,STARTTIME,ENDTIME) VALUES('%@','%@','%@','%@','%@','%@',GETDATE(),NULL",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BOWLERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLEROVERDETAILS" :@"MSC250" :updateSQL];
                
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(BOOL)   PARTIALUPDATEBOWLINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) BOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = CASE WHEN OVERS > 0 THEN (OVERS - 1) ELSE OVERS END,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS + (CASE WHEN @BOWLEROVERBALLCNT > 0 THEN  CASE WHEN @F_ISLEGALBALL = 0 THEN (@BOWLEROVERBALLCNT)  ELSE (@BOWLEROVERBALLCNT - 1)  END ELSE 0 END) WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}




//UpdateScoreEngine
-(NSMutableArray*) GetDataFromUpdateScoreEngine: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE
{
    
    
    NSMutableArray *GetDataArrayUpdateScoreEngine=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISLEGALBALL, BOWLERCODE,STRIKERCODE,NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND   MATCHCODE  = '%@' AND TEAMCODE = '%@' AND INNINGSNO  =	'%@' AND BALLCODE  = '%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UpdateScoreEngineRecord *record=[[UpdateScoreEngineRecord alloc]init];
                record.OLDISLEGALBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.OLDBOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.OLDSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.OLDNONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [GetDataArrayUpdateScoreEngine addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    return GetDataArrayUpdateScoreEngine;
}


-(NSMutableArray*) getBowlingTeamCode: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE
{
    
    
    NSMutableArray *getBowlingCodeArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT (CASE WHEN TEAMACODE = '%@' THEN TEAMBCODE ELSE TEAMACODE END) AS BOWLINGTEAMCODE , MATCHOVERS FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",TEAMCODE,COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UpdateScoreEngineRecord *record=[[UpdateScoreEngineRecord alloc]init];
                record.BOWLINGTEAMCODE =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHOVER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [getBowlingCodeArray addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    return getBowlingCodeArray;
}




-(NSString*) GetBowlingTeamCodeUpdateScoreEngine : (NSNumber*) COMPETITIONCODE: (NSNumber*) MATCHCODE:(NSNumber*) BATTINGTEAMCODE:(NSNumber*) MATCHOVERS

{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE = '%@'THEN TEAMBCODE ELSE TEAMACODE END), '%@' = MATCHOVERS FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",BATTINGTEAMCODE,MATCHOVERS,COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}


-(NSString*) GetWicCountUpdateScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString *) TEAMCODE : (NSNumber *) INNINGSNO :(NSString*) BALLCODE

{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS  F_ISWICKETCOUNTABLE FROM WICKETEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@'	AND ISWICKET = 1 AND WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}



-(NSString*) GetISWicCountUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE

{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS  F_ISWICKET FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}


-(NSString*) GetWicTypeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE

{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS  WICKETTYPE FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}


-(BOOL)  GetBallCodeExistsUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' 	",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}




-(BOOL)   UpdateWicEventsUpdateScoreEngine  : (NSString*) WICKETTYPE:(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT:(NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETTYPE = '%@' ,WICKETPLAYER = '%@',FIELDINGPLAYER = '%@',WICKETEVENT  = '%@' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'  AND BALLCODE='%@'",WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER,WICKETEVENT,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"WICKETEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}






-(NSString*)  GetBallCodeExistsUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(WKT.WICKETNO),0) + 1  FROM WICKETEVENTS WKT WHERE WKT.COMPETITIONCODE= '%@'	AND WKT.MATCHCODE= '%@'	AND WKT.TEAMCODE= '%@'	AND WKT.INNINGSNO= '%@'	",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}


-(BOOL)   InsertWicEventsUpdateScoreEngine :  (NSString*) WICKETNO: (NSString*) BALLCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO:(NSNumber*) ISWICKET:(NSString*) WICKETTYPE :(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO WICKETEVENTS (BALLCODE,COMPETITIONCODE,	MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER,VIDEOLOCATION,WICKETEVENT)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','','%@')",BALLCODE, COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER,WICKETEVENT];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"WICKETEVENTS" :@"MSC250" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}


-(NSString*)  GetWicPlayersUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETPLAYER FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@' AND BALLCODE = '%@' AND ISWICKET = 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}


-(NSString*)  GetWicketNoUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETNO AS WICKETNOS  FROM WICKETEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@' AND BALLCODE = '%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}




-(NSString*)  GetBallCodeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}



-(BOOL)   UpdateWicketEveUpdateScoreEngine :  (NSNumber*) WICKETNO: (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETNO = WICKETNO - 1 WHERE WICKETNO > %@ AND BALLCODE IN  (SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@')", WICKETNO, COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"WICKETEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(BOOL) UpdateBattingOrderUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO

{
    
    NSMutableArray *battingSummaryArray = [[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BS.COMPETITIONCODE, BS.MATCHCODE, BS.BATTINGTEAMCODE, BS.INNINGSNO, BS.BATSMANCODE, BS.RUNS, BS.BALLS, BS.ONES, BS.TWOS, BS.THREES, BS.FOURS, BS.SIXES, BS.DOTBALLS, BS.WICKETNO, BS.WICKETTYPE, BS.FIELDERCODE, BS.BOWLERCODE, BS.WICKETOVERNO, BS.WICKETBALLNO, BS.WICKETSCORE,(SELECT COUNT(1) FROM(SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME UNION SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME) SAMSUB WHERE SAMSUB.MATCHCODE = SAM.MATCHCODE AND SAMSUB.INNINGSNO = SAM.INNINGSNO AND SAMSUB.OVERBALL<= SAM.OVERBALL) BATTINGPOSITIONNO FROM(SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = %@ GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME UNION SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = %@ GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME) SAM INNER JOIN BATTINGSUMMARY BS ON SAM.MATCHCODE = BS.MATCHCODE AND SAM.INNINGSNO = BS.INNINGSNO AND SAM.STRIKERCODE = BS.BATSMANCODE", MATCHCODE,TEAMCODE,INNINGSNO, MATCHCODE,TEAMCODE,INNINGSNO,MATCHCODE,TEAMCODE,INNINGSNO,MATCHCODE,TEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BattingSummaryRecord *record = [[BattingSummaryRecord alloc]init];
                
                record.COMPETITIONCODE = [self getValueByNull: statement:0];
                record.MATCHCODE = [self getValueByNull: statement:1];
                record.BATTINGTEAMCODE = [self getValueByNull: statement:2];
                record.INNINGSNO = [self getValueByNull: statement:3];
                record.BATSMANCODE = [self getValueByNull: statement:4];
                record.RUNS = [self getValueByNull: statement:5];
                record.BALLS = [self getValueByNull: statement:6];
                record.ONES = [self getValueByNull: statement:7];
                record.TWOS = [self getValueByNull: statement:8];
                record.THREES = [self getValueByNull: statement:9];
                record.FOURS = [self getValueByNull: statement:10];
                record.SIXES = [self getValueByNull: statement:11];
                record.DOTBALLS = [self getValueByNull: statement:12];
                record.WICKETNO = [self getValueByNull: statement:13];
                record.WICKETTYPE = [self getValueByNull: statement:14];
                record.FIELDERCODE = [self getValueByNull: statement:15];
                record.BOWLERCODE = [self getValueByNull: statement:16];
                record.WICKETOVERNO = [self getValueByNull: statement:17];
                record.WICKETBALLNO = [self getValueByNull: statement:18];
                record.WICKETSCORE = [self getValueByNull: statement:19];
                record.BATTINGPOSITIONNO = [self getValueByNull: statement:20];
                
                [battingSummaryArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BATTINGSUMMARY WHERE MATCHCODE = '%@' AND BATTINGTEAMCODE =	'%@' AND INNINGSNO = '%@' ", MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            //Deleted
            
            PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
            [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC252" :updateSQL];
            
        }else{
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
    }
    
    
    for(int i =0;i<battingSummaryArray.count;i++){
        
        BattingSummaryRecord *record = [battingSummaryArray objectAtIndex:i];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *error = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[record.WICKETNO isEqualToString:@""]?@"NULL" : record.WICKETNO,[record.WICKETTYPE isEqualToString:@""]?@"NULL" : record.WICKETTYPE,[record.FIELDERCODE isEqualToString:@""]?@"NULL" : record.FIELDERCODE ,[record.BOWLERCODE isEqualToString:@""]?@"NULL" : record.BOWLERCODE ,[record.WICKETOVERNO isEqualToString:@""]?@"NULL" : record.WICKETOVERNO,[record.WICKETBALLNO isEqualToString:@""]?@"NULL" : record.WICKETBALLNO,[record.WICKETSCORE isEqualToString:@""]?@"NULL" : record.WICKETSCORE];
            
            NSString *Noerror = [NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@'",[record.WICKETNO isEqualToString:@""]?@"NULL" : record.WICKETNO,[record.WICKETTYPE isEqualToString:@""]?@"NULL" : record.WICKETTYPE,[record.FIELDERCODE isEqualToString:@""]?@"NULL" : record.FIELDERCODE ,[record.BOWLERCODE isEqualToString:@""]?@"NULL" : record.BOWLERCODE ,[record.WICKETOVERNO isEqualToString:@""]?@"NULL" : record.WICKETOVERNO,[record.WICKETBALLNO isEqualToString:@""]?@"NULL" : record.WICKETBALLNO,[record.WICKETSCORE isEqualToString:@""]?@"NULL" : record.WICKETSCORE];
            
            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY (COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTINGPOSITIONNO,BATSMANCODE,RUNS,BALLS,ONES,TWOS,THREES,FOURS,SIXES,DOTBALLS,WICKETNO,WICKETTYPE,FIELDERCODE,BOWLERCODE,WICKETOVERNO,WICKETBALLNO,WICKETSCORE) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%@)", record.COMPETITIONCODE,record.MATCHCODE,record.BATTINGTEAMCODE,record.INNINGSNO,record.BATTINGPOSITIONNO,record.BATSMANCODE,record.RUNS,record.BALLS,record.ONES,record.TWOS,record.THREES,record.FOURS,record.SIXES,record.DOTBALLS, [record.WICKETNO isEqualToString:@""] ? error : Noerror];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC250" :updateSQL];
                //ADDED
            }else{
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
            }
        }
        
        
    }
    
    return  YES;
}


-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}







-(BOOL)  UpdateBowlingOrderUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE :(NSString*) BATTINGTEAMCODE: (NSString*)INNINGSNO

{
    
    NSMutableArray *bowlingSummaryArray = [[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BS.COMPETITIONCODE, BS.MATCHCODE, BS.BOWLINGTEAMCODE, BS.INNINGSNO, BS.BOWLERCODE, BS.OVERS, BS.BALLS, BS.PARTIALOVERBALLS, BS.MAIDENS, BS.RUNS, BS.WICKETS, BS.NOBALLS, BS.WIDES, BS.DOTBALLS, BS.FOURS, BS.SIXES, (SELECT COUNT(1) FROM (SELECT BE.COMPETITIONCODE, BE.MATCHCODE, BE.INNINGSNO, BE.BOWLERCODE, MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) FIRSTBALL FROM BALLEVENTS BE WHERE BE.MATCHCODE = '%@' AND BE.TEAMCODE = '%@' AND BE.INNINGSNO = %@ GROUP BY BE.COMPETITIONCODE, BE.MATCHCODE, BE.INNINGSNO, BE.BOWLERCODE) BEV WHERE BEV.MATCHCODE = BE.MATCHCODE AND BEV.INNINGSNO = BE.INNINGSNO AND BEV.FIRSTBALL <= BE.FIRSTBALL) BOWLINGPOSITIONNO FROM (SELECT BE.COMPETITIONCODE, BE.MATCHCODE, BE.INNINGSNO, BE.BOWLERCODE, MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) FIRSTBALL FROM BALLEVENTS BE WHERE BE.MATCHCODE = '%@' AND BE.TEAMCODE = '%@' AND BE.INNINGSNO = %@ GROUP BY BE.COMPETITIONCODE, BE.MATCHCODE, BE.INNINGSNO, BE.BOWLERCODE) BE INNER JOIN BOWLINGSUMMARY BS ON BE.MATCHCODE = BS.MATCHCODE AND BE.INNINGSNO = BS.INNINGSNO AND BE.BOWLERCODE = BS.BOWLERCODE;", MATCHCODE,BATTINGTEAMCODE, INNINGSNO,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlingSummaryRecord *record = [[BowlingSummaryRecord alloc]init];
                
                record.COMPETITIONCODE = [self getValueByNull: statement:0];
                record.MATCHCODE = [self getValueByNull: statement:1];
                record.BOWLINGTEAMCODE = [self getValueByNull: statement:2];
                record.INNINGSNO = [self getValueByNull: statement:3];
                record.BOWLERCODE = [self getValueByNull: statement:4];
                record.OVERS = [self getValueByNull: statement:5];
                record.BALLS = [self getValueByNull: statement:6];
                record.PARTIALOVERBALLS = [self getValueByNull: statement:7];
                record.MAIDENS = [self getValueByNull: statement:8];
                record.RUNS = [self getValueByNull: statement:9];
                record.WICKETS = [self getValueByNull: statement:10];
                record.NOBALLS = [self getValueByNull: statement:11];
                record.WIDES = [self getValueByNull: statement:12];
                record.DOTBALLS = [self getValueByNull: statement:13];
                record.FOURS = [self getValueByNull: statement:14];
                record.SIXES = [self getValueByNull: statement:15];
                record.BOWLINGPOSITIONNO = [self getValueByNull: statement:16];
                
                [bowlingSummaryArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGSUMMARY WHERE MATCHCODE = '%@' AND BOWLINGTEAMCODE =	'%@' AND INNINGSNO = '%@' ", MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            //Deleted
            PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
            [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC252" :updateSQL];
            
        }else{
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
    }
    
    
    for(int i =0;i<bowlingSummaryArray.count;i++){
        
        BowlingSummaryRecord *record = [bowlingSummaryArray objectAtIndex:i];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGSUMMARY (COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,BOWLERCODE,OVERS,BALLS,PARTIALOVERBALLS,MAIDENS,RUNS,WICKETS,NOBALLS,WIDES,DOTBALLS,FOURS,SIXES,BOWLINGPOSITIONNO) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", record.COMPETITIONCODE,record.MATCHCODE,record.BOWLINGTEAMCODE,record.INNINGSNO,record.BOWLERCODE,record.OVERS,record.BALLS,record.PARTIALOVERBALLS,record.MAIDENS,record.RUNS,record.WICKETS,record.NOBALLS,record.WIDES,record.DOTBALLS,record.FOURS,record.SIXES,record.BOWLINGPOSITIONNO];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC250" :updateSQL];
                
                //ADDED
            }else{
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
            }
        }
        
    }
    
    return  YES;
    
    
    
}







-(BOOL)  DeleteRemoveUnusedBatFBSUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE IN (SELECT BS.BATSMANCODE FROM BATTINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE AND BS.BATTINGTEAMCODE = BE.TEAMCODE AND BS.INNINGSNO = BE.INNINGSNO AND (BS.BATSMANCODE = BE.STRIKERCODE OR BS.BATSMANCODE = BE.NONSTRIKERCODE) WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@' AND BS.BATTINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@' AND BE.STRIKERCODE IS NULL)",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC252" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(BOOL)  DeleteRemoveUnusedBowFBSUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*)INNINGSNO : (NSString*) BOWLINGTEAMCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE IN(SELECT BS.BOWLERCODE FROM BOWLINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE	AND BS.INNINGSNO = BE.INNINGSNO AND BS.BOWLERCODE = BE.BOWLERCODE WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@'	AND BS.BOWLINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@' AND BE.BOWLERCODE IS NULL)" ,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC252" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(BOOL)DeleteWicket : (NSString*) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) TEAMCODE :(NSString*)INNINGSNO :(NSString*)BALLCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM WICKETEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE= '%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"WICKETEVENTS" :@"MSC252" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}


-(BOOL)  getInningNo : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT INNINGSNO FROM INNINGSSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
    }
    return NO;
}

-(BOOL)  UpdateInningsSummary : (NSString*) PENALTYRUNS:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*)INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET PENALTIES = PENALTIES + '%@', INNINGSTOTAL = INNINGSTOTAL + '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",PENALTYRUNS,PENALTYRUNS,  COMPETITIONCODE, MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSSUMMARY" :@"MSC251" :updateSQL];
                
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}




//PENALTY

-(BOOL)  GetPenaltyBallCodeUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSString*) BALLCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =	'%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
    }
    return NO;
}



-(BOOL)  UpdatePenaltyScoreEngine : (NSString*)AWARDEDTOTEAMCODE : (NSString*)PENALTYRUNS: (NSString*)PENALTYTYPECODE: (NSString*) PENALTYREASONCODE : (NSString*)COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BALLCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PENALTYDETAILS SET AWARDEDTOTEAMCODE = '%@',PENALTYRUNS = '%@', PENALTYTYPECODE = '%@', PENALTYREASONCODE = '%@' WHERE COMPETITIONCODE = '%@'AND MATCHCODE = '%@' AND INNINGSNO = '%@'AND BALLCODE = '%@'",AWARDEDTOTEAMCODE,PENALTYRUNS,(PENALTYTYPECODE == nil || [PENALTYTYPECODE isEqualToString:@"(null)"]) ?@"":PENALTYTYPECODE,PENALTYREASONCODE,COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"PENALTYDETAILS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(NSString*)  GetMaxidUpdateScoreEngine{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(SUBSTR(PENALTYCODE,4,7)),0)+1 AS MAXID FROM PENALTYDETAILS"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}

-(BOOL)  InsertPenaltyScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE :(NSString*) PENALTYCODE : (NSString *) AWARDEDTOTEAMCODE : (NSString *) PENALTYRUNS : (NSString *) PENALTYTYPECODE : (NSString *) PENALTYREASONCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO PENALTYDETAILS (COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE, (PENALTYCODE == nil ||[PENALTYCODE isEqualToString:@"(null)"] )?@"": PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,  (PENALTYTYPECODE == nil ||[PENALTYTYPECODE isEqualToString:@"(null)"] )?@"": PENALTYTYPECODE,PENALTYREASONCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"PENALTYDETAILS" :@"MSC250" :updateSQL];
                
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(BOOL)  UpdateBallPlusoneScoreEngine :(NSString*) BALLCNT: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO:(NSString*)OVERNO:(NSString*) BALLCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLCOUNT = '%@' + BALLCOUNT WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE  = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' AND OVERNO  =	'%@' AND BALLNO = '%@' + 1",BALLCNT, COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}


-(BOOL)  UpdateBallMinusoneScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) INNINGSNO:(NSString*) OVERNO :(NSString*) BALLNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO - 1 WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO  =	'%@' AND BALLNO > '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(BOOL)  LegalBallByOverNoUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) INNINGSNO : (NSString*)OVERNO : (NSString*)BALLNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 WHERE COMPETITIONCODE =	'%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO =	'%@' AND BALLNO > '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(BOOL)  LegalBallByOverNoUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) INNINGSNO : (NSString*)OVERNO : (NSString*)BALLNO : (NSString *) BALLCOUNT

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1, BALLCOUNT = BALLCOUNT - '%@' WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE  =	'%@' AND   TEAMCODE =	'%@' AND   INNINGSNO =	'%@' AND   OVERNO    =	'%@' AND   BALLNO =	'%@' AND	  BALLCOUNT >   '%@'",BALLCOUNT,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}



-(BOOL)  LegalBallCountUpdateScoreEngine : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 , BALLCOUNT = BALLCOUNT - '%@'	WHERE COMPETITIONCODE = '%@' AND MATCHCODE =	'%@' AND TEAMCODE =	'%@' AND INNINGSNO  =	'%@' AND   OVERNO  =	'%@' AND   BALLNO			= '%@' AND BALLCOUNT > '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}


-(NSString*)  LastBallCodeUPSE  :(NSString*) MATCHCODE:(NSNumber*) INNINGSNO{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BE WHERE (BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) = (SELECT MAX((BALL.OVERNO || '.' || BALL.BALLNO) || BALL.BALLCOUNT) FROM BALLEVENTS BALL WHERE BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@') AND BE.MATCHCODE = '%@' AND BE.INNINGSNO = '%@'",MATCHCODE,INNINGSNO,MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
    
}

-(NSString*)  OverStatusUPSE : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE:(NSNumber*) INNINGSNO : (NSString*) OVERNO {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL((OVERSTATUS),0) FROM OVEREVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND INNINGSNO='%@' 	AND OVERNO ='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
    
}


-(BOOL)  InningEveUpdateScoreEngine : (NSString*) T_STRIKERCODE: (NSString*) T_NONSTRIKERCODE: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE: (NSString *) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS	SET CURRENTSTRIKERCODE = '%@' ,CURRENTNONSTRIKERCODE = '%@',	CURRENTBOWLERCODE = CURRENTBOWLERCODE WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' 	AND TEAMCODE = '%@'	AND INNINGSNO = '%@'",T_STRIKERCODE,T_NONSTRIKERCODE, COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}




-(BOOL)  BallCodeUPSE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, OLDBOWLERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
    }
    return NO;
}







-(BOOL)  DeleteOverDetailsUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, OLDBOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLEROVERDETAILS" :@"MSC252" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}


-(NSString*) OtherOverBallcntUPSE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO {
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK){
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS OtheroverBallcnt FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
    
}

-(NSString*)  OtherBowlerUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK){
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE as OtherBowler FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND BOWLERCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, BOWLERCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"0";
}

-(NSString*) IsMaidenOverUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK){
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN (IFNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END AS IsMaidenOver	FROM BALLEVENTS	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"0";
    
}


-(NSString*) IsOverCompleteUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK){
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS 	WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' 	AND INNINGSNO='%@'	AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isDayNight;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    
    return @"0";
    
}

-(BOOL)  BowMadienSummUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) BOWLERCODE :(NSString*) OVERNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY(COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,OVERS)VALUES('%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE, OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGMAIDENSUMMARY" :@"MSC250" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(BOOL)  BowSummaryOverplusoneUPSE : (NSString*) OTHERBOWLEROVERBALLCNT : (NSString*) BOWLERMAIDEN : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = OVERS + 1,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS - '%@',MAIDENS = MAIDENS + '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",OTHERBOWLEROVERBALLCNT,BOWLERMAIDEN,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(BOOL)  BowSummaryUPSE : (NSString*)OTHERBOWLEROVERBALLCNT: (NSString*)U_BOWLERMAIDENS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = OVERS,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS - '%@',MAIDENS = MAIDENS + '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",OTHERBOWLEROVERBALLCNT,U_BOWLERMAIDENS,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}

-(BOOL)  UPDATEWICKETOVERNOUPSE : (NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO

{
    
    NSMutableArray *battingSummaryArray = [[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BS.COMPETITIONCODE, BS.MATCHCODE, BS.BATTINGTEAMCODE, BS.INNINGSNO, BS.BATSMANCODE, BS.RUNS, BS.BALLS, BS.ONES, BS.TWOS, BS.THREES, BS.FOURS, BS.SIXES, BS.DOTBALLS, BS.WICKETNO, BS.WICKETTYPE, BS.FIELDERCODE, BS.BOWLERCODE, BS.WICKETOVERNO, BS.WICKETBALLNO, BS.WICKETSCORE,(SELECT COUNT(1) FROM(SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME UNION SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME) SAMSUB WHERE SAMSUB.MATCHCODE = SAM.MATCHCODE AND SAMSUB.INNINGSNO = SAM.INNINGSNO AND SAMSUB.OVERBALL<= SAM.OVERBALL) BATTINGPOSITIONNO FROM(SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = %@ GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME UNION SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE, (MIN(BE.OVERNO || '.' || BE.BALLNO || BE.BALLCOUNT) - 0.01) OVERBALL FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = %@ GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME) SAM INNER JOIN BATTINGSUMMARY BS ON SAM.MATCHCODE = BS.MATCHCODE AND SAM.INNINGSNO = BS.INNINGSNO AND SAM.STRIKERCODE = BS.BATSMANCODE", MATCHCODE,TEAMCODE,INNINGSNO, MATCHCODE,TEAMCODE,INNINGSNO,MATCHCODE,TEAMCODE,INNINGSNO,MATCHCODE,TEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BattingSummaryRecord *record = [[BattingSummaryRecord alloc]init];
                
                record.COMPETITIONCODE = [self getValueByNull: statement:0];
                record.MATCHCODE = [self getValueByNull: statement:1];
                record.BATTINGTEAMCODE = [self getValueByNull: statement:2];
                record.INNINGSNO = [self getValueByNull: statement:3];
                record.BATSMANCODE = [self getValueByNull: statement:4];
                record.RUNS = [self getValueByNull: statement:5];
                record.BALLS = [self getValueByNull: statement:6];
                record.ONES = [self getValueByNull: statement:7];
                record.TWOS = [self getValueByNull: statement:8];
                record.THREES = [self getValueByNull: statement:9];
                record.FOURS = [self getValueByNull: statement:10];
                record.SIXES = [self getValueByNull: statement:11];
                record.DOTBALLS = [self getValueByNull: statement:12];
                record.WICKETNO = [self getValueByNull: statement:13];
                record.WICKETTYPE = [self getValueByNull: statement:14];
                record.FIELDERCODE = [self getValueByNull: statement:15];
                record.BOWLERCODE = [self getValueByNull: statement:16];
                record.WICKETOVERNO = [self getValueByNull: statement:17];
                record.WICKETBALLNO = [self getValueByNull: statement:18];
                record.WICKETSCORE = [self getValueByNull: statement:19];
                record.BATTINGPOSITIONNO = [self getValueByNull: statement:20];
                
                [battingSummaryArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BATTINGSUMMARY WHERE MATCHCODE = '%@' AND BATTINGTEAMCODE =	'%@' AND INNINGSNO = '%@' ", MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            //Deleted
            PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
            [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC252" :updateSQL];
        }else{
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
    }
    
    
    
    for(int i =0;i<battingSummaryArray.count;i++){
        
        BattingSummaryRecord *record = [battingSummaryArray objectAtIndex:i];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            
            
            // NSString *filter =[NSString stringWithFormat:@"MR.COMPETITIONCODE='%@' AND",competitionCode];
            
            
            NSString *error = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[record.WICKETNO isEqualToString:@""]?@"NULL" : record.WICKETNO,[record.WICKETTYPE isEqualToString:@""]?@"NULL" : record.WICKETTYPE,[record.FIELDERCODE isEqualToString:@""]?@"NULL" : record.FIELDERCODE ,[record.BOWLERCODE isEqualToString:@""]?@"NULL" : record.BOWLERCODE ,[record.WICKETOVERNO isEqualToString:@""]?@"NULL" : record.WICKETOVERNO,[record.WICKETBALLNO isEqualToString:@""]?@"NULL" : record.WICKETBALLNO,[record.WICKETSCORE isEqualToString:@""]?@"NULL" : record.WICKETSCORE];
            
            NSString *Noerror = [NSString stringWithFormat:@"'%@','%@','%@','%@','%@','%@','%@'",[record.WICKETNO isEqualToString:@""]?@"NULL" : record.WICKETNO,[record.WICKETTYPE isEqualToString:@""]?@"NULL" : record.WICKETTYPE,[record.FIELDERCODE isEqualToString:@""]?@"NULL" : record.FIELDERCODE ,[record.BOWLERCODE isEqualToString:@""]?@"NULL" : record.BOWLERCODE ,[record.WICKETOVERNO isEqualToString:@""]?@"NULL" : record.WICKETOVERNO,[record.WICKETBALLNO isEqualToString:@""]?@"NULL" : record.WICKETBALLNO,[record.WICKETSCORE isEqualToString:@""]?@"NULL" : record.WICKETSCORE];
            
            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY (COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTINGPOSITIONNO,BATSMANCODE,RUNS,BALLS,ONES,TWOS,THREES,FOURS,SIXES,DOTBALLS,WICKETNO,WICKETTYPE,FIELDERCODE,BOWLERCODE,WICKETOVERNO,WICKETBALLNO,WICKETSCORE) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%@)", record.COMPETITIONCODE,record.MATCHCODE,record.BATTINGTEAMCODE,record.INNINGSNO,record.BATTINGPOSITIONNO,record.BATSMANCODE,record.RUNS,record.BALLS,record.ONES,record.TWOS,record.THREES,record.FOURS,record.SIXES,record.DOTBALLS, [record.WICKETNO isEqualToString:@""] ? error : Noerror];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                //ADDED
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC250" :updateSQL];
            }
            else{
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
            }
        }
        
        
    }
    
    return  YES;
}







// [Utitliy getPitchMapXAxisForDB:PMX2] ,  [Utitliy getPitchMapYAxisForDB:PMY2]
//[Utitliy getWagonWheelXAxisForDB: WWX1],[Utitliy getWagonWheelYAxisForDB: WWY1],[Utitliy getWagonWheelXAxisForDB: WWX2],[Utitliy getWagonWheelYAxisForDB: WWY2]


-(BOOL) UPDATEBALLEVENT : (NSString*) BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEN:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT:(NSString*) BOWLINGEND
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET STRIKERCODE  =	'%@', NONSTRIKERCODE =	'%@', BOWLERCODE  =	'%@', WICKETKEEPERCODE   = '%@', UMPIRE1CODE  =	'%@', UMPIRE2CODE  =	'%@', ATWOROTW  =	'%@', BOWLINGEND   =	'%@', BOWLTYPE   =	'%@', SHOTTYPE            =	'%@', SHOTTYPECATEGORY	=	'%@', ISLEGALBALL  =	'%@', ISFOUR  =	'%@', ISSIX =	'%@', RUNS  =	'%@', OVERTHROW  =	'%@', TOTALRUNS   =	'%@', WIDE  =	'%@', NOBALL =	'%@', BYES  =	'%@', LEGBYES  =	'%@', PENALTY   = '%@', TOTALEXTRAS  = '%@', GRANDTOTAL  =	'%@', RBW =	'%@', PMLINECODE   =	'%@', PMLENGTHCODE =	'%@', PMSTRIKEPOINT =	'%@', PMSTRIKEPOINTLINECODE = '%@' , PMX1  =	'%@',PMY1 = '%@',PMX2  =	'%@',PMY2  = '%@', PMX3   =	'%@', PMY3  =	'%@', WWREGION  =	'%@', WWX1  =	'%@', WWY1 = '%@', WWX2 =	'%@', WWY2  =	'%@', BALLDURATION  =	'%@', ISAPPEAL  =	'%@', ISBEATEN  =	'%@', ISUNCOMFORT  =	'%@', ISWTB =	'%@', ISRELEASESHOT  =	'%@', MARKEDFOREDIT   =	'%@', REMARKS	 =	'%@', BALLSPEED =   '%@', UNCOMFORTCLASSIFCATION	=	'%@' WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE   =	'%@' AND   TEAMCODE  =	'%@' AND   INNINGSNO =	'%@' AND   BALLCODE =	'%@'",STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE,UMPIRE2CODE,ATWOROTW,BOWLINGEND,BOWLTYPE,SHOTTYPE,SHOTTYPECATEGORY,ISLEGALBALL,ISFOUR,ISSIX,RUNS,OVERTHROW,TOTALRUNS,WIDE,NOBALL,BYES,LEGBYES,PENALTY,TOTALEXTRAS,GRANDTOTAL,RBW,PMLINECODE,PMLENGTHCODE,PMSTRIKEPOINT,PMSTRIKEPOINTLINECODE,PMX1,PMY1,[Utitliy getPitchMapXAxisForDB:PMX2] ,  [Utitliy getPitchMapYAxisForDB:PMY2],PMX3,PMY3,WWREGION,[Utitliy getWagonWheelXAxisForDB: WWX1],[Utitliy getWagonWheelYAxisForDB: WWY1],[Utitliy getWagonWheelXAxisForDB: WWX2],[Utitliy getWagonWheelYAxisForDB: WWY2],BALLDURATION,ISAPPEAL,ISBEATEN,ISUNCOMFORT,ISWTB,ISRELEASESHOT,MARKEDFOREDIT,REMARKS,BALLSPEED,UNCOMFORTCLASSIFCATION,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}


@end





