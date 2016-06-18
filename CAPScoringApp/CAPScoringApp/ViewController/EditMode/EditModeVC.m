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
@interface EditModeVC ()
{
    CustomNavigationVC * objCustomNavigation;
    NSMutableArray* inningsDetail;
    NSMutableArray * OversorderArray;
    BOOL isFirsttime;
    UIView * view_addedit;
   
}

@end

@implementation EditModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customnavigationmethod];
    inningsDetail =[[NSMutableArray alloc]init];
    OversorderArray =[[NSMutableArray alloc]init];
    //self.btn_innings1Widthposition.constant =400;
//self.btn_innings2xposition.constant=400;
    
   // [self.view layoutIfNeeded];
//    self.Btn_innings1team1.frame= CGRectMake(10, self.Btn_innings1team1.frame.origin.y,200, 50);
//    self.Btn_innings1team2.frame =CGRectMake(self.Btn_innings1team1.frame.size.width+10,self.Btn_innings1team1.frame.origin.y, 200, 50);
   // OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
   //inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
    isFirsttime=NO;
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
    
    NSInteger currentRow = indexPath.row;
    EditModeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OversorderRecord *objOversorderRecord=(OversorderRecord *)[OversorderArray objectAtIndex:indexPath.row];
    cell.lbl_playername.text =objOversorderRecord.BowlerName;
   
    cell.lbl_overs.text= objOversorderRecord.OversOrder;
     NSMutableArray * objoverballCount =[[NSMutableArray alloc]init];
    if (cell != nil) {
       

        for(int i=0; i < [inningsDetail count]; i++)
                {
                    InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:i];
            
                    NSString *ballcount=objInningsBowlerDetailsRecord.OverballCount;
                    if([objOversorderRecord.OversOrder isEqualToString:objInningsBowlerDetailsRecord.OverNo])
                    {
                        [objoverballCount addObject: ballcount];
                        
            
                       
                    }
                }
        [self createboltierMethod:currentRow :cell ];
       
