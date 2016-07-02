//
//  DBManagerEndBall.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerEndBall.h"
#import "UpdateScoreEngineRecord.h"

@implementation DBManagerEndBall

@synthesize BATTINGTEAMCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize BATTEAMSHORTNAME;
@synthesize BOWLTEAMSHORTNAME;
@synthesize BATTEAMNAME;
@synthesize BOWLTEAMNAME;
@synthesize MATCHOVERS;
@synthesize BATTEAMLOGO;
@synthesize BOWLTEAMLOGO;
@synthesize MATCHTYPE;
@synthesize OLDISLEGALBALL;
@synthesize OLDBOWLERCODE;
@synthesize OLDSTRIKERCODE;
@synthesize OLDNONSTRIKERCODE;


//SP_UPDATESCOREBOARD

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


+(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}


+(void) UpdateScoreBoard:(NSString *) BALLCODE:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSNumber*)INNINGSNO :(NSString *)BATSMANCODE:(NSNumber *) ISFOUR:(NSNumber*)ISSIX:(NSNumber*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)ISWICKET :(NSString *)WICKETTYPE:(NSString *)WICKETPLAYER:(NSString*)BOWLERCODE:(NSString*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)WICKETSCORE :(NSNumber *)WIDE:(NSNumber *)NOBALL:(NSNumber*)BYES	:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)ISDELETE :(NSNumber *)ISWICKETUNDO:(NSNumber *)F_ISWICKETCOUNTABLE:(NSNumber*)F_ISWICKET :(NSNumber*)F_WICKETTYPE
{

    NSString* F_STRIKERCODE = [[NSString alloc] init];
    NSString* F_BOWLERCODE = [[NSString alloc] init];
    NSNumber* F_ISLEGALBALL = [[NSNumber alloc] init];
    NSNumber* F_OVERS = [[NSNumber alloc] init];
    NSNumber* F_BALLS = [[NSNumber alloc] init];
    NSNumber* F_RUNS = [[NSNumber alloc] init];
    NSNumber* F_OVERTHROW = [[NSNumber alloc] init];
    NSNumber* F_ISFOUR = [[NSNumber alloc] init];
    NSNumber* F_ISSIX = [[NSNumber alloc] init];
    NSNumber* F_WIDE = [[NSNumber alloc] init];
    NSNumber* F_NOBALL = [[NSNumber alloc] init];
    NSNumber* F_BYES = [[NSNumber alloc] init];
    NSNumber* F_LEGBYES = [[NSNumber alloc] init];
    NSNumber* F_PENALTY = [[NSNumber alloc] init];
    NSNumber* F_WICKETNO = [[NSNumber alloc] init];
    NSString* F_WICKETPLAYER = [[NSString alloc] init];
    NSString* F_FIELDINGPLAYER = [[NSString alloc] init];
    
    [DBManagerEndBall SELECTALLUPSC : COMPETITIONCODE: MATCHCODE: BALLCODE ];
    
    [DBManagerEndBall UPDATEBATTINGSUMMARYUPSC : COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO :F_STRIKERCODE ];
    
    int O_RUNSvalue,N_RUNSvalue;
    
    O_RUNSvalue=F_RUNS.intValue + F_OVERTHROW.intValue + F_BYES.intValue + F_LEGBYES.intValue + F_NOBALL.intValue + F_WIDE.intValue + F_PENALTY.intValue;
    
    N_RUNSvalue= RUNS.intValue + OVERTHROW.intValue + BYES.intValue + LEGBYES.intValue + NOBALL.intValue + WIDE.intValue + PENALTY.intValue;
    
    NSString* O_RUNS = [[NSNumber alloc] init];
    NSString* N_RUNS = [[NSNumber alloc] init];
    
    O_RUNS = [NSString stringWithFormat:@"%d",O_RUNSvalue];
    N_RUNS = [NSString stringWithFormat:@"%d",N_RUNSvalue];
    if(O_RUNS != N_RUNS)
    {
        [DBManagerEndBall UPDATEBATTINGSUMBYINNUPSC : O_RUNS:N_RUNS:COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
    }
    else
    {
        //[DBManagerEndBall UPDATEINNINGSSUMMARYUPSC : COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
        
        [DBManagerEndBall UPDATEBATTINGSUMMARYUPSC:O_RUNS :N_RUNS :COMPETITIONCODE :MATCHCODE :INNINGSNO];
    }
    
    NSNumber* F_BOWLEROVERS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERBALLS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERRUNS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERMAIDENS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERWICKETS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERNOBALLS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERWIDES = [[NSNumber alloc] init];
    NSNumber* F_BOWLERDOTBALLS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERFOURS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERSIXES = [[NSNumber alloc] init];
    
    
    [DBManagerEndBall SELECTINNBOWLEROVERSUPSC : COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO:F_BOWLERCODE ];
    
    
    NSNumber* U_BOWLEROVERS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERPARTIALOVERBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERRUNS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERMAIDENS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERWICKETS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERNOBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERWIDES = [[NSNumber alloc] init];
    NSNumber* U_BOWLERDOTBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERFOURS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERSIXES = [[NSNumber alloc] init];
    NSNumber* BOWLERCOUNT = [[NSNumber alloc] init];
    NSNumber* ISOVERCOMPLETE = [[NSNumber alloc] init];
    
    
    NSString * TEAMCODE;
    NSString *F_OVERNO;
    NSString *OVERS;
    NSString *O_WICKETNO;
    NSString * U_BOWLERCODE;
    ISOVERCOMPLETE = [DBManagerEndBall GETISOVERCOMPLETE : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:F_OVERS ];
    BOWLERCOUNT  = [DBManagerEndBall GETBALLCOUNT : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO ];
    
    NSNumber* ISBALLEXISTS ;
    ISBALLEXISTS = [DBManagerEndBall ISBALLEXISTS : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO];
    NSNumber* ISBOWLERCHANGED;
    ISBOWLERCHANGED = (BOWLERCODE != F_BOWLERCODE) ? @1 : @0;
    
    NSNumber*F_BOWLERPARTIALOVERBALLS;

    if([ISDELETE  isEqual: @1])
    {
        if(ISOVERCOMPLETE == 0 || BOWLERCOUNT > [NSNumber numberWithInt:1])
        {
            U_BOWLERBALLS = ((F_NOBALL == 0) && (F_WIDE == 0) && [BOWLERCOUNT  isEqual: @"1"]) ? [NSNumber numberWithInt:F_BOWLERBALLS.intValue - 1 ]: F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = (F_NOBALL == 0  && F_WIDE == 0 && BOWLERCOUNT > 1) ? ([NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS.intValue - 1]) :[NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS]  ;
        }
        else
        {
            U_BOWLERBALLS = F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = F_BOWLERPARTIALOVERBALLS;
        }
        
        
        U_BOWLEROVERS = ([ISBALLEXISTS  isEqual: @1]) ? F_BOWLEROVERS : ((F_BOWLEROVERS > 0 && [ISOVERCOMPLETE  isEqual: @1]) ? [NSNumber numberWithInt:F_BOWLEROVERS.intValue - 1] : F_BOWLEROVERS);
    }
    else
    {
        if(([ISBOWLERCHANGED  isEqual: @1]) || (([F_ISLEGALBALL  isEqual: @1]) && (NOBALL > 0 || WIDE > 0)))
        {
            U_BOWLERBALLS = ([F_NOBALL  isEqual: @0] && ([F_WIDE  isEqual: @0]) && [BOWLERCOUNT  isEqual: @1] && [ISOVERCOMPLETE  isEqual: @0]) ? ([NSNumber numberWithInt:F_BOWLERBALLS.intValue - 1]): F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = ([F_NOBALL  isEqual:@0] && [F_WIDE  isEqual: @0] && BOWLERCOUNT.intValue > 1)? ([NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS.intValue - 1]) : F_BOWLERPARTIALOVERBALLS ;
        }
        else
        {
            U_BOWLERBALLS = F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = F_BOWLERPARTIALOVERBALLS;
        }
        U_BOWLEROVERS = F_BOWLEROVERS;
    }
    
    U_BOWLERRUNS = ((F_BYES == 0) && (F_LEGBYES == 0))?([NSNumber numberWithInt:F_BOWLERRUNS.intValue -F_RUNS.intValue + F_WIDE.intValue + F_NOBALL.intValue +F_WIDE.intValue > 0]? 0 : F_OVERTHROW ): (([NSNumber numberWithInt:F_BOWLERRUNS.intValue -F_WIDE.intValue +F_NOBALL.intValue]));
    U_BOWLERWICKETS = (F_ISWICKETCOUNTABLE.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERWICKETS.intValue - 1]) : F_BOWLERWICKETS;
    U_BOWLERNOBALLS = ( F_NOBALL.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERNOBALLS.intValue - 1]) : F_BOWLERNOBALLS ;
    U_BOWLERWIDES = (F_WIDE.intValue > 0) ? [NSNumber numberWithInt:F_BOWLERWIDES.intValue - 1]: F_BOWLERWIDES ;
    U_BOWLERDOTBALLS =((F_WIDE.intValue == 0) && (F_NOBALL.intValue == 0) && (F_RUNS.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERDOTBALLS.intValue - 1]) : F_BOWLERDOTBALLS;
    U_BOWLERFOURS = ((F_ISFOUR.intValue == 1) && (F_WIDE.intValue == 0) && (F_BYES.intValue == 0) && (F_LEGBYES.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERFOURS.intValue - 1]):[NSNumber numberWithInt:F_BOWLERFOURS.intValue ] ;
    U_BOWLERSIXES = (F_ISSIX.intValue == 1 && F_WIDE.intValue == 0 && F_BYES.intValue == 0 && F_LEGBYES.intValue == 0) ? [NSNumber numberWithInt:F_BOWLERSIXES.intValue - 1] : F_BOWLERSIXES;
    
    NSNumber* ISMAIDENOVER ;
    NSString *SMAIDENOVER;
    
    if(ISMAIDENOVER.intValue > 5)
    {
        [DBManagerEndBall BALLCOUNTUPSC : COMPETITIONCODE:MATCHCODE:INNINGSNO:F_OVERNO];
    }
    {
        SMAIDENOVER = [DBManagerEndBall SMAIDENOVER : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:@"%@",F_OVERS]:BALLCODE];
        
    }
    ISMAIDENOVER = (RUNS.intValue + (BYES.intValue == 0)  && (LEGBYES.intValue == 0)) ? OVERTHROW : 0; + (WIDE.intValue + NOBALL.intValue) > 0 ? 0 : ISMAIDENOVER ;
    ISMAIDENOVER = ( BOWLERCOUNT.intValue > 1 || ISBOWLERCHANGED.intValue == 1) ? 0 : ISMAIDENOVER ;
    if([DBManagerEndBall GETOVERS : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:OVERS]] !=0)
    {
        if(ISMAIDENOVER == 0)
        {
            [DBManagerEndBall DELBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO];
        }
       // U_BOWLERMAIDENS = F_BOWLERMAIDENS - 1;
        else
        {
            [DBManagerEndBall INSERTBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:BOWLERCODE:F_OVERNO];
            U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue + 1];
        }
        U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue - 1];
    }
    
    //+(NSString*) GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  OVERS;
    
   // [DBManagerEndBall GETOVERS: U_BOWLEROVERS:U_BOWLERBALLS:U_BOWLERPARTIALOVERBALLS:U_BOWLERMAIDENS:U_BOWLERRUNS:U_BOWLERWICKETS:U_BOWLERNOBALLS:U_BOWLERWIDES:U_BOWLERDOTBALLS:U_BOWLERFOURS:U_BOWLERSIXES];
    
    [DBManagerEndBall GETOVERS:COMPETITIONCODE :MATCHCODE :INNINGSNO :OVERS];
    
    
    
    if(ISWICKETUNDO.intValue == 1)
    {
        NSNumber* O_WICKETNO;
        [DBManagerEndBall WICKETNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
    }
    
    [DBManagerEndBall UPDATEBATTINGSUMMARY : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
    [DBManagerEndBall UPDATEBATTINGSUMMARYO_WICNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:O_WICKETNO];
    
    NSNumber* ISWKTDTLSUPDATE ;
    //NSNumber* U_BOWLERCODE ;
    NSNumber* BOWLEROVERBALLCNT ;
    NSNumber * BOWLEROVERBALLCN;
   
    
    ISWKTDTLSUPDATE = ((F_ISWICKET.intValue == 1) || (ISWICKET.intValue == 1)) ? @1 : @0;
    U_BOWLERCODE  = (BOWLERCODE != F_BOWLERCODE )? BOWLERCODE : F_BOWLERCODE ;
    BOWLEROVERBALLCNT = 0;
    
    BOWLEROVERBALLCNT = [DBManagerEndBall BOWLEROVERBALLCNT : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO:F_BOWLERCODE];
    if(ISBOWLERCHANGED.intValue == 1)
    {
        if(![DBManagerEndBall GETBOWLERCODE :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:TEAMCODE:INNINGSNO:OVERNO:BOWLERCODE] )
        {
            //[DBManagerEndBall INSERTBOWLEROVERDETAILS :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:TEAMCODE:INNINGSNO:OVERNO:BOWLERCODE];
            [DBManagerEndBall PARTIALUPDATEBOWLINGSUMMARY :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:BOWLERCODE];
            
        }
        
        if((ISDELETE == 0) || (ISBOWLERCHANGED.intValue == 1))
        {
            //[DBManagerEndBall SP_INSERTSCOREBOARD:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:BOWLINGTEAMCODE:INNINGSNO:BATSMANCODE:ISFOUR:ISSIX:RUNS:OVERTHROW:ISWICKET:WICKETTYPE:WICKETPLAYER:U_BOWLERCODE:OVERNO:BALLNO:WICKETSCORE:WIDE:NOBALL:BYES:LEGBYES:PENALTY:ISWKTDTLSUPDATE:ISBOWLERCHANGED:1:F_ISLEGALBALL];
        }
    }
}






//DBManager.h
//UpdateScoreCard
//DBManager.M
//UpdateScoreCard

+(NSString*) SELECTALLUPSC :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) BALLCODE

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT STRIKERCODE, BOWLERCODE, ISLEGALBALL, OVERNO, BALLNO, RUNS, OVERTHROW, ISFOUR, ISSIX , WIDE, NOBALL, BYES, LEGBYES, PENALTY FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND	MATCHCODE = '%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BALLCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(BOOL)  UPDATEBATTINGSUMMARYUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*) F_STRIKERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET RUNS = CASE WHEN (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (RUNS - (F_RUNS + F_OVERTHROW)) ELSE (RUNS - F_RUNS) END,BALLS = CASE WHEN F_WIDE = 0 THEN (BALLS - 1) ELSE BALLS END,ONES = CASE WHEN (F_RUNS + F_OVERTHROW = 1) AND (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (ONES - 1) ELSE ONES END,TWOS = CASE WHEN (F_RUNS + F_OVERTHROW = 2) AND (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (TWOS - 1) ELSE TWOS END,THREES = CASE WHEN (F_RUNS + F_OVERTHROW = 3) AND (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (THREES - 1) ELSE THREES END,FOURS = CASE WHEN (F_ISFOUR = 1 AND F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (FOURS - 1) ELSE FOURS END,SIXES = CASE WHEN (F_ISSIX = 1 AND F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (SIXES - 1) ELSE SIXES END,DOTBALLS = CASE WHEN (F_RUNS = 0 AND F_WIDE = 0) THEN (DOTBALLS - 1) ELSE DOTBALLS END  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,F_STRIKERCODE];

        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  UPDATEBATTINGSUMBYINNUPSC : (NSNumber*) O_RUNS: (NSNumber*) N_RUNS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETSCORE = WICKETSCORE - (O_RUNS - N_RUNS)	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND CONVERT(NUMERIC(5,2),CONVERT(NVARCHAR,WICKETOVERNO) + '%@' +CONVERT(NVARCHAR,WICKETBALLNO)) >= 	CONVERT(NUMERIC(5,2),CONVERT(NVARCHAR,@F_OVERS) + '%@' +CONVERT(NVARCHAR,F_BALLS))",O_RUNS,N_RUNS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL) UPDATEINNINGSSUMMARYUPSC : (NSNumber*) O_RUNS: (NSNumber*) N_RUNS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET BYES = BYES - (CASE WHEN @F_NOBALL > 0 AND F_BYES > 0 THEN 0 ELSE F_BYES END),LEGBYES = LEGBYES - (CASE WHEN F_NOBALL > 0 AND F_LEGBYES > 0 THEN 0 ELSE F_LEGBYES END),NOBALLS = NOBALLS - (CASE	WHEN F_NOBALL > 0 AND F_BYES > 0 THEN F_NOBALL + F_BYES WHEN F_NOBALL > 0 AND F_LEGBYES > 0 THEN F_NOBALL + F_LEGBYES ELSE F_NOBALL END),WIDES = WIDES - (CASE WHEN F_WIDE > 0 THEN F_WIDE ELSE F_WIDE END),PENALTIES = PENALTIES - F_PENALTY, INNINGSTOTAL = INNINGSTOTAL - (F_RUNS + (CASE WHEN F_BYES > 0 OR F_LEGBYES > 0 OR F_WIDE > 0 THEN 0 ELSE F_OVERTHROW END) + F_BYES + F_LEGBYES + F_NOBALL + F_WIDE + F_PENALTY),INNINGSTOTALWICKETS = CASE WHEN (F_ISWICKET = 1 AND F_WICKETTYPE <> 'MSC102') OR (F_ISWICKET = 0 AND F_WICKETTYPE IN ('MSC107', 'MSC108', 'MSC133')) THEN (INNINGSTOTALWICKETS - 1) ELSE INNINGSTOTALWICKETS END WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}




