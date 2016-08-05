//
//  DBManagerFollowOn.m
//  CAPScoringApp
//
//  Created by mac on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerFollowOn.h"
#import "FollowOnRecords.h"

@implementation DBManagerFollowOn

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






//SP_FETCHFOLLOWON

-(NSMutableArray *) GetteamDetailsForFetchFollowOn:(NSString*) MATCHCODE:(NSString*) TEAMCODE

{
    NSMutableArray *GetSessionEventDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TM.TEAMCODE,TM.TEAMNAME   FROM MATCHTEAMPLAYERDETAILS MTPD INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MTPD.TEAMCODE   WHERE MATCHCODE ='%@' AND TM.TEAMCODE='%@' GROUP BY TM.TEAMCODE,TM.TEAMNAME",MATCHCODE,TEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FollowOnRecords *record=[[FollowOnRecords alloc]init];
                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                

                [GetSessionEventDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetSessionEventDetails;
}


-(NSString*) GetFollowonForFetchFollowOn:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO {
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE MATCHCODE ='%@' AND INNINGSNO='%@'-1",MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *isFollowOn = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return isFollowOn;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);

        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    
    
}




//SP_FETCHTEAMNAMESELECTIONCHANGED-----------------------------------------------------------------

-(NSString*)GetOppositeTeamCodeForFetchTeamNameSelectionChanged: (NSString*) MATCHCODE:(NSString*)TEAMNAME {
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT TEAMCODE FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE='%@' AND TEAMCODE <>'%@' GROUP BY TEAMCODE",MATCHCODE,TEAMNAME];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSMutableArray *)GetSelectionBattingTeamForFetchTeamNameSelectionChanged:(NSString*) MATCHCODE:(NSString*) TEAMCODE

{
    NSMutableArray *GetSessionEventDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS MTPD  INNER JOIN PLAYERMASTER PM  ON PM.PLAYERCODE = MTPD.PLAYERCODE  WHERE MATCHCODE = '%@'  AND TEAMCODE = '%@' ",MATCHCODE,TEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FollowOnRecords *record=[[FollowOnRecords alloc]init];
            record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [GetSessionEventDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetSessionEventDetails;
}

-(NSMutableArray *)GetOppositeBowlingTeamForFetchTeamNameSelectionChanged: (NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE

{
    NSMutableArray *GetSessionEventDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME FROM MATCHREGISTRATION MR  INNER JOIN MATCHTEAMPLAYERDETAILS MPD  ON MR.MATCHCODE = MPD.MATCHCODE  INNER JOIN COMPETITION COM ON COM.COMPETITIONCODE = MR.COMPETITIONCODE  INNER JOIN TEAMMASTER TMA  ON MPD.MATCHCODE = '%@'  AND MPD.TEAMCODE = '%@'  AND MPD.TEAMCODE = TMA.TEAMCODE  INNER JOIN PLAYERMASTER PM  ON MPD.PLAYERCODE = PM.PLAYERCODE  WHERE MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE = '%@' THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END)  --AND PM.BOWLINGSTYLE IN ('MSC131','MSC132')--MSC131-Right Arm,MSC132-Left Arm  AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))",MATCHCODE,BOWLINGTEAMCODE,BOWLINGTEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FollowOnRecords *record=[[FollowOnRecords alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [GetSessionEventDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetSessionEventDetails;
}

-(NSMutableArray *)GetStrickerDetailForFetchTeamNameSelectionChanged: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME : (NSNumber*) INNINGSNO

{
    NSMutableArray *GetSessionEventDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STRIKERCODE,NONSTRIKERCODE,BOWLERCODE FROM INNINGSEVENTS IE  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'+1",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FollowOnRecords *record=[[FollowOnRecords alloc]init];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [GetSessionEventDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetSessionEventDetails;
}


//SP_UPDATEFOLLOWON----------------------------------------------------------------------
-(BOOL) GetBallCodeForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSString*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%@",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
        
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





-(NSString*) GetTeamNamesForUpdateFollowOn :(NSNumber*) TEAMNAME {
    
   
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT TEAMNAME FROM TEAMMASTER WHERE TEAMCODE='%@'",TEAMNAME];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
}
    return 0;
    
    
}

-(NSString*) GetTotalRunsForUpdateFollowOn :(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSString*) INNINGSNO {
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%@",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSString*)  GetOverNoForUpdateFollowOn :(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSString*) INNINGSNO{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MAX(OVERNO) AS MAXOVER  FROM BALLEVENTS   WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    
    sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSString*)  GetBallNoForUpdateFollowOn : (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE :(NSString*) TEAMNAME : (NSString*) INNINGSNO : (NSString*) OVERNO
{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) AS BALLNO FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO=%@",COMPETITIONCODE,MATCHCODE,TEAMNAME,OVERNO,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSString *) GetOverStatusForUpdateFollowOn :(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO:(NSString*) OVERNO{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO,OVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }

    sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSString *) GetBowlingTeamCodeForUpdateFollowOn :(NSString*) COMPETITIONCODE:(NSString*) TEAMNAME: (NSString*) MATCHCODE{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT(CASE WHEN TEAMACODE = '%@' THEN TEAMBCODE ELSE TEAMACODE END) as TeamCode FROM MATCHREGISTRATION  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  ",TEAMNAME,COMPETITIONCODE,MATCHCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }

    sqlite3_close(dataBase);
    }
    return 0;
    
    
}


