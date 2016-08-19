//
//  EditModeVC.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EditModeVC.h"
#import "CustomNavigationVC.h"
#import "DBManager.h"
#import "InningsBowlerDetailsRecord.h"
#import "EditModeCell.h"
#import "OversorderRecord.h"
#import "ScorEnginVC.h"
#import "FETCHSEBALLCODEDETAILS.h"
#import "BallEventRecord.h"
#import "ScoreEnginEditRecord.h"
#import "InsertSEScoreEngine.h"
#import "FetchSEPageLoadRecord.h"
#import "FetchScorecard.h"

// Border Brushes
#define runBrushBDR [UIColor colorWithRed:(82.0/255.0) green:(131.0/255.0) blue:(174.0/255.0) alpha:1.0]
#define extrasBrushBDR [UIColor colorWithRed:(255.0/255.0) green:(77.0/255.0) blue:(166.0/255.0) alpha:1.0]
#define fourBrushBDR [UIColor colorWithRed:(1.0/255.0) green:(126.0/255.0) blue:(254.0/255.0) alpha:1.0]
#define sixBrushBDR [UIColor colorWithRed:(148.0/255.0) green:(52.0/255.0) blue:(227.0/255.0) alpha:1.0]

#define wicketBrushBDR [UIColor colorWithRed:(251.0/255.0) green:(53.0/255.0) blue:(54.0/255.0) alpha:1.0]
#define markedForEditBrushBDR [UIColor colorWithRed:(237.0/255.0) green:(192.0/255.0) blue:(60.0/255.0) alpha:1.0]


// Background Brushes

#define runBrushBG [UIColor clearColor]
#define extrasBrushBG [UIColor colorWithRed:(255.0/255.0) green:(77.0/255.0) blue:(166.0/255.0) alpha:1.0]
#define fourBrushBG [UIColor colorWithRed:(1.0/255.0) green:(126.0/255.0) blue:(254.0/255.0) alpha:1.0]

#define fourBrushBG [UIColor colorWithRed:(1.0/255.0) green:(126.0/255.0) blue:(254.0/255.0) alpha:1.0]

#define sixBrushBG [UIColor colorWithRed:(148.0/255.0) green:(52.0/255.0) blue:(227.0/255.0) alpha:1.0]

#define wicketBrushBG [UIColor colorWithRed:(251.0/255.0) green:(53.0/255.0) blue:(54.0/255.0) alpha:1.0]
#define brushFGNormal [UIColor colorWithRed:(82.0/255.0) green:(131.0/255.0) blue:(174.0/255.0) alpha:1.0]

#define brushFGSplEvents [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0]


//UIColor *runBrushBG = [UIColor clearColor];
//UIColor *extrasBrushBG = [self colorWithHexString : @"#FF4DA6"];
//UIColor *fourBrushBG = [self colorWithHexString : @"#017EFE"];
//UIColor *sixBrushBG = [self colorWithHexString : @"#9434E3"];
//UIColor *wicketBrushBG = [self colorWithHexString : @"#FB3536"];

// Foreground Brushes
//UIColor *brushFGNormal = [self colorWithHexString : @"#5283AE"];
//UIColor *brushFGSplEvents = [UIColor whiteColor];

FETCHSEBALLCODEDETAILS *fetchSeBallCodeDetails;
BOOL isWicketSelected;
@interface EditModeVC ()
{
    CustomNavigationVC * objCustomNavigation;
    NSMutableArray* inningsDetail;
    NSMutableArray * OversorderArray;
    
    UIView * view_addedit;
    UIButton * Editrotation;
    UIButton * Cancelrotation;
    UIButton * Rightrotation;
    UIButton * leftrotation;
    
    int  totalRun;
    NSMutableArray * objoverballCount;
    NSMutableArray * eachoverRun;
    NSMutableArray * objOverrthrow;
    NSMutableArray  *objnoballArray;
    NSMutableArray * objWide;
    NSMutableArray * objlegByes;
    NSMutableArray * objByes;
    NSMutableArray * objIsfour;
    NSMutableArray * objissix;
    NSMutableArray * objWicketno;
    NSMutableArray * objwicketType;
    NSMutableArray * objGrandTotal;
    NSMutableArray * objBallNo;
    NSMutableArray * objRowNumber;
    
    int EachoverWicketCount;
    UIButton *btn_Run;
    NSInteger ballCodeIndex;
    //int indexCount ;
    BOOL isEdit;
    FetchScorecard*fetchScorecard;
    DBManager *objDBManager;

    
}
@property (strong,nonatomic) BallEventRecord *ballEventRecord;

@end

@implementation EditModeVC