+(NSString*) SELECTINNBOWLEROVERSUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BOWLINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  F_BOWLERCODE

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT F_BOWLEROVERS = OVERS, F_BOWLERBALLS = BALLS, F_BOWLERPARTIALOVERBALLS = PARTIALOVERBALLS, F_BOWLERRUNS = RUNS, F_BOWLERWICKETS = WICKETS, F_BOWLERMAIDENS = MAIDENS, F_BOWLERNOBALLS = NOBALLS, F_BOWLERWIDES = WIDES, F_BOWLERDOTBALLS = DOTBALLS, F_BOWLERFOURS = FOURS, F_BOWLERSIXES = SIXES FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,F_BOWLERCODE];    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) GETISOVERCOMPLETE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*) F_OVERS
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@' AND INNINGSNO= '%@' AND OVERNO= '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,F_OVERS];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) GETBALLCOUNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BOWLERCODE) AS BOWLERCOUNT FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) ISBALLEXISTS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BOWLERCODE) AS BOWLERCOUNT FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) BALLCOUNTUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  F_OVERS
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) BALLCOUNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO,F_OVERS];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) SMAIDENOVER : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO :(NSString*)  F_OVERS :(NSString*) BALLCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN (IFNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END  AS SMAIDENOVER FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,F_OVERS,BALLCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  OVERS
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT OVERS FROM BOWLINGMAIDENSUMMARY	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND INNINGSNO= '%@'	AND OVERS= '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];

    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(BOOL) DELBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO :(NSString*)  OVERS{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGMAIDENSUMMARY WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@'	AND INNINGSNO= '%@'	AND OVERS= '%@'	",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL)   INSERTBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO : (NSString*) BOWLERCODE:(NSString*)  F_OVERS{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY(COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,OVERS)VALUES('%@','%@','%@','%@','%@',)",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,F_OVERS];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL) UPDATEBOWLINGSUMMARY : (NSString*) U_BOWLEROVERS :(NSString*) U_BOWLERBALLS : (NSString*) U_BOWLERPARTIALOVERBALLS :(NSString*) U_BOWLERMAIDENS :(NSString*) U_BOWLERRUNS :(NSString*) U_BOWLERWICKETS :(NSString*) U_BOWLERNOBALLS :(NSString*) U_BOWLERWIDES :(NSString*) U_BOWLERDOTBALLS :(NSString*) U_BOWLERFOURS :(NSString*) U_BOWLERSIXES :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSString*) BOWLINGTEAMCODE:(NSNumber*)  F_BOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = '%@',BALLS = '%@',PARTIALOVERBALLS = '%@',MAIDENS = '%@',RUNS = '%@',WICKETS = '%@',	NOBALLS = '%@',WIDES = '%@',DOTBALLS = '%@',FOURS = '%@',SIXES = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",U_BOWLEROVERS,U_BOWLERBALLS,U_BOWLERPARTIALOVERBALLS,U_BOWLERMAIDENS,U_BOWLERRUNS,U_BOWLERWICKETS,U_BOWLERNOBALLS,U_BOWLERWIDES,U_BOWLERDOTBALLS,U_BOWLERFOURS,U_BOWLERSIXES,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,F_BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


                                                                   

+(NSString*) WICKETNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*)  WICKETPLAYER
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT WICKETNO FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}



