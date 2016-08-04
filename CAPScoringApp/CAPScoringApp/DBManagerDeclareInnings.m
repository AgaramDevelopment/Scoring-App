//
//  DBManagerDeclareInnings.m
//  CAPScoringApp
//
//  Created by mac on 27/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerDeclareInnings.h"

@implementation DBManagerDeclareInnings

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



//SP_UPDATEDECLAREINNINGS------------------------------------------------------------------------

-(BOOL) GetBallCodeForUpdateDeclareInnings:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
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

-(NSString*) GetTeamNameForUpdateDeclareInnings:(NSString*) TEAMCODE
    
    
    {
        int retVal;
        NSString *databasePath =[self getDBPath];
        sqlite3 *dataBase;
        const char *stmt;
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
        {
    NSString *query=[NSString stringWithFormat:@"SELECT TEAMNAME FROM TEAMMASTER WHERE TEAMCODE= '%@' ",TEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TeamName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TeamName;

            }
        }
    
        sqlite3_close(dataBase);
        }
        return 0;
        
    }
    
    



-(NSString*) GetTotalRunForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TOTAL =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
            }
            
        }
         sqlite3_close(dataBase);
    }
   
    return @"";
}


-(NSString*) GetOverNoForUpdateDeclareInnings:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) TEAMCODE:(NSString*)INNINGSNO
    
    
    {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) AS MAXOVER FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
            const char *update_stmt = [updateSQL UTF8String];
            if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
                
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *overNo =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return overNo;
                }
                
            }
             sqlite3_close(dataBase);
        }
   
        return @"";
    }
        
        

-(NSString*) GetBallNoForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) OVERNO:(NSString*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) AS BALLNO FROM BALLEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,OVERNO,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
       
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLNO;
            }
            
        }
         sqlite3_close(dataBase);
    
    }

    return @"";
}

-(NSString*) GetOverStatusForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) OVERNO:(NSString*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,OVERNO,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
       
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OVERSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OVERSTATUS;
            }
            
        }
      sqlite3_close(dataBase);
    }
   
    return @"";
}

-(NSString*)GetWicketForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALLCODE) AS EXTRAWICKETCOUNT  FROM WICKETEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
      
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *EXTRAWICKETCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return EXTRAWICKETCOUNT;
            }
            
        }
     sqlite3_close(dataBase);
    }
    
    return @"";
}

-(BOOL) UpdateInningsEventForUpdateDeclareInnings:(NSString*) TEAMCODE:(NSString*) TOTALRUN:(NSString*) OVERBALLNO:(NSString*)WICKETS:(NSString*) ISDECLARE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET BATTINGTEAMCODE='%@',TOTALRUNS='%@',TOTALOVERS='%@',TOTALWICKETS='%@', INNINGSSTATUS='%@',ISDECLARE = '%@'  WHERE  COMPETITIONCODE='%@' AND MATCHCODE = '%@' AND   	INNINGSNO = '%@'",TEAMCODE,TOTALRUN,OVERBALLNO,WICKETS,ISDECLARE,ISDECLARE,COMPETITIONCODE,MATCHCODE,INNINGSNO];
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

-(BOOL)GetBallCodeInRevertInningsForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
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



-(BOOL) UpdateInningsEventInRevertInningsForUpdateDeclareInnings:(NSString*) ISDECLARE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET INNINGSSTATUS='%@',ISDECLARE = 0 WHERE COMPETITIONCODE='%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'-1",ISDECLARE,COMPETITIONCODE,MATCHCODE,INNINGSNO];
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

-(BOOL) DeleteInningsEventForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND  INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
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

-(BOOL) DeleteMatchResultForUpdateDeclareInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM MATCHRESULT WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
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

-(NSString *) GetDeclareInningsStatus:(NSString *) COMPETITIONCODE : (NSString *)MATCHCODE :(NSString *)INNINGSNO
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISDECLARE FROM INNINGSEVENTS IE WHERE IE.COMPETITIONCODE='%@' AND IE.MATCHCODE='%@'  AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString * innsStatus =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return innsStatus;
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    return @"";
    
}


@end
