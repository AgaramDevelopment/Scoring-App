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
#import "ManhattenWKTRecord.h"
#import "ToolTipRecord.h"


static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";


@interface Manhattan ()<MCBarChartViewDelegate,MCBarChartViewDataSource>
{
    ManhattanRecord * objManhattanRecord;
    NSMutableArray * objRunArray ;
     NSMutableArray * objOverArray ;
    
    NSMutableArray * objInnings2RunArray ;
    NSMutableArray * objInnings2OverArray ;
    
    NSMutableArray * objInnings3RunArray ;
    NSMutableArray * objInnings3OverArray ;
    
    NSMutableArray * objInnings4RunArray ;
    NSMutableArray * objInnings4OverArray ;
    
    NSMutableArray * wicketDetail;
    
    NSMutableArray * objinnings1Wicket;
    NSMutableArray * objinnings2wicket;
    NSMutableArray * objinnings3Wicket;
    NSMutableArray * objinnings4wicket;
    NSMutableArray * ToolTipDetails;
    
     UIView * tooltip_view;
}

@property (strong, nonatomic) MCBarChartView *barChartView;

@property (strong, nonatomic) NSArray * titles;

@property (strong, nonatomic) NSMutableArray *dataSource;


@end

@implementation Manhattan


- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray * manhattendetail = [[NSMutableArray alloc]init];
    objRunArray =[[NSMutableArray alloc]init];
    objOverArray =[[NSMutableArray alloc]init];
    
    objInnings2RunArray =[[NSMutableArray alloc]init];
    objInnings2OverArray =[[NSMutableArray alloc]init];
    
    objInnings3RunArray =[[NSMutableArray alloc]init];
    objInnings3OverArray =[[NSMutableArray alloc]init];
    
    objInnings4RunArray =[[NSMutableArray alloc]init];
    objInnings4OverArray =[[NSMutableArray alloc]init];
    
    wicketDetail=[[NSMutableArray alloc]init];
    
    objinnings1Wicket =[[NSMutableArray alloc]init];
    objinnings2wicket =[[NSMutableArray alloc]init];
    
    objinnings3Wicket =[[NSMutableArray alloc]init];
    objinnings4wicket =[[NSMutableArray alloc]init];
    
    ToolTipDetails =[[NSMutableArray alloc]init];
    
    
    manhattendetail =[self getChartDetail:self.matchTypecode :self.compititionCode :self.matchCode];
    NSString * innings1 = @"1";
    
    NSString * innings2 = @"2";
    
    NSString * innings3 = @"3";
    
    NSString * innings4 = @"4";
    
    NSPredicate* DayPredicate = [NSPredicate predicateWithFormat:@"inningsno == %@",innings1];
    
    NSArray * Innings1 = [manhattendetail filteredArrayUsingPredicate:DayPredicate];
    
    NSPredicate* DayPredicate1 = [NSPredicate predicateWithFormat:@"inningsno == %@",innings2];
    
    NSArray * Innings2 = [manhattendetail filteredArrayUsingPredicate:DayPredicate1];
    

    NSPredicate* DayPredicate2 = [NSPredicate predicateWithFormat:@"inningsno == %@",innings3];
    
    NSArray * Innings3 = [manhattendetail filteredArrayUsingPredicate:DayPredicate2];
    

    NSPredicate* DayPredicate3 = [NSPredicate predicateWithFormat:@"inningsno == %@",innings4];
    
    NSArray * Innings4 = [manhattendetail filteredArrayUsingPredicate:DayPredicate3];
    

    
    
    for(int i=0; i < Innings1.count; i++)
    {
        objManhattanRecord =(ManhattanRecord *)[Innings1 objectAtIndex:i];
        
        NSString * overno =objManhattanRecord.overno;
        
            if(objOverArray.count > 0)
            {
            NSString * Addoverno =[objOverArray lastObject];
            
            if(![overno isEqualToString: Addoverno])
            {
              [objOverArray addObject:objManhattanRecord.overno];
              [objRunArray addObject:objManhattanRecord.runs];
            }
            }
        
        
        if(objOverArray.count == 0)
        {
           [objOverArray addObject:objManhattanRecord.overno];
            [objRunArray addObject:objManhattanRecord.runs];
        }

       
    }
    
    for(int i=0; i < Innings2.count; i++)
    {
        objManhattanRecord =(ManhattanRecord *)[Innings2 objectAtIndex:i];
        
        
        NSString * overno =objManhattanRecord.overno;
        
        if(objInnings2OverArray.count >0)
        {
            NSString * Addoverno =[objInnings2OverArray lastObject];
            
            if(![overno isEqualToString: Addoverno])
            {
                [objInnings2RunArray addObject:objManhattanRecord.runs];
                
                [objInnings2OverArray addObject:objManhattanRecord.overno];
                

            }
        }
        
        
        if(objInnings2OverArray.count == 0)
        {
            [objInnings2RunArray addObject:objManhattanRecord.runs];
            
            [objInnings2OverArray addObject:objManhattanRecord.overno];
            

        }

        
    }

    
    for(int i=0; i < Innings3.count; i++)
    {
        objManhattanRecord =(ManhattanRecord *)[manhattendetail objectAtIndex:i];
        
        
        NSString * overno =objManhattanRecord.overno;
        
        if(objInnings3OverArray.count >0)
        {
            NSString * Addoverno =[objInnings3OverArray lastObject];
            
            if(![overno isEqualToString: Addoverno])
            {
                [objInnings3RunArray addObject:objManhattanRecord.runs];
                
                [objInnings3OverArray addObject:objManhattanRecord.overno];
            }
        }
        
        
        if(objInnings3OverArray.count == 0)
        {
            [objInnings3RunArray addObject:objManhattanRecord.runs];
            
            [objInnings3OverArray addObject:objManhattanRecord.overno];
        }
        
        
    }

    for(int i=0; i < Innings4.count; i++)
    {
        objManhattanRecord =(ManhattanRecord *)[manhattendetail objectAtIndex:i];
        
        NSString * overno =objManhattanRecord.overno;
        
        if(objInnings4OverArray.count >0)
        {
            NSString * Addoverno =[objInnings4OverArray objectAtIndex:i-1];
            
            if(![overno isEqualToString: Addoverno])
            {
                [objInnings4RunArray addObject:objManhattanRecord.runs];
                
                [objInnings4OverArray addObject:objManhattanRecord.overno];
                

            }
        }
        
        
        if(objInnings4OverArray.count == 0)
        {
            
            [objInnings4RunArray addObject:objManhattanRecord.runs];
            
            [objInnings4OverArray addObject:objManhattanRecord.overno];
            

        }
        
    }
    
    objinnings1Wicket = [self getwicket:self.compititionCode :self.matchCode:@"1"];
    objinnings2wicket = [self getwicket:self.compititionCode :self.matchCode:@"2"];
    
    int tag = 0;
    //Set tag for tool tip
    
    for(ManhattenWKTRecord * wick in objinnings1Wicket){
        wick.tag =[NSNumber numberWithInt:tag];
        tag++;
    }
    
    for(ManhattenWKTRecord *wick in objinnings2wicket){
        wick.tag =[NSNumber numberWithInt:tag];
        tag++;
    }
    
    
    //    if([self.objinnings1Wicket count]>0 || [self.objinnings2wicket count]>0){
    //        [self setChartOne];
    //    }
    
    
    
    //  if([self isTestMatch]){//Test
    
    objinnings3Wicket = [self getwicket:self.compititionCode :self.matchCode:@"3"];
    objinnings4wicket = [self getwicket:self.compititionCode :self.matchCode:@"4"];
    
    //self.wormDataInns3Array =[self generateInningsArray :@"3"];
    // self.wormDataInns4Array  =[self generateInningsArray:@"4"];
    
    //
    //        self.wicketInnsThree = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"3"];
    //        self.wicketInnsFour = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"4"];
    
    
    
    for(ManhattenWKTRecord *wick in objinnings3Wicket){
        wick.tag =[NSNumber numberWithInt:tag];
        tag++;
    }
    
    
    for(ManhattenWKTRecord *wick in objinnings4wicket){
        wick.tag =[NSNumber numberWithInt:tag];
        tag++;
    }

    

    if(Innings1.count > 0)
    {
      [self BarChartMethodFirstInnigs];
      [self.manhattan_Scroll setContentSize:CGSizeMake(self.view.frame.size.width,1* 355)];

    }
    
    if (Innings2.count > 0)
    {
     [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(BarChartMethodFirstInnigs2)
                                   userInfo:nil
                                    repeats:NO];
        [self.manhattan_Scroll setContentSize:CGSizeMake(self.view.frame.size.width,2* 355)];

    }
    
    if (Innings3.count > 0)
    {
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(BarChartMethodFirstInnigs3)
                                   userInfo:nil
                                    repeats:NO];
        [self.manhattan_Scroll setContentSize:CGSizeMake(self.view.frame.size.width,3* 355)];

    }
    
     if (Innings4.count >0)
    {
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(BarChartMethodFirstInnigs4)
                                   userInfo:nil
                            repeats:NO];
        [self.manhattan_Scroll setContentSize:CGSizeMake(self.view.frame.size.width,4* 355)];

    }
    
    wicketDetail = [self getwicket:self.compititionCode :self.matchCode:innings1];
    
