//
//  DBManagerPartnership.m
//  CAPScoringApp
//
//  Created by APPLE on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerPartnership.h"
#import <sqlite3.h>
#import "PartnershipRecord.h"

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";



@implementation DBManagerPartnership



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


-(NSMutableArray *) getPartnershipdetail :(NSString *) COMPETITIONCODES :(NSString *) MATCHCODES:(NSString *) TEAMCODES :(NSString *) INNINGS
{
    NSMutableArray * partnershipdetail=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"WITH PSHIP AS ( SELECT	STRIKERCODE, NONSTRIKERCODE, (((OVERNO)*6)+BALLNO) BALL,ISWTB, RUNS,OVERNO,BALLNO,TOTALEXTRAS,ISLEGALBALL,WIDE,OVERTHROW,BYES,LEGBYES,NOBALL,CASE WHEN WKT.WICKETTYPE IS NULL THEN 0 ELSE 1 END ISWICKET,PENALTY  FROM	 BALLEVENTS BALL  LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE   AND BALL.MATCHCODE = WKT.MATCHCODE  AND BALL.INNINGSNO = WKT.INNINGSNO  AND BALL.BALLCODE = WKT.BALLCODE 	WHERE   ('%@'='' OR BALL.COMPETITIONCODE ='%@')   AND ('%@'='' OR BALL.MATCHCODE = '%@')    AND   ('%@'='' OR BALL.TEAMCODE ='%@')   AND  ('%@' ='' OR BALL.INNINGSNO  = '%@')) SELECT PSHIPWICKET,STRIKER,NONSTRIKER ,RUNS,BALLS,STRIKER1,NONSTRIKER1,PLAYER1,EXTRAS,PLAYER2,STRIKERBALLS PLAYER1BALLS,NONSTRIKERBALLS PLAYER2BALLS,STARTOVER,ENDOVER,(STRIKER1+' ('+CAST(PLAYER1 AS NVARCHAR)+')' )AS GRIDPLAYER1, (NONSTRIKER1+' ('+CAST(PLAYER2 AS NVARCHAR)+')')AS GRIDPLAYER2,CASE WHEN BALLS!=0 THEN  CAST((RUNS/BALLS)*6 AS NUMERIC(5,2)) ELSE '0.00' END AS RUNRATE,(STRIKER1+' '+CAST(PLAYER1 AS NVARCHAR) +'('+ CAST(STRIKERBALLS AS NVARCHAR)+')') AS CHARTPLAYER1 ,(NONSTRIKER1+' '+CAST(PLAYER2 AS NVARCHAR) +'('+ CAST(NONSTRIKERBALLS AS NVARCHAR)+')') AS CHARTPLAYER2,(CAST((RUNS) AS NVARCHAR) +'('+CAST((BALLS)AS NVARCHAR)+')') CHARTEXTRAS  FROM ( SELECT RUNS,BALLS,CASE WHEN BALLS = 0 THEN 0 ELSE ((RUNS*6)/BALLS) END AS RR,PLAYER1 STRIKER1,PLAYER2  NONSTRIKER1,STARTOVER,ENDOVER,STRIKERBALLS,NONSTRIKERBALLS,STRIKERRUNS PLAYER1,NONSTRIKERRUNS PLAYER2,(STRIKEREXTRAS+NONSTRIKEREXTRAS) AS EXTRAS,STRIKER,NONSTRIKER  , PSHIPWICKET  FROM ( SELECT (STRIKERRUNS+NONSTRIKERRUNS+STRIKEREXTRAS+NONSTRIKEREXTRAS)AS RUNS ,(FINAL.STRIKERBALLS+FINAL.NONSTRIKERBALLS)AS BALLS,PM.PLAYERNAME AS PLAYER1,PM1.PLAYERNAME AS PLAYER2,STARTOVER,TOOVER AS ENDOVER,STRIKERBALLS,NONSTRIKERBALLS,STRIKERRUNS,NONSTRIKERRUNS,STRIKEREXTRAS,NONSTRIKEREXTRAS,STRIKER,NONSTRIKER, PSHIPWICKET FROM  (SELECT STRIKER, NONSTRIKER, SUM(STRIKERBALLS) STRIKERBALLS, SUM(NONSTRIKERBALLS) NONSTRIKERBALLS, SUM(STRIKERRUNS) STRIKERRUNS, SUM(NONSTRIKERRUNS) NONSTRIKERRUNS, SUM(STRIKEREXTRAS) STRIKEREXTRAS, SUM(NONSTRIKEREXTRAS) NONSTRIKEREXTRAS, MIN(FROMOVER) STARTOVER, MAX(TOOVER) TOOVER, SUM(PSHIPWICKET) PSHIPWICKET  FROM ( SELECT CASE WHEN STRKRNO > NSTRKRNO THEN NONSTRIKERCODE ELSE STRIKERCODE END STRIKER, CASE WHEN STRKRNO > NSTRKRNO THEN STRIKERCODE ELSE NONSTRIKERCODE END NONSTRIKER, CASE WHEN STRKRNO > NSTRKRNO THEN 0 ELSE SUM(BALLS) END STRIKERBALLS, CASE WHEN STRKRNO > NSTRKRNO THEN SUM(BALLS) ELSE 0 END NONSTRIKERBALLS, CASE WHEN STRKRNO > NSTRKRNO THEN 0 ELSE SUM(RUNS) END STRIKERRUNS, CASE WHEN STRKRNO > NSTRKRNO THEN SUM(RUNS) ELSE 0 END NONSTRIKERRUNS, CASE WHEN STRKRNO > NSTRKRNO THEN 0 ELSE SUM(EXTRAS) END STRIKEREXTRAS, CASE WHEN STRKRNO > NSTRKRNO THEN SUM(EXTRAS) ELSE 0 END NONSTRIKEREXTRAS, FROMOVER,TOOVER, PSHIPWICKET  FROM (SELECT STRIKERCODE, NONSTRIKERCODE , STRIKERCODE STRKRNO, NONSTRIKERCODE NSTRKRNO, SUM(ISLEGALBALL+NOBALL)BALLS, CASE WHEN (ISLEGALBALL=1) AND (ISLEGALBALL=1 AND (BYES+LEGBYES+WIDE)=0) OR (ISLEGALBALL=0 AND NOBALL=1 )   THEN  SUM(RUNS+CASE WHEN (BYES=0  AND LEGBYES=0 ) THEN  OVERTHROW ELSE 0 END)  ELSE 0  END  AS RUNS, CASE WHEN ISLEGALBALL=0 THEN (CASE WHEN WIDE!=0 THEN  SUM((WIDE)) ELSE SUM((NOBALL+BYES+LEGBYES)) END )  ELSE (CASE WHEN (LEGBYES + BYES)>0 THEN SUM(LEGBYES+BYES) ELSE PENALTY END)   END AS  EXTRAS, MIN(OVERS) FROMOVER, MAX(OVERS) TOOVER,ISLEGALBALL, SUM(PSHIPWICKET) PSHIPWICKET FROM ( SELECT A.STRIKERCODE,A.NONSTRIKERCODE,A.BALL,A.RUNS,A.TOTALEXTRAS,(A.OVERNO||'.'||A.BALLNO) OVERS,A.ISLEGALBALL,A.WIDE,A.OVERTHROW,A.BYES,A.LEGBYES,A.NOBALL, ISWICKET PSHIPWICKET ,PENALTY FROM  PSHIP A) PARTNERSHIP  GROUP BY STRIKERCODE,NONSTRIKERCODE,ISLEGALBALL,WIDE,OVERTHROW,BYES,LEGBYES,NOBALL,RUNS,PENALTY) PRTNRSHIP  GROUP BY STRIKERCODE,NONSTRIKERCODE,STRKRNO,NSTRKRNO, FROMOVER,TOOVER,ISLEGALBALL, PSHIPWICKET	) PARTNERSHIPDTLS  GROUP BY STRIKER, NONSTRIKER)FINAL  INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=FINAL.STRIKER  INNER JOIN PLAYERMASTER PM1 ON PM1.PLAYERCODE=FINAL.NONSTRIKER )FINALSP) PSHIP  ORDER BY STARTOVER ASC;",COMPETITIONCODES,COMPETITIONCODES,MATCHCODES,MATCHCODES,TEAMCODES,TEAMCODES,INNINGS,INNINGS];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                PartnershipRecord *record=[[PartnershipRecord alloc]init];
                
                record.PSHIPWICKET=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.STRIKER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                record.NONSTRIKER =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];

                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];

                record.BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];

                record.STRIKER1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];

                record.NONSTRIKER1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];

                record.PLAYER1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];

                record.EXTRAS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];

                record.PLAYER2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];

                record.PLAYER1BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];

                record.PLAYER2BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];

                record.STARTOVER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];

                record.ENDOVER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];

                record.GRIDPLAYER1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                
                record.GRIDPLAYER2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];

                record.RUNRATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,16)];


                record.CHARTPLAYER1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,17)];

                record.CHARTPLAYER2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,18)];

                record.CHARTEXTRAS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,19)];

                
                [partnershipdetail addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return partnershipdetail;
}


@end
