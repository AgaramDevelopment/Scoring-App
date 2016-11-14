//
//  WormReportVC.m
//  CAPScoringApp
//
//  Created by Mac on 09/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "WormReportVC.h"
#import "MCLineChartView.h"
#import "DBManagerReports.h"
#import "WormRecord.h"
#import "WormWicketRecord.h"

@interface WormReportVC ()  <MCLineChartViewDataSource, MCLineChartViewDelegate>
@property (strong, nonatomic) MCLineChartView *lineChartViewOne;
@property (strong, nonatomic) MCLineChartView *lineChartViewTwo;

@property (strong, nonatomic) NSMutableArray *wicketInnsOne;
@property (strong, nonatomic) NSMutableArray *wicketInnsTwo;
@property (strong, nonatomic) NSMutableArray *wicketInnsThree;
@property (strong, nonatomic) NSMutableArray *wicketInnsFour;




@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *wormDataInns1Array;
@property (strong, nonatomic) NSMutableArray *wormDataInns2Array;
@property (strong, nonatomic) NSMutableArray *wormDataInns3Array;
@property (strong, nonatomic) NSMutableArray *wormDataInns4Array;

@end


@implementation WormReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DBManagerReports *dbMngr = [[DBManagerReports alloc]init];
    
    self.wormDataInns1Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"1"];
    self.wormDataInns2Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"2"];
    
    self.wicketInnsOne = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"1"];
    self.wicketInnsTwo = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"2"];
    
    int tag = 0;
    //Set tag for tool tip
    for(WormWicketRecord *wick in self.wicketInnsOne){
        wick.tag =[NSNumber numberWithInt:tag];
        tag++;
    }
    
    for(WormWicketRecord *wick in self.wicketInnsTwo){
        wick.tag =[NSNumber numberWithInt:tag];
        tag++;
    }
    
    
    if([self.wormDataInns1Array count]>0 || [self.wormDataInns2Array count]>0){
        [self setChartOne];
    }
    
    
    
    if([self isTestMatch]){//Test

        self.wormDataInns3Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"3"];
        self.wormDataInns4Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"4"];
        
        self.wicketInnsThree = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"3"];
        self.wicketInnsFour = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"4"];
        
        
        
        for(WormWicketRecord *wick in self.wicketInnsThree){
            wick.tag =[NSNumber numberWithInt:tag];
            tag++;
        }
        
        
        for(WormWicketRecord *wick in self.wicketInnsFour){
            wick.tag =[NSNumber numberWithInt:tag];
            tag++;
        }
        
        
        if([self.wormDataInns3Array count]>0 || [self.wormDataInns4Array count]>0){
            [self setChartTwo];
        }
        
        
    }
    
  
    
    
    
//    _titles = @[@"A", @"B", @"C", @"D", @"E"];
//    _dataSource = @[@100, @245, @180, @165, @225];
//    
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setChartOne{
    
    WormRecord *wormRecord = [self.wormDataInns1Array lastObject];
    
    self.lineChartViewOne = [[MCLineChartView alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width, 260)];

    self.lineChartViewOne.dotRadius = 5;
    self.lineChartViewOne.dataSource = self;
    self.lineChartViewOne.delegate = self;
    self.lineChartViewOne.minValue = @1;
    self.lineChartViewOne.maxValue = [wormRecord score];
    self.lineChartViewOne.solidDot = YES;
    self.lineChartViewOne.numberOfYAxis = 7;
    //self.lineChartViewInnsOne.unitOfYAxis = @"Score";
    self.lineChartViewOne.colorOfXAxis = [UIColor whiteColor];
    self.lineChartViewOne.colorOfXText = [UIColor whiteColor];
    self.lineChartViewOne.colorOfYAxis = [UIColor whiteColor];
    self.lineChartViewOne.colorOfYText = [UIColor whiteColor];
    
    [self.view addSubview:self.lineChartViewOne];

    
    UIView * tittleview =[[UIView alloc]initWithFrame:CGRectMake(_lineChartViewOne.frame.origin.x, _lineChartViewOne.frame.origin.y-50,self.view.frame.size.width, 60)];
    
    UILabel * title_lbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 0,self.view.frame.size.width, 40)];
    

    title_lbl.text =@"INNING 1";
    title_lbl.textColor =[UIColor whiteColor];
    title_lbl.textAlignment=UITextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:25];
    
    [tittleview addSubview:title_lbl];
    
    UILabel * BattingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(20,title_lbl.frame.origin.y+30,self.view.frame.size.width/2, 40)];
    BattingTeam_lbl.text =self.fstInnShortName;
    BattingTeam_lbl.textColor =[UIColor whiteColor];
    BattingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BattingTeam_lbl.font = [UIFont systemFontOfSize:23];
    
    
    [tittleview addSubview:BattingTeam_lbl];
    
    UILabel * BowlingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+100,title_lbl.frame.origin.y+30,self.view.frame.size.width/2, 40)];
    BowlingTeam_lbl.text =self.secInnShortName;
    BowlingTeam_lbl.textColor =[UIColor whiteColor];
    BowlingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BowlingTeam_lbl.font = [UIFont systemFontOfSize:23];
    
    
    [tittleview addSubview:BowlingTeam_lbl];

    [self.view addSubview:tittleview];

    
    
    [self.lineChartViewOne reloadDataWithAnimate:YES];
}

