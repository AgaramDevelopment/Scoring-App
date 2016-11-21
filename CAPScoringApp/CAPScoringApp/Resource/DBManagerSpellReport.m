//
//  DBManagerSpellReport.m
//  CAPScoringApp
//
//  Created by APPLE on 19/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerSpellReport.h"
#import <sqlite3.h>
#import "SpellReportRecord.h"


static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";



@implementation DBManagerSpellReport


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


-(NSMutableArray *)getSpellReportDetail:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE:(NSString *)TEAMCODE:(NSString *) INNINGSNO
{
    NSMutableArray * FFactordetail=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"WITH SPELL AS (SELECT BE.BOWLERCODE,BE.INNINGSNO,BE.DAYNO, BE.OVERNO, CASE WHEN (SELECT COUNT(BOWLERCODE) FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = BE.COMPETITIONCODE  AND MATCHCODE = BE.MATCHCODE AND INNINGSNO = BE.INNINGSNO AND OVERNO = BE.OVERNO) > 1 OR (OV.OVERSTATUS = 0) THEN (CASE WHEN COUNT(BE.BALLNO) > 6 THEN 6 ELSE COUNT(BE.BALLNO) END) ELSE 0 END BALLS, SUM(CASE WHEN (BE.RUNS = 0 AND BE.ISLEGALBALL=1)  THEN 1 ELSE 0 END) AS DOTBALLS, SUM(CASE WHEN BE.RUNS = 1  THEN 1 ELSE 0 END) AS ONES, SUM(CASE WHEN BE.RUNS = 2  THEN 1 ELSE 0 END) AS TWOS, SUM(CASE WHEN BE.RUNS = 3  THEN 1 ELSE 0 END) AS THREES, SUM(CASE WHEN (BE.RUNS = 4 AND BE.ISFOUR=1)  THEN 1 ELSE 0 END) AS FOURS, SUM(CASE WHEN (BE.RUNS = 6 AND BE.ISSIX=1)  THEN 1 ELSE 0 END) AS SIXES, SUM(CASE WHEN (BE.ISFOUR=1 OR BE.ISSIX=1 ) AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) AS BOUNDARIES, SUM(CASE WHEN BE.RUNS + (CASE WHEN BYES = 0 AND LEGBYES = 0 THEN OVERTHROW ELSE 0 END) > 0 THEN 1 ELSE 0 END) AS SB, SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 THEN BE.RUNS + OVERTHROW +WIDE+NOBALL ELSE BE.RUNS+WIDE+NOBALL END) AS RUNS, SUM(IFNULL(WE.ISWICKET,0)) WICKETS, 0 SPELLNO, (CASE WHEN BMDN.OVERS IS NOT NULL THEN 1 ELSE 0 END) MAIDEN FROM   BALLEVENTS BE INNER JOIN OVEREVENTS OV ON BE.COMPETITIONCODE = OV.COMPETITIONCODE AND BE.MATCHCODE = OV.MATCHCODE AND BE.INNINGSNO = OV.INNINGSNO AND BE.OVERNO = OV.OVERNO LEFT JOIN BOWLINGMAIDENSUMMARY BMDN ON OV.COMPETITIONCODE = BMDN.COMPETITIONCODE AND OV.MATCHCODE = BMDN.MATCHCODE AND OV.INNINGSNO = BMDN.INNINGSNO AND OV.OVERNO = BMDN.OVERS  LEFT JOIN WICKETEVENTS WE ON WE.BALLCODE = BE.BALLCODE  AND WE.COMPETITIONCODE = BE.COMPETITIONCODE  AND WE.WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')  AND WE.MATCHCODE = BE.MATCHCODE  AND WE.TEAMCODE = BE.TEAMCODE  AND WE.INNINGSNO = BE.INNINGSNO  WHERE ('%@' ='' OR BE.COMPETITIONCODE = '%@') AND ('%@'='' OR BE.MATCHCODE = '%@') AND ('%@'='' OR BE.TEAMCODE ='%@') AND ('%@' =''  OR  BE.INNINGSNO = '%@') GROUP BY BE.COMPETITIONCODE, BE.MATCHCODE, BE.BOWLERCODE, BE.INNINGSNO,BE.DAYNO, BE.OVERNO, OV.OVERSTATUS, BMDN.OVERS) SELECT SPELLECO.BOWLERCODE, SPELLECO.BOWLERNAME, SPELLECO.INNINGSNO, SPELLECO.DAYNO, SPELLECO.SPELL, SPELLECO.OVERS, SPELLECO.DOTBALLS, SPELLECO.ONES, SPELLECO.TWOS, SPELLECO.THREES, SPELLECO.FOURS, SPELLECO.SIXES, SPELLECO.BOUNDARIES, SPELLECO.BOUNDARIESPER, SPELLECO.SB, SPELLECO.RUNS, SPELLECO.RPSS, SPELLECO.WICKETS, SPELLECO.MAIDENS, CAST((CASE WHEN ((substr(SPELLECO.OVERS,2) * 6) + substr(SPELLECO.OVERS,1)) = 0 THEN 0 ELSE ((SPELLECO.RUNS / ((substr(SPELLECO.OVERS,2) * 6) + substr(SPELLECO.OVERS,1))) * 6) END) AS NUMERIC (6,2)) ECONOMY FROM (SELECT SPELLDTLS.BOWLERCODE, PM.PLAYERNAME BOWLERNAME, SPELLDTLS.INNINGSNO,SPELLDTLS.DAYNO, SPELLDTLS.SPELL, SUM(SPELLDTLS.BALLS) BALLS, CASE WHEN (SUM(SPELLDTLS.BALLS) / 6) > 0 THEN (CAST((COUNT(SPELLDTLS.OVERNO)-1) AS NVARCHAR) + '.' + CAST(CAST(SUM(SPELLDTLS.BALLS) / 6 AS INTEGER) AS NVARCHAR)) ELSE CAST(COUNT(SPELLDTLS.OVERNO) AS NVARCHAR)+ '.0' END OVERS, SUM(SPELLDTLS.DOTBALLS) DOTBALLS, SUM(ONES) ONES, SUM(TWOS) TWOS, SUM(THREES) THREES, SUM(SPELLDTLS.FOURS) FOURS, SUM(SPELLDTLS.SIXES) SIXES, SUM(BOUNDARIES) BOUNDARIES, CASE WHEN  SUM(SPELLDTLS.RUNS)=0 THEN 0 ELSE CAST((CAST (SUM(BOUNDARIES) AS FLOAT)/CAST (SUM(SPELLDTLS.RUNS) AS FLOAT)*100) AS NUMERIC(5,2)) END BOUNDARIESPER, SUM(SB) SB, SUM(SPELLDTLS.RUNS) RUNS, CAST(CAST((CASE WHEN SUM(SB) = 0 THEN 0 ELSE (SUM(SPELLDTLS.RUNS)/SUM(SB)) END) AS NUMERIC(5,2)) AS NVARCHAR) AS RPSS, SUM(SPELLDTLS.WICKETS) WICKETS, SUM(SPELLDTLS.MAIDEN) MAIDENS  FROM (SELECT A.BOWLERCODE, A.INNINGSNO,A.DAYNO, (A.OVERNO+1) OVERNO, SUM(B.SPELLNO) SPELL, A.BALLS, A.DOTBALLS, A.ONES, A.TWOS, A.THREES, A.FOURS, A.SIXES, A.BOUNDARIES, A.SB, A.RUNS, A.WICKETS, A.MAIDEN FROM (SELECT A.INNINGSNO,A.DAYNO, A.BOWLERCODE, A.OVERNO,(CASE WHEN (A.OVERNO - MAX(B.OVERNO)) IN (NULL, 2) THEN 0 ELSE 1 END) SPELLNO , A.BALLS,A.DOTBALLS, A.ONES, A.TWOS, A.THREES, A.FOURS, A.SIXES, A.BOUNDARIES, A.SB, A.RUNS, A.WICKETS, A.MAIDEN FROM SPELL A LEFT JOIN SPELL B ON B.OVERNO < A.OVERNO AND B.BOWLERCODE = A.BOWLERCODE  AND B.INNINGSNO = A.INNINGSNO GROUP BY A.BOWLERCODE, A.INNINGSNO,A.DAYNO, A.OVERNO, A.BALLS, A.DOTBALLS,A.ONES, A.TWOS, A.THREES, A.FOURS, A.SIXES, A.BOUNDARIES, A.SB, A.RUNS, A.WICKETS, A.MAIDEN) A INNER JOIN(SELECT A.INNINGSNO,A.DAYNO,A.BOWLERCODE, A.OVERNO,CASE WHEN (A.OVERNO - MAX(B.OVERNO)) IN (NULL, 2) THEN 0 ELSE 1 END SPELLNO, A.BALLS,A.DOTBALLS, A.ONES, A.TWOS, A.THREES, A.FOURS, A.SIXES, A.BOUNDARIES, A.SB, A.RUNS, A.WICKETS, A.MAIDEN FROM SPELL A  LEFT JOIN SPELL B ON B.OVERNO < A.OVERNO AND B.BOWLERCODE = A.BOWLERCODE AND B.INNINGSNO = A.INNINGSNO GROUP BY A.BOWLERCODE, A.INNINGSNO,A.DAYNO, A.OVERNO, A.BALLS, A.DOTBALLS,A.ONES, A.TWOS, A.THREES, A.FOURS, A.SIXES, A.BOUNDARIES, A.SB, A.RUNS, A.WICKETS, A.MAIDEN) B ON A.BOWLERCODE = B.BOWLERCODE AND A.INNINGSNO = B.INNINGSNO AND A.OVERNO >= B.OVERNO GROUP BY A.BOWLERCODE, A.INNINGSNO,A.DAYNO, A.OVERNO, A.BALLS, A.SPELLNO,A.DOTBALLS, A.ONES, A.TWOS, A.THREES, A.FOURS, A.SIXES, A.BOUNDARIES, A.SB, A.RUNS, A.WICKETS, A.MAIDEN) SPELLDTLS INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE = SPELLDTLS.BOWLERCODE GROUP BY SPELLDTLS.BOWLERCODE, PM.PLAYERNAME,SPELLDTLS.INNINGSNO,SPELLDTLS.DAYNO, SPELLDTLS.SPELL) SPELLECO ORDER BY SPELLECO.INNINGSNO, SPELLECO.DAYNO, SPELLECO.SPELL",COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                SpellReportRecord * record=[[SpellReportRecord alloc]init];
                
                record.Bowlercode=[self getValueByNull:statement :0];
                
                record.BowlerName=[self getValueByNull:statement :1];
                
                record.inningsno =[self getValueByNull:statement :2];
                
                record.Dayno=[self getValueByNull:statement :3];
                
                record.Spell=[self getValueByNull:statement :4];
                
                record.Overs=[self getValueByNull:statement :5];
                
                record.DotBall=[self getValueByNull:statement :6];

                record.ones=[self getValueByNull:statement :7];

                record.Twos=[self getValueByNull:statement :8];

                record.Threes=[self getValueByNull:statement :9];

                record.Fours=[self getValueByNull:statement :10];

                record.Sixs=[self getValueByNull:statement :11];
                
                record.Boundaries=[self getValueByNull:statement :12];

                record.Boundariesper=[self getValueByNull:statement :13];

                record.SB=[self getValueByNull:statement :14];

                record.Runs=[self getValueByNull:statement :15];

                record.RPSS=[self getValueByNull:statement :16];

                record.Wickets=[self getValueByNull:statement :17];

                record.Maidens=[self getValueByNull:statement :18];

                record.Economy=[self getValueByNull:statement :19];

                [FFactordetail addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return FFactordetail;

}
@end
