//
//  DBManagerLastBowler.m
//  CAPScoringApp
//
//  Created by APPLE on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerLastBowler.h"
#import "LastBolwerDetailRecord.h"

@implementation DBManagerLastBowler
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



//LASTBOWLER DETAILS
-(NSString*) GetBowlerCodeForBowlerDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@' AND BALLCOUNT='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLCOUNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BOWLERCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);

            
        }
        sqlite3_close(dataBase);
    }
    return @"";
}

-(NSString*) GetTopBowlerCodeForBowlerDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT:(NSString*) CURRENTBOWLERCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  BOWLERCODE FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=BE.BOWLERCODE WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND CAST(CAST(OVERNO AS NVARCHAR(3))||'.'||CAST(BALLNO AS NVARCHAR(3))+CAST(BALLCOUNT AS NVARCHAR(3)) AS FLOAT)< CAST(CAST('%@' AS NVARCHAR(3))||'.'||CAST('%@' AS NVARCHAR(3))+CAST('%@' AS NVARCHAR(3)) AS FLOAT)  AND ('%@' IS NULL OR BE.BOWLERCODE !='%@')ORDER BY OVERNO DESC,BALLNO DESC,BALLCOUNT DESC LIMIT 1",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT,CURRENTBOWLERCODE,CURRENTBOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLERCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);

            
        }
                    sqlite3_close(dataBase);
        
    }
   
    return @"";
}


-(NSNumber*) GetWicketNoForBowlerDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT:(NSString*) PREVIOUSBOWLERCODE{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {

    NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(WKT.WICKETNO) AS WICKETS FROM BALLEVENTS BALL INNER JOIN WICKETEVENTS WKT ON WKT.BALLCODE = BALL.BALLCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@'  AND CAST(CAST(OVERNO AS NVARCHAR(3))||'.'||CAST(BALLNO AS NVARCHAR(3))||CAST(BALLCOUNT AS NVARCHAR(3)) AS FLOAT)< CAST(CAST('%@' AS NVARCHAR(3))||'.'||CAST('%@' AS NVARCHAR(3))||CAST('%@' AS NVARCHAR(3)) AS FLOAT) AND BALL.BOWLERCODE = '%@' AND WKT.WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT,PREVIOUSBOWLERCODE];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *WICKETS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
             sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return WICKETS;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
}

-(NSNumber*) GetLastBowlerOverNoForBallEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PREVIOUSBOWLERCODE:(NSNumber*) OVERNO{
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;

    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) AS LASTBOWLEROVERNO FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND BOWLERCODE = '%@' AND OVERNO <= %@",COMPETITIONCODE,MATCHCODE,INNINGSNO,PREVIOUSBOWLERCODE,OVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *LASTBOWLEROVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return LASTBOWLEROVERNO;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
}

-(NSNumber*) GetBatTeamOversForOverEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSNumber*) OVERNO{
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) AS BATTEAMOVERS FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO <= '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BATTEAMOVERS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BATTEAMOVERS;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
}

-(NSNumber*) GetBowlerCodeForIsPartialOver:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PREVIOUSBOWLERCODE:(NSNumber*) BATTEAMOVERS{
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN COUNT(BOWLERCODE) > 1 THEN 1 ELSE 0 END AS ISPARTIALOVER FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND OVERNO IN (SELECT OVERNO FROM BOWLEROVERDETAILS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE =  '%@' AND INNINGSNO = %@ AND BOWLERCODE = '%@' AND OVERNO <= %@)AND BOWLERCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,INNINGSNO,PREVIOUSBOWLERCODE,BATTEAMOVERS,PREVIOUSBOWLERCODE];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *ISPARTIALOVER = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return ISPARTIALOVER;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
        
}

