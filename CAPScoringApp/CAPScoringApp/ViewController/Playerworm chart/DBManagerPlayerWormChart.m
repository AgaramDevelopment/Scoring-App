//
//  DBManagerPlayerWormChart.m
//  CAPScoringApp
//
//  Created by Raja sssss on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerPlayerWormChart.h"
#import "Utitliy.h"
#import "PlayerWormChartRecords.h"
@implementation DBManagerPlayerWormChart

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


-(NSString *) fetchMaxInnsNo:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSString *count = @"0";
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(INNINGSNO),0)  FROM BALLEVENTS WHERE MATCHCODE= '%@'",MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
    }
    
}

-(NSString *) FetchMinBatNo:(NSString*) MATCHCODE :(NSInteger )ICOUNT{
    
    @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT MIN(PLAYINGORDER) AS MINBATNO FROM (SELECT  MTP.PLAYINGORDER FROM BALLEVENTS  BE INNER JOIN MATCHTEAMPLAYERDETAILS MTP ON MTP.PLAYERCODE=BE.STRIKERCODE AND MTP.MATCHCODE=BE.MATCHCODE WHERE    BE.MATCHCODE='%@' AND INNINGSNO='%ld' GROUP BY   BE.STRIKERCODE,MTP.PLAYINGORDER)",MATCHCODE,(long)ICOUNT];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
     
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
    }
}

-(NSString *) FetchTeamCode:(NSString*)COMPETITIONCODE : (NSString*) MATCHCODE :(NSInteger )ICOUNT{
    
    @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT BATTINGTEAMCODE FROM INNINGSEVENTS  WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%ld'",COMPETITIONCODE,MATCHCODE,(long)ICOUNT];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
    }
}

-(NSString *) FetchTeamCount:(NSString*)TEAMCODE : (NSString*) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT  MAX(MTPLAY.PLAYINGORDER) AS ROWORDER FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MTPLAY ON MTPLAY.MATCHCODE = MR.MATCHCODE AND MTPLAY.TEAMCODE = '%@' WHERE MR.MATCHCODE = '%@'",TEAMCODE,MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
    }
}


-(NSString *) FetchStrikerCode:(NSString*)MATCHCODE : (NSInteger ) ICOUNT : (NSInteger) LOOPCOUNT{
    
    @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT BE.STRIKERCODE FROM BALLEVENTS  BE INNER JOIN MATCHTEAMPLAYERDETAILS MTP ON MTP.PLAYERCODE=BE.STRIKERCODE AND MTP.MATCHCODE=BE.MATCHCODE WHERE   BE.MATCHCODE='%@' AND INNINGSNO='%ld' AND CAST (MTP.PLAYINGORDER AS NVARCHAR)= '%ld' GROUP BY BE.STRIKERCODE,MTP.PLAYINGORDER",MATCHCODE,(long)ICOUNT,(long)LOOPCOUNT];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
    
}
}




-(NSMutableArray *) fetchMinAndMaxOver:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE
{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *InningsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MIN(OVERNO) ,MAX(OVERNO) FROM BALLEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%ld' AND ((STRIKERCODE='%@' ) OR (NONSTRIKERCODE = '%@'));",COMPETITIONCODE,MATCHCODE,(long)ICOUNT,STRIKERCODE,STRIKERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                PlayerWormChartRecords *record=[[PlayerWormChartRecords alloc]init];
                
                record.MINOVERSTRIKER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MAXOVERSTRIKER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [InningsArray addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return InningsArray;
}
}


-(NSMutableArray *) fetchMinAndMaxOverNotEqual:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE
{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *InningsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MIN(OVERNO) ,MAX(OVERNO) FROM BALLEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%ld' AND NONSTRIKERCODE= '%@');",COMPETITIONCODE,MATCHCODE,(long)ICOUNT,STRIKERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                PlayerWormChartRecords *record=[[PlayerWormChartRecords alloc]init];
                
                record.MINOVERSTRIKER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MAXOVERSTRIKER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [InningsArray addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return InningsArray;
}
}