+(BOOL)   UPDATEBATTINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSString*) WICKETPLAYER{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = NULL,WICKETTYPE = NULL,FIELDERCODE = NULL,BOWLERCODE = NULL,WICKETOVERNO = NULL,WICKETBALLNO = NULL 	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)   UPDATEBATTINGSUMMARYO_WICNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSString*) O_WICKETNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = WICKETNO - 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND WICKETNO > '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BATTINGTEAMCODE,INNINGSNO,O_WICKETNO];        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}



+(NSString*) BOWLEROVERBALLCNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSNumber*)  OVERNO:(NSString*) F_BOWLERCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALLCODE) AS BOWLEROVERBALLCNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1 AND BOWLERCODE = @F_BOWLERCODE",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,F_BOWLERCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) GETBOWLERCODE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:  (NSString*) BATTINGTEAMCODE:(NSString*) TEAMCODE :(NSNumber*)  INNINGSNO :(NSNumber*)  OVERNO:(NSString*) BOWLERCODE
{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT BOWLERCODE FROM BOWLEROVERDETAILS WHERE	COMPETITIONCODE = '%@' AND MATCHCODE =	'%@' AND TEAMCODE =	'%@'AND	INNINGSNO =	'%@' AND OVERNO	= '%@' AND BOWLERCODE =	'%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BOWLERCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(BOOL)   INSERTBOWLEROVERDETAILS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSNumber*) OVERNO :(NSString*) BOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLEROVERDETAILS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,STARTTIME,ENDTIME) VALUES('%@','%@','%@','%@','%@','%@',GETDATE(),NULL",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BOWLERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}



+(BOOL)   PARTIALUPDATEBOWLINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) BOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = CASE WHEN OVERS > 0 THEN (OVERS - 1) ELSE OVERS END,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS + (CASE WHEN @BOWLEROVERBALLCNT > 0 THEN  CASE WHEN @F_ISLEGALBALL = 0 THEN (@BOWLEROVERBALLCNT)  ELSE (@BOWLEROVERBALLCNT - 1)  END ELSE 0 END) WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}