//    NSPredicate* wicketPredicate = [NSPredicate predicateWithFormat:@"inningsno == %@",innings1];
//    
//    NSArray * Innings1wicket = [wicketDetail filteredArrayUsingPredicate:wicketPredicate];
//    
//    for(int i=0; i < wicketDetail.count; i++)
//    {
//     ManhattenWKTRecord * ManhattanWktRecord =(ManhattenWKTRecord *)[wicketDetail objectAtIndex:i];
//        
//        
//        NSString * inningsno =ManhattanWktRecord.inningno;
//        
////        if(objInnings2OverArray.count >0)
////        {
////            NSString * Addoverno =[objInnings2OverArray lastObject];
//        
//            if([inningsno isEqualToString: @"1"])
//            {
//                [objinnings1Wicket addObject:ManhattanWktRecord];
//            }
//
//        
//    }
//
//    for(int i=0; i < wicketDetail.count; i++)
//    {
//         ManhattenWKTRecord * ManhattanWktRecord =(ManhattenWKTRecord *)[wicketDetail objectAtIndex:i];
//        
//        
//        NSString * inningsno =ManhattanWktRecord.inningno;
//        
//        //        if(objInnings2OverArray.count >0)
//        //        {
//        //            NSString * Addoverno =[objInnings2OverArray lastObject];
//        
//        if([inningsno isEqualToString: @"2"])
//        {
//            [objinnings2wicket addObject:ManhattanWktRecord];
//        }
//        
//        
//    }

