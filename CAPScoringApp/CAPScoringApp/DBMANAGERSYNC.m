//
//  DBMANAGERSYNC.m
//  CAPScoringApp
//
//  Created by Lexicon on 22/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBMANAGERSYNC.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "getimageRecord.h"

@implementation DBMANAGERSYNC

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

//competition insert&Update

+(BOOL) CheckCompetitionCode:(NSString *)COMPETITIONCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM COMPETITION WHERE COMPETITIONCODE ='%@'",COMPETITIONCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}





+(BOOL) InsertMASTEREvents:(NSString*) COMPETITIONCODE:(NSString*) COMPETITIONNAME:(NSString*) SEASON:(NSString*) TROPHY:(NSString*) STARTDATE:(NSString*) ENDDATE:(NSString*) MATCHTYPE:(NSString*) ISOTHERSMATCHTYPE :(NSString*) MANOFTHESERIESCODE:(NSString*) BESTBATSMANCODE :(NSString*) BESTBOWLERCODE:(NSString*) BESTALLROUNDERCODE:(NSString*) MOSTVALUABLEPLAYERCODE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO COMPETITION(COMPETITIONCODE,COMPETITIONNAME,SEASON,TROPHY, STARTDATE, ENDDATE,MATCHTYPE,ISOTHERSMATCHTYPE,MANOFTHESERIESCODE,BESTBATSMANCODE, BESTBOWLERCODE,BESTALLROUNDERCODE, MOSTVALUABLEPLAYERCODE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",COMPETITIONCODE,COMPETITIONNAME,SEASON,TROPHY, STARTDATE, ENDDATE,MATCHTYPE,ISOTHERSMATCHTYPE,MANOFTHESERIESCODE,BESTBATSMANCODE, BESTBOWLERCODE,BESTALLROUNDERCODE, MOSTVALUABLEPLAYERCODE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}



+(BOOL ) UPDATECOMPETITION:(NSString*) COMPETITIONCODE:(NSString*) COMPETITIONNAME:(NSString*) SEASON:(NSString*) TROPHY:(NSString*) STARTDATE:(NSString*) ENDDATE:(NSString*) MATCHTYPE:(NSString*) ISOTHERSMATCHTYPE :(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE COMPETITION SET  COMPETITIONNAME='%@', SEASON='%@', TROPHY='%@',STARTDATE='%@',ENDDATE='%@', MATCHTYPE='%@',ISOTHERSMATCHTYPE='%@', MODIFIEDBY='%@', MODIFIEDDATE='%@',issync='1', WHERE COMPETITIONCODE='%@'",COMPETITIONNAME,SEASON,TROPHY, STARTDATE, ENDDATE,MATCHTYPE,ISOTHERSMATCHTYPE,MODIFIEDBY,MODIFIEDDATE,COMPETITIONCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
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



//CompetitionTeamDetails



+(BOOL) CheckCompetitionCodeTeamCode:(NSString *)COMPETITIONCODE:(NSString *)TEAMCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COMPETITIONCODE,TEAMCODE FROM COMPETITIONTEAMDETAILS WHERE COMPETITIONCODE ='%@' AND TEAMCODE ='%@'",COMPETITIONCODE,TEAMCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}



+(BOOL) DELETECompetitionCodeTeamCode:(NSString *)COMPETITIONCODE:(NSString *)TEAMCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"DELETE COMPETITIONCODE,TEAMCODE FROM COMPETITIONTEAMDETAILS WHERE COMPETITIONCODE ='%@' AND TEAMCODE ='%@'",COMPETITIONCODE,TEAMCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}


+(BOOL) InsertCompetitionTeamDetails:(NSString*) COMPETITIONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE:(NSString*) RECORDSTATUS
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO COMPETITIONTEAMDETAILS(COMPETITIONTEAMCODE,COMPETITIONCODE,TEAMCODE,RECORDSTATUS,issync)VALUES('%@','%@','%@','%@','1')",COMPETITIONTEAMCODE,COMPETITIONCODE,TEAMCODE,RECORDSTATUS];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}




//Competitionteamplayer



+(BOOL) CheckCompetitionteamplayer:(NSString *)COMPETITIONCODE:(NSString *)TEAMCODE:(NSString *)PLAYERCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT TEAMCODE,PLAYERCODE,COMPETITIONCODE FROM COMPETITIONTEAMPLAYER WHERE COMPETITIONCODE ='%@' AND TEAMCODE ='%@' AND PLAYERCODE ='%@'" ,COMPETITIONCODE,TEAMCODE,PLAYERCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}


+(BOOL) InsertCompetitionTeamPlayer:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE:(NSString*) PLAYERCODE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO COMPETITIONTEAMPLAYER (COMPETITIONCODE,TEAMCODE,PLAYERCODE,RECORDSTATUS,CREATEDBY, CREATEDDATE, MODIFIEDBY, MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','1')", COMPETITIONCODE, TEAMCODE, PLAYERCODE, RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}


//Matchregistration

+(BOOL) Matchregistration:(NSString *)MATCHCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT MATCHCODE FROM MATCHREGISTRATION WHERE MATCHCODE ='%@'",MATCHCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;


}


+(BOOL) InsertMatchregistration:(NSString*) MATCHCODE:(NSString*) MATCHNAME:(NSString*) COMPETITIONCODE:(NSString*) MATCHOVERS:(NSString*) MATCHOVERCOMMENTS:(NSString*) MATCHDATE:(NSString*) ISDAYNIGHT:(NSString*) ISNEUTRALVENUE:(NSString*) GROUNDCODE:(NSString*) TEAMACODE:(NSString*) TEAMBCODE:(NSString*) TEAMACAPTAIN:(NSString*) TEAMAWICKETKEEPER:(NSString*) TEAMBCAPTAIN:(NSString*) TEAMBWICKETKEEPER:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) UMPIRE3CODE:(NSString*) MATCHREFEREECODE:(NSString*) MATCHRESULT:(NSString*) MATCHRESULTTEAMCODE:(NSString*) TEAMAPOINTS:(NSString*) TEAMBPOINTS:(NSString*) MATCHSTATUS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) ISDEFAULTORLASTINSTANCE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO MATCHREGISTRATION(MATCHCODE,MATCHNAME,   COMPETITIONCODE,MATCHOVERS,MATCHOVERCOMMENTS,MATCHDATE,ISDAYNIGHT,ISNEUTRALVENUE,GROUNDCODE, TEAMACODE,TEAMBCODE,TEAMACAPTAIN,TEAMAWICKETKEEPER,TEAMBCAPTAIN,TEAMBWICKETKEEPER,UMPIRE1CODE, UMPIRE2CODE,UMPIRE3CODE,MATCHREFEREECODE,MATCHRESULT, MATCHRESULTTEAMCODE,TEAMAPOINTS,TEAMBPOINTS, MATCHSTATUS,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,ISDEFAULTORLASTINSTANCE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','1')", MATCHCODE, MATCHNAME, COMPETITIONCODE, MATCHOVERS,MATCHOVERCOMMENTS,MATCHDATE,ISDAYNIGHT,ISNEUTRALVENUE,GROUNDCODE,TEAMACODE,TEAMBCODE,TEAMACAPTAIN,TEAMAWICKETKEEPER,TEAMBCAPTAIN,TEAMBWICKETKEEPER,UMPIRE1CODE,UMPIRE2CODE,UMPIRE3CODE,  MATCHREFEREECODE,MATCHRESULT,MATCHRESULTTEAMCODE,TEAMAPOINTS,TEAMBPOINTS,MATCHSTATUS,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,ISDEFAULTORLASTINSTANCE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}



+(BOOL) UpdateMatchregistration:(NSString*) MATCHCODE:(NSString*) MATCHNAME:(NSString*) COMPETITIONCODE:(NSString*) MATCHOVERS:(NSString*) MATCHOVERCOMMENTS:(NSString*) MATCHDATE:(NSString*) ISDAYNIGHT:(NSString*) ISNEUTRALVENUE:(NSString*) GROUNDCODE:(NSString*) TEAMACODE:(NSString*) TEAMBCODE:(NSString*) TEAMACAPTAIN:(NSString*) TEAMAWICKETKEEPER:(NSString*) TEAMBCAPTAIN:(NSString*) TEAMBWICKETKEEPER:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) UMPIRE3CODE:(NSString*) MATCHREFEREECODE:(NSString*) MATCHRESULT:(NSString*) MATCHRESULTTEAMCODE:(NSString*) TEAMAPOINTS:(NSString*) TEAMBPOINTS:(NSString*) MATCHSTATUS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) ISDEFAULTORLASTINSTANCE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET [MATCHNAME] = '%@',[COMPETITIONCODE] = '%@',[MATCHOVERS] = '%@',[MATCHDATE] = '%@',[ISDAYNIGHT] ='%@',[ISNEUTRALVENUE] = '%@',[GROUNDCODE] = '%@',[TEAMACODE] = '%@',[TEAMBCODE] = '%@',[TEAMACAPTAIN] = '%@' ,[TEAMAWICKETKEEPER] ='%@' ,[TEAMBCAPTAIN] ='%@' ,[TEAMBWICKETKEEPER] = '%@',[UMPIRE1CODE] = '%@',[UMPIRE2CODE] ='%@',[UMPIRE3CODE] = '%@',[MATCHREFEREECODE] = '%@',[MATCHRESULT] = '%@',[MATCHRESULTTEAMCODE] ='%@',[TEAMAPOINTS] = '%@' ,[TEAMBPOINTS] ='%@',[MATCHSTATUS] = '%@',[RECORDSTATUS] = '%@',[MODIFIEDBY] ='%@',[MODIFIEDDATE] = '%@' WHERE [MATCHCODE] ='%@'", MATCHNAME, COMPETITIONCODE, MATCHOVERS,MATCHDATE,ISDAYNIGHT,ISNEUTRALVENUE,GROUNDCODE,TEAMACODE,TEAMBCODE,TEAMACAPTAIN,TEAMAWICKETKEEPER,TEAMBCAPTAIN,TEAMBWICKETKEEPER,UMPIRE1CODE,UMPIRE2CODE,UMPIRE3CODE,  MATCHREFEREECODE,MATCHRESULT,MATCHRESULTTEAMCODE,TEAMAPOINTS,TEAMBPOINTS,MATCHSTATUS,RECORDSTATUS,MODIFIEDBY,MODIFIEDDATE,MATCHCODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}

