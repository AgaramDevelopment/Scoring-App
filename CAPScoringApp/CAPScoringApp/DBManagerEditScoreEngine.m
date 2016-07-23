    //
//  DBManagerEditScoreEngine.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerEditScoreEngine.h"

#import "ScoreEnginEditRecord.h"
#import "SelectPlayerRecord.h"
#import "BowlerEvent.h"


@implementation DBManagerEditScoreEngine
//SP_FETCHSEBALLCODEDETAILS


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

//Get database path
-(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}




-(NSMutableArray *) GetTeamDetailsForMatchRegistration:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE{
    
    NSMutableArray *GetTeamDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT TEAMACODE,  TEAMBCODE,  MATCHOVERS FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
     if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                GetSEDetailsForMatchRegistration *record=[[GetSEDetailsForMatchRegistration alloc]init];
                record.TEAMACODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.MATCHOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [GetTeamDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetTeamDetailsArray;
}


-(NSMutableArray *) GetTeamDetailsForCompetition:(NSString*) COMPETITIONCODE{
    NSMutableArray *GetTeamDetailsForCompetitionArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT  MATCHTYPE,ISOTHERSMATCHTYPE FROM COMPETITION WHERE COMPETITIONCODE = '%@'",COMPETITIONCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
     if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                GetSEDetailsForCompetition *record=[[GetSEDetailsForCompetition alloc]init];
                record.MATCHTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.ISOTHERSMATCHTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [GetTeamDetailsForCompetitionArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetTeamDetailsForCompetitionArray;
}

-(NSMutableArray *) GetTeamDetailsForBallEvents:(NSString*) TEAMACODE: (NSString*) BATTINGTEAMCODE: (NSString*) TEAMBCODE: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BALLCODE{
    NSMutableArray *GetTeamDetailsForBallEventsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT INNINGSNO, TEAMCODE,  CASE  WHEN '%@' = TEAMCODE THEN '%@' ELSE '%@' END FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BALLCODE = '%@';",TEAMACODE,TEAMBCODE,TEAMACODE,COMPETITIONCODE,MATCHCODE,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForBallEvents *record=[[GetSEDetailsForBallEvents alloc]init];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                 record.BOWLINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [GetTeamDetailsForBallEventsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetTeamDetailsForBallEventsArray;
}


-(NSString*) GetSessionNoForSessionEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(SESSIONNO),0) + 1 AS SESSIONNO FROM SESSIONEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *SESSIONNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                  sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return SESSIONNO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }

        sqlite3_close(dataBase);
    }
   
    return @"";
}

-(NSString*) GetDayNoForSEDayEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(DAYNO),0) + 1 AS DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *DAYNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                  sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return DAYNO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
        sqlite3_close(dataBase);
    }
    sqlite3_reset(statement);
    return @"";
}

-(NSString*) GetInningsStatusForSEInningsEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT INNINGSSTATUS FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *INNINGSSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                  sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return INNINGSSTATUS;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
        sqlite3_close(dataBase);
    }
    sqlite3_reset(statement);
    return @"";
}

