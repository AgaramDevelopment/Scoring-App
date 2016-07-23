//
//  InningsDetailsVC.m
//  CAPScoringApp
//
//  Created by Stephen on 08/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "InningsDetailsVC.h"
#import "CustomNavigationVC.h"
#import "DBManagerChangeToss.h"
#import "FetchBattingTeamTossRecord.h"
#import "ScorEnginVC.h"

@interface InningsDetailsVC ()
{
    BOOL isEnableTbl;
    CustomNavigationVC *objCustomNavigation;
    FetchBattingTeamTossRecord *fetchBattingTeamTossRecord;
    NSString *selectTeam;
    NSString *selectTeamcode;
    
    NSString * selectedElected;
    NSString *electedcode;
    
    NSString *selectStriker;
    NSString *StrikerCode;
    
    NSString *selectNonStriker;
    NSString *NonStrikerCode;
    
    NSString *selectBowler;
    NSString*selectBowlerCode;
    
    NSString *teamaCode;
    NSString *teambCode;
    
    NSString * BOWLCOMPUTESHOW;
    int selectTeamindex;
    
    NSString* BowlingEnd;
    DBManagerChangeToss *dbChangeToss;
    
}
@property (nonatomic,strong)NSMutableArray*StrikerArray;
@property (nonatomic,strong)NSMutableArray*nonStrikerArray;
@property(nonatomic,strong)NSMutableArray*BowleArray;
@end

@implementation InningsDetailsVC
@synthesize StrikerArray;
@synthesize nonStrikerArray;
@synthesize BowleArray;
@synthesize MATCHCODE;
@synthesize CompetitionCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customnavigationmethod];
    dbChangeToss = [[DBManagerChangeToss alloc]init];
    [self.Striker_View setUserInteractionEnabled:YES];
    [self.NonStriker_View setUserInteractionEnabled:YES];
    [self.Bowler_View setUserInteractionEnabled:YES];
    
    //striker
    [self.Striker_View .layer setBorderWidth:2.0];
    [self.Striker_View.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.Striker_View .layer setMasksToBounds:YES];
    self.Striker_tableview.hidden=YES;
    
    //nonstriker
    [self.NonStriker_View .layer setBorderWidth:2.0];
    [self.NonStriker_View.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.NonStriker_View .layer setMasksToBounds:YES];
    self.NonStriker_tableview.hidden=YES;
    
    //Bowler
    [self.Bowler_View .layer setBorderWidth:2.0];
    [self.Bowler_View.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.Bowler_View .layer setMasksToBounds:YES];
    self.Bowler_tableview.hidden=YES;
    isEnableTbl=YES;
    
    NSMutableDictionary *FetchInningsDetails = [dbChangeToss FetchTossDetailsForInnings: MATCHCODE : CompetitionCode];
    StrikerArray = [[NSMutableArray alloc] init];
    StrikerArray = [FetchInningsDetails objectForKey:@"battingplayers"];
    nonStrikerArray = [[NSMutableArray alloc] init];
    nonStrikerArray = [FetchInningsDetails objectForKey:@"battingplayers"];
    BowleArray = [[NSMutableArray alloc] init];
    BowleArray = [FetchInningsDetails objectForKey:@"bowlingplayers"];
    NSMutableArray *TeamDetails = [[NSMutableArray alloc] init];
    TeamDetails =[FetchInningsDetails objectForKey:@"teamdetails"];
    if(TeamDetails.count>1)
    {
        selectTeam = [TeamDetails objectAtIndex:0];
        selectTeamcode = [TeamDetails objectAtIndex:1];
        self.lbl_Team.text = selectTeam;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.Near_btn setTag:0];
    BowlingEnd=@"MSC150";
    [self.Near_btn addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Far_btn setTag:1];
    
    [self.Far_btn addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    //striker
    [self.Striker_View .layer setBorderWidth:2.0];
    [self.Striker_View.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.Striker_View .layer setMasksToBounds:YES];
    self.Striker_tableview.hidden=YES;
    
    //nonstriker
    [self.NonStriker_View .layer setBorderWidth:2.0];
    [self.NonStriker_View.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.NonStriker_View .layer setMasksToBounds:YES];
    self.NonStriker_tableview.hidden=YES;
    
    //Bowler
    [self.Bowler_View .layer setBorderWidth:2.0];
    [self.Bowler_View.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.Bowler_View .layer setMasksToBounds:YES];
    self.Bowler_tableview.hidden=YES;
    isEnableTbl=YES;
}

