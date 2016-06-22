//
//  DBManagerInsertUpdateMatchResult.m
//  CAPScoringApp
//
//  Created by APPLE on 21/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerInsertUpdateMatchResult.h"

@implementation DBManagerInsertUpdateMatchResult

+(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}


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

+(BOOL)  UpdateCompetitionForInsertMatchResult:(NSString*) MANOFTHESERIESCODE:(NSString*) BESTBATSMANCODE:(NSString*) BESTBOWLERCODE:(NSString*) BESTALLROUNDERCODE:(NSString*) MOSTVALUABLEPLAYERCODE:(NSString*) COMPETITIONCODE{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE  COMPETITION SET MANOFTHESERIESCODE='%@', BESTBATSMANCODE='%@',  BESTBOWLERCODE='%@' ,BESTALLROUNDERCODE= '%@',MOSTVALUABLEPLAYERCODE='%@' WHERE	COMPETITIONCODE='%@'",MANOFTHESERIESCODE,BESTBATSMANCODE,BESTBOWLERCODE,BESTALLROUNDERCODE,MOSTVALUABLEPLAYERCODE,COMPETITIONCODE];
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

+(NSString*)  GetMatchresultCodeForInsertMatchResult :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BUTTONNAME {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHRESULTCODE FROM MATCHRESULT WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND '%@'='REVERT'",COMPETITIONCODE,MATCHCODE,BUTTONNAME];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MATCHRESULTCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MATCHRESULTCODE;
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

+(BOOL) DeleteMatchResultForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM MATCHRESULT  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
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

+(NSString*)  GetMatchresultCodeInElseIfForInsertMatchResult :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BUTTONNAME {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHRESULTCODE FROM MATCHRESULT WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND ('%@'='DONE' OR '%@'='UPDATE')",COMPETITIONCODE,MATCHCODE,BUTTONNAME];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MATCHRESULTCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MATCHRESULTCODE;
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

+(BOOL)  InsertMatchResultForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS :(NSString*) MANOFTHEMATCHCODE :(NSString*) COMMENTS;{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO MATCHRESULT   (  COMPETITIONCODE, 	MATCHCODE, 	MATCHRESULTCODE, 	MATCHWONTEAMCODE, 	TEAMAPOINTS,TEAMBPOINTS,	MANOFTHEMATCHCODE, 	COMMENTS) 	VALUES 	( 	'%@', 	'%@',  '%@','%@' , '%@' , '%@', '%@', '%@' )",COMPETITIONCODE,MATCHCODE,MATCHRESULTCODE,MATCHWONTEAMCODE,TEAMAPOINTS,TEAMBPOINTS,MANOFTHEMATCHCODE,COMMENTS];
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

+(BOOL)  UpdateMatchRegistrationForInsertMatchResult:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE [MATCHREGISTRATION]  SET [MATCHRESULT] = '' ,[MATCHRESULTTEAMCODE] = '' ,[MATCHSTATUS] = 'MSC124'  ,[MODIFIEDBY] = 'USER'  ,[MODIFIEDDATE] = GETDATE() WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
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

+(BOOL) UpdatematchRegistrationElseifForInsertMatchResult:(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS : COMPETITIONCODE:(NSString*) MATCHCODE {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE [MATCHREGISTRATION] SET [MATCHRESULT] = '%@' ,[MATCHRESULTTEAMCODE] = '%@' ,[TEAMAPOINTS] = '%@' ,[TEAMBPOINTS] = '%@' ,[MATCHSTATUS] = 'MSC125'  ,[MODIFIEDBY] = 'USER'				  ,[MODIFIEDDATE] = GETDATE()			 WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",MATCHRESULTCODE,MATCHWONTEAMCODE,TEAMAPOINTS,TEAMBPOINTS,COMPETITIONCODE,MATCHCODE];
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

+(BOOL) UpdatematchResultForInsertMatchResult:(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS :(NSString*) MANOFTHEMATCHCODE :(NSString*) COMMENTS : COMPETITIONCODE:(NSString*) MATCHCODE {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE  MATCHRESULT 	SET MATCHRESULTCODE='%@',MATCHWONTEAMCODE='%@',TEAMAPOINTS='%@',TEAMBPOINTS= '%@',	MANOFTHEMATCHCODE='%@',	COMMENTS='%@'	WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",MATCHRESULTCODE,MATCHWONTEAMCODE,TEAMAPOINTS,TEAMBPOINTS,MANOFTHEMATCHCODE,COMMENTS,COMPETITIONCODE,MATCHCODE];
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

+(BOOL) UpdatematchRegistrationinElseForInsertMatchResult:(NSString*) MATCHRESULTCODE : (NSString*) MATCHWONTEAMCODE : (NSString*) TEAMAPOINTS : (NSString*) TEAMBPOINTS: COMPETITIONCODE:(NSString*) MATCHCODE {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE [MATCHREGISTRATION]  SET [MATCHRESULT] = '%@'  ,[MATCHRESULTTEAMCODE] = '%@'  ,[TEAMAPOINTS] = '%@' ,[TEAMBPOINTS] = '%@' ,[MATCHSTATUS] = 'MSC125'  ,[MODIFIEDBY] = 'USER'  ,[MODIFIEDDATE] = GETDATE()		 WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",MATCHRESULTCODE,MATCHWONTEAMCODE,TEAMAPOINTS,TEAMBPOINTS,COMPETITIONCODE,MATCHCODE];
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



@end