-(void) setChartTwo{
    WormRecord *wormRecord = [self.wormDataInns2Array lastObject];

    self.lineChartViewTwo = [[MCLineChartView alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width, 260)];
    self.lineChartViewTwo.dotRadius = 5;
    self.lineChartViewTwo.dataSource = self;
    self.lineChartViewTwo.delegate = self;
    self.lineChartViewTwo.minValue = @1;
    self.lineChartViewTwo.maxValue = [wormRecord score];
    self.lineChartViewTwo.solidDot = YES;
    self.lineChartViewTwo.unitOfYAxis = @"Score";
    self.lineChartViewTwo.numberOfYAxis = 7;
    self.lineChartViewTwo.colorOfXAxis = [UIColor whiteColor];
    self.lineChartViewTwo.colorOfXText = [UIColor whiteColor];
    self.lineChartViewTwo.colorOfYAxis = [UIColor whiteColor];
    self.lineChartViewTwo.colorOfYText = [UIColor whiteColor];
    [self.view addSubview:self.lineChartViewTwo];
    
    [self.lineChartViewTwo reloadDataWithAnimate:YES];
}


-(bool) isTestMatch {
    if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){//Test
        return YES;
    }
    return NO;
}


- (NSUInteger)numberOfLinesInLineChartView:(MCLineChartView *)lineChartView {
    return 2;
}

- (NSUInteger)lineChartView:(MCLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number {
    
    if(lineChartView == _lineChartViewOne){
        if(number == 0){
          return  [self.wormDataInns1Array count];
        }else{
          return  [self.wormDataInns2Array count];
        }
        
    }else if(lineChartView == _lineChartViewTwo){
        
        
        if(number == 0){
         return   [self.wormDataInns3Array count];
        }else{
          return  [self.wormDataInns4Array count];
        }

    }
    return 0;
}

- (id)lineChartView:(MCLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    
    if(lineChartView == _lineChartViewOne){
        
        if(lineNumber == 0){
            WormRecord *record = [self.wormDataInns1Array objectAtIndex:index];
            return record.score;
        }else{
            WormRecord *record = [self.wormDataInns2Array objectAtIndex:index];
            return record.score;
        }
    }else if(lineChartView == _lineChartViewTwo){
        if(lineNumber == 0){
            WormRecord *record = [self.wormDataInns3Array objectAtIndex:index];
            return record.score;
        }else{
            WormRecord *record = [self.wormDataInns4Array objectAtIndex:index];
            return record.score;
        }

    }
    return @"";
}

//- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number {
- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number :(NSInteger)linenumber :(NSInteger)dummy{

    
    if(lineChartView == _lineChartViewOne){
        if(linenumber == 0){
            WormRecord *record = [self.wormDataInns1Array objectAtIndex:number];
            return record.over;

        }else{
            WormRecord *record = [self.wormDataInns2Array objectAtIndex:number];
            return record.over;

        }
        
    }else if(lineChartView == _lineChartViewTwo){
        
        if(linenumber == 0){
            WormRecord *record = [self.wormDataInns3Array objectAtIndex:number];
            return record.over;

        }else{
            WormRecord *record = [self.wormDataInns4Array objectAtIndex:number];
            return record.over;

        }
    }
    return @"";
    
}

- (UIColor *)lineChartView:(MCLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber {
    
    if(lineNumber == 0){
        return [UIColor blueColor];
    }else{
        return [UIColor redColor];
    }

}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    //if (index == 0 || index == _dataSource.count - 1) {
      //  return [NSString stringWithFormat:@"%@", _dataSource[index]];
    //}
    return nil;
}

- (NSMutableArray *)lineChartView:(MCLineChartView *)lineChartView informationOfWicketInSection:(NSInteger)lineNumber{
    
    if(lineChartView == _lineChartViewOne){
        
        if(lineNumber == 0){
            return _wicketInnsOne;

        }else{
            return _wicketInnsTwo;
        }
    }else if(lineChartView == _lineChartViewTwo){
        if(lineNumber == 0){
            return _wicketInnsThree;
        }else{
            return _wicketInnsFour;
        }
        
    }
    
    return nil;
}

-(WormWicketRecord *) getWicketByTag:(NSInteger) tag{
    
    for(WormWicketRecord *wick in self.wicketInnsOne){
        if([wick.tag integerValue] == tag){
            return wick;
        }
    }
    
    for(WormWicketRecord *wick in self.wicketInnsTwo){
        if([wick.tag integerValue] == tag){
            return wick;
        }
    }
    
    if([self isTestMatch]){//Test

    
        for(WormWicketRecord *wick in self.wicketInnsThree){
            if([wick.tag integerValue] == tag){
                return wick;
            }
        }
    
        for(WormWicketRecord *wick in self.wicketInnsFour){
            if([wick.tag integerValue] == tag){
                return wick;
            }
        }
    }
    
    return nil;
}


- (NSString *)getWicketDetails:(UIButton *)selectwicket{
    WormWicketRecord *wicketdetail = [self getWicketByTag:selectwicket.tag];
    
    return [NSString stringWithFormat:@" Batsman : %@,\n Bowler : %@,\n Over : %@,\n Wicket No : %@,\n Wicket Type : %@ ",wicketdetail.batsmanName,wicketdetail.bowlerName,wicketdetail.wicketOver,wicketdetail.wicketNo,wicketdetail.wicketDesc];
 
}

@end
