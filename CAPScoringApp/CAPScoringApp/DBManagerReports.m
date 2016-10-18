//
//  DBManagerReports.m
//  CAPScoringApp
//
//  Created by Raja sssss on 18/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerReports.h"
#import "FixturesRecord.h"

@implementation DBManagerReports


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



//-------------------------------------------------------------------------------------------------

//Fixtures
-(NSMutableArray *)FixturesData:(NSString*)competitionCode :(NSString*)userCode {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.TEAMNAME AS TEAMANAME,TM1.TEAMNAME AS TEAMBNAME,TM.SHORTTEAMNAME AS TEAMASHORTNAME,TM1.SHORTTEAMNAME AS TEAMBSHORTNAME,MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE, MR.MATCHSTATUS FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE INNER JOIN  MATCHSCORERDETAILS MSD ON CP.COMPETITIONCODE = MSD.COMPETITIONCODE AND MSD.SCORERCODE = '%@' AND MSD.MATCHCODE = MR.MATCHCODE WHERE MR.COMPETITIONCODE='%@' AND MR.MATCHSTATUS in ('MSC123','MSC281') GROUP BY MSD.MATCHCODE ORDER BY MATCHDATE ASC",userCode,competitionCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FixturesRecord *record=[[FixturesRecord alloc]init];
                
                
                record.matchcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.competitioncode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                //        const  char mcod = *sqlite3_column_text(statement, 3);
                NSString* mCode=[NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, 3)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 3)]];
                // mCode = [mCode isEqual:@"(null)"]?@"":mCode;
                record.matchovercomments=mCode;
                record.matchdate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.groundcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.groundname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.overs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.matchTypeName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.MatchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}

@end