-(NSMutableArray *) GetBattingTeamNamesForTeamMaster:(NSString*) BATTINGTEAMCODE{
    NSMutableArray *GetBattingTeamNamesArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT SHORTTEAMNAME,TEAMNAME,TEAMLOGO FROM TEAMMASTER WHERE TEAMCODE = '%@'",BATTINGTEAMCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForBattingTeamNames *record=[[GetSEDetailsForBattingTeamNames alloc]init];
                record.SHORTTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TEAMLOGO= [self getValueByNull:statement :2];
                [GetBattingTeamNamesArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBattingTeamNamesArray;
}

-(NSMutableArray *) GetBowlingTeamNamesForTeamMaster:(NSString*) BOWLINGTEAMCODE{
    NSMutableArray *GetBowlingTeamNamesArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT SHORTTEAMNAME,TEAMNAME,TEAMLOGO FROM TEAMMASTER WHERE TEAMCODE = '%@'",BOWLINGTEAMCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForBowlingTeamNames *record=[[GetSEDetailsForBowlingTeamNames alloc]init];
                record.SHORTTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TEAMLOGO=[self getValueByNull:statement :2];
                
                [GetBowlingTeamNamesArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBowlingTeamNamesArray;
}

-(NSMutableArray *) GetRevisedTargetForMatchEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *GetRevisedTargetArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT IFNULL(TARGETRUNS,0),IFNULL(TARGETOVERS,0) FROM MATCHEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForMtachRevisedTarget *record=[[GetSEDetailsForMtachRevisedTarget alloc]init];
                record.TARGETRUNS=[self getValueByNull:statement :0];
                record.TARGETOVERS=[self getValueByNull:statement :1];
                [GetRevisedTargetArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetRevisedTargetArray;
}


-(NSMutableArray *) GetMatchDetailsForSEMatchRegistration:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *GetMatchDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BOWLINGTEAMCODE,INNINGSNO,SESSIONNO,DAYNO,MATCHOVERS, MATCHTYPE,ISOTHERSMATCHTYPE,MR.TEAMAWICKETKEEPER, MR.TEAMBWICKETKEEPER, MR.TEAMACAPTAIN, MR.TEAMBCAPTAIN, MR.TEAMACODE, MR.TEAMBCODE,INNINGSSTATUS FROM MATCHREGISTRATION MR WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForMatchDetails *record=[[GetSEDetailsForMatchDetails alloc]init];
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.BOWLINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.SESSIONNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.DAYNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.MATCHOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.MATCHTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.ISOTHERSMATCHTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.TEAMAWICKETKEEPER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.TEAMBWICKETKEEPER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.TEAMACAPTAIN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.TEAMBCAPTAIN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.TEAMACODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.TEAMBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.INNINGSSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                
                
                
                
                
                [GetMatchDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetMatchDetailsArray;
}


-(NSMutableArray *) GetBowlTypeForBallCodeDetails{
    NSMutableArray *GetBowlTypeArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT BOWLTYPECODE,BOWLTYPE,MD.METASUBCODEDESCRIPTION ,MD.METASUBCODE FROM BOWLTYPE BT INNER JOIN METADATA MD ON MD.METASUBCODE=BT.BOWLERTYPE WHERE BT.RECORDSTATUS='MSC001'"];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForBowlType *record=[[GetSEDetailsForBowlType alloc]init];
                record.BOWLTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.METASUBCODEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.METASUBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                [GetBowlTypeArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBowlTypeArray;
}

-(NSMutableArray *) GetShotTypeForBallCodeDetails{
    NSMutableArray *GetShotTypeArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT ST.SHOTCODE, ST.SHOTNAME, ST.SHOTTYPE FROM SHOTTYPE ST WHERE ST.RECORDSTATUS = 'MSC001' ORDER BY ST.SHOTTYPE , ST.DISPLAYORDER" ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForShotType *record=[[GetSEDetailsForShotType alloc]init];
                record.SHOTCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.SHOTNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.SHOTTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [GetShotTypeArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetShotTypeArray;
}

-(NSMutableArray *) GetBallCodeForBallEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSString*) BALLCODE{
    NSMutableArray *GetBallCodeArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT OVERNO,BALLNO,BALLCOUNT,BOWLERCODE,ATWOROTW,BOWLINGEND,STRIKERCODE,NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND   TEAMCODE = '%@' AND INNINGSNO= '%@' AND	BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForBallEventsDetails *record=[[GetSEDetailsForBallEventsDetails alloc]init];
                record.OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.BALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.ATWOROTW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.BOWLINGEND=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                
                
                
                
                [GetBallCodeArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBallCodeArray;
}


-(NSMutableArray *) GetRetiredHurtChangesForBallevents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO{
    NSMutableArray *GetRetiredHurtChangesArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT rownum OVER (ORDER BY WKT.MATCHCODE),WKT.WICKETPLAYER,WKT.WICKETTYPE,WKT.BALLCODE,WKT.COMPETITIONCODE,WKT.MATCHCODE,WKT.TEAMCODE,WKT.INNINGSNO,BALL.OVERNO,BALL.BALLNO,BALL.BALLCOUNT FROM BALLEVENTS BALL INNER JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.BALLCODE = WKT.BALLCODE WHERE WKT.COMPETITIONCODE = '%@' AND WKT.MATCHCODE = '%@' AND WKT.TEAMCODE = '%@' AND WKT.INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEDetailsForRetiredHurtDetails *record=[[GetSEDetailsForRetiredHurtDetails alloc]init];
                record.rownum=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.BALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                
                
                
                
                [GetRetiredHurtChangesArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetRetiredHurtChangesArray;
}

-(NSMutableArray *) GetBattingTeamPlayersForMatchRegistration:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT{
    NSMutableArray *GetBattingTeamPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"WITH X(rownum,WICKETPLAYER,WICKETTYPE,BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT)  AS ( SELECT  (SELECT COUNT(*) FROM WICKETEVENTS AS t2 WHERE t2.MATCHCODE <= WKT.MATCHCODE), WKT.WICKETPLAYER,WKT.WICKETTYPE,WKT.BALLCODE,WKT.COMPETITIONCODE, WKT.MATCHCODE,WKT.TEAMCODE,WKT.INNINGSNO,BALL.OVERNO,BALL.BALLNO,BALL.BALLCOUNT    FROM BALLEVENTS BALL 		INNER JOIN WICKETEVENTS WKT 		ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE 		AND BALL.MATCHCODE = WKT.MATCHCODE 		AND BALL.INNINGSNO = WKT.INNINGSNO 		AND BALL.BALLCODE = WKT.BALLCODE    WHERE   		WKT.COMPETITIONCODE = '%@' 		AND WKT.MATCHCODE =   '%@' 		AND	WKT.TEAMCODE =   '%@' 		AND WKT.INNINGSNO = '%@' 		 		) 	SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BATTINGSTYLE 	FROM MATCHREGISTRATION MR 	INNER JOIN MATCHTEAMPLAYERDETAILS MPD 	ON MR.MATCHCODE = MPD.MATCHCODE 	INNER JOIN COMPETITION COM  	ON COM.COMPETITIONCODE = MR.COMPETITIONCODE 	INNER JOIN TEAMMASTER TMA 	ON MPD.MATCHCODE = '%@' 	AND	MPD.TEAMCODE = '%@' 	AND MPD.TEAMCODE = TMA.TEAMCODE 	INNER JOIN PLAYERMASTER PM 	ON MPD.PLAYERCODE = PM.PLAYERCODE	 	WHERE PM.PLAYERCODE NOT IN  	(	 		SELECT X.WICKETPLAYER FROM X LEFT JOIN X nex ON nex.rownum = X.rownum + 1 WHERE  		(X.WICKETTYPE  != 'MSC102' OR NEX.WICKETPLAYER IS NULL) AND 		X.COMPETITIONCODE = '%@' 		AND X.MATCHCODE = '%@' 		AND	X.TEAMCODE = '%@' 		AND X.INNINGSNO = '%@'  		AND CAST(CAST(X.OVERNO as TEXT) || '.' || CAST(X.BALLNO as TEXT) 		|| CAST(X.BALLCOUNT as TEXT) as numeric) < cast(CAST('%@' as TEXT) || '.' 		|| CAST('%@' as TEXT) || CAST('%@' as TEXT) as numeric) 		 	) 	AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) 	ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,MATCHCODE,BATTINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS ,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                SelectPlayerRecord *record = [[SelectPlayerRecord alloc]init];

               // GetSEDetailsForBattingTeamPlayers *record=[[GetSEDetailsForBattingTeamPlayers alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.battingStyle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                
                
                
                
                
                [GetBattingTeamPlayersArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBattingTeamPlayersArray;
}


-(NSString*) GetSEGrandTotalForBallEvents:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT: (NSNumber*) BATTEAMOVERS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) AS GRANDTOTAL FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO || '.' || BALLNO || BALLCOUNT <= '%@' || '.' ||'%@'||'%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *GRANDTOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return GRANDTOTAL;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
        sqlite3_close(dataBase);
    }

    return @"";
}


-(NSString*) GetPenaltyRunsForBallCodeDetails:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) AS PENALTYRUNS FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND AWARDEDTOTEAMCODE = '%@'AND BALLCODE IS NULL",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *PENALTYRUNS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                  sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return PENALTYRUNS;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
        sqlite3_close(dataBase);
    }
   
    return @"";
}



