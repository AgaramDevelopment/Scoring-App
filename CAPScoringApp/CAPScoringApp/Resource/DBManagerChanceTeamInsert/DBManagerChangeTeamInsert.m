//
//  DBManagerChanceTeamInsert.m
//  CAPScoringApp
//
//  Created by APPLE on 01/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerChangeTeamInsert.h"
#import <sqlite3.h>
static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";
@implementation DBManagerChangeTeamInsert

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


+(BOOL) SetBallCodeForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) CURRENTBATTINGTEAM:(NSNumber*) CURRENTINNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,CURRENTBATTINGTEAM,CURRENTINNINGSNO];
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


+(BOOL) SetBallCodeForInsertChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) CURRENTINNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO >='%@'",COMPETITIONCODE,MATCHCODE,CURRENTINNINGSNO];
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


+(BOOL) DeleteInningsBreaksEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteBallEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteBattingSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from BATTINGSUMMARY WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteOverEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from OVEREVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteBowlingSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"	DELETE from BOWLINGSUMMARY WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteBowlingMaidenSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from BOWLINGMAIDENSUMMARY WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteBowlerOverDetailsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from BOWLEROVERDETAILS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteFieldingEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from FIELDINGEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteDayEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteSessionEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'	",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteAppealEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from APPEALEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteWicketEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeletePowerplayForChangeTeam:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from POWERPLAY WHERE  MATCHCODE='%@'",MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeletePlayerInOutTimeForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from PLAYERINOUTTIME WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeletePenaltyDetailsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from PENALTYDETAILS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteMatchEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from MATCHEVENTS WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteInningsSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from INNINGSSUMMARY WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteInningsEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE from INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) UpadateInningsEventsForChangeTeam:(NSString *) STRIKER:(NSString *) NONSTRIKERCODE:(NSString*) BOWLERCODE:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) BATTINGTEAMCODE:(NSNumber *) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET CURRENTSTRIKERCODE='%@',CURRENTNONSTRIKERCODE='%@',CURRENTBOWLERCODE='%@',INNINGSSTATUS=0,ISDECLARE='0' WHERE COMPETITIONCODE='%@'  AND MATCHCODE='%@'  AND TEAMCODE='%@'  AND INNINGSNO='%@'",STRIKER,NONSTRIKERCODE,BOWLERCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) DeleteInningsEventsForInsertChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'+1",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}
@end
