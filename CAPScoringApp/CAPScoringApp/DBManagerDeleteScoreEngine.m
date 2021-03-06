//
//  DBManagerDeleteScoreEngine.m
//  CAPScoringApp
//
//  Created by mac on 09/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerDeleteScoreEngine.h"
#import "UpdateScoreEngineRecord.h"
#import "PushSyncDBMANAGER.h"
#import "DeleteBallRecord.h"
#import "Utitliy.h"

@implementation DBManagerDeleteScoreEngine
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

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}

-(NSInteger)GetMaxInningsNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(INNINGSNO) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger MaxInningsNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MaxInningsNo;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetMaxOverNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(OVERNO) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%ld",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger MaxOverNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MaxOverNo;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetMaxBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%ld AND OVERNO=%ld",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS,(long)MAXOVER];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger MaxBallNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MaxBallNo;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetMaxBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLCOUNT) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%ld AND OVERNO=%ld AND BALLNO=%ld",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS,(long)MAXOVER,(long)MAXBALL];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger MaxBallCount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MaxBallCount;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetMaxSessionNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL : (NSInteger)MAXBALLCOUNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(SESSIONNO) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%ld AND OVERNO=%ld AND BALLNO=%ld AND BALLCOUNT='%ld'",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS,(long)MAXOVER,(long)MAXBALL,(long)MAXBALLCOUNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger MaxSessionNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MaxSessionNo;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetMaxDayNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL : (NSInteger)MAXBALLCOUNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(DAYNO) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%ld AND OVERNO=%ld AND BALLNO=%ld AND BALLCOUNT='%ld'",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS,(long)MAXOVER,(long)MAXBALL,(long)MAXBALLCOUNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger MaxDayNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MaxDayNo;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSMutableArray *)GetBallDetailsForDeleteScoreEngine:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BALLCODE:(NSString*)BALLCODE{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT TEAMCODE, INNINGSNO, OVERNO, BALLNO, BALLCOUNT, NOBALL, WIDE , STRIKERCODE, BOWLERCODE, NONSTRIKERCODE,ISFOUR,ISSIX,RUNS,OVERTHROW,PENALTY,BYES,LEGBYES FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                 DeleteBallRecord *record = [[DeleteBallRecord alloc]init];
                
               // NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                //f.numberStyle = NSNumberFormatterDecimalStyle;
                
                record.battingTeamCode = [self getValueByNull:statement :0];
                record .inningsno = [self getValueByNull:statement :1];
                record.overNo = [self getValueByNull:statement :2];
                record.ballNo = [self getValueByNull:statement :3];
                record .ballCount = [self getValueByNull:statement :4];
                record.NoBall = [self getValueByNull:statement :5];
                record.Wide = [self getValueByNull:statement :6];
                record.StrikerCode = [self getValueByNull:statement :7];
                record .bowlerCode = [self getValueByNull:statement :8];
                record .NonStrikerCode = [self getValueByNull:statement :9];
                record .isFour           =[self getValueByNull:statement :10];
                record.isSix    =[self getValueByNull:statement :11];
                record.Runs    =[self getValueByNull:statement :12];
                record.overThrow =[self getValueByNull:statement :13];
                record.Penalty    =[self getValueByNull:statement :14];
                record.Byes       =[self getValueByNull:statement :15];
                record.legByes    =[self getValueByNull:statement :16];
                [result addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}