//UpdateScoreEngine
+(NSMutableArray*) GetDataFromUpdateScoreEngine: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;
{
    
    
    NSMutableArray *GetDataArrayUpdateScoreEngine=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISLEGALBALL, BOWLERCODE,STRIKERCODE,NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND   MATCHCODE  = '%@' AND TEAMCODE = '%@' AND INNINGSNO  =	'%@' AND BALLCODE  = '%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
       if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
           while(sqlite3_step(statement)==SQLITE_ROW){
           UpdateScoreEngineRecord *record=[[UpdateScoreEngineRecord alloc]init];
        record.OLDISLEGALBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        record.OLDBOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        record.OLDSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        record.OLDNONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        [GetDataArrayUpdateScoreEngine addObject:record];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetDataArrayUpdateScoreEngine;
    }



+(NSString*) GetBowlingTeamCodeUpdateScoreEngine : (NSNumber*) COMPETITIONCODE: (NSNumber*) MATCHCODE:(NSNumber*) BATTINGTEAMCODE:(NSNumber*) MATCHOVERS

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE = '%@'THEN TEAMBCODE ELSE TEAMACODE END), '%@' = MATCHOVERS FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",BATTINGTEAMCODE,MATCHOVERS,COMPETITIONCODE,MATCHCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(NSString*) GetWicCountUpdateScoreEngine: (NSString*)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString *) TEAMCODE : (NSNumber *) INNINGSNO :(NSString*) BALLCODE

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS  F_ISWICKETCOUNTABLE FROM WICKETEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@'	AND ISWICKET = 1 AND WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];

    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}



