//
//  DBManagerEndInnings.m
//  CAPScoringApp
//
//  Created by mac on 18/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerEndInnings.h"
#import "EndInnings.h"

@implementation DBManagerEndInnings

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";


//Copy database to application document
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

//Get database path
+(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}



+(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}

//SP_INSERTENDINNINGS---------------------------------------------------------------------------
+(NSString*) GetMatchTypeUsingCompetition:(NSString*) COMPETITIONCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT MATCHTYPE FROM COMPETITION WHERE COMPETITIONCODE = '%@'",COMPETITIONCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *getMatchType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return getMatchType;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) GetDayNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT DAYNO AS DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@'AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *getDayNo= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return getDayNo;
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(NSString*) GetMaxDayNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(DAYNO) AS DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@'AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *DAYNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return DAYNO;
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

+(NSMutableArray *) GetInningsDetails:(NSString*) MATCHCODE
{
    NSMutableArray *InningsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STARTTIME,ENDTIME,TEAMNAME,TOTALRUNS,TOTALOVERS,TOTALWICKETS,INNINGSNO,BATTINGTEAMCODE, IFNULL((DAYDURATION),0) AS DAYDURATION,INNINGSDURATION,CASE WHEN DAYDURATION IS NULL THEN CAST(INNINGSDURATION AS NVARCHAR)+' MINS'  ELSE CAST(DAYDURATION AS NVARCHAR)+' MINS' END AS DURATION FROM (SELECT IE.INNINGSSTARTTIME AS STARTTIME,IE.INNINGSENDTIME AS ENDTIME,((julianday(IE.INNINGSENDTIME) - julianday(IE.INNINGSSTARTTIME))) AS INNINGSDURATION,CASE WHEN DE.STARTTIME!=NULL THEN SUM(julianday(DE.ENDTIME) - julianday(DE.STARTTIME)) ELSE SUM(julianday(DE.ENDTIME) - julianday(DE.STARTTIME)) END AS DAYDURATION,TM.TEAMNAME,IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE FROM INNINGSEVENTS IE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=IE.BATTINGTEAMCODE LEFT JOIN DAYEVENTS DE ON DE.MATCHCODE=IE.MATCHCODE AND DE.BATTINGTEAMCODE=IE.BATTINGTEAMCODE AND DE.INNINGSNO=IE.INNINGSNO WHERE IE.MATCHCODE='%@' AND IE.INNINGSSTATUS='1' GROUP BY IE.INNINGSSTARTTIME, IE.INNINGSENDTIME,TM.TEAMNAME, IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE )DETAILS ORDER BY INNINGSNO;",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
            EndInnings *record=[[EndInnings alloc]init];
        record.STARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        record.ENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        record.TOTALOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
        record.TOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
    record.BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
       
                
        record.DAYDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
    
                record.INNINGSDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            record.DURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
            [InningsArray addObject:record];
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return InningsArray;
}






+(NSString*) GetSessionNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO: (NSString*) DAYNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(SESSIONNO) AS SESSIONNO FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,DAYNO];
				    
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *SESSIONNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return SESSIONNO;
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

+(NSNumber*) GetStartoverNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE:(NSString*) SESSIONNO: (NSString*) OLDINNINGSNO: (NSString*) DAYNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MIN(OVERNO),0) AS STARTOVER FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,SESSIONNO,OLDINNINGSNO,DAYNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
               // NSString *obj =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                NSNumber *STARTOVER =@1; //[NSNumber numberWithInteger:[ obj integerValue]];
                sqlite3_finalize(statement);
               sqlite3_close(dataBase);
                return STARTOVER;
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

+(NSNumber*) GetBallNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE:(NSString*) SESSIONNO: (NSString*) OLDINNINGSNO: (NSString*) STARTOVERNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL (MIN(BALLNO),0) AS STARTOVERBALLNO FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,SESSIONNO,OLDINNINGSNO,STARTOVERNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                
                NSString *STARTOVERBALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return STARTOVERBALLNO;
                
               
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

+(NSNumber*) GetRunScoredForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE:(NSString*) SESSIONNO: (NSString*) OLDINNINGSNO: (NSString*) DAYNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL) ,0) AS RUNSSCORED FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND SESSIONNO='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,SESSIONNO,OLDINNINGSNO,DAYNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumber *RUNSSCORED = [NSNumber numberWithInteger: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return RUNSSCORED;
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

+(NSString*) GetWicketLostForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE:(NSString*) OLDINNINGSNO:(NSString*) SESSIONNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(WKT.BALLCODE) AS EXTRAWICKETCOUNT  FROM BALLEVENTS BALL LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE WHERE BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALL.TEAMCODE='%@' AND BALL.INNINGSNO='%@' AND BALL.SESSIONNO ='%@'",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO,SESSIONNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *EXTRAWICKETCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return EXTRAWICKETCOUNT;
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

+(BOOL) GetCompetitioncodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND INNINGSSTATUS='0'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                //                NSString *COMPETITIONCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}
+(BOOL) UpdateInningsEventForMatchTypeBasedInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET ISDECLARE='1' WHERE 	COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(NSString*) GetLastBallCodeForInsertEndInninges:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BE WHERE (SELECT MAX(BALL.OVERNO + '.' + BALL.BALLNO + BALL.BALLCOUNT)FROM BALLEVENTS BALL WHERE BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@')AND BE.MATCHCODE = '%@' AND BE.INNINGSNO = '%@'",MATCHCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
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

+(NSMutableArray *) GetBallEventForInningsDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) LASTBALLCODE
{
    NSMutableArray *BallEventArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMCODE,OVERNO, BOWLERCODE, STRIKERCODE,NONSTRIKERCODE, WICKETKEEPERCODE, UMPIRE1CODE, UMPIRE2CODE,ATWOROTW, BOWLINGEND FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BALLCODE = '%@';",COMPETITIONCODE, MATCHCODE,LASTBALLCODE];
        
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndInnings *record=[[EndInnings alloc]init];
                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.WICKETKEEPERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.UMPIRE1CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.UMPIRE2CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.ATWOROTW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.BOWLINGEND=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                [BallEventArray addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BallEventArray;
}




+(BOOL) UpdateInningsEventForInsertEndInninges:(NSString*) INNINGSSTARTTIME : (NSString*) INNINGSENDTIME :(NSString*) OLDTEAMCODE :(NSString*) TOTALRUNS : (NSString*) ENDOVER :(NSString*) TOTALWICKETS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET INNINGSSTARTTIME='%@',INNINGSENDTIME='%@',BATTINGTEAMCODE='%@',TOTALRUNS='%@',TOTALOVERS='%@',TOTALWICKETS='%@',INNINGSSTATUS='1' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",INNINGSSTARTTIME,INNINGSENDTIME,OLDTEAMCODE,TOTALRUNS,ENDOVER,TOTALWICKETS,COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
             NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}



