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
#import "GetStrickerNonStrickerPlayerCode.h"
#import "GetPlayerDetail.h"
#import "GetPlayerDetailOnRetiredHurt.h"
#import "GetPlayerDetailOnAbsentHurt.h"
#import "GetPlayerDetailOnTimeOut.h"
#import "GetPlayerDetailOnRetiredHurt2.h"
#import "GetPlayerDetailOnRetiredHurtOnMSC108.h"
#import "WicketTypeRecord.h"
#import "GetWicketEventsPlayerDetail.h"
#import "GetWicketDetail.h"


@implementation DbManager_OtherWicket
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





//-----------
//wicket Type
//-----------
-(NSMutableArray *)RetrieveOtherWicketType{
    NSMutableArray *WicketTypeArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METADATATYPECODE,METADATATYPEDESCRIPTION,METASUBCODEDESCRIPTION FROM METADATA  WHERE  METASUBCODE ='MSC102' OR METASUBCODE ='MSC108'  OR METASUBCODE ='MSC101' OR METASUBCODE ='MSC133'  OR METASUBCODE ='MSC107'"];
        
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                WicketTypeRecord *record=[[WicketTypeRecord alloc]init];
                
                record.metasubcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.metadatatypecode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.metadatatypedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.metasubcodedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                [WicketTypeArray addObject:record];
                
                
            }
            sqlite3_close(dataBase);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return WicketTypeArray;
}


//--------------
//WICKET PLAYER
//---------------

