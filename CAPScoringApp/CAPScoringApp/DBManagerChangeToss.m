//
//  DBManagerChangeToss.m
//  CAPScoringApp
//
//  Created by APPLE on 01/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerChangeToss.h"
#import <sqlite3.h>
#import "FetchBattingTeamTossRecord.h"
#import "UmpireDetailRecord.h"
#import "InningsEventTossDetail.h"
#import "TossDetailRecord.h"
#import "TossTeamDetailRecord.h"
#import "InitializeInningsScoreBoardRecord.h"
static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

@implementation DBManagerChangeToss


+(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}

+ (void) copyDatabaseIfNotExist{
    
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


+(NSMutableArray *) GetBattingTeamPlayers:(NSString*) TEAMCODE:(NSString*) MATCHCODE{
    NSMutableArray *GetBattingTeamPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE,PM.PLAYERNAME PLAYERNAME,MPD.RECORDSTATUS FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE AND	MPD.TEAMCODE = '%@' AND MPD.MATCHCODE = '%@' Inner Join COMPETITION COM on COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE where (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) AND MPD.RECORDSTATUS = 'MSC001' ORDER BY MPD.PLAYINGORDER",TEAMCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord *GetPlayerDetails=[[FetchBattingTeamTossRecord alloc]init];
                GetPlayerDetails.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                GetPlayerDetails.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                GetPlayerDetails.RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [GetBattingTeamPlayersArray addObject:GetPlayerDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBattingTeamPlayersArray;
}


+ (NSMutableArray *) GetBowlingTeamPlayers:(NSString*) TEAMCODE:(NSString*) MATCHCODE{
    NSMutableArray *GetBowlingTeamPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE,PM.PLAYERNAME PLAYERNAME,MPD.RECORDSTATUS FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE AND	MPD.TEAMCODE != '%@' AND MPD.MATCHCODE = '%@' Inner Join COMPETITION COM on COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) AND MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE != '%@' THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END) --AND PM.BOWLINGSTYLE IN ('MSC131','MSC132') AND MPD.RECORDSTATUS = 'MSC001'ORDER BY MPD.PLAYINGORDER",TEAMCODE,MATCHCODE,TEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord *GetBowlingDetails=[[FetchBattingTeamTossRecord alloc]init];
                GetBowlingDetails.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                GetBowlingDetails.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                GetBowlingDetails.RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [GetBowlingTeamPlayersArray addObject:GetBowlingDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBowlingTeamPlayersArray;
}

+(NSMutableArray *) BattingTeamPlayersForToss:(NSString*) TEAMCODE:(NSString*) MATCHCODE{
    NSMutableArray *BattingTeamPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE,PM.PLAYERNAME PLAYERNAME,MPD.RECORDSTATUS FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE AND	MPD.TEAMCODE != '%@' AND MPD.MATCHCODE = '%@' Inner Join COMPETITION COM on COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE where (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) AND MPD.RECORDSTATUS = 'MSC001' ORDER BY MPD.PLAYINGORDER",TEAMCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord *BattingDetails=[[FetchBattingTeamTossRecord alloc]init];
                BattingDetails.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                BattingDetails.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                BattingDetails.RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [BattingTeamPlayersArray addObject:BattingDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BattingTeamPlayersArray;
}


+(NSMutableArray *) BowlingTeamPlayersForToss:(NSString*) TEAMCODE:(NSString*) MATCHCODE{
    NSMutableArray *BowlingTeamPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE,PM.PLAYERNAME PLAYERNAME,MPD.RECORDSTATUS FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE AND	MPD.TEAMCODE != '%@' AND MPD.MATCHCODE = '%@' Inner Join COMPETITION COM on COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) AND MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE != '%@' THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END) --AND PM.BOWLINGSTYLE IN ('MSC131','MSC132') AND MPD.RECORDSTATUS = 'MSC001'ORDER BY MPD.PLAYINGORDER",TEAMCODE,MATCHCODE,TEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord *BowlingDetails=[[FetchBattingTeamTossRecord alloc]init];
                BowlingDetails.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                BowlingDetails.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                BowlingDetails.RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [BowlingTeamPlayersArray addObject:BowlingDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BowlingTeamPlayersArray;
}


//SP_FETCHTOSSDETAILSFORINNINGS

+(NSString*) GetMaxInningsNoForInningsEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(INNINGSNO) AS MAXINNINGSNO from INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 1",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MAXINNINGSNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MAXINNINGSNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}

+(NSString *) GetBowlingTeamCodeForInningsEvents:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) MAXINNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMCODE AS BOWLINGTEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 1 AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,MAXINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLINGTEAMCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BOWLINGTEAMCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}