+(BOOL) GetCompetitioncodeInAddOldInningsNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDTEAMCODE:(NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'+1 AND ISDECLARE=0",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                //                NSString *COMPETITIONCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(NSString*) GetInningsCountForInsertEndInnings:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    NSString *INNINGSCOUNT = [[NSString alloc]init];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(INNINGSNO) FROM INNINGSEVENTS WHERE MATCHCODE ='%@'",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                INNINGSCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return INNINGSCOUNT;
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

+(BOOL) UpdateMatchRegistrationForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = 'MSC125' , MODIFIEDBY = 'USER' ,MODIFIEDDATE = CURRENT_TIMESTAMP WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
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

+(BOOL) GetMatchBasedSessionNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) SESSIONNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONNO FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@' AND SESSIONNO='%@'",COMPETITIONCODE, MATCHCODE ,OLDINNINGSNO , DAYNO , SESSIONNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                // NSString *SESSIONNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL) InsertSessionEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) SESSIONNO: (NSString*) OLDTEAMCODE: (NSString*) STARTOVERBALLNO:(NSString*) ENDOVER:(NSString*) RUNSSCORED:(NSString*) TOTALWICKETS{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO SESSIONEVENTS (COMPETITIONCODE,MATCHCODE,INNINGSNO,DAYNO,SESSIONNO,SESSIONSTARTTIME,SESSIONENDTIME,BATTINGTEAMCODE,STARTOVER,ENDOVER,TOTALRUNS,DOMINANTTEAMCODE,SESSIONSTATUS) VALUES  ('%@','%@','%@','%@','%@','','','%@','%@','%@','%@','%@','',0)",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,DAYNO,SESSIONNO,OLDTEAMCODE,STARTOVERBALLNO,ENDOVER,RUNSSCORED,TOTALWICKETS];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) GetDayNoInDayEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : OLDINNINGSNO: (NSString*) DAYNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,DAYNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) InsertDayEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) OLDTEAMCODE: (NSString*) TOTALRUNS:(NSString*) ENDOVER:(NSString*) TOTALWICKETS : (NSString*) SESSIONNO : (NSString*) STARTOVERBALLNO : (NSString*) RUNSSCORED{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO DAYEVENTS(COMPETITIONCODE,MATCHCODE,	INNINGSNO,STARTTIME,ENDTIME,DAYNO,BATTINGTEAMCODE,	TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DAYSTATUS)  VALUES('%@','%@','%@','','','%@','%@','%@','%@','%@',''0);)",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,DAYNO,SESSIONNO,OLDTEAMCODE,STARTOVERBALLNO,ENDOVER,RUNSSCORED,TOTALWICKETS];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return YES;
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

+(NSString*) GetCompetitioncodeInUpdateForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDTEAMCODE:(NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND INNINGSSTATUS='1' ",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *COMPETITIONCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return COMPETITIONCODE;
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

+(BOOL) UpdateInningsEventInUpdateForInsertEndInninges:(NSString*) INNINGSSTARTTIME : (NSString*) INNINGSENDTIME :(NSString*) TOTALRUNS : (NSString*) ENDOVER :(NSString*) TOTALWICKETS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE  INNINGSEVENTS  SET	INNINGSSTARTTIME='%@',INNINGSENDTIME='%@',TOTALRUNS='%@',TOTALOVERS='%@',TOTALWICKETS='%@'  WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@' AND TEAMCODE='%@' AND  INNINGSNO='%@' ",INNINGSSTARTTIME,INNINGSENDTIME,OLDTEAMCODE,TOTALRUNS,ENDOVER,TOTALWICKETS,COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}




+(NSString*) GetSecondTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=2",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TEAMCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TEAMCODE;
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

+(NSString*) GetThirdTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=3",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TEAMCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return TEAMCODE;
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


+(NSString*) GetSecondTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    
    NSString *databasePath = [self getDBPath];
    
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND (INNINGSNO=3 OR INNINGSNO=2)",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
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

+(NSString*) GetFirstTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO=1 ",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
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


+(NSNumber*) GetSecondTotalinSecondThirdTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO=2",COMPETITIONCODE,MATCHCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumber *TOTAL = [NSNumber numberWithInteger: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
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

+(NSNumber*) GetFirstThirdTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND (INNINGSNO=1 OR INNINGSNO=3)",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumber *TOTAL = [NSNumber numberWithInteger: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
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


//SP_MANAGESEOVERDETAILS-----------------------------------------------------------------------

+(BOOL) GetOverNoFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERNO FROM OVEREVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}


+(BOOL) InsertOverEventFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OVERSTATUS  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO OVEREVENTS (COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,OVERSTATUS) VALUES('%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,TEAMCODE ,INNINGSNO,OVERNO, OVERSTATUS];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    return NO;
    
}

+(BOOL) InsertBowlerOverDetailsFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLEROVERDETAILS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,STARTTIME,ENDTIME) VALUES('%@','%@','%@','%@','%@','%@',CURRENT_TIMESTAMP,'')", COMPETITIONCODE,MATCHCODE,TEAMCODE ,INNINGSNO,OVERNO, BOWLERCODE];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    return NO;
    
}

+(BOOL) GetBallCodeFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(NSString*) GetBowlingTeamCodeFormanageOverDetails:(NSString*) TEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE = '%@' THEN TEAMBCODE  ELSE TEAMACODE END AS BOWLINGTEAMACODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",TEAMCODE,COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLINGTEAMACODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLINGTEAMACODE;
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

+(NSString*) GetBatTeanRunsFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) Total  FROM BALLEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'  AND TEAMCODE = '%@' AND INNINGSNO = '%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLINGTEAMACODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLINGTEAMACODE;
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

+(NSNumber*)GetMaxidFormanageOverDetails:(NSString*) MATCHCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT CONVERT(NVARCHAR(50),IFNULL(MAX(CONVERT(NUMERIC(10,0), RIGHT(BALLCODE,10))),0) + 1) FROM BALLEVENTS WHERE MATCHCODE = '%@'",MATCHCODE];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *maxid = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return maxid;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}