//Matchteamplayerdetails


+(BOOL) CheckMatchteamplayerdetails:(NSString *)MATCHCODE:(NSString *)TEAMCODE:(NSString *)PLAYERCODE

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT MATCHCODE,TEAMCODE,PLAYERCODE,RECORDSTATUS FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE ='%@' AND PLAYERCODE ='%@' AND TEAMCODE ='%@'  AND RECORDSTATUS ='MSC001'",MATCHCODE,PLAYERCODE,TEAMCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
    
}
+(BOOL) InsertMatchteamplayerdetails:(NSString*) MATCHTEAMPLAYERCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) PLAYERCODE:(NSString*)PLAYINGORDER:(NSString*) RECORDSTATUS{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO MATCHTEAMPLAYERDETAILS(MATCHTEAMPLAYERCODE,MATCHCODE,TEAMCODE,PLAYERCODE,PLAYINGORDER,RECORDSTATUS,issync)VALUES('%@','%@','%@','%@','%@','%@','1')", MATCHTEAMPLAYERCODE,MATCHCODE,TEAMCODE,PLAYERCODE,PLAYINGORDER,RECORDSTATUS];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
                 NSLog(@"Error %s while preparing statement", sqlite3_errmsg(dataBase));
            return NO;
        }
        
    }
    return YES;

    
}