+(NSString*) GetBattingTeamCodeForInningsEvents:(NSString *) BATTINGTEAMCODE:(NSString *) MATCHCODE:(NSString*) COMPETITIONCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT (CASE WHEN TEAMACODE = '%@' THEN TEAMBCODE ELSE TEAMACODE END) AS BATTINGTEAMCODE FROM MATCHREGISTRATION WHERE MATCHCODE = '%@' AND COMPETITIONCODE = '%@'",BATTINGTEAMCODE,MATCHCODE,COMPETITIONCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BATTINGTEAMCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BATTINGTEAMCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}


+(NSMutableArray *) GetTeamCodeForInnings:(NSString*) BATTINGTEAMCODE{
    NSMutableArray *InningsDetailsForTossArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMNAME,TEAMCODE FROM TEAMMASTER WHERE TEAMCODE = '%@'",BATTINGTEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord *InningsDetailsForToss=[[FetchBattingTeamTossRecord alloc]init];
                InningsDetailsForToss.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                InningsDetailsForToss.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [InningsDetailsForTossArray addObject:InningsDetailsForToss];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return InningsDetailsForTossArray;
}


+(NSMutableArray *) GetBattingTeamPlayersForToss:(NSString*) BATTINGTEAMCODE:(NSString*) MATCHCODE{
    NSMutableArray *BattingPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE,PM.PLAYERNAME PLAYERNAME,MPD.RECORDSTATUS FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MPD.MATCHCODE = MR.MATCHCODE AND MPD.TEAMCODE = '%@' Inner Join COMPETITION COM on COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE where (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) AND MPD.RECORDSTATUS = 'MSC001' AND MR.MATCHCODE = '%@' ORDER BY MPD.PLAYINGORDER",BATTINGTEAMCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord *BattingPlayerDetails=[[FetchBattingTeamTossRecord alloc]init];
                BattingPlayerDetails.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                BattingPlayerDetails.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                BattingPlayerDetails.RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [BattingPlayersArray addObject:BattingPlayerDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BattingPlayersArray;
}

+(NSMutableArray *) GetBowlingTeamPlayersForToss:(NSString*) BOWLINGTEAMCODE:(NSString*) MATCHCODE{
    NSMutableArray *BowlingPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE,PM.PLAYERNAME PLAYERNAME,MPD.RECORDSTATUS FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MPD.MATCHCODE = MR.MATCHCODE ANDMPD.TEAMCODE = '%@' INNER JOIN COMPETITION COM ON COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) AND PM.BOWLINGSTYLE IN ('MSC131','MSC132')AND MPD.RECORDSTATUS = 'MSC001' AND MR.MATCHCODE = '%@' ORDER BY MPD.PLAYINGORDER",BOWLINGTEAMCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord * BattingPlayerDetails=[[FetchBattingTeamTossRecord alloc]init];
                BattingPlayerDetails.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                BattingPlayerDetails.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                BattingPlayerDetails.RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [BowlingPlayersArray addObject:BattingPlayerDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BowlingPlayersArray;
}

+(NSMutableArray *) UmpireDetailsForToss:(NSString*) MATCHCODE{
    NSMutableArray *UmpireDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MRG.UMPIRE1CODE,UMPIRE1.NAME,MRG.UMPIRE2CODE,UMPIRE2.NAME FROM MATCHREGISTRATION MRG INNER JOIN OFFICIALSMASTER UMPIRE1 ON UMPIRE1.OFFICIALSCODE = MRG.UMPIRE1CODE INNER JOIN OFFICIALSMASTER UMPIRE2 ON UMPIRE2.OFFICIALSCODE = MRG.UMPIRE2CODE WHERE MRG.MATCHCODE = '%@'",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if (sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UmpireDetailRecord *UmpireDetailsForTossEvents=[[UmpireDetailRecord alloc]init];
                UmpireDetailsForTossEvents.umpireCode1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                UmpireDetailsForTossEvents.umpirename1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                UmpireDetailsForTossEvents.umpireCode2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                UmpireDetailsForTossEvents.umpireName2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [UmpireDetailsArray addObject:UmpireDetailsForTossEvents];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return UmpireDetailsArray;
}


+(NSMutableArray *) GetInningsForTossDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *InningsEventsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STRIKERCODE,NONSTRIKERCODE,BOWLERCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 0",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                InningsEventTossDetail *InningsEventsForToss=[[InningsEventTossDetail alloc]init];
                InningsEventsForToss.StrickerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                InningsEventsForToss.nonStrickerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                InningsEventsForToss.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [InningsEventsArray addObject:InningsEventsForToss];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return InningsEventsArray;
}
//SP_FETCHLOADDETAILSFORTOSS
+(NSMutableArray *) GetTossDetails{
    NSMutableArray *FetchTossDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT [METASUBCODE],[METASUBCODEDESCRIPTION] FROM [METADATA] WHERE [METADATATYPECODE] = 'MDT007'"];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                TossDetailRecord *GetTossDetail=[[TossDetailRecord alloc]init];
                GetTossDetail.METASUBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                GetTossDetail.METASUBCODEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [FetchTossDetailsArray addObject:GetTossDetail];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return FetchTossDetailsArray;
}