-(NSString*) GetBowlingTeamForDeleteScoreEngine:(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE = '%@' THEN TEAMBCODE ELSE TEAMACODE END FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",BATTINGTEAMCODE,COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLINGTEAMCODE =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLINGTEAMCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSInteger)GetBatteamOversForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*) MAXINNINGS
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERSTATUS = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,MAXINNINGS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger BatteamOvers = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BatteamOvers;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}
-(NSInteger)GetBatteamOversWithExtraBallsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber *)MAXINNINGS : (NSInteger)BATTEAMOVERS
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,MAXINNINGS,(long)BATTEAMOVERS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger BatteamOversWithExtraBalls = [self getValueByNull:statement :0].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BatteamOversWithExtraBalls;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetBatteamOversBallsCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)MAXINNINGS : (NSInteger)BATTEAMOVERS : (NSInteger)BATTEAMOVRWITHEXTRASBALLS
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),1) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = %ld AND BALLNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,MAXINNINGS,(long)BATTEAMOVERS,(long)BATTEAMOVRWITHEXTRASBALLS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger BatteamOversBallsCount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BatteamOversBallsCount;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSMutableArray *)GetCurrentPlayersDetailsForDeleteScoreEngine : (NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString*)BATTINGTEAMCODE INNINGSNO:(NSNumber*)INNINGSNO BATTEAMOVERS:(NSInteger)BATTEAMOVERS BATTEAMOVRWITHEXTRASBALLS:(NSInteger)BATTEAMOVRWITHEXTRASBALLS BATTEAMOVRBALLSCNT:(NSInteger)BATTEAMOVRBALLSCNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT STRIKERCODE, NONSTRIKERCODE, BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %@ AND OVERNO = %ld AND BALLNO = %ld AND BALLCOUNT = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,(long)BATTEAMOVERS,(long)BATTEAMOVRWITHEXTRASBALLS,(long)BATTEAMOVRBALLSCNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
               // NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                //f.numberStyle = NSNumberFormatterDecimalStyle;
                DeleteBallRecord * record =[[DeleteBallRecord alloc]init];
                
                record.CurrentStrikercode = [self getValueByNull:statement :0];
                record.CurrentNonStrikerCode = [self getValueByNull:statement :1];
                record.CurrenBowlerCode = [self getValueByNull:statement :2];
                
                //[result addObject:CURRENTSTRIKERCODE];
               // [result addObject:CURRENTNONSTRIKERCODE];
                [result addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}

-(BOOL) UpdateInningsEventsWithCurrentValuesForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)CURRENTSTRIKERCODE : (NSString*)CURRENTNONSTRIKERCODE : (NSString*)CURRENTBOWLERCODE : (NSInteger)BATTEAMOVRWITHEXTRASBALLS : (NSInteger)BATTEAMOVRBALLSCNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET CURRENTSTRIKERCODE = '%@', CURRENTNONSTRIKERCODE = '%@', CURRENTBOWLERCODE = CASE WHEN (%ld = 1 AND %ld = 1) THEN CURRENTBOWLERCODE ELSE '%@' END WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %@",CURRENTSTRIKERCODE,CURRENTNONSTRIKERCODE,(long)BATTEAMOVRWITHEXTRASBALLS,(long)BATTEAMOVRBALLSCNT,CURRENTBOWLERCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(BOOL) UpdateInningsEventsWithExistingValuesForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET CURRENTSTRIKERCODE = STRIKERCODE, CURRENTNONSTRIKERCODE = NONSTRIKERCODE, CURRENTBOWLERCODE = BOWLERCODE WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(NSNumber *)GetWicketsCountableCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO = %@ AND BALLCODE = '%@' AND ISWICKET = 1 AND WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumber* WicketsCountableCount =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WicketsCountableCount;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSNumber *)GetIsWicketCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO = %@ AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumber* IsWicketCount = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return IsWicketCount;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSString *)GetWicketTypeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETTYPE FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO = %@ AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *WicketType = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WicketType;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSString*)GetBallCodeInWicketsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO = %@ AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSMutableArray *)GetWicketPlayerAndNoDetailsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETNO, WICKETPLAYER FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO= %@ AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                DeleteBallRecord *objRecord =[[DeleteBallRecord alloc]init];
                objRecord.wicketNo = [self getValueByNull:statement :0];
                objRecord.wicketPlayer = [self getValueByNull:statement :1];
                
                [result addObject:objRecord];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}

-(BOOL) DeleteWicketEventsWithBallCodeForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO = %@ AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(BOOL) UpdateWicketEventsWicketNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSNumber*)WICKETNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETNO = WICKETNO - 1 WHERE WICKETNO > %ld AND BALLCODE IN ( SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO = %@ )",(long)WICKETNO,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(BOOL) DeletePenaltyDetailsForDeleteScoreEngine: (NSString*) BALLCODE :(NSString *)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from PENALTYDETAILS WHERE BALLCODE = '%@'",BALLCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"PENALTYDETAILS" :@"MSC252" :updateSQL];
                
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
}

-(BOOL) DeleteAppealDetailsForDeleteScoreEngine: (NSString*) BALLCODE :(NSString *)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM APPEALEVENTS WHERE BALLCODE = '%@'",BALLCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                 PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"APPEALEVENTS" :@"MSC252" :updateSQL];
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
}

-(BOOL) DeleteFieldingDetailsForDeleteScoreEngine: (NSString*) BALLCODE :(NSString *)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM FIELDINGEVENTS WHERE BALLCODE = '%@'",BALLCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"FIELDINGEVENTS" :@"MSC252" :updateSQL];
                
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
}

-(BOOL) DeleteBallEventDetailsForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BALLCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC252" :updateSQL];
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
}

-(NSString*)GetBowlerCodeInCurrentOverForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSString*)BOWLERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND	  MATCHCODE = '%@' AND   INNINGSNO = %@ AND   OVERNO = %@ AND   BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *Bowlercode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return Bowlercode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(BOOL)  UpdateBowlingOrderDeleteScoreEngine : (NSString*) MATCHCODE :(NSString*) BOWLINGTEAMCODE :(NSString*) BATTINGTEAMCODE : (NSNumber*) INNINGSNO

{
    @synchronized ([Utitliy syncId]) {
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
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGSUMMARY WHERE MATCHCODE = '%@' AND BOWLINGTEAMCODE =	'%@' AND INNINGSNO = %@ ", MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            //Deleted
             PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
            [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC252" :updateSQL];
            

        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
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
                
                //ADDED
                
                 PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC250" :updateSQL];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
    }
    return  YES;
	}
}

-(BOOL)DeleteRemoveUnusedBatFBSDeleteScoreEngine : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) TEAMCODE : (NSNumber*) INNINGSNO

{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = %@ AND BATSMANCODE IN (SELECT BS.BATSMANCODE FROM BATTINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE AND BS.BATTINGTEAMCODE = BE.TEAMCODE AND BS.INNINGSNO = BE.INNINGSNO AND (BS.BATSMANCODE = BE.STRIKERCODE OR BS.BATSMANCODE = BE.NONSTRIKERCODE) WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@' AND BS.BATTINGTEAMCODE = '%@' AND BS.INNINGSNO = %@ AND BE.STRIKERCODE IS NULL)",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
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
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}



-(BOOL)  DeleteRemoveUnusedBowFBSDeleteScoreEngine : (NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSNumber*)INNINGSNO : (NSString*) BOWLINGTEAMCODE

{
   @synchronized ([Utitliy syncId]) { 
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = %@ AND BOWLERCODE IN(SELECT BS.BOWLERCODE FROM BOWLINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE	AND BS.INNINGSNO = BE.INNINGSNO AND BS.BOWLERCODE = BE.BOWLERCODE WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@'	AND BS.BOWLINGTEAMCODE = '%@' AND BS.INNINGSNO = %@ AND BE.BOWLERCODE IS NULL)" ,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
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
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}

-(BOOL)  UpdateOverBallCountInBallEventtForInsertScoreEngine : (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSString*) OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *ballEventArray = [[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BM.BALLCODE, BM.COMPETITIONCODE, BM.MATCHCODE, BM.TEAMCODE, BM.INNINGSNO, BM.OVERNO, BM.BALLNO, BM.BALLCOUNT, (SELECT COUNT(1) FROM BALLEVENTS BEVNT WHERE BEVNT.COMPETITIONCODE = BM.COMPETITIONCODE AND BEVNT.MATCHCODE = BM.MATCHCODE AND BEVNT.TEAMCODE = BM.TEAMCODE AND BEVNT.INNINGSNO = BM.INNINGSNO AND BEVNT.OVERNO = BM.OVERNO AND (BEVNT.OVERNO || '.' || BEVNT.BALLNO || BEVNT.BALLCOUNT) <= (BM.OVERNO || '.' || BM.BALLNO || BM.BALLCOUNT)) OVERBALLCOUNT FROM (SELECT BE.BALLCODE, BE.COMPETITIONCODE, BE.MATCHCODE, BE.TEAMCODE, BE.INNINGSNO, BE.OVERNO, BE.BALLNO, BE.BALLCOUNT FROM BALLEVENTS BE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.TEAMCODE = '%@' AND BE.INNINGSNO = %@ AND BE.OVERNO = '%@') BM",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BallEventSummaryRecord *record = [[BallEventSummaryRecord alloc]init];
                
                record.BALLCODE = [self getValueByNull: statement:0];
                record.COMPETITIONCODE = [self getValueByNull: statement:1];
                record.MATCHCODE = [self getValueByNull: statement:2];
                record.TEAMCODE = [self getValueByNull: statement:3];
                record.INNINGSNO = [self getValueByNull: statement:4];
                record.OVERNO = [self getValueByNull: statement:5];
                record.BALLNO = [self getValueByNull: statement:6];
                record.BALLCOUNT = [self getValueByNull: statement:7];
                record.OVERBALLCOUNT = [self getValueByNull: statement:8];
                
                [ballEventArray addObject:record];
                
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);    
    for(int i =0;i<ballEventArray.count;i++){
        
        BallEventSummaryRecord *record = [ballEventArray objectAtIndex:i];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET OVERBALLCOUNT = '%@' 	 WHERE BALLCODE = '%@' AND COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND TEAMCODE = '%@' AND OVERNO = %@",record.OVERBALLCOUNT,record.BALLCODE, record.COMPETITIONCODE,record.MATCHCODE,record.INNINGSNO, record.TEAMCODE ,record.OVERNO];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //ADDED
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
            }
            else
            {      sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
            }
            
        }
        // sqlite3_reset(statement);
       // sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    
    return  YES;
	}
}

-(NSInteger)GetCurrentOverBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALLCODE) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger CURRENTOVERBALLCOUNT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return CURRENTOVERBALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSString*)GetBallCodeCountInFutureOversForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO > %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(BOOL) UpdateOverEventWithOverStatusForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE OVEREVENTS SET OVERSTATUS = 0 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"OVEREVENTS" :@"MSC251" :updateSQL];
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
}

-(BOOL) DeleteOverEventInFutureOverForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO > %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"OVEREVENTS" :@"MSC252" :updateSQL];
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
}

-(BOOL) UpdateBowlerOverEventWithOverStatusForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLEROVERDETAILS SET ENDTIME = '' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLEROVERDETAILS" :@"MSC251" :updateSQL];
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
}

-(BOOL) DeleteBowlerOverEventInFutureOverForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO > %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(BOOL) UpdateBallEventForBallCountWithOldBallCountForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSNumber *)BALLCOUNT : (NSNumber *)BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLCOUNT = (%@ + BALLCOUNT) - 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = %@ AND BALLNO = %@ + 1",BALLCOUNT,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BALLNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(BOOL) UpdateBallEventForBallNoWithOldBallNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSNumber *)BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO - 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = '%@' AND BALLNO > %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BALLNO];
        
        
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(BOOL) UpdateBallEventForBallCountOnlyWithOldBallCountForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSNumber *)BALLCOUNT : (NSNumber *)BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLCOUNT = BALLCOUNT - 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT > '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(NSString*)GetBallCodeCountWithCurrentOverBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSNumber*)BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO = %@ AND OVERNO = '%@' AND BALLNO = %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BALLNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSString*)GetBallCodeCountWithCurrentOverBallNoAndPreviousBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSNumber *)BALLNO : (NSNumber *)BALLCOUNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT = %@ - 1",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSInteger)GetMaxOverBallCountWithCurrentOverNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSNumber *)BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLCOUNT) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BALLNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger CURRENTOVERBALLCOUNT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return CURRENTOVERBALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSString*)GetBallCodeCountWithCurrentOverBallNoAndPreviousBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSNumber *)BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = '%@' AND BALLNO = '%@' - 1",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BALLNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSInteger)GetMaxOverBallCountWithCurrentOverBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSInteger )BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLCOUNT) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = '%@' AND BALLNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,(long)BALLNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger CURRENTOVERBALLCOUNT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return CURRENTOVERBALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetMaxOverBallNoWithCurrentOverBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger CURRENTOVERBALLCOUNT = [self getValueByNull:statement :0].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return CURRENTOVERBALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetMaxOverBallNoWithCurrentOverNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,(long)OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger CURRENTOVERBALLCOUNT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return CURRENTOVERBALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;}
}

