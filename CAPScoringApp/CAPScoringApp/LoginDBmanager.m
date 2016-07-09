//
//  LoginDBmanager.m
//  CAPScoringApp
//
//  Created by Lexicon on 01/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "LoginDBmanager.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
@implementation LoginDBmanager



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

//Get database path
+(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}

//UserDetails insert&Update

+(BOOL) CheckUserDetails:(NSString *)LOGINID:(NSString *)PASSWORD{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
   
    NSString *query=[NSString stringWithFormat:@"SELECT LOGINID,PASSWORD FROM USERDETAILS WHERE LOGINID ='%@' AND PASSWORD ='%@'",LOGINID,PASSWORD];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}





+(BOOL) INSERTUSERDETAILS:(NSString *)USERCODE:(NSString *)USERROLEID:(NSString *)LOGINID: (NSString *)PASSWORD:(NSString *)REMEMBERME:(NSString *)REMENTDATE:(NSString *)USERFULLNAME:(NSString *)MACHINEID:(NSString *)LICENSEUPTO:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO USERDETAILS(USERCODE, USERROLEID,LOGINID,PASSWORD,REMEMBERME,REMENTDATE,USERFULLNAME,MACHINEID, LICENSEUPTO,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,RECORDSTATUS,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",USERCODE, USERROLEID,LOGINID,PASSWORD,REMEMBERME,REMENTDATE,USERFULLNAME,MACHINEID, LICENSEUPTO,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,RECORDSTATUS];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}



+(BOOL) UPDATEUSERDETAILS:(NSString *)LOGINID: (NSString *)PASSWORD:(NSString *)LICENSEUPTO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE USERDETAILS SET  LICENSEUPTO='%@',issync='1' WHERE LOGINID ='%@' AND PASSWORD ='%@'",LICENSEUPTO,LOGINID,PASSWORD];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
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



//SecureIdDetails

+(BOOL) CheckSecureIdDetails:(NSString *)USERNAME{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT USERNAME FROM SECUREIDDETAILS WHERE USERNAME ='%@'",USERNAME];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(BOOL) INSERTSECUREIDDETAILS:(NSString *)USERNAME:(NSString *)SECUREID:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO SECUREIDDETAILS(USERNAME, SECUREID,STARTDATE,ENDDATE,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE, RECORDSTATUS,issync)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",USERNAME, SECUREID,STARTDATE,ENDDATE,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE, RECORDSTATUS];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;



}

+(BOOL) UPDATESECUREIDDETAILS:(NSString *)USERNAME:(NSString *)SECUREID:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS
{

    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE SECUREIDDETAILS SET  SECUREID='%@',STARTDATE='%@',ENDDATE='%@',CREATEDBY='%@',CREATEDDATE='%@',MODIFIEDBY='%@',MODIFIEDDATE='%@',RECORDSTATUS='%@',issync='1' WHERE USERNAME ='%@'",SECUREID,STARTDATE,ENDDATE,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE,RECORDSTATUS,USERNAME];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
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

@end