//        for(int j=0; j< objoverballCount.count; j++)
//            {
//                //[self createboltierMethod:currentRow];
//               
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((j*40.0)+28,65.0, 30.0, 15.0)];
//        [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
//        [nameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
//                nameLabel.textAlignment=NSTextAlignmentCenter;
//       
//        [cell.view_main addSubview:nameLabel];
//            InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:indexPath.row];
//              
//                nameLabel .text=[NSString stringWithFormat:@"%@.%@",[@(currentRow) stringValue],[@(j+1) stringValue]];
//                        nameLabel.textColor=[UIColor whiteColor];
//                 nameLabel .text=@"";
//                UIButton *btn_Run = [[UIButton alloc] initWithFrame:CGRectMake((j*40.0)+25,30.0,30.0, 30.0)];
//              
//                [btn_Run setBackgroundColor:[UIColor clearColor]];
//                [btn_Run setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [btn_Run setTitle:@"1" forState:UIControlStateNormal];
//                btn_Run .layer. cornerRadius=15;
//                btn_Run.layer.borderWidth=2;
//                btn_Run.layer.borderColor= [UIColor redColor].CGColor;
//                btn_Run.layer.masksToBounds=YES;
//                [btn_Run addTarget:self action:@selector(didClickEditAction:) forControlEvents:UIControlEventTouchUpInside];
//               
//                [cell.view_main addSubview:btn_Run];


       // }
       
   }
    

    
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
     InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:indexpath];
    NSMutableDictionary * dicAddbowlerdetails=[NSMutableDictionary new];
    int overThrow = [objInningsBowlerDetailsRecord.overThrow intValue];
    int runs      = [objInningsBowlerDetailsRecord.Runs intValue]+overThrow;
    int noBall    = [objInningsBowlerDetailsRecord.noBall intValue];
    int wide      = [objInningsBowlerDetailsRecord.Wide intValue];
    int legalbyes = [objInningsBowlerDetailsRecord.Legbyes intValue];
    int byes      = [objInningsBowlerDetailsRecord.Byes intValue];
    
    noBall =noBall > 1 ?noBall-1:noBall;
     if([objInningsBowlerDetailsRecord.isFour isEqualToString:@"1"])
     {
         [dicAddbowlerdetails setValue:@"4" forKey:@"RUNS"];
     }
     else if ([objInningsBowlerDetailsRecord.isSix isEqualToString:@"1"])
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
             NSString* noballValues = [NSString stringWithFormat:@"(%@ + %d)", runs,noBall-1];
            [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
            [dicAddbowlerdetails setValue:noballValues forKey:@"RUNS"];
          
        }
        [dicAddbowlerdetails setObject:@"NB" forKey:@"EXTRAS-NB"];
        
    }
    if (wide != 0)//Ball ticker for wide balls.
    {
        if (wide > 0)
        {
             NSString* wideValues = [NSString stringWithFormat:@"%@", wide-1];
             [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
             [dicAddbowlerdetails setValue:wideValues forKey:@"RUNS"];
        }
        [dicAddbowlerdetails setObject:@"WD" forKey:@"EXTRAS-NB"];
        
    }

    if (legalbyes != 0)//Ball ticker for leg byes.
    {
        if (legalbyes > 0)
        {
            int* objlegalbyesValues = legalbyes+(noBall==0?0:noBall-1);
            NSString *legalbyesValues=[NSString stringWithFormat:@"%@",objlegalbyesValues];
            [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
            [dicAddbowlerdetails setValue:legalbyesValues forKey:@"RUNS"];
            
        }
    }
    if (noBall == 0)
        [dicAddbowlerdetails setValue:@"LB" forKey:@"EXTRAS"];
    if (byes != 0)//Ball ticker for byes.
    {
        if (byes > 0)
        {
            int* objbyesValues = byes+(noBall==0?0:noBall-1);
            NSString *byesValues=[NSString stringWithFormat:@"%@",objbyesValues];
            [dicAddbowlerdetails removeObjectForKey:@"RUNS"];
            [dicAddbowlerdetails setValue:byesValues forKey:@"RUNS"];

        }
        if (noBall == 0)
            [dicAddbowlerdetails setValue:@"B" forKey:@"EXTRAS"];
    
        // MessageBox.Show(drballdetails["WICKETNO"].ToString());
        if (![objInningsBowlerDetailsRecord.WicketNo isEqualToString:@"" ])
        {
            if ([objInningsBowlerDetailsRecord.WicketType isEqualToString:@"MSC102"])
                [dicAddbowlerdetails setValue:@"RH" forKey:@"WICKETS"];
            
            else
                [dicAddbowlerdetails setValue:@"W" forKey:@"WICKETS"];

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
        NSString * content;
        bool isExtras ;
        bool isSix =[objInningsBowlerDetailsRecord.isSix isEqualToString:@"1"]? YES: NO;
        bool isFour =[objInningsBowlerDetailsRecord.isFour isEqualToString:@"1"]? YES:NO;
        bool isSpecialEvents;
        if(isFour == YES || isSix == YES || ![objInningsBowlerDetailsRecord.WicketNo isEqualToString:@""])
        {
            isSpecialEvents=YES;
        }
        else{
            isSpecialEvents=NO;
        }
        for(NSString * kvpItem in dicAddbowlerdetails)
        {
            isExtras = [kvpItem isEqualToString:@"WD"] || [kvpItem isEqualToString:@"NB"] || [kvpItem isEqualToString:@"B"] || [kvpItem isEqualToString:@"LB"] || [kvpItem isEqualToString:@"PENALTY"];
            if ([kvpItem isEqualToString:@"RUNS"] && [kvpItem isEqualToString:@"0"] && dicAddbowlerdetails > 1)
                content = [content stringByAppendingString:content];
            else
                content =[kvpItem stringByAppendingString:@""];          //kvpItem.Value + " ";
        }
        //string videoURL = dtballdetails.Columns.Contains("VIDEOFILEPATH") ? drballdetails["VIDEOFILEPATH"].ToString() : string.Empty;
        //To Create ball tiker for each row.
        
        [self CreateBallTickerInstance:content :isExtras :isSpecialEvents :objInningsBowlerDetailsRecord.ballNo :cell];
       //[self CreateBallTickerInstance content isExtras, isSpecialEvents,objInningsBowlerDetailsRecord.ballNo)];
    


    }

}

-(void)CreateBallTickerInstance:(NSString *)content :(BOOL ) isextra: (BOOL) isspecialevent :(NSString *)ballno :(EditModeCell *) cell;
{
    UIButton *btn_Run = [[UIButton alloc] initWithFrame:CGRectMake(40.0+25,30.0,30.0, 30.0)];
    
    [btn_Run setBackgroundColor:[UIColor clearColor]];
    [btn_Run setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_Run setTitle:@"1" forState:UIControlStateNormal];
    btn_Run .layer. cornerRadius=15;
    btn_Run.layer.borderWidth=2;
    btn_Run.layer.borderColor= [UIColor redColor].CGColor;
    btn_Run.layer.masksToBounds=YES;
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
         btn_Run.layer.borderColor= [UIColor whiteColor].CGColor;
    }
    else if([content isEqualToString :@"6" ])
    {
         btn_Run.layer.borderColor= [UIColor greenColor].CGColor;
    }
    
    else if([content isEqualToString :@"W"])
    {
        btn_Run.layer.borderColor= [UIColor redColor].CGColor;
    }
    else
    {
        btn_Run.layer.borderColor= [UIColor yellowColor].CGColor;
    }


}





-(IBAction)didClickEditAction:(id)sender
{
    
    if(view_addedit != nil)
    {
        [view_addedit removeFromSuperview];
    }
     UIButton * btn_add = (UIButton *)sender;
    
   
   EditModeCell *cell = (EditModeCell*)[sender superview];
    NSIndexPath* indexPath = [self.tbl_innnings indexPathForCell:cell];
     view_addedit=[[UIView alloc]initWithFrame:CGRectMake(btn_add.frame.origin.x-20,btn_add.frame.origin.y-50,130, 50)];
    [view_addedit setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
    [cell addSubview:view_addedit];
    UIButton * leftrotation=[[UIButton alloc]initWithFrame:CGRectMake(5, view_addedit.frame.origin.y+45, 25, 25)];
    [leftrotation setImage:[UIImage imageNamed:@"LeftRotation"] forState:UIControlStateNormal];
    [view_addedit addSubview:leftrotation];
    
    UIButton * Editrotation=[[UIButton alloc]initWithFrame:CGRectMake(leftrotation.frame.origin.x+leftrotation.frame.size.width+8, leftrotation.frame.origin.y-3, 25, 25)];
    [Editrotation setImage:[UIImage imageNamed:@"ArchiveEdit"] forState:UIControlStateNormal];
    [view_addedit addSubview:Editrotation];
    
    UIButton * Cancelrotation=[[UIButton alloc]initWithFrame:CGRectMake(Editrotation.frame.origin.x+Editrotation.frame.size.width+8, Editrotation.frame.origin.y, 25, 25)];
    [Cancelrotation setImage:[UIImage imageNamed:@"ArchiveCancel"] forState:UIControlStateNormal];
    [view_addedit addSubview:Cancelrotation];
    
    UIButton * Rightrotation=[[UIButton alloc]initWithFrame:CGRectMake(Cancelrotation.frame.origin.x+Cancelrotation.frame.size.width+8, Cancelrotation.frame.origin.y, 25, 25)];
    [Rightrotation setImage:[UIImage imageNamed:@"RightRotation"] forState:UIControlStateNormal];
    [view_addedit addSubview:Rightrotation];

}


-(IBAction)didClickInnings1team1:(id)sender
{
    self.highlightbtnxposition.constant=0;
}
-(IBAction)didClickInnings1team2:(id)sender
{
    self.highlightbtnxposition.constant=self.Btn_innings1team2.frame.origin.x;
}
-(IBAction)didClickInnings2team1:(id)sender
{
     self.highlightbtnxposition.constant=self.Btn_inning2steam1.frame.origin.x;
}
-(IBAction)didClickInnings2team2:(id)sender
{
     self.highlightbtnxposition.constant=self.Btn_innings2team2.frame.origin.x;
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
