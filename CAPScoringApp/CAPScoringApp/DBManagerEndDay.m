//
//  DBManagerEndDay.m
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerEndDay.h"
#import "InsertEndDay.h"
#import "DeleteEndDay.h"
#import "FetchEndDayDetails.h"
#import "UpdateEndDay.h"
#import "FetchEndDay.h"






@implementation DBManagerEndDay

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";


//Copy database to application document
-(void) copyDatabaseIfNotExist{
    
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



//SP_UPDATEENDDAY
-(NSString*) GetStartTimeForDayEvents:(NSString*) ENDTIMEFORMAT:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STARTTIME FROM DAYEVENTS WHERE  strftime('%%Y-%%m-%%d %%H:%%M:%%S',ENDTIME) ='%@' AND COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO!='%@'",ENDTIMEFORMAT,COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *STARTTIME =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return STARTTIME;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(BOOL) UpdateDayEventsForEndDay:(NSString*) STARTTIME:(NSString*) ENDTIME:(NSString*) COMMENTS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE DAYEVENTS SET STARTTIME = '%@',ENDTIME = '%@',COMMENTS = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND DAYNO = '%@'",STARTTIME,ENDTIME,COMMENTS,COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return NO;
    
}

-(NSMutableArray*) GetDayEventsForUpdateEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *UpdateEndDayArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DE.STARTTIME,DE.ENDTIME,julianday(DE.ENDTIME) - julianday(DE.STARTTIME) AS DURATION,TM.TEAMNAME AS  TEAMNAME,DAYNO,INNINGSNO,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DE.BATTINGTEAMCODE FROM	DAYEVENTS DE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=DE.BATTINGTEAMCODE WHERE DE.COMPETITIONCODE='%@' AND DE.MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                UpdateEndDay *SetUpdateEndDay=[[UpdateEndDay alloc]init];
                SetUpdateEndDay.STARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                SetUpdateEndDay.ENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                SetUpdateEndDay.DURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                SetUpdateEndDay.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                SetUpdateEndDay.DAYNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                SetUpdateEndDay.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                SetUpdateEndDay.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                SetUpdateEndDay.TOTALOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                SetUpdateEndDay.TOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                SetUpdateEndDay.COMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                SetUpdateEndDay.BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                [UpdateEndDayArray addObject:SetUpdateEndDay];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return UpdateEndDayArray;
}

//SP_DELETEENDDAY