-(NSString*)  GetWicketForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSString*) INNINGSNO{
    
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
   
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALLCODE) AS EXTRAWICKETCOUNT  FROM   WICKETEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%@",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamCode;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
    
    
}


-(BOOL) UpdatInningsEventForInsertScoreBoard:(NSString*) TEAMNAME:(NSString*) TOTALRUN :(NSNumber*) OVERBALLNO	:(NSString*) WICKETS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSString*) TEAMNAME {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET     BATTINGTEAMCODE='%@',TOTALRUNS='%@', TOTALOVERS='%@', TOTALWICKETS='%@', INNINGSSTATUS = 1,      ISFOLLOWON=0 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND TEAMCODE  = '%@'",TEAMNAME,TOTALRUN , OVERBALLNO, WICKETS,COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMNAME];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
}






-(BOOL) GetTeamCodeForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSString*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' and MATCHCODE='%@' AND TEAMCODE='%@'  AND INNINGSNO=%@+1 AND ISFOLLOWON='1'",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
        
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


-(BOOL) InsertInningsEventForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSString*) INNINGSNO :(NSString*) STRIKER:(NSString*) NONSTRIKER :(NSString*) BOWLER{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO INNINGSEVENTS (COMPETITIONCODE,  MATCHCODE, TEAMCODE, INNINGSNO, INNINGSSTARTTIME, INNINGSENDTIME, STRIKERCODE,  NONSTRIKERCODE, BOWLERCODE, CURRENTSTRIKERCODE, CURRENTNONSTRIKERCODE, CURRENTBOWLERCODE,   BATTINGTEAMCODE, TOTALRUNS, TOTALOVERS, TOTALWICKETS, ISDECLARE, ISFOLLOWON,   INNINGSSTATUS)   VALUES ('%@', '%@','%@',  %@+1,'','','%@','%@', '%@', '%@','%@','%@', '%@','', '', '',0,1,   0 ) ",COMPETITIONCODE, MATCHCODE,TEAMNAME,INNINGSNO,STRIKER,NONSTRIKER,BOWLER,STRIKER,NONSTRIKER,BOWLER,TEAMNAME];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
}




-(BOOL)UpdateInningsEventForInsertScoreBoard:(NSString*) TEAMCODE:(NSString *)TOTALRUNS:(NSString*)TOTALOVERS:(NSString *)TOTALWICKETS:(NSString *) INNINGSSTATUS:(NSString*) ISFOLLOWON:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString*)INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET BATTINGTEAMCODE='%@', TOTALRUNS='%@', TOTALOVERS='%@', TOTALWICKETS='%@',INNINGSSTATUS ='%@',ISFOLLOWON='%@' WHERE COMPETITIONCODE ='%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND TEAMCODE  = '%@'",TEAMCODE,TOTALRUNS, TOTALOVERS,TOTALWICKETS,INNINGSSTATUS,ISFOLLOWON,COMPETITIONCODE,MATCHCODE,INNINGSNO,TEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
}





-(BOOL)UpdateInningsEventInStrickerForInsertScoreBoard:(NSString*) STRIKER:(NSString*) NONSTRIKER :(NSString*) BOWLERCODE:(NSString*) TEAMCODE: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET STRIKERCODE='%@',   NONSTRIKERCODE='%@',BOWLERCODE='%@',CURRENTSTRIKERCODE='%@', CURRENTNONSTRIKERCODE='%@',   CURRENTBOWLERCODE='%@', BATTINGTEAMCODE='%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@+1 AND TEAMCODE  = '%@'",STRIKER,NONSTRIKER,BOWLERCODE,STRIKER,NONSTRIKER,BOWLERCODE,TEAMCODE,COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
}

//SP_DELETEREVERTFOLLOWON
-(NSString *)  GetBallCodeForDeleteFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'  AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);

            
        }
      
            sqlite3_close(dataBase);
        
    }

    return @"";
}



-(BOOL) UpdateInningsEventForDeleteFollowOn: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS  SET   INNINGSSTATUS = 0  WHERE    COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'     AND INNINGSNO = '%@'-1  ",COMPETITIONCODE, MATCHCODE,INNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
}
-(BOOL) DeleteInningsEventForDeleteFollowOn: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM INNINGSEVENTS   WHERE   COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'   AND INNINGSNO = '%@'  ",COMPETITIONCODE, MATCHCODE,INNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
}






@end
