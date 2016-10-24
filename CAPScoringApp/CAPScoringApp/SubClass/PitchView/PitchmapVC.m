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
#import "PitchReportdetailRecord.h"

@interface PitchmapVC ()
{
    BOOL isStriker;
    BOOL isLength;
    BOOL isLine;
    DBManagerpitchmapReport * DBMpitchReport;
     UIImageView * Img_ball;
}

@property (nonatomic,strong) NSString * teamCode;

@property (nonatomic,strong) NSString * selectStrikerCode;
@property (nonatomic,strong) NSString * selectLineCode;
@property (nonatomic,strong) NSString * selectLengthCode;



@property (nonatomic,strong) NSMutableArray * lineArray;
@property (nonatomic,strong) NSMutableArray * lengthArray;
@property (nonatomic,strong) NSMutableArray * strickerArray;

@property (nonatomic,strong) NSString * lnningsno;
@property (nonatomic,strong) NSString * selectRun;

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
    self.lnningsno=@"1";
    self.selectStrikerCode =(self.selectStrikerCode !=nil)?self.selectStrikerCode :@"";
    self.selectRun=@"";
    self.selectLengthCode =@"";
    self.selectLineCode = @"";
    [self drawpitchMethod];
}

-(void)drawpitchMethod
{
    
    for(UIImageView * obj in [self.pitch_Img subviews])
    {
        NSLog(@"%@",obj);
        [obj removeFromSuperview];
    }

    
    NSMutableArray * objPitchdetail=[DBMpitchReport getPitchmapdetails :self.matchTypecode :self.compititionCode :self.matchCode :_teamCode :self.lnningsno  :self.selectStrikerCode : self.selectRun: self.selectLineCode : self.selectLengthCode];
    
    int xposition;
    int yposition;
    
   
    for(int i=0; i<objPitchdetail.count;i++)
    {
        PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMY2 intValue];
        
        if(!(xposition == 1 && yposition ==1)){
            
            
            //        if(Img_ball != nil)
            //        {
            //            [Img_ball removeFromSuperview];
            //        }
            //
            Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+(xposition/1.2),yposition+(yposition/4),20, 20)];
            Img_ball.image =[UIImage imageNamed:@"RedBall"];
            [self.pitch_Img addSubview:Img_ball];
            
            
        }
    }
}

-(IBAction)didClickInns1:(id)sender
{
    self.lnningsno=@"1";
    [self.Inn1_Btn setBackgroundColor:[UIColor blueColor]];
    [self.Inn2_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn3_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn4_Btn setBackgroundColor:[UIColor clearColor]];
    
    
   self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
}

-(IBAction)didClickInns2:(id)sender
{
    self.lnningsno=@"2";
    [self.Inn2_Btn setBackgroundColor:[UIColor blueColor]];
    [self.Inn1_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn3_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn4_Btn setBackgroundColor:[UIColor clearColor]];

    

    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"2"];
}

-(IBAction)didClickInns3:(id)sender
{
    self.lnningsno=@"3";
    [self.Inn3_Btn setBackgroundColor:[UIColor blueColor]];
    [self.Inn1_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn2_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn4_Btn setBackgroundColor:[UIColor clearColor]];

    
    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"3"];
}

-(IBAction)didClickInns4:(id)sender
{
    self.lnningsno=@"4";
    [self.Inn4_Btn setBackgroundColor:[UIColor blueColor]];
    [self.Inn1_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn2_Btn setBackgroundColor:[UIColor clearColor]];
    [self.Inn3_Btn setBackgroundColor:[UIColor clearColor]];

    
    
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
    self.selectRun =@"1";
    [self.Run1_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

    

}
-(IBAction)didSelectrun2:(id)sender
{
    self.selectRun =@"2";
    [self.Run2_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

}
-(IBAction)didClickSelectrun3:(id)sender
{
    self.selectRun =@"3";
    [self.Run3_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run4_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

}
-(IBAction)didSelectrun4:(id)sender
{
      self.selectRun =@"4";
    [self.Run4_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.all_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run1_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run2_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run3_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.Run6_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];

    
}
-(IBAction)didClickSelectrun6:(id)sender
{
     self.selectRun =@"6";
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
    [self drawpitchMethod];
    
}
-(IBAction)didClickStandard:(id)sender
{
    self.statistics_Btn.backgroundColor=[UIColor clearColor];
    self.standard_Btn.backgroundColor=[UIColor blackColor];
    [self Stardardpitchmap];
    
}

-(IBAction)didClickStatistics:(id)sender
{
    self.statistics_Btn.backgroundColor=[UIColor blackColor];
    self.standard_Btn.backgroundColor=[UIColor clearColor];
    
}

-(void)Stardardpitchmap;
{
    
    for(UIImageView * obj in [self.pitch_Img subviews])
    {
        NSLog(@"%@",obj);
        [obj removeFromSuperview];
    }

    
    NSMutableArray * objPitchdetail=[DBMpitchReport getPitchmapdetails :self.matchTypecode :self.compititionCode :self.matchCode :_teamCode :self.lnningsno  :self.selectStrikerCode : self.selectRun: self.selectLineCode : self.selectLengthCode];
    
    int xposition;
    int yposition;

    
    for(int i=0; i<objPitchdetail.count;i++)
    {
        PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
        
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMY2 intValue];
        
        if(!(xposition == 1 && yposition ==1)){
            
           
            [self pitchpositioncount :objRecord.PMlengthcode :objRecord.PMlineCode :objRecord.BattingStyle];
            
        }
    }
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
        self.striker_Lbl.text =objStriker.playername;
        
    }
    else if(isLine == YES)
    {
        LineReportRecord * objLine =[self.lineArray objectAtIndex:indexPath.row];
        self.selectLineCode= objLine.metasubcode;
        self.line_lbl.text =objLine.metasubcodedescription;
    }
    else if (isLength == YES)
    {
        LengthReportRecord * objLength =[self.lengthArray objectAtIndex:indexPath.row];
        self.selectLengthCode = objLength.metasubcode;
        self.length_Lbl.text =objLength.metasubcodedescription;
    }
    self.striker_Tbl.hidden=YES;
}

-(void)pitchpositioncount:(NSString *) PMLengthcode :(NSString *) PMLinecode :(NSString *) battingStyle
{
    if([battingStyle isEqualToString:@"MSC013"])
    {
        if([PMLengthcode isEqualToString:@"MSC037"])
        {
            if([PMLinecode isEqualToString:@"MSC031"])
            {
                ///lable
            }
            else if ([PMLinecode isEqualToString:@"MSC028"])
            {
                //lable
                
            }
            else if ([PMLinecode isEqualToString:@"MSC026"])
            {
                
            }
            else if ([PMLinecode isEqualToString:@"MSC029"])
            {
                
            }
            else if ([PMLinecode isEqualToString:@"MSC030"])
            {
                
            }
        }
    }
    else
    {
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
