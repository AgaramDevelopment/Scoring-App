//
//  ChanceTossVC.m
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ChangeTossVC.h"
#import "FetchBattingTeamTossRecord.h"
#import "DBManagerChangeToss.h"
#import "TossDetailRecord.h"
#import "TossTeamDetailRecord.h"
#import "InitializeInningsScoreBoardRecord.h"
#import "DBManager.h"
#import "DBManagerChangeToss.h"

@interface ChangeTossVC ()
{
    NSMutableArray * catagory;
    //DBManagerChangeToss * objDBManagerChangeToss;
    NSMutableArray * TossDetailArray;
   // NSMutableArray *TeamDetailToss;
    
     BOOL isTossWon;
     BOOL isElectedTo;
     BOOL isStricker;
     BOOL isNonStricker;
     BOOL isBowler;
    
    
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
    
    
    NSMutableArray *TeamDetailTossWon;
    NSMutableArray *objElectedTodetailArray;
    NSMutableArray *objStrickerdetail;
    NSMutableArray *objNonStrikerdetail;
    NSMutableArray *objBowlingTeamdetail;

}

@end

@implementation ChangeTossVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view_TossWon.layer.borderWidth = 1.0;
    self.view_TossWon.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_TossWon .layer.cornerRadius =5.0;
    self.view_TossWon.layer .masksToBounds =YES;
    
    
    self.view_ElectedTo.layer.borderWidth = 1.0;
    self.view_ElectedTo.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_ElectedTo .layer.cornerRadius =5.0;
    self.view_ElectedTo.layer .masksToBounds =YES;
    
    self.view_Stricker.layer.borderWidth = 1.0;
    self.view_Stricker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_Stricker .layer.cornerRadius =5.0;
    self.view_Stricker.layer .masksToBounds =YES;
    
    self.view_NonStricker.layer.borderWidth = 1.0;
    self.view_NonStricker.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    self.view_NonStricker .layer.cornerRadius =5.0;
    self.view_NonStricker.layer .masksToBounds =YES;
    
    self.view_Bowler.layer.borderWidth = 1.0;
    self.view_Bowler.layer.borderColor = [UIColor colorWithRed:(48/255.0f) green:(62/255.0f) blue:(73/255.0f) alpha:1.0f].CGColor;
    
    self.view_Bowler .layer.cornerRadius =5.0;
    self.view_Bowler.layer .masksToBounds =YES;

     self.Tbl_toss.hidden=YES;
    catagory =[[NSMutableArray alloc]init];
    TeamDetailTossWon =[[NSMutableArray alloc]init];
    objElectedTodetailArray=[[NSMutableArray alloc]init];
    objStrickerdetail =[[NSMutableArray alloc]init];
    objNonStrikerdetail=[[NSMutableArray alloc]init];
    objBowlingTeamdetail =[[NSMutableArray alloc]init];
    TossDetailArray=[[NSMutableArray alloc]init];
    TossDetailArray=[DBManagerChangeToss GetTossDetails];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.Btn_Nearend setTag:0];
    [self.Btn_Nearend setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
    
    
    
    
   // [self.Btn_Nearend setBackgroundImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
    BowlingEnd=@"MSC150";
    [self.Btn_Nearend addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_FairEnd setTag:1];
    [self.Btn_FairEnd setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
   // [self.Btn_FairEnd setBackgroundImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];[self.Btn_FairEnd setBackgroundImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateSelected];
    [self.Btn_FairEnd addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)radiobuttonSelected:(id)sender{
    
    if([self.Btn_Nearend.currentImage isEqual: [UIImage imageNamed:@"Radio.on.png"]])
        
    {           BowlingEnd=@"MSC151";
        [self.Btn_Nearend setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
        [self.Btn_FairEnd setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
        
        
    }
    else{
        BowlingEnd=@"MSC150";
        [self.Btn_Nearend setImage:[UIImage imageNamed:@"Radio.on.png"] forState:UIControlStateNormal];
        [self.Btn_FairEnd setImage:[UIImage imageNamed:@"Radio.off.png"] forState:UIControlStateNormal];
        
    }
    
}

-(IBAction)didClickTossWonSelection:(id)sender
{
    CGFloat contentSize=self.Tbl_toss.contentSize.height;
    self.tbl_tossHeight.constant=(contentSize > 44)?130:contentSize;
    if(isTossWon ==NO)
    {
     isTossWon=YES;
     isElectedTo=NO;
     isStricker=NO;
     isNonStricker=NO;
     isBowler=NO;
    TeamDetailTossWon=[DBManagerChangeToss GetTeamDetailsForToss:self.matchCode];
    catagory =TeamDetailTossWon;
    
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_TossWon.frame.origin.y-30;
    [self.Tbl_toss reloadData];
    }
    else
    {
        self.Tbl_toss.hidden=YES;
        isTossWon=NO;
    }
    
}
-(IBAction)didClickElectedToSelection:(id)sender
{
    CGFloat contentSize=self.Tbl_toss.contentSize.height;
    self.tbl_tossHeight.constant=(contentSize > 44)?130:contentSize;
    if(isElectedTo==NO)
    {
    isTossWon=NO;
    isElectedTo=YES;
    isStricker=NO;
    isNonStricker=NO;
    isBowler=NO;
    objElectedTodetailArray =[DBManagerChangeToss GetTossDetails ];
    catagory =objElectedTodetailArray;
    
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_ElectedTo.frame.origin.y-30;
    [self.Tbl_toss reloadData];
    }
    else
    {
         self.Tbl_toss.hidden=YES;
         isElectedTo=NO;
    }
}

-(IBAction)didClickStrikerSelection:(id)sender
{
    CGFloat contentSize=self.Tbl_toss.contentSize.height;
    self.tbl_tossHeight.constant=(contentSize > 44)?130:contentSize;
    if(isStricker == NO)
    {
    isTossWon=NO;
    isElectedTo=NO;
    isStricker=YES;
    isNonStricker=NO;
    isBowler=NO;
     FetchBattingTeamTossRecord * objFetchBattingTeamTossRecord ;
    if([selectedElected isEqualToString:@"Bat"])
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex];

     teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
    }
    else if(selectTeamindex==0)
    {
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex+1];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
    }
    if(selectTeamindex==1)
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex-1];
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
    }

   objStrickerdetail =[DBManagerChangeToss StrikerNonstriker:self.matchCode :teamaCode ];

    catagory=objStrickerdetail;
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_Stricker.frame.origin.y-30;
    [self.Tbl_toss reloadData];
    }
    else
    {
         self.Tbl_toss.hidden=YES;
         isStricker=NO;
    }
}