+(NSString*) GetISWicCountUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS  F_ISWICKET FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(NSString*) GetWicTypeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE

{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS  WICKETTYPE FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(BOOL)  GetBallCodeExistsUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' 	",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}




+(BOOL)   UpdateWicEventsUpdateScoreEngine  : (NSString*) WICKETTYPE:(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT:(NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETTYPE = '%@' ,WICKETPLAYER = '%@',FIELDINGPLAYER = '%@',WICKETEVENT  = '%@' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'  AND OVERNO='%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}






+(NSString*)  GetBallCodeExistsUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(WKT.WICKETNO),0) + 1  FROM WICKETEVENTS WKT WHERE WKT.COMPETITIONCODE= '%@'	AND WKT.MATCHCODE= '%@'	AND WKT.TEAMCODE= '%@'	AND WKT.INNINGSNO= '%@'	",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(BOOL)   InsertWicEventsUpdateScoreEngine :  (NSString*) WICKETNO: (NSString*) BALLCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO:(NSNumber*) ISWICKET:(NSString*) WICKETTYPE :(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO WICKETEVENTS (BALLCODE,COMPETITIONCODE,	MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER,VIDEOLOCATION,WICKETEVENT)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','','%@')",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(NSString*)  GetWicPlayersUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT WICKETPLAYER FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@' AND BALLCODE = '%@' AND ISWICKET = 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(NSString*)  GetWicketNoUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT WICKETNO AS WICKETNOS  FROM WICKETEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}




+(NSString*)  GetBallCodeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}