- (void)viewDidLoad {
    //indexCount = 0;
    [super viewDidLoad];
    [self customnavigationmethod];
    
     objDBManager = [[DBManager alloc] init];
    isEdit=NO;
      isWicketSelected=NO;
    //CGFloat totalwidth =1200;
    
    [self.view layoutIfNeeded];
    FetchSEPageLoadRecord *objfetchSEPageLoadRecord;
  
    self.Btn_innings1team1.frame= CGRectMake(self.Btn_innings1team1.frame.origin.x, self.Btn_innings1team1.frame.origin.y, 400, self.Btn_innings1team1.frame.size.height);
   self. Btn_innings1team2.userInteractionEnabled=NO;
    _Btn_inning2steam1.userInteractionEnabled=NO;
    _Btn_innings2team2.userInteractionEnabled=NO;
    self.lbl_1stseprator.hidden=YES;
    self.lbl_2seprator.hidden=YES;
    self.lbl_3seprator.hidden=YES;
    
    NSMutableArray* objInniningsarray=[objDBManager FETCHSEALLINNINGSSCOREDETAILS:self.Comptitioncode MATCHCODE:self.matchCode];
    
    if(objInniningsarray.count>0){
    objfetchSEPageLoadRecord=(FetchSEPageLoadRecord*)[objInniningsarray objectAtIndex:0];
    }
    if(![objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME isEqualToString:@""])
    {
    [self.Btn_innings1team1 setTitle:[NSString stringWithFormat:@"1st INNS %@ ",objfetchSEPageLoadRecord.FIRSTINNINGSSHORTNAME] forState: UIControlStateNormal];
    }
    
    if(![objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqualToString:@""])
    {
       NSString *secondinningsTeamName=([objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME isEqualToString:@""] || objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME == nil)?@"":[NSString stringWithFormat:@"2nd INNS %@",objfetchSEPageLoadRecord.SECONDINNINGSSHORTNAME];
        [self.Btn_innings1team2 setTitle: [NSString stringWithFormat:secondinningsTeamName] forState: UIControlStateNormal];
        self. Btn_innings1team2.userInteractionEnabled=YES;
        self.lbl_1stseprator.hidden=NO;

    }
    
    if(![objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqualToString:@""])
    {
     NSString *ThirdinningsTeamName=([objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqualToString:@""] || objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME == nil)?@"":[NSString stringWithFormat:@"3rd INNS %@",objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME];
         [self.Btn_inning2steam1 setTitle: [NSString stringWithFormat:ThirdinningsTeamName] forState: UIControlStateNormal];
        self. Btn_inning2steam1.userInteractionEnabled=YES;
        self.lbl_2seprator.hidden=NO;
    }
    
    if(![objfetchSEPageLoadRecord.THIRDINNINGSSHORTNAME isEqualToString:@""])
    {
    NSString *FourinningsTeamName=([objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME isEqualToString:@""] || objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME == nil)?@"":[NSString stringWithFormat:@"4th INNS %@",objfetchSEPageLoadRecord.FOURTHINNINGSSHORTNAME];
        
    [self.Btn_innings2team2 setTitle: [NSString stringWithFormat:FourinningsTeamName] forState: UIControlStateNormal];
         self. Btn_innings2team2.userInteractionEnabled=YES;
        self.lbl_3seprator.hidden=NO;
    }
    
    
    NSLog(@"constant=%@",self.highlightbtnxposition.constant);
    
    
    

    //self.inningsviewWidth.constant =totalwidth;
    //self.btn_innings1Widthposition.constant=400;
    //self.btn_innings2xposition.constant     =self.btn_innings1Widthposition.constant+10;
    // self.inningButtonView.constant = totalwidth;
//    OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
//    inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
//    
//    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
//        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
//        // self.btn_third_inns_id.hidden = YES;
//        // self.btn_fourth_inns_id.hidden = YES;
//    }
    // Do any additional setup after loading the view.

   }