//    DBManagerReports *dbMngr = [[DBManagerReports alloc]init];
//    
//    // self.wormDataInns1Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"1"];
//    // self.wormDataInns2Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"2"];
//    self.wormDataInns1Array = [self generateInningsArray :@"1"];
//    self.wormDataInns2Array =[self generateInningsArray :@"2"];
//    
//    
//    self.wicketInnsOne = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"1"];
//    self.wicketInnsTwo = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"2"];
//    
//    int tag = 0;
//    //Set tag for tool tip
//    for(WormWicketRecord *wick in self.wicketInnsOne){
//        wick.tag =[NSNumber numberWithInt:tag];
//        tag++;
//    }
//    
//    for(WormWicketRecord *wick in self.wicketInnsTwo){
//        wick.tag =[NSNumber numberWithInt:tag];
//        tag++;
//    }
//    
//    
//    if([self.wormDataInns1Array count]>0 || [self.wormDataInns2Array count]>0){
//        [self setChartOne];
//    }
//    
//    
//    
//    if([self isTestMatch]){//Test
//        
//        self.wormDataInns3Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"3"];
//        self.wormDataInns4Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"4"];
//        
//        self.wormDataInns3Array =[self generateInningsArray :@"3"];
//        self.wormDataInns4Array  =[self generateInningsArray:@"4"];
//        
//        
//        self.wicketInnsThree = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"3"];
//        self.wicketInnsFour = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"4"];
//        
//        
//        
//        for(WormWicketRecord *wick in self.wicketInnsThree){
//            wick.tag =[NSNumber numberWithInt:tag];
//            tag++;
//        }
//        
//        
//        for(WormWicketRecord *wick in self.wicketInnsFour){
//            wick.tag =[NSNumber numberWithInt:tag];
//            tag++;
//        }
//        
//        
//        if([self.wormDataInns3Array count]>0 || [self.wormDataInns4Array count]>0){
//            [self setChartTwo];
//        }
//        
//        
//    }
//    
//    DBManagerReports *dbMngr = [[DBManagerReports alloc]init];
//    
//    // self.wormDataInns1Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"1"];
//    // self.wormDataInns2Array = [dbMngr retrieveWormChartDetails :self.matchCode :self.compititionCode :@"2"];
//    self.wormDataInns1Array = [self generateInningsArray :@"1"];
//    self.wormDataInns2Array =[self generateInningsArray :@"2"];
//    
//
     //wicketDetail = [self getwicket:self.compititionCode :self.matchCode:innings1];
//    objinnings1Wicket = [self getwicket:self.compititionCode :self.matchCode:@"1"];
//    objinnings2wicket = [self getwicket:self.compititionCode :self.matchCode:@"2"];
//    
//    int tag = 0;
//    //Set tag for tool tip
//    
//    for(ManhattenWKTRecord * wick in objinnings1Wicket){
//        wick.tag =[NSNumber numberWithInt:tag];
//        tag++;
//    }
//    
//    for(ManhattenWKTRecord *wick in objinnings2wicket){
//        wick.tag =[NSNumber numberWithInt:tag];
//        tag++;
//    }
//    
//    
////    if([self.objinnings1Wicket count]>0 || [self.objinnings2wicket count]>0){
////        [self setChartOne];
////    }
//    
//    
//    
//  //  if([self isTestMatch]){//Test
//        
//        objinnings3Wicket = [self getwicket:self.compititionCode :self.matchCode:@"3"];
//        objinnings4wicket = [self getwicket:self.compititionCode :self.matchCode:@"4"];
//        
//        //self.wormDataInns3Array =[self generateInningsArray :@"3"];
//       // self.wormDataInns4Array  =[self generateInningsArray:@"4"];
//        
////        
////        self.wicketInnsThree = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"3"];
////        self.wicketInnsFour = [dbMngr retrieveWormWicketDetails :self.matchCode :self.compititionCode :@"4"];
//        
//        
//        
//        for(ManhattenWKTRecord *wick in objinnings3Wicket){
//            wick.tag =[NSNumber numberWithInt:tag];
//            tag++;
//        }
//        
//        
//        for(ManhattenWKTRecord *wick in objinnings4wicket){
//            wick.tag =[NSNumber numberWithInt:tag];
//            tag++;
//        }
    
        
//        if([self.wormDataInns3Array count]>0 || [self.wormDataInns4Array count]>0){
//            [self setChartTwo];
//        }
        
        
  //  }
    

    
    
//    NSPredicate* wicketinnings2Predicate = [NSPredicate predicateWithFormat:@"inningsno == %@",innings2];
//    
//    NSArray * Innings2wicket = [wicketDetail filteredArrayUsingPredicate:wicketinnings2Predicate];
//    
//    objinnings2wicket =[Innings2wicket copy];
//    

    
    ToolTipDetails =[self getToolTip:self.compititionCode :self.matchCode];
    

  }


