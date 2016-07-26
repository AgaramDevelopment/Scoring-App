//
//  TossDetailsVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 26/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "TossDetailsVC.h"
#import "DBManager.h"
#import "EventRecord.h"
#import "UserRecord.h"
#import "TossDeatilsEvent.h"
#import "BowlerEvent.h"
#import "ScorEnginVC.h"
#import "CustomNavigationVC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"
#import "DBManagerChangeToss.h"
#import "DBManagerChangeToss.h"
#import "TossDetailRecord.h"
#import "TossTeamDetailRecord.h"
#import "InitializeInningsScoreBoardRecord.h"

@interface TossDetailsVC ()
{
    BOOL isEnableTbl;
    NSMutableArray * TossWonByselectindexarray;
    NSMutableArray * Electedselectindexarray;
    NSMutableArray *Strikerselectindexarray;
    NSMutableArray *NonStrikerselectindexarray;
    NSMutableArray *BowlerselectionIndexArray;
    
    CustomNavigationVC *objCustomNavigation;
    
    
    EventRecord *objEventRecord;
    UserRecord * objUserRecord;
    TossDeatilsEvent *objTossDeatilsRecord;
    BowlerEvent *objBowlerEventRecord;
    
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
    DBManager *objDBManager;

}
@property (nonatomic,strong)NSMutableArray*WonTossArray;
@property (nonatomic,strong)NSMutableArray*ElectedToArray;
@property (nonatomic,strong)NSMutableArray*StrikerArray;
@property (nonatomic,strong)NSMutableArray*nonStrikerArray;
@property(nonatomic,strong)NSMutableArray*BowleArray;


@end

@implementation TossDetailsVC
@synthesize WonTossArray;
@synthesize ElectedToArray;
@synthesize StrikerArray;
@synthesize nonStrikerArray;
@synthesize BowleArray;
@synthesize MATCHCODE;
@synthesize CompetitionCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    objDBManager = [[DBManager alloc]init];
    
    [self customnavigationmethod];
    
    
    [self.view_Striker setUserInteractionEnabled:NO];
    [self.nonStriker setUserInteractionEnabled:NO];
    [self.view_Bowler setUserInteractionEnabled:NO];
    
    
    
    
    [self.view_Wonby.layer setBorderWidth:2.0];
    [self.view_Wonby.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Wonby .layer setMasksToBounds:YES];
    [_Wonby_table setHidden:YES];
    
    //electedto
    [self.view_Electedto .layer setBorderWidth:2.0];
    [self.view_Electedto.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Electedto .layer setMasksToBounds:YES];
    [_electedTo_table setHidden:YES];
    
    //striker
    [self.view_Striker .layer setBorderWidth:2.0];
    [self.view_Striker.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Striker .layer setMasksToBounds:YES];
    [_Striker_table setHidden:YES];
    
    //nonstriker
    [self.nonStriker .layer setBorderWidth:2.0];
    [self.nonStriker.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.nonStriker .layer setMasksToBounds:YES];
    [_nonStriker_table setHidden:YES];
    
    //Bowler
    [self.view_Bowler .layer setBorderWidth:2.0];
    [self.view_Bowler.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Bowler .layer setMasksToBounds:YES];
    [_Bowler_table setHidden:YES];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.Btn_Nearend setTag:0];
    //    [self.Btn_Nearend setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
    
    
    BowlingEnd=@"MSC150";
    [self.Btn_Nearend addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.Btn_FairEnd setTag:1];
    //    [self.Btn_FairEnd setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
    
    [self.Btn_FairEnd addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view_Wonby.layer setBorderWidth:2.0];
    [self.view_Wonby.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Wonby .layer setMasksToBounds:YES];
    [_Wonby_table setHidden:YES];
    
    //electedto
    [self.view_Electedto .layer setBorderWidth:2.0];
    [self.view_Electedto.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Electedto .layer setMasksToBounds:YES];
    [_electedTo_table setHidden:YES];
    
    //striker
    [self.view_Striker .layer setBorderWidth:2.0];
    [self.view_Striker.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Striker .layer setMasksToBounds:YES];
    [_Striker_table setHidden:YES];
    
    //nonstriker
    [self.nonStriker .layer setBorderWidth:2.0];
    [self.nonStriker.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.nonStriker .layer setMasksToBounds:YES];
    [_nonStriker_table setHidden:YES];
    
    //Bowler
    [self.view_Bowler .layer setBorderWidth:2.0];
    [self.view_Bowler.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_Bowler .layer setMasksToBounds:YES];
    [_Bowler_table setHidden:YES];
    isEnableTbl=YES;
    
    
    
    
    
    
}