-(NSNumber*) GetBowlerSpellForBallEvents:(NSNumber*) V_SPELLNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PREVIOUSBOWLERCODE:(NSNumber*) OVERNO{
    
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(SPELL),0) AS BOWLERSPELL FROM(SELECT BALL.BOWLERCODE AS BOWLERCODE, BALL.OVERNO, IFNULL((SELECT CASE WHEN BALL.OVERNO - MAX(B.OVERNO) > 2 THEN '%@' + 1 ELSE '%@' END FROM BALLEVENTS B WHERE B.COMPETITIONCODE = BALL.COMPETITIONCODE AND B.MATCHCODE = BALL.MATCHCODE AND B.INNINGSNO = BALL.INNINGSNO AND B.BOWLERCODE = BALL.BOWLERCODE AND B.OVERNO < BALL.OVERNO GROUP BY B.COMPETITIONCODE, B.MATCHCODE, B.INNINGSNO, B.BOWLERCODE), 1) SPELL FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@'  AND OVERNO <= '%@' GROUP BY BALL.COMPETITIONCODE, BALL.MATCHCODE, BALL.INNINGSNO, BALL.BOWLERCODE, BALL.OVERNO ) BOWLERSPELL",V_SPELLNO,V_SPELLNO,COMPETITIONCODE,MATCHCODE,INNINGSNO,PREVIOUSBOWLERCODE,OVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BOWLERSPELL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BOWLERSPELL;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    

    sqlite3_close(dataBase);
    }
    return 0;
}

-(NSMutableArray*) GETTOTALBALLSBOWLMAIDENSBOWLERRUNSForLastBowlDetails: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) PREVIOUSBOWLERCODE :(NSNumber*)  OVERNO
{
    NSMutableArray *GetTotalballbowlMaidensBowlerrunsforlastbowldetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT 	IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 THEN 6 ELSE BALLCOUNT END),0) as  TOTALBALLSBOWL ,IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 AND TOTALRUNS = 0 THEN 1 ELSE 0 END),0) as MAIDENS,	    IFNULL(SUM(OE.TOTALRUNS),0) as BOWLERRUNS 	FROM	(		SELECT OE.OVERNO + 1 AS OVERNO, IFNULL(SUM(CASE WHEN BALL.ISLEGALBALL = 1 THEN 1 ELSE 0 END),0) AS BALLCOUNT, OE.OVERSTATUS,		IFNULL(SUM(BALL.TOTALRUNS + CASE WHEN BALL.NOBALL > 0 AND BALL.BYES > 0 THEN 1 WHEN BALL.NOBALL > 0 AND BALL.BYES = 0 THEN BALL.NOBALL ELSE 0 END + BALL.WIDE),0) AS TOTALRUNS		FROM BALLEVENTS BALL		INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE 		AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO		WHERE BALL.COMPETITIONCODE = '%@'		AND BALL.MATCHCODE = '%@'		AND BALL.INNINGSNO = '%@'		AND BALL.BOWLERCODE = '%@'		 AND BALL.OVERNO <= '%@'		GROUP BY BOWLERCODE,OE.OVERNO,OE.OVERSTATUS	)OE", COMPETITIONCODE, MATCHCODE, INNINGSNO, PREVIOUSBOWLERCODE, OVERNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                [GetTotalballbowlMaidensBowlerrunsforlastbowldetails addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                [GetTotalballbowlMaidensBowlerrunsforlastbowldetails addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
                [GetTotalballbowlMaidensBowlerrunsforlastbowldetails addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetTotalballbowlMaidensBowlerrunsforlastbowldetails;
}







-(NSNumber*) GetlastBowlerOverballNoForlastBowlDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) PREVIOUSBOWLERCODE :(NSNumber*) LASTBOWLEROVERNO {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(COUNT(BALLNO),0) as BALLNO 	FROM BALLEVENTS		WHERE COMPETITIONCODE = '%@'		AND MATCHCODE = '%@'		AND INNINGSNO = '%@'		AND BOWLERCODE = '%@'		AND OVERNO = '%@'		AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO,PREVIOUSBOWLERCODE,LASTBOWLEROVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BALLNO;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
}


-(NSNumber*) GetlastBowlerOverballNoWithExtraForlastBowlDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) PREVIOUSBOWLERCODE :(NSNumber*) LASTBOWLEROVERNO {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) as BALLNO 	FROM BALLEVENTS		WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@'	AND INNINGSNO = '%@'		AND BOWLERCODE = '%@'		AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,PREVIOUSBOWLERCODE,LASTBOWLEROVERNO];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BALLNO;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
}



