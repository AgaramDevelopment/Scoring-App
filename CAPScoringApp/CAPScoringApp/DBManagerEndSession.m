//
//  DBManagerEndSession.m
//  CAPScoringApp
//
//  Created by deepak on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerEndSession.h"
#import "EndSessionRecords.h"

@implementation DBManagerEndSession

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


//SP_FETCHPAGELOADENDSESSIONDETAILS----------------------------------------------------------


-(NSString*)GetIsDayNightForFetchEndSession:(NSString*) MATCHCODE
    
{

    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT ISDAYNIGHT FROM MATCHREGISTRATION WHERE MATCHCODE='%@'",MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
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
    return 0;
    
}



-(BOOL)GetDayNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO AS DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' ",COMPETITIONCODE,MATCHCODE];
        
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

-(NSString*)getDayNo:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL((MAX(DAYNO)),0) AS DAYNO FROM   DAYEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND DAYSTATUS='1'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
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
    return 0;
    
}



-(NSString*)GetDayNoStatusForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE {
    
    
        int retVal;
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL((MAX(DAYNO)+1),0) AS DAYNO FROM   DAYEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND DAYSTATUS='1'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
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
        return 0;
        
    }
    


-(NSString*)GetDayNoStatusIn0ForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(DAYNO),0) AS DAYNO FROM   DAYEVENTS 	WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND DAYSTATUS='0'",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
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

-(NSNumber*) GetInningsNosForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(INNINGSNO),0) AS INNINGSNO  FROM   BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *inningsNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return inningsNo;
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSNumber*)  GetSessionNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) DAYNO{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(SESSIONNO),0) AS SESSIONNO FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND DAYNO='%@' AND SESSIONSTATUS='1'",COMPETITIONCODE,MATCHCODE,DAYNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *sessionNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return sessionNo;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
    
   
}

-(BOOL) GetOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERNO AS STARTOVER   FROM   BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND SESSIONNO='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,SESSIONNO,INNINGSNO,DAYNO];
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



-(NSString*) GetStartOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MIN(OVERNO),0) AS STARTOVER   FROM   BALLEVENTS   WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND SESSIONNO ='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,SESSIONNO,INNINGSNO,DAYNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *startOver = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return startOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    
}

-(NSString*) GetNewStartOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(ENDOVER),0) as ENDOVER  FROM	  SESSIONEVENTS  WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *endOver = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return endOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    

}


-(NSString*)  GetStartBallNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSString*) DAYNO:(NSNumber*) INNINGSNO: (NSString*) STARTOVERNO {
   
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MIN(BALLNO) AS STARTOVERBALLNO  FROM   BALLEVENTS  WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND SESSIONNO='%@' AND DAYNO='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,SESSIONNO,DAYNO,INNINGSNO,STARTOVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *endOver = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return endOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
        sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSString*) GetEndOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSString*) DAYNO:(NSNumber*) INNINGSNO{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MAX(OVERNO) AS ENDOVER FROM   BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND SESSIONNO='%@' AND DAYNO='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,SESSIONNO,DAYNO,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *maxOver = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return maxOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
}
    return 0;
    

    }

-(NSString*) GetEndBallNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSString*) DAYNO:(NSNumber*) INNINGSNO :(NSString*) ENDOVERNO{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) AS STARTOVERBALLNO  FROM   BALLEVENTS   WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND SESSIONNO='%@' AND DAYNO='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,SESSIONNO,DAYNO,INNINGSNO,ENDOVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *maxBallNo = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return maxBallNo;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);

        }
        
        sqlite3_close(dataBase);
    }
    return 0;
    
    
}

-(NSString*) GetOverStatusForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*) ENDOVERNO{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM   OVEREVENTS   WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,ENDOVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *overStatusNo = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return overStatusNo;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
}
    return 0;
    
    
}


-(NSString*) GetTeamNamesForFetchEndSession:(NSString*) BATTINGTEAMCODE{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT TEAMNAME FROM TEAMMASTER WHERE TEAMCODE='%@'",BATTINGTEAMCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamName = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamName;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    
    sqlite3_close(dataBase);
    }
    return 0;
    
    
    
}



