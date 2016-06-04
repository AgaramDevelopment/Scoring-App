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
@interface TossDetailsVC ()
{
    BOOL isEnableTbl;
    NSMutableArray * TossWonByselectindexarray;
     NSMutableArray * Electedselectindexarray;
    NSMutableArray *Strikerselectindexarray;
    NSMutableArray *NonStrikerselectindexarray;
    NSMutableArray *BowlerselectionIndexArray;
    
    
    
    
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
    
    
    

    
    [self.view_Striker setUserInteractionEnabled:NO];
     [self.nonStriker setUserInteractionEnabled:NO];
     [self.view_Bowler setUserInteractionEnabled:NO];
    self.outlet_btn_proceed.enabled = NO;

    
    
     // self.outlet_btn_proceed.enabled = YES;
    
    // Do any additional setup after loading the view.
// _MATCHCODE=@"IMSC0221C6F6595E95A00001";
    //wontoss
    
    [self.view_Wonby.layer setBorderWidth:3];
    [self.view_Wonby.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Wonby .layer setMasksToBounds:YES];
    [_Wonby_table setHidden:YES];
    
    //electedto
    [self.view_Electedto .layer setBorderWidth:3];
    [self.view_Electedto.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Electedto .layer setMasksToBounds:YES];
    [_electedTo_table setHidden:YES];
    
    //striker
    [self.view_Striker .layer setBorderWidth:3];
    [self.view_Striker.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Striker .layer setMasksToBounds:YES];
    [_Striker_table setHidden:YES];
    
    //nonstriker
    [self.nonStriker .layer setBorderWidth:3];
    [self.nonStriker.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.nonStriker .layer setMasksToBounds:YES];
    [_nonStriker_table setHidden:YES];
    
    //Bowler
    [self.view_Bowler .layer setBorderWidth:3];
    [self.view_Bowler.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Bowler .layer setMasksToBounds:YES];
    [_Bowler_table setHidden:YES];
 
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view_Wonby .layer setBorderWidth:3];
    [self.view_Wonby.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Wonby .layer setMasksToBounds:YES];
    
    [super viewWillAppear:animated];
    [self.view_Electedto .layer setBorderWidth:3];
    [self.view_Electedto.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Electedto .layer setMasksToBounds:YES];
   
    [super viewWillAppear:animated];
    [self.view_Striker .layer setBorderWidth:3];
    [self.view_Striker.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Striker .layer setMasksToBounds:YES];

    
    [self.nonStriker .layer setBorderWidth:3];
    [self.nonStriker.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.nonStriker .layer setMasksToBounds:YES];
    [_nonStriker_table setHidden:YES];

    [self.view_Bowler .layer setBorderWidth:3];
    [self.view_Bowler.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view_Bowler .layer setMasksToBounds:YES];
    [_Bowler_table setHidden:YES];

    isEnableTbl=YES;
    
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
        
        cell.textLabel.text =objUserRecord.electedTo;
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
        objTossDeatilsRecord=(TossDeatilsEvent*)[StrikerArray objectAtIndex:indexPath.row];
        
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
        self.electedTo_lbl.text =objUserRecord.electedTo;
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
        self.Striker_lbl.text =objTossDeatilsRecord.PlaerNameStrike_nonStrike;
        selectStriker=self.Striker_lbl.text;
        StrikerCode=objTossDeatilsRecord.PlaercodeStrike_nonStrike;
        [Strikerselectindexarray addObject:objTossDeatilsRecord];
        
        self.Striker_table.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    if (tableView == self.nonStriker_table)
    {
        NonStrikerselectindexarray=[[NSMutableArray alloc]init];
        objTossDeatilsRecord=(TossDeatilsEvent*)[StrikerArray objectAtIndex:indexPath.row];
        self.nonStriker_lbl.text =objTossDeatilsRecord.PlaerNameStrike_nonStrike;
        selectNonStriker=self.nonStriker_lbl.text;
        
        NonStrikerCode=objTossDeatilsRecord.PlaercodeStrike_nonStrike;
        [NonStrikerselectindexarray addObject:objTossDeatilsRecord];
        
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
    
    if(isEnableTbl==YES)
    {
        WonTossArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchTossWonArray =[DBManager checkTossDetailsWonby:MATCHCODE];
        for(int i=0; i < [FetchTossWonArray count]; i++)
        {
            
        objEventRecord=(EventRecord*)[FetchTossWonArray objectAtIndex:i];
       
        [WonTossArray addObject:objEventRecord];
           
            
        }
        
        
        [self.Wonby_table reloadData];
        self.Wonby_table.hidden=NO;
        isEnableTbl=NO;
    }

    


}