-(NSString*) GetWicketNoForBallCodeDetails:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT: (NSNumber*) BATTEAMOVERS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(COUNT(WKT.WICKETNO),0) AS WICKETNO FROM BALLEVENTS BALL INNER JOIN WICKETEVENTS WKT ON WKT.BALLCODE = BALL.BALLCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@'  AND BALL.INNINGSNO = '%@' AND WKT.WICKETTYPE != 'MSC102' AND OVERNO || '.' ||BALLNO||BALLCOUNT <= '%@' || '.' || '%@'||'%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }

        sqlite3_close(dataBase);
    }
    sqlite3_reset(statement);
    return @"";
}


-(NSMutableArray *) GetBowlingTeamPlayersForMatchRegistration:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS{
    NSMutableArray *GetBowlingTeamPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BOWLINGTYPE, PM.BOWLINGSTYLE, '' AS PENULTIMATEBOWLERCODE FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE INNER JOIN COMPETITION COM  ON COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN TEAMMASTER TMA ON MPD.MATCHCODE = '%@' AND	MPD.TEAMCODE = '%@' AND MPD.TEAMCODE = TMA.TEAMCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE = '%@' THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END) --AND PM.BOWLINGSTYLE IN ('MSC131','MSC132') AND PM.PLAYERCODE NOT IN  ( SELECT BOWLERCODE FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND TEAMCODE = '%@'  AND INNINGSNO = '%@'  AND OVERNO = '%@' - 1 ) AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))",MATCHCODE,BOWLINGTEAMCODE,BOWLINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                BowlerEvent *record = [[BowlerEvent alloc]init];
                
              //  GetSEDetailsForBowlingTeamPlayers *record=[[GetSEDetailsForBowlingTeamPlayers alloc]init];
                record.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.bowlingType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.bowlingStyle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
              //  record.PENULTIMATEBOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                [GetBowlingTeamPlayersArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
 
    return GetBowlingTeamPlayersArray;
}


-(NSString*) GetTotalBatTeamOversForGrandTotal:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) AS GRANDTOTAL FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO < '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *GRANDTOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return GRANDTOTAL;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
       
        sqlite3_close(dataBase);
    }
   
    return @"";
}

-(NSString*) GetTotalBowlTeamOversForGrandTotal:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) AS GRANDTOTAL FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO < '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *GRANDTOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return GRANDTOTAL;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
    
        sqlite3_close(dataBase);
    }
    
    return @"";
}


-(NSString*) GetFreeHitDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT:(NSNumber*) BATTEAMOVERS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(NOBALL) AS NOBALL FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT < '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *NOBALL =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NOBALL;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
  
        sqlite3_close(dataBase);
    }

    return @"";
}


-(NSString*) GetStrikerBallForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) STRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALL.BALLCODE) AS BALLCODE FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'  AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0 AND BALL.OVERNO|| '.' ||BALL.BALLNO||BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }

        sqlite3_close(dataBase);
    }
    
    return @"";
}

-(NSString*) GetStrikerDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) STRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.STRIKERCODE FROM  BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.OVERNO || '.' || BALL.BALLNO||BALL.BALLCOUNT <= '%@' || '.' || '%@'||'%@' AND BALL.WIDE = 0 GROUP BY BALL.STRIKERCODE",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *STRIKERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return STRIKERCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
        sqlite3_close(dataBase);
    }
       return @"";
}


-(NSMutableArray *) GetStrikerDetailsForSEBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT:(NSString*) STRIKERCODE : (NSString *)STRIKERBALLS{
    NSMutableArray *GetStrikerDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT BALL.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME,IFNULL(SUM(BALL.TOTALRUNS),0) AS TOTALRUNS, IFNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISFOUR = 1 THEN 1 ELSE 0 END),0) AS FOURS, IFNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISSIX = 1 THEN 1 ELSE 0 END),0) AS SIXES,CASE WHEN '%@' = 0 THEN 0 ELSE ((IFNULL(SUM(BALL.TOTALRUNS),0)/'%@')*100) END AS STRIKERATE, PM.BATTINGSTYLE FROM BALLEVENTS BALL INNER JOIN PLAYERMASTER PM ON BALL.STRIKERCODE = PM.PLAYERCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'  AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' || '%@' || '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0 GROUP BY BALL.STRIKERCODE,PM.PLAYERNAME, PM.BATTINGSTYLE",STRIKERBALLS,STRIKERBALLS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT,STRIKERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEStrikerDetailsForBallEvents *record=[[GetSEStrikerDetailsForBallEvents alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                
                
                
                
                [GetStrikerDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetStrikerDetailsArray;
}

-(NSMutableArray *) GetStrikerDetailsForPlayerMaster:(NSString*) STRIKERCODE{
    NSMutableArray *GetStrikerDetailsForPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT PLAYERCODE,PLAYERNAME,0 AS TOTALRUNS, 0 AS FOURS, 0 AS SIXES,0 AS TOTALBALLS, 0 AS STRIKERATE, BATTINGSTYLE FROM PLAYERMASTER WHERE PLAYERCODE = '%@'",STRIKERCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEStrikerDetailsForBallEvents *record=[[GetSEStrikerDetailsForBallEvents alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                
                
                
                
                [GetStrikerDetailsForPlayersArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetStrikerDetailsForPlayersArray;
}


-(NSString*) GetNonStrikerBallForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) NONSTRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALL.BALLCODE) AS BALLCODE FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'  AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0 AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
        sqlite3_close(dataBase);
    }

    return @"";
}

-(NSString*) GetNonStrikerDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) NONSTRIKERCODE: (NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.STRIKERCODE FROM  BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@' AND BALL.WIDE = 0 GROUP BY BALL.STRIKERCODE",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *STRIKERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return STRIKERCODE;
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
    
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
   
    return @"";
}


-(NSMutableArray *) GetNonStrikerDetailsForSEBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS: (NSNumber*) BATTEAMOVRBALLS: (NSNumber*) BATTEAMOVRBALLSCNT:(NSString*) NONSTRIKERCODE : (NSString *)STRIKERBALLS{
    NSMutableArray *GetNonStrikerDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT BALL.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME,IFNULL(SUM(BALL.TOTALRUNS),0) AS TOTALRUNS, IFNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISFOUR = 1 THEN 1 ELSE 0 END),0) AS FOURS, IFNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISSIX = 1 THEN 1 ELSE 0 END),0) AS SIXES,CASE WHEN '%@' = 0 THEN 0 ELSE ((IFNULL(SUM(BALL.TOTALRUNS),0)/'%@')*100) END AS STRIKERATE, PM.BATTINGSTYLE FROM BALLEVENTS BALL INNER JOIN PLAYERMASTER PM ON BALL.STRIKERCODE = PM.PLAYERCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'  AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0 GROUP BY BALL.STRIKERCODE,PM.PLAYERNAME, PM.BATTINGSTYLE",STRIKERBALLS,STRIKERBALLS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT,NONSTRIKERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSENonStrikerDetailsForBallEvents *record=[[GetSENonStrikerDetailsForBallEvents alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                
                
                
                [GetNonStrikerDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetNonStrikerDetailsArray;
}