//TeamMaster
+(BOOL) CheckTeamMaster:(NSString *)TEAMCODE{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT TEAMCODE FROM TEAMMASTER WHERE TEAMCODE ='%@'",TEAMCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    

}



+(BOOL) InsertTeamMaster:(NSString*) TEAMCODE:(NSString*) TEAMNAME:(NSString*) SHORTTEAMNAME:(NSString*) TEAMTYPE:(NSString*)TEAMLOGO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO TEAMMASTER(TEAMCODE,TEAMNAME, SHORTTEAMNAME,TEAMTYPE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,  MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",TEAMCODE,TEAMNAME, SHORTTEAMNAME,TEAMTYPE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error %s while preparing statement", sqlite3_errmsg(dataBase));
            return NO;
        }
        
    }
    return YES;
    
    
}



+(BOOL )UpdateTeamMaster:(NSString*) TEAMNAME:(NSString*) SHORTTEAMNAME:(NSString*) TEAMTYPE:(NSString*) TEAMLOGO:(NSString*) RECORDSTATUS:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) TEAMCODE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TEAMMASTER SET TEAMNAME='%@', SHORTTEAMNAME='%@', TEAMTYPE='%@',RECORDSTATUS='%@', MODIFIEDBY='%@',MODIFIEDDATE='%@',issync='1' WHERE TEAMCODE='%@'",TEAMNAME,SHORTTEAMNAME,TEAMTYPE,RECORDSTATUS,MODIFIEDBY,MODIFIEDDATE,TEAMCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error %s while preparing statement", sqlite3_errmsg(dataBase));
            return NO;
        }
        
    }
    return YES;
    
}