-(void) BarChartMethodFirstInnigs
{
    
    
    id max = [objRunArray valueForKeyPath:@"@max.intValue"];
    
    _titles = objOverArray;
    _dataSource = objRunArray;
    
    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView.tag = 111;
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.maxValue = max;
   // _barChartView.unitOfYAxis = @"Run";
    
    _barChartView.colorOfXAxis = [UIColor whiteColor];
    _barChartView.colorOfXText = [UIColor whiteColor];
    _barChartView.colorOfYAxis = [UIColor whiteColor];
    _barChartView.colorOfYText = [UIColor whiteColor];
    [self.manhattan_Scroll addSubview:_barChartView];
    
    UIView * tittleview =[[UIView alloc]initWithFrame:CGRectMake(_barChartView.frame.origin.x, _barChartView.frame.origin.y-40,self.view.frame.size.width, 60)];
    
    UILabel * title_lbl =[[UILabel alloc]initWithFrame:CGRectMake(70, 0,self.view.frame.size.width, 40)];
    
    title_lbl.text =@"INNINGS 1";
    title_lbl.textColor =[UIColor whiteColor];
    title_lbl.textAlignment=UITextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:25];

    [tittleview addSubview:title_lbl];
    
    UILabel * BattingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(tittleview.frame.size.width/2.9,title_lbl.frame.origin.y+30,self.manhattan_Scroll.frame.size.width/2, 40)];
    BattingTeam_lbl.text =self.fstInnShortName;
    BattingTeam_lbl.textColor =[UIColor whiteColor];
    BattingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BattingTeam_lbl.font = [UIFont systemFontOfSize:23];

    
    [tittleview addSubview:BattingTeam_lbl];
    
//    UILabel * BowlingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+100,title_lbl.frame.origin.y+30,self.manhattan_Scroll.frame.size.width/2, 40)];
//    BowlingTeam_lbl.text =self.secInnShortName;
//    BowlingTeam_lbl.textColor =[UIColor whiteColor];
//    BowlingTeam_lbl.textAlignment=UITextAlignmentCenter;
//    BowlingTeam_lbl.font = [UIFont systemFontOfSize:23];
//
//    
//    [tittleview addSubview:BowlingTeam_lbl];

    [self.manhattan_Scroll addSubview: tittleview];
}

-(void) BarChartMethodFirstInnigs2
{
    id max = [objInnings2RunArray valueForKeyPath:@"@max.intValue"];
    _titles = objInnings2OverArray;
    _dataSource = objInnings2RunArray;
    
    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(20, 450, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView.tag = 112;
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.maxValue = max;
  //  _barChartView.unitOfYAxis = @"Run";
    
    _barChartView.colorOfXAxis = [UIColor whiteColor];
    _barChartView.colorOfXText = [UIColor whiteColor];
    _barChartView.colorOfYAxis = [UIColor whiteColor];
    _barChartView.colorOfYText = [UIColor whiteColor];
    [self.manhattan_Scroll addSubview:_barChartView];
    
    UIView * tittleview =[[UIView alloc]initWithFrame:CGRectMake(_barChartView.frame.origin.x, _barChartView.frame.origin.y-80,self.view.frame.size.width, 60)];
    
    UILabel * title_lbl =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.manhattan_Scroll.frame.size.width, 40)];
    title_lbl.text =@"INNINGS 2";
    title_lbl.textColor =[UIColor whiteColor];
    title_lbl.textAlignment=UITextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:25];

    [tittleview addSubview:title_lbl];
    
    UILabel * BattingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(tittleview.frame.size.width/4,title_lbl.frame.origin.y+25,self.manhattan_Scroll.frame.size.width/2, 40)];
    BattingTeam_lbl.text =self.secInnShortName;
    BattingTeam_lbl.textColor =[UIColor whiteColor];
    BattingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BattingTeam_lbl.font = [UIFont systemFontOfSize:23];

    [tittleview addSubview:BattingTeam_lbl];
    
//    UILabel * BowlingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,title_lbl.frame.origin.y+20,self.manhattan_Scroll.frame.size.width/2, 40)];
//    BowlingTeam_lbl.text =self.thrdInnShortName;
//    BowlingTeam_lbl.textColor =[UIColor whiteColor];
//    BowlingTeam_lbl.textAlignment=UITextAlignmentCenter;
//    BowlingTeam_lbl.font = [UIFont systemFontOfSize:23];
//
//    [tittleview addSubview:BowlingTeam_lbl];
    
    [self.manhattan_Scroll addSubview: tittleview];
}