-(NSMutableArray *)  GetStrickerNonStrickerCodeForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
{
    NSMutableArray *arraylist=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT STRIKERCODE,NONSTRIKERCODE FROM BALLEVENTS   WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'   AND TEAMCODE='%@' AND INNINGSNO='%@' GROUP BY STRIKERCODE,NONSTRIKERCODE ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
       if (sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
      
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetStrickerNonStrickerPlayerCode *record=[[GetStrickerNonStrickerPlayerCode alloc]init];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [arraylist addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return arraylist;
}

//ABSENT HURT
-(NSMutableArray *)   GetPlayerDetailForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO;
{
    NSMutableArray *arraylist1=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME   FROM MATCHREGISTRATION MR    INNER JOIN MATCHTEAMPLAYERDETAILS MPD    ON MR.MATCHCODE = MPD.MATCHCODE    AND MR.COMPETITIONCODE ='%@'    AND MR.MATCHCODE = '%@'   AND MPD.TEAMCODE ='%@'  INNER JOIN COMPETITION COM     ON COM.COMPETITIONCODE = MR.COMPETITIONCODE    INNER JOIN PLAYERMASTER PM    ON MPD.PLAYERCODE = PM.PLAYERCODE    WHERE PM.PLAYERCODE NOT IN    (      SELECT WKT.WICKETPLAYER     FROM WICKETEVENTS WKT      WHERE WKT.COMPETITIONCODE = '%@'    AND WKT.MATCHCODE = '%@'     AND WKT.TEAMCODE = '%@'     AND WKT.INNINGSNO='%@'    )    AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))   ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetPlayerDetail *record=[[GetPlayerDetail alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [arraylist1 addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return arraylist1;
}


-(NSMutableArray*) GetPlayerDetailOnRetiredHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO
{
    NSMutableArray *GetPlayerDetailsOnAbsentHurt=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
         if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
             {
                 NSString *updateSQL =[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME      FROM MATCHREGISTRATION MR      INNER JOIN MATCHTEAMPLAYERDETAILS MPD  ON MR.MATCHCODE = MPD.MATCHCODE      AND MR.COMPETITIONCODE = '%@'  AND MR.MATCHCODE = '%@'  AND MPD.TEAMCODE = '%@'  INNER JOIN COMPETITION COM  ON COM.COMPETITIONCODE = MR.COMPETITIONCODE  INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE      WHERE PM.PLAYERCODE NOT IN  (SELECT WKT.WICKETPLAYER FROM WICKETEVENTS WKT        WHERE WKT.COMPETITIONCODE = '%@' AND WKT.MATCHCODE = '%@'  AND WKT.TEAMCODE = '%@' AND WKT.INNINGSNO='%@') AND PM.PLAYERCODE NOT IN (SELECT STRIKERCODE BATSMANCODE FROM (SELECT STRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'       GROUP BY STRIKERCODE UNION ALL SELECT NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND TEAMCODE='%@' AND INNINGSNO='%@' GROUP BY NONSTRIKERCODE) AS BATSMAN)AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
                 const char *update_stmt = [updateSQL UTF8String];
                 if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
                 {
                     while(sqlite3_step(statement)==SQLITE_ROW){
                     GetPlayerDetailOnAbsentHurt *record=[[GetPlayerDetailOnAbsentHurt alloc]init];
                    record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                       record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                      [GetPlayerDetailsOnAbsentHurt addObject:record];
                       }
                 }
             }
                                sqlite3_finalize(statement);
                               sqlite3_close(dataBase);
                            return GetPlayerDetailsOnAbsentHurt;
                                  }


-(NSMutableArray*) GetPlayerDetailOnTimeOutForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
    {
        NSMutableArray *arraylist4=[[NSMutableArray alloc]init];
       NSString *databasePath = [self getDBPath];
       sqlite3_stmt *statement;
       sqlite3 *dataBase;
       const char *dbPath = [databasePath UTF8String];
       if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
       {
           NSString *updateSQL =[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME   FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE  AND MR.COMPETITIONCODE ='%@'   AND MR.MATCHCODE = '%@' AND MPD.TEAMCODE ='%@' AND MPD.RECORDSTATUS='MSC001' INNER JOIN COMPETITION COM  ON COM.COMPETITIONCODE = MR.COMPETITIONCODE   INNER JOIN PLAYERMASTER PM      ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE PM.PLAYERCODE NOT IN (SELECT WKT.WICKETPLAYER   FROM WICKETEVENTS WKT  WHERE WKT.COMPETITIONCODE ='%@'  AND WKT.MATCHCODE = '%@' AND WKT.TEAMCODE ='%@'  AND WKT.INNINGSNO='%@' )   AND PM.PLAYERCODE NOT IN (  SELECT STRIKERCODE BATSMANCODE FROM (  SELECT STRIKERCODE FROM BALLEVENTS       WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'   AND TEAMCODE='%@' AND INNINGSNO='%@' GROUP BY STRIKERCODE   UNION ALL   SELECT NONSTRIKERCODE FROM  BALLEVENTS    WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'AND TEAMCODE='%@' AND INNINGSNO='%@'  GROUP BY NONSTRIKERCODE) AS BATSMAN  )  AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))     ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
           const char *update_stmt = [updateSQL UTF8String];
           if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
           {
               while(sqlite3_step(statement)==SQLITE_ROW)
               {
             GetPlayerDetailOnAbsentHurt *record=[[GetPlayerDetailOnAbsentHurt alloc]init];
           record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
             record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            [arraylist4 addObject:record];
         }
           }
       }
      sqlite3_finalize(statement);
      sqlite3_close(dataBase);
     return arraylist4;
        }
    



-(NSMutableArray*) GetPlayerDetailOnAbsentHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
{
    NSMutableArray *GetPlayerDetailsOnAbsentHurt=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    { NSString *updateSQL =[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME      FROM MATCHREGISTRATION MR      INNER JOIN MATCHTEAMPLAYERDETAILS MPD  ON MR.MATCHCODE = MPD.MATCHCODE      AND MR.COMPETITIONCODE = '%@'  AND MR.MATCHCODE = '%@'  AND MPD.TEAMCODE = '%@'  INNER JOIN COMPETITION COM  ON COM.COMPETITIONCODE = MR.COMPETITIONCODE  INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE      WHERE PM.PLAYERCODE NOT IN  (SELECT WKT.WICKETPLAYER FROM WICKETEVENTS WKT        WHERE WKT.COMPETITIONCODE = '%@' AND WKT.MATCHCODE = '%@'  AND WKT.TEAMCODE = '%@' AND WKT.INNINGSNO='%@') AND PM.PLAYERCODE NOT IN (SELECT STRIKERCODE BATSMANCODE FROM (SELECT STRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'       GROUP BY STRIKERCODE UNION ALL SELECT NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND TEAMCODE='%@' AND INNINGSNO='%@' GROUP BY NONSTRIKERCODE) AS BATSMAN)AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetPlayerDetailOnAbsentHurt *record=[[GetPlayerDetailOnAbsentHurt alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [GetPlayerDetailsOnAbsentHurt addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetPlayerDetailsOnAbsentHurt;
}


//-(NSMutableArray*) GetPlayerDetailOnTimeOutForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO
//{
//    NSMutableArray *arraylist4=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    { NSString *updateSQL =[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME   FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE  AND MR.COMPETITIONCODE ='%@'   AND MR.MATCHCODE = '%@' AND MPD.TEAMCODE ='%@' INNER JOIN COMPETITION COM  ON COM.COMPETITIONCODE = MR.COMPETITIONCODE   INNER JOIN PLAYERMASTER PM      ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE PM.PLAYERCODE NOT IN (SELECT WKT.WICKETPLAYER   FROM WICKETEVENTS WKT  WHERE WKT.COMPETITIONCODE ='%@'  AND WKT.MATCHCODE = '%@' AND WKT.TEAMCODE ='%@'  AND WKT.INNINGSNO='%@' )   AND PM.PLAYERCODE NOT IN (  SELECT STRIKERCODE BATSMANCODE FROM (  SELECT STRIKERCODE FROM BALLEVENTS       WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'   AND TEAMCODE='%@' AND INNINGSNO='%@' GROUP BY STRIKERCODE   UNION ALL   SELECT NONSTRIKERCODE FROM  BALLEVENTS    WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'AND TEAMCODE='%@' AND INNINGSNO='%@'  GROUP BY NONSTRIKERCODE) AS BATSMAN  )  AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))     ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
//        const char *update_stmt = [updateSQL UTF8String];
//        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetPlayerDetailOnAbsentHurt *record=[[GetPlayerDetailOnAbsentHurt alloc]init];
//                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                [arraylist4 addObject:record];
//            }
//            sqlite3_reset(statement);
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return arraylist4;
//}



-(NSMutableArray*) GetPlayerDetailOnRetiredHurt2ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
{
    NSMutableArray * arraylist5=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"   SELECT PM.PLAYERCODE, PM.PLAYERNAME      FROM MATCHREGISTRATION MR      INNER JOIN MATCHTEAMPLAYERDETAILS MPD      ON MR.MATCHCODE = MPD.MATCHCODE      AND MR.COMPETITIONCODE ='%@'      AND MR.MATCHCODE = '%@'      AND MPD.TEAMCODE = '%@'      INNER JOIN COMPETITION COM       ON COM.COMPETITIONCODE = MR.COMPETITIONCODE      INNER JOIN PLAYERMASTER PM      ON MPD.PLAYERCODE = PM.PLAYERCODE      WHERE (PM.PLAYERCODE NOT IN       (        SELECT WKT.WICKETPLAYER       FROM WICKETEVENTS WKT        WHERE WKT.COMPETITIONCODE = '%@'       AND WKT.MATCHCODE = '%@'       AND WKT.TEAMCODE = '%@'       AND WKT.INNINGSNO='%@'      )      OR PM.PLAYERCODE IN      (       SELECT CURRENTSTRIKERCODE FROM INNINGSEVENTS       WHERE COMPETITIONCODE = '%@'       AND MATCHCODE = '%@'       AND TEAMCODE = '%@'       AND INNINGSNO = '%@'       UNION ALL       SELECT CURRENTNONSTRIKERCODE FROM INNINGSEVENTS       WHERE COMPETITIONCODE = '%@'       AND MATCHCODE = '%@'       AND TEAMCODE = '%@'       AND INNINGSNO = '%@'      ))      AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))      ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetPlayerDetailOnRetiredHurt2 *record=[[GetPlayerDetailOnRetiredHurt2 alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [arraylist5 addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return arraylist5;
}



-(NSMutableArray*) GetPlayerDetailOnRetiredHurtOnMSC108ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
{
    NSMutableArray *GetPlayerDetailsOnRetiredHurtOnMSC108=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *updateSQL =[NSString stringWithFormat:@" SELECT PM.PLAYERCODE, PM.PLAYERNAME      FROM MATCHREGISTRATION MR      INNER JOIN MATCHTEAMPLAYERDETAILS MPD      ON MR.MATCHCODE = MPD.MATCHCODE      AND MR.COMPETITIONCODE = '%@'       AND MR.MATCHCODE = '%@'       AND MPD.TEAMCODE = '%@'       INNER JOIN COMPETITION COM       ON COM.COMPETITIONCODE = MR.COMPETITIONCODE      INNER JOIN PLAYERMASTER PM      ON MPD.PLAYERCODE = PM.PLAYERCODE      WHERE ((PM.PLAYERCODE NOT IN       (        SELECT WKT.WICKETPLAYER       FROM WICKETEVENTS WKT        WHERE WKT.COMPETITIONCODE = '%@'        AND WKT.MATCHCODE = '%@'        AND WKT.TEAMCODE = '%@'        AND WKT.INNINGSNO='%@'       )      AND PM.PLAYERCODE NOT IN      (       SELECT STRIKERCODE BATSMANCODE FROM (       SELECT STRIKERCODE FROM BALLEVENTS       WHERE COMPETITIONCODE='%@'  AND MATCHCODE='%@'        AND TEAMCODE='%@'  AND INNINGSNO='%@'     GROUP BY STRIKERCODE       UNION ALL       SELECT NONSTRIKERCODE FROM  BALLEVENTS       WHERE COMPETITIONCODE='%@'  AND MATCHCODE='%@'        AND TEAMCODE='%@'  AND INNINGSNO='%@'        GROUP BY NONSTRIKERCODE) AS BATSMAN      ))      OR PM.PLAYERCODE IN      (       SELECT CURRENTSTRIKERCODE FROM INNINGSEVENTS       WHERE COMPETITIONCODE = '%@'        AND MATCHCODE = '%@'        AND TEAMCODE = '%@'        AND INNINGSNO ='%@'       UNION ALL       SELECT CURRENTNONSTRIKERCODE FROM INNINGSEVENTS       WHERE COMPETITIONCODE = '%@'        AND MATCHCODE = '%@'        AND TEAMCODE = '%@'        AND INNINGSNO ='%@'     ))      AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))      ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){    GetPlayerDetailOnRetiredHurtOnMSC108 *record=[[GetPlayerDetailOnRetiredHurtOnMSC108 alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [GetPlayerDetailsOnRetiredHurtOnMSC108 addObject:record];
                
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetPlayerDetailsOnRetiredHurtOnMSC108;
}

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}

//SP_INSERTOTHERWICKETS

-(NSString *)  GetBallCodeForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WE.BALLCODE FROM WICKETEVENTS WE 	WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@' AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@' AND WE.WICKETPLAYER='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETPLAYER];
        const char *update_stmt = [updateSQL UTF8String];
    
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [self getValueByNull:statement :0];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

            
        }
        sqlite3_close(dataBase);
    }
   
    return @"";
}

-(NSString*)  GetMaxOverForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(OVERNO) AS OVERNO FROM BALLEVENTS BE   WHERE BE.COMPETITIONCODE='%@' AND BE.MATCHCODE='%@' AND BE.TEAMCODE='%@' AND BE.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OVERNO =  [self getValueByNull:statement :0];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OVERNO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*)  GetMaxBallForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(BALLNO) AS BALLNO  FROM BALLEVENTS BE	 WHERE BE.COMPETITIONCODE='%@' AND BE.MATCHCODE='%@' AND BE.TEAMCODE='%@' AND BE.INNINGSNO='%@' AND BE.OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,MAXOVER];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLNO =  [self getValueByNull:statement :0];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLNO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
        sqlite3_close(dataBase);
    }
    sqlite3_reset(statement);
    return @"";
}

-(NSString*) GetMaxBallCountForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER: (NSString*) MAXBALL {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(BE.BALLCOUNT) AS BALLCOUNT  FROM BALLEVENTS BE   WHERE BE.COMPETITIONCODE='%@' AND BE.MATCHCODE='%@' AND BE.TEAMCODE='%@' AND BE.INNINGSNO='%@' AND BE.OVERNO='%@' AND BE.BALLNO='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,MAXOVER,MAXBALL];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCOUNT =  [self getValueByNull:statement :0];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCOUNT;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
       
        sqlite3_close(dataBase);
    }
    
    return @"";
}

-(NSString*) GetBallCodeOnExistsForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER: (NSString*) MAXBALL : (NSString*) BALLCOUNT {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BE WHERE BE.COMPETITIONCODE='%@' AND BE.MATCHCODE='%@' AND BE.TEAMCODE='%@' AND BE.INNINGSNO='%@' AND BE.OVERNO='%@' AND BE.BALLNO='%@' AND BE.BALLCOUNT='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,MAXOVER,MAXBALL,BALLCOUNT];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE = [self getValueByNull:statement :0];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
       
        sqlite3_close(dataBase);
    }

    return @"";
}
-(NSString*) GetBallCodeForAssignForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER: (NSString*) MAXBALL : (NSString*) BALLCOUNT {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BE WHERE BE.COMPETITIONCODE='%@' AND BE.MATCHCODE='%@' AND BE.TEAMCODE='%@' AND BE.INNINGSNO='%@' AND BE.OVERNO='%@' AND BE.BALLNO='%@' AND BE.BALLCOUNT='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,MAXOVER,MAXBALL,BALLCOUNT];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [self getValueByNull:statement :0];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

            
        }
        
        sqlite3_close(dataBase);
    }

    return @"";
}

