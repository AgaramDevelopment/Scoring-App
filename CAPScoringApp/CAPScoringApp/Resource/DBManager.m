//
//  DBManager.m
//  CAP
//
//  Created by Lexicon on 20/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManager.h"
#import "EventRecord.h"
#import "UserRecord.h"
@implementation DBManager


+(NSString *)getDBPath
{
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"TNCA_DATABASE" ofType:@"sqlite"];
    
    return dbPath;
}



+(NSMutableArray *)RetrieveEventData{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    NSDate*todayDate=[NSDate date];
    NSDateFormatter*dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd"];
    NSString *strDate=[dateFormat stringFromDate:todayDate];
    
    NSDateFormatter*dateFormat1=[[NSDateFormatter alloc]init];
    [dateFormat1 setDateFormat:@"MMMM"];
    NSString *strDate1=[dateFormat1 stringFromDate:todayDate];
    NSString *month=[strDate1 lowercaseString];
    
    NSString *query=[NSString stringWithFormat:@"select * FROM COMPETITION"];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            EventRecord *record=[[EventRecord alloc]init];
            //            record.id=(int)sqlite3_column_int(statement, 0);
            record.competitioncode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            record.competitionname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            record.recordstatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
            
            //            record.date=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            //            record.year=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            
            [eventArray addObject:record];
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
}




+(BOOL)checkExpiryDate: (NSString *) userId{
    int retVal;
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT  *  FROM Userdetails WHERE  strftime('%%Y-%%m-%%d-', EXPIRYDATE) >= CURRENT_DATE AND USERCODE = '%@'",userId];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                return YES;
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return NO;
}

+(NSMutableArray *)checkUserLogin: (NSString *) userName password: (NSString *) password{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT  USERCODE,USERNAME  FROM Userdetails WHERE  USERNAME = '%@' AND PASSWORD = '%@' AND RECORDSTATUS = 'MSC001'",userName,password];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                UserRecord *record=[[UserRecord alloc]init];
                record.userCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.userName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [eventArray addObject:record];
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return eventArray;
}

@end