-(IBAction)didClickNonStrikerSelection:(id)sender
{
    CGFloat contentSize=self.Tbl_toss.contentSize.height;
    self.tbl_tossHeight.constant=(contentSize > 44)?130:contentSize;
    if(isNonStricker == NO)
    {
    isTossWon=NO;
    isElectedTo=NO;
    isStricker=NO;
    isNonStricker=YES;
    isBowler=NO;
    FetchBattingTeamTossRecord * objFetchBattingTeamTossRecord ;
    if([selectedElected isEqualToString:@"Bat"])
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
        //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
    }
    else if(selectTeamindex==0)
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex+1];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
    }
    if(selectTeamindex==1)
    {
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex-1];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
       // teamaCode=[[TossDetailArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
    }
    objNonStrikerdetail =[DBManagerChangeToss StrikerNonstriker:self.matchCode :teamaCode];
    catagory=objNonStrikerdetail;
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_NonStricker.frame.origin.y-30;
    [self.Tbl_toss reloadData];
    }
    else
    {
        self.Tbl_toss.hidden=YES;
        isNonStricker=NO;
    }
}
-(IBAction)didClickBowlerSelection:(id)sender
{
    CGFloat contentSize=self.Tbl_toss.contentSize.height;
    self.tbl_tossHeight.constant=(contentSize > 44)?130:contentSize;
    if(isBowler==NO)
    {
    isTossWon=NO;
    isElectedTo=NO;
    isStricker=NO;
    isNonStricker=NO;
    isBowler=YES;
    FetchBattingTeamTossRecord * objFetchBattingTeamTossRecord ;
    if([selectedElected isEqualToString:@"Bat"])
    {
        
        
        if(selectTeamindex==0)
        {
            objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex+1];
            
            teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
            //teambCode=[[TossDetailArray objectAtIndex:selectTeamindex+1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        }
        if(selectTeamindex==1)
        {
            objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex-1];
            
            teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
            //teambCode=[[TossDetailArray objectAtIndex:selectTeamindex-1]valueForKey:@"TEAMCODE_TOSSWONBY"];
        }
        
        //PlayerCode =objEventRecord.TEAMCODE_TOSSWONBY;
    }
    else{
        objFetchBattingTeamTossRecord = (FetchBattingTeamTossRecord *)[TeamDetailTossWon objectAtIndex:selectTeamindex];
        
        teamaCode= objFetchBattingTeamTossRecord.TEAMCODE_TOSSWONBY ;
        //teambCode=[[TossDetailArray objectAtIndex:selectTeamindex] valueForKey:@"TEAMCODE_TOSSWONBY"];
       
        
    }

    objBowlingTeamdetail =[DBManagerChangeToss StrikerNonstriker:self.matchCode :teamaCode];
    catagory=objBowlingTeamdetail;
    self.Tbl_toss.hidden=NO;
    self.tbl_tossYposition.constant=self.view_Bowler.frame.origin.y-30;
    [self.Tbl_toss reloadData];
    }
    else{
       self.Tbl_toss.hidden=YES;
        isBowler=NO;
    }
}

