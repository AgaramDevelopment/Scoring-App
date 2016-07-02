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
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL) DeleteInningsBreaksEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [INNINGSBREAKEVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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

+(BOOL) DeleteBallEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [BALLEVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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

+(BOOL) DeleteBattingSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [BATTINGSUMMARY] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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

+(BOOL) DeleteOverEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [OVEREVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
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

+(BOOL) DeleteBowlingSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"	DELETE [BOWLINGSUMMARY] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteBowlingMaidenSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [BOWLINGMAIDENSUMMARY] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteBowlerOverDetailsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [BOWLEROVERDETAILS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteFieldingEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [FIELDINGEVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteDayEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [DAYEVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteSessionEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [SESSIONEVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'	",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteAppealEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [APPEALEVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteWicketEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [WICKETEVENTS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeletePowerplayForChangeTeam:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [POWERPLAY] WHERE  MATCHCODE='%@'",MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeletePlayerInOutTimeForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [PLAYERINOUTTIME] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeletePenaltyDetailsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE [PENALTYDETAILS] WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteMatchEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE  MATCHEVENTS WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteInningsSummaryForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE INNINGSSUMMARY WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL) DeleteInningsEventsForChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        const char *selectStmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
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
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
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
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: Delete statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}
@end