- (IBAction)electedTo_btn:(id)sender{

    
    
    
    if(isEnableTbl==YES)
    {         ElectedToArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchElectedToArray =[DBManager Electedto];
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
      
        NSMutableArray * FetchstrikerArray =[DBManager StrikerNonstriker:MATCHCODE:teamaCode];
        for(int i=0; i < [FetchstrikerArray count]; i++)
        {
       objTossDeatilsRecord=(TossDeatilsEvent*)[FetchstrikerArray objectAtIndex:i];
            
            [StrikerArray addObject:objTossDeatilsRecord];
            
            
        }
        
        
        
        
        
        [self.Striker_table reloadData];
        self.Striker_table.hidden=NO;
        isEnableTbl=NO;
        
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
        
        NSMutableArray * FetchnonstrikerArray =[DBManager StrikerNonstriker:MATCHCODE:teamaCode];
        for(int i=0; i < [FetchnonstrikerArray count]; i++)
        {
            objTossDeatilsRecord=(TossDeatilsEvent*)[FetchnonstrikerArray objectAtIndex:i];
            
            [nonStrikerArray addObject:objTossDeatilsRecord];
            
            
        }
        
        
        
        
        
        [self.nonStriker_table reloadData];
        self.nonStriker_table.hidden=NO;
        isEnableTbl=NO;
        
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
//            if(selectTeamindex==0)
//            {
//                teambCode=[[WonTossArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
//            }
//            if(selectTeamindex==1)
//            {
//                teambCode=[[WonTossArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
//            }

        }
        
        
        BowleArray=[[NSMutableArray alloc]init];
        
        NSMutableArray * FetchBowlerArray =[DBManager Bowler:MATCHCODE :teambCode];
        for(int i=0; i < [FetchBowlerArray count]; i++)
        {
            objBowlerEventRecord=(BowlerEvent*)[FetchBowlerArray objectAtIndex:i];
            
            [BowleArray addObject:objBowlerEventRecord];
            
            
        }
        
        
        
        
        
        [self.Bowler_table reloadData];
        self.Bowler_table.hidden=NO;
        isEnableTbl=NO;
          self.outlet_btn_proceed.enabled = YES;
        
    }




}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Btn_Proceed:(id)sender {
    
    //save option
   NSString *count =[DBManager TossSaveDetails:MATCHCODE :CompetitionCode];
    if([count isEqualToString:@"0"]){
        [DBManager insertMatchEvent:CompetitionCode :MATCHCODE :selectTeamcode :electedcode :teamaCode :teambCode];
    }
    
    NSString *maxInnNo = [DBManager getMaxInningsNumber:CompetitionCode :MATCHCODE];
  
    NSString*inningsstatus=@"0";
       NSString* BowlingEnd=@"MSC150";
    [DBManager inserMaxInningsEvent:CompetitionCode :MATCHCODE :teamaCode :maxInnNo :StrikerCode:NonStrikerCode :selectBowlerCode :StrikerCode :NonStrikerCode :selectBowlerCode :teamaCode :inningsstatus:BowlingEnd];
    [DBManager updateProcced:CompetitionCode :MATCHCODE];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Alert"
                                                   message: @"Please confirm to start the match"
                                                  delegate: self
                                         cancelButtonTitle:@"Start match"
                                         otherButtonTitles:@"Cancel",nil];
    
  
    
  
    [alert show];
    
    
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    ScorEnginVC *scoreEngine =(ScorEnginVC*) [storyBoard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
//    //Fixvc.CompitionCode=selectindexarray;
//    [scoreEngine setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self presentViewController:scoreEngine animated:NO completion:nil];
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (alertView.tag == 1) { // UIAlertView with tag 1 detected
        if (buttonIndex == 0)
        {
            NSLog(@"user pressed Button Indexed 0");
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                ScorEnginVC *scoreEngine =(ScorEnginVC*) [storyBoard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
               scoreEngine.matchCode=self.MATCHCODE;
               scoreEngine.competitionCode=self.CompetitionCode;
                //Fixvc.CompitionCode=selectindexarray;
                [scoreEngine setModalPresentationStyle:UIModalPresentationFullScreen];
                [self presentViewController:scoreEngine animated:NO completion:nil];
        }
//        else
//        {
//            NSLog(@"user pressed Button Indexed 1");
//            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            TossDetailsVC *toss =(TossDetailsVC*) [storyBoard instantiateViewControllerWithIdentifier:@"TossDetails"];
//            //Fixvc.CompitionCode=selectindexarray;
//            [toss setModalPresentationStyle:UIModalPresentationFullScreen];
//            [self presentViewController:toss animated:NO completion:nil];
//        }
    }


@end
