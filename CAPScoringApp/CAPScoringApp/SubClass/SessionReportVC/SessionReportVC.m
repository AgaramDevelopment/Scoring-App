//
//  SessionReportVC.m
//  CAPScoringApp
//
//  Created by APPLE on 26/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SessionReportVC.h"
#import <sqlite3.h>
#import "SessionReportRecord.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "SessionReportCell.h"




static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";


@interface SessionReportVC ()<SKSTableViewDelegate>
{
    NSMutableArray * commonArray;
    NSMutableArray * DaySubarray ;
}

@property (nonatomic,strong) IBOutlet SessionReportCell * sessionCell;

@end

@implementation SessionReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.SKSTableViewDelegate = self;
    NSMutableArray * sessionvalue =[self getSession:self.compitioncode :self.matchcode];
    commonArray = [[NSMutableArray alloc] init];
    NSMutableArray * dayarray = [[NSMutableArray alloc] init];
    DaySubarray = [[NSMutableArray alloc] init];
    int Daycount =0;
    SessionReportRecord * objRecord;
    
    
    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"dayno", @"Day 1",@"dayno", @"Day 2", nil];
//    
//    NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"dayno", @"Day 2", nil];
//    NSDictionary *dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"dayno", @"Day 3", nil];

    for(int i=0; i< sessionvalue.count; i++)
    {
        if(i==0)
        {
            SessionReportRecord *record=[[SessionReportRecord alloc]init];
            record.dayno = @"DAY 1";
            record.sessionno=@"";
            record.Teamcode=@"";
            record.TeamName=@"";
            
            record.Runs=@"";
            
            record.overs=@"";
            
            record.wickets=@"";
            
            record.fours=@"";
            
            record.sixes=@"";
            
            record.RunRate=@"";
            record.BDRY=@"";
            [sessionvalue addObject:record];

        }
        if(i==4)
        {
            SessionReportRecord *record=[[SessionReportRecord alloc]init];
            record.dayno = @"DAY 2";
            record.sessionno=@"";
            record.Teamcode=@"";
            record.TeamName=@"";
            
            record.Runs=@"";
            
            record.overs=@"";
            
            record.wickets=@"";
            
            record.fours=@"";
            
            record.sixes=@"";
            
            record.RunRate=@"";
            record.BDRY=@"";
            [sessionvalue addObject:record];
        }
        if(i== 8)
        {
            
            SessionReportRecord *record=[[SessionReportRecord alloc]init];
            record.dayno = @"DAY 3";
            record.sessionno=@"";
            record.Teamcode=@"";
            record.TeamName=@"";
            
            record.Runs=@"";
            
            record.overs=@"";
            
            record.wickets=@"";
            
            record.fours=@"";
            
            record.sixes=@"";
            
            record.RunRate=@"";
            record.BDRY=@"";
            [sessionvalue addObject:record];
        }
        if(i== 12)
        {
            SessionReportRecord *record=[[SessionReportRecord alloc]init];
            record.dayno = @"DAY 4";
            record.sessionno=@"";
            record.Teamcode=@"";
            record.TeamName=@"";
            
            record.Runs=@"";
            
            record.overs=@"";
            
            record.wickets=@"";
            
            record.fours=@"";
            
            record.sixes=@"";
            
            record.RunRate=@"";
            record.BDRY=@"";
            [sessionvalue addObject:record];
        }
        if(i== 16)
        {
            SessionReportRecord *record=[[SessionReportRecord alloc]init];
            record.dayno = @"DAY 5";
            record.sessionno=@"";
            record.Teamcode=@"";
            record.TeamName=@"";
            
            record.Runs=@"";
            
            record.overs=@"";
            
            record.wickets=@"";
            
            record.fours=@"";
            
            record.sixes=@"";
            
            record.RunRate=@"";
            record.BDRY=@"";
            [sessionvalue addObject:record];
        }
    }
    
    
    
    
    for(int i=0; i< sessionvalue.count; i++)
    {
        objRecord =(SessionReportRecord *)[sessionvalue objectAtIndex:i];
        if([objRecord.dayno isEqualToString:@"DAY 1"] && [objRecord.sessionno isEqualToString:@"SESSION 1"])
        {
           
            Daycount= Daycount+1;
        }
        
        if([objRecord.dayno isEqualToString:@"DAY 2"] && [objRecord.sessionno isEqualToString:@"SESSION 1"])
        {
           
            Daycount= Daycount+1;
        }
        if([objRecord.dayno isEqualToString:@"DAY 3"] && [objRecord.sessionno isEqualToString:@"SESSION 1"])
        {
            
            Daycount= Daycount+1;
        }
        if([objRecord.dayno isEqualToString:@"DAY 4"] && [objRecord.sessionno isEqualToString:@"SESSION 1"])
        {
            Daycount= Daycount+1;
        }
        if([objRecord.dayno isEqualToString:@"DAY 5"] && [objRecord.sessionno isEqualToString:@"SESSION 1"])
        {
            Daycount= Daycount+1;
        }
    }

    
    
    for(int i=0; i < Daycount; i++)
    {
        int day =i+4;
        if(i==0)
        {
        
          objRecord =(SessionReportRecord *)[sessionvalue objectAtIndex:i];
        }
        else
        {
            if(sessionvalue.count > day)
            {
            objRecord =(SessionReportRecord *)[sessionvalue objectAtIndex:day];
            }
            else{
                return ;
            }
        }
       NSString * dayno = objRecord.dayno;
        
       NSPredicate* DayPredicate = [NSPredicate predicateWithFormat:@"dayno == %@",dayno];
        
       NSArray * day1 = [sessionvalue filteredArrayUsingPredicate:DayPredicate];
        
        NSArray* reversedArray = [[day1 reverseObjectEnumerator] allObjects];

//        
//        [DaySubarray addObject:day1];
        
       // NSMutableArray * obj=[NSMutableArray arrayWithObjects:objRecord.dayno,day1, nil];
        [dayarray addObject:reversedArray];
        }
    
    [commonArray addObject:dayarray];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [commonArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commonArray [section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [commonArray [indexPath.section][indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 1 && indexPath.row == 0 && indexPath.row == 3)
    //    {
    return YES;
    //    }
    //
    //    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    cell.textLabel.text = [NSString stringWithFormat:@"DAY %d",indexPath.row+1];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor=[UIColor whiteColor];
    
    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
        cell.expandable = YES;
    else
        cell.expandable = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SessionReportCell";
    
    SessionReportCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SessionReportCell" owner:self options:nil];
        cell = self.sessionCell;
        
    }
    
     //NSMutableArray *objRecords = commonArray[indexPath.section][indexPath.row][indexPath.subRow];
     SessionReportRecord *objRecord = commonArray[indexPath.section][indexPath.row][indexPath.subRow];
    cell.sessionno.text = objRecord.sessionno;
    cell.BattingTeam.text =objRecord.shortName;
    cell.overs.text      =objRecord.overs;
    cell.Run.text        =objRecord.Runs;
    cell.WKT.text       =objRecord.wickets;
    cell.Run4s.text  =objRecord.fours;
    cell.Run6s.text  =objRecord.sixes;
    cell.RunRate.text = objRecord.RunRate;
    cell.BDRY.text = objRecord.BDRY;
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

#pragma mark - Actions

- (void)collapseSubrows
{
    [self.tableView collapseCurrentlyExpandedIndexPaths];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}

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



-(NSMutableArray *)getSession:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE
{
    NSMutableArray * getSessiondetail=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  'DAY'||' '||CAST(DAYNO AS NVARCHAR)  AS DAYNO, 'SESSION'||' '|| CAST(SESSIONNO AS NVARCHAR)  AS SESSIONNO, TEAMCODE, TEAMNAME,SHORTTEAMNAME, RUNS, CAST((BALLS / 6) AS TEXT) || '.' || CAST((BALLS / 6) AS TEXT) OVERS, WICKETS, FOURS, SIXES, CAST((CASE WHEN BALLS = 0 THEN 0 ELSE ((RUNS / BALLS) * 6) END) AS NUMERIC(5,2)) RUNRATE, CAST((CASE WHEN RUNS = 0 THEN 0 ELSE (((FOURS * 4) + (SIXES * 6)) / RUNS) * 100 END) AS NUMERIC(5,2)) BOUNDARIESPERCENTAGE FROM (SELECT BE.COMPETITIONCODE, BE.MATCHCODE, BE.INNINGSNO, BE.DAYNO, BE.SESSIONNO, BE.TEAMCODE, TM.TEAMNAME,TM.SHORTTEAMNAME, SUM(BE.GRANDTOTAL) RUNS, SUM(CASE WHEN BE.ISLEGALBALL = 1 THEN 1 ELSE 0 END) BALLS, SUM(CASE WHEN BE.ISFOUR = 1 THEN 1 ELSE 0 END) FOURS, SUM(CASE WHEN BE.ISSIX = 1 THEN 1 ELSE 0 END) SIXES, SUM(CASE WHEN BE.ISLEGALBALL = 1 AND (BE.RUNS + (CASE WHEN BE.BYES + BE.LEGBYES = 0 THEN BE.OVERTHROW ELSE 0 END)) = 0 THEN 1 ELSE 0 END) DOTBALLS, SUM(CASE WHEN LENGTH(IFNULL(WE.WICKETTYPE,''))<0 OR WE.WICKETTYPE = 'MSC102' THEN 0 ELSE 1 END) WICKETS FROM BALLEVENTS BE INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE LEFT JOIN WICKETEVENTS WE ON  BE.COMPETITIONCODE = WE.COMPETITIONCODE AND BE.MATCHCODE = WE.MATCHCODE AND BE.INNINGSNO = WE.INNINGSNO AND BE.BALLCODE = WE.BALLCODE WHERE  ('%@'='' OR BE.COMPETITIONCODE = '%@') AND ('%@'='' OR BE.MATCHCODE = '%@') GROUP BY BE.COMPETITIONCODE, BE.MATCHCODE, BE.INNINGSNO, BE.DAYNO, BE.SESSIONNO, BE.TEAMCODE, TM.TEAMNAME) SSN",COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                SessionReportRecord *record=[[SessionReportRecord alloc]init];
                record.dayno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.sessionno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.Teamcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.TeamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.shortName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                record.Runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                record.overs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                record.wickets=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                record.fours=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                record.sixes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                 record.RunRate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.BDRY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                [getSessiondetail addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return getSessiondetail;
    

}

@end
