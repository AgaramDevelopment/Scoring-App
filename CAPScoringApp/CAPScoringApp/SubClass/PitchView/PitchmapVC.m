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
    
    BOOL isSelectStriker;
    
    
    UILabel *fullTosswideOO;
    UILabel * fullTossoutsideoff;
    UILabel * Fulltossmiddle;
    UILabel* FullTossOSLeg;
    UILabel * FulltosswideWL;
    UILabel * yorkerwideOO;
    UILabel * yorkeroutsideoff;
    UILabel * yorkermiddle;
    UILabel * yorkeroutsideleg;
    UILabel * yorkerwideOL;
    UILabel * fullwideOO;
    UILabel * fulloutsideoff;
    UILabel * fullmiddle;
    UILabel * fulloutsideleg;
    UILabel * fullwideoutleg;
    UILabel * goodwideOO;
    UILabel * goodoutsideoff;
    UILabel * goodmiddle;
    UILabel * goodoutsidele;
    UILabel * goodoutsideleg;
    UILabel * goodwideoutleg;
    UILabel * shortwideOO;
    UILabel * shortoutsideoff;
    UILabel * shortmiddle;
    UILabel * shortoutsideleg;
    UILabel * shortwideOL;
    UILabel * bouncerwideOO;
    UILabel * bounceroutsideoff;
    UILabel * bouncermiddle;
    UILabel * bouncerousideleg;
    UILabel * bouncerwideOL;
    
    
    int  fullTosswideOORun;
    int fullTossoutsideoffRun;
    int  FulltossmiddleRun;
    int  FullTossOSLegRun;
    int  FulltosswideWLRun;
    int  yorkerwideOORun;
    int yorkeroutsideoffRun;
    int yorkermiddleRun;
    int yorkeroutsidelegRun;
    int yorkerwideOLRun;
    int fullwideOORun;
    int fulloutsideoffRun;
    int fullmiddleRun;
    int fulloutsidelegRun;
    int fullwideoutlegRun;
    int goodwideOORun;
    int goodoutsideoffRun;
    int goodmiddleRun;
    int goodoutsideleRun;
    int goodoutsidelegRun;
    int goodwideoutlegRun;
    int shortwideOORun;
    int shortoutsideoffRun;
    int shortmiddleRun;
    int shortoutsidelegRun;
    int shortwideOLRun;
    int bouncerwideOORun;
    int bounceroutsideoffRun;
    int bouncermiddleRun;
    int bouncerousidelegRun;
    int bouncerwideOLRun;
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
@property (nonatomic,strong) NSString * selectballwkt;




@end

@implementation PitchmapVC
@synthesize lineArray,lengthArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lineArray =[[NSMutableArray alloc]init];
    lengthArray =[[NSMutableArray alloc]init];
    
     [self setInningsView];
    isSelectStriker = NO;
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
    
    
    self.lnningsno=@"1";
    self.selectStrikerCode =(self.selectStrikerCode !=nil)?self.selectStrikerCode :@"";
    self.selectRun=@"";
    self.selectLengthCode =@"";
    self.selectLineCode = @"";
    self.selectballwkt  =@"0";
    [self.Inn1_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}


-(void) setInningsView{
    if([self.matchTypecode isEqual:@"MSC116"] || [self.matchTypecode isEqual:@"MSC024"]){//T20
        
        self.Inn1_Btn.hidden = NO;
        self.Inn2_Btn.hidden = NO;
        self.Inn3_Btn.hidden = YES;
        self.Inn4_Btn.hidden = YES;
        
        //   [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //[self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        self.inns2_btnWidth.constant = self.view.frame.size.width/2;
        self.inn1_btnWidth.constant =  self.view.frame.size.width/2;
        
        
    }else if([self.matchTypecode isEqual:@"MSC115"] || [self.matchTypecode isEqual:@"MSC022"]){//ODI
        self.Inn1_Btn.hidden = NO;
        self.Inn2_Btn.hidden = NO;
        self.Inn3_Btn.hidden = YES;
        self.Inn4_Btn.hidden = YES;
        self.inns2_btnWidth.constant = self.view.frame.size.width/2;
        self.inn1_btnWidth.constant = self.view.frame.size.width/2;
        
        //     [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //    [self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        
    }else if([self.matchTypecode isEqual:@"MSC114"] || [self.matchTypecode isEqual:@"MSC023"]){//Test
        
        self.Inn1_Btn.hidden = NO;
        self.Inn2_Btn.hidden = NO;
        self.Inn3_Btn.hidden = NO;
        self.Inn4_Btn.hidden = NO;
    }
}