+(BOOL)   UpdateWicketEveUpdateScoreEngine :  (NSNumber*) WICKETNO: (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETNO = WICKETNO - 1 WHERE WICKETNO > '%@' AND BALLCODE IN  (SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@')", WICKETNO, COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}



+(BOOL) UpdateBattingOrderUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BS SET BS.BATTINGPOSITIONNO = ALLM.ORDR FROM [BATTINGSUMMARY] BS INNER JOIN (SELECT MATCHCODE,INNINGSNO,PLAYERNAME,STRIKERCODE,ROW_NUMBER()OVER(PARTITION BY MATCHCODE,INNINGSNO ORDER BY MIN(ORDR)) ORDR FROM(SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE,MIN(CONVERT( NUMERIC(10,5),(CONVERT(NVARCHAR,BE.OVERNO) || '.' || CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT))))-0.01 ORDR 	FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE	WHERE BE.MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME UNION ALL	SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER1.PLAYERNAME, NONSTRIKERCODE,MIN(CONVERT( NUMERIC(10,5),( CONVERT(NVARCHAR,BE.OVERNO) + '.' + CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT)))) FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER1 ON PLAYERMASTER1.PLAYERCODE = BE.NONSTRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' GROUP BY BE.MATCHCODE,INNINGSNO, PLAYERMASTER1.PLAYERNAME, NONSTRIKERCODE) SAM GROUP BY MATCHCODE,INNINGSNO,PLAYERNAME,STRIKERCODE ) ALLM ON BS.MATCHCODE = ALLM.MATCHCODE AND BS.INNINGSNO = ALLM.INNINGSNO	AND BS.BATSMANCODE = ALLM.STRIKERCODE", MATCHCODE,TEAMCODE,INNINGSNO, MATCHCODE,TEAMCODE,INNINGSNO];

        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

                               

+(BOOL)  UpdateBowlingOrderUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"MERGE BOWLINGSUMMARY BS USING (SELECT COMPETITIONCODE, MATCHCODE,INNINGSNO, BOWLERCODE, OVERNO, BOWLINGPOSITIONNO FROM(SELECT COMPETITIONCODE, MATCHCODE, INNINGSNO, BOWLERCODE, MIN(OVERNO) OVERNO, MIN(BALLNO) BALLNO, MIN(BALLCOUNT) BALLCOUNT,ROW_NUMBER() OVER (PARTITION BY COMPETITIONCODE, MATCHCODE, INNINGSNO ORDER BY COMPETITIONCODE, MATCHCODE, INNINGSNO, MIN(OVERNO), MIN(BALLNO), MIN(BALLCOUNT)) BOWLINGPOSITIONNO	FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' GROUP BY COMPETITIONCODE, MATCHCODE, INNINGSNO, BOWLERCODE) BOWLERORDERDETAILS ) BOD ON BS.COMPETITIONCODE = BOD.COMPETITIONCODE AND BS.MATCHCODE = BOD.MATCHCODE AND BS.INNINGSNO = BOD.INNINGSNO AND BS.BOWLERCODE = BOD.BOWLERCODE 	AND BOD.COMPETITIONCODE = '%@' 	AND BOD.MATCHCODE = '%@' AND BOD.INNINGSNO = '%@' WHEN MATCHED THEN UPDATE SET BS.BOWLINGPOSITIONNO = BOD.BOWLINGPOSITIONNO",COMPETITIONCODE, MATCHCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  DeleteRemoveUnusedBatFBSUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE IN (SELECT BS.BATSMANCODE FROM BATTINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE AND BS.BATTINGTEAMCODE = BE.TEAMCODE AND BS.INNINGSNO = BE.INNINGSNO AND (BS.BATSMANCODE = BE.STRIKERCODE OR BS.BATSMANCODE = BE.NONSTRIKERCODE) WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@' AND BS.BATTINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@' AND BE.STRIKERCODE IS NULL)",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}



+(BOOL)  DeleteRemoveUnusedBowFBSUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*)INNINGSNO : (NSString*) BOWLINGTEAMCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE IN(SELECT BS.BOWLERCODE FROM BOWLINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE	AND BS.INNINGSNO = BE.INNINGSNO AND BS.BOWLERCODE = BE.BOWLERCODE WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@'	AND BS.BOWLINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@' AND BE.BOWLERCODE IS NULL)" ,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)DeleteWicket : (NSString*) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) TEAMCODE :(NSString*)INNINGSNO :(NSString*)BALLCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM WICKETEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE= '%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL)  getInningNo : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT INNINGSNO FROM INNINGSSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  UpdateInningsSummary : (NSString*) PENALTYRUNS:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*)INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET PENALTIES = PENALTIES + '%@', INNINGSTOTAL = INNINGSTOTAL + '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",PENALTYRUNS,PENALTYRUNS,  COMPETITIONCODE, MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}