-(NSString*) GetMaxIdForInsertOtherwicket:  (NSString*) MATCHCODE {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CONVERT(NVARCHAR(50),ISNULL(MAX(CONVERT(NUMERIC(10,0), RIGHT(BALLCODE,10))),0) + 1)as MAXID   FROM BALLEVENTS WHERE MATCHCODE = '%@'",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MAXID =  [self getValueByNull:statement :0];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MAXID;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
      
        sqlite3_close(dataBase);
    }

    return @"";
}




-(BOOL) InsertWicketEventForInsertOtherwicket:(NSString*) BALLCODE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*)  WICKETNO: (NSString*) WICKETTYPE: (NSString*) WICKETPLAYER: (NSString*) VIDEOLOCATION{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO WICKETEVENTS (  BALLCODE, COMPETITIONCODE,	MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,	WICKETTYPE,WICKETPLAYER,VIDEOLOCATION)  VALUES  ( '%@',	 '%@', '%@', '%@','%@',	'0','%@','%@', '%@', '%@')",BALLCODE,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO,WICKETTYPE,WICKETPLAYER,VIDEOLOCATION];
        
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

-(NSMutableArray *) GetWicketDetailForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER;
{
    NSMutableArray *GetWicketDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETNO, WICKETTYPE, FIELDINGPLAYER FROM WICKETEVENTS WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' AND TEAMCODE = '%@'		AND INNINGSNO = '%@'		AND WICKETPLAYER = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETPLAYER];
        
        const char *update_stmt = [updateSQL UTF8String];
         if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
         {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetWicketDetail *record=[[GetWicketDetail alloc]init];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.FIELDINGPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [GetWicketDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketDetails;
}
-(NSString*)GetBatsManCodeForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BATSMANCODE FROM BATTINGSUMMARY	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND BATSMANCODE = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETPLAYER];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                
                NSString *BATSMANCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BATSMANCODE;
            }
            sqlite3_reset(statement);

            sqlite3_finalize(statement);
            

        }

        sqlite3_close(dataBase);
    }

    return @"";
}