-(void)radiobuttonSelected:(id)sender{
    
    if([self.Btn_FairEnd.currentImage isEqual:[UIImage imageNamed:@"Radio.on.png"]])
        
    {     BowlingEnd=@"MSC150";
        [self.Btn_Nearend setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
        [self.Btn_FairEnd setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
        
        
    }
    else{
        BowlingEnd=@"MSC151";
        [self.Btn_Nearend setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
        [self.Btn_FairEnd setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
        
    }
    
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{  if (tableView == self.Wonby_table)
{
    return 1;
}//count of section
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.Wonby_table)
    {
        return [WonTossArray count];
    }
    if (tableView == self.electedTo_table)
    {
        return [ElectedToArray count];
    }
    
    if (tableView == self.Striker_table)
    {
        return [StrikerArray count];
    }
    
    if (tableView == self.nonStriker_table)
    {
        return [nonStrikerArray count];
    }
    
    if (tableView == self.Bowler_table)
    {
        return [BowleArray count];
    }
    
    else
        return 1;
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.Wonby_table)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objEventRecord=(EventRecord*)[WonTossArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objEventRecord.TEAMNAME_TOSSWONBY;
        return cell;
    }
    
    
    if (tableView == self.electedTo_table)
    {
        static NSString *MyIdentifier1 = @"MyIdentifier1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier1];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier1];
        }
        objUserRecord=(UserRecord*)[ElectedToArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =[objUserRecord.electedTo uppercaseString];
        return cell;
    }
    
    
    
    if (tableView == self.Striker_table)
    {
        static NSString *MyIdentifier2 = @"MyIdentifier2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier2];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier2];
        }
        objTossDeatilsRecord=(TossDeatilsEvent*)[StrikerArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objTossDeatilsRecord.PlaerNameStrike_nonStrike;
        return cell;
    }
    
    
    
    
    if (tableView == self.nonStriker_table)
    {
        static NSString *MyIdentifier3 = @"MyIdentifier3";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier3];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier3];
        }
        objTossDeatilsRecord=(TossDeatilsEvent*)[nonStrikerArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objTossDeatilsRecord.PlaerNameStrike_nonStrike;
        return cell;
        
        
    }
    
    
    
    
    if (tableView == self.Bowler_table)
    {
        static NSString *MyIdentifier4 = @"MyIdentifier4";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier4];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier4];
        }
        objBowlerEventRecord=(BowlerEvent*)[BowleArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objBowlerEventRecord.BowlerName;
        return cell;
    }
    
    
    
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.Wonby_table)
    {
        
        
        TossWonByselectindexarray=[[NSMutableArray alloc]init];
        objEventRecord=(EventRecord*)[WonTossArray objectAtIndex:indexPath.row];
        
        NSInteger selectindex = indexPath.row;
        selectTeamindex= (int) selectindex;
        self.Wonby_lbl.text =objEventRecord.TEAMNAME_TOSSWONBY;
        selectTeam=self.Wonby_lbl.text;
        selectTeamcode=objEventRecord.TEAMCODE_TOSSWONBY;
        [TossWonByselectindexarray addObject:objEventRecord];
        
        self.Wonby_table.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    if (tableView == self.electedTo_table)
    {
        Electedselectindexarray=[[NSMutableArray alloc]init];
        objUserRecord=(UserRecord*)[ElectedToArray objectAtIndex:indexPath.row];
        self.electedTo_lbl.text =[objUserRecord.electedTo uppercaseString];
        selectedElected=self.electedTo_lbl.text;
        electedcode=objUserRecord.MasterSubCode;
        
        [Electedselectindexarray addObject:objUserRecord];
        
        self.electedTo_table.hidden=YES;
        isEnableTbl=YES;
    }
    
    if (tableView == self.Striker_table)
    {
        Strikerselectindexarray=[[NSMutableArray alloc]init];
        objTossDeatilsRecord=(TossDeatilsEvent*)[StrikerArray objectAtIndex:indexPath.row];
        if(![NonStrikerCode isEqualToString: objTossDeatilsRecord.PlaercodeStrike_nonStrike])
        {
        self.Striker_lbl.text =objTossDeatilsRecord.PlaerNameStrike_nonStrike;
        selectStriker=self.Striker_lbl.text;
        StrikerCode=objTossDeatilsRecord.PlaercodeStrike_nonStrike;
        [Strikerselectindexarray addObject:objTossDeatilsRecord];
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                            message: @"Striker and Non Striker cannot be same.\nPlease Select different Player"
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert1 show];
        }
        self.Striker_table.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    if (tableView == self.nonStriker_table)
    {
        NonStrikerselectindexarray=[[NSMutableArray alloc]init];
        objTossDeatilsRecord=(TossDeatilsEvent*)[nonStrikerArray objectAtIndex:indexPath.row];
        if(![StrikerCode isEqualToString: objTossDeatilsRecord.PlaercodeStrike_nonStrike])
        {
            self.nonStriker_lbl.text =objTossDeatilsRecord.PlaerNameStrike_nonStrike;
            selectNonStriker=self.nonStriker_lbl.text;
            
            NonStrikerCode=objTossDeatilsRecord.PlaercodeStrike_nonStrike;
            [NonStrikerselectindexarray addObject:objTossDeatilsRecord];
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Alert"
                                                            message: @"Striker and Non Striker cannot be same.\nPlease Select different Player"
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert1 show];
        }
        self.nonStriker_table.hidden=YES;
        isEnableTbl=YES;
    }
    if (tableView == self.Bowler_table)
    {
        BowlerselectionIndexArray=[[NSMutableArray alloc]init];
        objBowlerEventRecord=(BowlerEvent*)[BowleArray objectAtIndex:indexPath.row];
        self.Bowler_lbl.text =objBowlerEventRecord.BowlerName;
        selectBowler=self.Bowler_lbl.text;
        
        selectBowlerCode=objBowlerEventRecord.BowlerCode;
        [BowlerselectionIndexArray addObject:objBowlerEventRecord];
        
        self.Bowler_table.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    
}