//PENALTY

+(BOOL)  GetPenaltyBallCodeUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSString*) BALLCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =	'%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}



+(BOOL)  UpdatePenaltyScoreEngine : (NSString*)AWARDEDTOTEAMCODE : (NSString*)PENALTYRUNS: (NSString*)PENALTYTYPECODE: (NSString*) PENALTYREASONCODE : (NSString*)COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BALLCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PENALTYDETAILS SET AWARDEDTOTEAMCODE = '%@',PENALTYRUNS = '%@', PENALTYTYPECODE = '%@', PENALTYREASONCODE = '%@' WHERE COMPETITIONCODE = '%@'AND MATCHCODE = '%@' AND INNINGSNO = '%@'AND BALLCODE = '%@'",AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE,COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(NSString*)  GetMaxidUpdateScoreEngine{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(SUBSTR(PENALTYCODE,4,7)),0)+1 AS MAXID FROM PENALTYDETAILS"];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(BOOL)  InsertPenaltyScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE :(NSString*) PENALTYCODE : (NSString *) AWARDEDTOTEAMCODE : (NSString *) PENALTYRUNS : (NSString *) PENALTYTYPECODE : (NSString *) PENALTYREASONCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO PENALTYDETAILS (COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  UpdateBallPlusoneScoreEngine :(NSString*) BALLCNT: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO:(NSString*)OVERNO:(NSString*) BALLCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLCOUNT = '%@' + BALLCOUNT WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE  = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' AND OVERNO  =	'%@' AND BALLNO = '%@' + 1",BALLCNT, COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(BOOL)  UpdateBallMinusoneScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) INNINGSNO:(NSString*) OVERNO :(NSString*) BALLNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO - 1 WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO  =	'%@' AND BALLNO > '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  LegalBallByOverNoUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) INNINGSNO : (NSString*)OVERNO : (NSString*)BALLNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 WHERE COMPETITIONCODE =	'%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO =	'%@' AND BALLNO > '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  LegalBallCountUpdateScoreEngine : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 , BALLCOUNT = BALLCOUNT - '%@'	WHERE COMPETITIONCODE = '%@' AND MATCHCODE =	'%@' AND TEAMCODE =	'%@' AND INNINGSNO  =	'%@' AND   OVERNO  =	'%@' AND   BALLNO			= '%@' AND BALLCOUNT > '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}
    
    
+(NSString*)  LastBallCodeUPSE  :(NSString*) MATCHCODE:(NSNumber*) INNINGSNO{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BE WHERE (BE.OVERNO + '.' + BE.BALLNO + BE.BALLCOUNT) = (SELECT MAX((BALL.OVERNO + '.' + BALL.BALLNO) + BALL.BALLCOUNT) FROM BALLEVENTS BALL WHERE BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@') AND BE.MATCHCODE = '%@' AND BE.INNINGSNO = '%@'",MATCHCODE,INNINGSNO,MATCHCODE,INNINGSNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*)  OverStatusUPSE : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE:(NSNumber*) INNINGSNO : (NSString*) OVERNO {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(OVERSTATUS,0) FROM OVEREVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND INNINGSNO='%@' 	AND OVERNO ='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(BOOL)  InningEveUpdateScoreEngine : (NSString*) T_STRIKERCODE: (NSString*) T_NONSTRIKERCODE: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE: (NSString *) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS	SET CURRENTSTRIKERCODE = '%@' ,CURRENTNONSTRIKERCODE = '%@',	CURRENTBOWLERCODE = CURRENTBOWLERCODE WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' 	AND TEAMCODE = '%@'	AND INNINGSNO = '%@'",T_STRIKERCODE,T_NONSTRIKERCODE, COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}




+(BOOL)  BallCodeUPSE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, OLDBOWLERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}







+(BOOL)  DeleteOverDetailsUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"	DELETE FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, OLDBOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+(NSString*) OtherOverBallcntUPSE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) AS OtheroverBallcnt FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*)  OtherBowlerUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE{
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT BALLCODE as OtherBowler FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND BOWLERCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, BOWLERCODE];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(NSString*) IsMaidenOverUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN (IFNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END AS IsMaidenOver	FROM BALLEVENTS	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];

    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}