-(void)insertAfterAndBeforeMode:(NSString*)BALLCODE {
    
    fetchSeBallCodeDetails = [[FETCHSEBALLCODEDETAILS alloc]init];
    [fetchSeBallCodeDetails FetchSEBallCodeDetails:self.Comptitioncode :self.matchCode :BALLCODE];

    GetBallDetailsForBallEventsBE *getBallDetailsForBallEventsBE =[fetchSeBallCodeDetails.GetBallDetailsForBallEventsArray objectAtIndex:0];
    
    
    self.ballEventRecord = [[BallEventRecord alloc] init];
    self.ballEventRecord.objTeamcode =getBallDetailsForBallEventsBE.TEAMCODE;
    
    self.ballEventRecord.objOverno=getBallDetailsForBallEventsBE.OVERNO;
    self.ballEventRecord.objBallno=getBallDetailsForBallEventsBE.BALLNO;
    self.ballEventRecord.objOverBallcount = getBallDetailsForBallEventsBE.BALLCOUNT;
    self.ballEventRecord.objBallcount=getBallDetailsForBallEventsBE.BALLCOUNT;;
    self.ballEventRecord.objBowlercode = getBallDetailsForBallEventsBE.BOWLERCODE;
    self.ballEventRecord.objStrikercode = getBallDetailsForBallEventsBE.STRIKERCODE;
    self.ballEventRecord.objNonstrikercode = getBallDetailsForBallEventsBE.NONSTRIKERCODE;
    self.ballEventRecord.objRbw =getBallDetailsForBallEventsBE.RBW;
    self.ballEventRecord.objIswtb=getBallDetailsForBallEventsBE.ISWTB;
    self.ballEventRecord.objIsuncomfort=getBallDetailsForBallEventsBE.ISUNCOMFORT;
    self.ballEventRecord.objIsreleaseshot=getBallDetailsForBallEventsBE.ISRELEASESHOT;
    self.ballEventRecord.objIsbeaten=getBallDetailsForBallEventsBE.ISBEATEN;
    self.ballEventRecord.objPMlengthcode=getBallDetailsForBallEventsBE.PMLENGTHCODE;
    self.ballEventRecord.objPMlinecode =getBallDetailsForBallEventsBE.PMLINECODE;
    self.ballEventRecord.objPMX1=getBallDetailsForBallEventsBE.PMX1;
    self.ballEventRecord.objPMY1=getBallDetailsForBallEventsBE.PMY1;
    self.ballEventRecord.objPMX2=getBallDetailsForBallEventsBE.PMX2;
    self.ballEventRecord.objPMY2=getBallDetailsForBallEventsBE.PMY2;
    self.ballEventRecord.objcompetitioncode =getBallDetailsForBallEventsBE.COMPETITIONCODE;
    
    self.ballEventRecord.objmatchcode =getBallDetailsForBallEventsBE.MATCHCODE;
    self.ballEventRecord.objInningsno =getBallDetailsForBallEventsBE.INNINGSNO;
    self.ballEventRecord.objSessionno =getBallDetailsForBallEventsBE.SESSIONNO;
    
    self.ballEventRecord.objWicketkeepercode =getBallDetailsForBallEventsBE.WICKETKEEPERCODE;
    self.ballEventRecord.objUmpire1code =getBallDetailsForBallEventsBE.UMPIRE1CODE;
    self.ballEventRecord.objUmpire2code =getBallDetailsForBallEventsBE.UMPIRE2CODE;
    self.ballEventRecord.objAtworotw =getBallDetailsForBallEventsBE.ATWOROTW;
    self.ballEventRecord.objBowlingEnd =getBallDetailsForBallEventsBE.BOWLINGEND;
    //self.ballEventRecord.bow =getBallDetailsForBallEventsBE.BOWLTYPECODE;
    
    self.ballEventRecord.objBowltype =getBallDetailsForBallEventsBE.BOWLTYPECODE;
    //self.ballEventRecord.bow =getBallDetailsForBallEventsBE.BOWLERTYPE;
    //self.ballEventRecord.objShottype =getBallDetailsForBallEventsBE.SHOTCODE;
    //self.ballEventRecord.objInningsno =getBallDetailsForBallEventsBE.SHOTNAME;
    self.ballEventRecord.objShottype =getBallDetailsForBallEventsBE.SHOTCODE;
    self.ballEventRecord.objShorttypecategory =getBallDetailsForBallEventsBE.SHOTTYPECATEGORY;
    self.ballEventRecord.objIslegalball =getBallDetailsForBallEventsBE.ISLEGALBALL;
    self.ballEventRecord.objIsFour =getBallDetailsForBallEventsBE.ISFOUR;
    
    self.ballEventRecord.objIssix =getBallDetailsForBallEventsBE.ISSIX;
    self.ballEventRecord.objRuns =getBallDetailsForBallEventsBE.RUNS;
    self.ballEventRecord.objOverthrow =getBallDetailsForBallEventsBE.OVERTHROW;
    self.ballEventRecord.objTotalruns =getBallDetailsForBallEventsBE.TOTALRUNS;
    self.ballEventRecord.objWide =getBallDetailsForBallEventsBE.WIDE;
    self.ballEventRecord.objNoball =getBallDetailsForBallEventsBE.NOBALL;
    self.ballEventRecord.objByes =getBallDetailsForBallEventsBE.BYES;
    self.ballEventRecord.objLegByes =getBallDetailsForBallEventsBE.LEGBYES;
    self.ballEventRecord.objPenalty =getBallDetailsForBallEventsBE.PENALTY;
    self.ballEventRecord.objTotalextras =getBallDetailsForBallEventsBE.TOTALEXTRAS;
    self.ballEventRecord.objGrandtotal =getBallDetailsForBallEventsBE.GRANDTOTAL;
    self.ballEventRecord.objPMStrikepoint =getBallDetailsForBallEventsBE.PMSTRIKEPOINT;
    self.ballEventRecord.objPMStrikepointlinecode =getBallDetailsForBallEventsBE.PMSTRIKEPOINTLINECODE;
    self.ballEventRecord.objWWREGION =getBallDetailsForBallEventsBE.WWREGION;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.REGIONNAME;
    self.ballEventRecord.objWWX1 =getBallDetailsForBallEventsBE.WWX1;
    self.ballEventRecord.objWWY1 =getBallDetailsForBallEventsBE.WWY1;
    self.ballEventRecord.objWWX2 =getBallDetailsForBallEventsBE.WWX2;
    self.ballEventRecord.objWWY2 =getBallDetailsForBallEventsBE.WWY2;
    self.ballEventRecord.objballduration =getBallDetailsForBallEventsBE.BALLDURATION;
    self.ballEventRecord.objIsappeal =getBallDetailsForBallEventsBE.ISAPPEAL;
    self.ballEventRecord.objUncomfortclassification =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFCATION;
    self.ballEventRecord.objMarkedforedit =getBallDetailsForBallEventsBE.MARKEDFOREDIT;
    self.ballEventRecord.objRemark =getBallDetailsForBallEventsBE.REMARKS;
    self.ballEventRecord.objBallspeed =getBallDetailsForBallEventsBE.BALLSPEED;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.BALLSPEEDTYPE;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.BALLSPEEDCODE;
    self.ballEventRecord.objUncomfortclassification =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFICATION;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFICATIONCODE;
    //self.ballEventRecord. =getBallDetailsForBallEventsBE.UNCOMFORTCLASSIFICATIONSUBCODE;
    
    
}