-(NSInteger)GetMaxOverBallCountWithCurrentOverNoAndBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO : (NSInteger)BALLNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLCOUNT) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = '%@' AND BALLNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,(long)BALLNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger CURRENTOVERBALLCOUNT = [self getValueByNull:statement :0].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return CURRENTOVERBALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSString*)GetBallCodeWithCurrentOverBallNoAndBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO : (NSInteger)BALLNO : (NSInteger)BALLCOUNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO=%@ AND OVERNO = '%@' AND BALLNO = %ld AND BALLCOUNT = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,(long)BALLNO,(long)BALLCOUNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSString*)GetBallCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSString*)BOWLERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(BOOL) DeleteBowlerOverEventForCurrentOverNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSNumber*)INNINGSNO : (NSString*)OVERNO : (NSString*)BOWLERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(NSString*)GetOtherBowlerCodeWithCurrentOverAndBowlerCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSString*)BOWLERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO = %@ AND BOWLERCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *OtherBowlerCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OtherBowlerCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSInteger)GetOtherBowlerCodeWithCurrentOverAndBowlerForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO
{
    @synchronized ([Utitliy syncId]) {
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
        {
            // NSString *query=[NSString stringWithFormat:@"SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO = %ld AND BOWLERCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
            NSString *query=[NSString stringWithFormat:@"SELECT BOWLERCODE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO = %@",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
            
            stmt=[query UTF8String];
            if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSString *OtherBowlerCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return OtherBowlerCode;
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
        }
        return @"";
    }
}

-(NSInteger)GetOtherBowlerOverBallCountWithCurrentOverAndBowlerCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO : (NSString*) OTHERBOWLERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO = %@ AND BOWLERCODE = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,OTHERBOWLERCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger OTHERBOWLEROVERBALLCNT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OTHERBOWLEROVERBALLCNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSInteger)GetOtherBowlerOverStatusWithCurrentOverForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSNumber*)INNINGSNO : (NSString *)OVERNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger ISOVERCOMPLETE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return ISOVERCOMPLETE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(BOOL) UpdateOtherBowlerBowlingSummaryForCurrentOverNoForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSNumber*)INNINGSNO : (NSInteger)OVERNO : (NSString*)OTHERBOWLER : (NSInteger)ISOVERCOMPLETE : (NSInteger)OTHERBOWLEROVERBALLCNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = CASE WHEN %ld = 1 THEN OVERS + 1 ELSE OVERS END, BALLS = CASE WHEN %ld = 1 THEN 0 ELSE BALLS + %ld END, PARTIALOVERBALLS = PARTIALOVERBALLS - %ld WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND BOWLERCODE = '%@'",(long)ISOVERCOMPLETE,(long)ISOVERCOMPLETE,(long)OTHERBOWLEROVERBALLCNT,(long)OTHERBOWLEROVERBALLCNT,COMPETITIONCODE,MATCHCODE,INNINGSNO,OTHERBOWLER];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(NSString*)GetBallCodeWithCurrentMatchCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BallCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(BOOL) UpdateMatchStatusBasedOnMatchCodeForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = 'MSC240' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
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
}

-(NSMutableArray *)GetWicketOverNoAndBallNoAndBallCountWithStrikerAndNonStrikerForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)TEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BATSMANCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BE.OVERNO, BE.BALLNO, BE.BALLCOUNT FROM BALLEVENTS BE INNER JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE = BE.COMPETITIONCODE AND WE.MATCHCODE = BE.MATCHCODE AND WE.TEAMCODE = BE.TEAMCODE AND WE.INNINGSNO = BE.INNINGSNO AND WE.BALLCODE = BE.BALLCODE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.TEAMCODE = '%@' AND BE.INNINGSNO = %@ AND WE.WICKETTYPE = 'MSC102' AND WE.WICKETPLAYER = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BATSMANCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString* OVERNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString* BALLNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString* BALLCOUNT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [result addObject:OVERNO];
                [result addObject:BALLNO];
                [result addObject:BALLCOUNT];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}

-(NSInteger)GetBallCodeCountWithWicketBallNoOverNoBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)TEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BATSMANCODE :(NSString *) nonStriker: (NSInteger)W_OVERNO : (NSInteger)W_BALLNO : (NSInteger)W_BALLCOUNT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BE.BALLCODE) FROM BALLEVENTS BE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.TEAMCODE = '%@' AND BE.INNINGSNO = %@ AND (BE.STRIKERCODE = '%@' OR BE.NONSTRIKERCODE = '%@') AND (BE.OVERNO) + '.' + (BE.BALLNO) + (BE.BALLCOUNT) >(%ld) + '.' + (%ld) + (%ld)",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BATSMANCODE,nonStriker,W_OVERNO,W_BALLNO,W_BALLCOUNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger BALLCODECO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODECO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(BOOL) UpdateWicketTypeBasedOnMatchCodeBatmanForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)TEAMCODE : (NSNumber*)INNINGSNO : (NSString*)BATSMANCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETTYPE = 'MSC102' WHERE (COMPETITIONCODE || MATCHCODE || BATTINGTEAMCODE || INNINGSNO || BATSMANCODE) IN ( SELECT WE.COMPETITIONCODE || WE.MATCHCODE || WE.TEAMCODE || WE.INNINGSNO || WE.WICKETPLAYER FROM WICKETEVENTS WE WHERE WE.COMPETITIONCODE = '%@' AND WE.MATCHCODE = '%@' AND WE.TEAMCODE = '%@' AND  WE.INNINGSNO = %@ AND WE.WICKETPLAYER = '%@' AND WE.WICKETTYPE = 'MSC102') AND (WICKETTYPE IS NULL OR  WICKETTYPE = '') ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BATSMANCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(NSString*)GetMatchCodeWithMatchCodeAndResultForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MATCHCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND (MATCHRESULT NOT IN ('','Select'))",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *ResultMatchCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return ResultMatchCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSString*)GetTossWonTeamWithMatchCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT TOSSWONTEAMCODE FROM MATCHEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *TossWonTeam = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TossWonTeam;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}