-(NSMutableArray *) GetNonStrikerDetailsForPlayerMaster:(NSString*) NONSTRIKERCODE{
    NSMutableArray *GetNonStrikerDetailsForPlayersArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT PLAYERCODE,PLAYERNAME,0 AS TOTALRUNS, 0 AS FOURS, 0 AS SIXES,0 AS TOTALBALLS, 0 AS STRIKERATE, BATTINGSTYLE FROM PLAYERMASTER WHERE PLAYERCODE = '%@'", NONSTRIKERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSENonStrikerDetailsForBallEvents *record=[[GetSENonStrikerDetailsForBallEvents alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                
                
                
                
                [GetNonStrikerDetailsForPlayersArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetNonStrikerDetailsForPlayersArray;
}



-(NSMutableArray *) GetPartnershipDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT{
    NSMutableArray *GetPartnershipDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) PARTNERSHIPRUNS, SUM(CASE WHEN WIDE > 0 THEN 0 ELSE 1 END) PARTNERSHIPBALLS FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@'  AND (BALL.STRIKERCODE = '%@' OR BALL.NONSTRIKERCODE = '%@')  AND (BALL.STRIKERCODE = '%@' OR BALL.NONSTRIKERCODE = '%@') AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,STRIKERCODE,STRIKERCODE,NONSTRIKERCODE,NONSTRIKERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEPartnershipDetailsForBallEvents *record=[[GetSEPartnershipDetailsForBallEvents alloc]init];
                record.PARTNERSHIPRUNS=[self getValueByNull:statement :0];
                record.PARTNERSHIPBALLS=[self getValueByNull:statement :1];
                
                [GetPartnershipDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetPartnershipDetailsArray;
}



-(NSString*) GetWicketsDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT:(NSString*) BOWLERCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(WKT.WICKETNO) AS WICKETNO FROM BALLEVENTS BALL INNER JOIN WICKETEVENTS WKT ON WKT.BALLCODE = BALL.BALLCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'  AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@' AND BALL.BOWLERCODE = '%@' AND WKT.WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT,BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNO;
            }
           
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
        sqlite3_close(dataBase);
    }
    
    return @"";
}

-(NSString*) GetBowlerCodeForBowlerOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BOWLERCODE:(NSNumber*) BATTEAMOVERS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN COUNT(BOWLERCODE) > 1 THEN 1 ELSE 0 END BOWLERCODE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO IN ( SELECT OVERNO FROM BOWLEROVERDETAILS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@' AND OVERNO < '%@' )",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,BATTEAMOVERS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);

                return BOWLERCODE;
            }
 
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }

        sqlite3_close(dataBase);
    }
        return @"";
}

-(NSString*) GetIsPartialOverForBowlerOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS:(NSNumber*) BOWLERCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) ISPARTIALOVER FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BOWLERCODE <> '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *ISPARTIALOVER =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);

                return ISPARTIALOVER;
            }
   
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
      
        sqlite3_close(dataBase);
    }
   
    return @"";
}


-(NSMutableArray *) GetBallCountForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BOWLERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT{
    NSMutableArray *GetBallCountArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 THEN 6 ELSE BALLCOUNT END),0) AS TOTALBALLSBOWL,IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 AND TOTALRUNS = 0 THEN 1 ELSE 0 END),0) AS MAIDENS,IFNULL(SUM(OE.TOTALRUNS),0) AS BOWLERRUNS FROM ( SELECT OE.OVERNO + 1 AS OVERNO, IFNULL(SUM(CASE WHEN BALL.ISLEGALBALL = 1 THEN 1 ELSE 0 END),0) AS BALLCOUNT, OE.OVERSTATUS,IFNULL(SUM(BALL.TOTALRUNS + CASE WHEN BALL.NOBALL > 0 AND BALL.BYES > 0 THEN 1 WHEN BALL.NOBALL > 0 AND BALL.BYES = 0 THEN BALL.NOBALL ELSE 0 END + BALL.WIDE),0) AS TOTALRUNS FROM BALLEVENTS BALL INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE  AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@' GROUP BY BOWLERCODE,OE.OVERNO,OE.OVERSTATUS )OE",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEBallCountForBallEvents *record=[[GetSEBallCountForBallEvents alloc]init];
                record.TOTALBALLSBOWL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MAIDENS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.BOWLERRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [GetBallCountArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBallCountArray;
}

-(NSString*) GetBowlerSpellForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSNumber*) BOWLERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(SPELL) AS BOWLERSPELL FROM(SELECT BALL.BOWLERCODE AS BOWLERCODE, BALL.OVERNO, IFNULL((SELECT CASE WHEN BALL.OVERNO - MAX(B.OVERNO) > 2 THEN @V_SPELLNO + 1 ELSE @V_SPELLNO END FROM BALLEVENTS B WHERE B.COMPETITIONCODE = BALL.COMPETITIONCODE AND B.MATCHCODE = BALL.MATCHCODE	 AND B.INNINGSNO = BALL.INNINGSNO AND B.BOWLERCODE = BALL.BOWLERCODE AND B.OVERNO < BALL.OVERNO GROUP BY B.COMPETITIONCODE, B.MATCHCODE, B.INNINGSNO, B.BOWLERCODE ), 1) SPELL FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@' GROUP BY BALL.COMPETITIONCODE, BALL.MATCHCODE, BALL.INNINGSNO, BALL.BOWLERCODE, BALL.OVERNO ) BOWLERSPELL",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLERSPELL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);

                return BOWLERSPELL;
            }
       
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
       
        sqlite3_close(dataBase);
    }
 
    return @"";
}



