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






//wicket Type
+(NSMutableArray *)RetrieveOtherWicketType{
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
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return WicketTypeArray;
}




+(NSMutableArray *)  GetStrickerNonStrickerCodeForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
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
      sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
      if (sqlite3_step(statement) == SQLITE_DONE)
         {
            while(sqlite3_step(statement)==SQLITE_ROW){
            GetStrickerNonStrickerPlayerCode *record=[[GetStrickerNonStrickerPlayerCode alloc]init];
          record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
          record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        [arraylist addObject:record];
                  }
                                   
               }
             }
              sqlite3_finalize(statement);
             sqlite3_close(dataBase);
              return arraylist;
             }
                               
                               
 +(NSMutableArray *)   GetPlayerDetailForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO;
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
                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                  if (sqlite3_step(statement) == SQLITE_DONE)
                 {  while(sqlite3_step(statement)==SQLITE_ROW){
                     GetPlayerDetail *record=[[GetPlayerDetail alloc]init];
                   record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                  record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                         [arraylist1 addObject:record];
                    }} }sqlite3_finalize(statement);
                        sqlite3_close(dataBase);
                        return arraylist1;
                        }
    
                               
+(NSMutableArray*) GetPlayerDetailOnRetiredHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
   {
   NSMutableArray *arraylist3=[[NSMutableArray alloc]init];
   NSString *databasePath = [self getDBPath];
      sqlite3_stmt *statement;
                sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
                 if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                 {
                     NSString *updateSQL =[NSString stringWithFormat:@" SELECT PM.PLAYERCODE, PM.PLAYERNAME   FROM MATCHREGISTRATION MR    INNER JOIN MATCHTEAMPLAYERDETAILS MPD    ON MR.MATCHCODE = MPD.MATCHCODE    AND MR.COMPETITIONCODE = '%@'    AND MR.MATCHCODE = '%@'    AND MPD.TEAMCODE = '%@'    INNER JOIN COMPETITION COM     ON COM.COMPETITIONCODE = MR.COMPETITIONCODE    INNER JOIN PLAYERMASTER PM    ON MPD.PLAYERCODE = PM.PLAYERCODE    WHERE (PM.PLAYERCODE NOT IN     (     SELECT WKT.WICKETPLAYER     FROM WICKETEVENTS WKT      WHERE WKT.COMPETITIONCODE = @COMPETITIONCODE     AND WKT.MATCHCODE = @MATCHCODE     AND WKT.TEAMCODE = @TEAMCODE     AND WKT.INNINGSNO=@INNINGSNO    )    OR PM.PLAYERCODE IN    (     SELECT CURRENTSTRIKERCODE FROM INNINGSEVENTS     WHERE COMPETITIONCODE = @COMPETITIONCODE     AND MATCHCODE = @MATCHCODE     AND TEAMCODE = @TEAMCODE     AND INNINGSNO = @INNINGSNO     UNION ALL     SELECT CURRENTNONSTRIKERCODE FROM INNINGSEVENTS      WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'     AND TEAMCODE = '%@'     AND INNINGSNO = '%@'    ))    AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))   ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
                                   const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                {
                                    while(sqlite3_step(statement)==SQLITE_ROW){
                            GetPlayerDetailOnRetiredHurt *record=[[GetPlayerDetailOnRetiredHurt alloc]init];
                            record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                            record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                            [arraylist3 addObject:record];
                                        }
                             }}
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                     return arraylist3;
      }
                  
                                            
        
                                            
+(NSMutableArray*) GetPlayerDetailOnAbsentHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
    {
        NSMutableArray *GetPlayerDetailsOnAbsentHurt=[[NSMutableArray alloc]init];
       NSString *databasePath = [self getDBPath];
         sqlite3_stmt *statement;
        sqlite3 *dataBase;
         const char *dbPath = [databasePath UTF8String];
     if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
             { NSString *updateSQL =[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME      FROM MATCHREGISTRATION MR      INNER JOIN MATCHTEAMPLAYERDETAILS MPD  ON MR.MATCHCODE = MPD.MATCHCODE      AND MR.COMPETITIONCODE = '%@'  AND MR.MATCHCODE = '%@'  AND MPD.TEAMCODE = '%@'  INNER JOIN COMPETITION COM  ON COM.COMPETITIONCODE = MR.COMPETITIONCODE  INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE      WHERE PM.PLAYERCODE NOT IN  (SELECT WKT.WICKETPLAYER FROM WICKETEVENTS WKT        WHERE WKT.COMPETITIONCODE = '%@' AND WKT.MATCHCODE = '%@'  AND WKT.TEAMCODE = '%@' AND WKT.INNINGSNO='%@') AND PM.PLAYERCODE NOT IN (SELECT STRIKERCODE BATSMANCODE FROM (SELECT STRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'       GROUP BY STRIKERCODE UNION ALL SELECT NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND TEAMCODE='%@' AND INNINGSNO='%@' GROUP BY NONSTRIKERCODE) AS BATSMAN)AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
                  const char *update_stmt = [updateSQL UTF8String];
                  sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                  if (sqlite3_step(statement) == SQLITE_DONE)
                  {
                      while(sqlite3_step(statement)==SQLITE_ROW){
                     GetPlayerDetailOnAbsentHurt *record=[[GetPlayerDetailOnAbsentHurt alloc]init];
                    record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                       record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                      [GetPlayerDetailsOnAbsentHurt addObject:record];
                       }}}
                                sqlite3_finalize(statement);
                               sqlite3_close(dataBase);
                            return GetPlayerDetailsOnAbsentHurt;
                                  }
                                      
                                      
+(NSMutableArray*) GetPlayerDetailOnTimeOutForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
    {
        NSMutableArray *arraylist4=[[NSMutableArray alloc]init];
       NSString *databasePath = [self getDBPath];
       sqlite3_stmt *statement;
       sqlite3 *dataBase;
       const char *dbPath = [databasePath UTF8String];
       if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
       { NSString *updateSQL =[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME   FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE  AND MR.COMPETITIONCODE ='%@'   AND MR.MATCHCODE = '%@' AND MPD.TEAMCODE ='%@' INNER JOIN COMPETITION COM  ON COM.COMPETITIONCODE = MR.COMPETITIONCODE   INNER JOIN PLAYERMASTER PM      ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE PM.PLAYERCODE NOT IN (SELECT WKT.WICKETPLAYER   FROM WICKETEVENTS WKT  WHERE WKT.COMPETITIONCODE ='%@'  AND WKT.MATCHCODE = '%@' AND WKT.TEAMCODE ='%@'  AND WKT.INNINGSNO='%@' )   AND PM.PLAYERCODE NOT IN (  SELECT STRIKERCODE BATSMANCODE FROM (  SELECT STRIKERCODE FROM BALLEVENTS       WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'   AND TEAMCODE='%@' AND INNINGSNO='%@' GROUP BY STRIKERCODE   UNION ALL   SELECT NONSTRIKERCODE FROM  BALLEVENTS    WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'AND TEAMCODE='%@' AND INNINGSNO='%@'  GROUP BY NONSTRIKERCODE) AS BATSMAN  )  AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))     ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
            const char *update_stmt = [updateSQL UTF8String];
              sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
              if (sqlite3_step(statement) == SQLITE_DONE)
              {
              while(sqlite3_step(statement)==SQLITE_ROW){
             GetPlayerDetailOnAbsentHurt *record=[[GetPlayerDetailOnAbsentHurt alloc]init];
           record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
             record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            [arraylist4 addObject:record];
         }}}
      sqlite3_finalize(statement);
      sqlite3_close(dataBase);
     return arraylist4;
        }



+(NSMutableArray*) GetPlayerDetailOnRetiredHurt2ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
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
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
            while(sqlite3_step(statement)==SQLITE_ROW){
            GetPlayerDetailOnRetiredHurt2 *record=[[GetPlayerDetailOnRetiredHurt2 alloc]init];
            record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            [arraylist5 addObject:record];
           }
                    }
           }
      sqlite3_finalize(statement);
     sqlite3_close(dataBase);
    return arraylist5;
 }
  
                               
                               
