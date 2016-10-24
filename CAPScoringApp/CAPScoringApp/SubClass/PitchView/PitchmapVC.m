//
//  PitchmapViewViewController.m
//  CAPScoringApp
//
//  Created by APPLE on 20/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PitchmapVC.h"
#import "DBManagerpitchmapReport.h"
#import "StrikerDetails.h"
#import "LineReportRecord.h"
#import "LengthReportRecord.h"

@interface PitchmapVC ()
{
    BOOL isStriker;
    BOOL isLength;
    BOOL isLine;
    DBManagerpitchmapReport * DBMpitchReport;
}

@property (nonatomic,strong) NSString * teamCode;

@property (nonatomic,strong) NSString * selectStrikerCode;
@property (nonatomic,strong) NSString * selectLineCode;
@property (nonatomic,strong) NSString * selectLengthCode;



@property (nonatomic,strong) NSMutableArray * lineArray;
@property (nonatomic,strong) NSMutableArray * lengthArray;
@property (nonatomic,strong) NSMutableArray * strickerArray;

@end

@implementation PitchmapVC
@synthesize lineArray,lengthArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lineArray =[[NSMutableArray alloc]init];
    lengthArray =[[NSMutableArray alloc]init];
    
    
    
    self.filter_view.hidden =YES;
    
    [self.striker_view .layer setBorderWidth:2.0];
    [self.striker_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.striker_view .layer setMasksToBounds:YES];
    
    [self.line_Vew .layer setBorderWidth:2.0];
    [self.line_Vew.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.line_Vew .layer setMasksToBounds:YES];
    
    [self.length_View .layer setBorderWidth:2.0];
    [self.length_View.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.length_View .layer setMasksToBounds:YES];
    
     self.striker_Tbl.hidden=YES;
    DBMpitchReport =[[DBManagerpitchmapReport alloc]init];
    
    lineArray =[DBMpitchReport getLine];
    lengthArray =[DBMpitchReport getLength];
    
    [self.Inn1_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray * objPitchdetail=[DBMpitchReport getPitchmapdetails:self.matchTypecode :self.compititionCode :self.matchCode :_teamCode :@"1" :@"" :@"" :self.selectStrikerCode :@"" :@"" :@"" :@"" :@"" :@"":@"" :@"0" :@"0" :@"0" :@"0" :@"0" :@"0" :@"0" :@"0" :@"0" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@""];
    
    
    
}

-(IBAction)didClickInns1:(id)sender
{
   self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
}

-(IBAction)didClickInns2:(id)sender
{
    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"2"];
}

-(IBAction)didClickInns3:(id)sender
{
    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"3"];
}

-(IBAction)didClickInns4:(id)sender
{
    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"4"];
}

-(IBAction)didclickShowFilerviewbtn:(id)sender
{
    self.filter_view.hidden =NO;
}

-(IBAction)didclickStrikerSelection:(id)sender
{
    self.strikerTblYposition.constant =self.striker_view.frame.origin.y;
    self.strickerArray=[[NSMutableArray alloc]init];
    self.strickerArray= [DBMpitchReport getStrickerdetail:self.matchCode :_teamCode];
   
    if(isStriker==NO)
    {
        
        self.striker_Tbl.hidden=NO;
        isStriker=YES;
        
    }
    else
    {
        self.striker_Tbl.hidden=YES;
        isStriker=NO;
    }
    isLine=NO;
    isLength =NO;
    [self.striker_Tbl reloadData];

}

-(IBAction)didclicklengthSelection:(id)sender
{
    self.strikerTblYposition.constant =self.length_View.frame.origin.y;
    
    if(isLength==NO)
    {
        self.striker_Tbl.hidden=NO;
        isLength=YES;
        
        
    }
    else
    {
        self.striker_Tbl.hidden=YES;
        isLength=NO;
    }

    isLine=NO;
    isStriker =NO;
    [self.striker_Tbl reloadData];

}

-(IBAction)DidclicklineSelection:(id)sender
{
    self.strikerTblYposition.constant =self.line_Vew.frame.origin.y;
    
    if(isLine==NO)
    {
        self.striker_Tbl.hidden=NO;
        isLine=YES;
    }
    else
    {
        self.striker_Tbl.hidden=YES;
        isLine=NO;
    }
    isLength=NO;
    isStriker =NO;
    [self.striker_Tbl reloadData];

}

-(IBAction)didClickAllRuns:(id)sender
{
    [self.all_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
}

-(IBAction)didSelectrun1:(id)sender
{
    [self.Run1_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

    

}
-(IBAction)didSelectrun2:(id)sender
{
    [self.Run2_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

}
-(IBAction)didClickSelectrun3:(id)sender
{
    [self.Run3_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

}
-(IBAction)didSelectrun4:(id)sender
{
    [self.Run4_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

    
}
-(IBAction)didClickSelectrun6:(id)sender
{
    [self.Run6_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

}
-(IBAction)didSelectBalls:(id)sender
{
    [self.ball_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.dotball_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.wicket_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
}
-(IBAction)didSelectDotBall:(id)sender
{
    [self.dotball_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.ball_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.wicket_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    
}
-(IBAction)didSelectWicket:(id)sender
{
    [self.wicket_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.dotball_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.ball_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    
}

-(IBAction)didClickHidefilterBtn:(id)sender
{
    self.filter_view.hidden=YES;
}
-(IBAction)didClickStandard:(id)sender
{
    self.statistics_Btn.backgroundColor=[UIColor clearColor];
    self.standard_Btn.backgroundColor=[UIColor blackColor];
}

-(IBAction)didClickStatistics:(id)sender
{
    self.statistics_Btn.backgroundColor=[UIColor blackColor];
    self.standard_Btn.backgroundColor=[UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(isStriker == YES)
    {
        return self.strickerArray.count;
    }
    else if(isLine == YES)
    {
        return self.lineArray.count;
    }
    else if(isLength == YES)
    {
        return self.lengthArray.count;
    }
    
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
    }
    if(isStriker == YES)
    {

        StrikerDetails * objStriker =[self.strickerArray objectAtIndex:indexPath.row];
        cell.textLabel.text =objStriker.playername;
    }
    else if(isLine == YES)
    {
        LineReportRecord * objLine =[self.lineArray objectAtIndex:indexPath.row];
        cell.textLabel.text = objLine.metasubcodedescription;
    }
    else if (isLength == YES)
    {
        LengthReportRecord * objLength =[self.lengthArray objectAtIndex:indexPath.row];
        cell.textLabel.text = objLength.metasubcodedescription;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isStriker == YES)
    {
        
        StrikerDetails * objStriker =[self.strickerArray objectAtIndex:indexPath.row];
        self.selectStrikerCode =objStriker.playercode;
    }
    else if(isLine == YES)
    {
        LineReportRecord * objLine =[self.lineArray objectAtIndex:indexPath.row];
        self.selectLineCode= objLine.metasubcode;
    }
    else if (isLength == YES)
    {
        LengthReportRecord * objLength =[self.lengthArray objectAtIndex:indexPath.row];
        self.selectLengthCode = objLength.metasubcode;
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