-(NSMutableArray *) GetBowlerDetailsForBallEventsDetails:(NSNumber*) ISPARTIALOVER:(NSNumber *) TOTALBALLSBOWL:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BOWLERRUNS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE:(NSNumber*) BATTEAMOVERS:(NSNumber*) BATTEAMOVRBALLS:(NSNumber*) BATTEAMOVRBALLSCNT{
    NSMutableArray *GetBowlerDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        //, BOWLERSPELL,TOTALRUNS, ATWOROTW
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT BOWLERCODE, BOWLERNAME,CASE WHEN %@ > 0 THEN(CASE WHEN '%@' = 0 THEN '0' ELSE '%@' / 6 || '.' || '%@' %% 6 END) ELSE (CASE WHEN INCOMPLETEOVERS > 0 THEN OVERS ELSE OVERS - 1 END) || '.' || CASE WHEN '%@' > 5 THEN '%@' ELSE '%@' %% 6 END END AS OVERS, (CASE WHEN '%@' = 0 THEN 0 ELSE ('%@' / ('%@'*1.0)) * 6 END) AS ECONOMY FROM( SELECT BOWLERCODE,BOWLERNAME,SUM(CASE WHEN OVERSTATUS = 1 THEN 1 ELSE 0 END) OVERS, SUM(CASE WHEN OVERSTATUS = 0 THEN 1 ELSE 0 END) INCOMPLETEOVERS FROM ( SELECT BALL.BOWLERCODE AS BOWLERCODE,PM.PLAYERNAME BOWLERNAME,OE.OVERSTATUS FROM BALLEVENTS BALL INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE  AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO INNER JOIN PLAYERMASTER PM ON BALL.BOWLERCODE = PM.PLAYERCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' AND BALL.OVERNO || '.' || BALL.BALLNO || BALL.BALLCOUNT <= '%@' || '.' ||'%@'||'%@' GROUP BY BALL.BOWLERCODE,PM.PLAYERNAME,OE.OVERNO,OE.OVERSTATUS ) OE GROUP BY BOWLERCODE,BOWLERNAME ) BOWLDTLS",ISPARTIALOVER,TOTALBALLSBOWL,TOTALBALLSBOWL,TOTALBALLSBOWL,BATTEAMOVRBALLS,BATTEAMOVRBALLS,TOTALBALLSBOWL,TOTALBALLSBOWL,BOWLERRUNS,TOTALBALLSBOWL,COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEBowlerDetailsForBallEvents *record=[[GetSEBowlerDetailsForBallEvents alloc]init];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.ECONOMY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
             
                //record.BOWLERSPELL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                //record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                //record.ATWOROTW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                
                [GetBowlerDetailsArray addObject:record];
                
                
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBowlerDetailsArray;
}

-(NSMutableArray *) GetMatchUmpireDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BALLCODE{
    NSMutableArray *GetMatchUmpireDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT OMU1.OFFICIALSCODE AS UMPIRE1CODE, OMU2.OFFICIALSCODE AS UMPIRE2CODE, OMU1.NAME AS UMPIRE1NAME, OMU2.NAME AS UMPIRE2NAME FROM BALLEVENTS BALL INNER JOIN OFFICIALSMASTER OMU1 ON OMU1.OFFICIALSCODE = BALL.UMPIRE1CODE INNER JOIN OFFICIALSMASTER OMU2 ON OMU2.OFFICIALSCODE = BALL.UMPIRE2CODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BALLCODE = '%@'", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEUmpireDetailsForBallEvents *record=[[GetSEUmpireDetailsForBallEvents alloc]init];
                record.UMPIRE1CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.UMPIRE2CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.UMPIRE1NAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.UMPIRE2NAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [GetMatchUmpireDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetMatchUmpireDetailsArray;
}

-(NSString*) GetIsInningsLastOverForBallevents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) BATTINGTEAMCODE:(NSNumber*) BATTEAMOVERS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALLCODE) AS ISINNINGSLASTOVER FROM BALLEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'  AND INNINGSNO = '%@' AND TEAMCODE = '%@'  AND OVERNO > '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,BATTEAMOVERS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *ISINNINGSLASTOVER =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);

                return ISINNINGSLASTOVER;
            }
       
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
       
        sqlite3_close(dataBase);
    }
    
    return @"";
}





