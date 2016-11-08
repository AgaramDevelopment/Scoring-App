//
//  DBManagerPlayersKPI.m
//  CAPScoringApp
//
//  Created by Raja sssss on 01/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerPlayersKPI.h"
#import "PlayerKPIRecords.h"
#import "Utitliy.h"

@implementation DBManagerPlayersKPI


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


//Sector Wagon Wheel
-(NSMutableArray *)getBowlingKpi:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)STRIKERCODE:(NSString*)BOWLERCODE

{
    NSMutableArray *bowlerArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
       
    NSString *updateSQL = [NSString stringWithFormat:@"WITH X AS ( SELECT  KPI.BOWLERCODE, KPI.BOWLERNAME,KPI.COMPETITIONCODE,KPI.INNINGSNO, COUNT(KPI.OVERS) MAIDENS, SUM(KPI.RUNS) RUNS, SUM(KPI.BALLS) BALLS, SUM(KPI.ONES) ONES, SUM(KPI.TWOS) TWOS, SUM(KPI.THREES) THREES, SUM(KPI.FOURS) FOURS, SUM(KPI.FIVES) FIVES, SUM(KPI.SIXES) SIXES, SUM(KPI.ISFOUR) ISFOUR, SUM(KPI.ISSIX) ISSIX, SUM(KPI.BOUNDARY4S) BOUNDARY4S, SUM(KPI.BOUNDARY6S) BOUNDARY6S, SUM(KPI.DOTBALL) DOTBALL, SUM(KPI.SB) SB, SUM(KPI.WIDES) WIDES, SUM(KPI.NOBALLS) NOBALLS, SUM(KPI.WICKETS) WICKETS, SUM(KPI.ECONOMYRATE) ECONOMYRATE FROM ( SELECT  BE.BOWLERCODE, PM.PLAYERNAME BOWLERNAME,BE.COMPETITIONCODE,BE.INNINGSNO, BMS.OVERS, SUM(BE.RUNS +WIDE+NOBALL+  (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN (CASE WHEN WIDE >0 THEN 0 ELSE BE.OVERTHROW END )ELSE 0 END))AS RUNS, CAST(SUM(CASE WHEN ISLEGALBALL = 1 THEN 1 ELSE 0 END)  AS NUMERIC(5)) BALLS, SUM(CASE WHEN BE.RUNS + (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) = 1 THEN 1 ELSE 0 END) ONES, SUM(CASE WHEN BE.RUNS + (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) = 2 THEN 1 ELSE 0 END) TWOS, SUM(CASE WHEN BE.RUNS + (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) = 3 THEN 1 ELSE 0 END) THREES, SUM(CASE WHEN BE.RUNS + (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) = 4 AND ISFOUR=0 THEN 1 ELSE 0 END) FOURS, SUM(CASE WHEN BE.RUNS + (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) = 5 THEN 1 ELSE 0 END) FIVES, SUM(CASE WHEN BE.RUNS + (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) = 6 AND ISSIX=0 THEN 1 ELSE 0 END) SIXES, SUM(CASE WHEN BE.ISFOUR = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) ISFOUR, SUM(CASE WHEN BE.ISSIX = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) ISSIX, SUM(CASE WHEN BE.ISFOUR = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY4S, SUM(CASE WHEN BE.ISSIX = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY6S, (SUM(CASE WHEN BE.RUNS + (CASE WHEN BE.BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) = 0 AND BE.ISLEGALBALL = 1 THEN 1 ELSE 0 END)) DOTBALL, SUM(CASE WHEN BE.RUNS + (CASE WHEN BE.BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END) > 0 THEN 1 ELSE 0 END) SB, SUM(CASE WHEN BE.WIDE > 0 THEN 1 ELSE 0 END) WIDES, SUM(CASE WHEN BE.NOBALL > 0 THEN 1 ELSE 0 END) NOBALLS, SUM(CASE WHEN WE.ISWICKET = 1 THEN 1 ELSE 0 END) WICKETS, CAST((SUM(BE.RUNS + (CASE WHEN BYES = 0 AND BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END))*6)/COUNT(BE.BALLCOUNT) AS NUMERIC(8,2)) ECONOMYRATE FROM        BALLEVENTS BE INNER JOIN MATCHREGISTRATION MRM ON MRM.MATCHCODE = BE.MATCHCODE AND MRM.RECORDSTATUS='MSC001' INNER JOIN PLAYERMASTER PM ON BE.BOWLERCODE = PM.PLAYERCODE AND PM.RECORDSTATUS='MSC001' INNER JOIN PLAYERMASTER PM1 ON BE.STRIKERCODE = PM1.PLAYERCODE AND PM1.RECORDSTATUS='MSC001' INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MRM.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001' LEFT JOIN BOWLINGMAIDENSUMMARY BMS ON BMS.COMPETITIONCODE = BE.COMPETITIONCODE AND BMS.MATCHCODE = BE.MATCHCODE AND BMS.INNINGSNO = BE.INNINGSNO AND BMS.OVERS = BE.OVERNO AND BMS.BOWLERCODE = BE.BOWLERCODE LEFT JOIN WICKETEVENTS WE ON WE.BALLCODE = BE.BALLCODE AND WE.COMPETITIONCODE = BE.COMPETITIONCODE AND WE.MATCHCODE = BE.MATCHCODE AND WE.TEAMCODE = BE.TEAMCODE AND WE.INNINGSNO = BE.INNINGSNO AND WE.WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095') WHERE ('%@'='' OR CM.MATCHTYPE = '%@') AND ('%@' = '' OR BE.COMPETITIONCODE = '%@') AND ('%@' = '' OR BE.MATCHCODE = '%@') AND ('%@' = '' OR BE.TEAMCODE = '%@') AND ('%@' = '' OR BE.INNINGSNO = '%@') AND ('%@' = '' OR BE.STRIKERCODE = '%@') AND ('%@' = '' OR BE.BOWLERCODE = '%@') GROUP BY   BE.BOWLERCODE, PM.PLAYERNAME,BE.INNINGSNO,BE.COMPETITIONCODE, BMS.OVERS) KPI GROUP BY KPI.BOWLERCODE, KPI.BOWLERNAME,KPI.COMPETITIONCODE,KPI.INNINGSNO) SELECT KPI.BOWLERCODE BOWLERCODE,BOWLERNAME, KPI.MAIDENS MAIDEN,KPI.RUNS RUNS,KPI.BALLS BALLS,DOTBALL,SB,ONES,TWOS,THREES,KPI.FOURS FOURS,FIVES,KPI.SIXES SIXES,KPI.WIDES WIDES,NOBALL,KPI.WICKETS WICKETS,BOUNDARY4S, BOUNDARY6S,CAST(CAST((CASE WHEN KPI.BALLS = 0 THEN 0 ELSE (KPI.SB/KPI.BALLS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS SBPERCENTAGE ,CAST((CASE WHEN KPI.BALLS=0 THEN 0 ELSE ((KPI.RUNS/KPI.BALLS)*6) END )AS NUMERIC(10,2)) ECONOMYRATE ,CAST((CASE WHEN  KPI.WICKETS=0 THEN 0 ELSE IFNULL(((KPI.BALLS/KPI.WICKETS)),0) END )AS NUMERIC(10,2)) STRIKERATE ,CAST((CASE WHEN KPI.WICKETS=0 THEN 0 ELSE IFNULL(((KPI.RUNS/KPI.WICKETS)),0) END )AS NUMERIC(10,2)) AVERAGE ,CAST(CAST((CASE WHEN KPI.BALLS = 0 THEN 0 ELSE (KPI.DOTBALL/KPI.BALLS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS DOTBALLPERCENTAGE ,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.ONES/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS ONESPERCENTAGE ,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.TWOS/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS TWOSPERCENTAGE ,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.THREES/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS THREESPERCENTAGE ,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.FOURS/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS FOURSPERCENTAGE,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.FIVES/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS FIVESPERCENTAGE ,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.SIXES/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS SIXESPERCENTAGE ,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.BOUNDARY4S * 4/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS BOUNDARY4SPERCENT,CAST(CAST((CASE WHEN KPI.RUNS = 0 THEN 0 ELSE (KPI.BOUNDARY6S * 6/KPI.RUNS)*100 END) AS NUMERIC(8,2))AS NVARCHAR) AS BOUNDARY6SPERCENT,(CAST((CAST(KPI.BALLS AS INT)/6) AS NVARCHAR)||'.'||CAST((CAST(KPI.BALLS AS INT)%%6) AS NVARCHAR))  AS OVERS FROM ( SELECT  X.BOWLERCODE,X.BOWLERNAME, SUM(X.MAIDENS) MAIDENS,SUM((X.RUNS))RUNS,SUM(X.BALLS) AS BALLS,SUM(X.DOTBALL) AS DOTBALL ,SUM(X.SB) AS SB ,SUM(X.ONES) ONES,SUM(X.TWOS) TWOS,SUM(X.THREES)THREES,SUM(X.FOURS)FOURS,SUM(X.FIVES) FIVES,SUM(X.SIXES) SIXES,SUM(X.WIDES) WIDES,SUM(X.NOBALLS) NOBALL ,SUM(IFNULL(X.WICKETS,0))WICKETS,SUM(X.BOUNDARY4S) BOUNDARY4S,SUM(X.BOUNDARY6S) BOUNDARY6S FROM   X GROUP BY X.BOWLERCODE,X.BOWLERNAME) AS KPI",MATCHTYPECODE,MATCHTYPECODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO,STRIKERCODE,STRIKERCODE,BOWLERCODE,BOWLERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                PlayerKPIRecords *record=[[PlayerKPIRecords alloc]init];
                
                
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.MAIDEN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.DOTBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.SB=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.ONES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.TWOS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.THREES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.FIVES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.NOBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.BOUNDARY4S=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.BOUNDARY6S=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.SBPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record.ECONOMYRATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record.AVERAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record.DOTBALLPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record.ONESPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record.TWOSPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                record.THREESPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                record.FOURSPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                record.FIVESPERCENAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                record.SIXESPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                record.BOUNDARY4SPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                record.BOUNDART6SPERCENTAGE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,30)];
                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                
                [bowlerArray addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return bowlerArray;
}


@end