-(NSString*)GetBallCodeFromBallEventsWithMatchCodeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BALLCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
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
}

-(BOOL) UpdateMatchRegistrationWithMatchResultBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)MATCHRESULT : (NSString*)MATCHSTATUS
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHRESULT = '%@', MATCHRESULTTEAMCODE = '%@', MATCHSTATUS='%@' WHERE  COMPETITIONCODE='%@' AND MATCHCODE = '%@'",MATCHRESULT,MATCHRESULT,MATCHSTATUS,COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
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
}

-(BOOL) UpdateMatchResultBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)MATCHRESULT
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHRESULT SET MATCHRESULTCODE='%@', MATCHWONTEAMCODE='%@', TEAMAPOINTS=0, TEAMBPOINTS=0,COMMENTS='' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",MATCHRESULT,MATCHRESULT,COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHRESULT" :@"MSC251" :updateSQL];
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
}

-(BOOL) DeleteSessionBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXSESSIONNO : (NSInteger)MAXDAYNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO>=%ld AND SESSIONNO>=%ld AND DAYNO>=%ld",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS,(long)MAXSESSIONNO,(long)MAXDAYNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"SESSIONEVENTS" :@"MSC252" :updateSQL];
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
}

-(BOOL) DeleteDayEventsBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXSESSIONNO : (NSInteger)MAXDAYNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO>=%ld AND DAYNO>=%ld",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS,(long)MAXDAYNO];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"DAYEVENTS" :@"MSC252" :updateSQL];
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
}

-(BOOL) UpdateInningsEventsBasedOnMatchCodeForDeleteScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET INNINGSSTARTTIME=NULL, INNINGSENDTIME=NULL, INNINGSSTATUS= 0 WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%ld",COMPETITIONCODE,MATCHCODE,(long)MAXINNINGS];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
	}
}
-(BOOL)ScoreboardUpdate:(NSString *)matchcode:(NSString *)competioncode:(NSInteger)inningsno
{
    @synchronized ([Utitliy syncId]) {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BS SET WICKETOVERNO=BE.OVERNO,WICKETBALLNO=(CASE WHEN (BE.WIDE + BE.NOBALL) > 0 THEN BE.BALLNO -1 ELSE BE.BALLNO END),WICKETSCORE=(SELECT SUM(GRANDTOTAL) FROM BALLEVENTS BES WHERE BES.COMPETITIONCODE='%@' AND BES.MATCHCODE='%@' AND BES.INNINGSNO=%ld AND (( CAST(CAST(BES.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BES.BALLNO AS NVARCHAR(MAX)) AS FLOAT)) BETWEEN 0.0 AND  CAST(CAST(BE.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BE.BALLNO AS NVARCHAR(MAX)) AS FLOAT))) FROM BATTINGSUMMARY BS INNER JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE=BS.COMPETITIONCODE AND WE.MATCHCODE=BS.MATCHCODE AND WE.INNINGSNO=BS.INNINGSNO AND WE.WICKETPLAYER=BS.BATSMANCODE AND BS.WICKETTYPE IS NOT NULL INNER JOIN BALLEVENTS BE ON BE.BALLCODE =WE.BALLCODE WHERE BS.COMPETITIONCODE='%@' AND BS.MATCHCODE='%@' AND BS.INNINGSNO=%ld",competioncode,matchcode,(long)inningsno,competioncode,matchcode,(long)inningsno];
            const char *selectStmt = [updateSQL UTF8String];
            if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                    [objPushSyncDBMANAGER InsertTransactionLogEntry:matchcode :@"BALLEVENTS" :@"MSC251" :updateSQL];
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
}



@end