+(NSMutableArray *) GetTeamDetailsForToss:(NSString*) MATCHCODE{
    NSMutableArray *FetchTeamDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MR.TEAMACODE AS TEAMCODE,TMA.TEAMNAME AS TEAMNAME FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TMA ON TMA.TEAMCODE = MR.TEAMACODE WHERE MR.MATCHCODE = '%@' UNION SELECT MR.TEAMBCODE AS TEAMCODE,TMB.TEAMNAME AS TEAMNAME FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TMB ON TMB.TEAMCODE = MR.TEAMBCODE WHERE MR.MATCHCODE = '%@'",MATCHCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchBattingTeamTossRecord *GetTeamDetails=[[FetchBattingTeamTossRecord alloc]init];
                GetTeamDetails.TEAMCODE_TOSSWONBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                GetTeamDetails.TEAMNAME_TOSSWONBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [FetchTeamDetailsArray addObject:GetTeamDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return FetchTeamDetailsArray;
}

+(NSMutableArray *) GetUmpireDetailsForToss:(NSString*) MATCHCODE{
    NSMutableArray *FetchUmpireDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MRG.UMPIRE1CODE,UMPIRE1.NAME,MRG.UMPIRE2CODE,UMPIRE2.NAME FROM MATCHREGISTRATION MRG INNER JOIN OFFICIALSMASTER UMPIRE1 ON UMPIRE1.OFFICIALSCODE = MRG.UMPIRE1CODE INNER JOIN OFFICIALSMASTER UMPIRE2 ON UMPIRE2.OFFICIALSCODE = MRG.UMPIRE2CODE WHERE MRG.MATCHCODE = '%@'",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UmpireDetailRecord *GetUmpireDetails=[[UmpireDetailRecord alloc]init];
                GetUmpireDetails.umpireCode1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                GetUmpireDetails.umpirename1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                GetUmpireDetails.umpireCode2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                GetUmpireDetails.umpireName2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [FetchUmpireDetailsArray addObject:GetUmpireDetails];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return FetchUmpireDetailsArray;
}
+(NSMutableArray *)StrikerNonstriker: (NSString *) MATCHCODE :(NSString *) TeamCODE{
    NSMutableArray *SrikerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME,PM.BATTINGSTYLE FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE WHERE MTP.MATCHCODE='%@'  AND MTP.TEAMCODE='%@'", MATCHCODE,TeamCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                FetchBattingTeamTossRecord *record=[[FetchBattingTeamTossRecord alloc]init];
                //need to edit
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.RecordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                
                //TEAMCODE_TOSSWONBY
                [SrikerEventArray addObject:record];
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return SrikerEventArray;
}

+(void) InsertTossDetails:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TOSSWONTEAMCODE:(NSString*)ELECTEDTO:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)BOWLINGEND
{
    NSString* BOWLINGTEAMCODE ;
    NSString* BATTINGTEAMCODE ;
    NSString* MAXINNINGSNO ;
    
    if(ELECTEDTO.length>0 && ![ELECTEDTO.uppercaseString isEqual: @"SELECT"])
    {
        if([ELECTEDTO isEqual:@"MSC017"])
        {
            NSMutableArray *TossDetailsArrays=[DBManagerChangeToss GetTossDetailsForBattingTeam : TOSSWONTEAMCODE : COMPETITIONCODE : MATCHCODE];
            TossTeamDetailRecord * objTossteam;
            if(TossDetailsArrays.count>0)
            {
                objTossteam=(TossTeamDetailRecord *)[TossDetailsArrays objectAtIndex:0];
                BATTINGTEAMCODE=objTossteam.BattingTeamcode;
                
                BOWLINGTEAMCODE=objTossteam.BowlingTeamCode;
            }
        }
        else
        {
            NSMutableArray *TossWonTeamDetailsArray=[DBManagerChangeToss GetTossDetailsForBowlingTeam : TOSSWONTEAMCODE : COMPETITIONCODE : MATCHCODE];
            TossTeamDetailRecord * objTossteam;
            if(TossWonTeamDetailsArray.count>0)
            {
                objTossteam=(TossTeamDetailRecord *)[TossWonTeamDetailsArray objectAtIndex:0];
                BATTINGTEAMCODE=objTossteam.BattingTeamcode;
                
                BOWLINGTEAMCODE=objTossteam.BowlingTeamCode;
            }
        }
    }
    else
    {
        NSMutableArray *TossWonTeamArray=[DBManagerChangeToss GetTossDetailsForTeam : TOSSWONTEAMCODE : COMPETITIONCODE : MATCHCODE];
        TossTeamDetailRecord * objTossteam;
        if(TossWonTeamArray > 0)
        {
            objTossteam=(TossTeamDetailRecord *)[TossWonTeamArray objectAtIndex:0];
            BATTINGTEAMCODE=objTossteam.BattingTeamcode;
            BOWLINGTEAMCODE=objTossteam.BowlingTeamCode;
        }
    }
    if([DBManagerChangeToss GetMatchEventsForTossDetails : COMPETITIONCODE : MATCHCODE].length<=0)
    {
        [DBManagerChangeToss SetMatchEventsForToss : COMPETITIONCODE : MATCHCODE : TOSSWONTEAMCODE : ELECTEDTO : BATTINGTEAMCODE : BOWLINGTEAMCODE];
    }
    MAXINNINGSNO = [DBManagerChangeToss GetMaxInningsNoForTossDetails : COMPETITIONCODE : MATCHCODE];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *MaxInningsNumber = [f numberFromString:MAXINNINGSNO];
    
    [DBManagerChangeToss SetInningsEventsForToss : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE :  MaxInningsNumber : STRIKERCODE : NONSTRIKERCODE: BOWLERCODE : BOWLINGEND];
    
    [DBManagerChangeToss UpdateMatchStatusForToss : COMPETITIONCODE : MATCHCODE];
    
    [InitializeInningsScoreBoardRecord InitializeInningsScoreBoard:COMPETITIONCODE : MATCHCODE :BATTINGTEAMCODE :BOWLINGTEAMCODE : MaxInningsNumber : STRIKERCODE : NONSTRIKERCODE :
     BOWLERCODE : [NSNumber numberWithInt:0]];
}
//SP_INSERTTOSSDETAILS