-(NSMutableArray *) GetBallCodeDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BATTEAMOVERS{
    NSMutableArray *GetBallCodeDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        //, ISINNINGSLASTOVER
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT BALL.BALLCODE,BALL.OVERNO||'.'|| BALL.BALLNO AS BALLNO, BWLR.PLAYERNAME BOWLER,STRKR.PLAYERNAME STRIKER, NSTRKR.PLAYERNAME NONSTRIKER,  BT.BOWLTYPE BOWLTYPE, ST.SHOTNAME AS SHOTTYPE, BALL.TOTALRUNS, BALL.TOTALEXTRAS, BALL.OVERNO,BALL.BALLNO,BALL.BALLCOUNT,BALL.ISLEGALBALL,BALL.ISFOUR,BALL.ISSIX,BALL.RUNS,BALL.OVERTHROW, BALL.TOTALRUNS,BALL.WIDE,BALL.NOBALL,BALL.BYES,BALL.LEGBYES,BALL.TOTALEXTRAS,BALL.GRANDTOTAL,WE.WICKETNO,WE.WICKETTYPE,WE.WICKETEVENT,BALL.MARKEDFOREDIT , PTY.PENALTYRUNS, PTY.PENALTYTYPECODE, (MR.VIDEOLOCATION + '\' + BALL.VIDEOFILENAME) VIDEOFILEPATH FROM BALLEVENTS BALL INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BALL.COMPETITIONCODE AND MR.MATCHCODE = BALL.MATCHCODE INNER JOIN TEAMMASTER TM ON BALL.TEAMCODE = TM.TEAMCODE INNER JOIN PLAYERMASTER BWLR ON BALL.BOWLERCODE=BWLR.PLAYERCODE INNER JOIN PLAYERMASTER STRKR ON BALL.STRIKERCODE = STRKR.PLAYERCODE INNER JOIN PLAYERMASTER NSTRKR ON BALL.NONSTRIKERCODE = NSTRKR.PLAYERCODE LEFT JOIN BOWLTYPE BT ON BALL.BOWLTYPE = BT.BOWLTYPECODE LEFT JOIN SHOTTYPE ST ON BALL.SHOTTYPE = ST.SHOTCODE LEFT JOIN WICKETEVENTS WE ON BALL.BALLCODE = WE.BALLCODE AND WE.ISWICKET = 1 LEFT JOIN PENALTYDETAILS PTY ON BALL.BALLCODE = PTY.BALLCODE WHERE  BALL.COMPETITIONCODE='%@'  AND BALL.MATCHCODE='%@'  AND BALL.TEAMCODE='%@'  AND BALL.INNINGSNO='%@'  AND BALL.OVERNO = '%@' ORDER BY BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEBallCodeDetailsForBallEvents *record=[[GetSEBallCodeDetailsForBallEvents alloc]init];
                record.BALLCODE= [self getValueByNull: statement: 0];
                record.BALLNO=[self getValueByNull: statement:1];
                record.BOWLER=[self getValueByNull: statement:2];
                record.STRIKER=[self getValueByNull: statement:3];
                record.NONSTRIKER=[self getValueByNull: statement:4];
                record.BOWLTYPE=[self getValueByNull: statement:5];
                record.SHOTTYPE=[self getValueByNull: statement:6];
                record.TOTALRUNS=[self getValueByNull: statement:7];
                record.TOTALEXTRAS=[self getValueByNull: statement:8];
                record.OVERNO=[self getValueByNull: statement:9];
                record.BALLNO=[self getValueByNull: statement:10];
                record.BALLCOUNT=[self getValueByNull: statement:11];
                record.ISLEGALBALL=[self getValueByNull: statement:12];
                record.ISFOUR=[self getValueByNull: statement:13];
                record.ISSIX=[self getValueByNull: statement:14];
                record.RUNS=[self getValueByNull: statement:15];
                record.OVERTHROW=[self getValueByNull: statement:16];
                record.TOTALRUNS=[self getValueByNull: statement:17];
                record.WIDE=[self getValueByNull: statement:18];
                record.NOBALL=[self getValueByNull: statement:19];
                record.BYES=[self getValueByNull: statement:20];
                record.LEGBYES=[self getValueByNull: statement:21];
                record.TOTALEXTRAS=[self getValueByNull: statement:22];
                record.GRANDTOTAL=[self getValueByNull: statement:23];
                record.WICKETNO=[self getValueByNull: statement:24];
                record.WICKETTYPE=[self getValueByNull: statement:25];
                record.WICKETEVENT=[self getValueByNull: statement:26];
                record.MARKEDFOREDIT=[self getValueByNull: statement:27];
                record.PENALTYRUNS=[self getValueByNull: statement:28];
                record.PENALTYTYPECODE=[self getValueByNull: statement:29];
                record.ISINNINGSLASTOVER=[self getValueByNull: statement:30];
                record.VIDEOFILEPATH=[self getValueByNull: statement:31];
                [GetBallCodeDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBallCodeDetailsArray;
}


-(NSMutableArray *) GetSETeamDetailsForBallEventsBE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *GetSETeamDetailsForBallEventsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT BE.TEAMCODE, TM.TEAMNAM FROM BALLEVENTS BE INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE  WHERE BE.COMPETITIONCODE='%@'  AND BE.MATCHCODE='%@' GROUP BY BE.TEAMCODE,TM.TEAMNAME",COMPETITIONCODE,MATCHCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetTeamDetailsForBallEventsBE *record=[[GetTeamDetailsForBallEventsBE alloc]init];
                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [GetSETeamDetailsForBallEventsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetSETeamDetailsForBallEventsArray;
}

-(NSMutableArray *) GetBallDetailsForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) BALLCODE{
    NSMutableArray *GetBallDetailsForBallEventsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT  BALL.BALLCODE, BALL.COMPETITIONCODE, BALL.MATCHCODE, BALL.TEAMCODE, BALL.INNINGSNO, BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT, BALL.SESSIONNO, BALL.STRIKERCODE, BALL.NONSTRIKERCODE, BALL.BOWLERCODE, BALL.WICKETKEEPERCODE, BALL.UMPIRE1CODE, BALL.UMPIRE2CODE, BALL.ATWOROTW, BALL.BOWLINGEND, BALL.BOWLTYPE AS BOWLTYPECODE, BT.BOWLTYPE, BT.BOWLERTYPE, BALL.SHOTTYPE AS SHOTCODE, ST.SHOTNAME, ST.SHOTTYPE, BALL.SHOTTYPECATEGORY, BALL.ISLEGALBALL, BALL.ISFOUR, BALL.ISSIX, BALL.RUNS, BALL.OVERTHROW, BALL.TOTALRUNS, BALL.WIDE, BALL.NOBALL, BALL.BYES, BALL.LEGBYES, BALL.PENALTY, BALL.TOTALEXTRAS, BALL.GRANDTOTAL, BALL.RBW, BALL.PMLINECODE, BALL.PMLENGTHCODE, BALL.PMSTRIKEPOINT,BALL.PMSTRIKEPOINTLINECODE, BALL.PMX1, BALL.PMY1, BALL.PMX2, BALL.PMY2, BALL.PMX3, BALL.PMY3, BALL.WWREGION, MD.METASUBCODEDESCRIPTION AS REGIONNAME,  BALL.WWX1, BALL.WWY1, BALL.WWX2, BALL.WWY2, BALL.BALLDURATION, BALL.ISAPPEAL, BALL.ISBEATEN, BALL.ISUNCOMFORT,BALL.UNCOMFORTCLASSIFCATION, BALL.ISWTB, BALL.ISRELEASESHOT, BALL.MARKEDFOREDIT,  BALL.REMARKS,MA.METASUBCODEDESCRIPTION AS BALLSPEED,MA.METADATATYPECODE AS BALLSPEEDTYPE,MA.METASUBCODE AS BALLSPEEDCODE,UN.METASUBCODEDESCRIPTION AS UNCOMFORTCLASSIFICATION,UN.METADATATYPECODE AS UNCOMFORTCLASSIFICATIONCODE,UN.METASUBCODE AS UNCOMFORTCLASSIFICATIONSUBCODE FROM BALLEVENTS BALL LEFT JOIN METADATA MD ON BALL.WWREGION = MD.METASUBCODE  LEFT JOIN BOWLTYPE BT ON BALL.BOWLTYPE = BT.BOWLTYPECODE LEFT JOIN SHOTTYPE ST ON BALL.SHOTTYPE = ST.SHOTCODE LEFT JOIN METADATA MA  ON MA.METASUBCODE = BALL.BALLSPEED LEFT JOIN METADATA UN ON BALL.UNCOMFORTCLASSIFCATION = UN.METASUBCODE  WHERE BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BALLCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetBallDetailsForBallEventsBE *record=[[GetBallDetailsForBallEventsBE alloc]init];
                record.BALLCODE=[self getValueByNull:statement :0];
                
                record.COMPETITIONCODE =[self getValueByNull:statement :1];
                
                record.MATCHCODE=[self getValueByNull:statement :2];
                record.TEAMCODE=[self getValueByNull:statement :3];
                record.INNINGSNO=[self getValueByNull:statement :4];
                record.OVERNO=[self getValueByNull:statement :5];
                record.BALLNO=[self getValueByNull:statement :6];
                record.BALLCOUNT=[self getValueByNull:statement :7];
                record.SESSIONNO=[self getValueByNull:statement :8];
                record.STRIKERCODE =[self getValueByNull:statement :9];
                record.NONSTRIKERCODE  =[self getValueByNull:statement :10];
                record.BOWLERCODE        =[self getValueByNull:statement :11];
                record.WICKETKEEPERCODE  =[self getValueByNull:statement :12];
                record.UMPIRE1CODE       =[self getValueByNull:statement :13];
                record.UMPIRE2CODE       =[self getValueByNull:statement :14];
                record.ATWOROTW          =[self getValueByNull:statement :15];
                record.BOWLINGEND        =[self getValueByNull:statement :16];
                record.BOWLTYPECODE=[self getValueByNull:statement :17];
                record.BOWLTYPE             =[self getValueByNull:statement :18];
                record.BOWLERTYPE           =[self getValueByNull:statement :19];
                record.SHOTCODE    =[self getValueByNull:statement :20];
                record.SHOTNAME             =[self getValueByNull:statement :21];
                record.SHOTTYPE             =[self getValueByNull:statement :22];
                record.SHOTTYPECATEGORY        =[self getValueByNull:statement :23];
                record.ISLEGALBALL   =[self getValueByNull:statement :24];
                record.ISFOUR        =[self getValueByNull:statement :25];
                record.ISSIX         =[self getValueByNull:statement :26];
                record.RUNS         =[self getValueByNull:statement :27];
                record.OVERTHROW     =[self getValueByNull:statement :28];
                record.TOTALRUNS     =[self getValueByNull:statement :29];
                record.WIDE          =[self getValueByNull:statement :30];
                record.NOBALL        =[self getValueByNull:statement :31];
                record.BYES          =[self getValueByNull:statement :32];
                record.LEGBYES       =[self getValueByNull:statement :33];
                record.PENALTY       =[self getValueByNull:statement :34];
                record.TOTALEXTRAS   =[self getValueByNull:statement :35];
                record.GRANDTOTAL    =[self getValueByNull:statement :36];
                record.RBW           =[self getValueByNull:statement :37];
                record.PMLINECODE   =[self getValueByNull:statement :38];
                record.PMLENGTHCODE  =[self getValueByNull:statement :39];
                record.PMSTRIKEPOINT =[self getValueByNull:statement :40];
                record.PMSTRIKEPOINTLINECODE   =[self getValueByNull:statement :41];
                record.PMX1                    =[self getValueByNull:statement :42];
                record.PMY1                    =[self getValueByNull:statement :43];
                record.PMX2                    =[self getValueByNull:statement :44];
                record.PMY2                    =[self getValueByNull:statement :45];
                record.PMX3                    =[self getValueByNull:statement :46];
                record.PMY3                    =[self getValueByNull:statement :47];
                record.WWREGION                =[self getValueByNull:statement :48];
                record.REGIONNAME              =[self getValueByNull:statement :49];
                record.WWX1                    =[self getValueByNull:statement :50];
                record.WWY1                    =[self getValueByNull:statement :51];
                record.WWX2                    =[self getValueByNull:statement :52];
                record.WWY2                    =[self getValueByNull:statement :53];
                record.BALLDURATION            =[self getValueByNull:statement :54];
                record.ISAPPEAL                =[self getValueByNull:statement :55];
                record.ISBEATEN                =[self getValueByNull:statement :56];
                record.ISUNCOMFORT             =[self getValueByNull:statement :57];
                record.UNCOMFORTCLASSIFCATION  =[self getValueByNull:statement :58];
                record.ISWTB                   =[self getValueByNull:statement :59];
                record.ISRELEASESHOT           =[self getValueByNull:statement :60];
                record.MARKEDFOREDIT           =[self getValueByNull:statement :61];
                record.REMARKS                 =[self getValueByNull:statement :62];
                record.BALLSPEED               =[self getValueByNull:statement :63];
                record.BALLSPEEDTYPE           =[self getValueByNull:statement :64];
                record.BALLSPEEDCODE           =[self getValueByNull:statement :65];
                record.UNCOMFORTCLASSIFICATION =[self getValueByNull:statement :66];
                record.UNCOMFORTCLASSIFICATIONCODE    =[self getValueByNull:statement :67];
                record.UNCOMFORTCLASSIFICATIONSUBCODE =[self getValueByNull:statement :68];
                
                [GetBallDetailsForBallEventsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBallDetailsForBallEventsArray;
}

-(NSMutableArray *) GetWicketEventDetailsForWicketEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSNumber*) BALLCODE{
    NSMutableArray *GetWicketEventDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT  WE.BALLCODE, WE.ISWICKET, WE.WICKETNO, WE.WICKETTYPE,  WE.WICKETPLAYER, WE.FIELDINGPLAYER, WE.VIDEOLOCATION,WE.WICKETEVENT  FROM WICKETEVENTS WE WHERE WE.COMPETITIONCODE='%@'  AND WE.MATCHCODE='%@'  AND WE.TEAMCODE='%@'  AND WE.INNINGSNO='%@' AND WE.BALLCODE='%@' AND ISWICKET = 1", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEWicketDetailsForWicketEvents *record=[[GetSEWicketDetailsForWicketEvents alloc]init];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.ISWICKET=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.FIELDINGPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.VIDEOLOCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.WICKETEVENT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                
                
                
                
                [GetWicketEventDetailsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketEventDetailsArray;
}

-(NSMutableArray *) GetAppealDetailsForAppealEvents:(NSNumber*) BALLCODE{
    NSMutableArray *GetAppealDetailsForAppealEventsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT	APPL.BALLCODE,(CAST(BALL.OVERNO AS NVARCHAR) +'.'+ CAST(BALL.BALLNO AS NVARCHAR)) OVERS,APPL.APPEALTYPECODE, MD1.METASUBCODEDESCRIPTION AS APPEALTYPEDES,APPL.APPEALSYSTEMCODE, MD2.METASUBCODEDESCRIPTION AS APPEALSYSTEMDES,APPL.APPEALCOMPONENTCODE, MD3.METASUBCODEDESCRIPTION AS APPEALCOMPONENTDES,APPL.UMPIRECODE,UMP.NAME AS UMPIRENAME, APPL.BATSMANCODE,PM.PLAYERNAME AS BATSMANNAME,MD5.METASUBCODEDESCRIPTION AS ISREFERREDDESC, APPL.ISREFERRED,PMBOWL.PLAYERNAME AS BOWLERNAME,MD4.METASUBCODEDESCRIPTION AS APPEALDECISIONDESC, APPL.APPEALDECISION,APPL.APPEALCOMMENTS,'F'FLAG FROM APPEALEVENTS APPL INNER JOIN METADATA MD1 ON MD1.METASUBCODE = APPL.APPEALTYPECODE LEFT JOIN METADATA MD2 ON MD2.METASUBCODE = APPL.APPEALSYSTEMCODE LEFT JOIN METADATA MD3 ON MD3.METASUBCODE = APPL.APPEALCOMPONENTCODE INNER JOIN METADATA MD4 ON MD4.METASUBCODE = APPL.APPEALDECISION INNER JOIN METADATA MD5 ON MD5.METASUBCODE = APPL.ISREFERRED INNER JOIN OFFICIALSMASTER UMP ON UMP.OFFICIALSCODE = APPL.UMPIRECODE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE = APPL.BATSMANCODE INNER JOIN BALLEVENTS BALL ON BALL.BALLCODE = APPL.BALLCODE INNER JOIN PLAYERMASTER PMBOWL ON PMBOWL.PLAYERCODE = BALL.BOWLERCODE WHERE APPL.BALLCODE = '%@'",BALLCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEAppealDetailsForAppealEvents *record=[[GetSEAppealDetailsForAppealEvents alloc]init];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.APPEALTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.APPEALTYPEDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.APPEALSYSTEMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.APPEALSYSTEMDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.APPEALCOMPONENTCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.APPEALCOMPONENTDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.UMPIRECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.UMPIRENAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.BATSMANCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.BATSMANNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.ISREFERREDDESC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.ISREFERRED=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.APPEALDECISIONDESC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.APPEALDECISION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.APPEALCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.FLAG=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                
                
                
                
                
                [GetAppealDetailsForAppealEventsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetAppealDetailsForAppealEventsArray;
}

-(NSMutableArray *) GetPenaltyDetailsForPenaltyEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSNumber*) BALLCODE{
    NSMutableArray *GetPenaltyDetailsForPenaltyEventsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT  PD.COMPETITIONCODE, PD.MATCHCODE, PD.INNINGSNO, PD.BALLCODE, PD.PENALTYCODE, PD.AWARDEDTOTEAMCODE, PD.PENALTYRUNS, PD.PENALTYTYPECODE, MD.METASUBCODEDESCRIPTION AS PENALTYTYPEDESCRIPTION, PD.PENALTYREASONCODE, MDR.METASUBCODEDESCRIPTION AS PENALTYREASONDESCRIPTION FROM PENALTYDETAILS PD INNER JOIN METADATA MD ON PD.PENALTYTYPECODE = MD.METASUBCODE INNER JOIN METADATA MDR ON PD.PENALTYREASONCODE = MDR.METASUBCODE WHERE PD.COMPETITIONCODE = '%@'  AND PD.MATCHCODE = '%@' AND PD.INNINGSNO = '%@' AND PD.BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                GetSEPenaltyDetailsForPenaltyEvents *record=[[GetSEPenaltyDetailsForPenaltyEvents alloc]init];
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.PENALTYCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.AWARDEDTOTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.PENALTYRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.PENALTYTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.PENALTYTYPEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.PENALTYREASONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.PENALTYREASONDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                
                
                
                [GetPenaltyDetailsForPenaltyEventsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetPenaltyDetailsForPenaltyEventsArray;
}


-(NSMutableArray *) GetSpinSpeedBallDetailsForMetadata{
    NSMutableArray *GetSpinSpeedBallDetailsForMetadataArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT * FROM METADATA MD WHERE MD.METADATATYPECODE='MDT054'"];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSESpinBallSpeedDetails *record=[[GetSESpinBallSpeedDetails alloc]init];
                record.METASUBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.METADATATYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.METADATATYPEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.METASUBCODEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                
                
                
                
                [GetSpinSpeedBallDetailsForMetadataArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetSpinSpeedBallDetailsForMetadataArray;
}


-(NSMutableArray *) GetFastSpeedBallDetailsForMetadata{
    NSMutableArray *GetFastSpeedBallDetailsForMetadataArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT * FROM METADATA MD WHERE MD.METADATATYPECODE='MDT055'"];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetSEFastBallSpeedDetails *record=[[GetSEFastBallSpeedDetails alloc]init];
                record.METASUBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.METADATATYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.METADATATYPEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.METASUBCODEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                
                
                
                
                [GetFastSpeedBallDetailsForMetadataArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetFastSpeedBallDetailsForMetadataArray;
}



-(NSMutableArray *) getFieldingFactorDetails:(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) BALLCODE{
    NSMutableArray *fieldingFactorArray =[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        //FE.BALLCODE,BE.OVERNO,BE.BALLNO,(CONVERT(NVARCHAR,BE.OVERNO)+'.'+CONVERT(NVARCHAR,BE.BALLNO)) AS [OVER],
        
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT FE.FIELDERCODE, PM.PLAYERNAME AS FIELDERNAME,FE.FIELDINGFACTORCODE AS FIELDINGEVENTSCODE,FF.FIELDINGFACTOR AS FIELDINGEVENTS,FE.NRS AS NETRUNS, 'F' AS FLAG FROM FIELDINGEVENTS FE INNER JOIN BALLEVENTS BE ON FE.BALLCODE = BE.BALLCODE INNER JOIN FIELDINGFACTOR FF ON FE.FIELDINGFACTORCODE = FF.FIELDINGFACTORCODE INNER JOIN PLAYERMASTER PM ON FE.FIELDERCODE = PM.PLAYERCODE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.TEAMCODE = '%@' AND BE.BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                [fieldingFactorArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                [fieldingFactorArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
                [fieldingFactorArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                [fieldingFactorArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                [fieldingFactorArray addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return fieldingFactorArray;
}





@end