-(NSNumber*) GetlastballCountForlastBowlDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) PREVIOUSBOWLERCODE :(NSNumber*) LASTBOWLEROVERNO :(NSNumber*) LASTBOWLEROVERBALLNOWITHEXTRAS{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) as BALLNO FROM BALLEVENTS	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND INNINGSNO = '%@'	AND BOWLERCODE = '%@'		AND OVERNO = '%@'			AND BALLNO = '%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,PREVIOUSBOWLERCODE,LASTBOWLEROVERNO,LASTBOWLEROVERBALLNOWITHEXTRAS];
    
    stmt=[updateSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            return BALLNO;
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);

    }
    
    sqlite3_close(dataBase);
    }
    return 0;
}


-(NSMutableArray*) GetBallEventForLastBowlerDetails: (NSNumber*)  BOWLERSPELL :(NSNumber*)  BOWLERRUNS :(NSNumber*)  ISPARTIALOVER :(NSNumber*)  TOTALBALLSBOWL : (NSNumber*) MAIDENS :(NSNumber*)  WICKETS:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) INNINGSNO: (NSString*) PREVIOUSBOWLERCODE: (NSNumber*) OVERNO:(NSNumber *)LASTBOWLEROVERBALLNO
{
    NSMutableArray *GetLastBolwerDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE, BOWLERNAME, %@ BOWLERSPELL, %@ AS TOTALRUNS, CASE WHEN %@ > 0 THEN 	(CASE WHEN %@ = 0 THEN 0 ELSE CAST((%@ / 6) AS INT) ||'.'|| CAST((%@ %% 6)AS INT) END) ELSE 		CASE WHEN OVERS!=0 THEN  OVERS ELSE 0 END ||'.'|| %@ 	END AS OVERS, 		'%@' AS MAIDENOVERS, '%@' AS WICKETS, (CASE WHEN '%@' = 0 THEN 0 ELSE ('%@' * 1.0 / '%@'*1.0) * 6 END) AS ECONOMY 		FROM 		( 			SELECT BOWLERCODE,BOWLERNAME,SUM(CASE WHEN OVERSTATUS = 1 THEN 1 ELSE 0 END) OVERS 			FROM 			( 				SELECT BALL.BOWLERCODE AS BOWLERCODE,PM.PLAYERNAME BOWLERNAME,OE.OVERSTATUS 				FROM BALLEVENTS BALL 				INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE  				AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO 				INNER JOIN PLAYERMASTER PM ON BALL.BOWLERCODE = PM.PLAYERCODE 				WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' 				AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' AND BALL.OVERNO <= '%@'  				GROUP BY BALL.BOWLERCODE,PM.PLAYERNAME,OE.OVERNO,OE.OVERSTATUS  			) OE 			GROUP BY BOWLERCODE,BOWLERNAME 		) BOWLDTLS",BOWLERSPELL, BOWLERRUNS, ISPARTIALOVER, TOTALBALLSBOWL, TOTALBALLSBOWL, TOTALBALLSBOWL, LASTBOWLEROVERBALLNO, MAIDENS, WICKETS, TOTALBALLSBOWL, BOWLERRUNS, TOTALBALLSBOWL, COMPETITIONCODE, MATCHCODE, INNINGSNO, PREVIOUSBOWLERCODE, OVERNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                LastBolwerDetailRecord *record=[[LastBolwerDetailRecord alloc]init];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.BOWLERSPELL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.MAIDENOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.ECONOMY=[self getValueByNull:statement: 7];
                
                
                
                
                
                [GetLastBolwerDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetLastBolwerDetails;
}

-(NSNumber*) GetlastOverStatusForlastBowlerDetails:(NSString*) COMPETITIONCODE :(NSString*) MATCHCODE :(NSString*) INNINGSNO :(NSNumber*) LASTBOWLEROVERNO {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  AND INNINGSNO = %@ AND OVERNO = %@ ", COMPETITIONCODE,MATCHCODE,INNINGSNO,LASTBOWLEROVERNO];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return 0;
}
-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}

@end
