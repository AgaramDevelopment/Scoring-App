//
//  DbManager_OtherWicket.m
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DbManager_OtherWicket.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GetWicketPlayerandtypePlayerDetail.h"
#import "GetPlayerDetail.h"
#import "GetWicketEventsPlayerDetail.h"
#import "GetNotOutOutBatsManPlayerDetail.h"


@implementation DbManager_OtherWicket
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



+(NSMutableArray*) GetPlayerDetailForFetchOtherwicket:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE
{
    NSMutableArray *GetPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD	ON MR.MATCHCODE = MPD.MATCHCODE	AND MR.COMPETITIONCODE = '%@'	AND MR.MATCHCODE = '%@'	AND MPD.TEAMCODE = '%@'	INNER JOIN COMPETITION COM 	ON COM.COMPETITIONCODE = MR.COMPETITIONCODE	INNER JOIN PLAYERMASTER PM	ON MPD.PLAYERCODE = PM.PLAYERCODE	WHERE PM.PLAYERCODE NOT IN 	(			SELECT WKT.WICKETPLAYER		FROM WICKETEVENTS WKT 		INNER JOIN BALLEVENTS BL		ON WKT.BALLCODE = BL.BALLCODE		AND BL.COMPETITIONCODE = '%@'		AND BL.MATCHCODE = '%@'		AND	BL.TEAMCODE = '%@'		AND WKT.WICKETTYPE != 'MSC102'	)	AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))	ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE];
        
                               const char *update_stmt = [updateSQL UTF8String];
                               sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                               if (sqlite3_step(statement) == SQLITE_DONE)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       GetPlayerDetail *record=[[GetPlayerDetail alloc]init];
                                       record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                       record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                                       
                                       
                                       
                                       [GetPlayerDetails addObject:record];
                                   }
                                   
                               }
                               }
                               sqlite3_finalize(statement);
                               sqlite3_close(dataBase);
                               return GetPlayerDetails;
                               }




+(NSMutableArray *) GetWicketEventDetailsForFetchOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
{
    NSMutableArray *GetWicketEventsPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETDETAILS.BALLCODE, WICKETDETAILS.WICKETNO, WICKETDETAILS.WICKETPLAYER,WICKETDETAILS.WICKETTYPE, WICKETDETAILS.WICKETTYPECODEFROM(SELECT WE.BALLCODE,WE.WICKETNO,PM.PLAYERNAME AS WICKETPLAYER,MD.METASUBCODEDESCRIPTION AS WICKETTYPE,WE.WICKETTYPE AS WICKETTYPECODE,(SELECT COUNT(BE.BALLCODE)FROM BALLEVENTS BEWHERE BE.COMPETITIONCODE = WE.COMPETITIONCODE AND BE.MATCHCODE = WE.MATCHCODE AND BE.TEAMCODE = WE.TEAMCODE AND BE.INNINGSNO = WE.INNINGSNO AND (BE.STRIKERCODE = WE.WICKETPLAYER OR BE.NONSTRIKERCODE = WE.WICKETPLAYER) AND ((BE.OVERNO ||  '.' ||  BE.BALLNO || BE.BALLCOUNT ) > (BALL.OVERNO ||  '.' ||  BALL.BALLNO || BALL.BALLCOUNT))) AS WICKETCOUNT	FROM WICKETEVENTS WE	LEFT JOIN	BALLEVENTS BALL ON BALL.COMPETITIONCODE = WE.COMPETITIONCODE AND BALL.MATCHCODE = WE.MATCHCODE	AND BALL.TEAMCODE = WE.TEAMCODE	AND BALL.INNINGSNO = WE.INNINGSNO AND BALL.BALLCODE = WE.BALLCODE	INNER JOIN	PLAYERMASTER PM ON PM.PLAYERCODE=WE.WICKETPLAYER INNER JOIN	METADATA MD ON MD.METASUBCODE=WE.WICKETTYPE	WHERE WE.COMPETITIONCODE='%@'  AND WE.MATCHCODE='%@' AND WE.TEAMCODE='%@'	 AND WE.INNINGSNO='%@'	 AND ISWICKET='0')WICKETDETAILS	WHERE WICKETDETAILS.WICKETCOUNT < 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
                               const char *update_stmt = [updateSQL UTF8String];
                               sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                               if (sqlite3_step(statement) == SQLITE_DONE)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       GetWicketEventsPlayerDetail *record=[[GetWicketEventsPlayerDetail alloc]init];
                                       record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                       record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                                       
                                       record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                                       record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                                       record.WICKETTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                                       
                                       [GetWicketEventsPlayerDetails addObject:record];
                                   }
                                   
                               }
                               }
                               sqlite3_finalize(statement);
                               sqlite3_close(dataBase);
                               return GetWicketEventsPlayerDetails;
                               }




+(NSString*) GetWicketNoForFetchOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(WE.WICKETNO)+1 AS WICKETNO FROM WICKETEVENTS WE WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@' AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNO;
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



+(NSMutableArray *) GetNotOutAndOutBatsManForFetchOtherwicket:(NSString*) MATCHCODE:(NSString*) TEAMCODE;
{
    NSMutableArray *GetNotOutOutBatsManPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT PM.PLAYERCODE, PM.PLAYERNAME   FROM MATCHTEAMPLAYERDETAILS MTP    INNER JOIN PLAYERMASTER PM ON     PM.PLAYERCODE=MTP.PLAYERCODE     WHERE MTP.MATCHCODE='%@' AND MTP.TEAMCODE='%@' AND MTP.RECORDSTATUS='MSC001' ",MATCHCODE,TEAMCODE];
                               
                               const char *update_stmt = [updateSQL UTF8String];
                               sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                               if (sqlite3_step(statement) == SQLITE_DONE)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       GetNotOutOutBatsManPlayerDetail *record=[[GetNotOutOutBatsManPlayerDetail alloc]init];
                                       record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                       record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                                       
                                       
                                       
                                       [GetNotOutOutBatsManPlayerDetails addObject:record];
                                   }
                                   
                               }
                               }
                               sqlite3_finalize(statement);
                               sqlite3_close(dataBase);
                               return GetNotOutOutBatsManPlayerDetails;
                               }
                               
                                               
   @end