+(BOOL) InsertBallEventsFormanageOverDetails:(NSString*) BALLCODENO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) DAYNO:(NSString*) OVERNO : (NSString*) BALLNO:(NSString*) SESSIONNO  :(NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE :(NSString*) BOWLERCODE:(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW:(NSString*) BOWLINGEND {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BALLEVENTS(BALLCODE, COMPETITIONCODE, MATCHCODE,TEAMCODE, INNINGSNO, DAYNO, OVERNO,BALLNO, BALLCOUNT, SESSIONNO, STRIKERCODE, NONSTRIKERCODE, BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE, UMPIRE2CODE, ATWOROTW, BOWLINGEND,BOWLTYPE, SHOTTYPE,  ISLEGALBALL,ISFOUR,ISSIX,RUNS,OVERTHROW, TOTALRUNS, WIDE, NOBALL,BYES,LEGBYES,PENALTY, TOTALEXTRAS,GRANDTOTAL,RBW,PMLINECODE, PMLENGTHCODE,PMSTRIKEPOINT, PMX1, PMY1,PMX2,PMY2,PMX3, PMY3,WWREGION, WWX1, WWY1, WWX2, WWY2, BALLDURATION,ISAPPEAL,ISBEATEN,ISUNCOMFORT,ISWTB,ISRELEASESHOT, MARKEDFOREDIT,REMARKS) VALUES ('%@','%@','%@','%@','%@', '%@','%@','%@',1,'%@',        '%@','%@','%@','%@','%@','%@','%@','%@','','',1,0,0,0,0,0,0,0,0,0,0,0,0,0,'','', '', 1,1,1,1,1,1,'',165,124,165,124,0,0,0,0,0,0,0,'')", BALLCODENO, COMPETITIONCODE,MATCHCODE, TEAMCODE, INNINGSNO, DAYNO, OVERNO , BALLNO, SESSIONNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE, UMPIRE2CODE,ATWOROTW,BOWLINGEND];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
}


+(BOOL) UpdateOverEventFormanageOverDetails:(NSString*) OVERSTATUS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE OVEREVENTS SET OVERSTATUS='%@' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'  AND OVERNO='%@'",OVERSTATUS,COMPETITIONCODE,MATCHCODE,TEAMCODE ,INNINGSNO,OVERNO];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
 
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
}

+(BOOL)  UpdateBowlerOverDetailsFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLEROVERDETAILS SET ENDTIME = date('now')  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'  AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE ,INNINGSNO,OVERNO];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
}

+(NSNumber*) GetBattingteamOverwithExtraBallFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0)as BALLNO  FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@'  AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE ,INNINGSNO,OVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BALLNO;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}

+(NSNumber*) GetBattingteamOverBallCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO : (NSString*) BATTEAMOVRWITHEXTRASBALLS{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@" SELECT IFNULL(MAX(BALLCOUNT),1) as BALLCOUNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  AND TEAMCODE = '%@'  AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@'  ",COMPETITIONCODE,MATCHCODE,TEAMCODE ,INNINGSNO,OVERNO,BATTEAMOVRWITHEXTRASBALLS];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BALLCOUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BALLCOUNT;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}


+(NSString *) GetLastBallCodeFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO : (NSNumber*) BATTEAMOVRWITHEXTRASBALLS : (NSNumber*) BATTEAMOVRBALLSCNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE =  '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO =  '%@'  AND OVERNO =  '%@' AND BALLNO =  '%@'  AND BALLCOUNT =  '%@'  ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BATTEAMOVRWITHEXTRASBALLS,BATTEAMOVRBALLSCNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return @"";
        }
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}

+(NSString *)GetBallEventCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) as COUNT  FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@') > 0 ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *COUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return COUNT;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    
    return @"";
}







+(NSMutableArray*) GetStrickerNonStrickerRunFormanageOverDetails:(NSString*) LASTBALLCODE
{
    NSMutableArray *getStrickerArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  BALL.STRIKERCODE,  BALL.NONSTRIKERCODE,(BALL.TOTALRUNS + (CASE WHEN BALL.WIDE > 0 THEN BALL.WIDE-1 ELSE BALL.WIDE END) +(CASE WHEN BALL.NOBALL > 0 THEN BALL.NOBALL-1 ELSE BALL.NOBALL END) + BALL.LEGBYES + BALL.BYES + (CASE WHEN (BALL.BYES > 0 OR BALL.LEGBYES > 0) THEN BALL.OVERTHROW ELSE 0 END)) as TOTALRUNS  FROM BALLEVENTS BALL WHERE BALL.BALLCODE = '%@'",LASTBALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndInnings *record=[[EndInnings alloc]init];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [getStrickerArray addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return getStrickerArray;
}



+(BOOL)  UpdateInningsEventFormanageOverDetails:(NSString*) T_STRIKERCODE:(NSString*) T_NONSTRIKERCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET CURRENTSTRIKERCODE = '%@', CURRENTNONSTRIKERCODE = '%@', CURRENTBOWLERCODE = '' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",T_STRIKERCODE,T_NONSTRIKERCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE ,INNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}


+(NSString *)  GetBallNoFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLNO  FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' GROUP BY BALLNO HAVING MAX(BALLNO) > 4   ",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BALLNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}


+(NSString *)  GetIsMaidenOverFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN (ISNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END  as MAIDENOVERS FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'group by ballno  HAVING MAX(BALLNO) > 4 ",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSString *MAIDENOVERS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return MAIDENOVERS;
                }
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return @"";
            }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}

+(NSString *)  GetBowlerCodeFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT BOWLERCODE  FROM BOWLEROVERDETAILS  WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'  AND INNINGSNO = '%@'   AND OVERNO = '%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLERCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}


+(NSNumber *) GetBowlerCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BOWLERCODE) AS BOWLERCODE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@';",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BOWLERCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BOWLERCODE;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}

+(NSString *)   GetCurrentBowlerCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLERCODE;
            }
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}


+(BOOL)  UpdateBowlingSummaryFormanageOverDetails:(NSString*) BOWLERCOUNT:(NSString*) ISMAIDENOVER :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) CURRENTBOWLER {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = (CASE WHEN ('%@' > 1) THEN OVERS ELSE (OVERS + 1) END),   BALLS = 0,   PARTIALOVERBALLS =  (CASE WHEN (BALLS < 6 AND '%@' > 1) THEN (PARTIALOVERBALLS + BALLS) ELSE PARTIALOVERBALLS END),   MAIDENS = (CASE WHEN ('%@' = 1 AND '%@' = 1) THEN (MAIDENS + 1) ELSE MAIDENS END)  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  AND INNINGSNO = '%@'  AND BOWLERCODE = '%@'",BOWLERCOUNT,BOWLERCOUNT,ISMAIDENOVER,BOWLERCOUNT,COMPETITIONCODE,MATCHCODE,INNINGSNO,CURRENTBOWLER ];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}


+(BOOL)UpdateBowlingSummaryFormanageOver:(NSString*) BOWLERCOUNT:(NSString*) ISMAIDENOVER :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) CURRENTBOWLER :(NSString*)OVERNO
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = (CASE WHEN ('%@' > 1) THEN OVERS ELSE (OVERS + 1) END),BALLS = 0,  PARTIALOVERBALLS =  (CASE WHEN (BALLS < 6 AND '%@' > 1) THEN (PARTIALOVERBALLS + BALLS) ELSE PARTIALOVERBALLS END), MAIDENS = (CASE WHEN ('%@' = 1 AND '%@' = 1) THEN (MAIDENS + 1) ELSE MAIDENS END) WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE IN (  SELECT BOWLERCODE FROM BOWLEROVERDETAILS  WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'   AND INNINGSNO = '%@' AND OVERNO = '%@' )",BOWLERCOUNT,BOWLERCOUNT,ISMAIDENOVER,BOWLERCOUNT,COMPETITIONCODE,MATCHCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
}

