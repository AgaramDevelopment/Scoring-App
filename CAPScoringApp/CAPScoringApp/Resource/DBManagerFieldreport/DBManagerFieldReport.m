//
//  DBManagerFieldReport.m
//  CAPScoringApp
//
//  Created by APPLE on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerFieldReport.h"
#import <sqlite3.h>
#import "FFactorRecord.h"
#import "FFactoredRecord.h"
#import "FFactorDetailRecord.h"

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";



@implementation DBManagerFieldReport


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

-(NSMutableArray *)GETFIELDINGFACTORCODE
{
    NSMutableArray * FFactore=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT FIELDINGFACTORCODE,FIELDINGFACTOR FROM   FIELDINGFACTOR WHERE  RECORDSTATUS='MSC001' ORDER BY FIELDINGFACTOR ASC "];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FFactorRecord *record=[[FFactorRecord alloc]init];
                
                record.FFactorCode=[self getValueByNull:statement :0];
                record.FieldFactor=[self getValueByNull:statement :1];

                [FFactore addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return FFactore;
}


-(NSMutableArray *) GETFIELDERCODE:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *)TEAMCODE :(NSString *) INNINGSNO
{
    NSMutableArray * FFactored=[[NSMutableArray alloc]init];

    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT DISTINCT FE.FIELDERCODE,PM.PLAYERNAME  FROM   FIELDINGEVENTS FE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=FE.FIELDERCODE AND PM.RECORDSTATUS='MSC001' WHERE  ('%@'=''  OR FE.COMPETITIONCODE ='%@') AND ('%@'='' OR FE.MATCHCODE='%@') AND ('%@'='' OR FE.TEAMCODE ='%@') AND  ('%@'='' OR  FE.INNINGSNO ='%@') ORDER BY PLAYERNAME ASC ",COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
            FFactoredRecord *record=[[FFactoredRecord alloc]init];
            record.FFatoredCode=[self getValueByNull:statement :0];
            record.PlayerName=[self getValueByNull:statement :1];

            [FFactored addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return FFactored;
}

-(NSMutableArray *) getFieldingdetails:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *)TEAMCODE :(NSString *) INNINGSNO :(NSString *) FIELDINGFACTORCODE 
{
    NSMutableArray * FFactordetail=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT FLD.FIELDERCODE,PM.PLAYERNAME,FF.FIELDINGFACTOR, COUNT(1) BALLSFIELDED, SUM(CASE WHEN NRS < 0 THEN ABS(NRS) ELSE 0 END) RUNSCOST, SUM(CASE WHEN NRS > 0 THEN ABS(NRS) ELSE 0 END) RUNSSAVED FROM FIELDINGEVENTS FLD  INNER JOIN BALLEVENTS BALL ON FLD.BALLCODE = BALL.BALLCODE  LEFT JOIN PLAYERMASTER PM ON FLD.FIELDERCODE = PM.PLAYERCODE INNER JOIN FIELDINGFACTOR FF ON FLD.FIELDINGFACTORCODE= FF.FIELDINGFACTORCODE  WHERE ('%@' ='' OR BALL.COMPETITIONCODE ='%@')  AND ('%@' = ''  OR BALL.MATCHCODE ='%@')  AND ('%@'='' OR BALL.TEAMCODE ='%@') AND ('%@'='' OR BALL.INNINGSNO ='%@') AND ('%@'='' OR FLD.FIELDERCODE ='%@') GROUP BY FLD.FIELDERCODE, PM.PLAYERNAME, FF.FIELDINGFACTOR,FIELDERCODE",COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO,FIELDINGFACTORCODE,FIELDINGFACTORCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FFactorDetailRecord *record=[[FFactorDetailRecord alloc]init];
                
                record.Fieldercode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PlayerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                record.Fieldingfactor =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                record.Ballsfielded=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                record.Runscost=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                record.Runssaved=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                
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