+(NSString*) IsOverCompleteUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO{
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS 	WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' 	AND INNINGSNO='%@'	AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            NSString *isDayNight = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            return isDayNight;
            
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return 0;
    
}

+(BOOL)  BowMadienSummUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) BOWLERCODE :(NSString*) OVERNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY(COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,OVERS)VALUES('%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE, OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  BowSummaryOverplusoneUPSE : (NSString*) OTHERBOWLEROVERBALLCNT : (NSString*) BOWLERMAIDEN : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = OVERS + 1,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS - '%@',MAIDENS = MAIDENS + '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",OTHERBOWLEROVERBALLCNT,BOWLERMAIDEN,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  BowSummaryUPSE : (NSString*)OTHERBOWLEROVERBALLCNT: (NSString*)U_BOWLERMAIDENS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = OVERS,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS - '%@',MAIDENS = MAIDENS + '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",OTHERBOWLEROVERBALLCNT,U_BOWLERMAIDENS,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}

+(BOOL)  UPDATEWICKETOVERNOUPSE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO

{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BS SET WICKETOVERNO=BE.OVERNO,WICKETBALLNO=BE.BALLNO,WICKETSCORE=(SELECT SUM(GRANDTOTAL) FROM BALLEVENTS BES WHERE BES.COMPETITIONCODE= '%@' AND BES.MATCHCODE= '%@' AND BES.INNINGSNO= '%@' AND (( CAST(CAST(BES.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BES.BALLNO AS NVARCHAR(MAX)) AS FLOAT)) BETWEEN 0.0 AND  CAST(CAST(BE.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BE.BALLNO AS NVARCHAR(MAX)) AS FLOAT))) FROM BATTINGSUMMARY BS INNER JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE=BS.COMPETITIONCODE AND WE.MATCHCODE=BS.MATCHCODE AND WE.INNINGSNO=BS.INNINGSNO AND WE.WICKETPLAYER=BS.BATSMANCODE AND BS.WICKETTYPE IS NOT NULL INNER JOIN BALLEVENTS BE ON BE.BALLCODE =WE.BALLCODE WHERE BS.COMPETITIONCODE='%@' AND BS.MATCHCODE='%@' AND BS.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            NSLog(@"Error: update statement failed: %s.", sqlite3_errmsg(dataBase));
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


@end
                               
                               
                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                   