+(BOOL) InsertBowlingMaidenSummaryInElseFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) BOWLERCODE:(NSString*) OVERNO {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY  (COMPETITIONCODE,  MATCHCODE,INNINGSNO, BOWLERCODE,  OVERS)  VALUES  ('%@','%@', '%@', '%@', '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE, OVERNO ];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
}

//SP_INSERTSCOREBOARD------------------------------------------------------------------------------------
+(NSString *) GetBatsmanCodeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO: (NSString*) BATSMANCODE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT BATSMANCODE  FROM BATTINGSUMMARY   WHERE COMPETITIONCODE = '%@'  AND MATCHCODE =  '%@'   AND BATTINGTEAMCODE =  '%@' AND INNINGSNO = '%@' AND BATSMANCODE =  '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATSMANCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BATSMANCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BATSMANCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}


+(NSMutableArray*) GetO_AssignValueForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO: (NSString*) BATSMANCODE
{
    NSMutableArray *GetOScoreBoardDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
NSString *updateSQL = [NSString stringWithFormat:@"SELECT BATTINGPOSITIONNO, RUNS,  BALLS,  ONES, TWOS  , THREES, FOURS, SIXES, DOTBALLS , WICKETNO , WICKETTYPE, FIELDERCODE, BOWLERCODE    FROM BATTINGSUMMARY    WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'  AND BATTINGTEAMCODE ='%@'  AND INNINGSNO = '%@'  AND BATSMANCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATSMANCODE];
                               
            const char *update_stmt = [updateSQL UTF8String];
            if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
                               
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       EndInnings *record=[[EndInnings alloc]init];
                                       record.BATTINGPOSITIONNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                       record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                                       record.BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                                       record.ONES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                                       record.TWOS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                                       record.THREES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                                       record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                                       record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                                       record.DOTBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                                       record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                                       record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                                       record.FIELDERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                                       record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                                       
                                       
                                       [GetOScoreBoardDetails addObject:record];
                                   }
                                   
                               }
                               }
                               sqlite3_finalize(statement);
                               sqlite3_close(dataBase);
                               return GetOScoreBoardDetails;
                               }
                               
+(NSNumber*) GetOBattingPositionNoForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO
    {
        int retVal;
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([databasePath UTF8String], &dataBase);
        if(retVal !=0){
        }
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) + 1 as COUNT FROM BATTINGSUMMARY  WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'   AND BATTINGTEAMCODE = '%@'    AND INNINGSNO = '%@'  ",COMPETITIONCODE,MATCHCODE ,BATTINGTEAMCODE,INNINGSNO];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *COUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return COUNT;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return 0;
    }
                               
+(BOOL) InsertbattingSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) N_BATTINGPOSITIONNO :(NSString*) BATSMANCODE:(NSNumber*) N_RUNS: (NSNumber*) N_BALLS:(NSNumber*) N_ONES:(NSNumber*) N_TWOS :(NSNumber*) N_THREES: (NSNumber*) N_FOURS:(NSNumber*) N_SIXES:(NSNumber*) N_DOTBALLS
        
    {
                                   
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY  ( COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE, INNINGSNO, BATTINGPOSITIONNO,BATSMANCODE,  RUNS,BALLS, ONES, TWOS, THREES, FOURS, SIXES,  DOTBALLS )  VALUES (  '%@',   '%@',  '%@',   '%@',  '%@',  '%@',  '%@',  '%@',  '%@',  '%@',  '%@',  '%@',  '%@',  '%@')", COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE,INNINGSNO, N_BATTINGPOSITIONNO, BATSMANCODE, N_RUNS, N_BALLS,N_ONES,  N_TWOS , N_THREES, N_FOURS, N_SIXES, N_DOTBALLS ];
            const char *selectStmt = [updateSQL UTF8String];
            
            if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
            }
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return NO;
        
    }
                               