//PlayerMaster

+(BOOL )CheckPlayermaster:(NSString*) PLAYERCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT PLAYERCODE FROM PLAYERMASTER WHERE PLAYERCODE ='%@'",PLAYERCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;


}




+(BOOL ) InsertPlayermaster:(NSString*) PLAYERCODE:(NSString*) PLAYERNAME:(NSString*) PLAYERDOB:(NSString*) PLAYERPHOTO:(NSString*) BATTINGSTYLE:(NSString*) BATTINGORDER:(NSString*) BOWLINGSTYLE:(NSString*)BOWLINGTYPE:(NSString*) BOWLINGSPECIALIZATION:(NSString*) PLAYERROLE:(NSString*) PLAYERREMARKS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) BALLTYPECODE:(NSString*) SHOTTYPE:(NSString*) SHOTCODE:(NSString*)PMLENGTHCODE:(NSString*)PMLINECODE:(NSString*) PMXVALUE:(NSString*) PMYVALUE:(NSString*) ATWOROTW
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO PLAYERMASTER(PLAYERCODE,PLAYERNAME,PLAYERDOB,PLAYERPHOTO,BATTINGSTYLE,BATTINGORDER,BOWLINGSTYLE,BOWLINGTYPE,BOWLINGSPECIALIZATION,PLAYERROLE,PLAYERREMARKS,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY, MODIFIEDDATE,BALLTYPECODE,SHOTTYPE,SHOTCODE,PMLENGTHCODE,PMLINECODE,PMXVALUE,PMYVALUE,ATWOROTW,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",PLAYERCODE,PLAYERNAME,PLAYERDOB,PLAYERPHOTO,BATTINGSTYLE,BATTINGORDER,BOWLINGSTYLE,BOWLINGTYPE,BOWLINGSPECIALIZATION,PLAYERROLE,PLAYERREMARKS,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,BALLTYPECODE,SHOTTYPE,SHOTCODE,PMLENGTHCODE,PMLINECODE,PMXVALUE,PMYVALUE,ATWOROTW];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error %s while preparing statement", sqlite3_errmsg(dataBase));
            return NO;
        }
        
    }
    return YES;



}




