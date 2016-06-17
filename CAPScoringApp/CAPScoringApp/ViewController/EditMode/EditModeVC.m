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
   
}

@end

@implementation EditModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customnavigationmethod];
    inningsDetail =[[NSMutableArray alloc]init];
    OversorderArray =[[NSMutableArray alloc]init];
    OversorderArray =[DBManager getBowlerOversorder:self.Comptitioncode :self.matchCode :@"1"];
   inningsDetail=[DBManager GetBolwerDetailsonEdit:self.Comptitioncode :self.matchCode :@"1"];
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
        
       
        for(int j=0; j< objoverballCount.count; j++)
            {
            
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((j*40.0)+28,65.0, 30.0, 15.0)];
        [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [nameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
                nameLabel.textAlignment=NSTextAlignmentCenter;
       
        [cell.view_main addSubview:nameLabel];
            InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=(InningsBowlerDetailsRecord *)[inningsDetail objectAtIndex:indexPath.row];
                nameLabel .text=[NSString stringWithFormat:@"%@.%@",[@(currentRow) stringValue],[@(j+1) stringValue]];
                        nameLabel.textColor=[UIColor whiteColor];
                
                UIButton *btn_Run = [[UIButton alloc] initWithFrame:CGRectMake((j*40.0)+25,30.0,30.0, 30.0)];
              
                [btn_Run setBackgroundColor:[UIColor clearColor]];
                [btn_Run setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn_Run setTitle:@"1" forState:UIControlStateNormal];
                btn_Run .layer. cornerRadius=15;
                btn_Run.layer.borderWidth=2;
                btn_Run.layer.borderColor= [UIColor redColor].CGColor;
                btn_Run.layer.masksToBounds=YES;
               
                [cell.view_main addSubview:btn_Run];


        }
       
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
