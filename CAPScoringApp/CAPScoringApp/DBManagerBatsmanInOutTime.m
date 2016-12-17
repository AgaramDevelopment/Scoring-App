//
//  DBManagerBatsmanInOutTime.m
//  CAPScoringApp
//
//  Created by APPLE on 28/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerBatsmanInOutTime.h"
#import <sqlite3.h>
#import "BatsmanPlayerList.h"
#import "PushSyncDBMANAGER.h"
#import "BatsmaninoutRecord.h"


static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";


@implementation DBManagerBatsmanInOutTime


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





-(NSMutableArray *)getBATTINGPLAYERSTATISTICS:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *) INNINGSNO :(NSString *) TeamCode
{
    
    NSMutableArray *GetBowlingTDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERNAME,PM.PLAYERCODE FROM MATCHTEAMPLAYERDETAILS MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE WHERE MTP.MATCHCODE='%@' AND MTP.TEAMCODE='%@' AND MTP.RECORDSTATUS='MSC001'",MATCHCODE,TeamCode];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                BatsmanPlayerList *record=[[BatsmanPlayerList alloc]init];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [GetBowlingTDetails addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return GetBowlingTDetails;
}

-(NSMutableArray * )getBatsManBreakTime:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *) ININGSNO :(NSString *) TeamCode
{
    NSMutableArray *GetBowlingTDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PLAYERCODE,PLAYERNAME,INTIME,OUTTIME,CAST((julianday(OUTTIME) - julianday(INTIME)) as TEXT)+' Mins' AS DURATION FROM(SELECT	PM.PLAYERCODE,PM.PLAYERNAME,INTIME,OUTTIME,CAST((julianday(INTIME) - julianday(OUTTIME)) as TEXT)+' Mins' AS DURATION FROM PLAYERINOUTTIME PTIME INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=PTIME.PLAYERCODE LEFT JOIN INNINGSBREAKEVENTS INNBRK ON INNBRK.COMPETITIONCODE='%@' AND INNBRK.MATCHCODE='%@' AND  INNBRK.INNINGSNO='%@'  AND INNBRK.ISINCLUDEINPLAYERDURATION='0' AND (INNBRK.BREAKSTARTTIME BETWEEN PTIME.INTIME AND PTIME.OUTTIME) WHERE  PTIME.COMPETITIONCODE='%@' AND PTIME.MATCHCODE='%@' AND PTIME.TEAMCODE='%@' AND PTIME.INNINGSNO='%@')AS FIN",COMPETITIONCODE,MATCHCODE,ININGSNO,COMPETITIONCODE,MATCHCODE,TeamCode,ININGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                BatsmaninoutRecord *record=[[BatsmaninoutRecord alloc]init];
                record.playercode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.startTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.EndTime=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                record.Duration=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                [GetBowlingTDetails addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return GetBowlingTDetails;

}

-(BOOL)INSERTPLAYERINOUTTIME :(NSString *) COMPETITIONCODE:(NSString *)INNINGSNO :(NSString *) MATCHCODE:(NSString *) TEAMCODE :(NSString *) PLAYERCODE :(NSString *) INTIME :(NSString *) OUTTIME
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO PLAYERINOUTTIME(COMPETITIONCODE,INNINGSNO,MATCHCODE,TEAMCODE,PLAYERCODE,INTIME,OUTTIME) VALUES('%@','%@','%@','%@','%@','%@','%@') ",COMPETITIONCODE,INNINGSNO,MATCHCODE,TEAMCODE,PLAYERCODE,INTIME,OUTTIME];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER * objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHTEAMPLAYERDETAILS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
}
-(BOOL) UPDATEPLAYERINOUT :(NSString *) COMPETITIONCODE :(NSString *)MATCHCODE :(NSString *)TEAMCODE:(NSString *)INNINGSNO:(NSString *)PLAYERCODE :(NSString *)INTIME:(NSString *)OUTTIME :(NSString *) oldplayercode
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PLAYERINOUTTIME SET PLAYERCODE='%@',INTIME		 = '%@',OUTTIME	  = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO = '%@' AND PLAYERCODE='%@'",PLAYERCODE,INTIME,OUTTIME,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,oldplayercode];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHTEAMPLAYERDETAILS" :@"MSC251" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;

}

-(BOOL) DELETEPLAYERINOUTTIME :(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE:(NSString *)INNINGSNO:(NSString *)PLAYERCODE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from PLAYERINOUTTIME WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO = '%@' AND PLAYERCODE='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,PLAYERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSBREAKEVENTS" :@"MSC252" :updateSQL];
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;

}

-(BOOL) FETCHBREAKMINUTES :(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO:(NSString *)PLAYERINTIME : (NSString *) PLAYEROUTTIME
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DATEDIFF(MINUTE,BREAKSTARTTIME,BREAKENDTIME) AS BREAKTIME FROM INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND  INNINGSNO= '%@' AND  BREAKSTARTTIME BETWEEN @PLAYERINTIME AND @PLAYEROUTTIME AND ISINCLUDEINPLAYERDURATION='0' SET NOCOUNT ON",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
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





-(NSString*) FETCHDURATION :(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO:(NSString *)PLAYERCODE
{
   // NSString *Duration = @"";
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  IFNULL(SUM((strftime('%%s', OUTTIME) - strftime('%%s', INTIME))/60),0)  AS DURATION FROM PLAYERINOUTTIME WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND PLAYERCODE = '%@' GROUP BY PLAYERCODE",COMPETITIONCODE,MATCHCODE,INNINGSNO,PLAYERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                return  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
    
}

@end