+(BOOL) UpdatePlayermaster:(NSString*) PLAYERCODE:(NSString*) PLAYERNAME:(NSString*) PLAYERDOB:(NSString*) PLAYERPHOTO:(NSString*) BATTINGSTYLE:(NSString*) BATTINGORDER:(NSString*) BOWLINGSTYLE:(NSString*)BOWLINGTYPE:(NSString*) BOWLINGSPECIALIZATION:(NSString*) PLAYERROLE:(NSString*) PLAYERREMARKS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) BALLTYPECODE:(NSString*) SHOTTYPE:(NSString*) SHOTCODE:(NSString*)PMLENGTHCODE:(NSString*)PMLINECODE:(NSString*) PMXVALUE:(NSString*) PMYVALUE:(NSString*) ATWOROTW
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE PLAYERMASTER SET PLAYERNAME ='%@',PLAYERDOB = '%@',BATTINGSTYLE ='%@',BATTINGORDER ='%@',BOWLINGSTYLE ='%@',BOWLINGTYPE = '%@',BOWLINGSPECIALIZATION ='%@',PLAYERROLE ='%@',PLAYERREMARKS ='%@',BALLTYPECODE ='%@',SHOTTYPE = '%@',SHOTCODE ='%@',PMLENGTHCODE ='%@',PMLINECODE ='%@',PMXVALUE ='%@',PMYVALUE ='%@',ATWOROTW = '%@',MODIFIEDBY ='%@',MODIFIEDDATE ='%@' WHERE PLAYERCODE ='%@'",PLAYERNAME,PLAYERDOB,BATTINGSTYLE,BATTINGORDER,BOWLINGSTYLE,BOWLINGTYPE ,BOWLINGSPECIALIZATION,PLAYERROLE,PLAYERREMARKS ,BALLTYPECODE ,SHOTTYPE ,SHOTCODE ,PMLENGTHCODE,PMLINECODE,PMXVALUE,PMYVALUE,ATWOROTW,MODIFIEDBY,MODIFIEDDATE,PLAYERCODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}




//PLAYERTEAMDETAILS

+(BOOL )CheckPlayerTeamDetails:(NSString*) PLAYERCODE:(NSString*) TEAMCODE
{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT PLAYERCODE,TEAMCODE FROM PLAYERTEAMDETAILS WHERE PLAYERCODE ='%@' AND TEAMCODE ='%@'",PLAYERCODE,TEAMCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    
    
}


+(BOOL) InsertPlayerTeamDetails:(NSString*) PLAYERCODE:(NSString*) TEAMCODE:(NSString*) RECORDSTATUS
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO PLAYERTEAMDETAILS(PLAYERCODE,TEAMCODE,RECORDSTATUS,issync)VALUES('%@','%@','%@','1')",PLAYERCODE,TEAMCODE,RECORDSTATUS];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}


+(BOOL) UpdatePlayerTeamDetails:(NSString*) PLAYERCODE:(NSString*) TEAMCODE:(NSString*) RECORDSTATUS
{

NSString *databasePath = [self getDBPath];
sqlite3_stmt *statement;
sqlite3 *dataBase;
const char *dbPath = [databasePath UTF8String];
if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
{
    NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE [PLAYERTEAMDETAILS] SET [RECORDSTATUS] = '%@' WHERE [PLAYERCODE] ='%@' AND [TEAMCODE] ='%@'AND issync='1' ",PLAYERCODE,TEAMCODE,RECORDSTATUS];
    
    
    const char *update_stmt = [UPDATESQL UTF8String];
      sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        sqlite3_close(dataBase);
        return YES;
        
    }
    else {
        sqlite3_reset(statement);
        
        return NO;
    }
    
}
return YES;
}



//Officialsmaster

+(BOOL )CheckOfficialsmaster:(NSString*)OFFICIALSCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT OFFICIALSCODE FROM OFFICIALSMASTER WHERE OFFICIALSCODE ='%@'",OFFICIALSCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;



}

+(BOOL) InsertOfficialsmaster:(NSString*) OFFICIALSCODE:(NSString*) NAME:(NSString*) ROLE:(NSString*) COUNTRY:(NSString*) STATE:(NSString*) CATEGORY:(NSString*) OFFICIALSPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO OFFICIALSMASTER( OFFICIALSCODE,NAME,ROLE,COUNTRY,STATE,CATEGORY,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",OFFICIALSCODE,NAME,ROLE,COUNTRY,STATE,CATEGORY,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY, MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;



}

+(BOOL) UpdateOfficialsmaster:(NSString*) OFFICIALSCODE:(NSString*) NAME:(NSString*) ROLE:(NSString*) COUNTRY:(NSString*) STATE:(NSString*) CATEGORY:(NSString*) OFFICIALSPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
   {
       NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE OFFICIALSMASTER SET NAME='%@',ROLE = '%@',COUNTRY ='%@',STATE='%@',CATEGORY ='%@',MODIFIEDBY ='%@',MODIFIEDDATE = '%@',issync='1'WHERE OFFICIALSCODE = '%@'",NAME,ROLE,COUNTRY,STATE,CATEGORY,MODIFIEDBY,MODIFIEDDATE,OFFICIALSCODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;


}




