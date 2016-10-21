//
//  PitchmapViewViewController.m
//  CAPScoringApp
//
//  Created by APPLE on 20/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PitchmapVC.h"
#import "DBManagerpitchmapReport.h"

@interface PitchmapVC ()
{
    BOOL isStriker;
    BOOL isLength;
    BOOL isLine;
    DBManagerpitchmapReport * DBMpitchReport;
}

@property (nonatomic,strong) NSString * teamCode;
@property (nonatomic,strong) NSMutableArray * lineArray;
@property (nonatomic,strong) NSMutableArray * lengthArray;

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