-(void) BarChartMethodFirstInnigs3
{
    
    id max = [objInnings3RunArray valueForKeyPath:@"@max.intValue"];

    _titles = objInnings3OverArray;
    _dataSource = objInnings3RunArray;
    
    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(20, 810, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView.tag = 113;
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.maxValue = max;
   // _barChartView.unitOfYAxis = @"Run";
    
    _barChartView.colorOfXAxis = [UIColor whiteColor];
    _barChartView.colorOfXText = [UIColor whiteColor];
    _barChartView.colorOfYAxis = [UIColor whiteColor];
    _barChartView.colorOfYText = [UIColor whiteColor];
    [self.manhattan_Scroll addSubview:_barChartView];
    
    UIView * tittleview =[[UIView alloc]initWithFrame:CGRectMake(_barChartView.frame.origin.x, _barChartView.frame.origin.y-80,self.view.frame.size.width, 60)];
    
    UILabel * title_lbl =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.manhattan_Scroll.frame.size.width, 40)];
    title_lbl.text =@"INNINGS 3";
    title_lbl.textColor =[UIColor whiteColor];
    title_lbl.textAlignment=UITextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:25];
    [tittleview addSubview:title_lbl];
    
    UILabel * BattingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(tittleview.frame.size.width/4,title_lbl.frame.origin.y+25,self.manhattan_Scroll.frame.size.width/2, 40)];
    BattingTeam_lbl.text =self.thrdInnShortName;
    BattingTeam_lbl.textColor =[UIColor whiteColor];
    BattingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BattingTeam_lbl.font = [UIFont systemFontOfSize:23];

    [tittleview addSubview:BattingTeam_lbl];
    
//    UILabel * BowlingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,title_lbl.frame.origin.y+20,self.manhattan_Scroll.frame.size.width/2, 40)];
//    BowlingTeam_lbl.text =self.frthInnShortName;
//    BowlingTeam_lbl.textColor =[UIColor whiteColor];
//    BowlingTeam_lbl.textAlignment=UITextAlignmentCenter;
//    BowlingTeam_lbl.font = [UIFont systemFontOfSize:23];
//
//    [tittleview addSubview:BowlingTeam_lbl];
//    
    [self.manhattan_Scroll addSubview: tittleview];
}

-(void) BarChartMethodFirstInnigs4
{
    
    id max = [objInnings4RunArray valueForKeyPath:@"@max.intValue"];

    _titles = objInnings4OverArray;
    _dataSource = objInnings4RunArray;
    
    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(20, 1140, [UIScreen mainScreen].bounds.size.width, 260)];
    _barChartView.tag = 114;
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.maxValue = max;
   // _barChartView.unitOfYAxis = @"Run";
    
    _barChartView.colorOfXAxis = [UIColor whiteColor];
    _barChartView.colorOfXText = [UIColor whiteColor];
    _barChartView.colorOfYAxis = [UIColor whiteColor];
    _barChartView.colorOfYText = [UIColor whiteColor];
    [self.manhattan_Scroll addSubview:_barChartView];
    
    UIView * tittleview =[[UIView alloc]initWithFrame:CGRectMake(_barChartView.frame.origin.x, _barChartView.frame.origin.y-60,self.view.frame.size.width, 60)];
    
    UILabel * title_lbl =[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.manhattan_Scroll.frame.size.width, 40)];
    title_lbl.text =@"INNINGS 4";
    title_lbl.textColor =[UIColor whiteColor];
    title_lbl.textAlignment=UITextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:25];
    
    [tittleview addSubview:title_lbl];
    
    UILabel * BattingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(tittleview.frame.size.width/4,title_lbl.frame.origin.y+25,self.manhattan_Scroll.frame.size.width/2, 40)];
    BattingTeam_lbl.text =self.frthInnShortName;
    BattingTeam_lbl.textColor =[UIColor whiteColor];
    BattingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BattingTeam_lbl.font = [UIFont systemFontOfSize:23];
    [tittleview addSubview:BattingTeam_lbl];
    
//    UILabel * BowlingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,title_lbl.frame.origin.y+20,self.manhattan_Scroll.frame.size.width/2, 40)];
//    BowlingTeam_lbl.text =self.fstInnShortName;
//    BowlingTeam_lbl.textColor =[UIColor whiteColor];
//    BowlingTeam_lbl.textAlignment=UITextAlignmentCenter;
//    BowlingTeam_lbl.font = [UIFont systemFontOfSize:23];
//
//    [tittleview addSubview:BowlingTeam_lbl];
//    
    [self.manhattan_Scroll addSubview: tittleview];
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
                record.teamcode=[self getValueByNull:statement :2];
                record.teamname=[self getValueByNull:statement :3];
                
                record.inningsno=[self getValueByNull:statement :4];
                
                record.overno=[self getValueByNull:statement :5];
                
                record.wickets=[self getValueByNull:statement :6];
                
                record.runs=[self getValueByNull:statement :7];
                
                record.score=[self getValueByNull:statement :8];
                
                record.ispowerplay=[self getValueByNull:statement :9];
                record.powerplayType=[self getValueByNull:statement :10];
                
                [getManhattendetail addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return getManhattendetail;
}

