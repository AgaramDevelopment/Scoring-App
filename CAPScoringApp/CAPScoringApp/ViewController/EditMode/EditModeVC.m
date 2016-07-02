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


@interface EditModeVC ()
{
    CustomNavigationVC * objCustomNavigation;
    NSMutableArray* inningsDetail;
    NSMutableArray * OversorderArray;
    
    UIView * view_addedit;
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
    int EachoverWicketCount;
    UIButton *btn_Run;
    NSInteger ballCodeIndex;
    int indexCount ;
}

@end

@implementation EditModeVC

- (void)viewDidLoad {
     indexCount = 0;
    [super viewDidLoad];
    [self customnavigationmethod];
    inningsDetail =[[NSMutableArray alloc]init];
    OversorderArray =[[NSMutableArray alloc]init];
    //CGFloat totalwidth =1200;
   
    [self.view layoutIfNeeded];
    
    self.Btn_innings1team1.frame= CGRectMake(self.Btn_innings1team1.frame.origin.x, self.Btn_innings1team1.frame.origin.y, 400, self.Btn_innings1team1.frame.size.height);
    
    
    //self.inningsviewWidth.constant =totalwidth;
    //self.btn_innings1Widthposition.constant=400;
    //self.btn_innings2xposition.constant     =self.btn_innings1Widthposition.constant+10;
    // self.inningButtonView.constant = totalwidth;
    OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
   inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    
    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
       // self.btn_third_inns_id.hidden = YES;
       // self.btn_fourth_inns_id.hidden = YES;
    }
    // Do any additional setup after loading the view.
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
    
     currentRow = indexPath.row;
    EditModeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OversorderRecord *objOversorderRecord=(OversorderRecord *)[OversorderArray objectAtIndex:indexPath.row];
     InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:indexPath.row];
    cell.lbl_playername.text =objOversorderRecord.BowlerName;
   
    cell.lbl_overs.text= objOversorderRecord.OversOrder;
    
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
                     }
                }
        for (UILabel *view in cell.view_main.subviews) {
            [view removeFromSuperview];
        }
       
        for(int j=0; j< objoverballCount.count; j++)
            {
                
                
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((j*40.0)+5,30.0, 30.0, 15.0)];
       [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [nameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
                nameLabel.textAlignment=NSTextAlignmentCenter;
       
           [cell.view_main addSubview:nameLabel];
            InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:indexPath.row];
              
                nameLabel .text=[NSString stringWithFormat:@"%@.%@",[@(currentRow) stringValue],[@(j+1) stringValue]];
                        nameLabel.textColor=[UIColor whiteColor];
               
                 //nameLabel .text=@"";
//               UIButton *btn_Run = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.origin.x,30.0,cell.frame.size.width,cell.frame.size.height-30)];
               
                //[btn_Run setBackgroundColor:[UIColor clearColor]];
               /// [btn_Run setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               // [btn_Run setTitle:@"1" forState:UIControlStateNormal];
                //btn_Run .layer. cornerRadius=15;
                //btn_Run.layer.borderWidth=2;
               // btn_Run.layer.borderColor= [UIColor redColor].CGColor;
               //btn_Run.layer.masksToBounds=YES;
               // [btn_Run addTarget:self action:@selector(GetCellIndexPath:) forControlEvents:UIControlEventTouchUpInside];
               
                //[cell.view_main addSubview:btn_Run];
              


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
    
    return 90;
    
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
    
    NSMutableDictionary * dicAddbowlerdetails=[[NSMutableDictionary alloc]init];
    int overThrow = [objoverThrow intValue];
    int runs      = [objRuns intValue]+overThrow;
    int noBall    = [objnoball intValue];
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
    
    if (noBall != 0)//Ball ticker for no balls.
    {
        if (noBall > 0)
        {
            noBall =noBall-1;
           
            int  noBall = noBall+runs;
             NSString* noballValues = [NSString stringWithFormat:@"%d",noBall];
            [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
            [dicAddbowlerdetails setValue:noballValues forKey:@"RUNS"];
          
        }
        [dicAddbowlerdetails setObject:@"NB" forKey:@"EXTRAS-NB"];
        
    }
    if (wide != 0)//Ball ticker for wide balls.
    {
        if (wide > 0)
        {
             NSString* wideValues = [NSString stringWithFormat:@"%d", wide-1];
             [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
             [dicAddbowlerdetails setValue:wideValues forKey:@"RUNS"];
        }
        [dicAddbowlerdetails setObject:@"WD" forKey:@"EXTRAS-NB"];
        
    }

    if (legalbyes != 0)//Ball ticker for leg byes.
    {
        if (legalbyes > 0)
        {
            if(noBall== 0)
            {
                noBall=0;
            }
            else{
                noBall=noBall-1;
            }
            int objlegalbyesValues = legalbyes+noBall;
            NSString *legalbyesValues=[NSString stringWithFormat:@"%d",objlegalbyesValues];
            [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
            [dicAddbowlerdetails setValue:legalbyesValues forKey:@"RUNS"];
            
        }
        if (noBall == 0)
            [dicAddbowlerdetails setValue:@"LB" forKey:@"EXTRAS"];
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
            [dicAddbowlerdetails setValue:@"B" forKey:@"EXTRAS"];
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

            //dicBall.Add("WICKETS", "W");
        }
        
        //MSC134 - BATTING, MSC135 - BOWLING
        int  penalty ;
        NSString * penaltyLabel = objInningsBowlerDetailsRecord.penaltytypeCode;
       // int.TryParse(drballdetails["PENALTYRUNS"].ToString(), out _penalty);
        if (![penaltyLabel isEqualToString:@""] && penalty > 0)
        {
            if([penaltyLabel isEqualToString:@"MSC134"])
            {
                penaltyLabel=[NSString stringWithFormat:@"BP +%d",penalty];
            }
            else if ([penaltyLabel isEqualToString:@"MSC135"])
            {
                penaltyLabel =[NSString stringWithFormat:@"FP + %@",penalty];
            }
            else{
                penaltyLabel=@"";
            }
          //  penaltyLabel = [penaltyLabel isEqualToString:@"MSC134"] ? ("BP " + penalty) : [penaltyLabel isEqualToString @"MSC135" ] ? ("FP " + penalty) : "";
            
            [dicAddbowlerdetails setValue:penaltyLabel forKey:@"PENALTY"];
            
        }
    
        NSString * content=@"";
        bool isExtras ;
        bool isSix =[objisSix isEqualToString:@"1"]? YES: NO;
        bool isFour =[objisFour isEqualToString:@"1"]? YES:NO;
        bool isSpecialEvents;
        if(isFour == YES || isSix == YES || ![objWicketNo isEqualToString:@""])
        {
            isSpecialEvents=YES;
        }
        else{
            isSpecialEvents=NO;
        }
    NSString * runvalue;
        for(NSString * kvpItem in dicAddbowlerdetails)
        {
            isExtras = [[dicAddbowlerdetails valueForKey:kvpItem ] isEqualToString:@"WD"] || [[dicAddbowlerdetails valueForKey:kvpItem] isEqualToString:@"NB"] || [[dicAddbowlerdetails valueForKey:kvpItem] isEqualToString:@"B"] || [[dicAddbowlerdetails valueForKey:kvpItem] isEqualToString:@"LB"] || [[dicAddbowlerdetails valueForKey:kvpItem] isEqualToString:@"PENALTY"];
            NSString * dicRunValue =[dicAddbowlerdetails valueForKey:kvpItem];
            if ([kvpItem isEqualToString:@"RUNS"] && [dicRunValue isEqualToString:@"0"] &&  dicAddbowlerdetails.count > 1)
                content = [dicAddbowlerdetails valueForKey:@"RUNS" ];
            else
            {
                 runvalue=[dicAddbowlerdetails valueForKey:@"RUNS"];
                
                
                NSString * extraValue =(![kvpItem isEqualToString:@"RUNS"])? [dicAddbowlerdetails valueForKey:kvpItem]:@"";
                content =[runvalue stringByAppendingString:extraValue];
            }   //kvpItem.Value + " ";
        }
    if(runvalue != @"")
    {
        totalRun  =[runvalue intValue]+totalRun;
    }

    
        [self CreateBallTickerInstance:content :isExtras :isSpecialEvents :objnoball :cell :indexpath];

    }

}


   // [self CreateBallTickerInstance:content :isExtras :isSpecialEvents :objInningsBowlerDetailsRecord.ballNo :cell];



-(void)CreateBallTickerInstance:(NSString *)content :(BOOL ) isextra: (BOOL) isspecialevent :(NSString *)ballno :(EditModeCell *) cell: (int) currentindex;
{
    
    btn_Run = [[UIButton alloc] initWithFrame:CGRectMake((currentindex*40.0)+5,2.0,33.0, 35.0)];
       // NSString *objeachRunsValue =[eachoverRun objectAtIndex:i];
    [btn_Run setBackgroundColor:[UIColor clearColor]];
    [btn_Run setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    [btn_Run setTitle:[NSString stringWithFormat:content] forState:UIControlStateNormal];
    btn_Run.font=[UIFont fontWithName:@"Rajdhani-Bold" size:10];
    [btn_Run sizeToFit];
    btn_Run .layer. cornerRadius=11;
    btn_Run.layer.borderWidth=2;
    btn_Run.layer.borderColor= [UIColor redColor].CGColor;
    btn_Run.layer.masksToBounds=YES;
    //btn_Run.tag =currentindex;
    indexCount++;

    btn_Run.tag = indexCount;
    
    
    [btn_Run addTarget:self action:@selector(didClickEditAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.view_main addSubview:btn_Run];
    
    content = content == @"0 W" ? @"W" : content;
    content = content == @"0 NB" ? @"NB" : content;
    content = content == @"0 WD" ? @"WD" : content;
    content = content == @"0 RH" ? @"RH" : content;
    double singleInstanceWidth = isextra ? 55 : 30;
    double totalWidth = singleInstanceWidth;
    if (content.length > 5)
        totalWidth = 10 * content.length;
    else if (content.length >= 3)
        totalWidth = 13 * content.length;
   // btn_Run.frame.size.width = totalWidth;
    
    
    if([content isEqualToString:@"4"])
    {
         [btn_Run setBackgroundColor:[UIColor colorWithRed:(0.0/255.0f) green:(176.0/255.0f) blue:(191.0/255.0f) alpha:1.0f]];
         btn_Run.layer.borderColor= [UIColor clearColor].CGColor;
    }
    else if([content isEqualToString :@"6" ])
    {
        [btn_Run setBackgroundColor: [UIColor colorWithRed:(0.0/255.0f) green:(161.0/255.0f) blue:(90.0/255.0f) alpha:1.0f]];

         btn_Run.layer.borderColor= [UIColor clearColor].CGColor;
    }
    
    else if([content isEqualToString :@"W"])
    {
         [btn_Run setBackgroundColor:[UIColor colorWithRed:(196.0/255.0f) green:(40.0/255.0f) blue:(38.0/255.0f) alpha:1.0f]];
        btn_Run.layer.borderColor= [UIColor clearColor].CGColor;
        
    }
    else
    {
        btn_Run.layer.borderColor= [UIColor colorWithRed:(231.0/255.0f) green:(211.0/255.0f) blue:(76.0/255.0f) alpha:1.0f].CGColor;
    }
    
    
}


-(IBAction)GetCellIndexPath:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    EditModeCell *buttonCell = (EditModeCell *)[senderButton superview];
    
    NSIndexPath* pathOfTheCell = [self.tbl_innnings indexPathForCell:buttonCell];
    NSInteger rowOfTheCell = [pathOfTheCell row];
    NSLog(@"rowofthecell %d", rowOfTheCell);
    objSelectBallCodeArray=[[NSMutableArray alloc]init];
    OversorderRecord *objOversorderRecord=(OversorderRecord *)[OversorderArray objectAtIndex:rowOfTheCell];
    
    NSString *overNo=objOversorderRecord.OversOrder;
    
    
    
    
    for(int i=0; i < [inningsDetail count]; i++)
    {
        InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:i];
        NSString *objoverNo= objInningsBowlerDetailsRecord.OverNo;
        
        if([overNo isEqualToString:objoverNo])
        {
            
            NSString * objballcode =objInningsBowlerDetailsRecord.ballCode;
            NSLog(@"ballcode =%@",objballcode);
            [objSelectBallCodeArray addObject:objballcode];
           
        }
       
    }
   [self MoveEditToScore:seleBtnIndex];
}


-(IBAction)didClickEditAction:(id)sender
{
   
    if(view_addedit != nil)
    {
        [view_addedit removeFromSuperview];
    }
     UIButton * btn_add = (UIButton *)sender;
    
    int objIndex =btn_add.tag;
    seleBtnIndex =[NSString stringWithFormat:@"%d",objIndex];
    

    
   ballCodeIndex= btn_add.tag;
    

   EditModeCell *cell = (EditModeCell*)[sender superview];
    NSIndexPath* indexPath = [self.tbl_innnings indexPathForCell:cell];
     view_addedit=[[UIView alloc]initWithFrame:CGRectMake(btn_add.frame.origin.x-20,btn_add.frame.origin.y+30,130, 50)];
    [view_addedit setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
    [cell addSubview:view_addedit];
    UIButton * leftrotation=[[UIButton alloc]initWithFrame:CGRectMake(view_addedit.frame.origin.x, view_addedit.frame.origin.y, 25, 25)];
    [leftrotation setImage:[UIImage imageNamed:@"LeftRotation"] forState:UIControlStateNormal];
    [cell addSubview:leftrotation];
    [leftrotation addTarget:self action:@selector(didClickLeftRotation:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    NSIndexPath* pathOfTheCell = [self.tbl_innnings indexPathForCell:buttonCell];
//    NSInteger rowOfTheCell = [pathOfTheCell row];

    
    
    UIButton * Editrotation=[[UIButton alloc]initWithFrame:CGRectMake(leftrotation.frame.origin.x+leftrotation.frame.size.width+8, leftrotation.frame.origin.y, 25, 25)];
    [Editrotation setImage:[UIImage imageNamed:@"ArchiveEdit"] forState:UIControlStateNormal];
    [cell addSubview:Editrotation];
    
    [Editrotation addTarget:self action:@selector(didClickEditrotation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * Cancelrotation=[[UIButton alloc]initWithFrame:CGRectMake(Editrotation.frame.origin.x+Editrotation.frame.size.width+8, Editrotation.frame.origin.y, 25, 25)];
    [Cancelrotation setImage:[UIImage imageNamed:@"ArchiveCancel"] forState:UIControlStateNormal];
    [cell addSubview:Cancelrotation];
    [Cancelrotation addTarget:self action:@selector(didClickCancelrotation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * Rightrotation=[[UIButton alloc]initWithFrame:CGRectMake(Cancelrotation.frame.origin.x+Cancelrotation.frame.size.width+8, Cancelrotation.frame.origin.y, 25, 25)];
    [Rightrotation setImage:[UIImage imageNamed:@"RightRotation"] forState:UIControlStateNormal];
    [cell addSubview:Rightrotation];
    [Rightrotation addTarget:self action:@selector(didClickRightrotation:) forControlEvents:UIControlEventTouchUpInside];
    Btn_Indexpath = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.origin.x,0.0,cell.frame.size.width,40)];
    [Btn_Indexpath addTarget:self action:@selector(GetCellIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    Btn_Indexpath.tag=1;
    [cell addSubview:Btn_Indexpath];
}

-(IBAction)didClickLeftRotation:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    EditModeCell *buttonCell = (EditModeCell *)[senderButton superview];
    
    NSIndexPath* pathOfTheCell = [self.tbl_innnings indexPathForCell:buttonCell];
    NSInteger rowOfTheCell = [pathOfTheCell row];
    NSLog(@"rowofthecell %d", rowOfTheCell);
    for (id obj in buttonCell.subviews) {
        
        NSString *classStr = NSStringFromClass([obj class]);
        
        if ([classStr isEqualToString:@"UIButton"]) {
            
            UIButton *button = (UIButton*)obj;
            
//            int overIndex = ((senderButton.tag-30000)%10000)/10;
//            int ballIndex = ((senderButton.tag-(overIndex*10))-30000)/10000;
//            
            if(btn_Run.tag == button.tag)
            {
               button.layer.borderWidth = 2.0;
                button.layer.borderColor = [UIColor greenColor].CGColor;
            }
        }
    }
}

-(void)MoveEditToScore:(NSString*)selectIndex
{
   
//
//    int overIndex = ((senderButton.tag-30000)%10000)/10;
//    int ballIndex = ((senderButton.tag-(overIndex*10))-30000)/10000;
// 
    InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:ballCodeIndex-1];
    ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
    
    scoreEngine =(ScorEnginVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
    scoreEngine.matchCode=self.matchCode;
    scoreEngine.competitionCode=self.Comptitioncode;
    scoreEngine.isEditMode = YES;
    scoreEngine.editBallCode =[NSString stringWithFormat:@"%@",SelectBallCode];
    [self.navigationController pushViewController:scoreEngine animated:YES];
}
-(IBAction)didClickEditrotation:(id)sender
{
    
    
  [Btn_Indexpath sendActionsForControlEvents: UIControlEventTouchUpInside];
    
   
}
-(IBAction)didClickCancelrotation:(id)sender
{
    
}
-(IBAction)didClickRightrotation:(id)sender
{
    
}

-(IBAction)didClickInnings1team1:(id)sender
{
    self.highlightbtnxposition.constant=0;
    OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
    inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    [_tbl_innnings reloadData];

}
-(IBAction)didClickInnings1team2:(id)sender
{
    self.highlightbtnxposition.constant=self.Btn_innings1team2.frame.origin.x;
    OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"2"];
    inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"2"];
    [_tbl_innnings reloadData];

}
-(IBAction)didClickInnings2team1:(id)sender
{
     self.highlightbtnxposition.constant=self.Btn_inning2steam1.frame.origin.x;
    OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"3"];
    inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"3"];
    [_tbl_innnings reloadData];
}
-(IBAction)didClickInnings2team2:(id)sender
{
     self.highlightbtnxposition.constant=self.Btn_innings2team2.frame.origin.x;
    OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"4"];
    inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"4"];
    [_tbl_innnings reloadData];
}
-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