+(NSMutableArray *) GetTossDetailsForBattingTeam: (NSString*) TOSSWONTEAMCODE : (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE{
    NSMutableArray *TossDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT case when TEAMACODE = '%@' then TEAMACODE else TEAMBCODE End AS BATTINGTEAMCODE,case when TEAMACODE != '%@' then TEAMACODE else TEAMBCODE End AS BOWLINGTEAMCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",TOSSWONTEAMCODE,TOSSWONTEAMCODE,COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL) ==SQLITE_OK);
        
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                TossTeamDetailRecord *TossWonTeamCodeForToss=[[TossTeamDetailRecord alloc]init];
                TossWonTeamCodeForToss.BattingTeamcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                TossWonTeamCodeForToss.BowlingTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [TossDetailsArray addObject:TossWonTeamCodeForToss];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return TossDetailsArray;
}


+(NSMutableArray *) GetTossDetailsForBowlingTeam:(NSString*) TOSSWONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *TossWonTeamDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT case when TEAMACODE = '%@' then TEAMACODE else TEAMBCODE End AS BATTINGTEAMCODE,case when TEAMACODE != '%@' then TEAMACODE else TEAMBCODE End AS BOWLINGTEAMCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",TOSSWONTEAMCODE,TOSSWONTEAMCODE,COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL) == SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                TossTeamDetailRecord *BattingTeamCodeForToss=[[TossTeamDetailRecord alloc]init];
                BattingTeamCodeForToss.BattingTeamcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                BattingTeamCodeForToss.BowlingTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [TossWonTeamDetailsArray addObject:BattingTeamCodeForToss];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return TossWonTeamDetailsArray;
}