-(void)viewWillAppear:(BOOL)animated
{
     //indexCount = 0;
    inningsDetail =[[NSMutableArray alloc]init];
    OversorderArray =[[NSMutableArray alloc]init];
    
    OversorderArray =[objDBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
    inningsDetail=[objDBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    
    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
        // self.btn_third_inns_id.hidden = YES;
        // self.btn_fourth_inns_id.hidden = YES;
         [self.tbl_innnings reloadData];
    }
    if(isEdit==YES)
    {
        //[self.tbl_innnings reloadData];
        CGFloat xposition=self.selectbtnhighlight.frame.origin.x;
        CGFloat btn1xposition=self.Btn_innings1team1.frame.origin.x;
        CGFloat btn2xposition=self.Btn_innings1team2.frame.origin.x;
        CGFloat btn3xposition =self.Btn_inning2steam1.frame.origin.x;
        CGFloat btn4xposition =self.Btn_innings2team2.frame.origin.x;
        if(xposition==btn1xposition)
        {
            [self.Btn_innings1team1 sendActionsForControlEvents:UIControlEventTouchUpInside];
            NSLog(@"constant");
        }
       else if(xposition==btn2xposition)
        {
            [self.Btn_innings1team2 sendActionsForControlEvents:UIControlEventTouchUpInside];
            NSLog(@"constant");
        }
        else if (xposition==btn3xposition)
        {
            [self.Btn_inning2steam1 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else if (xposition==btn4xposition)
        {
            [self.Btn_innings2team2 sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
  
}
-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"ARCHIVES";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [OversorderArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditModeCell";
    
    NSInteger currentRow = indexPath.row;
    EditModeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OversorderRecord *objOversorderRecord=(OversorderRecord *)[OversorderArray objectAtIndex:indexPath.row];
    InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:indexPath.row];
    cell.lbl_playername.text =objOversorderRecord.BowlerName;
    
   // cell.lbl_overs.text= objOversorderRecord.OversOrder;
    cell.lbl_overs.text = [NSString stringWithFormat:@"%d",[objOversorderRecord.OversOrder intValue]+1];
    NSString *strCurrentRow=[NSString stringWithFormat:@"%d",currentRow];
    objoverballCount =[[NSMutableArray alloc]init];
    eachoverRun =[[NSMutableArray alloc]init];
    objOverrthrow =[[NSMutableArray alloc]init];
    
    objWide     =[[NSMutableArray alloc]init];
    objlegByes     =[[NSMutableArray alloc]init];
    objByes     =[[NSMutableArray alloc]init];
    objIsfour     =[[NSMutableArray alloc]init];
    objissix     =[[NSMutableArray alloc]init];
    objWicketno     =[[NSMutableArray alloc]init];
    objwicketType     =[[NSMutableArray alloc]init];
    objnoballArray   =[[NSMutableArray alloc]init];
    objGrandTotal   =[[NSMutableArray alloc]init];
    objBallNo   =[[NSMutableArray alloc]init];
    objRowNumber  =[[NSMutableArray alloc]init];

    if (cell != nil) {
        
        
        for(int i=0; i < [inningsDetail count]; i++)
        {
            InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:i];
            
            NSString *ballcount=objInningsBowlerDetailsRecord.ballNo;
            NSString * objRun    =objInningsBowlerDetailsRecord.Runs;
            NSString * objoverThrow =objInningsBowlerDetailsRecord.overThrow;
            NSString * objWidevalue =objInningsBowlerDetailsRecord.Wide;
            NSString * objLegbyes =objInningsBowlerDetailsRecord.Legbyes;
            NSString * objByesvalue =objInningsBowlerDetailsRecord.Byes;
            NSString * objisFour =objInningsBowlerDetailsRecord.isFour;
            NSString * objisSix =objInningsBowlerDetailsRecord.isSix;
            NSString * objWicketNo =objInningsBowlerDetailsRecord.WicketNo;
            NSString * objWicketType =objInningsBowlerDetailsRecord.WicketType;
            NSString  * objNoBall    =objInningsBowlerDetailsRecord.noBall;
            NSString  * grandTotal    =objInningsBowlerDetailsRecord.grandTotal;
            NSString  * ballNo    =objInningsBowlerDetailsRecord.ballNo;
            
            if([strCurrentRow isEqualToString:objInningsBowlerDetailsRecord.OverNo])
            {
                [objoverballCount addObject: ballcount];
                [eachoverRun addObject:objRun];
                [objOverrthrow addObject:objoverThrow];
                [objWide addObject:objWidevalue];
                [objlegByes addObject:objLegbyes];
                [objByes addObject:objByesvalue];
                [objIsfour addObject:objisFour];
                [objissix addObject:objisSix];
                [objWicketno addObject:objWicketNo];
                [objwicketType addObject:objWicketType];
                [objnoballArray addObject:objNoBall];
                [objGrandTotal addObject:grandTotal];
                [objBallNo addObject:ballNo];
                [objRowNumber addObject:objInningsBowlerDetailsRecord.rowId];
                
            }
        }
        for (UILabel *view in cell.view_main.subviews) {
            [view removeFromSuperview];
        }
        
        for(int j=0; j< objoverballCount.count; j++)
        {
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((j*40.0)+15,50.0, 30.0, 15.0)];
            [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
            [nameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
            nameLabel.textAlignment=NSTextAlignmentCenter;
            
            [cell.view_main addSubview:nameLabel];
            InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:j];
            
//            nameLabel .text=[NSString stringWithFormat:@"%@.%@",[@(currentRow) stringValue],[@(j+1) stringValue]];
            nameLabel .text=[NSString stringWithFormat:@"%@.%@",objOversorderRecord.OversOrder,[objBallNo objectAtIndex:j]];
            
            nameLabel.textColor=[UIColor whiteColor];
            
        }
        
    }
    
    [self createboltierMethod:currentRow :cell ];
    cell.lbl_overcountwkt.text=[NSString stringWithFormat:@"%d/ %d",totalRun,EachoverWicketCount];
    totalRun=0;
    EachoverWicketCount=0;
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    self.tbl_innnings.separatorColor = [UIColor clearColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(void)createboltierMethod:(int *) indexpath :(EditModeCell *)cell
{
    NSLog(@"%d",indexpath);
    
    for(int i=0; i< objoverballCount.count; i++)
    {
        InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:i];
        indexpath=i;
        NSString * objoverThrow =[objOverrthrow objectAtIndex:i];
        NSString * objRuns      =[eachoverRun objectAtIndex:i];
        NSString * objnoball     =[objnoballArray objectAtIndex:i];
        NSString * objWidevalue =[objWide objectAtIndex:i];
        NSString * objLegbyes =[objlegByes objectAtIndex:i];
        NSString * objByesvalue =[objByes objectAtIndex:i];
        NSString * objisFour =[objIsfour objectAtIndex:i];
        NSString * objisSix =[objissix objectAtIndex:i];
        NSString * objWicketNo =[objWicketno objectAtIndex:i];
        NSString * objWicketType =[objwicketType objectAtIndex:i];
        NSString * grandTotal =[objGrandTotal objectAtIndex:i];
        NSNumber *rowId =[objRowNumber objectAtIndex:i];
        
        NSMutableArray* dicBallKeysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary * dicAddbowlerdetails=[[NSMutableDictionary alloc]init];
        int overThrow = [objoverThrow intValue];
        int runs      = [objRuns intValue]+overThrow;
       unsigned int noBall  = [objnoball integerValue];
        int wide      = [objWidevalue intValue];
        int legalbyes = [objLegbyes intValue];
        int byes      = [objByesvalue intValue];
        
        noBall =noBall > 1 ?noBall-1:noBall;
        if([objisFour isEqualToString:@"1"])
        {
            [dicAddbowlerdetails setValue:@"4" forKey:@"RUNS"];
        }
        else if ([objisSix isEqualToString:@"1"])
        {
            [dicAddbowlerdetails setValue:@"6" forKey:@"RUNS"];
        }
        else
        {
            NSString* runValue = [NSString stringWithFormat:@"%i", runs];
            [dicAddbowlerdetails setValue:runValue forKey:@"RUNS"];
        }
        [dicBallKeysArray addObject:@"RUNS"];
        if (noBall!=0)//Ball ticker for no balls.
        {
            int obj =noBall;
            if (obj>0)
            {
                
                
                obj =--obj;
                
                int  noBall = obj+runs;
                NSString* noballValues = [NSString stringWithFormat:@"%d",noBall];
                [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
                [dicAddbowlerdetails setValue:noballValues forKey:@"RUNS"];
                
            }
            [dicAddbowlerdetails setObject:@"NB" forKey:@"EXTRAS-NB"];
            [dicBallKeysArray addObject:@"EXTRAS-NB"];
            
        }
        if (wide != 0)//Ball ticker for wide balls.
        {
            if (wide > 0)
            {
                NSString* wideValues = [NSString stringWithFormat:@"%d", wide-1];
                [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
                [dicAddbowlerdetails setValue:wideValues forKey:@"RUNS"];
            }
            [dicAddbowlerdetails setObject:@"WD" forKey:@"EXTRAS"];
            [dicBallKeysArray addObject:@"EXTRAS"];
            
        }
        
        if (legalbyes != 0)//Ball ticker for leg byes.
        {
            if (legalbyes > 0)
            {
//                if(noBall== 0)
//                {
//                    noBall=0;
//                }
//                else{
//                    noBall=noBall-1;
//                }
//                int objlegalbyesValues = legalbyes+noBall;
//                NSString *legalbyesValues=[NSString stringWithFormat:@"%d",objlegalbyesValues];
                [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
                [dicAddbowlerdetails setValue:[NSString stringWithFormat:@"%i", (legalbyes + /*_overthrow +*/ (noBall == 0 ? 0 : noBall - 1))] forKey: @"RUNS"];
                
            }
            if (noBall == 0)
            {
                [dicAddbowlerdetails setValue:@"LB" forKey:@"EXTRAS"];
                [dicBallKeysArray addObject:@"EXTRAS"];
            }
        }
        
        if (byes != 0)//Ball ticker for byes.
        {
            if (byes > 0)
            {
                int objbyesValues = byes+(noBall==0?0:noBall-1);
                NSString *byesValues=[NSString stringWithFormat:@"%d",objbyesValues];
                [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
                [dicAddbowlerdetails setValue:byesValues forKey:@"RUNS"];
                
            }
            if (noBall == 0)
            {
                [dicAddbowlerdetails setValue:@"B" forKey:@"EXTRAS"];
                [dicBallKeysArray addObject:@"EXTRAS"];
            }
        }
        // MessageBox.Show(drballdetails["WICKETNO"].ToString());
        if (![objWicketNo isEqualToString:@"0"])
        {
            if ([objWicketType isEqualToString:@"MSC102"])
                [dicAddbowlerdetails setValue:@"RH" forKey:@"WICKETS"];
            
            else
            {
                [dicAddbowlerdetails setValue:@"W" forKey:@"WICKETS"];
                NSString *wickCount = [dicAddbowlerdetails valueForKey:@"WICKETS"];
                if([wickCount isEqualToString:@"W"])
                {
                    EachoverWicketCount =1+EachoverWicketCount;
                }
            }
            [dicBallKeysArray addObject:@"WICKETS"];
            //dicBall.Add("WICKETS", "W");
        }
        
        //MSC134 - BATTING, MSC135 - BOWLING
        int  penalty ;
        NSString * penaltyLabel = objInningsBowlerDetailsRecord.penaltytypeCode;
        penalty = [objInningsBowlerDetailsRecord.penaltyRuns intValue];
        if ((![penaltyLabel isEqualToString: @""]) && penalty > 0)
        {
            if([penaltyLabel isEqualToString:@"MSC134"])
            {
                penaltyLabel=[NSString stringWithFormat:@"BP %i",penalty];
            }
            else if ([penaltyLabel isEqualToString:@"MSC135"])
            {
                penaltyLabel =[NSString stringWithFormat:@"FP %i",penalty];
            }
            else{
                penaltyLabel=@"";
            }
            [dicAddbowlerdetails setValue:penaltyLabel forKey:@"PENALTY"];
            [dicBallKeysArray addObject:@"PENALTY"];
            
        }
        
        NSString * content=@"";
        bool isExtras ;
        bool isSix =[objisSix isEqualToString:@"1"]? YES: NO;
        bool isFour =[objisFour isEqualToString:@"1"]? YES:NO;
        bool isSpecialEvents;
        if(isFour == YES || isSix == YES || ![objWicketNo isEqualToString:@"0"])
        {
            isSpecialEvents=YES;
        }
        else{
            isSpecialEvents=NO;
        }
        for(int i = 0; i < dicBallKeysArray.count; i++)
        {
            NSString *dicBallKey = [dicBallKeysArray objectAtIndex:i];
            isExtras = [[dicAddbowlerdetails valueForKey:dicBallKey ] isEqualToString:@"WD"] ||
            [[dicAddbowlerdetails valueForKey:dicBallKey] isEqualToString:@"NB"] ||
            [[dicAddbowlerdetails valueForKey:dicBallKey] isEqualToString:@"B"] ||
            [[dicAddbowlerdetails valueForKey:dicBallKey] isEqualToString:@"LB"] ||
            [[dicAddbowlerdetails valueForKey:dicBallKey] isEqualToString:@"PENALTY"];
            
            if ([dicBallKey isEqual: @"RUNS"] && [[dicAddbowlerdetails objectForKey:dicBallKey] isEqual : @"0"] && dicAddbowlerdetails.count > 1)
                content = [content stringByAppendingString: content];
            else
                content = [content stringByAppendingString: [[dicAddbowlerdetails objectForKey:dicBallKey] stringByAppendingString:@" "]];
        }
        totalRun  =[grandTotal intValue]+totalRun;
        [self CreateBallTickerInstance: [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] :isExtras :isSpecialEvents :objnoball :cell :indexpath: rowId.intValue];
        
    }
    
}


// [self CreateBallTickerInstance:content :isExtras :isSpecialEvents :objInningsBowlerDetailsRecord.ballNo :cell];



-(void)CreateBallTickerInstance:(NSString *)content :(BOOL ) isextra: (BOOL) isspecialevent :(NSString *)ballno :(EditModeCell *) cell: (int) currentindex: (int) rowId;
{
    
    btn_Run = [[UIButton alloc] initWithFrame:CGRectMake((currentindex*40.0)+15,5.0,35.0, 35.0)];
    // NSString *objeachRunsValue =[eachoverRun objectAtIndex:i];
    [btn_Run setBackgroundColor:[UIColor clearColor]];
    [btn_Run setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [btn_Run setTitle:[NSString stringWithFormat:content] forState:UIControlStateNormal];
    btn_Run.font=[UIFont fontWithName:@"Rajdhani-Bold" size:10];
    //[btn_Run sizeToFit];
    btn_Run .layer. cornerRadius=17;
    btn_Run.layer.borderWidth=2;
    btn_Run.layer.borderColor= [UIColor redColor].CGColor;
    btn_Run.layer.masksToBounds=YES;
    //btn_Run.tag =currentindex;
  //  indexCount++;
    
    btn_Run.tag = rowId;
    
    
    [btn_Run addTarget:self action:@selector(didClickEditAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.view_main addSubview:btn_Run];
    content = [content isEqual: @"0 W"] ? @"W" : content;
    content = [content isEqual: @"0 NB" ]? @"NB" : content;
    content = [content isEqual: @"0 WD"] ? @"WD" : content;
    content = [content isEqual: @"0 RH"] ? @"RH" : content;
    double singleInstanceWidth = isextra ? 55 : 30;
    double totalWidth = singleInstanceWidth;
    if (content.length > 5)
        totalWidth = 10 * content.length;
    else if (content.length >= 3)
        totalWidth = 13 * content.length;
    // btn_Run.frame.size.width = totalWidth;
    
    
    if([content isEqualToString:@"4"])
    {
        [btn_Run setBackgroundColor: ((isspecialevent) ? fourBrushBDR : ((isextra) ? extrasBrushBG : runBrushBG))];
        btn_Run.layer.borderColor= ((isspecialevent) ? fourBrushBDR : runBrushBDR).CGColor;
    }
    else if([content isEqualToString :@"6" ])
    {
        [btn_Run setBackgroundColor: ((isspecialevent) ? sixBrushBDR : ((isextra) ? extrasBrushBG : runBrushBG))];
        
        btn_Run.layer.borderColor= ((isspecialevent) ? sixBrushBDR : runBrushBDR).CGColor;
    }
    
    else if([content isEqualToString :@"W"])
    {
        [btn_Run setBackgroundColor:wicketBrushBG];
        btn_Run.layer.borderColor= wicketBrushBDR.CGColor;
        
    }
    else
    {
        btn_Run.layer.borderColor=  ((isextra) ? extrasBrushBDR : runBrushBDR).CGColor;
        btn_Run.layer.backgroundColor =((isextra) ? extrasBrushBG : runBrushBG).CGColor;

    }
    
    [btn_Run setTitle:[NSString stringWithFormat:content] forState:UIControlStateNormal];

    
}





-(IBAction)didClickEditAction:(id)sender
{
    
    if(view_addedit != nil)
    {
        [view_addedit removeFromSuperview];
        [leftrotation removeFromSuperview];
        [Rightrotation removeFromSuperview];
        [Cancelrotation removeFromSuperview];
        [Editrotation removeFromSuperview];
    }
    UIButton * btn_add = (UIButton *)sender;
    
    
    
    ballCodeIndex= btn_add.tag;
    
    
    EditModeCell *cell = (EditModeCell*)[sender superview];
    NSIndexPath* indexPath = [self.tbl_innnings indexPathForCell:cell];
    view_addedit=[[UIView alloc]initWithFrame:CGRectMake(btn_add.frame.origin.x-20,btn_add.frame.origin.y+40,175,100)];
    [view_addedit setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
    [cell addSubview:view_addedit];
    leftrotation=[[UIButton alloc]initWithFrame:CGRectMake(view_addedit.frame.origin.x, view_addedit.frame.origin.y+3,38,38)];
    [leftrotation setImage:[UIImage imageNamed:@"LeftRotation"] forState:UIControlStateNormal];
    [cell addSubview:leftrotation];
    [leftrotation addTarget:self action:@selector(didClickLeftRotation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    NSIndexPath* pathOfTheCell = [self.tbl_innnings indexPathForCell:buttonCell];
    //    NSInteger rowOfTheCell = [pathOfTheCell row];
    
    
    
    Editrotation=[[UIButton alloc]initWithFrame:CGRectMake(leftrotation.frame.origin.x+leftrotation.frame.size.width+8, leftrotation.frame.origin.y,38,38)];
    [Editrotation setImage:[UIImage imageNamed:@"ArchiveEdit"] forState:UIControlStateNormal];
    Editrotation.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:Editrotation];
    
    [Editrotation addTarget:self action:@selector(didClickEditrotation:) forControlEvents:UIControlEventTouchUpInside];
    
    Cancelrotation=[[UIButton alloc]initWithFrame:CGRectMake(Editrotation.frame.origin.x+Editrotation.frame.size.width+8, Editrotation.frame.origin.y,38,38)];
    [Cancelrotation setImage:[UIImage imageNamed:@"ArchiveCancel"] forState:UIControlStateNormal];
    [cell addSubview:Cancelrotation];
    [Cancelrotation addTarget:self action:@selector(didClickCancelrotation:) forControlEvents:UIControlEventTouchUpInside];
    
    Rightrotation=[[UIButton alloc]initWithFrame:CGRectMake(Cancelrotation.frame.origin.x+Cancelrotation.frame.size.width+8, Cancelrotation.frame.origin.y,38,38)];
    [Rightrotation setImage:[UIImage imageNamed:@"RightRotation"] forState:UIControlStateNormal];
    [cell addSubview:Rightrotation];
    [Rightrotation addTarget:self action:@selector(didClickRightrotation:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(IBAction)didClickLeftRotation:(id)sender
{
    InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:ballCodeIndex];
    ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
    scoreEngine.competitionCode=self.Comptitioncode;
    scoreEngine.matchCode = self.matchCode;
    
    scoreEngine.isEditMode = YES;
    scoreEngine.editBallCode = objInningsBowlerDetailsRecord.ballCode;
    [self insertAfterAndBeforeMode:objInningsBowlerDetailsRecord.ballCode];
    
    [scoreEngine insertBallDetails:objInningsBowlerDetailsRecord.ballCode :@"BEFORE"];
    
   // indexCount = 0;
    [self.tbl_innnings reloadData];
    OversorderArray =[objDBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
    
    inningsDetail=[objDBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    
    
}

-(IBAction)didClickEditrotation:(id)sender
{
    
    //
    //    int overIndex = ((senderButton.tag-30000)%10000)/10;
    //    int ballIndex = ((senderButton.tag-(overIndex*10))-30000)/10000;
    //
    isEdit=YES;
    InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:ballCodeIndex];
    ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
    
    scoreEngine =(ScorEnginVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
    scoreEngine.matchCode=self.matchCode;
    scoreEngine.competitionCode=self.Comptitioncode;
    scoreEngine.isEditMode = YES;
    scoreEngine.editBallCode = objInningsBowlerDetailsRecord.ballCode;
    [self.navigationController pushViewController:scoreEngine animated:NO];
}
-(IBAction)didClickCancelrotation:(id)sender
{
    
}
-(IBAction)didClickRightrotation:(id)sender
{
    InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:ballCodeIndex];
    ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
    scoreEngine.competitionCode=self.Comptitioncode;
    scoreEngine.matchCode = self.matchCode;
    scoreEngine.isEditMode = YES;
    scoreEngine.editBallCode = objInningsBowlerDetailsRecord.ballCode;
    [self insertAfterAndBeforeMode:objInningsBowlerDetailsRecord.ballCode];
    
    [scoreEngine insertBallDetails:objInningsBowlerDetailsRecord.ballCode :@"AFTER"];
   // indexCount = 0;

    [self.tbl_innnings reloadData];
    OversorderArray =[objDBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
    
    inningsDetail=[objDBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
}

-(IBAction)didClickInnings1team1:(id)sender
{
  //  indexCount = 0;
    self.highlightbtnxposition.constant=0;
    OversorderArray =[objDBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
    inningsDetail=[objDBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    [_tbl_innnings reloadData];
    
}
-(IBAction)didClickInnings1team2:(id)sender
{
   // indexCount = 0;
    self.highlightbtnxposition.constant=self.Btn_innings1team2.frame.origin.x;
    OversorderArray =[objDBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"2"];
    inningsDetail=[objDBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"2"];
    [_tbl_innnings reloadData];
    
}
-(IBAction)didClickInnings2team1:(id)sender
{
   // indexCount = 0;
    self.highlightbtnxposition.constant=self.Btn_inning2steam1.frame.origin.x;
    OversorderArray =[objDBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"3"];
    inningsDetail=[objDBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"3"];
    [_tbl_innnings reloadData];
}
-(IBAction)didClickInnings2team2:(id)sender
{
    self.highlightbtnxposition.constant=self.Btn_innings2team2.frame.origin.x;
    OversorderArray =[objDBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"4"];
    inningsDetail=[objDBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"4"];
    [_tbl_innnings reloadData];
}
-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
