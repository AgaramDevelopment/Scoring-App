//
//  DBManagerLastInstance.m
//  CAPScoringApp
//
//  Created by Mac on 16/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerLastInstance.h"
#import "ScoreEnginEditRecord.h"
#import "Utitliy.h"
#import <sqlite3.h>

@implementation DBManagerLastInstance
//SP_FETCHSELASTINSTANCEDTLS

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




-(BOOL)  UpdateMatchRegistration: (NSString*) ISDEFAULTORLAST: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE
{
   
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET ISDEFAULTORLASTINSTANCE = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",ISDEFAULTORLAST,COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
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

-(NSString * ) GetBattingTeamOversFromOverEvents: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *SQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) AS OVERS   FROM OVEREVENTS OE WHERE OE.COMPETITIONCODE = '%@' AND OE.MATCHCODE = '%@' AND OE.INNINGSNO = '%@'  AND OVERSTATUS = 0",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        
        const char *sql_stmt = [SQL UTF8String];
        if(sqlite3_prepare(dataBase, sql_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *overs =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];

                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return overs;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
    
    
}

-(NSString * ) GetBattingTeamOversFromBallEvents: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSNumber*) BATTEAMOVERS
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *SQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) AS BALLS   FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'  AND OVERNO = %@",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTEAMOVERS];
        
        
        const char *sql_stmt = [SQL UTF8String];
        if(sqlite3_prepare(dataBase, sql_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BALLS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString * ) GetBattingTeamOverBallsFromBallEvetns: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSNumber*) BATTEAMOVERS   : (NSNumber*) BATTEAMOVRBALLS
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *SQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),1)  AS BALLCOUNT FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'  AND OVERNO = '%@' AND BALLNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS];
        
        
        const char *sql_stmt = [SQL UTF8String];
        if(sqlite3_prepare(dataBase, sql_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BALLCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";

}

-(NSString * ) GetLastBallCodeFromBallEvents: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSNumber*) BATTEAMOVERS   : (NSNumber*) BATTEAMOVRBALLS : (NSNumber*) BATTEAMOVRBALLSCNT
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *SQL = [NSString stringWithFormat:@"SELECT BALLCODE   FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'  AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        
        
        const char *sql_stmt = [SQL UTF8String];
        if(sqlite3_prepare(dataBase, sql_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return @"";

}


-(NSMutableArray *)GetLastinstancedetailsFromBallevents: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) LASTBALLCODE{
NSMutableArray *GetBallDetailsForBallEventsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
     //   NSString *query=[NSString stringWithFormat:@"SELECT BALL.BALLCODE, BALL.COMPETITIONCODE, BALL.MATCHCODE, BALL.TEAMCODE, BALL.INNINGSNO, BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT, BALL.SESSIONNO, BALL.STRIKERCODE,BALL.NONSTRIKERCODE, BALL.BOWLERCODE, BALL.WICKETKEEPERCODE, BALL.UMPIRE1CODE, BALL.UMPIRE2CODE, BALL.ATWOROTW, BALL.BOWLINGEND, BALL.BOWLTYPE AS BOWLTYPECODE,BT.BOWLTYPE, BT.BOWLERTYPE, BALL.SHOTTYPE AS SHOTCODE, ST.SHOTNAME, ST.SHOTTYPE, BALL.SHOTTYPECATEGORY, BALL.ISLEGALBALL, BALL.ISFOUR, BALL.ISSIX, BALL.RUNS,BALL.OVERTHROW, BALL.TOTALRUNS, BALL.WIDE, BALL.NOBALL, BALL.BYES, BALL.LEGBYES, BALL.PENALTY, BALL.TOTALEXTRAS, BALL.GRANDTOTAL, BALL.RBW, BALL.PMLINECODE,BALL.PMLENGTHCODE, BALL.PMSTRIKEPOINT,BALL.PMSTRIKEPOINTLINECODE, BALL.PMX1, BALL.PMY1, BALL.PMX2, BALL.PMY2, BALL.PMX3, BALL.PMY3, BALL.WWREGION, MD.METASUBCODEDESCRIPTION AS REGIONNAME,BALL.WWX1, BALL.WWY1, BALL.WWX2, BALL.WWY2, BALL.BALLDURATION, BALL.ISAPPEAL, BALL.ISBEATEN, BALL.ISUNCOMFORT, BALL.ISWTB, BALL.ISRELEASESHOT, BALL.MARKEDFOREDIT, BALL.REMARKS FROM BALLEVENTS BALL LEFT JOIN METADATA MD ON BALL.WWREGION = MD.METASUBCODE 		LEFT JOIN BOWLTYPE BT ON BALL.BOWLTYPE = BT.BOWLTYPECODE LEFT JOIN SHOTTYPE ST ON BALL.SHOTTYPE = ST.SHOTCODE WHERE  COMPETITIONCODE = '%@' and MATCHCODE = '%@' and BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,LASTBALLCODE];
        
        NSString *updateSQL =[NSString stringWithFormat:@"SELECT  BALL.BALLCODE, BALL.COMPETITIONCODE, BALL.MATCHCODE, BALL.TEAMCODE, BALL.INNINGSNO, BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT, BALL.SESSIONNO, BALL.STRIKERCODE, BALL.NONSTRIKERCODE, BALL.BOWLERCODE, BALL.WICKETKEEPERCODE, BALL.UMPIRE1CODE, BALL.UMPIRE2CODE, BALL.ATWOROTW, BALL.BOWLINGEND, BALL.BOWLTYPE AS BOWLTYPECODE, BT.BOWLTYPE, BT.BOWLERTYPE, BALL.SHOTTYPE AS SHOTCODE, ST.SHOTNAME, ST.SHOTTYPE, BALL.SHOTTYPECATEGORY, BALL.ISLEGALBALL, BALL.ISFOUR, BALL.ISSIX, BALL.RUNS, BALL.OVERTHROW, BALL.TOTALRUNS, BALL.WIDE, BALL.NOBALL, BALL.BYES, BALL.LEGBYES, BALL.PENALTY, BALL.TOTALEXTRAS, BALL.GRANDTOTAL, BALL.RBW, BALL.PMLINECODE, BALL.PMLENGTHCODE, BALL.PMSTRIKEPOINT,BALL.PMSTRIKEPOINTLINECODE, BALL.PMX1, BALL.PMY1, BALL.PMX2, BALL.PMY2, BALL.PMX3, BALL.PMY3, BALL.WWREGION, MD.METASUBCODEDESCRIPTION AS REGIONNAME,  BALL.WWX1, BALL.WWY1, BALL.WWX2, BALL.WWY2, BALL.BALLDURATION, BALL.ISAPPEAL, BALL.ISBEATEN, BALL.ISUNCOMFORT,BALL.UNCOMFORTCLASSIFCATION, BALL.ISWTB, BALL.ISRELEASESHOT, BALL.MARKEDFOREDIT,  BALL.REMARKS,MA.METASUBCODEDESCRIPTION AS BALLSPEED,MA.METADATATYPECODE AS BALLSPEEDTYPE,MA.METASUBCODE AS BALLSPEEDCODE,UN.METASUBCODEDESCRIPTION AS UNCOMFORTCLASSIFICATION,UN.METADATATYPECODE AS UNCOMFORTCLASSIFICATIONCODE,UN.METASUBCODE AS UNCOMFORTCLASSIFICATIONSUBCODE FROM BALLEVENTS BALL LEFT JOIN METADATA MD ON BALL.WWREGION = MD.METASUBCODE  LEFT JOIN BOWLTYPE BT ON BALL.BOWLTYPE = BT.BOWLTYPECODE LEFT JOIN SHOTTYPE ST ON BALL.SHOTTYPE = ST.SHOTCODE LEFT JOIN METADATA MA  ON MA.METASUBCODE = BALL.BALLSPEED LEFT JOIN METADATA UN ON BALL.UNCOMFORTCLASSIFCATION = UN.METASUBCODE  WHERE BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,LASTBALLCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetBallDetailsForBallEventsBE *record=[[GetBallDetailsForBallEventsBE alloc]init];
                record.BALLCODE=[self getValueByNull:statement :0];
                
                record.COMPETITIONCODE =[self getValueByNull:statement :1];
                
                record.MATCHCODE=[self getValueByNull:statement :2];
                record.TEAMCODE=[self getValueByNull:statement :3];
                record.INNINGSNO=[self getValueByNull:statement :4];
                record.OVERNO=[self getValueByNull:statement :5];
                record.BALLNO=[self getValueByNull:statement :6];
                record.BALLCOUNT=[self getValueByNull:statement :7];
                record.SESSIONNO=[self getValueByNull:statement :8];
                record.STRIKERCODE =[self getValueByNull:statement :9];
                record.NONSTRIKERCODE  =[self getValueByNull:statement :10];
                record.BOWLERCODE        =[self getValueByNull:statement :11];
                record.WICKETKEEPERCODE  =[self getValueByNull:statement :12];
                record.UMPIRE1CODE       =[self getValueByNull:statement :13];
                record.UMPIRE2CODE       =[self getValueByNull:statement :14];
                record.ATWOROTW          =[self getValueByNull:statement :15];
                record.BOWLINGEND        =[self getValueByNull:statement :16];
                record.BOWLTYPECODE=[self getValueByNull:statement :17];
                record.BOWLTYPE             =[self getValueByNull:statement :18];
                record.BOWLERTYPE           =[self getValueByNull:statement :19];
                record.SHOTCODE    =[self getValueByNull:statement :20];
                record.SHOTNAME             =[self getValueByNull:statement :21];
                record.SHOTTYPE             =[self getValueByNull:statement :22];
                record.SHOTTYPECATEGORY        =[self getValueByNull:statement :23];
                record.ISLEGALBALL   =[self getValueByNull:statement :24];
                record.ISFOUR        =[self getValueByNull:statement :25];
                record.ISSIX         =[self getValueByNull:statement :26];
                record.RUNS         =[self getValueByNull:statement :27];
                record.OVERTHROW     =[self getValueByNull:statement :28];
                record.TOTALRUNS     =[self getValueByNull:statement :29];
                record.WIDE          =[self getValueByNull:statement :30];
                record.NOBALL        =[self getValueByNull:statement :31];
                record.BYES          =[self getValueByNull:statement :32];
                record.LEGBYES       =[self getValueByNull:statement :33];
                record.PENALTY       =[self getValueByNull:statement :34];
                record.TOTALEXTRAS   =[self getValueByNull:statement :35];
                record.GRANDTOTAL    =[self getValueByNull:statement :36];
                record.RBW           =[self getValueByNull:statement :37];
                record.PMLINECODE   =[self getValueByNull:statement :38];
                record.PMLENGTHCODE  =[self getValueByNull:statement :39];
                record.PMSTRIKEPOINT =[self getValueByNull:statement :40];
                record.PMSTRIKEPOINTLINECODE   =[self getValueByNull:statement :41];
                
                record.PMX1                    =[self getValueByNull:statement :42];
                record.PMY1                    =[self getValueByNull:statement :43];
                record.PMX2 = [Utitliy getPitchMapXAxisForDevice:[self getValueByNull:statement :44]];
                record.PMY2 = [Utitliy getPitchMapYAxisForDevice:[self getValueByNull:statement :45]];

                record.PMX3                    =[self getValueByNull:statement :46];
                record.PMY3                    =[self getValueByNull:statement :47];
                record.WWREGION                =[self getValueByNull:statement :48];
                record.REGIONNAME              =[self getValueByNull:statement :49];
                
                record.WWX1                    =[Utitliy getWagonWheelXAxisForDevice:[self getValueByNull:statement :50]];
                record.WWY1                    =[Utitliy getWagonWheelYAxisForDevice:[self getValueByNull:statement :51]];
                record.WWX2                    =[Utitliy getWagonWheelXAxisForDevice:[self getValueByNull:statement :52]];
                record.WWY2                    =[Utitliy getWagonWheelYAxisForDevice:[self getValueByNull:statement :53]];

//                
//                record.WWX1                    =[self getValueByNull:statement :50];
//                record.WWY1                    =[self getValueByNull:statement :51];
//                record.WWX2                    =[self getValueByNull:statement :52];
//                record.WWY2                    =[self getValueByNull:statement :53];
                record.BALLDURATION            =[self getValueByNull:statement :54];
                record.ISAPPEAL                =[self getValueByNull:statement :55];
                record.ISBEATEN                =[self getValueByNull:statement :56];
                record.ISUNCOMFORT             =[self getValueByNull:statement :57];
                record.UNCOMFORTCLASSIFCATION  =[self getValueByNull:statement :58];
                record.ISWTB                   =[self getValueByNull:statement :59];
                record.ISRELEASESHOT           =[self getValueByNull:statement :60];
                record.MARKEDFOREDIT           =[self getValueByNull:statement :61];
                record.REMARKS                 =[self getValueByNull:statement :62];
                record.BALLSPEED               =[self getValueByNull:statement :63];
                record.BALLSPEEDTYPE           =[self getValueByNull:statement :64];
                record.BALLSPEEDCODE           =[self getValueByNull:statement :65];
                record.UNCOMFORTCLASSIFICATION =[self getValueByNull:statement :66];
                record.UNCOMFORTCLASSIFICATIONCODE    =[self getValueByNull:statement :67];
                record.UNCOMFORTCLASSIFICATIONSUBCODE =[self getValueByNull:statement :68];
                
                [GetBallDetailsForBallEventsArray addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBallDetailsForBallEventsArray;
}

                         @end