//Coachmaster

+(BOOL )CheckCoachmaster:(NSString*)COACHCODE
{ int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COACHCODE FROM COACHMASTER WHERE COACHCODE ='%@'",COACHCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}



+(BOOL) InsertCoachmaster:(NSString*) COACHCODE:(NSString*) COACHNAME:(NSString*) COACHTEAMCODE:(NSString*)COACHSPECIALIZATION:(NSString*) COACHPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE

{

    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO COACHMASTER(COACHCODE,COACHNAME,COACHTEAMCODE,COACHSPECIALIZATION,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",COACHCODE,COACHNAME,COACHTEAMCODE,COACHSPECIALIZATION,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    


}




+(BOOL) UpdateCoachmaster:(NSString*) COACHCODE:(NSString*) COACHNAME:(NSString*) COACHTEAMCODE:(NSString*)COACHSPECIALIZATION:(NSString*) COACHPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE COACHMASTER SET COACHNAME='%@',COACHTEAMCODE = '%@',COACHSPECIALIZATION ='%@',RECORDSTATUS='%@',MODIFIEDDATE = '%@',issync='1'WHERE COACHCODE = '%@'",COACHNAME,COACHTEAMCODE,COACHSPECIALIZATION,RECORDSTATUS,MODIFIEDDATE,COACHCODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;




}


//Groundmaster

+(BOOL )CheckGroundmaster:(NSString*)GROUNDCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT GROUNDCODE FROM GROUNDMASTER WHERE GROUNDCODE ='%@'",GROUNDCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;


}

+(BOOL) InsertGroundmaster:(NSString*)GROUNDCODE:(NSString*)GROUNDNAME:(NSString*)COUNTRY:(NSString*)STATE:(NSString*)CITY:(NSString*)GROUNDPROFILE:(NSString*)GSTOPLEFT:(NSString*)GSTOPRIGHT:(NSString*)GSBOTTOMLEFT:(NSString*)GSBOTTOMRIGHT:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO GROUNDMASTER(GROUNDCODE,GROUNDNAME, COUNTRY,STATE,CITY,GROUNDPROFILE,GSTOPLEFT,GSTOPRIGHT,GSBOTTOMLEFT,GSBOTTOMRIGHT,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",GROUNDCODE,GROUNDNAME,COUNTRY,STATE,CITY,GROUNDPROFILE,GSTOPLEFT,GSTOPRIGHT,GSBOTTOMLEFT,GSBOTTOMRIGHT,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
   }

+(BOOL) UpdateGroundmaster:(NSString*)GROUNDCODE:(NSString*)GROUNDNAME:(NSString*)COUNTRY:(NSString*)STATE:(NSString*)CITY:(NSString*)GROUNDPROFILE:(NSString*)GSTOPLEFT:(NSString*)GSTOPRIGHT:(NSString*)GSBOTTOMLEFT:(NSString*)GSBOTTOMRIGHT:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE GROUNDMASTER SET GROUNDNAME='%@',COUNTRY ='%@',STATE='%@',CITY ='%@',GROUNDPROFILE ='%@',GSTOPLEFT = '%@',GSTOPRIGHT='%@',GSBOTTOMLEFT ='%@',GSBOTTOMRIGHT ='%@',MODIFIEDBY = '%@',MODIFIEDDATE = '%@',issync='1'WHERE GROUNDCODE = '%@'",GROUNDNAME,COUNTRY,STATE,CITY,GROUNDPROFILE,GSTOPLEFT,GSTOPRIGHT,GSBOTTOMLEFT,GSBOTTOMRIGHT,MODIFIEDBY,MODIFIEDDATE,GROUNDCODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    
    
    
}




//Shottype

+(BOOL )CheckShottype:(NSString*)SHOTCODE
{

    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT SHOTCODE FROM SHOTTYPE WHERE SHOTCODE ='%@'",SHOTCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    


}

