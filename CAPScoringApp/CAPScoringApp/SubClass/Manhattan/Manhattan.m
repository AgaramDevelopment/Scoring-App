//
//  Manhattan.m
//  CAPScoringApp
//
//  Created by APPLE on 28/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Manhattan.h"
#import <sqlite3.h>
#import "ManhattanRecord.h"
#import "MCBarChartView.h"


static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";


@interface Manhattan ()<MCBarChartViewDelegate,MCBarChartViewDataSource>
{
    ManhattanRecord * objManhattanRecord;
    NSMutableArray * objRunArray ;
     NSMutableArray * objOverArray ;
}

@property (strong, nonatomic) MCBarChartView *barChartView;

@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) NSMutableArray *dataSource;


@end

@implementation Manhattan


- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray * manhattendetail = [[NSMutableArray alloc]init];
    objRunArray =[[NSMutableArray alloc]init];
    objOverArray =[[NSMutableArray alloc]init];
    manhattendetail =[self getChartDetail:self.matchTypecode :self.compititionCode :self.matchCode];
    
    for(int i=0; i < manhattendetail.count; i++)
    {
        objManhattanRecord =(ManhattanRecord *)[manhattendetail objectAtIndex:i];
        
        [objRunArray addObject:objManhattanRecord.runs];
        
        [objOverArray addObject:objManhattanRecord.overno];
    
       
    }

    
    [self BarChartMethod];
    
}


-(void) BarChartMethod
{
    _titles = objOverArray; //@[@"0", @"1", @"2", @"3", @"4", @"5",@"6",@"7",@"8",@"10",@"11",@"12",@"13"];
    _dataSource = objRunArray; //[NSMutableArray arrayWithArray:@[@15, @5, @0, @18, @10, @20,@22]];
    
    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView.tag = 111;
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.maxValue = @25;
    _barChartView.unitOfYAxis = @"Run";
    
    _barChartView.colorOfXAxis = [UIColor whiteColor];
    _barChartView.colorOfXText = [UIColor whiteColor];
    _barChartView.colorOfYAxis = [UIColor whiteColor];
    _barChartView.colorOfYText = [UIColor whiteColor];
    [self.manhattan_Scroll addSubview:_barChartView];
}

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
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

-(NSMutableArray *)getChartDetail:(NSString *) MatchTypecode:(NSString *) compititionCode :(NSString *) matchcode
{
    NSMutableArray * getManhattendetail=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"WITH WORMCHART AS (SELECT   CASE WHEN COM.MATCHTYPE = '%@' OR COM.MATCHTYPE = '%@' THEN 1 ELSE 0 END ISMULTIDAY, BE.TEAMCODE, TM.TEAMNAME TEAMNAME, BE.INNINGSNO,(BE.OVERNO + 1) OVERNO, SUM(BE.GRANDTOTAL) SCORE, SUM(BE.RUNS) RUNS , BE.MATCHCODE FROM    BALLEVENTS BE INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE INNER JOIN COMPETITION COM ON BE.COMPETITIONCODE = COM.COMPETITIONCODE WHERE  ('' = '%@' OR BE.COMPETITIONCODE = '%@') AND ('' = '%@' OR BE.MATCHCODE = '%@') GROUP BY COM.MATCHTYPE, BE.TEAMCODE, TM.TEAMNAME, BE.INNINGSNO, BE.OVERNO, BE.MATCHCODE),WICKETSDETAILS AS (SELECT   BE.TEAMCODE, BE.INNINGSNO,(BE.OVERNO + 1) OVERNO, WE.WICKETNO WICKETS FROM    BALLEVENTS BE INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE INNER JOIN COMPETITION COM ON BE.COMPETITIONCODE = COM.COMPETITIONCODE INNER JOIN  WICKETEVENTS WE ON WE.COMPETITIONCODE = BE.COMPETITIONCODE AND WE.MATCHCODE = BE.MATCHCODE AND WE.TEAMCODE = BE.TEAMCODE AND WE.BALLCODE = BE.BALLCODE AND WE.WICKETTYPE NOT IN ('MSC102') WHERE  ('' = '%@' OR BE.COMPETITIONCODE = '%@') AND (BE.MATCHCODE = '%@') GROUP BY BE.TEAMCODE, BE.INNINGSNO, BE.OVERNO, WE.WICKETNO)	SELECT   CHARTDATA.MATCHCODE,CHARTDATA.ISMULTIDAY, CHARTDATA.TEAMCODE, CHARTDATA.TEAMNAME, CHARTDATA.INNINGSNO, CHARTDATA.OVERNO, IFNULL((WKT.WICKETS),0) WICKETS, CHARTDATA.RUNS, CHARTDATA.SCORE, CASE  WHEN PP.POWERPLAYCODE IS NOT NULL THEN 1 ELSE 0 END AS ISPOWERPLAY ,PP.POWERPLAYTYPE FROM (SELECT   WCI.MATCHCODE,WCI.ISMULTIDAY, WCI.TEAMCODE, WCI.TEAMNAME, WCI.INNINGSNO, WCI.OVERNO, WCI.RUNS, SUM(WCA.SCORE) SCORE FROM	 WORMCHART WCI INNER JOIN WORMCHART WCA ON WCI.TEAMCODE = WCA.TEAMCODE AND WCI.INNINGSNO = WCA.INNINGSNO AND WCA.OVERNO <= WCI.OVERNO GROUP BY WCI.ISMULTIDAY, WCI.TEAMCODE, WCI.TEAMNAME, WCI.INNINGSNO, WCI.OVERNO, WCI.RUNS,WCI.MATCHCODE )CHARTDATA LEFT JOIN POWERPLAY PP ON CHARTDATA.OVERNO BETWEEN PP.STARTOVER AND PP.ENDOVER AND CHARTDATA.MATCHCODE = PP.MATCHCODE AND CHARTDATA.INNINGSNO=PP.INNINGSNO AND PP.RECORDSTATUS='MSC001' LEFT JOIN WICKETSDETAILS WKT ON WKT.TEAMCODE = CHARTDATA.TEAMCODE AND WKT.INNINGSNO = CHARTDATA.INNINGSNO AND WKT.OVERNO = CHARTDATA.OVERNO ORDER BY CHARTDATA.INNINGSNO, CHARTDATA.OVERNO;",MatchTypecode,MatchTypecode,compititionCode,compititionCode,matchcode,matchcode,compititionCode,compititionCode,matchcode];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                ManhattanRecord *record=[[ManhattanRecord alloc]init];
                record.matchcode = [self getValueByNull:statement :0];
                record.ismultiday=[self getValueByNull:statement :1];
                record.inningsno=[self getValueByNull:statement :1];
                record.teamcode=[self getValueByNull:statement :2];
                
                record.teamname=[self getValueByNull:statement :3];
                
                record.wickets=[self getValueByNull:statement :4];
                
                record.overno=[self getValueByNull:statement :5];
                
                record.ispowerplay=[self getValueByNull:statement :6];
                
                record.runs=[self getValueByNull:statement :7];
                
                record.score=[self getValueByNull:statement :8];
                record.powerplayType=[self getValueByNull:statement :9];
                
                [getManhattendetail addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return getManhattendetail;
}