-(BOOL) UpdateBattingSummaryForInsertOtherwicket:(NSString*) WICKETNO :(NSString*) WICKETTYPE:(NSString*) FIELDERCODE:(NSNumber*) WICKETSCORE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) BATSMANCODE{
    
    
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET 	WICKETNO = '%@',WICKETTYPE = '%@',FIELDERCODE = '%@',WICKETSCORE = '%@'	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'			AND INNINGSNO = '%@'			AND BATSMANCODE = '%@'",WICKETNO,WICKETTYPE,FIELDERCODE,WICKETSCORE,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BATSMANCODE];
        
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

-(NSString*)  GetBattingPositionNoForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) + 1 as Count  FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@'	 AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *Count =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return Count;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
   
        sqlite3_close(dataBase);
    }

    return @"";
}

-(BOOL) InsertBattingSummaryForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) BATTINGPOSITIONNO: (NSString*) WICKETPLAYER :(NSNumber *) N_WICKETNO:(NSNumber*) N_WICKETTYPE:(NSNumber*) TOTALRUNS {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY (	COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTINGPOSITIONNO,BATSMANCODE,RUNS,	BALLS,ONES,TWOS,THREES,FOURS,SIXES,	DOTBALLS,WICKETNO,WICKETTYPE,	WICKETSCORE	) VALUES	('%@','%@','%@','%@','%@','%@',0,0,0,0,0,0,	0,	0,	'%@','%@','%@')",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BATTINGPOSITIONNO,WICKETPLAYER,N_WICKETNO,N_WICKETTYPE,TOTALRUNS];
        
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

-(NSString*)  GetInningsNoForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT INNINGSNO FROM INNINGSSUMMARY		WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
    if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
    {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *Count =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return Count;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }

        sqlite3_close(dataBase);
    }

    return @"";
}
-(BOOL)  UpdateInningsSummaryForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET INNINGSTOTALWICKETS = INNINGSTOTALWICKETS + 1	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'		AND INNINGSNO = '%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
        
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