+(BOOL) UpdateShottype:(NSString*)SHOTCODE:(NSString*)SHOTNAME:(NSString*)SHOTTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE SHOTTYPE SET SHOTNAME='%@',SHOTTYPE ='%@',RECORDSTATUS='%@',MODIFIEDBY ='%@',MODIFIEDDATE ='%@',issync='1'WHERE SHOTCODE = '%@'",SHOTNAME,SHOTTYPE,RECORDSTATUS,MODIFIEDBY,MODIFIEDDATE,SHOTCODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    
    
    
}



+(BOOL) InsertShottype:(NSString*)SHOTCODE:(NSString*)SHOTNAME:(NSString*)SHOTTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE
{
 
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO SHOTTYPE(SHOTCODE,SHOTNAME,SHOTTYPE,DISPLAYORDER,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",SHOTCODE,SHOTNAME,SHOTTYPE,DISPLAYORDER,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
            
            
            const char *update_stmt = [INSERTSQL UTF8String];
            //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
            sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                
                return NO;
            }
            
        }
        return YES;

}





//Bowltype
+(BOOL )CheckBowltype:(NSString*)BOWLTYPECODE{

    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT BOWLTYPECODE FROM BOWLTYPE WHERE BOWLTYPECODE ='%@'",BOWLTYPECODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;

}

+(BOOL) UpdateBowltype:(NSString*)BOWLTYPECODE:(NSString*)BOWLTYPE:(NSString*)BOWLERTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE BOWLTYPE SET BOWLTYPE='%@',BOWLERTYPE ='%@',RECORDSTATUS='%@',MODIFIEDBY ='%@',MODIFIEDDATE ='%@',issync='1'WHERE BOWLTYPECODE = '%@'",BOWLTYPE,BOWLERTYPE,RECORDSTATUS,MODIFIEDBY,MODIFIEDDATE,BOWLTYPECODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
 
}


+(BOOL) InsertBowltype:(NSString*)BOWLTYPECODE:(NSString*)BOWLTYPE:(NSString*)BOWLERTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE
{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO BOWLTYPE(BOWLTYPECODE,BOWLTYPE,BOWLERTYPE,DISPLAYORDER,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",BOWLTYPECODE,BOWLTYPE,BOWLERTYPE,DISPLAYORDER,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;


}




//Fieldingfactor

+(BOOL) CheckFieldingfactor:(NSString*)FIELDINGFACTORCODE{

    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT FIELDINGFACTORCODE FROM FIELDINGFACTOR WHERE FIELDINGFACTORCODE ='%@'",FIELDINGFACTORCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    

}

+(BOOL)UpdateFieldingfactor:(NSString*)FIELDINGFACTORCODE:(NSString*)FIELDINGFACTOR:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE FIELDINGFACTOR SET FIELDINGFACTOR='%@',FIELDINGFACTORCODE ='%@',RECORDSTATUS='%@',MODIFIEDBY ='%@',MODIFIEDDATE ='%@',issync='1'WHERE FIELDINGFACTORCODE = '%@'",FIELDINGFACTOR,FIELDINGFACTORCODE,RECORDSTATUS,MODIFIEDBY,MODIFIEDDATE,FIELDINGFACTORCODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}


+(BOOL)InsertFieldingfactor:(NSString*)FIELDINGFACTORCODE:(NSString*)FIELDINGFACTOR:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO FIELDINGFACTOR(FIELDINGFACTORCODE,FIELDINGFACTOR,DISPLAYORDER,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','1')",FIELDINGFACTORCODE,FIELDINGFACTOR,DISPLAYORDER,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    


}

//Bowlerspecialization

+(BOOL)CheckBowlerspecialization:BOWLERSPECIALIZATIONCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT BOWLERSPECIALIZATIONCODE FROM BOWLERSPECIALIZATION WHERE BOWLERSPECIALIZATIONCODE ='%@'",BOWLERSPECIALIZATIONCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    




}

+(BOOL)UpdateBowlerspecialization:(NSString*)BOWLERSPECIALIZATIONCODE:(NSString*)BOWLERSPECIALIZATION:(NSString*)BOWLERSTYLE:(NSString*)BOWLERTYPE:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE{

    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO BOWLERSPECIALIZATION(BOWLERSPECIALIZATIONCODE,BOWLERSPECIALIZATION,BOWLERSTYLE,BOWLERTYPE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,issync)VALUES('%@',,'%@','%@','%@','%@','%@','%@','%@','%@','1')",BOWLERSPECIALIZATIONCODE,BOWLERSPECIALIZATION,BOWLERSTYLE,BOWLERTYPE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    


}