-(NSMutableArray *)getwicket:(NSString *)compitioncode :(NSString *) matchcode:(NSString *)inningsno
{
    NSMutableArray * getWicketdetail=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT   BAT.INNINGSNO, BAT.BATSMANCODE  , BAT.BOWLERCODE, BATSMANNAME , BAT.RUNS, BALLS , BOWLERNAME, WICKETDESCRIPTION, WICKETNO, (BE.BALLNO) AS WICKETBALLNO, WICKETSCORE, WICKETTYPEDESCRIPTION ,(BE.OVERNO+1) AS WICKETOVERNO,WICKETBALLNO FROM (SELECT BS.BATTINGPOSITIONNO, BS.BATSMANCODE, BMC.PLAYERNAME BATSMANNAME,BS.BOWLERCODE, BWLC.PLAYERNAME BOWLERNAME, CAST(BS.RUNS AS NVARCHAR) RUNS, CAST(BS.BALLS AS NVARCHAR) BALLS, CASE BS.WICKETTYPE WHEN 'MSC095' THEN 'c ' + FLDRC.PLAYERNAME + ' b ' + BWLC.PLAYERNAME WHEN 'MSC096' THEN 'b ' + BWLC.PLAYERNAME WHEN 'MSC097' THEN 'run out ' + FLDRC.PLAYERNAME WHEN 'MSC104' THEN 'st ' + FLDRC.PLAYERNAME + ' b '+ BWLC.PLAYERNAME WHEN 'MSC098' THEN 'lbw ' + BWLC.PLAYERNAME WHEN 'MSC099' THEN 'hit wicket' +' '+ BWLC.PLAYERNAME WHEN 'MSC100' THEN 'Handled the ball' WHEN 'MSC105' THEN 'c & b' +' '+ BWLC.PLAYERNAME WHEN 'MSC101' THEN 'Timed Out' WHEN 'MSC102' THEN 'Retired Hurt' WHEN 'MSC103' THEN 'Hitting Twice' WHEN 'MSC107' THEN 'Mankading' WHEN 'MSC108' THEN 'Retired Out' WHEN 'MSC106' THEN 'Obstructing the field' WHEN 'MSC133' THEN 'Absent Hurt' ELSE 'Not Out' END AS WICKETDESCRIPTION, BS.WICKETNO WICKETNO, CAST(BS.WICKETOVERNO AS NVARCHAR)+1 WICKETOVERNO, CAST(BS.WICKETBALLNO AS NVARCHAR) WICKETBALLNO, CAST(BS.WICKETSCORE AS NVARCHAR) WICKETSCORE, MDWT.METASUBCODEDESCRIPTION WICKETTYPEDESCRIPTION, BS.INNINGSNO,WE.BALLCODE AS BALLCODE  FROM	  BATTINGSUMMARY BS INNER JOIN PLAYERMASTER BMC  ON BMC.PLAYERCODE = BS.BATSMANCODE LEFT JOIN PLAYERMASTER BWLC   ON BWLC.PLAYERCODE = BS.BOWLERCODE LEFT JOIN PLAYERMASTER FLDRC   ON FLDRC.PLAYERCODE = BS.FIELDERCODE LEFT JOIN METADATA MDWT   ON BS.WICKETTYPE = MDWT.METASUBCODE LEFT JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE=BS.COMPETITIONCODE  AND WE.MATCHCODE=BS.MATCHCODE AND WE.INNINGSNO =BS.INNINGSNO  AND WE.WICKETPLAYER=BS.BATSMANCODE  WHERE ('' = '%@' OR  BS.COMPETITIONCODE = '%@') AND BS.MATCHCODE = '%@' AND ('%@' = '' OR  BS.INNINGSNO = '%@')  AND BS.WICKETNO IS NOT NULL GROUP BY BS.BATSMANCODE, BMC.PLAYERNAME, BS.BOWLERCODE,BS.RUNS, BS.BALLS, BS.WICKETTYPE, BS.WICKETNO, BS.WICKETOVERNO, BS.WICKETBALLNO, BS.WICKETSCORE, FLDRC.PLAYERNAME, BWLC.PLAYERNAME, BS.BATTINGPOSITIONNO, MDWT.METASUBCODEDESCRIPTION  , BS.INNINGSNO) BAT INNER JOIN BALLEVENTS BE ON  BE.BALLCODE =BAT.BALLCODE ORDER BY WICKETNO;",compitioncode,compitioncode,matchcode,inningsno,inningsno];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                ManhattenWKTRecord *record=[[ManhattenWKTRecord alloc]init];
                record.inningno = [self getValueByNull:statement :0];
                record.batsmancode=[self getValueByNull:statement :1];
                record.bowlercode=[self getValueByNull:statement :2];
                record.batsmanname=[self getValueByNull:statement :3];
                
                record.Run=[self getValueByNull:statement :4];
                
                record.balls=[self getValueByNull:statement :5];
                
                record.bowlername=[self getValueByNull:statement :6];
                
                record.wicketdescription=[self getValueByNull:statement :7];
                
                record.wicketno=[self getValueByNull:statement :8];
                
                record.wicketballno=[self getValueByNull:statement :9];
                record.wicketscore=[self getValueByNull:statement :10];
                record.wickettypedescription=[self getValueByNull:statement :11];
                record.wicketoverno=[self getValueByNull:statement :12];
            
                
                
                [getWicketdetail addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return getWicketdetail;

}



- (NSInteger)numberOfSectionsInBarChartView:(MCBarChartView *)barChartView {
    
    return [_dataSource count];
  
    
}

- (NSInteger)barChartView:(MCBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section {
    return 1;
    
}

- (id)barChartView:(MCBarChartView *)barChartView valueOfBarInSection:(NSInteger)section index:(NSInteger)index {
    return _dataSource[section];
   
}

- (UIColor *)barChartView:(MCBarChartView *)barChartView colorOfBarInSection:(NSInteger)section index:(NSInteger)index {
    
    return [UIColor colorWithRed:35/255.0 green:116/255.0 blue:205/255.0 alpha:1.0];
    
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

- (NSMutableArray *)barChartView:(MCBarChartView *)barChartView informationOfWicketInSection:(NSInteger)section
{
    if(barChartView.tag == 111)
    {
    return objinnings1Wicket;
    }
    else if(barChartView.tag==112)
    {
        return objinnings2wicket;
    }
    else if(barChartView.tag==113)
    {
        return objinnings3Wicket;
    }
    else if(barChartView.tag==114)
    {
        return objinnings4wicket;
    }
    else{
    return nil;
    }
}


- (CGFloat)barWidthInBarChartView:(MCBarChartView *)barChartView {
        return 26;
    
}

- (CGFloat)paddingForSectionInBarChartView:(MCBarChartView *)barChartView {
    return 24;
   
}

-(NSMutableArray *) getToolTip :(NSString *) compitioncode :(NSString *) matchcode
{
    NSMutableArray * getTooltipdetail=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT   BAT.INNINGSNO, BAT.BATSMANCODE  , BAT.BOWLERCODE, BATSMANNAME , BAT.RUNS, BALLS , BOWLERNAME, WICKETDESCRIPTION, WICKETNO, (BE.BALLNO) AS WICKETBALLNO, WICKETSCORE, WICKETTYPEDESCRIPTION ,(BE.OVERNO+1) AS WICKETOVERNO FROM (SELECT BS.BATTINGPOSITIONNO, BS.BATSMANCODE, BMC.PLAYERNAME BATSMANNAME,BS.BOWLERCODE, BWLC.PLAYERNAME BOWLERNAME, CAST(BS.RUNS AS NVARCHAR) RUNS, CAST(BS.BALLS AS NVARCHAR) BALLS, CASE BS.WICKETTYPE WHEN 'MSC095' THEN 'c ' + FLDRC.PLAYERNAME + ' b ' + BWLC.PLAYERNAME WHEN 'MSC096' THEN 'b ' + BWLC.PLAYERNAME WHEN 'MSC097' THEN 'run out ' + FLDRC.PLAYERNAME WHEN 'MSC104' THEN 'st ' + FLDRC.PLAYERNAME + ' b '+ BWLC.PLAYERNAME WHEN 'MSC098' THEN 'lbw ' + BWLC.PLAYERNAME WHEN 'MSC099' THEN 'hit wicket' +' '+ BWLC.PLAYERNAME WHEN 'MSC100' THEN 'Handled the ball' WHEN 'MSC105' THEN 'c & b' +' '+ BWLC.PLAYERNAME WHEN 'MSC101' THEN 'Timed Out' WHEN 'MSC102' THEN 'Retired Hurt' WHEN 'MSC103' THEN 'Hitting Twice' WHEN 'MSC107' THEN 'Mankading' WHEN 'MSC108' THEN 'Retired Out' WHEN 'MSC106' THEN 'Obstructing the field' WHEN 'MSC133' THEN 'Absent Hurt' ELSE 'Not Out' END AS WICKETDESCRIPTION, BS.WICKETNO WICKETNO, CAST(BS.WICKETOVERNO AS NVARCHAR)+1 WICKETOVERNO, CAST(BS.WICKETBALLNO AS NVARCHAR) WICKETBALLNO, CAST(BS.WICKETSCORE AS NVARCHAR) WICKETSCORE, MDWT.METASUBCODEDESCRIPTION WICKETTYPEDESCRIPTION, BS.INNINGSNO,WE.BALLCODE AS BALLCODE FROM BATTINGSUMMARY BS INNER JOIN PLAYERMASTER BMC  ON BMC.PLAYERCODE = BS.BATSMANCODE LEFT JOIN PLAYERMASTER BWLC   ON BWLC.PLAYERCODE = BS.BOWLERCODE LEFT JOIN PLAYERMASTER FLDRC   ON FLDRC.PLAYERCODE = BS.FIELDERCODE LEFT JOIN METADATA MDWT   ON BS.WICKETTYPE = MDWT.METASUBCODE LEFT JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE=BS.COMPETITIONCODE  AND WE.MATCHCODE=BS.MATCHCODE AND WE.INNINGSNO =BS.INNINGSNO  AND WE.WICKETPLAYER=BS.BATSMANCODE WHERE ('' = '%@' OR  BS.COMPETITIONCODE = '%@') AND BS.MATCHCODE = '%@' AND BS.WICKETNO IS NOT NULL GROUP BY BS.BATSMANCODE, BMC.PLAYERNAME, BS.BOWLERCODE,BS.RUNS, BS.BALLS, BS.WICKETTYPE, BS.WICKETNO, BS.WICKETOVERNO, BS.WICKETBALLNO, BS.WICKETSCORE , FLDRC.PLAYERNAME, BWLC.PLAYERNAME, BS.BATTINGPOSITIONNO, MDWT.METASUBCODEDESCRIPTION  , BS.INNINGSNO,WE.BALLCODE) BAT INNER JOIN BALLEVENTS BE ON  BE.BALLCODE =BAT.BALLCODE ORDER BY WICKETNO;",compitioncode,compitioncode,matchcode];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                ToolTipRecord *record=[[ToolTipRecord alloc]init];
                record.inningsno = [self getValueByNull:statement :0];
                record.batsmancode=[self getValueByNull:statement :1];
                record.bowlercode=[self getValueByNull:statement :2];
                record.batsmanname=[self getValueByNull:statement :3];
                
                record.runs=[self getValueByNull:statement :4];
                
                record.balls=[self getValueByNull:statement :5];
                
                record.bowlername=[self getValueByNull:statement :6];
                
                record.wicketdescription=[self getValueByNull:statement :7];
                
                record.wicketno=[self getValueByNull:statement :8];
                
                record.wicketballno=[self getValueByNull:statement :9];
                
                record.wicketscore=[self getValueByNull:statement :10];
                
                record.wickettypedescription=[self getValueByNull:statement :11];
                
                record.wicketoverno=[self getValueByNull:statement :12];
                
                [getTooltipdetail addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return getTooltipdetail;

}

-(void) TooltipMethod :(UIButton *)selectwicket
{
    NSLog(@"%@",selectwicket);
   
    if(tooltip_view !=nil)
    {
        [tooltip_view removeFromSuperview];
    }
    ToolTipRecord * wicketdetail =[ToolTipDetails objectAtIndex:selectwicket.tag-1];
    if([wicketdetail.inningsno  isEqual: @"1"])
    {
    
   tooltip_view =[[UIView alloc]initWithFrame:CGRectMake(selectwicket.frame.origin.x+50,selectwicket.frame.origin.y-80, 200, 140)];
    }
    else if ([wicketdetail.inningsno  isEqual: @"2"])
    {
        tooltip_view =[[UIView alloc]initWithFrame:CGRectMake(selectwicket.frame.origin.x+50,selectwicket.frame.origin.y*2.7, 200, 140)];
    }
    else if ([wicketdetail.inningsno  isEqual: @"3"])
    {
        tooltip_view =[[UIView alloc]initWithFrame:CGRectMake(selectwicket.frame.origin.x+50,selectwicket.frame.origin.y*4.7, 200, 140)];
    }
    else if ([wicketdetail.inningsno  isEqual: @"4"])
    {
        tooltip_view =[[UIView alloc]initWithFrame:CGRectMake(selectwicket.frame.origin.x+50,selectwicket.frame.origin.y*6.7, 200, 140)];
    }
    [tooltip_view setBackgroundColor:[UIColor clearColor]];
    [self.manhattan_Scroll addSubview:tooltip_view];
    
    tooltip_view.layer.borderColor = [UIColor whiteColor].CGColor;
    tooltip_view.layer.borderWidth = 2.0f;
    
    UILabel * objwicketText =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, tooltip_view.frame.size.width,tooltip_view.frame.size.height)];
    objwicketText.numberOfLines=10;
    objwicketText.textColor =[UIColor whiteColor];
    
    //ToolTipRecord * wicketdetail =[ToolTipDetails objectAtIndex:selectwicket.tag-1];
    objwicketText.text = [NSString stringWithFormat:@" Team Score : %@,\n Bowler Name : %@,\n overno : %@,\n Runs : %@,\n Wicket : %@ ",wicketdetail.wicketscore,wicketdetail.bowlername,wicketdetail.wicketoverno,wicketdetail.runs,wicketdetail.wicketno];
    //objwicketText.textAlignment =UITextAlignmentCenter;
    [tooltip_view addSubview:objwicketText];
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(hidepopview)
                                   userInfo:nil
                                    repeats:NO];
}

- (NSString *) getWicketDetails: (UIButton *) selectwicket{
    ManhattenWKTRecord * wicketdetail = [self getWicketByTag:selectwicket.tag];
    
    return [NSString stringWithFormat:@" Team Score : %@,\n Bowler Name : %@,\n overno : %@,\n Runs : %@,\n Wicket : %@ ",wicketdetail.wicketscore,wicketdetail.bowlername,wicketdetail.wicketoverno,wicketdetail.Run,wicketdetail.wicketno];
    
}

-(bool) isTestMatch {
    if([self.matchTypecode isEqual:@"MSC114"] || [self.matchTypecode isEqual:@"MSC023"]){//Test
        return YES;
    }
    return NO;
}
-(ManhattenWKTRecord *) getWicketByTag:(NSInteger) tag{
    
    for(ManhattenWKTRecord *wick in objinnings1Wicket){
        if([wick.tag integerValue] == tag){
            return wick;
        }
    }
    
    for(ManhattenWKTRecord *wick in objinnings2wicket){
        if([wick.tag integerValue] == tag){
            return wick;
        }
    }
    
        for(ManhattenWKTRecord *wick in objinnings3Wicket){
            if([wick.tag integerValue] == tag){
                return wick;
            }
        }
        
        for(ManhattenWKTRecord *wick in objinnings4wicket){
            if([wick.tag integerValue] == tag){
                return wick;
            }
        }

    
    return nil;
}

-(void)hidepopview
{
    if(tooltip_view !=nil)
    {
        [tooltip_view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