-(NSString*)GetPenaltyRunsForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)  as PENALTYRUNS FROM   PENALTYDETAILS WHERE  COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  AND INNINGSNO IN ('%@', '%@' - 1) AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE IS NULL OR INNINGSNO < '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,INNINGSNO,BATTINGTEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamName = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamName;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    }


-(NSString*) GetRunsScoredForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSNumber*) INNINGSNO: (NSString*) DAYNO {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT  IFNULL(SUM(GRANDTOTAL) ,0) AS RUNSSCORED FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND SESSIONNO='%@'  AND INNINGSNO='%@'  AND DAYNO='%@' ",COMPETITIONCODE,MATCHCODE,SESSIONNO,INNINGSNO,DAYNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamName = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamName;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    
}

-(NSString*) GetWicketLoftForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO: (NSString*) SESSIONNO: (NSString*) DAYNO {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(WKT.BALLCODE) AS EXTRAWICKETCOUNT FROM BALLEVENTS BALL LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO  AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE=WKT.COMPETITIONCODE AND MR.MATCHCODE=WKT.MATCHCODE  AND MR.RECORDSTATUS='MSC001' WHERE  BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@'  AND BALL.INNINGSNO='%@' AND BALL.SESSIONNO = '%@' AND BALL.DAYNO='%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,SESSIONNO,DAYNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamName = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamName;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
    
    
}



-(NSMutableArray*) GetBattingTeamForFetchEndSession:(NSString *)BATTINGTEAMCODE :(NSString *)BOWLINGTEAMCODE
{
    NSMutableArray *GetBattingTeamDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat: @"SELECT TEAMCODE AS BATTINGTEAMCODE,TEAMNAME AS BATTINGTEAMNAME FROM TEAMMASTER  WHERE  TEAMCODE= '%@'UNION ALL SELECT TEAMCODE AS BATTINGTEAMCODE,TEAMNAME AS BATTINGTEAMNAME FROM TEAMMASTER  WHERE  TEAMCODE= '%@'UNION ALL SELECT METASUBCODE,METASUBCODEDESCRIPTION FROM METADATA  WHERE  METASUBCODE='MSC250'",BATTINGTEAMCODE,BOWLINGTEAMCODE];
                               
                const char *update_stmt = [updateSQL UTF8String];
         if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
           
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    EndSessionRecords *record=[[EndSessionRecords alloc]init];
                  
                        
                        record.BATTINGTEAMCODE=[self getValueByNull:statement :0];
                        record.BATTINGTEAMNAME=[self getValueByNull:statement :1];

                    
                    
                    
                    [GetBattingTeamDetails addObject:record];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
    }
    
    sqlite3_close(dataBase);
    return GetBattingTeamDetails;
}

-(NSMutableArray *) GetBattingTeamUsingBowlingCode:(NSString*) BOWLINGTEAMCODE
{
    NSMutableArray *GetBattingTeamDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat: @"SELECT TEAMCODE AS BATTINGTEAMCODE,TEAMNAME AS BATTINGTEAMNAME FROM TEAMMASTER  WHERE  TEAMCODE= '%@'",BOWLINGTEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
       
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndSessionRecords *record=[[EndSessionRecords alloc]init];
                record.BOWLINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLINGTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];

                [GetBattingTeamDetails addObject:record];
            }
            sqlite3_reset(statement);
             sqlite3_finalize(statement);
        }
    }
   
    sqlite3_close(dataBase);
    return GetBattingTeamDetails;
}

-(NSMutableArray*) GetMetaSubCode
{
    NSMutableArray *GetBattingTeamDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat: @"SELECT METASUBCODE,METASUBCODEDESCRIPTION FROM METADATA  WHERE  METASUBCODE='MSC250'"];
        
        const char *update_stmt = [updateSQL UTF8String];
       if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndSessionRecords *record=[[EndSessionRecords alloc]init];
                
                
                record.METASUBCODE=[self getValueByNull:statement :0];
                record.METADESCRIPTION=[self getValueByNull:statement :1];

                [GetBattingTeamDetails addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
    }
    
    sqlite3_close(dataBase);
    return GetBattingTeamDetails;
}