-(void)drawpitchMethod
{
    

    for(UIImageView * obj in [self.pitch_Img subviews])
    {
        NSLog(@"%@",obj);
        [obj removeFromSuperview];
    }

    
    NSMutableArray * objPitchdetail=[DBMpitchReport getPitchmapdetails :self.matchTypecode :self.compititionCode :self.matchCode :_teamCode :self.lnningsno  :self.selectStrikerCode : self.selectRun: self.selectLineCode : self.selectLengthCode:self.selectballwkt];
    
      if(objPitchdetail.count > 0)
      {
    
    PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:0];
    
  
    if(isSelectStriker == YES)
    {
        if([objRecord.BattingStyle isEqualToString:@"MSC013"])
        {
            self.pitch_Img.image=[UIImage imageNamed:@"pichmapRH"];
            
        }
        else{
            
            self.pitch_Img.image=[UIImage imageNamed:@"pichmapLH"];
            
        }
        
    }
    else
    {
        self.pitch_Img.image=[UIImage imageNamed:@"pichmapRH"];
        
    }

      }
    int xposition;
    int yposition;
    
   
    for(int i=0; i<objPitchdetail.count;i++)
    {
        PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMY2 intValue];
        
        if(!(xposition == 1 && yposition ==1)){
            
            Img_ball =[[UIImageView alloc]initWithFrame:CGRectMake(xposition+(xposition/1.2),yposition+(yposition/4),20, 20)];
            Img_ball.image =[UIImage imageNamed:@"RedBall"];
            [self.pitch_Img addSubview:Img_ball];
            
        
        }
    }
}


-(IBAction)didClickInns1:(id)sender
{
    self.lnningsno=@"1";
    [self setInningsBySelection:@"1"];
    
   self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
    [self.standard_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self drawpitchMethod];
}

-(IBAction)didClickInns2:(id)sender
{
    self.lnningsno=@"2";
     [self setInningsBySelection:@"2"];
    

    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"2"];
    [self.standard_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];

    [self drawpitchMethod];

}

-(IBAction)didClickInns3:(id)sender
{
    self.lnningsno=@"3";
     [self setInningsBySelection:@"3"];
    
    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"3"];
    [self.standard_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];

    [self drawpitchMethod];

}

-(IBAction)didClickInns4:(id)sender
{
    self.lnningsno=@"4";
     [self setInningsBySelection:@"4"];
    
    
    self.teamCode =[DBMpitchReport getTeamCode:self.compititionCode :self.matchCode :@"4"];
    [self.standard_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];

    [self drawpitchMethod];

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
    
    self.selectRun=@"";
    
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
     self.selectballwkt=@"1";
    [self.dotball_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.ball_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.wicket_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    
}
-(IBAction)didSelectWicket:(id)sender
{
     self.selectballwkt=@"1";
    [self.wicket_Btn setImage:[UIImage imageNamed:@"On_Circle"] forState:UIControlStateNormal];
    [self.dotball_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    [self.ball_Btn setImage:[UIImage imageNamed:@"Off_Circle"] forState:UIControlStateNormal];
    
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0f];
    
    return color;
}
-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2374CD"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#000000"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
}

-(void) setInningsBySelection: (NSString*) innsNo
    {
    
    [self setInningsButtonUnselect:self.Inn1_Btn];
    [self setInningsButtonUnselect:self.Inn2_Btn];
    [self setInningsButtonUnselect:self.Inn3_Btn];
    [self setInningsButtonUnselect:self.Inn4_Btn];
    
    [self.Inn1_Btn setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.fstInnShortName] forState:UIControlStateNormal];
    [self.Inn2_Btn setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.secInnShortName] forState:UIControlStateNormal];
    [self.Inn3_Btn setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.thrdInnShortName] forState:UIControlStateNormal];
    [self.Inn4_Btn setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.frthInnShortName] forState:UIControlStateNormal];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.Inn1_Btn];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.Inn2_Btn];
        
    }else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.Inn3_Btn];
        
    }else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.Inn4_Btn];
        
    }
}

-(IBAction)didClickHidefilterBtn:(id)sender
{
    self.filter_view.hidden=YES;
    [self.standard_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];

    [self drawpitchMethod];
    
}
-(IBAction)didClickStandard:(id)sender
{
    self.statistics_Btn.backgroundColor=[UIColor blackColor];
    self.standard_Btn.backgroundColor=[UIColor clearColor];
    [self drawpitchMethod];
    
}