-(BOOL)  InsertInningsSummaryForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO INNINGSSUMMARY 	(COMPETITIONCODE,	MATCHCODE,BATTINGTEAMCODE,	INNINGSNO,	BYES,LEGBYES,NOBALLS,WIDES,PENALTIES,INNINGSTOTAL,INNINGSTOTALWICKETS) VALUES	(	'%@','%@','%@',	'%@',0,	0,	0,	0, 0,0,	1)",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
        
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
-(NSMutableArray *) GetPlayerDetailForInsertOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME ;
{
    NSMutableArray *GetPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD	ON MR.MATCHCODE = MPD.MATCHCODE	AND MR.COMPETITIONCODE = '%@'	AND MR.MATCHCODE = '%@'	AND MPD.TEAMCODE = '%@'	INNER JOIN COMPETITION COM 	ON COM.COMPETITIONCODE = MR.COMPETITIONCODE	INNER JOIN PLAYERMASTER PM	ON MPD.PLAYERCODE = PM.PLAYERCODE	WHERE PM.PLAYERCODE NOT IN 	(			SELECT WKT.WICKETPLAYER		FROM WICKETEVENTS WKT 		INNER JOIN BALLEVENTS BL		ON WKT.BALLCODE = BL.BALLCODE		AND BL.COMPETITIONCODE = '%@'		AND BL.MATCHCODE = '%@'		AND	BL.TEAMCODE = '%@'		AND WKT.WICKETTYPE != 'MSC102'	)	AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))	ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMNAME,COMPETITIONCODE,MATCHCODE,TEAMNAME];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                GetPlayerDetail *record=[[GetPlayerDetail alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                
                [GetPlayerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetPlayerDetails;
}

-(NSMutableArray *) GetWicketEventDetailsForInsertOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME: (NSNumber*) INNINGSNO ;
{
    NSMutableArray *GetWicketEventsPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT	WICKETDETAILS.BALLCODE, WICKETDETAILS.WICKETNO, WICKETDETAILS.VIDEOLOCATION, WICKETDETAILS.WICKETPLAYER,			WICKETDETAILS.WICKETTYPE, WICKETDETAILS.WICKETTYPECODE,WICKETDETAILS.PLAYVIDEO	FROM	(	SELECT	WE.BALLCODE, WE.WICKETNO,WE.VIDEOLOCATION,PM.PLAYERNAME AS WICKETPLAYER,			MD.METASUBCODEDESCRIPTION AS WICKETTYPE,			WE.WICKETTYPE AS WICKETTYPECODE,'PLAY' AS PLAYVIDEO,			(SELECT COUNT(BE.BALLCODE) FROM BALLEVENTS BE			WHERE BE.COMPETITIONCODE = WE.COMPETITIONCODE AND BE.MATCHCODE = WE.MATCHCODE			AND BE.TEAMCODE = WE.TEAMCODE AND BE.INNINGSNO = WE.INNINGSNO			AND (BE.STRIKERCODE = WE.WICKETPLAYER OR BE.NONSTRIKERCODE = WE.WICKETPLAYER)			AND BE.OVERNO || '.' ||  BE.BALLNO ||  BE.BALLCOUNT	> BALL.OVERNO ||  '.' ||  BALL.BALLNO || BALL.BALLCOUNT)   AS WICKETCOUNT	FROM WICKETEVENTS WE	LEFT JOIN	BALLEVENTS BALL ON BALL.COMPETITIONCODE = WE.COMPETITIONCODE				AND BALL.MATCHCODE = WE.MATCHCODE				AND BALL.TEAMCODE = WE.TEAMCODE				AND BALL.INNINGSNO = WE.INNINGSNO				AND BALL.BALLCODE = WE.BALLCODE	INNER JOIN	PLAYERMASTER PM ON PM.PLAYERCODE=WE.WICKETPLAYER	INNER JOIN	METADATA MD ON MD.METASUBCODE=WE.WICKETTYPE	WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@'	AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@' AND ISWICKET='0'	)WICKETDETAILS	WHERE WICKETDETAILS.WICKETCOUNT < 1",COMPETITIONCODE,MATCHCODE,TEAMNAME,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetWicketEventsPlayerDetail *record=[[GetWicketEventsPlayerDetail alloc]init];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.VIDEOLOCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.WICKETTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.PLAYVIDEO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                [GetWicketEventsPlayerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketEventsPlayerDetails;
}


-(NSNumber*)  GetWicketNoForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT (IFNULL(MAX(WE.WICKETNO),0)+1) WICKETNO FROM WICKETEVENTS WE WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@' AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        sqlite3_close(dataBase);
    }

    return @"";
}




//--------------------
//UPDATE OTHER WICKETS
//--------------------

-(NSString*)  GetBallCodeForUpdateOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER :(NSNumber*) WICKETNO: (NSString*) WICKETTYPE {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WE.BALLCODE FROM WICKETEVENTS WE 	WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE= '%@'AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@' AND WE.WICKETPLAYER='%@'	AND WE.WICKETNO<>'%@' AND WE.WICKETTYPE='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETPLAYER,WICKETNO,WICKETTYPE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
       
        sqlite3_close(dataBase);
    }
   
    return @"";
}