-(NSString *) FetchMinBall:(NSString*) COMPETITIONCODE : (NSString*) MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MINOVERSTRIKER{
    
 @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT MIN(BALLNO)  FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%ld' AND ((STRIKERCODE='%@') OR (NONSTRIKERCODE = '%@')) AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,(long)ICOUNT,STRIKERCODE,STRIKERCODE,MINOVERSTRIKER];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
 }
}

-(NSString *) FetchMinBallEquals:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MINOVERSTRIKER{
 @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT MIN(BALLNO)  FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%ld' AND NONSTRIKERCODE = '%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,(long)ICOUNT,STRIKERCODE,MINOVERSTRIKER];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
 }
}


-(NSString *) FetchMaxBall :(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MAXOVERSTRIKER{
  @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT MAX(BALLNO)  FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%ld' AND ((STRIKERCODE='%@') OR (NONSTRIKERCODE = '%@')) AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,(long)ICOUNT,STRIKERCODE,STRIKERCODE,MAXOVERSTRIKER];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
  }
}


-(NSString *) FetchMaxBallEquals:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSInteger ) ICOUNT : (NSString*) STRIKERCODE : (NSString *) MAXOVERSTRIKER{
 @synchronized ([Utitliy syncId])  {
    NSString *count = [[NSString alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT MAX(BALLNO)  FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%ld' AND NONSTRIKERCODE = '%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,(long)ICOUNT,STRIKERCODE,MAXOVERSTRIKER];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
    
}
}




-(NSMutableArray *) fetchPlayerWormdetails:(NSString*) COMPETITIONCODE : (NSString*)MATCHCODE :(NSString *) STRIKERCODE
{
    
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *InningsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN COM.MATCHTYPE = 'MSC023' OR COM.MATCHTYPE = 'MSC114' THEN 1 ELSE 0 END ISMULTIDAY,BE.TEAMCODE,TM.TEAMNAME,BE.INNINGSNO,BE.OVERNO AS ACTUALOVERS,CAST(BE.OVERNO AS NVARCHAR(10))||'.'||CAST(BE.BALLNO AS NVARCHAR(10)) AS OVERBYOVER,BE.BALLNO,BE.BALLCOUNT AS BALLCOUNT,IFNULL(MAXOVER.MAXBALLCOUNT,0) AS MAXBALLCOUNT,'%@' STRIKERCODE,PM.PLAYERNAME STRIKERNAME,BE.BOWLERCODE,BWLC.PLAYERNAME BOWLERNAME,IFNULL(WE.WICKETNO,0) AS WICKETNO,BE.BALLCODE,CASE WE.WICKETTYPE WHEN 'MSC095' THEN 'c ' || FLDRC.PLAYERNAME || ' b ' || BWLC.PLAYERNAME WHEN 'MSC096' THEN 'b ' || BWLC.PLAYERNAME WHEN 'MSC097' THEN 'run out ' || FLDRC.PLAYERNAME WHEN 'MSC104' THEN 'st ' || FLDRC.PLAYERNAME || ' b '|| BWLC.PLAYERNAME WHEN 'MSC098' THEN 'lbw ' || BWLC.PLAYERNAME WHEN 'MSC099' THEN 'hit wicket' ||' '|| BWLC.PLAYERNAME WHEN 'MSC100' THEN 'Handled the ball' WHEN 'MSC105' THEN 'c & b' ||' '|| BWLC.PLAYERNAME WHEN 'MSC101' THEN 'Timed Out' WHEN 'MSC102' THEN 'Retired Hurt' WHEN 'MSC103' THEN 'Hitting Twice' WHEN 'MSC107' THEN 'Mankading' WHEN 'MSC108' THEN 'Retired Out' WHEN 'MSC106' THEN 'Obstructing the field' WHEN 'MSC133' THEN 'Absent Hurt' ELSE 'Not Out' END AS WICKETDESCRIPTION, PMWIC.PLAYERNAME WICKETPLAYR, SUM(BS.RUNS)AS STRIKERRUNS, 0 AS BOWLERRUNS FROM       BALLEVENTS BE LEFT JOIN BALLEVENTS BS  ON BS.COMPETITIONCODE= '%@' AND BS.MATCHCODE='%@'AND (BS.STRIKERCODE='%@') AND CAST( (BS.OVERNO)||'.'||(BS.BALLNO) AS DECIMAL) <= CAST( (BE.OVERNO)||'.'||(BE.BALLNO)  AS DECIMAL) LEFT JOIN  WICKETEVENTS WE ON  WE.BALLCODE = BE.BALLCODE AND WE.WICKETTYPE NOT IN ('MSC102') AND WE.WICKETPLAYER= '%@' LEFT JOIN (SELECT BE.COMPETITIONCODE,BE.MATCHCODE,BE.INNINGSNO,MAX(BE.OVERNO) AS MAXOVER,MAX(BE.BALLNO) AS MAXBALLNO, (SELECT MAX(BS.BALLCOUNT) FROM BALLEVENTS BS WHERE BS.MATCHCODE=BE.MATCHCODE AND BS.INNINGSNO=BE.INNINGSNO AND BS.OVERNO=MAX(BE.OVERNO) AND BS.BALLNO=MAX(BE.BALLNO))AS MAXBALLCOUNT FROM  BALLEVENTS BE WHERE BE.MATCHCODE='%@' GROUP BY COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO) MAXOVER ON MAXOVER.INNINGSNO=BE.INNINGSNO AND MAXOVER.MAXOVER=BE.OVERNO AND MAXOVER.MAXBALLNO=BE.BALLNO AND MAXOVER.MAXBALLCOUNT=BE.BALLCOUNT INNER JOIN COMPETITION COM ON COM.COMPETITIONCODE=BE.COMPETITIONCODE AND COM.RECORDSTATUS='MSC001' INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE  AND TM.RECORDSTATUS='MSC001' INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE= '%@' LEFT JOIN PLAYERMASTER PMWIC ON WE.WICKETPLAYER=PMWIC.PLAYERCODE INNER JOIN PLAYERMASTER BMC  ON BMC.PLAYERCODE = BE.STRIKERCODE LEFT JOIN PLAYERMASTER BWLC   ON BWLC.PLAYERCODE = BE.BOWLERCODE LEFT JOIN PLAYERMASTER FLDRC   ON FLDRC.PLAYERCODE = WE.FIELDINGPLAYER LEFT JOIN METADATA MDWT   ON WE.WICKETTYPE = MDWT.METASUBCODE WHERE ('%@'= '' OR BE.COMPETITIONCODE = '%@') AND ('%@' = '' OR BE.MATCHCODE = '%@') AND ('%@' = '' OR BE.STRIKERCODE = '%@') GROUP BY  COM.MATCHTYPE, BE.TEAMCODE, TM.TEAMNAME, BE.INNINGSNO, BE.OVERNO, BE.BALLNO, BE.BALLCOUNT,WE.WICKETTYPE , FLDRC.PLAYERNAME, IFNULL(MAXOVER.MAXBALLCOUNT,0), PM.PLAYERNAME, IFNULL(WE.WICKETNO,0),BE.BOWLERCODE,BWLC.PLAYERNAME ,PMWIC.PLAYERNAME ORDER BY BE.OVERNO,BE.BALLNO,BE.BALLCOUNT;",STRIKERCODE , COMPETITIONCODE, MATCHCODE,STRIKERCODE,STRIKERCODE,MATCHCODE,STRIKERCODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,STRIKERCODE,STRIKERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                PlayerWormChartRecords *record=[[PlayerWormChartRecords alloc]init];
            
                record.ISMULTIDAY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];

                record.ACTUALOVER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.OVERBYOVER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];

                record.BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.BALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];

                record.MAXBALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];

                record.STRIKERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];

                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];

                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.WICKERDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];

                //record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.WICKETPLAYER=[self getValueByNull:statement :16];

                
                
                record.STRIKERRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                 record.BOWLERRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];

                
                record.XAXISFORSORT = [NSNumber numberWithInt:[NSString stringWithFormat:@"%@%@",record.ACTUALOVER,record.BALLNO].intValue];
                
//                
//                if([record.STRIKERCODE isEqual:@"PYC0000482"]){
//                    NSLog(@"%@, %@",record.OVERBYOVER,record.STRIKERRUNS);
//                }
                
                
                [InningsArray addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return InningsArray;
}
}

@end