+(NSMutableArray *) GetTossDetailsForTeam:(NSString*) TOSSWONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *TossWonTeamArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT case when TEAMACODE = '%@' then TEAMACODE else TEAMBCODE End AS BATTINGTEAMCODE,case when TEAMACODE != '%@' then TEAMACODE else TEAMBCODE End AS BOWLINGTEAMCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",TOSSWONTEAMCODE,TOSSWONTEAMCODE,COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL) ==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                TossTeamDetailRecord *TeamCodeForToss=[[TossTeamDetailRecord alloc]init];
                TeamCodeForToss.BattingTeamcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                TeamCodeForToss.BowlingTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [TossWonTeamArray addObject:TeamCodeForToss];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return TossWonTeamArray;
}


+(NSString*) GetMatchEventsForTossDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHCODE FROM MATCHEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL) == SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MATCHCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MATCHCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}

+(BOOL) SetMatchEventsForToss:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TOSSWONTEAMCODE:(NSString*) ELECTEDTO:(NSString*) BATTINGTEAMCODE:(NSString*) BOWLINGTEAMCODE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO [MATCHEVENTS]([COMPETITIONCODE],[MATCHCODE],[TOSSWONTEAMCODE],[ELECTEDTO],[BATTINGTEAMCODE],[BOWLINGTEAMCODE],BOWLCOMPUTESHOW)VALUES('%@','%@','%@','%@','%@','%@','1')",COMPETITIONCODE,MATCHCODE,TOSSWONTEAMCODE,ELECTEDTO,BATTINGTEAMCODE,BOWLINGTEAMCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    return NO;
    
}

+(NSString *) GetMaxInningsNoForTossDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(INNINGSNO),0)+1 AS MAXINNINGSNO from INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MAXINNINGSNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MAXINNINGSNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
    
}


+(BOOL) SetInningsEventsForToss:(NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE : (NSNumber*) Inningsno : (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE : (NSString*) BOWLERCODE : (NSString*) BOWLINGEND {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO [INNINGSEVENTS]([COMPETITIONCODE],[MATCHCODE],[TEAMCODE],[INNINGSNO],[STRIKERCODE],[NONSTRIKERCODE],[BOWLERCODE],[CURRENTSTRIKERCODE],[CURRENTNONSTRIKERCODE],[CURRENTBOWLERCODE],[BATTINGTEAMCODE],[INNINGSSTATUS],[BOWLINGEND])VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@')", COMPETITIONCODE, MATCHCODE,BATTINGTEAMCODE,Inningsno,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,STRIKERCODE, NONSTRIKERCODE,BOWLERCODE,BATTINGTEAMCODE,0,BOWLINGEND];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL) UpdateMatchStatusForToss: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = (CASE WHEN MATCHSTATUS = 'MSC123' THEN 'MSC240' ELSE MATCHSTATUS END)WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    return NO;
}


@end