-(BOOL)  UpdateWicKetEventUpdateOtherwicket:(NSString*) WICKETTYPE:(NSString*) WICKETPLAYER:(NSString*) VIDEOLOCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS  SET    WICKETTYPE='%@',	WICKETPLAYER='%@',	VIDEOLOCATION='%@'	WHERE COMPETITIONCODE='%@' 	AND MATCHCODE='%@' 	AND TEAMCODE='%@' 	AND INNINGSNO='%@' 	AND WICKETNO = '%@' AND ISWICKET='0'",WICKETTYPE,WICKETPLAYER,VIDEOLOCATION,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO];
        
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


-(NSMutableArray *) GetwicketForUpdateOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER{
    NSMutableArray *GetWicketDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETNO,WICKETTYPE,FIELDINGPLAYER FROM WICKETEVENTS WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND WICKETPLAYER='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETPLAYER];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetWicketDetail *record=[[GetWicketDetail alloc]init];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.FIELDINGPLAYER=[self getValueByNull:statement:2];
                [GetWicketDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketDetails;
}




-(NSMutableArray *) GetWicketOnAssignForUpdateOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER;
{
    NSMutableArray *GetWicketOnAssignDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT	WICKETDETAILS.BALLCODE, WICKETDETAILS.WICKETNO, WICKETDETAILS.VIDEOLOCATION, WICKETDETAILS.WICKETPLAYER,			WICKETDETAILS.WICKETTYPE, WICKETDETAILS.WICKETTYPECODE,WICKETDETAILS.PLAYVIDEO	FROM	(	SELECT	WE.BALLCODE, WE.WICKETNO,WE.VIDEOLOCATION,PM.PLAYERNAME AS WICKETPLAYER,			MD.METASUBCODEDESCRIPTION AS WICKETTYPE,			WE.WICKETTYPE AS WICKETTYPECODE,'PLAY' AS PLAYVIDEO,			(SELECT COUNT(BE.BALLCODE)			FROM BALLEVENTS BE			WHERE BE.COMPETITIONCODE = WE.COMPETITIONCODE AND BE.MATCHCODE = WE.MATCHCODE			AND BE.TEAMCODE = WE.TEAMCODE AND BE.INNINGSNO = WE.INNINGSNO			AND (BE.STRIKERCODE = WE.WICKETPLAYER OR BE.NONSTRIKERCODE = WE.WICKETPLAYER)			AND (CONVERT( NUMERIC,( CONVERT(NVARCHAR,BE.OVERNO) + '.' + CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT) ) )				> CONVERT( NUMERIC,( CONVERT(NVARCHAR,BALL.OVERNO) + '.' + CONVERT(NVARCHAR,BALL.BALLNO) + CONVERT(NVARCHAR,BALL.BALLCOUNT) ) ) ) ) AS WICKETCOUNT	FROM WICKETEVENTS WE	LEFT JOIN	BALLEVENTS BALL ON BALL.COMPETITIONCODE = WE.COMPETITIONCODE				AND BALL.MATCHCODE = WE.MATCHCODE				AND BALL.TEAMCODE = WE.TEAMCODE				AND BALL.INNINGSNO = WE.INNINGSNO				AND BALL.BALLCODE = WE.BALLCODE	INNER JOIN	PLAYERMASTER PM ON PM.PLAYERCODE=WE.WICKETPLAYER	INNER JOIN	METADATA MD ON MD.METASUBCODE=WE.WICKETTYPE	WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@'	AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@' AND ISWICKET='0'	)WICKETDETAILS	WHERE WICKETDETAILS.WICKETCOUNT < 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                //                                       GetWicketOnAssignDetail *record=[[GetWicketOnAssignDetail alloc]init];
                //                                       record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                //                                       record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                //                                       record.FIELDINGPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                //
                //
                //
                //
                //                                       [GetWicketOnAssignDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketOnAssignDetails;
}

-(BOOL)  UpdateBattingSummaryForUpdateOtherwicket:(NSString*) N_WICKETNO:(NSString*) N_WICKETTYPE:(NSString*) N_FIELDERCODE :(NSString*) TOTALRUNS: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY 	SET WICKETNO = '%@',	WICKETTYPE = '%@',	FIELDERCODE = '%@',	WICKETSCORE = '%@'	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'		AND BATTINGTEAMCODE = '%@'		AND INNINGSNO = '%@'		AND BATSMANCODE = '%@'",N_WICKETNO,N_WICKETTYPE,N_FIELDERCODE,TOTALRUNS,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,WICKETPLAYER];
        
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