-(NSMutableArray*) GetSessionEventsForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE
                        
            {
        NSMutableArray *GetSessionEventDetails=[[NSMutableArray alloc]init];
                NSString *databasePath = [self getDBPath];
                sqlite3_stmt *statement;
                sqlite3 *dataBase;
                const char *dbPath = [databasePath UTF8String];
                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                {
                    NSString *updateSQL = [NSString stringWithFormat:@"SELECT DISTINCT SE.SESSIONSTARTTIME,SE.SESSIONENDTIME,SE.DAYNO,SE.SESSIONNO,SE.INNINGSNO, TM.TEAMNAME,TM.SHORTTEAMNAME,SE.TOTALRUNS,SE.TOTALWICKETS,(CASE WHEN SE.DOMINANTTEAMCODE='MSC253' THEN MD.METASUBCODEDESCRIPTION ELSE TM2.TEAMNAME  END) AS DOMINANTNAME, SE.STARTOVER, SE.ENDOVER,  CASE WHEN SE.STARTOVER=SE.ENDOVER	THEN  (CASE WHEN (SELECT COUNT(SESSIONNO) SESSIONNNO FROM BALLEVENTS WHERE MATCHCODE=SE.MATCHCODE AND INNINGSNO=SE.INNINGSNO AND SESSIONNO=SE.SESSIONNO AND DAYNO=SE.DAYNO) = 0 THEN '0.0' ELSE '0.1' END) ELSE CAST(((substr(SE.ENDOVER,0, instr(SE.ENDOVER,'.')) * 6 + substr(SE.ENDOVER,instr(SE.ENDOVER,'.')+1) - (substr(SE.STARTOVER,0, instr(SE.STARTOVER,'.')) * 6 + substr(SE.STARTOVER,instr(SE.STARTOVER,'.')+1)) + 1) / 6) AS TEXT) + '.' + CAST(((substr(SE.ENDOVER,0, instr(SE.ENDOVER,'.')) * 6 + substr(SE.ENDOVER,instr(SE.ENDOVER,'.')+1)) - (substr(SE.STARTOVER,0, instr(SE.STARTOVER,'.')) * 6 + substr(SE.STARTOVER,instr(SE.STARTOVER,'.')+1)) + 1) / 6 AS TEXT) END AS SESSIONOVER, CAST((julianday(SE.SESSIONSTARTTIME) - julianday(SE.SESSIONENDTIME)) as TEXT)+' Mins' AS DURATION FROM  SESSIONEVENTS SE INNER JOIN TEAMMASTER TM ON SE.BATTINGTEAMCODE = TM.TEAMCODE LEFT JOIN BALLEVENTS BE ON SE.COMPETITIONCODE = BE.COMPETITIONCODE AND SE.MATCHCODE = BE.MATCHCODE AND SE.INNINGSNO = BE.INNINGSNO AND SE.BATTINGTEAMCODE = BE.TEAMCODE AND SE.DAYNO = BE.DAYNO AND SE.SESSIONNO = BE.SESSIONNO LEFT OUTER JOIN TEAMMASTER TM2 ON TM2.TEAMCODE = SE.DOMINANTTEAMCODE LEFT JOIN METADATA MD ON MD.METASUBCODE=SE.DOMINANTTEAMCODE WHERE SE.COMPETITIONCODE = '%@' AND SE.MATCHCODE = '%@' ORDER BY SE.DAYNO,SE.SESSIONNO",COMPETITIONCODE,MATCHCODE];
                                           
                    const char *update_stmt = [updateSQL UTF8String];
                   if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
                    {
                    while(sqlite3_step(statement)==SQLITE_ROW){
                        EndSessionRecords *record=[[EndSessionRecords alloc]init];
                        
                        record.SESSIONSTARTTIME=[self getValueByNull:statement :0];
                        record.SESSIONENDTIME=[self getValueByNull:statement :1];
                        record.DAYNO=[self getValueByNull:statement :2];
                        record.SESSIONNO=[self getValueByNull:statement :3];
                        record.INNINGSNO=[self getValueByNull:statement :4];
                        record.TEAMNAME=[self getValueByNull:statement :5];
                         record.SHORTTEAMNAME=[self getValueByNull:statement :6];
                        record.TOTALRUNS=[self getValueByNull:statement :7];
                        record.TOTALWICKETS=[self getValueByNull:statement :8];
                        record.DOMINANTNAME=[self getValueByNull:statement :9];
                        record.STARTOVER=[self getValueByNull:statement :10];
                        record.ENDOVER=[self getValueByNull:statement :11];
                        record.SESSIONOVER=[self getValueByNull:statement :12];
                        record.DURATION=[self getValueByNull:statement :13];
                        
                        
                        
                        [GetSessionEventDetails addObject:record];
                    }
                        sqlite3_reset(statement);
                        sqlite3_finalize(statement);
                        }
                    }
         
                sqlite3_close(dataBase);
            return GetSessionEventDetails;
        }
                                           