+(BOOL) UpdatebattingSummaryForInsertScoreBoard:(NSString*) N_BATTINGPOSITIONNO:(NSNumber*) N_RUNS: (NSNumber*)N_BALLS:(NSNumber*) N_ONES:(NSNumber*) N_TWOS :(NSNumber*) N_THREES:(NSNumber*) N_FOURS:(NSNumber*)N_SIXES:(NSNumber*) N_DOTBALLS:(NSNumber*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) BATSMANCODE

            {
                
                NSString *databasePath = [self getDBPath];
                sqlite3_stmt *statement;
                sqlite3 *dataBase;
                const char *dbPath = [databasePath UTF8String];
                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                {
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET BATTINGPOSITIONNO = '%@',   RUNS = '%@',   BALLS = '%@',   ONES = '%@',   TWOS = '%@',   THREES ='%@', FOURS = '%@', SIXES = '%@', DOTBALLS = '%@' WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'  AND BATTINGTEAMCODE = '%@'  AND INNINGSNO = '%@'  AND BATSMANCODE = '%@'", N_BATTINGPOSITIONNO,N_RUNS, N_BALLS,N_ONES,N_TWOS,N_THREES,N_FOURS,N_SIXES,N_DOTBALLS, COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE, INNINGSNO , BATSMANCODE];
                    const char *selectStmt = [updateSQL UTF8String];
                    
                    if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                    {
                        while(sqlite3_step(statement)==SQLITE_ROW){
                            sqlite3_reset(statement);
                            sqlite3_finalize(statement);
                            sqlite3_close(dataBase);
                            return YES;
                        }
                    }
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
                
            }
                               
+(NSString *) GetWicKetTypeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER
        {
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [databasePath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                NSString *updateSQL = [NSString stringWithFormat:@" SELECT WICKETTYPE   FROM WICKETEVENTS   WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'   AND TEAMCODE = '%@'   AND INNINGSNO = '%@'   AND WICKETPLAYER = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
                const char *update_stmt = [updateSQL UTF8String];
                if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
                    
                {
                    while(sqlite3_step(statement)==SQLITE_ROW){
                        
                        NSString *WICKETTYPE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                        sqlite3_finalize(statement);
                        sqlite3_close(dataBase);
                        return WICKETTYPE;
                    }
                    
                }
                else {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    return @"";
                }
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return @"";
        }
                               
                               
+(NSMutableArray*)  GetWicKetAssignVarForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER
        
{
    NSMutableArray *GetWicketSDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT WICKETNO,  WICKETTYPE, FIELDINGPLAYER,  BOWLERCODE   FROM WICKETEVENTS   WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'  AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND WICKETPLAYER = '%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndInnings *record=[[EndInnings alloc]init];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.FIELDINGPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [GetWicketSDetails addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketSDetails;
}


+(BOOL) UpdatebattingSummaryInWiCketForInsertScoreBoard:(NSString*) N_WICKETNO:(NSString*) N_WICKETTYPE: (NSString*) N_FIELDERCODE:(NSString*) N_BOWLERCODE:(NSString*) WICKETOVERNO :(NSString*)WICKETBALLNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER
                       
        {
                            
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [databasePath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = '%@', WICKETTYPE = '%@', FIELDERCODE = '%@', BOWLERCODE = '%@', WICKETOVERNO = '%@', WICKETBALLNO = '%@'    WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'  AND BATTINGTEAMCODE = '%@'  AND INNINGSNO = '%@'  AND BATSMANCODE = '%@'",N_WICKETNO,N_WICKETTYPE,N_FIELDERCODE,N_BOWLERCODE,WICKETOVERNO, WICKETBALLNO, COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE, INNINGSNO ,WICKETPLAYER];
                const char *selectStmt = [updateSQL UTF8String];
                
                if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                {
                    while(sqlite3_step(statement)==SQLITE_ROW){
                        sqlite3_reset(statement);
                        sqlite3_finalize(statement);
                        sqlite3_close(dataBase);
                        return YES;
                    }
                }
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return NO;
            
        }
                               
+(NSString*) GetBateamCodeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO
                               
        {
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [databasePath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                NSString *updateSQL = [NSString stringWithFormat:@"SELECT BATTINGTEAMCODE  FROM INNINGSSUMMARY  WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@'   AND BATTINGTEAMCODE = '%@'   AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
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
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    return @"";
                }
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return @"";
        }

+(NSMutableArray*)GetInningsSummaryAssignForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO : (NSString*) WICKETPLAYER

    {
        NSMutableArray *GetInningsSummaryDetails=[[NSMutableArray alloc]init];
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETNO, WICKETTYPE, FIELDINGPLAYER,  BOWLERCODE FROM WICKETEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND WICKETPLAYER = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
                                   
                                   const char *update_stmt = [updateSQL UTF8String];
                                   sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                   if (sqlite3_step(statement) == SQLITE_DONE)
                                   {
                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                    EndInnings *record=[[EndInnings alloc]init];
                                           record.BYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                           record.LEGBYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                                           record.NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                                           record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                                           record.PENALTIES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                                           record.INNINGSTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                                           record.INNINGSTOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                                           
                                           
                                           [GetInningsSummaryDetails addObject:record];
                                       }
                                       
                                   }                                                                                                                            }
                                   sqlite3_finalize(statement);
                                   sqlite3_close(dataBase);
                                   return GetInningsSummaryDetails;
                                   }
                                   
                                                                                                                            
+(BOOL) InsertInningsSummaryForInsertScoreBoard :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) N_BYES:(NSString*) N_LEGBYES: (NSString*) N_NOBALLS:(NSString*) N_WIDES:(NSString*) N_PENALTIES :(NSString*) N_INNINGSTOTAL : (NSString*) N_INNINGSTOTALWICKETS
            {
                                                                                                                                
                                                                                                                                
                NSString *databasePath = [self getDBPath];
                sqlite3_stmt *statement;
                sqlite3 *dataBase;
                const char *dbPath = [databasePath UTF8String];
                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                {
                    NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO INNINGSSUMMARY (COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO, BYES,LEGBYES,NOBALLS,WIDES,	PENALTIES,INNINGSTOTAL,INNINGSTOTALWICKETS)VALUES('%@','%@','%@','%@','%@',	'%@','%@','%@',	'%@','%@','%@'", COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE, INNINGSNO , N_BYES ,N_LEGBYES,N_NOBALLS,N_WIDES,N_PENALTIES,N_INNINGSTOTAL,N_INNINGSTOTALWICKETS];
                    const char *selectStmt = [updateSQL UTF8String];
                    
                    if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                    {
                        while(sqlite3_step(statement)==SQLITE_ROW){
                            sqlite3_reset(statement);
                            sqlite3_finalize(statement);
                            sqlite3_close(dataBase);
                            return YES;
                        }
                    }
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
                
            }
                           
+(BOOL) UpdateInningsSummaryForInsertScoreBoard :(NSString*) N_BYES:(NSString*) N_LEGBYES: (NSString*) N_NOBALLS:(NSString*) N_WIDES:(NSString*) N_PENALTIES :(NSString*) N_INNINGSTOTAL : (NSString*) N_INNINGSTOTALWICKETS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO
{
                                                                                                                                
                                                                                                                                
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
                                                                                                                                    
  NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET BYES = '%@',LEGBYES = '%@',NOBALLS = '%@',	WIDES = '%@',PENALTIES = '%@',INNINGSTOTAL = '%@',INNINGSTOTALWICKETS = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'		AND INNINGSNO = '%@'", N_BYES ,N_LEGBYES,N_NOBALLS,N_WIDES,N_PENALTIES,N_INNINGSTOTAL,N_INNINGSTOTALWICKETS, COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE, INNINGSNO ];
        const char *selectStmt = [updateSQL UTF8String];
                                                                                                                                    
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
                                while(sqlite3_step(statement)==SQLITE_ROW){
                                    sqlite3_reset(statement);
                                    sqlite3_finalize(statement);
                                    sqlite3_close(dataBase);
                            return YES;
                        }
                }
            }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
            return NO;
    
}
                                                                                                                            
+(BOOL) UpdatebattingSummaryInWiCketScoreForInsertScoreBoard:(NSString*) N_INNINGSTOTAL :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER
{
                                                                                                                                
                                                                                                                                
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETSCORE = '%@'	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@'	AND BATSMANCODE = '%@'",N_INNINGSTOTAL, COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE, INNINGSNO,WICKETPLAYER ];
        const char *selectStmt = [updateSQL UTF8String];
                                                                                                                                    
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
    {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                return YES;
    }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
        return NO;
                                                                                                                                
}
                                                                                                                            
+(NSNumber*)GetOverStatusForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
                                                                                                                                
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'  AND OVERNO='%@' ",COMPETITIONCODE,MATCHCODE ,BATTINGTEAMCODE,INNINGSNO,WICKETOVERNO];
                                                                                                                                
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
    while(sqlite3_step(statement)==SQLITE_ROW){
                                                                                                                                        
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *OVERSTATUS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                                                                                                                                        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
                                                                                                                                        
        return OVERSTATUS;
    }
}
                                                                                                                                
sqlite3_finalize(statement);
sqlite3_close(dataBase);
return 0;
}
                                                                                                                            
+(NSNumber *) GetBowlerForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
                                                                                                                                
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE FROM BOWLEROVERDETAILS 	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'	AND INNINGSNO = '%@'	AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE ,INNINGSNO,WICKETOVERNO];
    
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
                                                                                                                                        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BOWLERCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BOWLERCODE;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}
                           