-(NSString*) GetBallCodeForDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND DAYNO='%@'+1",COMPETITIONCODE,MATCHCODE,DAYNO];
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
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(BOOL) GetDayEventsForDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *selectQry = [NSString stringWithFormat:@"SELECT * FROM DAYEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND DAYNO='%@'+1",COMPETITIONCODE,MATCHCODE,DAYNO];
        
        const char *selectStmt = [selectQry UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
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

-(BOOL) DeleteDayEventsForDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *selectQry = [NSString stringWithFormat:@"DELETE FROM DAYEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND DAYNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO];
        
        const char *selectStmt = [selectQry UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
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


-(NSMutableArray *) GetDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *DeleteEndDayArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DE.STARTTIME,DE.ENDTIME,julianday(DE.ENDTIME) - julianday(DE.STARTTIME) AS DURATION,TM.TEAMNAME AS  TEAMNAME,DAYNO,INNINGSNO,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DE.BATTINGTEAMCODE FROM	DAYEVENTS DE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=DE.BATTINGTEAMCODE WHERE DE.COMPETITIONCODE='%@' AND DE.MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                DeleteEndDay *SetDeleteEndDay=[[DeleteEndDay alloc]init];
                SetDeleteEndDay.STARTTIME=[self getValueByNull:statement :0];
                SetDeleteEndDay.ENDTIME=[self getValueByNull:statement :1];
                SetDeleteEndDay.DURATION=[self getValueByNull:statement :2];
                SetDeleteEndDay.TEAMNAME=[self getValueByNull:statement :3];
                SetDeleteEndDay.DAYNO=[self getValueByNull:statement :4];
                SetDeleteEndDay.INNINGSNO=[self getValueByNull:statement :5];
                SetDeleteEndDay.TOTALRUNS=[self getValueByNull:statement :6];
                SetDeleteEndDay.TOTALOVERS=[self getValueByNull:statement :7];
                SetDeleteEndDay.TOTALWICKETS=[self getValueByNull:statement :8];
                SetDeleteEndDay.COMMENTS=[self getValueByNull:statement :9];
                SetDeleteEndDay.BATTINGTEAMCODE=[self getValueByNull:statement :10];
                [DeleteEndDayArray addObject:SetDeleteEndDay];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return DeleteEndDayArray;
}


//SP_FETCHENDDAYDETAILS
-(NSString*) GetIsDayNightForFetchEndDay:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISDAYNIGHT FROM   MATCHREGISTRATION WHERE  MATCHCODE='%@'",MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *ISDAYNIGHT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return ISDAYNIGHT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetTeamNameForFetcHEndDay:(NSString*) TEAMCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMNAME FROM TEAMMASTER WHERE TEAMCODE='%@'",TEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TEAMNAME =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return TEAMNAME;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetDayNoForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO AS DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
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
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMaxDayNoForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(DAYNO)+1 AS DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND DAYSTATUS='1'",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *DAYNO =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return DAYNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMaxDayNoForFetchEndDayDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(DAYNO) AS DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *DAYNO =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return DAYNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}


-(NSString*) GetPenaltyRunsForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) TEAMCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  IFNULL(SUM(PENALTYRUNS),0) AS PENALTYRUNS FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO IN ('%@', '%@' - 1)AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE IS NULL OR INNINGSNO < '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,INNINGSNO,TEAMCODE,INNINGSNO];
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
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetRunsForFetchEndDay:(NSNumber*) INNINGSNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL) ,0) AS RUNS FROM BALLEVENTS WHERE INNINGSNO='%@' AND COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND DAYNO='%@'",INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *RUNS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return RUNS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMinOverForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSNumber*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MIN(OVERNO) AS MINOVER	FROM BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MINOVER =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MINOVER;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMinBallNoForFetcHEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) MINOVERNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MIN(BALLNO) AS MINBALLNO FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,MINOVERNO,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MINBALLNO =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MINBALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}


-(NSString*) GetMaxOverForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSNumber*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(OVERNO) AS MAXOVER FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MAXOVER =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MAXOVER;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMaxBallNoForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) OVERNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(BALLNO) AS BALLNO FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,OVERNO,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLNO = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetBallEventsForFetchEndDay:(NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSNumber*) INNINGSNO:(NSString*) MINOVERBALL:(NSString*) MAXOVERBALL{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  COUNT(1) FROM BALLEVENTS AS TOTALOVERS WHERE MATCHCODE='%@' and COMPETITIONCODE='%@' AND INNINGSNO='%@' AND ISLEGALBALL=1 AND CAST((CAST(OVERNO AS NVARCHAR(3))+'.'+CAST(BALLNO AS NVARCHAR(3))) AS FLOAT)BETWEEN '%@' AND '%@'",MATCHCODE,COMPETITIONCODE,INNINGSNO,MINOVERBALL,MAXOVERBALL];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TOTALOVERS =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return TOTALOVERS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetWicketsCountForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSNumber*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(WKT.BALLCODE) AS EXTRAWICKETCOUNT FROM BALLEVENTS BALL LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE WHERE  BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALL.TEAMCODE='%@' AND BALL.INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *EXTRAWICKETCOUNT =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return EXTRAWICKETCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}


-(NSMutableArray *) GetFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *FetchEndDayArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  DE.STARTTIME,DE.ENDTIME, ((strftime('%%s',DE.ENDTIME) - strftime('%%s',DE.STARTTIME)) / 60) AS DURATION,TM.TEAMNAME AS  TEAMNAME,DAYNO,INNINGSNO,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DE.BATTINGTEAMCODE FROM	DAYEVENTS DE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=DE.BATTINGTEAMCODE WHERE DE.COMPETITIONCODE='%@' AND DE.MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchEndDay *SetFetchEndDay=[[FetchEndDay alloc]init];
                SetFetchEndDay.STARTTIME=[self getValueByNull:statement :0];
                SetFetchEndDay.ENDTIME=[self getValueByNull:statement :1];
                SetFetchEndDay.DURATION=[self getValueByNull:statement :2];
                SetFetchEndDay.TEAMNAME=[self getValueByNull:statement :3];
                SetFetchEndDay.DAYNO=[self getValueByNull:statement :4];
                SetFetchEndDay.INNINGSNO=[self getValueByNull:statement :5];
                SetFetchEndDay.TOTALRUNS=[self getValueByNull:statement :6];
                SetFetchEndDay.TOTALOVERS=[self getValueByNull:statement :7];
                SetFetchEndDay.TOTALWICKETS=[self getValueByNull:statement :8];
                SetFetchEndDay.COMMENTS=[self getValueByNull:statement :9];
                SetFetchEndDay.BATTINGTEAMCODE=[self getValueByNull:statement :10];
                [FetchEndDayArray addObject:SetFetchEndDay];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return FetchEndDayArray;
}