-(NSString*) GetStartDateForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE {
   
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MATCHDATE AS STARTDATE FROM	MATCHREGISTRATION WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *teamName = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return teamName;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
    
    
    }
                                           




-(NSMutableArray*)getSessionDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE

{
    NSMutableArray *getSession=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONSTARTTIME,SESSIONENDTIME,INNINGSNO,DAYNO,SESSIONNO FROM SESSIONEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
       if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndSessionRecords *record=[[EndSessionRecords alloc]init];
                record.SESSIONSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.SESSIONENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.DAYNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.SESSIONNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                [getSession addObject:record];
            }
            sqlite3_reset(statement);
             sqlite3_finalize(statement);
        }
    }
   
    sqlite3_close(dataBase);
    
    return getSession;
}




-(NSMutableArray*)GetDateDayWiseForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE

    {
        NSMutableArray *GetDateDayWiseDetails=[[NSMutableArray alloc]init];
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT STARTTIME,ENDTIME,INNINGSNO,DAYNO FROM DAYEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' ",COMPETITIONCODE,MATCHCODE];
                                   
                const char *update_stmt = [updateSQL UTF8String];
     if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    EndSessionRecords *record=[[EndSessionRecords alloc]init];
                    record.SESSIONSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    record.SESSIONENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    record.DAYNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    
                    
                    
                    
                    [GetDateDayWiseDetails addObject:record];
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
        }

    sqlite3_close(dataBase);
    return GetDateDayWiseDetails;
    }
                                   
   
//SP_INSERTENDSESSION----------------------------------------------------------------------

-(NSString*)  GetMatchTypeForInsertEndSession :(NSString*) COMPETITIONCODE{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MATCHTYPE FROM COMPETITION WHERE  COMPETITIONCODE = '%@'",COMPETITIONCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *matchType = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return matchType;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }

    sqlite3_close(dataBase);
    }
    return 0;
    
    
}


-(NSString*)  GetWicketsForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSNumber*) INNINGSNO {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
NSString *query=[NSString stringWithFormat:@"SELECT COUNT(WKT.BALLCODE) AS EXTRAWICKETCOUNT FROM   BALLEVENTS BALL  LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE WHERE  BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALL.TEAMCODE='%@' AND BALL.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *wicket = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return wicket;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
        sqlite3_close(dataBase);
    }
    return 0;
    
}


-(NSString*)  GetPenaltyRunsForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) TEAMCODE {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) AS PENALTYRUNS  FROM PENALTYDETAILS  WHERE   COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO IN ('%@', '%@' - 1)  AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE IS NULL OR INNINGSNO < '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,INNINGSNO,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *penalty = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return penalty;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
    
}



-(NSString*)  GetRunsForInsertEndSession:(NSString*) INNINGSNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL) ,0) AS RUNS FROM   BALLEVENTS 	WHERE  INNINGSNO= '%@' AND COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'",INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *grandTotal = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return grandTotal;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
    
   }