-(NSMutableArray *) GetPlayerDetailForUpdateOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME ;
{
    NSMutableArray *GetPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD	ON MR.MATCHCODE = MPD.MATCHCODE	AND MR.COMPETITIONCODE = '%@'	AND MR.MATCHCODE = '%@'	AND MPD.TEAMCODE = '%@'	INNER JOIN COMPETITION COM 	ON COM.COMPETITIONCODE = MR.COMPETITIONCODE	INNER JOIN PLAYERMASTER PM	ON MPD.PLAYERCODE = PM.PLAYERCODE	WHERE PM.PLAYERCODE NOT IN 	(			SELECT WKT.WICKETPLAYER		FROM WICKETEVENTS WKT 		INNER JOIN BALLEVENTS BL		ON WKT.BALLCODE = BL.BALLCODE		AND BL.COMPETITIONCODE = '%@'		AND BL.MATCHCODE = '%@'		AND	BL.TEAMCODE = '%@'		AND WKT.WICKETTYPE != 'MSC102'	)	AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))	ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMNAME,COMPETITIONCODE,MATCHCODE,TEAMNAME];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetPlayerDetail *record=[[GetPlayerDetail alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                
                [GetPlayerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetPlayerDetails;
}

-(NSMutableArray *) GetWicketEventDetailsForUpdateOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
{
    NSMutableArray *GetWicketEventsPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT	WICKETDETAILS.BALLCODE, WICKETDETAILS.WICKETNO, WICKETDETAILS.VIDEOLOCATION, WICKETDETAILS.WICKETPLAYER,			WICKETDETAILS.WICKETTYPE, WICKETDETAILS.WICKETTYPECODE,WICKETDETAILS.PLAYVIDEO	FROM	(	SELECT	WE.BALLCODE, WE.WICKETNO,WE.VIDEOLOCATION,PM.PLAYERNAME AS WICKETPLAYER,			MD.METASUBCODEDESCRIPTION AS WICKETTYPE,			WE.WICKETTYPE AS WICKETTYPECODE,'PLAY' AS PLAYVIDEO,			(SELECT COUNT(BE.BALLCODE)			FROM BALLEVENTS BE			WHERE BE.COMPETITIONCODE = WE.COMPETITIONCODE AND BE.MATCHCODE = WE.MATCHCODE			AND BE.TEAMCODE = WE.TEAMCODE AND BE.INNINGSNO = WE.INNINGSNO			AND (BE.STRIKERCODE = WE.WICKETPLAYER OR BE.NONSTRIKERCODE = WE.WICKETPLAYER)			AND (CONVERT( NUMERIC,( CONVERT(NVARCHAR,BE.OVERNO) + '.' + CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT) ) )				> CONVERT( NUMERIC,( CONVERT(NVARCHAR,BALL.OVERNO) + '.' + CONVERT(NVARCHAR,BALL.BALLNO) + CONVERT(NVARCHAR,BALL.BALLCOUNT) ) ) ) ) AS WICKETCOUNT	FROM WICKETEVENTS WE	LEFT JOIN	BALLEVENTS BALL ON BALL.COMPETITIONCODE = WE.COMPETITIONCODE				AND BALL.MATCHCODE = WE.MATCHCODE				AND BALL.TEAMCODE = WE.TEAMCODE				AND BALL.INNINGSNO = WE.INNINGSNO				AND BALL.BALLCODE = WE.BALLCODE	INNER JOIN	PLAYERMASTER PM ON PM.PLAYERCODE=WE.WICKETPLAYER	INNER JOIN	METADATA MD ON MD.METASUBCODE=WE.WICKETTYPE	WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@'	AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@' AND ISWICKET='0'	)WICKETDETAILS	WHERE WICKETDETAILS.WICKETCOUNT < 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetWicketEventsPlayerDetail *record=[[GetWicketEventsPlayerDetail alloc]init];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.VIDEOLOCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.WICKETTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.PLAYVIDEO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                
                
                [GetWicketEventsPlayerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketEventsPlayerDetails;
}
-(NSString*)  GetWicketNoForUpdateOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(WE.WICKETNO)+1 AS WICKETNO FROM WICKETEVENTS WE WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@' AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);

        }
        
        sqlite3_close(dataBase);
    }
   
    return @"";
}


//--------------------
//DELETE OTHER WICKETS
//--------------------



//SP_DELETEOTHERWICKETS

-(NSString*)  GetBallCodeForDeleteOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO :(NSNumber*) WICKETNO {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WE.BALLCODE FROM WICKETEVENTS WE 	WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE= '%@'AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@' AND ISWICKET ='0'AND WE.WICKETNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        
        sqlite3_close(dataBase);
    }

    return @"";
}


//-(NSMutableArray *) GetWicketPlayerandTypeForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO ;
//{
//    NSMutableArray *GetWicketPlayerandtypePlayerDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETPLAYER, WICKETTYPE 	FROM WICKETEVENTS	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'		AND TEAMCODE = '%@'		AND INNINGSNO = '%@'		AND WICKETNO = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO];
//                               const char *update_stmt = [updateSQL UTF8String];
//                               sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                               if (sqlite3_step(statement) == SQLITE_DONE)
//                               {
//                                   while(sqlite3_step(statement)==SQLITE_ROW){
////           GetWicketPlayerandtypePlayerDetails *record=[[GetWicketEventsPlayerDetail alloc]init];
////                    record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
////                    record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
////
////                   [GetWicketPlayerandtypePlayerDetails addObject:record];
//                                   }
//
//                               }
//                               }
//                               sqlite3_finalize(statement);
//                               sqlite3_close(dataBase);
//                               return GetWicketPlayerandtypePlayerDetails;
//                               }
//
//


-(NSMutableArray *) GetWicketPlayerandTypeForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO
{
    NSMutableArray *GetWicketPlayerandtypePlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETPLAYER, WICKETTYPE 	FROM WICKETEVENTS	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'		AND TEAMCODE = '%@'		AND INNINGSNO = '%@'		AND WICKETNO = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetWicketEventsPlayerDetail *record=[[GetWicketEventsPlayerDetail alloc]init];
                record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                
                [GetWicketPlayerandtypePlayerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketPlayerandtypePlayerDetails;
}


-(BOOL)  UpdateBattingSummaryForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY 	SET WICKETNO = '',WICKETTYPE = '',	FIELDERCODE = ''	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@'		AND INNINGSNO = '%@'	AND BATSMANCODE = '%@'",COMPETITIONCODE, MATCHCODE,TEAMNAME,INNINGSNO,WICKETPLAYER];
        
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

-(BOOL)  DeleteBattingSummaryForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE BATTINGSUMMARY 	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@'	AND BATSMANCODE = '%@'",COMPETITIONCODE, MATCHCODE,TEAMNAME,INNINGSNO,WICKETPLAYER];
        
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


-(BOOL)  UpdateBattingSummaryDetailForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = WICKETNO - 1	WHERE COMPETITIONCODE = '%@'	AND MATCHCODE ='%@'	AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@'			AND WICKETNO > '%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO];
        
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

-(BOOL)   UpdateInningsSummaryDetailForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"	UPDATE INNINGSSUMMARY	SET INNINGSTOTALWICKETS = INNINGSTOTALWICKETS - 1	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND BATTINGTEAMCODE = '%@'		AND INNINGSNO = '%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
        
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

-(BOOL)    DeleteWicketEventsForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"	DELETE FROM WICKETEVENTS	WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND WICKETNO = '%@' AND ISWICKET='0'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO];
        
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

-(BOOL)    UpdateWicketEventsForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETNO = WICKETNO - 1  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND WICKETNO > '%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,WICKETNO];
        
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

-(NSMutableArray *) GetPlayerDetailForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME ;
{
    NSMutableArray *GetPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD	ON MR.MATCHCODE = MPD.MATCHCODE	AND MR.COMPETITIONCODE = '%@'	AND MR.MATCHCODE = '%@'	AND MPD.TEAMCODE = '%@'	INNER JOIN COMPETITION COM 	ON COM.COMPETITIONCODE = MR.COMPETITIONCODE	INNER JOIN PLAYERMASTER PM	ON MPD.PLAYERCODE = PM.PLAYERCODE	WHERE PM.PLAYERCODE NOT IN 	(			SELECT WKT.WICKETPLAYER		FROM WICKETEVENTS WKT 		INNER JOIN BALLEVENTS BL		ON WKT.BALLCODE = BL.BALLCODE		AND BL.COMPETITIONCODE = '%@'		AND BL.MATCHCODE = '%@'		AND	BL.TEAMCODE = '%@'		AND WKT.WICKETTYPE != 'MSC102'	)	AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))	ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMNAME,COMPETITIONCODE,MATCHCODE,TEAMNAME];
        
        const char *update_stmt = [updateSQL UTF8String];
 if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetPlayerDetail *record=[[GetPlayerDetail alloc]init];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                
                [GetPlayerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetPlayerDetails;
}

-(NSMutableArray *) GetWicketEventDetailsForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
{
    NSMutableArray *GetWicketEventsPlayerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT	WICKETDETAILS.BALLCODE, WICKETDETAILS.WICKETNO, WICKETDETAILS.VIDEOLOCATION, WICKETDETAILS.WICKETPLAYER,			WICKETDETAILS.WICKETTYPE, WICKETDETAILS.WICKETTYPECODE,WICKETDETAILS.PLAYVIDEO	FROM	(	SELECT	WE.BALLCODE, WE.WICKETNO,WE.VIDEOLOCATION,PM.PLAYERNAME AS WICKETPLAYER,			MD.METASUBCODEDESCRIPTION AS WICKETTYPE,			WE.WICKETTYPE AS WICKETTYPECODE,'PLAY' AS PLAYVIDEO,			(SELECT COUNT(BE.BALLCODE)			FROM BALLEVENTS BE			WHERE BE.COMPETITIONCODE = WE.COMPETITIONCODE AND BE.MATCHCODE = WE.MATCHCODE			AND BE.TEAMCODE = WE.TEAMCODE AND BE.INNINGSNO = WE.INNINGSNO			AND (BE.STRIKERCODE = WE.WICKETPLAYER OR BE.NONSTRIKERCODE = WE.WICKETPLAYER)			AND (CONVERT( NUMERIC,( CONVERT(NVARCHAR,BE.OVERNO) + '.' + CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT) ) )				> CONVERT( NUMERIC,( CONVERT(NVARCHAR,BALL.OVERNO) + '.' + CONVERT(NVARCHAR,BALL.BALLNO) + CONVERT(NVARCHAR,BALL.BALLCOUNT) ) ) ) ) AS WICKETCOUNT	FROM WICKETEVENTS WE	LEFT JOIN	BALLEVENTS BALL ON BALL.COMPETITIONCODE = WE.COMPETITIONCODE				AND BALL.MATCHCODE = WE.MATCHCODE				AND BALL.TEAMCODE = WE.TEAMCODE				AND BALL.INNINGSNO = WE.INNINGSNO				AND BALL.BALLCODE = WE.BALLCODE	INNER JOIN	PLAYERMASTER PM ON PM.PLAYERCODE=WE.WICKETPLAYER	INNER JOIN	METADATA MD ON MD.METASUBCODE=WE.WICKETTYPE	WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@'	AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@' AND ISWICKET='0'	)WICKETDETAILS	WHERE WICKETDETAILS.WICKETCOUNT < 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
  if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetWicketEventsPlayerDetail *record=[[GetWicketEventsPlayerDetail alloc]init];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.VIDEOLOCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.WICKETTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.PLAYVIDEO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                
                
                [GetWicketEventsPlayerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetWicketEventsPlayerDetails;
}

-(NSString*)  GetWicketNoForDeleteOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(WE.WICKETNO)+1 AS WICKETNO FROM WICKETEVENTS WE WHERE WE.COMPETITIONCODE='%@' AND WE.MATCHCODE='%@' AND WE.TEAMCODE='%@' AND WE.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
      if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNO;
            }
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
       
        sqlite3_close(dataBase);
    
    }

    return @"";
}





@end