-(NSMutableArray *) GetMatchDateForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *FetchEndDayDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DE.STARTTIME,DE.ENDTIME,julianday(DE.ENDTIME) - julianday(DE.STARTTIME) AS DURATION,TM.TEAMNAME AS  TEAMNAME,DAYNO,INNINGSNO,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DE.BATTINGTEAMCODE FROM	DAYEVENTS DE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=DE.BATTINGTEAMCODE WHERE DE.COMPETITIONCODE='%@' AND DE.MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchEndDayDetails *SetFetchEndDayDetails=[[FetchEndDayDetails alloc]init];
                SetFetchEndDayDetails.STARTDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                SetFetchEndDayDetails.DAYNIGHT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [FetchEndDayDetailsArray addObject:SetFetchEndDayDetails];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return FetchEndDayDetailsArray;
}

//SP_INSERTENDDAY

-(NSString*) GetMatchTypeForInserTEndDay:(NSString*) COMPETITIONCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHTYPE FROM COMPETITION where COMPETITIONCODE = '%@'",COMPETITIONCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MATCHTYPE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MATCHTYPE ;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMaxSessionNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(SESSIONNO) AS SESSIONNO FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *SESSIONNO =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return SESSIONNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMinOverNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MIN(OVERNO) AS STARTOVER FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,SESSIONNO,INNINGSNO,DAYNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *STARTOVER =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return STARTOVER;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMinBallNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSNumber*) STARTOVERNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MIN(BALLNO) AS STARTOVERBALLNO FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,SESSIONNO,INNINGSNO,STARTOVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *STARTOVERBALLNO = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return STARTOVERBALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetMaxOverNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(OVERNO) AS ENDOVER FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,SESSIONNO,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *ENDOVER =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return ENDOVER;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}


-(NSString*) GetMaxBallNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSString*)ENDOVERNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(BALLNO) AS STARTOVERBALLNO FROM  BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,SESSIONNO,INNINGSNO,ENDOVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *STARTOVERBALLNO = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return STARTOVERBALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}


-(NSString*) GetOverStatusForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) ENDOVERNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,ENDOVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OVERSTATUS =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return OVERSTATUS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}


-(NSString*) GetRunsScoredForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  IFNULL(SUM(GRANDTOTAL) ,0) AS RUNSSCORED FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@' AND DAYNO='%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,SESSIONNO,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *RUNSSCORED =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return RUNSSCORED;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetWicketLostForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) SESSIONNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(WKT.BALLCODE) AS EXTRAWICKETCOUNT FROM BALLEVENTS BALL LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE WHERE  BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALL.TEAMCODE='%@' AND BALL.INNINGSNO='%@' AND BALL.SESSIONNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,SESSIONNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *EXTRAWICKETCOUNT = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return EXTRAWICKETCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetDayNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) DAYNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND BATTINGTEAMCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,DAYNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *DAYNO =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return DAYNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}