- (IBAction)Wonbytouch_btn:(id)sender {
    //self.wonbyTbl_height.constant=self.Wonby_table.contentSize.height;
    
    if(isEnableTbl==YES)
    {
        _Striker_lbl.text = @"";
        _nonStriker_lbl.text = @"";
        _Bowler_lbl.text = @"";
        
        WonTossArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchTossWonArray =[objDBManager checkTossDetailsWonby:MATCHCODE];
        for(int i=0; i < [FetchTossWonArray count]; i++)
        {
            
            objEventRecord=(EventRecord*)[FetchTossWonArray objectAtIndex:i];
            
            [WonTossArray addObject:objEventRecord];
            
            
        }
        
        
        [self.Wonby_table reloadData];
        self.Wonby_table.hidden=NO;
        self.electedTo_table.hidden=YES;
        self.Striker_table.hidden=YES;
        self.nonStriker_table.hidden=YES;
        self.Bowler_table.hidden=YES;
        isEnableTbl=NO;
    }
    else
    {
        self.Wonby_table.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    
}



- (IBAction)electedTo_btn:(id)sender{
    
    //self.electedTbl_height.constant =self.electedTo_table.contentSize.height;
    if(isEnableTbl==YES)
    {
        _Striker_lbl.text = @"";
        _nonStriker_lbl.text = @"";
        _Bowler_lbl.text = @"";
        ElectedToArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchElectedToArray =[objDBManager Electedto];
        for(int i=0; i < [FetchElectedToArray count]; i++)
        {
            
            objUserRecord=(UserRecord*)[FetchElectedToArray objectAtIndex:i];
            
            [ElectedToArray addObject:objUserRecord];
            
            
        }
        
        
        [self.electedTo_table reloadData];
        self.electedTo_table.hidden=NO;
        isEnableTbl=NO;
        
        [self.view_Striker setUserInteractionEnabled:YES];
        [self.nonStriker setUserInteractionEnabled:YES];
        [self.view_Bowler setUserInteractionEnabled:YES];
        
        self.Striker_table.hidden=YES;
        isEnableTbl=YES;
        
        self.nonStriker_table.hidden=YES;
        isEnableTbl=YES;
        
        self.Bowler_table.hidden=YES;
        isEnableTbl=YES;
    }
    else{
        self.electedTo_table.hidden=YES;
        isEnableTbl=YES;
    }
    
}




- (IBAction)Striker_btn:(id)sender{

    if(isEnableTbl==YES)
    {
      
        //NSString *teamCode;
        if([selectedElected isEqualToString:@"Bat"])
        {
            
            teamaCode=[[WonTossArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
            //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
        }
        else{
            if(selectTeamindex==0)
            {
                teamaCode=[[WonTossArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
            }
            if(selectTeamindex==1)
            {
                teamaCode=[[WonTossArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
            }
            //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
        }
        
        
        StrikerArray=[[NSMutableArray alloc]init];
        
        NSMutableArray * FetchstrikerArray =[objDBManager StrikerNonstriker : MATCHCODE:teamaCode];
        for(int i=0; i < [FetchstrikerArray count]; i++)
        {
            objTossDeatilsRecord=(TossDeatilsEvent*)[FetchstrikerArray objectAtIndex:i];
            
            [StrikerArray addObject:objTossDeatilsRecord];
            
            
        }
        
        
        
        
        
        [self.Striker_table reloadData];
        self.Striker_table.hidden=NO;
        self.Wonby_table.hidden=YES;
        self.electedTo_table.hidden=YES;
       
        self.nonStriker_table.hidden=YES;
        self.Bowler_table.hidden=YES;
        
        isEnableTbl=NO;
        
    }
    else{
        self.Striker_table.hidden=YES;
        isEnableTbl=YES;
    }
    
}



- (IBAction)nonStriker_btn:(id)sender{
    
    if(isEnableTbl==YES)
    {
       
        //  NSString *teamCode;
        if([selectedElected isEqualToString:@"Bat"])
        {
            
            teamaCode=[[WonTossArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
            //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
        }
        else if(selectTeamindex==0)
        {
            teamaCode=[[WonTossArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        }
        if(selectTeamindex==1)
        {
            teamaCode=[[WonTossArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        }
        
        
        
        nonStrikerArray=[[NSMutableArray alloc]init];
        
        NSMutableArray * FetchnonstrikerArray =[objDBManager StrikerNonstriker:MATCHCODE:teamaCode];
        for(int i=0; i < [FetchnonstrikerArray count]; i++)
        {
            objTossDeatilsRecord=(TossDeatilsEvent*)[FetchnonstrikerArray objectAtIndex:i];
            
            [nonStrikerArray addObject:objTossDeatilsRecord];
            
            
        }
        
        
        
        
        
        [self.nonStriker_table reloadData];
        self.nonStriker_table.hidden=NO;
        self.Striker_table.hidden=YES;
        self.Wonby_table.hidden=YES;
        self.electedTo_table.hidden=YES;
        self.Bowler_table.hidden=YES;
        isEnableTbl=NO;
        
    }
    else
    {
        self.nonStriker_table.hidden=YES;
        isEnableTbl=YES;
    }

}



- (IBAction)Bowler_btn:(id)sender{
    
   
    if(isEnableTbl==YES)
    {
       
        //NSString *teambCode;
        if([selectedElected isEqualToString:@"Bat"])
        {
            
            // teambCode=[[WonTossArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
            
            if(selectTeamindex==0)
            {
                teambCode=[[WonTossArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
            }
            if(selectTeamindex==1)
            {
                teambCode=[[WonTossArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
            }
            
            //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
        }
        else{
            teambCode=[[WonTossArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
            
        }
        
        
        BowleArray=[[NSMutableArray alloc]init];
        
        NSMutableArray * FetchBowlerArray =[objDBManager Bowler:MATCHCODE :teambCode];
        for(int i=0; i < [FetchBowlerArray count]; i++)
        {
            objBowlerEventRecord=(BowlerEvent*)[FetchBowlerArray objectAtIndex:i];
            
            [BowleArray addObject:objBowlerEventRecord];
            
            
        }
        
        
        
        
        
        [self.Bowler_table reloadData];
        self.Bowler_table.hidden=NO;
        self.nonStriker_table.hidden=YES;
        self.Striker_table.hidden=YES;
        self.Wonby_table.hidden=YES;
        self.electedTo_table.hidden=YES;
        
        isEnableTbl=NO;
        self.outlet_btn_proceed.enabled = YES;
        
    }
    else
    {
        self.Bowler_table.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)ShowAlterView:(NSString *) alterMsg
{
    UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:@"Toss Details" message:alterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objAlter show];
}

- (IBAction)Btn_Proceed:(id)sender {
    
    
    if([self formValidation])
   {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Toss Details"
                                                       message: @"Please confirm to start the match"
                                                      delegate: self
                                             cancelButtonTitle:@"Start match"
                                             otherButtonTitles:@"Cancel",nil];
        alert.tag =1;
        
        [alert show];
        
    }
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DBManagerChangeToss *dbChangeToss = [[DBManagerChangeToss alloc]init];
    //if (alertView.tag == 1) { // UIAlertView with tag 1 detected
    if (buttonIndex == 0 && alertView.tag == 1)
    {
        [dbChangeToss InsertTossDetails: self.CompetitionCode : self.MATCHCODE :selectTeamcode : electedcode : StrikerCode : NonStrikerCode : selectBowlerCode :BowlingEnd];
        
        [self startService:@"DONE"];
        
        ScorEnginVC*scoreEngine = [[ScorEnginVC alloc]init];
        
        scoreEngine =  (ScorEnginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
        scoreEngine.matchSetUp = self.matchSetUp;
        scoreEngine.matchCode=self.MATCHCODE;
        scoreEngine.competitionCode=self.CompetitionCode;
        scoreEngine.matchTypeCode = self.matchTypeCode;
        
        [self.navigationController pushViewController:scoreEngine animated:YES];
       
    }
   
}


-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"TOSS DETAILS";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




//Check internet connection
- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void) startService:(NSString *)OPERATIONTYPE{
    if(self.checkInternetConnection){
        
        MATCHCODE = MATCHCODE == nil ?@"NULL":MATCHCODE;
        CompetitionCode = CompetitionCode == nil ?@"NULL":CompetitionCode;
        selectTeamcode= selectTeamcode == nil ?@"NULL":selectTeamcode;
        electedcode = electedcode == nil ?@"NULL":electedcode;
        StrikerCode = StrikerCode == nil ?@"":StrikerCode;
        NonStrikerCode= NonStrikerCode == nil ?@"NULL":NonStrikerCode;
        BowlingEnd = BowlingEnd == nil ?@"NULL":BowlingEnd;
        
        
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        //Show indicator
        [delegate showLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/TOSSEVENTS/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getSyncIPPORT], CompetitionCode,MATCHCODE,selectTeamcode,electedcode,StrikerCode,NonStrikerCode,BowlingEnd,OPERATIONTYPE];
            NSLog(@"-%@",baseURL);
            
            
            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if(responseData != nil)
            {
            
            NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            
            if(rootArray !=nil && rootArray.count>0){
                NSDictionary *valueDict = [rootArray objectAtIndex:0];
                NSString *success = [valueDict valueForKey:@"DataItem"];
                if([success isEqual:@"Success"]){
                    
                }
            }else{
                
            }
            }
            //            NSNumber * errorCode = (NSNumber *)[rootDictionary objectForKey: @"LOGIN_STATUS"];
            //            NSLog(@"%@",errorCode);
            //
            //
            //            if([errorCode boolValue] == YES)
            //            {
            //
            //                BOOL isUserLogin = YES;
            //
            //                NSString *userCode = [rootDictionary valueForKey:@"L_USERID"];
            //                [[NSUserDefaults standardUserDefaults] setBool:isUserLogin forKey:@"isUserLoggedin"];
            //                [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"userCode"];
            //                [[NSUserDefaults standardUserDefaults] synchronize];
            //
            //                [self openContentView];
            //
            //            }else{
            //
            //                [self showDialog:@"Invalid user name and password" andTitle:@"Login failed"];
            //            }
            [delegate hideLoading];
        });
        
        //[delegate hideLoading];
    }
}


- (BOOL) formValidation
{

if([self.Wonby_lbl.text isEqualToString:@""] || self.Wonby_lbl.text==nil && [self.electedTo_lbl.text isEqualToString:@""] || self.electedTo_lbl.text==nil && [self.Striker_lbl.text isEqualToString:@""] || self.Striker_lbl.text==nil && [self.nonStriker_lbl.text isEqualToString:@""] || self.nonStriker_lbl.text==nil && [self.Bowler_lbl.text isEqualToString:@""] || self.Bowler_lbl.text==nil)
{
    [self ShowAlterView:@"Please Select Team,\nElectedTo,Striker,NonStriker And Bowler"];
    return NO;
}

else if([self.electedTo_lbl.text isEqualToString:@""] || self.electedTo_lbl.text==nil && [self.Striker_lbl.text isEqualToString:@""] || self.Striker_lbl.text==nil && [self.nonStriker_lbl.text isEqualToString:@""] || self.nonStriker_lbl.text==nil && [self.Bowler_lbl.text isEqualToString:@""] || self.Bowler_lbl.text==nil)
{
    [self ShowAlterView:@"Please ElectedTo,Striker,NonStriker And Bowler"];
    return NO;
}


else if([self.Striker_lbl.text isEqualToString:@""] || self.Striker_lbl.text==nil && [self.nonStriker_lbl.text isEqualToString:@""] || self.nonStriker_lbl.text==nil && [self.Bowler_lbl.text isEqualToString:@""] || self.Bowler_lbl.text==nil)
{
    [self ShowAlterView:@"Please Striker,NonStriker And Bowler"];
    return NO;
}

else if([self.nonStriker_lbl.text isEqualToString:@""] || self.nonStriker_lbl.text==nil && [self.Bowler_lbl.text isEqualToString:@""] || self.Bowler_lbl.text==nil)
{
    [self ShowAlterView:@"Please NonStriker And Bowler"];
    return NO;
}

else if([self.Wonby_lbl.text isEqualToString:@""] || self.Wonby_lbl.text==nil)
{
    [self ShowAlterView:@"Please Select Team"];
    return NO;
}
else if([self.electedTo_lbl.text isEqualToString:@""] || self.electedTo_lbl.text==nil)
{
    [self ShowAlterView:@"Please Select ElectedTo"];
}
else if([self.Striker_lbl.text isEqualToString:@""] || self.Striker_lbl.text==nil)
{
    [self ShowAlterView:@"Please Select Striker"];
    return NO;
}
else if([self.nonStriker_lbl.text isEqualToString:@""] || self.nonStriker_lbl.text==nil)
{
    [self ShowAlterView:@"Please Select NonStriker"];
    return NO;
}
else if([self.Bowler_lbl.text isEqualToString:@""] || self.Bowler_lbl.text==nil)
{
    [self ShowAlterView:@"Please Select Bowler"];
    return NO;
}
return YES;
}
@end