-(void)radiobuttonSelected:(id)sender{
    if([self.Far_btn.currentImage isEqual:[UIImage imageNamed:@"Radio.on.png"]])
    {
        BowlingEnd=@"MSC150";
        [self.Near_btn setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
        [self.Far_btn setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
    }
    else
    {
        BowlingEnd=@"MSC151";
        [self.Near_btn setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
        [self.Far_btn setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
    }
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"START INNINGS";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.Striker_tableview)
    {
        return [StrikerArray count];
    }
    if (tableView == self.NonStriker_tableview)
    {
        return [nonStrikerArray count];
    }
    if (tableView == self.Bowler_tableview)
    {
        return [BowleArray count];
    }
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.Striker_tableview)
    {
        static NSString *MyIdentifier2 = @"MyIdentifier2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier2];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier2];
        }
        fetchBattingTeamTossRecord=(FetchBattingTeamTossRecord*)[StrikerArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =fetchBattingTeamTossRecord.playerName;
        return cell;
    }
    if (tableView == self.NonStriker_tableview)
    {
        static NSString *MyIdentifier3 = @"MyIdentifier3";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier3];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier3];
        }
        fetchBattingTeamTossRecord=(FetchBattingTeamTossRecord*)[StrikerArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =fetchBattingTeamTossRecord.playerName;
        return cell;
    }
    if (tableView == self.Bowler_tableview)
    {
        static NSString *MyIdentifier4 = @"MyIdentifier4";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier4];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier4];
        }
        fetchBattingTeamTossRecord=(FetchBattingTeamTossRecord*)[BowleArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =fetchBattingTeamTossRecord.playerName;
        return cell;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.Striker_tableview)
    {
        fetchBattingTeamTossRecord=(FetchBattingTeamTossRecord*)[StrikerArray objectAtIndex:indexPath.row];
        
        if(![NonStrikerCode isEqualToString: fetchBattingTeamTossRecord.playerCode])
        {
            self.lbl_Striker.text =fetchBattingTeamTossRecord.playerName;
            selectStriker=self.lbl_Striker.text;
            StrikerCode=fetchBattingTeamTossRecord.playerCode;
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                            message: @"Striker cannot be same.\nPlease Select different Player"
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert1 show];
        }

        
        self.Striker_tableview.hidden=YES;
        isEnableTbl=YES;
    }
    if (tableView == self.NonStriker_tableview)
    {
        fetchBattingTeamTossRecord=(FetchBattingTeamTossRecord*)[StrikerArray objectAtIndex:indexPath.row];
        if(![StrikerCode isEqualToString: fetchBattingTeamTossRecord.playerCode])
        {
            self.lbl_NonStriker.text =fetchBattingTeamTossRecord.playerName;
            selectNonStriker=self.lbl_NonStriker.text;
            NonStrikerCode=fetchBattingTeamTossRecord.playerCode;
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                            message: @"Non Striker cannot be same.\nPlease Select different Player"
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert1 show];
        }
        self.NonStriker_tableview.hidden=YES;
        isEnableTbl=YES;
    }
    if (tableView == self.Bowler_tableview)
    {
        fetchBattingTeamTossRecord=(FetchBattingTeamTossRecord*)[BowleArray objectAtIndex:indexPath.row];
        self.lbl_Bowler.text =fetchBattingTeamTossRecord.playerName;
        selectBowler=self.lbl_Bowler.text;
        selectBowlerCode=fetchBattingTeamTossRecord.playerCode;
        self.Bowler_tableview.hidden=YES;
        isEnableTbl=YES;
    }
}

-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_Striker:(id)sender {
    if(isEnableTbl==YES)
    {
        _lbl_Striker.text = @"";
        [self.Striker_tableview reloadData];
        self.Striker_tableview.hidden=NO;
        isEnableTbl=NO;
    }
    else
    {
        self.Striker_tableview.hidden=YES;
        isEnableTbl=YES;
    }
}

- (IBAction)btn_Nonstriker:(id)sender {
    if(isEnableTbl==YES)
    {
        _lbl_NonStriker.text = @"";
        [self.NonStriker_tableview reloadData];
        self.NonStriker_tableview.hidden=NO;
        isEnableTbl=NO;
    }
    else
    {
        self.NonStriker_tableview.hidden=YES;
        isEnableTbl=YES;
    }
}

- (IBAction)btn_Bowler:(id)sender {
    if(isEnableTbl==YES)
    {
        _lbl_Bowler.text = @"";
        [self.Bowler_tableview reloadData];
        self.Bowler_tableview.hidden=NO;
        isEnableTbl=NO;
    }
    else
    {
        self.Bowler_tableview.hidden=YES;
        isEnableTbl=YES;
    }
}

-(void)ShowAlterView:(NSString *) alterMsg
{
    UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:@"Start Innings" message:alterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objAlter show];
}

- (IBAction)Finish_btn:(id)sender {
//    if([self.lbl_Striker.text isEqualToString:@""],[self.lbl_NonStriker.text isEqualToString:@""],[self.lbl_Bowler.text isEqualToString:@""])
//    {  [self ShowAlterView:@"Please Select Striker\nPlease Select NonStriker\nPlease Select Bowler"];
//   }
    if([self.lbl_Striker.text isEqualToString:@""] || self.lbl_Striker.text==nil)
    {
        [self ShowAlterView:@"Please Select Striker"];
    }
    else if([self.lbl_NonStriker.text isEqualToString:@""] || self.lbl_NonStriker.text==nil)
    {
        [self ShowAlterView:@"Please Select NonStriker"];
    }
    else if([self.lbl_Bowler.text isEqualToString:@""] || self.lbl_Bowler.text==nil)
    {
        [self ShowAlterView:@"Please Select Bowler"];
    }
    
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Start Innings"
                                                       message: @"Please confirm to start Innings"
                                                      delegate: self
                                             cancelButtonTitle:@"Start Innings"
                                             otherButtonTitles:@"Cancel",nil];
        alert.tag =1;
        
        [alert show];
        
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag == 1)
    {
        [dbChangeToss InsertTossDetails: self.CompetitionCode : self.MATCHCODE :selectTeamcode : @"" : StrikerCode : NonStrikerCode : selectBowlerCode : BowlingEnd];
        
        [self.delegate StartInningsprocessSuccessful : self.CompetitionCode : self.MATCHCODE : self.matchTypeCode : self.matchSetUp];
        
        //[self startService:@"DONE"];
    }
}


@end
