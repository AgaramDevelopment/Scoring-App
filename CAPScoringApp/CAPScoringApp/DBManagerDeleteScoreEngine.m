//
//  DBManagerDeleteScoreEngine.m
//  CAPScoringApp
//
//  Created by mac on 09/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerDeleteScoreEngine.h"

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

-(NSInteger)GetMaxOverNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS
{
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

-(NSInteger)GetMaxBallNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER
{
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

-(NSInteger)GetMaxBallCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL
{
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

-(NSInteger)GetMaxSessionNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL : (NSInteger)MAXBALLCOUNT
{
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

-(NSInteger)GetMaxDayNoForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSInteger)MAXINNINGS : (NSInteger)MAXOVER : (NSInteger)MAXBALL : (NSInteger)MAXBALLCOUNT
{
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

-(NSMutableArray *)GetBallDetailsForDeleteScoreEngine:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BALLCODE:(NSString*)BALLCODE{
    NSString *databasePath =[self getDBPath];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT TEAMCODE, INNINGSNO, OVERNO, BALLNO, BALLCOUNT, NOBALL, WIDE , STRIKERCODE, BOWLERCODE, NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *BATTINGTEAMCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *S_INNINGSNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *S_OVERNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString *S_BALLNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSString *S_BALLCOUNT = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                NSString *S_NOBALL = [self getValueByNull:statement :5];
                NSString *S_WIDE = [self getValueByNull:statement :5];
                NSString *SB_STRIKERCODE = [self getValueByNull:statement :5];
                NSString *SB_BOWLERCODE = [self getValueByNull:statement :5];
                NSString *SB_NONSTRIKERCODE = [self getValueByNull:statement :5];
                
                [result addObject:BATTINGTEAMCODE];
                [result addObject:S_INNINGSNO];
                [result addObject:S_OVERNO];
                [result addObject:S_BALLNO];
                [result addObject:S_BALLCOUNT];
                [result addObject:S_NOBALL];
                [result addObject:S_WIDE];
                [result addObject:SB_STRIKERCODE];
                [result addObject:SB_BOWLERCODE];
                [result addObject:SB_NONSTRIKERCODE];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
}

-(NSString*) GetBowlingTeamForDeleteScoreEngine:(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE{
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

-(NSInteger)GetBatteamOversForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)MAXINNINGS
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %ld AND OVERSTATUS = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)MAXINNINGS];
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
-(NSInteger)GetBatteamOversWithExtraBallsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)MAXINNINGS : (NSInteger)BATTEAMOVERS
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %ld AND OVERNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)MAXINNINGS,(long)BATTEAMOVERS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger BatteamOversWithExtraBalls = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
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

-(NSInteger)GetBatteamOversBallsCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)MAXINNINGS : (NSInteger)BATTEAMOVERS : (NSInteger)BATTEAMOVRWITHEXTRASBALLS
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),0) FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %ld AND OVERNO = %ld AND BALLNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)MAXINNINGS,(long)BATTEAMOVERS,(long)BATTEAMOVRWITHEXTRASBALLS];
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

-(NSMutableArray *)GetCurrentPlayersDetailsForDeleteScoreEngine : (NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString*)BATTINGTEAMCODE INNINGSNO:(NSInteger)INNINGSNO BATTEAMOVERS:(NSInteger)BATTEAMOVERS BATTEAMOVRWITHEXTRASBALLS:(NSInteger)BATTEAMOVRWITHEXTRASBALLS BATTEAMOVRBALLSCNT:(NSInteger)BATTEAMOVRBALLSCNT{
    NSString *databasePath =[self getDBPath];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT STRIKERCODE, NONSTRIKERCODE, BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %ld AND OVERNO = %ld AND BALLNO = %ld AND BALLCOUNT = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO,(long)BATTEAMOVERS,(long)BATTEAMOVRWITHEXTRASBALLS,(long)BATTEAMOVRBALLSCNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *CURRENTSTRIKERCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *CURRENTNONSTRIKERCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *CURRENTBOWLERCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [result addObject:CURRENTSTRIKERCODE];
                [result addObject:CURRENTNONSTRIKERCODE];
                [result addObject:CURRENTBOWLERCODE];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
}

-(BOOL) UpdateInningsEventsWithCurrentValuesForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)INNINGSNO : (NSString*)CURRENTSTRIKERCODE : (NSString*)CURRENTNONSTRIKERCODE : (NSString*)CURRENTBOWLERCODE : (NSInteger)BATTEAMOVRWITHEXTRASBALLS : (NSInteger)BATTEAMOVRBALLSCNT
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET CURRENTSTRIKERCODE = '%@', CURRENTNONSTRIKERCODE = '%@', CURRENTBOWLERCODE = CASE WHEN (%ld = 1 AND %ld = 1) THEN CURRENTBOWLERCODE ELSE '%@' END WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %ld",CURRENTSTRIKERCODE,CURRENTNONSTRIKERCODE,(long)BATTEAMOVRWITHEXTRASBALLS,(long)BATTEAMOVRBALLSCNT,CURRENTBOWLERCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO];
        
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

-(BOOL) UpdateInningsEventsWithExistingValuesForDeleteScoreEngine: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)INNINGSNO
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET CURRENTSTRIKERCODE = STRIKERCODE, CURRENTNONSTRIKERCODE = NONSTRIKERCODE, CURRENTBOWLERCODE = BOWLERCODE WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %ld",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO];
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

-(NSInteger)GetWicketsCountableCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)INNINGSNO : (NSString*)BALLCODE
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%ld AND BALLCODE = '%@' AND ISWICKET = 1 AND WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger WicketsCountableCount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
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

-(NSInteger)GetIsWicketCountForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)INNINGSNO : (NSString*)BALLCODE
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%ld AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSInteger IsWicketCount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)].integerValue;
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

-(NSString*)GetWicketTypeForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)INNINGSNO : (NSString*)BALLCODE
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETTYPE FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%ld AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *WicketType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
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

-(NSString*)GetBallCodeInWicketsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)INNINGSNO : (NSString*)BALLCODE
{
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%ld AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO,BALLCODE];
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

-(NSMutableArray *)GetWicketPlayerAndNoDetailsForDeleteScoreEngine : (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)BATTINGTEAMCODE : (NSInteger)INNINGSNO : (NSString*)BALLCODE
{
    NSString *databasePath =[self getDBPath];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETNO, WICKETPLAYER FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO=%ld AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,(long)INNINGSNO,BALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *WICKETNO = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *WICKETPLAYER = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [result addObject:WICKETNO];
                [result addObject:WICKETPLAYER];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
}
@end