-(IBAction)didClickStatistics:(id)sender
{
    self.statistics_Btn.backgroundColor=[UIColor clearColor];
    self.standard_Btn.backgroundColor=[UIColor blackColor];
    [self Stardardpitchmap];
    
}

-(void)Stardardpitchmap;
{
    
    for(UIImageView * obj in [self.pitch_Img subviews])
    {
        NSLog(@"%@",obj);
        [obj removeFromSuperview];
    }

    
      fullTosswideOORun=0;
      fullTossoutsideoffRun=0;
      FulltossmiddleRun=0;
      FullTossOSLegRun=0;
      FulltosswideWLRun=0;
      yorkerwideOORun=0;
      yorkeroutsideoffRun=0;
      yorkermiddleRun=0;
      yorkeroutsidelegRun=0;
      yorkerwideOLRun=0;
      fullwideOORun=0;
      fulloutsideoffRun=0;
      fullmiddleRun=0;
      fulloutsidelegRun=0;
      fullwideoutlegRun=0;
      goodwideOORun=0;
      goodoutsideoffRun=0;
      goodmiddleRun=0;
      goodoutsideleRun=0;
      goodoutsidelegRun=0;
      goodwideoutlegRun=0;
      shortwideOORun=0;
      shortoutsideoffRun=0;
      shortmiddleRun=0;
      shortoutsidelegRun=0;
      shortwideOLRun=0;
      bouncerwideOORun=0;
      bounceroutsideoffRun=0;
      bouncermiddleRun=0;
      bouncerousidelegRun=0;
      bouncerwideOLRun=0;
    
    
    NSMutableArray * objPitchdetail=[DBMpitchReport getPitchmapdetails :self.matchTypecode :self.compititionCode :self.matchCode :_teamCode :self.lnningsno  :self.selectStrikerCode : self.selectRun: self.selectLineCode : self.selectLengthCode:self.selectballwkt];
    
    
    
    if(objPitchdetail.count > 0)
    {
        PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:0];
    if(isSelectStriker == YES)
    {
        if([objRecord.BattingStyle isEqualToString:@"MSC013"])
        {
            self.pitch_Img.image=[UIImage imageNamed:@"pichmapRH"];
            
        }
        else{
            
            self.pitch_Img.image=[UIImage imageNamed:@"pichmapLH"];
            
        }

    }
    else
    {
//        if([self.BatmenStyle isEqualToString:@"MSC013"])
//        {
            self.pitch_Img.image=[UIImage imageNamed:@"pichmapRH"];
            
//        }
//        else{
//            
//            self.batsmanCell.pitchMap_img.image=[UIImage imageNamed:@"pichmapLH"];
//            
//        }

    }
    }
    int xposition;
    int yposition;

    
    for(int i=0; i<objPitchdetail.count;i++)
    {
        PitchReportdetailRecord * objRecord =(PitchReportdetailRecord *)[objPitchdetail objectAtIndex:i];
        
        xposition = [objRecord.PMX2 intValue];
        yposition = [objRecord.PMY2 intValue];
        
        if(!(xposition == 1 && yposition ==1)){
            
           
            [self pitchpositioncount :objRecord.PMlengthcode :objRecord.PMlineCode :objRecord.BattingStyle:objRecord.Runs];
            
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
        isSelectStriker =YES;
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

-(void)pitchpositioncount:(NSString *) PMLengthcode :(NSString *) PMLinecode :(NSString *) battingStyle :(NSString *) Run
{
    

    if(isSelectStriker ==YES)
    {
        battingStyle=battingStyle;
    }
    else
    {
        battingStyle=@"MSC013";
    }
    
    if([PMLengthcode isEqualToString:@"MSC037"])   //Fulltoss
    {
        if([PMLinecode isEqualToString:@"MSC031"])
        {
            if(fullTosswideOO !=nil)
            {
                [fullTosswideOO removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                fullTosswideOORun =[Run intValue]+fullTosswideOORun;
                fullTosswideOO=[[UILabel alloc]initWithFrame:CGRectMake(440,60,35, 35)];

            }
            else
            {
                fullTosswideOORun =[Run intValue]+fullTosswideOORun;
                fullTosswideOO=[[UILabel alloc]initWithFrame:CGRectMake(250,60,35, 35)];

            }
            
           
            fullTosswideOO.textColor=[UIColor whiteColor];
            fullTosswideOO.text =[NSString stringWithFormat:@"%d",fullTosswideOORun];
            [self.pitch_Img addSubview:fullTosswideOO];
        }
        else if ([PMLinecode isEqualToString:@"MSC028"])
        {
            if(fullTossoutsideoff !=nil)
            {
                [fullTossoutsideoff removeFromSuperview];
            }

        
            if([battingStyle isEqualToString:@"MSC013"])
            {
                fullTossoutsideoffRun =[Run intValue]+fullTossoutsideoffRun;
            }
            else
            {
                fullTossoutsideoffRun =[Run intValue]+fullTossoutsideoffRun;
            }
            
            
            fullTossoutsideoff =[[UILabel alloc]initWithFrame:CGRectMake(300,40,35, 35)];
            fullTossoutsideoff.textColor=[UIColor whiteColor];
            fullTossoutsideoff.text =[NSString stringWithFormat:@"%d",fullTossoutsideoffRun];
            [self.pitch_Img addSubview:fullTossoutsideoff];
            
        }
        else if ([PMLinecode isEqualToString:@"MSC026"])
        {

            FulltossmiddleRun =[Run intValue]+FulltossmiddleRun;

            if(Fulltossmiddle !=nil)
            {
                [Fulltossmiddle removeFromSuperview];
            }
            
            Fulltossmiddle=[[UILabel alloc]initWithFrame:CGRectMake(120,60,35, 35)];
            Fulltossmiddle.textColor=[UIColor whiteColor];
            Fulltossmiddle.text =[NSString stringWithFormat:@"%d",FulltossmiddleRun];
            [self.pitch_Img addSubview:Fulltossmiddle];
        }
        else if ([PMLinecode isEqualToString:@"MSC029"])
        {
            
            if(FullTossOSLeg !=nil)
            {
                [FullTossOSLeg removeFromSuperview];
            }
            if([battingStyle isEqualToString:@"MSC013"])
            {
                FullTossOSLegRun =[Run intValue]+FullTossOSLegRun;

            }
            else
            {
                FullTossOSLegRun =[Run intValue]+FullTossOSLegRun;

            }
            
            
            
            FullTossOSLeg=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            FullTossOSLeg.textColor=[UIColor whiteColor];
            FullTossOSLeg.text =[NSString stringWithFormat:@"%d",FullTossOSLegRun];
            [self.pitch_Img addSubview:FullTossOSLeg];
        }
        else if ([PMLinecode isEqualToString:@"MSC030"])
        {
            
            if(FulltosswideWL !=nil)
            {
                [FulltosswideWL removeFromSuperview];
            }
            if([battingStyle isEqualToString:@"MSC013"])
            {
                FulltosswideWLRun =[Run intValue]+FulltosswideWLRun;

            }
            else
            {
                FulltosswideWLRun =[Run intValue]+FulltosswideWLRun;

            }
            
           
            
            FulltosswideWL =[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            FulltosswideWL.textColor=[UIColor whiteColor];
            FulltosswideWL.text =[NSString stringWithFormat:@"%d",FulltosswideWLRun];
            [self.pitch_Img addSubview:FulltosswideWL];
        }
    }
    

    if([PMLengthcode isEqualToString:@"MSC036"]) //yorker
    {
        if([PMLinecode isEqualToString:@"MSC031"])
        {
            
            if(yorkerwideOO !=nil)
            {
                [yorkerwideOO removeFromSuperview];
            }

            
            if([battingStyle isEqualToString:@"MSC013"])
            {
                yorkerwideOORun =[Run intValue]+yorkerwideOORun;
                yorkerwideOO =[[UILabel alloc]initWithFrame:CGRectMake(450,100,35, 35)];

            }
            else
            {
                yorkerwideOORun =[Run intValue]+yorkerwideOORun;
                yorkerwideOO =[[UILabel alloc]initWithFrame:CGRectMake(240,100,35, 35)];
            }
            
            
            
            
            yorkerwideOO.textColor=[UIColor whiteColor];
            yorkerwideOO.text =[NSString stringWithFormat:@"%d",yorkerwideOORun];
            [self.pitch_Img addSubview:yorkerwideOO];
        }
        else if ([PMLinecode isEqualToString:@"MSC028"])
        {
            
            if(yorkeroutsideoff !=nil)
            {
                [yorkeroutsideoff removeFromSuperview];
            }
            
            if([battingStyle isEqualToString:@"MSC013"])
            {
                yorkeroutsideoffRun =[Run intValue]+yorkeroutsideoffRun;
                yorkeroutsideoff = [[UILabel alloc]initWithFrame:CGRectMake(390,100,35, 35)];

            }
            else
            {
                yorkeroutsideoffRun =[Run intValue]+yorkeroutsideoffRun;
                yorkeroutsideoff = [[UILabel alloc]initWithFrame:CGRectMake(310,100,35, 35)];

            }
            
            
            
            yorkeroutsideoff.textColor=[UIColor whiteColor];
            yorkeroutsideoff.text =[NSString stringWithFormat:@"%d",yorkeroutsideoffRun];
            [self.pitch_Img addSubview:yorkeroutsideoff];
            
        }
        else if ([PMLinecode isEqualToString:@"MSC026"])
        {

            yorkermiddleRun =[Run intValue]+yorkermiddleRun;

            if(yorkermiddle !=nil)
            {
                [yorkermiddle removeFromSuperview];
            }

            
            yorkermiddle=[[UILabel alloc]initWithFrame:CGRectMake(350,100,35, 35)];
            yorkermiddle.textColor=[UIColor whiteColor];
            yorkermiddle.text =[NSString stringWithFormat:@"%d",yorkermiddleRun];
            [self.pitch_Img addSubview:yorkermiddle];
        }
        else if ([PMLinecode isEqualToString:@"MSC029"])
        {
            
            if(yorkeroutsideleg !=nil)
            {
                [yorkeroutsideleg removeFromSuperview];
            }
            

            if([battingStyle isEqualToString:@"MSC013"])
            {
                yorkeroutsidelegRun =[Run intValue]+yorkeroutsidelegRun;

            }
            else
            {
                yorkeroutsidelegRun =[Run intValue]+yorkeroutsidelegRun;

            }
            
            
            yorkeroutsideleg = [[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            yorkeroutsideleg.textColor=[UIColor whiteColor];
            yorkeroutsideleg.text =[NSString stringWithFormat:@"%d",yorkeroutsidelegRun];
            [self.pitch_Img addSubview:yorkeroutsideleg];
        }
        else if ([PMLinecode isEqualToString:@"MSC030"])
        {
            
            if(yorkerwideOL !=nil)
            {
                [yorkerwideOL removeFromSuperview];
            }
            
            if([battingStyle isEqualToString:@"MSC013"])
            {
                yorkerwideOLRun =[Run intValue]+yorkerwideOLRun;

            }
            else
            {
                yorkerwideOLRun =[Run intValue]+yorkerwideOLRun;

            }
            
            yorkerwideOL=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            yorkerwideOL.textColor=[UIColor whiteColor];
            yorkerwideOL.text =[NSString stringWithFormat:@"%d",yorkerwideOLRun];
            [self.pitch_Img addSubview:yorkerwideOL];
        }
    }
    
    
    if([PMLengthcode isEqualToString:@"MSC035"])    //Full
    {
        if([PMLinecode isEqualToString:@"MSC031"])
        {
           
            if(fullwideOO !=nil)
            {
                [fullwideOO removeFromSuperview];
            }
            

            
            if([battingStyle isEqualToString:@"MSC013"])
            {
                fullwideOORun =[Run intValue]+fullwideOORun;
                fullwideOO = [[UILabel alloc]initWithFrame:CGRectMake(460,150,35, 35)];

            }
            else
            {
                fullwideOORun =[Run intValue]+fullwideOORun;
                fullwideOO = [[UILabel alloc]initWithFrame:CGRectMake(220,150,35, 35)];

            }
            
            
            fullwideOO.textColor=[UIColor whiteColor];
            fullwideOO.text =[NSString stringWithFormat:@"%d",fullwideOORun];
            [self.pitch_Img addSubview:fullwideOO];
        }
        else if ([PMLinecode isEqualToString:@"MSC028"])
        {
            //lable
            
            if(fulloutsideoff !=nil)
            {
                [fulloutsideoff removeFromSuperview];
            }
            if([battingStyle isEqualToString:@"MSC013"])
            {
                fulloutsideoffRun =[Run intValue]+fulloutsideoffRun;

            }
            else
            {
                fulloutsideoffRun =[Run intValue]+fulloutsideoffRun;

            }
            
            
            
            fulloutsideoff=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            fulloutsideoff.textColor=[UIColor whiteColor];
            fulloutsideoff.text =[NSString stringWithFormat:@"%d",fulloutsideoffRun];
            [self.pitch_Img addSubview:fulloutsideoff];
            
        }
        else if ([PMLinecode isEqualToString:@"MSC026"])
        {

            
            fullmiddleRun =[Run intValue]+fullmiddleRun;
            if(fullmiddle !=nil)
            {
                [fullmiddle removeFromSuperview];
            }

            fullmiddle=[[UILabel alloc]initWithFrame:CGRectMake(350,150,35, 35)];
            fullmiddle.textColor=[UIColor whiteColor];
            fullmiddle.text =[NSString stringWithFormat:@"%d",fullmiddleRun];
            [self.pitch_Img addSubview:fullmiddle];
        }
        else if ([PMLinecode isEqualToString:@"MSC029"])
        {
            
            if(fulloutsideleg !=nil)
            {
                [fulloutsideleg removeFromSuperview];
            }
            
            if([battingStyle isEqualToString:@"MSC013"])
            {
                fulloutsidelegRun =[Run intValue]+fulloutsidelegRun;

            }
            else
            {
                fulloutsidelegRun =[Run intValue]+fulloutsidelegRun;

            }
            
            
            
            fulloutsideleg=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            fulloutsideleg.textColor=[UIColor whiteColor];
            fulloutsideleg.text =[NSString stringWithFormat:@"%d",fulloutsidelegRun];
            [self.pitch_Img addSubview:fulloutsideleg];
        }
        else if ([PMLinecode isEqualToString:@"MSC030"])
        {
            
            if(fullwideoutleg !=nil)
            {
                [fullwideoutleg removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                fullwideoutlegRun =[Run intValue]+fullwideoutlegRun;
                fullwideoutleg=[[UILabel alloc]initWithFrame:CGRectMake(400,150,35, 35)];

            }
            else
            {
                fullwideoutlegRun =[Run intValue]+fullwideoutlegRun;
                fullwideoutleg=[[UILabel alloc]initWithFrame:CGRectMake(300,150,35, 35)];

            }
            
            
            fullwideoutleg.textColor=[UIColor whiteColor];
            fullwideoutleg.text =[NSString stringWithFormat:@"%d",fullwideoutlegRun];
            [self.pitch_Img addSubview:fullwideoutleg];
        }
    }
    
    
    
    if([PMLengthcode isEqualToString:@"MSC034"])       //good
    {
        if([PMLinecode isEqualToString:@"MSC031"])
        {
            if(goodwideOO !=nil)
            {
                [goodwideOO removeFromSuperview];
            }

          
            if([battingStyle isEqualToString:@"MSC013"])
            {
                goodwideOORun =[Run intValue]+goodwideOORun;

            }
            else
            {
                goodwideOORun =[Run intValue]+goodwideOORun;

            }
            
            
            goodwideOO=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            goodwideOO.textColor=[UIColor whiteColor];
            goodwideOO.text =[NSString stringWithFormat:@"%d",goodwideOORun];
            [self.pitch_Img addSubview:goodwideOO];
        }
        else if ([PMLinecode isEqualToString:@"MSC028"])
        {
            
            if(goodoutsideoff !=nil)
            {
                [goodoutsideoff removeFromSuperview];
            }
            if([battingStyle isEqualToString:@"MSC013"])
            {
                goodoutsideoffRun =[Run intValue]+goodoutsideoffRun;
                goodoutsideoff=[[UILabel alloc]initWithFrame:CGRectMake(405,210,35, 35)];

            }
            else
            {
                goodoutsideoffRun =[Run intValue]+goodoutsideoffRun;
                goodoutsideoff=[[UILabel alloc]initWithFrame:CGRectMake(290,210,35, 35)];

            }
          
            
            goodoutsideoff.textColor=[UIColor whiteColor];
            goodoutsideoff.text =[NSString stringWithFormat:@"%d",goodoutsideoffRun];
            [self.pitch_Img addSubview:goodoutsideoff];
            
        }
        else if ([PMLinecode isEqualToString:@"MSC026"])
        {

            goodmiddleRun =[Run intValue]+goodmiddleRun;

            if(goodmiddle !=nil)
            {
                [goodmiddle removeFromSuperview];
            }
            
            goodmiddle=[[UILabel alloc]initWithFrame:CGRectMake(350,210,35, 35)];
            goodmiddle.textColor=[UIColor whiteColor];
            goodmiddle.text =[NSString stringWithFormat:@"%d",goodmiddleRun];
            [self.pitch_Img addSubview:goodmiddle];
        }
       
        else if ([PMLinecode isEqualToString:@"MSC029"])
        {
            if(goodoutsideleg !=nil)
            {
                [goodoutsideleg removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                goodoutsidelegRun =[Run intValue]+goodoutsidelegRun;

            }
            else
            {
                goodoutsidelegRun =[Run intValue]+goodoutsidelegRun;

            }
            
            
            goodoutsideleg=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            goodoutsideleg.textColor=[UIColor whiteColor];
            goodoutsideleg.text =[NSString stringWithFormat:@"%d",goodoutsidelegRun];
            [self.pitch_Img addSubview:goodoutsideleg];
        }
        else if ([PMLinecode isEqualToString:@"MSC030"])
        {
            if(goodwideoutleg !=nil)
            {
                [goodwideoutleg removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                goodwideoutlegRun =[Run intValue]+goodwideoutlegRun;
                goodwideoutleg=[[UILabel alloc]initWithFrame:CGRectMake(480,210,35, 35)];
                
            }
            else
            {
                goodwideoutlegRun =[Run intValue]+goodwideoutlegRun;
                goodwideoutleg=[[UILabel alloc]initWithFrame:CGRectMake(200,210,35, 35)];

            }
            
            
            goodwideoutleg.textColor=[UIColor whiteColor];
            [goodoutsideleg setBackgroundColor:[UIColor greenColor]];

            goodwideoutleg.text =[NSString stringWithFormat:@"%d",goodwideoutlegRun];
            [self.pitch_Img addSubview:goodwideoutleg];
        }
    }
    
    
    if([PMLengthcode isEqualToString:@"MSC033"])        //short
    {
        if([PMLinecode isEqualToString:@"MSC031"])
        {
            if(shortwideOO !=nil)
            {
                [shortwideOO removeFromSuperview];
            }
            
            if([battingStyle isEqualToString:@"MSC013"])
            {
                shortwideOORun =[Run intValue]+shortwideOORun;

            }
            else
            {
                shortwideOORun =[Run intValue]+shortwideOORun;

            }
            
           
            
            shortwideOO=[[UILabel alloc]initWithFrame:CGRectMake(480,320,35, 35)];
            shortwideOO.textColor=[UIColor whiteColor];
            shortwideOO.text =[NSString stringWithFormat:@"%d",shortwideOORun];
            [self.pitch_Img addSubview:shortwideOO];
        }
        else if ([PMLinecode isEqualToString:@"MSC028"])
        {
            
            if(shortoutsideoff !=nil)
            {
                [shortoutsideoff removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                shortoutsideoffRun =[Run intValue]+shortoutsideoffRun;
                shortoutsideoff=[[UILabel alloc]initWithFrame:CGRectMake(420,310,35, 35)];


            }
            else
            {
                shortoutsideoffRun =[Run intValue]+shortoutsideoffRun;
                shortoutsideoff=[[UILabel alloc]initWithFrame:CGRectMake(180,310,35, 35)];

            }
            
            shortoutsideoff.textColor=[UIColor whiteColor];
            shortoutsideoff.text =[NSString stringWithFormat:@"%d",shortoutsideoffRun];
            [self.pitch_Img addSubview:shortoutsideoff];
            
        }
        else if ([PMLinecode isEqualToString:@"MSC026"])
        {

            
            shortmiddleRun =[Run intValue]+shortmiddleRun;

            if(shortmiddle !=nil)
            {
                [shortmiddle removeFromSuperview];
            }
            
            shortmiddle=[[UILabel alloc]initWithFrame:CGRectMake(350,310,35, 35)];
            shortmiddle.textColor=[UIColor whiteColor];
            shortmiddle.text =[NSString stringWithFormat:@"%d",shortmiddleRun];
            [self.pitch_Img addSubview:shortmiddle];
        }
        else if ([PMLinecode isEqualToString:@"MSC029"])
        {
            if(shortoutsideleg !=nil)
            {
                [shortoutsideleg removeFromSuperview];
            }
            

            if([battingStyle isEqualToString:@"MSC013"])
            {
                shortoutsidelegRun =[Run intValue]+shortoutsidelegRun;

            }
            else
            {
                shortoutsidelegRun =[Run intValue]+shortoutsidelegRun;

            }
            
            
            shortoutsideleg=[[UILabel alloc]initWithFrame:CGRectMake(280,320,35, 35)];
            shortoutsideleg.textColor=[UIColor whiteColor];
            shortoutsideleg.text =[NSString stringWithFormat:@"%d",shortoutsidelegRun];
            [self.pitch_Img addSubview:shortoutsideleg];
        }
        else if ([PMLinecode isEqualToString:@"MSC030"])
        {
            
            if(shortwideOL !=nil)
            {
                [shortwideOL removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                shortwideOLRun =[Run intValue]+shortwideOLRun;
                shortwideOL=[[UILabel alloc]initWithFrame:CGRectMake(510,310,35, 35)];
            }
            else
            {
                shortwideOLRun =[Run intValue]+shortwideOLRun;
                shortwideOL=[[UILabel alloc]initWithFrame:CGRectMake(180,310,35, 35)];

            }
        
            shortwideOL.textColor=[UIColor whiteColor];
            shortwideOL.text =[NSString stringWithFormat:@"%d",shortwideOLRun];
            [self.pitch_Img addSubview:shortwideOL];
        }
    }
    
    
    if([PMLengthcode isEqualToString:@"MSC032"])        //bouncer
    {
        if([PMLinecode isEqualToString:@"MSC031"])
        {
            
            if(bouncerwideOO !=nil)
            {
                [bouncerwideOO removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                bouncerwideOORun =[Run intValue]+bouncerwideOORun;

            }
            else
            {
                bouncerwideOORun =[Run intValue]+bouncerwideOORun;

            }
            
            
            bouncerwideOO=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            bouncerwideOO.textColor=[UIColor whiteColor];
            bouncerwideOO.text =[NSString stringWithFormat:@"%d",bouncerwideOORun];
            [self.pitch_Img addSubview:bouncerwideOO];
        }
        else if ([PMLinecode isEqualToString:@"MSC028"])
        {
            
            if(bounceroutsideoff !=nil)
            {
                [bounceroutsideoff removeFromSuperview];
            }
            

            if([battingStyle isEqualToString:@"MSC013"])
            {
                bounceroutsideoffRun =[Run intValue]+bounceroutsideoffRun;
                bounceroutsideoff=[[UILabel alloc]initWithFrame:CGRectMake(450,400,35, 35)];

            }
            else
            {
                bounceroutsideoffRun =[Run intValue]+bounceroutsideoffRun;
                bounceroutsideoff=[[UILabel alloc]initWithFrame:CGRectMake(250,400,35, 35)];

            }
            
            
            bounceroutsideoff.textColor=[UIColor whiteColor];
            bounceroutsideoff.text =[NSString stringWithFormat:@"%d",bounceroutsideoffRun];
            [self.pitch_Img addSubview:bounceroutsideoff];
            
        }
        else if ([PMLinecode isEqualToString:@"MSC026"])
        {

            bouncermiddleRun =[Run intValue]+bouncermiddleRun;

            if(bouncermiddle !=nil)
            {
                [bouncermiddle removeFromSuperview];
            }
            
            bouncermiddle=[[UILabel alloc]initWithFrame:CGRectMake(350,400,35, 35)];
            bouncermiddle.textColor=[UIColor whiteColor];
            bouncermiddle.text =[NSString stringWithFormat:@"%d",bouncermiddleRun];
            [self.pitch_Img addSubview:bouncermiddle];
        }
        else if ([PMLinecode isEqualToString:@"MSC029"])
        {
            if(bouncerousideleg !=nil)
            {
                [bouncerousideleg removeFromSuperview];
            }
            
            if([battingStyle isEqualToString:@"MSC013"])
            {
                bouncerousidelegRun =[Run intValue]+bouncerousidelegRun;

            }
            else
            {
                bouncerousidelegRun =[Run intValue]+bouncerousidelegRun;

            }
        
            
            bouncerousideleg=[[UILabel alloc]initWithFrame:CGRectMake(120,40,35, 35)];
            bouncerousideleg.textColor=[UIColor whiteColor];
            bouncerousideleg.text =[NSString stringWithFormat:@"%d",bouncerousidelegRun];
            [self.pitch_Img addSubview:bouncerousideleg];
        }
        else if ([PMLinecode isEqualToString:@"MSC030"])
        {
            
            if(bouncerwideOL !=nil)
            {
                [bouncerwideOL removeFromSuperview];
            }

            if([battingStyle isEqualToString:@"MSC013"])
            {
                bouncerwideOLRun =[Run intValue]+bouncerwideOLRun;
                bouncerwideOL=[[UILabel alloc]initWithFrame:CGRectMake(540,400,35, 35)];

            }
            else
            {
                bouncerwideOLRun =[Run intValue]+bouncerwideOLRun;
                bouncerwideOL=[[UILabel alloc]initWithFrame:CGRectMake(150,400,35, 35)];
            }
            
            
            
            bouncerwideOL.textColor=[UIColor whiteColor];
            bouncerwideOL.text =[NSString stringWithFormat:@"%d",bouncerwideOLRun];
            [self.pitch_Img addSubview:bouncerwideOL];
        }
    }
   

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