+(NSMutableArray*) GetPlayerDetailOnRetiredHurtOnMSC108ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;
    {
    NSMutableArray *GetPlayerDetailsOnRetiredHurtOnMSC108=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
     const char *dbPath = [databasePath UTF8String];
     if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
      {
     NSString *updateSQL =[NSString stringWithFormat:@" SELECT PM.PLAYERCODE, PM.PLAYERNAME      FROM MATCHREGISTRATION MR      INNER JOIN MATCHTEAMPLAYERDETAILS MPD      ON MR.MATCHCODE = MPD.MATCHCODE      AND MR.COMPETITIONCODE = '%@'       AND MR.MATCHCODE = '%@'       AND MPD.TEAMCODE = '%@'       INNER JOIN COMPETITION COM       ON COM.COMPETITIONCODE = MR.COMPETITIONCODE      INNER JOIN PLAYERMASTER PM      ON MPD.PLAYERCODE = PM.PLAYERCODE      WHERE ((PM.PLAYERCODE NOT IN       (        SELECT WKT.WICKETPLAYER       FROM WICKETEVENTS WKT        WHERE WKT.COMPETITIONCODE = '%@'        AND WKT.MATCHCODE = '%@'        AND WKT.TEAMCODE = '%@'        AND WKT.INNINGSNO='%@'       )      AND PM.PLAYERCODE NOT IN      (       SELECT STRIKERCODE BATSMANCODE FROM (       SELECT STRIKERCODE FROM BALLEVENTS       WHERE COMPETITIONCODE='%@'  AND MATCHCODE='%@'        AND TEAMCODE='%@'  AND INNINGSNO='%@'     GROUP BY STRIKERCODE       UNION ALL       SELECT NONSTRIKERCODE FROM  BALLEVENTS       WHERE COMPETITIONCODE='%@'  AND MATCHCODE='%@'        AND TEAMCODE='%@'  AND INNINGSNO='%@'        GROUP BY NONSTRIKERCODE) AS BATSMAN      ))      OR PM.PLAYERCODE IN      (       SELECT CURRENTSTRIKERCODE FROM INNINGSEVENTS       WHERE COMPETITIONCODE = '%@'        AND MATCHCODE = '%@'        AND TEAMCODE = '%@'        AND INNINGSNO ='%@'       UNION ALL       SELECT CURRENTNONSTRIKERCODE FROM INNINGSEVENTS       WHERE COMPETITIONCODE = '%@'        AND MATCHCODE = '%@'        AND TEAMCODE = '%@'        AND INNINGSNO ='%@'     ))      AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))      ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,TEAMCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
       const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
  {  while(sqlite3_step(statement)==SQLITE_ROW){
    GetPlayerDetailOnRetiredHurtOnMSC108 *record=[[GetPlayerDetailOnRetiredHurtOnMSC108 alloc]init];
    record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
 record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
[GetPlayerDetailsOnRetiredHurtOnMSC108 addObject:record];
    }  }  } sqlite3_finalize(statement);
               sqlite3_close(dataBase);
              return GetPlayerDetailsOnRetiredHurtOnMSC108;
   }
         @end