- (NSInteger)numberOfSectionsInBarChartView:(MCBarChartView *)barChartView {
    // if (barChartView.tag == 111) {
    return [_dataSource count];
    //}
    //else {
    //        return [_dataSource count];
    //    }
    
}

- (NSInteger)barChartView:(MCBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section {
    //if (barChartView.tag == 111) {
    return 1;
    //}
    //    else {
    //        return [_dataSource2[section] count];
    //    }
}

- (id)barChartView:(MCBarChartView *)barChartView valueOfBarInSection:(NSInteger)section index:(NSInteger)index {
    //if (barChartView.tag == 111) {
    return _dataSource[section];
    //    } else {
    //        return _dataSource2[section][index];
    //    }
}

- (UIColor *)barChartView:(MCBarChartView *)barChartView colorOfBarInSection:(NSInteger)section index:(NSInteger)index {
    //if (barChartView.tag == 111) {
    return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
    //}
    
    
    //    else {
    //        if (index == 0) {
    //            return [UIColor colorWithRed:105/255.0 green:105/255.0 blue:147/255.0 alpha:1.0];
    //        }
    //        return [UIColor colorWithRed:2/255.0 green:185/255.0 blue:187/255.0 alpha:1.0];
    //    }
}

- (NSString *)barChartView:(MCBarChartView *)barChartView titleOfBarInSection:(NSInteger)section {
    return _titles[section];
}

- (NSString *)barChartView:(MCBarChartView *)barChartView informationOfBarInSection:(NSInteger)section index:(NSInteger)index {
    if (barChartView.tag == 111) {
        if ([_dataSource[section] floatValue] >= 130) {
            return @"";
        } else if ([_dataSource[section] floatValue] >= 110) {
            return @"";
        } else if ([_dataSource[section] floatValue] >= 90) {
            return @"";
        } else {
            return @"";
        }
    }
    return nil;
}

- (CGFloat)barWidthInBarChartView:(MCBarChartView *)barChartView {
    //if (barChartView.tag == 111) {
    return 26;
    //    } else {
    //        return 26;
    //    }
}

- (CGFloat)paddingForSectionInBarChartView:(MCBarChartView *)barChartView {
    //if (barChartView.tag == 111) {
    return 24;
    //    } else {
    //        return 12;
    //    }
}


     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