+(NSNumber*) GetBowlerCountForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BOWLERCODE) AS BOWLERCODE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'		AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE ,INNINGSNO,WICKETOVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BOWLERCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BOWLERCODE;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}
                           
+(BOOL) InsertBowlerOverDetailsForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETOVERNO:(NSString*) BOWLERCODE{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLEROVERDETAILS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,STARTTIME,ENDTIME) 	VALUES('%@','%@','%@','%@','%@','%@',GETDATE(),'')", COMPETITIONCODE, MATCHCODE, BATTINGTEAMCODE, INNINGSNO,WICKETOVERNO,BOWLERCODE ];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
}
                           
+(NSNumber*) GetBowlerCodeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) BOWLINGTEAMCODE:(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE FROM BOWLINGSUMMARY 	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' 	AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE ,BOWLINGTEAMCODE,INNINGSNO,BOWLERCODE];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BOWLERCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BOWLERCODE;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}
                           
+(NSMutableArray*) GetBowlingDetailsForassignvarForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE
            
    {
        NSMutableArray *GetBowlingDetailsForAssignDetails=[[NSMutableArray alloc]init];
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLINGPOSITIONNO, OVERS, BALLS, PARTIALOVERBALLS, MAIDENS, RUNS, WICKETS, NOBALLS, WIDES, DOTBALLS,FOURS,SIXES FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,BOWLERCODE];
                                   
                                   const char *update_stmt = [updateSQL UTF8String];
                                   sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                   if (sqlite3_step(statement) == SQLITE_DONE)
                                   {
                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                           EndInnings *record=[[EndInnings alloc]init];
                                           record.BOWLINGPOSITIONNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                           record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                                           record.BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                                           record.PARTIALOVERBALLS	=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                                           record.MAIDENS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                                           record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                                           record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                                           record.NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                                           record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                                           record.DOTBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                                           record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                                           record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                                           
                                           [GetBowlingDetailsForAssignDetails addObject:record];
                                       }
                                   }
                                   }
                                   sqlite3_finalize(statement);
                                   sqlite3_close(dataBase);
                                   return GetBowlingDetailsForAssignDetails;
                                   }
                                   
+(NSNumber*) GetBowlingPositionCountForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) BOWLINGTEAMCODE:(NSNumber*) INNINGSNO
        
    {
        int retVal;
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([databasePath UTF8String], &dataBase);
        if(retVal !=0){
        }
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) + 1 as COUNT FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE ,BOWLINGTEAMCODE,INNINGSNO];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *COUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return COUNT;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return 0;
    }
                                   
+(NSNumber*) GetBallCountForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO
        
        {
            int retVal;
            NSString *databasePath =[self getDBPath];
            sqlite3 *dataBase;
            const char *stmt;
            sqlite3_stmt *statement;
            retVal=sqlite3_open([databasePath UTF8String], &dataBase);
            if(retVal !=0){
            }
            
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) AS COUNT	FROM BALLEVENTS	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'	AND OVERNO = '%@'	AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE ,INNINGSNO,WICKETOVERNO];
            
            stmt=[updateSQL UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    f.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber *COUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                    
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    return COUNT;
                }
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return 0;
        }
                                                          
+(NSNumber*) GetMaiDenOverForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO
                    
            {
                int retVal;
                NSString *databasePath =[self getDBPath];
                sqlite3 *dataBase;
                const char *stmt;
                sqlite3_stmt *statement;
                retVal=sqlite3_open([databasePath UTF8String], &dataBase);
                if(retVal !=0){
                }
                
                NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN (ISNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END as ISMAIDENOVER 	FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND INNINGSNO = '%@'	AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE ,INNINGSNO,WICKETOVERNO];
                
                stmt=[updateSQL UTF8String];
                if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
                {
                    while(sqlite3_step(statement)==SQLITE_ROW){
                        
                        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                        f.numberStyle = NSNumberFormatterDecimalStyle;
                        NSNumber *ISMAIDENOVER = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                        
                        sqlite3_finalize(statement);
                        sqlite3_close(dataBase);
                        
                        return ISMAIDENOVER;
                    }
                }
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return 0;
            }
                                                          
+(NSNumber*) GetOversForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO
            
        {
            int retVal;
            NSString *databasePath =[self getDBPath];
            sqlite3 *dataBase;
            const char *stmt;
            sqlite3_stmt *statement;
            retVal=sqlite3_open([databasePath UTF8String], &dataBase);
            if(retVal !=0){
            }
            
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERS FROM BOWLINGMAIDENSUMMARY		WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND OVERS='%@'",COMPETITIONCODE,MATCHCODE ,INNINGSNO,WICKETOVERNO];
            
            stmt=[updateSQL UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    f.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber *OVERS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                    
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    return OVERS;
                }
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return 0;
        }
                                                          
+(BOOL) DeletebattingSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO
        
        {
                                                              
                                                              
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [databasePath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                NSString *updateSQL = [NSString stringWithFormat:@"DELETE BOWLINGMAIDENSUMMARY 	WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND OVERS='%@' ",COMPETITIONCODE,MATCHCODE ,INNINGSNO,WICKETOVERNO];
                const char *selectStmt = [updateSQL UTF8String];
                
                if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                {
                    while(sqlite3_step(statement)==SQLITE_ROW){
                        sqlite3_reset(statement);
                        sqlite3_finalize(statement);
                        sqlite3_close(dataBase);
                        return YES;
                    }
                }
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return NO;
            
        }
                                                          
+(BOOL)  InsertBowlingMaidenSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE :(NSNumber*) WICKETOVERNO
    
    {
    
    
    NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY (COMPETITIONCODE,MATCHCODE,	INNINGSNO,BOWLERCODE,OVERS	)VALUES	(	'%@',	'%@',	'%@',	'%@',	'%@') ",COMPETITIONCODE,MATCHCODE ,BOWLERCODE,INNINGSNO,WICKETOVERNO];
            const char *selectStmt = [updateSQL UTF8String];
            
            if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
            }
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return NO;
        
    }
                                                          