-(NSString*) GetStartTimeForInsertEndDay:(NSString*) STARTTIMEFORMAT:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STARTTIME FROM DAYEVENTS WHERE  strftime('%%Y-%%m-%%d %%H:%%M:%%S',STARTTIME) ='%@' AND COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND BATTINGTEAMCODE='%@'",STARTTIMEFORMAT,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *STARTTIME =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return STARTTIME;
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(BOOL) SetDayEventsForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) STARTTIME:(NSString*) ENDTIME:(NSString*) DAYNO:(NSString*) BATTINGTEAMCODE:(NSString*) TOTALRUNS:(NSString*) TOTALOVERS:(NSString*) TOTALWICKETS:(NSString*) COMMENTS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO DAYEVENTS (COMPETITIONCODE,MATCHCODE,INNINGSNO,STARTTIME,ENDTIME,DAYNO,BATTINGTEAMCODE,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DAYSTATUS)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',1)",COMPETITIONCODE,MATCHCODE,INNINGSNO,STARTTIME,ENDTIME,DAYNO,BATTINGTEAMCODE,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
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

-(NSString*) GetSessionNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO:(NSString*) COUNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONNO FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@' AND SESSIONNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO,COUNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *SESSIONNO =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return SESSIONNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(BOOL) SetSessionEventsForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO:(NSString*) SESSIONNO:(NSString*) BATTINGTEAMCODE:(NSString*) STARTOVERBALLNO:(NSString*) TOTALOVERS:(NSString*) RUNSSCORED:(NSString*) WICKETLOST{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO SESSIONEVENTS(COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO,SESSIONNO,SESSIONSTARTTIME,SESSIONENDTIME,BATTINGTEAMCODE,STARTOVER,ENDOVER,TOTALRUNS,TOTALWICKETS,DOMINANTTEAMCODE,SESSIONSTATUS)VALUES('%@','%@','%@','%@','%@',NULL,NULL,'%@','%@','%@','%@','%@',NULL,0)",COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO,SESSIONNO,BATTINGTEAMCODE,STARTOVERBALLNO,TOTALOVERS,RUNSSCORED,WICKETLOST];
        
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
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return NO;
    
}

-(NSMutableArray *) InsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSMutableArray *InsertEndDayArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  DE.STARTTIME,DE.ENDTIME,((strftime('%%s',DE.ENDTIME) - strftime('%%s',DE.STARTTIME)) / 60) AS DURATION,TM.TEAMNAME AS  TEAMNAME,DAYNO,INNINGSNO,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DE.BATTINGTEAMCODE FROM	DAYEVENTS DE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=DE.BATTINGTEAMCODE WHERE DE.COMPETITIONCODE='%@' AND DE.MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                InsertEndDay *SetInsertEndDay=[[InsertEndDay alloc]init];
                SetInsertEndDay.STARTTIME=[self getValueByNull:statement :0];
                SetInsertEndDay.ENDTIME=[self getValueByNull:statement :1];
                SetInsertEndDay.DURATION=[self getValueByNull:statement :2];
                SetInsertEndDay.TEAMNAME=[self getValueByNull:statement :3];
                SetInsertEndDay.DAYNO=[self getValueByNull:statement :4];
                SetInsertEndDay.INNINGSNO=[self getValueByNull:statement :5];
                SetInsertEndDay.TOTALRUNS=[self getValueByNull:statement :6];
                SetInsertEndDay.TOTALOVERS=[self getValueByNull:statement :7];
                SetInsertEndDay.TOTALWICKETS=[self getValueByNull:statement :8];
                SetInsertEndDay.COMMENTS=[self getValueByNull:statement :9];
                SetInsertEndDay.BATTINGTEAMCODE=[self getValueByNull:statement :10];
                [InsertEndDayArray addObject:SetInsertEndDay];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return InsertEndDayArray;
}

-(NSString*) GetMaxDayNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BATTINGTEAMCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  MAX(DAYNO)+1 AS NEXTDAYO FROM DAYEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND BATTINGTEAMCODE='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *NEXTDAYO =  [self getValueByNull:statement :0];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return NEXTDAYO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}
@end