-(IBAction)didClickChangeToss:(id)sender
{
        if([self.lbl_Tosswon.text isEqualToString:@""] || self.lbl_Tosswon.text==nil)
        {
            [self ShowAlterView:@"Please Select Team"];
        }
        else if([self.lbl_ElectedTo.text isEqualToString:@""] || self.lbl_ElectedTo.text==nil)
        {
            [self ShowAlterView:@"Please Select ElectedTo"];
        }
        else if([self.lbl_Stricker.text isEqualToString:@""] || self.lbl_Stricker.text==nil)
        {
            [self ShowAlterView:@"Please Select Stricker"];
        }
        else if([self.lbl_NonStricker.text isEqualToString:@""] || self.lbl_NonStricker.text==nil)
        {
            [self ShowAlterView:@"Please Select NonStricker"];
        }
        else if([self.lbl_Bowler.text isEqualToString:@""] || self.lbl_Bowler.text==nil)
        {
            [self ShowAlterView:@"Please Select Bowler"];
        }
        else{
            [DBManagerChangeToss InsertTossDetails:self.CompitisonCode :self.matchCode:selectTeamcode :electedcode :StrikerCode :NonStrikerCode :selectBowlerCode :BowlingEnd];
            [self.delegate RedirectScorEngin];
            
        }
    
}

-(IBAction)didClickBackBtnAction:(id)sender
{
    [self.delegate ChangeVCBackBtnAction];
}

-(void)ShowAlterView:(NSString *) alterMsg
{
    UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:alterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objAlter show];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(catagory.count >0)
    {
        return [catagory count];
    }
    else if (isTossWon==YES)
    {
         return [TeamDetailTossWon count];
    }
    else if (isElectedTo == YES)
    {
         return [objElectedTodetailArray count];
    }
    else if (isStricker == YES)
    {
        return [objStrickerdetail count];
    }
    else if (isNonStricker == YES)
    {
        return [objNonStrikerdetail count];
    }
    else if (isBowler == YES)
    {
        return [objBowlingTeamdetail count];
    }

    return NO;
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    
    if(isTossWon ==YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
      cell.textLabel.text = objChanceTeamRecord.TEAMNAME_TOSSWONBY;
    }
    else if (isElectedTo == YES)
    {
        TossDetailRecord * objTossDetailRecord =(TossDetailRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objTossDetailRecord.METASUBCODEDESCRIPTION;
    }
    else if (isStricker == YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objChanceTeamRecord.playerName;

    }
    else if (isNonStricker == YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objChanceTeamRecord.playerName;
    }
    else if (isBowler ==YES)
    {
        FetchBattingTeamTossRecord *objChanceTeamRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
        cell.textLabel.text = objChanceTeamRecord.playerName;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.Tbl_toss.hidden=YES;
    FetchBattingTeamTossRecord* objChangeTossRecord=(FetchBattingTeamTossRecord *)[catagory objectAtIndex:indexPath.row];
    if(isTossWon== YES)
    {
        
        self.lbl_Tosswon.text=objChangeTossRecord.TEAMNAME_TOSSWONBY;
        selectTeam= self.lbl_Tosswon.text;
        selectTeamcode=objChangeTossRecord.TEAMCODE_TOSSWONBY;
    }
    else if(isElectedTo== YES)
    {
         TossDetailRecord* objChangeTossRecord=(TossDetailRecord *)[catagory objectAtIndex:indexPath.row];
        self.lbl_ElectedTo.text =objChangeTossRecord.METASUBCODEDESCRIPTION;
        selectedElected=self.lbl_ElectedTo.text;
        electedcode=objChangeTossRecord.METASUBCODE;
    }
    else if(isStricker== YES)
    {
        self.lbl_Stricker.text=objChangeTossRecord.playerName;
        
        selectStriker=self.lbl_Stricker.text;
        StrikerCode=objChangeTossRecord.playerCode;
    }
    else if(isNonStricker== YES)
    {
       
        if(![self.lbl_Stricker.text isEqualToString: objChangeTossRecord.playerName])
        {
            self.lbl_NonStricker.text =objChangeTossRecord.playerName;
            selectNonStriker=self.lbl_NonStricker.text;
            
            NonStrikerCode=objChangeTossRecord.playerCode;
           
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

    }
    else if(isBowler== YES)
    {
        self.lbl_Bowler.text =objChangeTossRecord.playerName;
        selectBowler=self.lbl_Bowler.text;
        
        selectBowlerCode=objChangeTossRecord.playerCode;
       
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