+(BOOL)  InsertBowlingSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSNumber*) N_BOWLINGPOSITIONNO:(NSNumber*) BOWLERCODE:(NSNumber*) N_BOWLEROVERS:(NSNumber*) N_BOWLERBALLS:(NSNumber*) N_BOWLERPARTIALOVERBALLS:(NSNumber*) N_BOWLERMAIDENS:(NSNumber*) N_BOWLERRUNS:(NSNumber*) N_BOWLERWICKETS:(NSNumber*) N_BOWLERNOBALLS:(NSNumber*) N_BOWLERWIDES:(NSNumber*) N_BOWLERDOTBALLS:(NSNumber*) N_BOWLERFOURS:(NSNumber*) N_BOWLERSIXES
            
    {
    
    
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
    NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGSUMMARY (COMPETITIONCODE, MATCHCODE,	BOWLINGTEAMCODE, INNINGSNO,BOWLINGPOSITIONNO,BOWLERCODE,OVERS,BALLS,	PARTIALOVERBALLS,MAIDENS,RUNS,WICKETS,NOBALLS,WIDES,DOTBALLS,FOURS,	SIXES)	VALUES	('%@','%@',	'%@','%@','%@','%@','%@','%@','%@',	'%@','%@','%@',	'%@','%@','%@',	'%@','%@')",COMPETITIONCODE, MATCHCODE, BOWLINGTEAMCODE,INNINGSNO, N_BOWLINGPOSITIONNO, BOWLERCODE, N_BOWLEROVERS, N_BOWLERBALLS, N_BOWLERPARTIALOVERBALLS, N_BOWLERMAIDENS, N_BOWLERRUNS, N_BOWLERWICKETS, N_BOWLERNOBALLS, N_BOWLERWIDES, N_BOWLERDOTBALLS, N_BOWLERFOURS, N_BOWLERSIXES];
            const char *selectStmt = [updateSQL UTF8String];
            
            if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
            }
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return NO;
        
    }
                                                          
+(BOOL) UpdateBowlingSummaryForInsertScoreBoard:(NSString*) N_BOWLINGPOSITIONNO:(NSString*) N_BOWLEROVERS :(NSNumber*) N_BOWLERBALLS	:(NSString*) N_BOWLERPARTIALOVERBALLS :(NSNumber*) N_BOWLERMAIDENS:(NSNumber*) N_BOWLERRUNS:(NSNumber*) N_BOWLERWICKETS:(NSNumber*) N_BOWLERNOBALLS:(NSNumber*) N_BOWLERWIDES:(NSNumber*) N_BOWLERDOTBALLS:(NSNumber*) N_BOWLERFOURS:(NSNumber*) N_BOWLERSIXES:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE
    {
                                                                                                                                                               
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET BOWLINGPOSITIONNO = '%@',OVERS = '%@',BALLS = '%@',	PARTIALOVERBALLS = '%@',MAIDENS = '%@',	RUNS = '%@',	WICKETS = '%@',	NOBALLS = '%@',	WIDES = '%@',DOTBALLS = '%@',FOURS = '%@',SIXES = '%@'	WHERE COMPETITIONCODE = '%@'AND MATCHCODE = '%@'AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'", N_BOWLINGPOSITIONNO,N_BOWLEROVERS , N_BOWLERBALLS, N_BOWLERPARTIALOVERBALLS ,N_BOWLERMAIDENS,N_BOWLERRUNS, N_BOWLERWICKETS, N_BOWLERNOBALLS, N_BOWLERWIDES, N_BOWLERDOTBALLS, N_BOWLERFOURS,N_BOWLERSIXES, COMPETITIONCODE, MATCHCODE, BOWLINGTEAMCODE , INNINGSNO, BOWLERCODE];
            const char *selectStmt = [updateSQL UTF8String];
            
            if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
            }
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return NO;
        
    }
                                                          
//SP_FETCHENDINNINGS---------------------------------------------------------------------------------
                                                          
+(NSString *)GetTeamNameForFetchEndInnings:(NSString *)TEAMCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT TEAMNAME FROM TEAMMASTER  WHERE TEAMCODE='%@'",TEAMCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *getInnings = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return getInnings;
            
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}
                                                          
                                                          
                                                          
+(NSNumber *) GetpenaltyRunsForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) TEAMCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) as PenaltyRuns FROM    PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@' AND INNINGSNO IN ('%@', '%@' - 1)	AND AWARDEDTOTEAMCODE ='%@' AND (BALLCODE IS NULL OR INNINGSNO < '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,INNINGSNO,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *PenaltyRuns = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return PenaltyRuns;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}
                                                          
                                                          
                                                          
+(NSNumber*) GetTotalRunsForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) AS TOTAL FROM   BALLEVENTS 	WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *TOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return TOTAL;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
}
                                                          
                                                          
                                                          
+(NSString*) GetOverNoForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    NSString *getOver = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) AS MAXOVER FROM BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            
            getOver = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return getOver;
            
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}
                                                          
+(NSString*) GetBallNoForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString *)OVERNO:(NSString*) INNINGSNO
    {
        int retVal;
        NSString *databasePath =[self getDBPath];
        //  const char *dbpath = [databasePath UTF8String];
        NSString *getMaxBall = [[NSString alloc]init];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([databasePath UTF8String], &dataBase);
        if(retVal !=0){
        }
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) AS BALLNO FROM BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,OVERNO,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getMaxBall = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getMaxBall;
                
                
            }
        }
        
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return 0;
        
    }
                                                          
                                                          
+(NSString*) GetOverStatusForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO:(NSString*) OVERNO
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    
    NSString *getOverStatus = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            
            getOverStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return getOverStatus;
            
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}
                                                          
                                                          
                                                          
                                                          
                                                          
+(NSString*) GetWicketForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    
    NSString *getWkt = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(WKT.BALLCODE) AS EXTRAWICKETCOUNT FROM BALLEVENTS BALL  LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE WHERE BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALL.TEAMCODE='%@' AND BALL.INNINGSNO='%@'  AND BALL.INNINGSNO ='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            getWkt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return getWkt;
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}
                                                          
                                                          
+(NSMutableArray *) FetchEndInningsDetailsForFetchEndInnings:(NSString*) MATCHCODE
    
