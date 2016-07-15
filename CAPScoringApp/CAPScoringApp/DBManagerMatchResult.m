//
//  DBManagerMatchResult.m
//  CAPScoringApp
//
//  Created by APPLE on 21/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerMatchResult.h"
#import "GetTeamANameDetails.h"
#import "GetTeamBNameDetails.h"
#import "SelectPlayerRecord.h"
#import "GetMatchResultTypeAndCodeDetails.h"
#import "GetBestPlayerDetail.h"
#import "GetMatchResultDetail.h"
#import "UserRecord.h"

@implementation DBManagerMatchResult


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



//SP_FETCHMATCHRESULTS

+(NSMutableArray *) GetMatchResultTypeAndCodeForFetchMatchResult{
    
    NSMutableArray * GetMatchResultTypeAndCode=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = @"SELECT METASUBCODEDESCRIPTION RESULTTYPE,METASUBCODE RESULTCODE FROM METADATA WHERE METADATATYPECODE='MDT008' AND METASUBCODE<>'MSC230'";
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetMatchResultTypeAndCodeDetails *record=[[GetMatchResultTypeAndCodeDetails alloc]init];
                record.RESULTTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.RESULTCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [GetMatchResultTypeAndCode addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetMatchResultTypeAndCode;
}


//
//+(NSMutableArray *) GetMatchResultTypeAndCodeForFetchMatchResult{
//    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
//    int retVal;
//    NSString *dbPath = [self getDBPath];
//    sqlite3 *dataBase;
//    const char *stmt;
//    sqlite3_stmt *statement;
//    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
//    if(retVal ==0){
//        
//        NSString *query= @"SELECT METASUBCODEDESCRIPTION RESULTTYPE,METASUBCODE RESULTCODE FROM METADATA WHERE METADATATYPECODE='MDT008' AND METASUBCODE<>'MSC230'";
//        NSLog(@"%@",query);
//        stmt=[query UTF8String];
//        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                NSLog(@"Success");
//                
//                const char *testimonial1=(char *)sqlite3_column_text(statement, 0);
//                
//                
//                NSString *data = [self getValueByNull:statement :0];
//                
//                UserRecord *record=[[UserRecord alloc]init];
//                NSLog(@"%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]);
//                NSString *dtat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.userCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.userName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                
//                
//                [eventArray addObject:record];
//                
//                
//            }
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(dataBase);
//    }
//    return eventArray;
//}



+(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}

+(NSMutableArray *) GetTeamANameDetailsForFetchMatchResult: (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE{
    
    NSMutableArray * GetTeamANameDetail=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TM.TEAMNAME,TM.SHORTTEAMNAME,MR.TEAMACODE FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MR.TEAMACODE WHERE MR.COMPETITIONCODE='%@' AND MR.MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetTeamANameDetails *record=[[GetTeamANameDetails alloc]init];
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.SHORTTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TEAMACODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [GetTeamANameDetail addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetTeamANameDetail;
}
+(NSMutableArray *) GetTeamBNameDetailsForFetchMatchResult: (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE{
    
    NSMutableArray * GetTeamBNameDetail=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TM.TEAMNAME,TM.SHORTTEAMNAME,MR.TEAMBCODE FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MR.TEAMBCODE WHERE MR.COMPETITIONCODE='%@' AND MR.MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetTeamANameDetails *record=[[GetTeamANameDetails alloc]init];
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.SHORTTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TEAMACODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [GetTeamBNameDetail addObject:record];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetTeamBNameDetail;
}
+(NSMutableArray *) GetManOfTheMatchDetailsForFetchMatchResult :(NSString*) MATCHCODE{
    
    NSMutableArray * GetManOfTheMatchDetail=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MTP.PLAYERCODE AS  PLAYERCODE,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE WHERE  MTP.MATCHCODE='%@' AND MTP.RECORDSTATUS='MSC001' GROUP BY MTP.PLAYERCODE,PM.PLAYERNAME",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                SelectPlayerRecord *record=[[SelectPlayerRecord alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [GetManOfTheMatchDetail addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetManOfTheMatchDetail;
}
+(NSMutableArray *) GetManOfTheSeriesDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE{
    
    NSMutableArray * GetManOfTheSeriesDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE WHERE MATCHCODE IN (SELECT MATCHCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE='%@') AND MTP.RECORDSTATUS='MSC001' GROUP BY PM.PLAYERCODE,PM.PLAYERNAME",COMPETITIONCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                SelectPlayerRecord *record=[[SelectPlayerRecord alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [GetManOfTheSeriesDetails addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetManOfTheSeriesDetails;
}
+(NSMutableArray *) GetBestBatsManDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE{
    
    NSMutableArray * GetBestBatsManDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BE.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=BE.STRIKERCODE WHERE  BE.COMPETITIONCODE='%@' GROUP BY BE.STRIKERCODE,PLAYERNAME",COMPETITIONCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                SelectPlayerRecord *record=[[SelectPlayerRecord alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [GetBestBatsManDetails addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBestBatsManDetails;
}
+(NSMutableArray *) GetBestBowlerDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE{
    
    NSMutableArray * GetBestBowlerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BE.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=BE.STRIKERCODE WHERE  BE.COMPETITIONCODE='%@' GROUP BY BE.STRIKERCODE,PLAYERNAME",COMPETITIONCODE];
//        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BE.BOWLERCODE AS PLAYERCODE,PM.PLAYERNAME FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=BE.BOWLERCODE WHERE  BE.COMPETITIONCODE='%@' GROUP BY BE.BOWLERCODE,PLAYERNAME",COMPETITIONCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                SelectPlayerRecord *record=[[SelectPlayerRecord alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [GetBestBowlerDetails addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBestBowlerDetails;
}

+(NSMutableArray *) GetMatchresultDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE : (NSString*) MATCHCODE{
    
    NSMutableArray * resultArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MD.METASUBCODEDESCRIPTION AS RESULTTYPE,TM.TEAMNAME AS TEAM,MR.COMMENTS,PM.PLAYERNAME AS MANOFTHEMATCH,MR.TEAMAPOINTS,MR.TEAMBPOINTS FROM MATCHRESULT MR LEFT OUTER JOIN TEAMMASTER TM ON TM.TEAMCODE=MR.MATCHWONTEAMCODE INNER JOIN METADATA MD ON MD.METASUBCODE=MR.MATCHRESULTCODE LEFT OUTER JOIN PLAYERMASTER PM ON  PM.PLAYERCODE=MR.MANOFTHEMATCHCODE WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetMatchResultDetail *record =[[GetMatchResultDetail alloc]init];
                record.RESULTTYPE=[self getValueByNull:statement :0];
                record.TEAM=[self getValueByNull:statement :1];
                record.COMMENTS=[self getValueByNull:statement :2];
                record.MANOFTHEMATCH=[self getValueByNull:statement :3];
                record.TEAMAPOINTS=[self getValueByNull:statement :4];
                record.TEAMBPOINTS=[self getValueByNull:statement :5];
                
                [resultArray addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return resultArray;
}

+(NSMutableArray *) GetBestPlayerDetailsForFetchMatchResult :(NSString*) COMPETITIONCODE{
    
    NSMutableArray * GetBestPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM1.PLAYERNAME AS MANOFTHESERIES,PM2.PLAYERNAME AS BESTBATSMAN,PM3.PLAYERNAME AS BESTBOWLER,PM4.PLAYERNAME AS BESTALLROUNDER,PM5.PLAYERNAME AS MOSTVALUABLEPLAYER FROM COMPETITION CM LEFT OUTER JOIN PLAYERMASTER PM1 ON PM1.PLAYERCODE=CM.MANOFTHESERIESCODE LEFT OUTER JOIN PLAYERMASTER PM2 ON  PM2.PLAYERCODE=CM.BESTBATSMANCODE LEFT OUTER JOIN PLAYERMASTER PM3 ON  PM3.PLAYERCODE=CM.BESTBOWLERCODE LEFT OUTER JOIN PLAYERMASTER PM4 ON PM4.PLAYERCODE=CM.BESTALLROUNDERCODE LEFT OUTER JOIN PLAYERMASTER PM5 ON  PM5.PLAYERCODE=CM.MOSTVALUABLEPLAYERCODE WHERE COMPETITIONCODE='%@' ",COMPETITIONCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetBestPlayerDetail *record=[[GetBestPlayerDetail alloc]init];
                record.MANOFTHESERIES=[self getValueByNull:statement :0];
                record.BESTBATSMAN=[self getValueByNull:statement :1];
                record.BESTBOWLER=[self getValueByNull:statement :2];
                record.BESTALLROUNDER=[self getValueByNull:statement :3];
                record.MOSTVALUABLEPLAYER=[self getValueByNull:statement :4];
                
                
                [GetBestPlayerDetails addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBestPlayerDetails;
}



@end