+(BOOL) InsertBowlerspecialization:(NSString*)BOWLERSPECIALIZATIONCODE:(NSString*)BOWLERSPECIALIZATION:(NSString*)BOWLERSTYLE:(NSString*)BOWLERTYPE:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE{

    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE BOWLERSPECIALIZATION SET BOWLERSPECIALIZATION='%@',BOWLERSTYLE ='%@',BOWLERTYPE='%@',RECORDSTATUS='%@',MODIFIEDBY ='%@',MODIFIEDDATE ='%@',issync='1'WHERE BOWLTYPECODE = '%@'",BOWLERSPECIALIZATION,BOWLERSTYLE,BOWLERTYPE,RECORDSTATUS,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;


}




+(NSMutableArray *)getPlayerCode
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    // NSString *count = [[NSString alloc]init];
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT PLAYERCODE FROM PLAYERMASTER"];
    stmt=[selectPlayersSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            getimageRecord *record=[[getimageRecord alloc]init];
            record.playercodeimage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
         [eventArray addObject:record];
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
    
}




+(NSMutableArray *)getofficailCode
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    // NSString *count = [[NSString alloc]init];
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT OFFICIALSCODE FROM OFFICIALSMASTER"];
    stmt=[selectPlayersSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            getimageRecord *record=[[getimageRecord alloc]init];
            record.officialscodeimage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            [eventArray addObject:record];
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
    
}

+(NSMutableArray *)getgroundcode
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    // NSString *count = [[NSString alloc]init];
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT GROUNDCODE FROM GROUNDMASTER"];
    stmt=[selectPlayersSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            getimageRecord *record=[[getimageRecord alloc]init];
            record.groundcodeimage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            [eventArray addObject:record];
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
    
}



//Metadata


+(BOOL) CheckMetaData:METASUBCODE{

    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE FROM METADATA WHERE METASUBCODE ='%@'",METASUBCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
    



}


+(BOOL)InsertMetaData:(NSString*)METASUBCODE:(NSString*)METADATATYPECODE:(NSString*)METADATATYPEDESCRIPTION:(NSString*)METASUBCODEDESCRIPTION
{

    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO METADATA(METASUBCODE,METADATATYPECODE,METADATATYPEDESCRIPTION,METASUBCODEDESCRIPTION,issync)VALUES('%@','%@','%@','%@','1')",METASUBCODE,METADATATYPECODE,METADATATYPEDESCRIPTION,METASUBCODEDESCRIPTION];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    
    




}



//PowerplayType
+(BOOL)  CheckPowerplayType:POWERPLAYTYPECODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT POWERPLAYTYPECODE FROM POWERPLAYTYPE WHERE POWERPLAYTYPECODE ='%@'",POWERPLAYTYPECODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;


}
+(BOOL)InsertPowerplayType:(NSString*)POWERPLAYTYPECODE:(NSString*)POWERPLAYTYPENAME:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE:(NSString*)ISSYSTEMREFERENCE{
    
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO POWERPLAYTYPE(POWERPLAYTYPECODE,POWERPLAYTYPENAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,ISSYSTEMREFERENCE,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','1')",POWERPLAYTYPECODE,POWERPLAYTYPENAME,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,ISSYSTEMREFERENCE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    
 }

+(BOOL)UpdatePowerplayType:(NSString*)POWERPLAYTYPECODE:(NSString*)POWERPLAYTYPENAME:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE:(NSString*)ISSYSTEMREFERENCE{


    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *UPDATESQL = [NSString stringWithFormat:@"UPDATE POWERPLAYTYPE SET POWERPLAYTYPENAME='%@',RECORDSTATUS='%@', issync='1' WHERE POWERPLAYTYPECODE ='%@'",POWERPLAYTYPENAME,RECORDSTATUS,POWERPLAYTYPECODE];
        
        
        const char *update_stmt = [UPDATESQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
    


}


@end