{
    NSMutableArray *FetchEndInningsDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STARTTIME,ENDTIME,TEAMNAME,TOTALRUNS,TOTALOVERS,TOTALWICKETS,INNINGSNO,BATTINGTEAMCODE,IFNULL((DAYDURATION),0) AS DAYDURATION,INNINGSDURATION,CASE WHEN DAYDURATION IS NULL THEN CAST(INNINGSDURATION AS NVARCHAR)+' MINS'  ELSE CAST(DAYDURATION AS NVARCHAR)+' MINS' END AS DURATION FROM (SELECT IE.INNINGSSTARTTIME AS STARTTIME,IE.INNINGSENDTIME AS ENDTIME,((julianday(IE.INNINGSENDTIME) - julianday(IE.INNINGSSTARTTIME))) AS INNINGSDURATION,CASE WHEN DE.STARTTIME!=NULL THEN SUM(julianday(DE.ENDTIME) - julianday(DE.STARTTIME)) ELSE SUM(julianday(DE.ENDTIME) - julianday(DE.STARTTIME)) END AS DAYDURATION,TM.TEAMNAME,IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE FROM INNINGSEVENTS IE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=IE.BATTINGTEAMCODE LEFT JOIN DAYEVENTS DE ON DE.MATCHCODE=IE.MATCHCODE AND DE.BATTINGTEAMCODE=IE.BATTINGTEAMCODE AND DE.INNINGSNO=IE.INNINGSNO WHERE IE.MATCHCODE='%@' AND IE.INNINGSSTATUS='1' GROUP BY IE.INNINGSSTARTTIME, IE.INNINGSENDTIME,TM.TEAMNAME, IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE )DETAILS ORDER BY INNINGSNO",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
       
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndInnings *record=[[EndInnings alloc]init];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
            
                
                record.STARTTIME=[self getValueByNull:statement:0];
                record.ENDTIME=[self getValueByNull:statement:1];
                record.TEAMNAME=[self getValueByNull:statement:2];
                
               // record.TOTALRUNS=[self getValueByNull:statement:3];
                
                NSString *string= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                record.TOTALRUNS= @([string intValue]);
                
                record.TOTALOVERS=[self getValueByNull:statement:4];
                record.TOTALWICKETS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                record.INNINGSNO=[self getValueByNull:statement:6];
                record.BATTINGTEAMCODE=[self getValueByNull:statement:7];
                record.DAYDURATION=[self getValueByNull:statement:8];
                record.INNINGSDURATION=[self getValueByNull:statement:9];
                record.DURATION=[self getValueByNull:statement: 10];
                [FetchEndInningsDetails addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return FetchEndInningsDetails;
}
                                                          
                                                          
                                                          
+(NSString*)  GetMatchDateForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE
    {
        int retVal;
        NSString *databasePath =[self getDBPath];
        NSString *getWkt = [[NSString alloc]init];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        retVal=sqlite3_open([databasePath UTF8String], &dataBase);
        if(retVal !=0){
        }
        
        NSString *query=[NSString stringWithFormat:@"SELECT MATCHDATE AS STARTDATE FROM   MATCHREGISTRATION WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getWkt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getWkt;
                
                
            }
        }
        
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return 0;
        
    }

//-----------------------------------------------------------------------------------------------------
//SP_DELETEENDINNINGS

+(NSString*) GetMatchTypeUsingCompetitionForDeleteEndInnings:(NSString*) COMPETITIONCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHTYPE FROM COMPETITION where COMPETITIONCODE = '%@'",COMPETITIONCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MATCHTYPE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MATCHTYPE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
    
}

+(BOOL) GetBallCodeForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO >'%@'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) GetInningsNoForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT INNINGSNO FROM INNINGSEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO >'%@' AND INNINGSSTATUS=1",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        

        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
             
                
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
            
                
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) UpdateInningsEventForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO{
    
     NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS  SET  INNINGSSTARTTIME='',INNINGSENDTIME='',TOTALRUNS='',TOTALOVERS='',TOTALWICKETS='',INNINGSSTATUS='0',ISDECLARE='0'  WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
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
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}


+(BOOL) DeleteInningsEventForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM INNINGSEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'+1",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteOverEventsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM OVEREVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'+1",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteBowlerOverDetailsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'+1",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteSessionEventsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'+1",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
}

+(NSString*) GetSessionNoForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONNO FROM  SESSIONEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND SESSIONSTATUS='0'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                NSString *SESSIONNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                return SESSIONNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}

+(BOOL) DeleteSessionEventsInInningsEntryForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@' AND INNINGSNO='%@' AND  SESSIONNO=(SELECT MAX(SESSIONNO) FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@'  AND INNINGSNO='%@' AND  SESSIONSTATUS='0')",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteDayEventsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'+1",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(NSString*) GetDayNoForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYSTATUS='0'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *DAYNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return DAYNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}

+(BOOL) DeleteDayEventsInInningsEntryForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO=(SELECT MAX(DAYNO) FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND 	DAYSTATUS='0')",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeletePenaltyDetailsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM PENALTYDETAILS WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@'  AND INNINGSNO ='%@' + 1",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(NSString*) GetInningsCountForDeleteEndInnings:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(INNINGSNO) FROM INNINGSEVENTS WHERE MATCHCODE ='%@'",MATCHCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
        NSString *INNINGSNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            
                
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return INNINGSNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return @"";
}

+(BOOL) UpdatematchRegistrationForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = 'MSC124',MODIFIEDBY = 'USER',MODIFIEDDATE= GETDATE()  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(NSMutableArray *) GetInningsDetailsForDeleteEndInnings:(NSString*) MATCHCODE
{
    NSMutableArray *InningsArrayForDelete=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STARTTIME,ENDTIME,TEAMNAME,TOTALRUNS,TOTALOVERS,TOTALWICKETS,INNINGSNO,BATTINGTEAMCODE,IFNULL((DAYDURATION),0) AS DAYDURATION,INNINGSDURATION,CASE WHEN DAYDURATION IS NULL THEN CAST(INNINGSDURATION AS NVARCHAR)+' MINS'  ELSE CAST(DAYDURATION AS NVARCHAR)+' MINS' END AS DURATION FROM (SELECT IE.INNINGSSTARTTIME AS STARTTIME,IE.INNINGSENDTIME AS ENDTIME,((julianday(IE.INNINGSENDTIME) - julianday(IE.INNINGSSTARTTIME))) AS INNINGSDURATION,CASE WHEN DE.STARTTIME!=NULL THEN SUM(julianday(DE.ENDTIME) - julianday(DE.STARTTIME)) ELSE SUM(julianday(DE.ENDTIME) - julianday(DE.STARTTIME)) END AS DAYDURATION,TM.TEAMNAME,IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE FROM INNINGSEVENTS IE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=IE.BATTINGTEAMCODE LEFT JOIN DAYEVENTS DE ON DE.MATCHCODE=IE.MATCHCODE AND DE.BATTINGTEAMCODE=IE.BATTINGTEAMCODE AND DE.INNINGSNO=IE.INNINGSNO WHERE IE.MATCHCODE='%@' AND IE.INNINGSSTATUS='1' GROUP BY IE.INNINGSSTARTTIME, IE.INNINGSENDTIME,TM.TEAMNAME, IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE )DETAILS ORDER BY INNINGSNO",MATCHCODE];
        
  
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
      
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EndInnings *record=[[EndInnings alloc]init];
                record.STARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.ENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.TOTALOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.TOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.DAYDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.INNINGSDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.DURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                [InningsArrayForDelete addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return InningsArrayForDelete;
}



+(BOOL) GetSessionNoForDeleteEndInninges:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) OLDINNINGSNO {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT SESSIONNO FROM SESSIONEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND SESSIONSTATUS='0'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

//---------------------------------------------------------------------------------------------------------

@end