-(NSString*)  GetOverNoForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSNumber*) INNINGSNO {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MAX(OVERNO) AS MAXOVER FROM BALLEVENTS  WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *maxOver =[self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return maxOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
   
    sqlite3_close(dataBase);
}
    return 0;
}


-(NSString*)  GetBallNoForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) OVERNO:(NSNumber*) INNINGSNO {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) AS BALLNO FROM   BALLEVENTS  WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,OVERNO,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *maxOver = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return maxOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;

}

-(NSString*) GetOverStatusForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSNumber*) INNINGSNO: (NSString*) OVERNO {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM   OVEREVENTS  WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'  GROUP BY OVERSTATUS ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *maxOver = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return maxOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
    
}

-(NSString*)  GetOversPlayedForInsertEndSession:(NSString*) INNINGSNO:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) TEAMCODE {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
         
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *query=[NSString stringWithFormat:@"SELECT MAX(GRANDTOTAL) AS RUNS  FROM   BALLEVENTS  WHERE  INNINGSNO='%@' AND COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'",INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *maxOver = [self getValueByNull:statement :0];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return maxOver;
            
            
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
   
    sqlite3_close(dataBase);
}
    return 0;
    

}


-(BOOL) GetSessionStartTimeForInsertEndSession:(NSString*) DAYNO:(NSString*) MATCHCODE: (NSString*) CHECKSTARTDATE {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONSTARTTIME FROM SESSIONEVENTS WHERE DAYNO!='%@' AND MATCHCODE='%@' AND strftime('%%s',SESSIONSTARTTIME)='%@'",DAYNO,MATCHCODE,CHECKSTARTDATE];
        
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



-(BOOL) GetCompetitionCodeForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) TEAMCODE {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND TEAMCODE='%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,TEAMCODE];
        
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



-(BOOL) GetDayNoInNotExistsForInsertEndSession:(NSString*) SESSIONSTARTTIME:(NSString*) SESSIONENDTIME :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO: (NSString*) DAYNO {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO FROM DAYEVENTS WHERE((((strftime('%%s','%@'))<STARTTIME AND ('%@')> (strftime('%%s',STARTTIME))) OR ((strftime('%%s','%@'))<ENDTIME AND ('%@')> (strftime('%%s',ENDTIME))) OR ((strftime('%%s','%@'))<STARTTIME AND ('%@') > (strftime('%%s',ENDTIME)))) AND COMPETITIONCODE = '%@' AND MATCHCODE='%@'  AND INNINGSNO = '%@' AND DAYNO='%@')",SESSIONSTARTTIME,SESSIONENDTIME,SESSIONSTARTTIME,SESSIONENDTIME,SESSIONSTARTTIME,SESSIONENDTIME,COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO];
        
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


-(BOOL) GetSessionNoForInsertEndSession:(NSString*) SESSIONSTARTTIME:(NSString*) SESSIONENDTIME :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE  {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONNO  FROM   SESSIONEVENTS 	WHERE (((strftime('%%s','%@'))<=SESSIONSTARTTIME AND ('%@')>= (strftime('%%s',SESSIONSTARTTIME))) OR ((strftime('%%s','%@'))<=SESSIONENDTIME AND ('%@')>= (strftime('%%s',SESSIONENDTIME))) OR ((strftime('%%s','%@'))>=SESSIONSTARTTIME AND ('%@')<= (strftime('%%s',SESSIONENDTIME)))) AND COMPETITIONCODE = '%@' AND MATCHCODE='%@'",SESSIONSTARTTIME,SESSIONENDTIME,SESSIONSTARTTIME,SESSIONENDTIME,SESSIONSTARTTIME,SESSIONENDTIME,COMPETITIONCODE,MATCHCODE];
        
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


-(BOOL)  GetCompetitionCodeInNotExistsForInsertEndSession:COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO: (NSString*) SESSIONNO: (NSString*) DAYNO  {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
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




-(BOOL) InsertSessionEventForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) SESSIONNO:(NSString*) STARTTIME : (NSString*) ENDTIME:(NSString*) TEAMCODE: (NSString*) STARTOVER:(NSString*) ENDOVER :(NSString*) TOTALRUNS:(NSString*) TOTALWICKETS :(NSString*) DOMINANTTEAMCODE  {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO SESSIONEVENTS (COMPETITIONCODE,MATCHCODE, INNINGSNO, DAYNO, SESSIONNO, SESSIONSTARTTIME,SESSIONENDTIME,BATTINGTEAMCODE, STARTOVER, ENDOVER,TOTALRUNS, TOTALWICKETS, DOMINANTTEAMCODE, SESSIONSTATUS) VALUES ('%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', 1)", COMPETITIONCODE,MATCHCODE, INNINGSNO,DAYNO ,SESSIONNO, STARTTIME , ENDTIME,TEAMCODE, STARTOVER, ENDOVER , TOTALRUNS,TOTALWICKETS ,DOMINANTTEAMCODE];
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


-(BOOL) GetDayNoForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO];
        
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





-(BOOL) InsertDayEventForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) TEAMCODE:(NSString*) RUNS : (NSString*) OVERBALLNO:(NSString*) WICKETS {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO DAYEVENTS (COMPETITIONCODE,MATCHCODE,INNINGSNO,STARTTIME,ENDTIME,DAYNO,BATTINGTEAMCODE,TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DAYSTATUS)	VALUES		('%@',	'%@','%@','','','%@','%@','%@','%@','%@','',1)", COMPETITIONCODE,MATCHCODE, INNINGSNO,DAYNO ,TEAMCODE, RUNS , OVERBALLNO,WICKETS];
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

//SP_UPDATEENDSESSION-------------------------------

-(BOOL)  GetMatchCodeInNotExists:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*)STARTTIME :(NSString*)ENDTIME  {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHCODE FROM MATCHREGISTRATION WHERE  COMPETITIONCODE = '%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
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

-(BOOL)updateEndSession:(NSString*) STARTTIME:(NSString*) ENDTIME : (NSString*) DOMINANTTEAMCODE:(NSString*) DAYNO :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) SESSIONNO
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE SESSIONEVENTS SET SESSIONSTARTTIME = '%@', SESSIONENDTIME = '%@', DOMINANTTEAMCODE = '%@', DAYNO	= '%@' WHERE  COMPETITIONCODE='%@' AND	MATCHCODE='%@' AND INNINGSNO='%@' AND SESSIONNO='%@' AND DAYNO='%@'", STARTTIME,ENDTIME, DOMINANTTEAMCODE,DAYNO ,COMPETITIONCODE, MATCHCODE , INNINGSNO,SESSIONNO,DAYNO];
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
//SP_DELETEENDSESSION-----------------------------------------------------------------------------


-(BOOL) GetBallCodeForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) DAYNO: (NSString*) SESSIONNO   {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND DAYNO='%@' AND SESSIONNO='%@'+1",COMPETITIONCODE,MATCHCODE,DAYNO,SESSIONNO];
        
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
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

-(BOOL) GetBallCodeWithAddDayNoForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) DAYNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND DAYNO='%@'+1",COMPETITIONCODE,MATCHCODE,DAYNO];
        
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

-(BOOL) GetSessionNoForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) SESSIONNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONNO FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@' AND SESSIONNO='%@'+1",COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO,SESSIONNO];
        
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

-(BOOL)GetSessionNoWithAddDayNoForDeleteEndSession: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString *) INNINGSNO:(NSString*) DAYNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONNO FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO='%@' AND DAYNO='%@'+1",COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO];
        
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


-(BOOL)DeleteSessionEventsForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) SESSIONNO
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM  SESSIONEVENTS  WHERE    COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@' AND SESSIONNO='%@'-1 ", COMPETITIONCODE,MATCHCODE ,INNINGSNO,DAYNO, SESSIONNO];
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



@end
