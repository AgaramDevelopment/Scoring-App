//
//  Other_WicketVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Other_WicketVC.h"
#import "DbManager_OtherWicket.h"
#import "WicketTypeRecord.h"
#import "SelectPlayerRecord.h"
#import "GetPlayerDetailOnAbsentHurt.h"
#import "GetPlayerDetailOnRetiredHurt.h"
#import "GetPlayerDetailOnTimeOut.h"
#import "GetPlayerDetailOnRetiredHurtOnMSC108.h"
#import "GetStrickerNonStrickerPlayerCode.h"
#import "Other_WicketgridVC.h"
#import "DBManagerInsertScoreEngine.h"
#import "GetWicketDetail.h"
#import "GetWicketEventsPlayerDetail.h"


@interface Other_WicketVC ()
{

    WicketTypeRecord*objEventRecord;
    SelectPlayerRecord *objPlayerRecord;
    GetPlayerDetailOnAbsentHurt *objAbsentHurt;
    GetPlayerDetailOnRetiredHurt *objRetriedHurt;
    GetPlayerDetailOnTimeOut*objTimedOut;
    GetStrickerNonStrickerPlayerCode *objMankading;
    
    GetPlayerDetailOnRetiredHurtOnMSC108 *objretriedOut;
    
    NSString *WICKETPLAYER;
    NSString *WicketStingValues;
    NSMutableArray *Wicketselectindexarray;
    NSMutableArray *PlayerselectindexarrayAH;
    NSMutableArray *PlayerselectindexarrayTO;
    NSMutableArray *PlayerselectindexarrayRH;
    NSMutableArray *PlayerselectindexarrayRO;
    NSMutableArray *PlayerselectindexarrayMK;
    
    NSMutableArray *GetPlayerDetailArray;
    NSMutableArray *GetPlayerDetailsOnAbsentHurtArray;
    NSMutableArray *GetPlayerDetailsOnTimeOutArray;
    NSMutableArray *GetPlayerDetailOnRetiredHurt2Array;
    NSMutableArray *GetPlayerDetailsOnRetiredHurtOnMSC108Array;
    NSMutableArray *GetPlayerDetailsOnRetiredHurtArray;
    NSMutableArray *GetStrikerandnonstrikerArray;
    BOOL isEnableTbl;
    BOOL isAddWicket;
    BOOL isWicketlist;
    DBManagerInsertScoreEngine *dbInsertScoreEngine;
    DbManager_OtherWicket *dbOtherWicket;
    NSMutableArray * GetWicketEventsPlayerDetails;
    
    
//    NSString  *N_WICKETNO;
//    NSString  *N_WICKETTYPE;
  //  NSString  *N_FIELDERCODE;
    
}

@property(nonatomic,strong)NSMutableArray *WICKETARRAY;
@property(nonatomic,strong)NSMutableArray *WICKETPLAYERARRAY;
@property(nonatomic,strong)NSMutableArray *WICKETPLAYERARRAYAH;
@property(nonatomic,strong)NSMutableArray *WICKETPLAYERARRAYTO;
@property(nonatomic,strong)NSMutableArray *WICKETPLAYERARRAYRH;
@property(nonatomic,strong)NSMutableArray *WICKETPLAYERARRAYRO;

@property(nonatomic,strong)NSString *PLAYERSCHECK;

@property(nonatomic,strong)NSString *TOTALRUNS;
@property(nonatomic,strong)NSString *VIDEOLOCATION;

@end

@implementation Other_WicketVC

@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize INNINGSNO;
@synthesize TEAMCODE;
@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize NONSTRIKERNAME;



@synthesize Wicket_lbl;
@synthesize Wicket_tableview;

@synthesize WICKETPLAYERARRAY;
@synthesize WICKETPLAYERARRAYAH;
@synthesize WICKETPLAYERARRAYTO;
@synthesize WICKETPLAYERARRAYRH;
@synthesize WICKETPLAYERARRAYRO;

@synthesize tbl_playername;
@synthesize WICKETARRAY;

@synthesize PLAYERSCHECK;
@synthesize WICKETTYPE;

@synthesize MAXOVER;
@synthesize MAXBALL;
@synthesize BALLCODE;
@synthesize BALLCOUNT;
@synthesize MAXID;
@synthesize N_WICKETNO;
@synthesize N_WICKETTYPE;
@synthesize N_FIELDERCODE;
@synthesize BATTINGPOSITIONNO;

@synthesize WICKETPLAYER;
@synthesize TOTALRUNS;
@synthesize VIDEOLOCATION;
@synthesize WICKETNO;


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    dbInsertScoreEngine = [[DBManagerInsertScoreEngine alloc]init];
    dbOtherWicket = [[DbManager_OtherWicket alloc]init];
    
    self.tbl_playername.hidden=YES;
    
    [self.WICKET_VIEW.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.WICKET_VIEW.layer.borderWidth = 2;
    
    [self.Player_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.Player_view.layer.borderWidth = 2;
    
    [self.WICKET_NO_LBL.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.WICKET_NO_LBL.layer.borderWidth = 2;
 
    if(_ISEDITMODE){
        self.Wicket_lbl.text=WICKETTYPE;
        self.selectplayer_lbl.text=WICKETPLAYER;
        
        [self.btn_save setTitle:@"Update" forState:UIControlStateNormal];
        
    }
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
     [self getWicketListMethod];
    WicketStingValues = [NSString stringWithFormat:@"%@", WICKETNO];
    
    self.WICKET_NO_LBL.text=WicketStingValues;
    

}
-(void)getWicketListMethod
{
    GetWicketEventsPlayerDetails =[[NSMutableArray alloc]init];
    
    
    GetWicketEventsPlayerDetails=[ dbOtherWicket GetWicketEventDetailsForInsertOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
    WICKETNO =[ dbOtherWicket GetWicketNoForInsertOtherwicket :COMPETITIONCODE :MATCHCODE:TEAMCODE :INNINGSNO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
   
    return 1;
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isWicketlist == NO)
    {
        return GetWicketEventsPlayerDetails.count;
    }
else
{    if (tableView == self.Wicket_tableview)
    {
        return [WICKETARRAY count];
    }
    
    if (tableView == self.tbl_playername)
    {
         if([WICKETTYPE isEqual:@"MSC133"])
    {
        return [GetPlayerDetailsOnAbsentHurtArray count];
    }
    else if([WICKETTYPE isEqual:@"MSC101"])
    {
        return [GetPlayerDetailsOnTimeOutArray count];
    }
    else if([WICKETTYPE isEqual:@"MSC108"])
    {
        return [GetPlayerDetailsOnRetiredHurtOnMSC108Array count];
    }
    else if([WICKETTYPE isEqual:@"MSC102"])
    {
        return [GetPlayerDetailOnRetiredHurt2Array count];
    }

        return 0;
    }
    
    else
    {
        return 1;
    }
}
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isWicketlist == NO)
    {
        static NSString *breakidentifier = @"otherwicketcell";
        
        
        Other_WicketgridTVC *cell = (Other_WicketgridTVC *)[tableView dequeueReusableCellWithIdentifier:breakidentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"Other_WicketgridTVC" owner:self options:nil];
            cell = self.Other_WicketCell;
            self.Other_WicketCell = nil;
        }
        
        GetWicketEventsPlayerDetail *veb =(GetWicketEventsPlayerDetail*)[GetWicketEventsPlayerDetails objectAtIndex:indexPath.row];
        
        cell.lbl_wickettype.text=veb.WICKETTYPE;
        cell.lbl_playername.text=veb.WICKETPLAYER;
        cell.lbl_wicketno.text=veb.WICKETNO;
        return cell;

    }
    else{
    if (tableView == self.Wicket_tableview)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objEventRecord=(WicketTypeRecord*)[WICKETARRAY objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objEventRecord.metasubcodedescription;
      
        
        return cell;
    }
    
    
    if (tableView == self.tbl_playername)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        if([WICKETTYPE isEqual:@"MSC133"]){
            
     
            objAbsentHurt = (GetPlayerDetailOnAbsentHurt*)[GetPlayerDetailsOnAbsentHurtArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objAbsentHurt.PLAYERNAME;
      
        }
        else if([WICKETTYPE isEqual:@"MSC101"]){
            
           
            objTimedOut=(GetPlayerDetailOnTimeOut*)[GetPlayerDetailsOnTimeOutArray objectAtIndex:indexPath.row];
            
            cell.textLabel.text =objTimedOut.PLAYERNAME;
         
        }
        else if([WICKETTYPE isEqual:@"MSC108"]){
            

            
            objretriedOut=(GetPlayerDetailOnRetiredHurtOnMSC108*)[GetPlayerDetailsOnRetiredHurtOnMSC108Array objectAtIndex:indexPath.row];
            
            cell.textLabel.text =objretriedOut.PLAYERNAME;
            
            
        }
        else if([WICKETTYPE isEqual:@"MSC102"]){
            
            
            objRetriedHurt =(GetPlayerDetailOnRetiredHurt*)[GetPlayerDetailOnRetiredHurt2Array objectAtIndex:indexPath.row];
            
            cell.textLabel.text =objRetriedHurt.PLAYERNAME;
       }
        
        
        return cell;
        
    }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isWicketlist == NO)
    {
        GetWicketEventsPlayerDetail *veb =(GetWicketEventsPlayerDetail*)[GetWicketEventsPlayerDetails objectAtIndex:indexPath.row];
        self.Wicket_lbl.text=veb.WICKETTYPE;
        self.selectplayer_lbl.text=veb.WICKETPLAYER;
        self.WICKET_NO_LBL.text=veb.WICKETNO;
        WICKETTYPE=veb.WICKETTYPE;
        WICKETPLAYER=veb.WICKETPLAYER;
        WICKETNO=veb.WICKETNO;
        _ISEDITMODE =YES;
        self.WickAddview.hidden=YES;
        
        self.Btn_Add.hidden =YES;
        [self.btn_delete setBackgroundColor:[UIColor colorWithRed:(255/255.0f) green:(86/255.0f) blue:(88/255.0f) alpha:1.0f]];
        self.btn_delete.userInteractionEnabled=YES;
        isAddWicket=YES;
  
    }
    else
    {
    
    if (tableView == self.Wicket_tableview)
    {
        
        Wicketselectindexarray=[[NSMutableArray alloc]init];
        objEventRecord=(WicketTypeRecord*)[WICKETARRAY objectAtIndex:indexPath.row];
        self.Wicket_lbl.text =objEventRecord.metasubcodedescription;
       // WICKETTYPE=self.Wicket_lbl.text;
        WICKETTYPE=objEventRecord.metasubcode;
        [Wicketselectindexarray addObject:objEventRecord];
        
        self.Wicket_tableview.hidden=YES;
        isEnableTbl=YES;
        self.selectplayer_lbl.text=@"Select";
    }
    
   
    if (tableView == self.tbl_playername)
    {
        if([WICKETTYPE isEqual:@"MSC133"]){
        
        PlayerselectindexarrayAH=[[NSMutableArray alloc]init];
        objAbsentHurt=(GetPlayerDetailOnAbsentHurt*)[GetPlayerDetailsOnAbsentHurtArray objectAtIndex:indexPath.row];
        self.selectplayer_lbl.text =objAbsentHurt.PLAYERNAME;
           // WICKETPLAYER=self.selectplayer_lbl.text;
            WICKETPLAYER=objAbsentHurt.PLAYERCODE;

        [PlayerselectindexarrayAH addObject:objAbsentHurt];
        
        self.tbl_playername.hidden=YES;
        isEnableTbl=YES;
        }
        else if([WICKETTYPE isEqual:@"MSC101"]){
            
            PlayerselectindexarrayTO=[[NSMutableArray alloc]init];
            objTimedOut=(GetPlayerDetailOnTimeOut*)[GetPlayerDetailsOnTimeOutArray objectAtIndex:indexPath.row];
            self.selectplayer_lbl.text =objTimedOut.PLAYERNAME;
           // WICKETPLAYER=self.selectplayer_lbl.text;
            WICKETPLAYER=objTimedOut.PLAYERCODE;
            [PlayerselectindexarrayTO addObject:objTimedOut];
            
            self.tbl_playername.hidden=YES;
            isEnableTbl=YES;
        }
        else if([WICKETTYPE isEqual:@"MSC108"]){
            PlayerselectindexarrayRO=[[NSMutableArray alloc]init];
            objretriedOut=(GetPlayerDetailOnRetiredHurtOnMSC108*)[GetPlayerDetailsOnRetiredHurtOnMSC108Array objectAtIndex:indexPath.row];
            self.selectplayer_lbl.text =objretriedOut.PLAYERNAME;
            //WICKETPLAYER=self.selectplayer_lbl.text;
            WICKETPLAYER=objretriedOut.PLAYERCODE;
            [PlayerselectindexarrayRO addObject:objretriedOut];
            
            self.tbl_playername.hidden=YES;
            isEnableTbl=YES;
            
        }
        else if([WICKETTYPE isEqual:@"MSC102"]){
            PlayerselectindexarrayRH=[[NSMutableArray alloc]init];
            objRetriedHurt=(GetPlayerDetailOnRetiredHurt*)[GetPlayerDetailOnRetiredHurt2Array objectAtIndex:indexPath.row];
            self.selectplayer_lbl.text =objRetriedHurt.PLAYERNAME;
           // WICKETPLAYER=self.selectplayer_lbl.text;
            WICKETPLAYER=objRetriedHurt.PLAYERCODE;
            [PlayerselectindexarrayRH addObject:objRetriedHurt];
            
            self.tbl_playername.hidden=YES;
            isEnableTbl=YES;
            
        }     }

    if([WICKETTYPE isEqual:@"MSC107"]){
        self.selectplayer_lbl.text= self.NONSTRIKERNAME;
       WICKETPLAYER=self.NONSTRIKERCODE;

        
    }
    }

}

- (IBAction)back_btn:(id)sender {
    
    if(isAddWicket==YES)
    {
        self.WickAddview.hidden=NO;
        self.Btn_Add.hidden =NO;
        isAddWicket=NO;
        isWicketlist=NO;
        [self.tbl_Wicketlist reloadData];
    }
    else
    {
        [self.delegate ChangeVCBackBtnAction];
        [self.delegate reloadScoreEnginOnOtherWicket];
        isAddWicket=YES;
    }

    
}

-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

- (BOOL) formValidation{
    
    BOOL flag = YES;
    
   
    
    if([Wicket_lbl.text isEqual:@"Select"]){
        [self showDialog:@"Please Select Wicket Type" andTitle:@"Other Wicket"];
//       errorMessage = [NSString stringWithFormat:@"%@",@"Please select Wicket Type.\n"];
        flag = NO;
        return flag;
    }
    
    if([self.selectplayer_lbl.text isEqual:@"Select"]){
        [self showDialog:@"Please enter Player Name." andTitle:@"Other Wicket"];
       // errorMessage = [NSString stringWithFormat:@"%@%@",@"Please Select Player Name.\n",errorMessage];
        flag = NO;
        return flag;
        
        
    }
    return flag;
}


-(IBAction)didclicksave:(id)sender{
    if([self formValidation]){
 
    if(_ISEDITMODE){
       [self UpdateOtherwickets:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO  :WICKETTYPE :WICKETPLAYER :WICKETNO :VIDEOLOCATION :TOTALRUNS];
        
        
       
    }else{
       
       
      
        [self InsertOtherwickets:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :WICKETPLAYER :WICKETTYPE : WICKETNO :VIDEOLOCATION :TOTALRUNS];
    
    }
    
    }
   
}

-(IBAction)didclicktouch:(id)sender{
    
    if(isEnableTbl==NO)
    {
         isWicketlist=YES;
        WICKETARRAY=[[NSMutableArray alloc]init];
        NSMutableArray * FetchWicketArray =[dbOtherWicket RetrieveOtherWicketType];
        for(int i=0; i < [FetchWicketArray count]; i++)
        {
            
            objEventRecord=(WicketTypeRecord*)[FetchWicketArray objectAtIndex:i];
            
            [WICKETARRAY addObject:objEventRecord];
            

        
        [self.Wicket_tableview reloadData];
        self.Wicket_tableview.hidden=NO;
        isEnableTbl=YES;
    }
    }
    else
    {
        isEnableTbl=NO;
        self.Wicket_tableview.hidden=YES;
    }
    
    
}

-(IBAction)didClickAddBtnAction:(id)sender
{
    [self getWicketListMethod];
    WicketStingValues = [NSString stringWithFormat:@"%@", WICKETNO];
    
    self.WICKET_NO_LBL.text=WicketStingValues;
    self.WickAddview.hidden =YES;
    self.Btn_Add.hidden=YES;
    isAddWicket=YES;
    isWicketlist=YES;
    self.selectplayer_lbl.text=@"Select";
    self. Wicket_lbl.text =@"Select";
    
    [self.btn_delete setBackgroundColor:[UIColor grayColor]];
    self.btn_delete.userInteractionEnabled=NO;
}
- (IBAction)didclicktouchplayer:(id)sender {
    
    if(![Wicket_lbl.text isEqualToString:@"Select"] && Wicket_lbl.text!=@"")
    {
    if(isEnableTbl ==NO)
    {
     [self FetchOtherwickets:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : WICKETTYPE:STRIKERCODE:NONSTRIKERCODE];
        isEnableTbl=YES;
        self.tbl_playername.hidden=NO;
         isWicketlist=YES;
    }
    else{
        isEnableTbl=NO;
        self.tbl_playername.hidden=YES;
         isWicketlist=YES;
    }
    
    }
    else
    {
        UIAlertView * objAlter=[[UIAlertView alloc]initWithTitle:@"Other Wicket" message:@"Please select wicket type" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [objAlter show];
    }
    
}

-(IBAction)didclickdelete:(id)sender{
    
    if(WICKETTYPE != nil){
    
    [self DeleteOtherwickets:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :WICKETNO];
        
        self.WickAddview.hidden=NO;
        self.Btn_Add.hidden =NO;
        isWicketlist=NO;
        [self getWicketListMethod];
        [self.tbl_Wicketlist reloadData];
    
//    Other_WicketgridVC*add = [[Other_WicketgridVC alloc]initWithNibName:@"Other_WicketgridVC" bundle:nil];
//    add.COMPETITIONCODE=self.COMPETITIONCODE;
//    add.MATCHCODE=self.MATCHCODE;
//    add.INNINGSNO=self.INNINGSNO;
//    add.TEAMCODE=self.TEAMCODE;
//        add.STRIKERCODE=STRIKERCODE;
//        add.NONSTRIKERCODE=NONSTRIKERCODE;
//        add.NONSTRIKERNAME=NONSTRIKERNAME;
//        add.MAXOVER=MAXOVER;
//        add.MAXBALL=MAXBALL;
//        add.BALLCOUNT=BALLCOUNT;
//        add.N_WICKETNO=N_WICKETNO;
//        add.BALLCODE=BALLCODE;
//    
//    [self addChildViewController:add];
//    add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//    [self.view addSubview:add.view];
//    add.view.alpha = 0;
//    [add didMoveToParentViewController:self];
//
//    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//     {
//         add.view.alpha = 1;
//     }
//                     completion:nil];
    }
    else{
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Other Wicket" message:@"No Record selected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];

    }
    
}


-(void)FetchOtherwickets:COMPETITIONCODE: MATCHCODE : TEAMCODE : INNINGSNO : WICKETTYPE: STRIKERCODE :NONSTRIKERCODE

{
    
    
    if(![ dbOtherWicket GetStrickerNonStrickerCodeForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO])
    {
        if([WICKETTYPE isEqual:@"MSC133"])
        {
            
          GetPlayerDetailArray=[ dbOtherWicket GetPlayerDetailForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE : INNINGSNO];
            
            
            for(int i=0; i < [GetPlayerDetailArray count]; i++)
            {
                
                objAbsentHurt=(SelectPlayerRecord*)[GetPlayerDetailArray objectAtIndex:i];
                
                [GetPlayerDetailArray addObject:objAbsentHurt];
                
                
                
                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;

        }
        }
        
        else if([WICKETTYPE isEqual:@"MSC101"])
        {
        GetPlayerDetailArray=[ dbOtherWicket GetPlayerDetailForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE : INNINGSNO];
            
            for(int i=0; i < [GetPlayerDetailArray count]; i++)
            {
                
                objPlayerRecord=(SelectPlayerRecord*)[GetPlayerDetailArray objectAtIndex:i];
                
                [GetPlayerDetailArray addObject:objPlayerRecord];
                
                
                
                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;
            }

        }else if([WICKETTYPE isEqual:@"MSC108"])
        {
            GetPlayerDetailArray=[ dbOtherWicket GetPlayerDetailForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE : INNINGSNO];
            
            for(int i=0; i < [GetPlayerDetailArray count]; i++)
            {
                
                objPlayerRecord=(SelectPlayerRecord*)[GetPlayerDetailArray objectAtIndex:i];
                
                [GetPlayerDetailArray addObject:objPlayerRecord];
                
                
                
                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;
            }
            
        }
        else if([WICKETTYPE isEqual:@"MSC102"])
        {
            GetPlayerDetailsOnRetiredHurtArray=[ dbOtherWicket GetPlayerDetailOnRetiredHurtForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
            
            for(int i=0; i < [GetPlayerDetailsOnRetiredHurtArray count]; i++)
            {
                
                objRetriedHurt=(GetPlayerDetailOnRetiredHurt*)[GetPlayerDetailOnRetiredHurt2Array objectAtIndex:i];
                
                [GetPlayerDetailsOnRetiredHurtArray addObject:objPlayerRecord];
                
                
                
                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;

            }
        }
        
        
    }
    else
    {
        if([WICKETTYPE isEqual:@"MSC133"])
        {
        GetPlayerDetailsOnAbsentHurtArray=[ dbOtherWicket GetPlayerDetailOnAbsentHurtForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
            
                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;
                
           

        }
        else if([WICKETTYPE isEqual:@"MSC101"])
        {
            GetPlayerDetailsOnTimeOutArray=[ dbOtherWicket GetPlayerDetailOnTimeOutForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];

                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;
            

        }
        else if([WICKETTYPE isEqual:@"MSC102"])
        {
           GetPlayerDetailOnRetiredHurt2Array=[ dbOtherWicket GetPlayerDetailOnRetiredHurt2ForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];

            
                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;
                
           
        }
        else if([WICKETTYPE isEqual:@"MSC108"])
        {
            GetPlayerDetailsOnRetiredHurtOnMSC108Array=[ dbOtherWicket GetPlayerDetailOnRetiredHurtOnMSC108ForFetchOtherwicketPlayerDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];

            
                [self.tbl_playername reloadData];
                self.tbl_playername.hidden=NO;
           

        }
    }
    
    
}
//--------------------
//insert other wicket
//--------------------

-(void) InsertOtherwickets:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSNumber*)INNINGSNO : (NSString*)WICKETPLAYER :(NSString*)WICKETTYPE : (NSNumber*)WICKETNO :(NSString*)VIDEOLOCATION: (NSString*)TOTALRUNS
{
    
    
    
    if([[dbOtherWicket GetBallCodeForInsertOtherwicket : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : WICKETPLAYER] isEqual:@""])
    {
        
        MAXOVER=[dbOtherWicket GetMaxOverForInsertOtherwicket : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO ];
        
        MAXBALL=[dbOtherWicket GetMaxBallForInsertOtherwicket : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : MAXOVER ];
        
        BALLCOUNT=[dbOtherWicket GetMaxBallCountForInsertOtherwicket : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : MAXOVER : MAXBALL ];
        
        if(![[dbOtherWicket GetBallCodeOnExistsForInsertOtherwicket : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : MAXOVER : MAXBALL: BALLCOUNT ]isEqual:@""])
        {
            BALLCODE=[dbOtherWicket GetBallCodeForAssignForInsertOtherwicket : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : MAXOVER : MAXBALL: BALLCOUNT ];
            
        }
        else
        {
            
            MAXID=[dbOtherWicket GetMaxIdForInsertOtherwicket : MATCHCODE ];
            
            BALLCODE=[dbInsertScoreEngine GetMaxIdForInsertScoreEngine:MATCHCODE];
            
            //BALLCODE = MATCHCODE + RIGHT(REPLICATE('0':10)+CAST(MAXID AS VARCHAR(10)):10);
        }
        
     [dbOtherWicket InsertWicketEventForInsertOtherwicket : BALLCODE:COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO:WICKETNO:WICKETTYPE:WICKETPLAYER:VIDEOLOCATION ];
        
        
        NSMutableArray *GetWicketDetails=[ dbOtherWicket GetWicketDetailForInsertOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETPLAYER ];
        
        
					   if(GetWicketDetails.count>0)
                       {
                           
                           N_WICKETNO  = [[GetWicketDetails valueForKey:@"WICKETNO"] objectAtIndex:0];
                           N_WICKETTYPE = [[GetWicketDetails valueForKey:@"WICKETTYPE"] objectAtIndex:0];
                           N_FIELDERCODE = [[GetWicketDetails valueForKey:@"FIELDINGPLAYER"] objectAtIndex:0];
                           
                       }
        if(![[ dbOtherWicket GetBatsManCodeForInsertOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETPLAYER ]isEqual:@""])
        {
           [ dbOtherWicket UpdateBattingSummaryForInsertOtherwicket:N_WICKETNO :N_WICKETTYPE :N_FIELDERCODE :TOTALRUNS :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :WICKETPLAYER];
            
            
        }
        else
        {
            [ dbOtherWicket GetBattingPositionNoForInsertOtherwicket :COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
            
            [ dbOtherWicket InsertBattingSummaryForInsertOtherwicket :COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO:BATTINGPOSITIONNO:WICKETPLAYER:N_WICKETNO:N_WICKETTYPE:TOTALRUNS];
        }
        if([ dbOtherWicket GetInningsNoForInsertOtherwicket :COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO]!=0)
        {
            [ dbOtherWicket UpdateInningsSummaryForInsertOtherwicket :COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
        }
        else
        {
            
            [ dbOtherWicket InsertInningsSummaryForInsertOtherwicket :COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
        }
       
        
    }
    NSMutableArray *GetPlayerDetails=[ dbOtherWicket GetPlayerDetailForInsertOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE];
    
    NSMutableArray *GetWicketEventsDetails=[ dbOtherWicket GetWicketEventDetailsForInsertOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
    
    UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Other Wicket" message:@"Other Wicket Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];
    
    [ dbOtherWicket GetWicketNoForInsertOtherwicket :COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    
    
    self.WickAddview.hidden=NO;
    self.Btn_Add.hidden =NO;
    isWicketlist=NO;
    GetWicketEventsPlayerDetails=[[NSMutableArray alloc]init];
    GetWicketEventsPlayerDetails= GetWicketEventsDetails;
    [self.tbl_Wicketlist reloadData];

    
    
    
//    Other_WicketgridVC*add = [[Other_WicketgridVC alloc]initWithNibName:@"Other_WicketgridVC" bundle:nil];
//    
//    GetWicketEventsPlayerDetails=GetWicketEventsPlayerDetails;
//    self.WickAddview.hidden=NO;
//    isWicketlist=NO;
//    //[self getWicketListMethod];
//    [self.tbl_Wicketlist reloadData];
    //add.GetPlayerDetails=GetPlayerDetails;
//   //add.GetWicketDetails=GetWicketDetails;
// 
//    //vc2 *viewController = [[vc2 alloc]init];
//    [self addChildViewController:add];
//    add.view.frame =CGRectMake(0, 0, add.view.frame.size.width, add.view.frame.size.height);
//    [self.view addSubview:add.view];
//    add.view.alpha = 0;
//    [add didMoveToParentViewController:self];
//    
//    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//     {
//         add.view.alpha = 1;
//     }
//                     completion:nil];
//    
    

    
}

//--------------------
//UPDATE OTHER WICKETS
//---------------------

-(void) UpdateOtherwickets:(NSString *)COMPETITIONCODE: (NSString *)  MATCHCODE : (NSString *) TEAMCODE : (NSNumber *)INNINGSNO : (NSString*)WICKETTYPE : (NSString*)WICKETPLAYER : 	(NSNumber*)WICKETNO :(NSString*)VIDEOLOCATIONNAME: (NSString*)TOTALRUNS
{
   
    if([[dbOtherWicket GetBallCodeForUpdateOtherwicket : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETPLAYER:WICKETNO:WICKETTYPE] isEqual:@""])
    {
        
        [dbOtherWicket UpdateWicKetEventUpdateOtherwicket :WICKETTYPE:WICKETPLAYER:VIDEOLOCATION:COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO:WICKETNO];
        
        
 //   NSMutableArray *GetWicketOnAssignDetails=[ dbOtherWicket GetWicketOnAssignForUpdateOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETPLAYER ];
        
//        
//					   if(GetWicketOnAssignDetails.count>0)
//                       {
//                           
////                           N_WICKETNO =[GetWicketOnAssignDetails objectAtIndex:0];
////                           N_WICKETTYPE = [GetWicketOnAssignDetails objectAtIndex:1];
////                           N_FIELDERCODE = [GetWicketOnAssignDetails objectAtIndex:2];
//                           
//                       }
        NSMutableArray *GetWicketDetailsArray= [dbOtherWicket GetwicketForUpdateOtherwicket:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :WICKETPLAYER];
       
                            if(GetWicketDetailsArray.count>0)
                              {
                               GetWicketDetail *wicketdetailss =[GetWicketDetailsArray objectAtIndex:0];
                                
                        
                                  N_WICKETNO =  wicketdetailss.WICKETNO;
                                  N_WICKETTYPE =wicketdetailss.WICKETTYPE;
                                  N_FIELDERCODE =wicketdetailss.FIELDINGPLAYER;
//                                  for(int i ; i< GetWicketEventsPlayerDetails.count;i++)
//                                  {
//                                       GetWicketEventsPlayerDetail *veb =(GetWicketEventsPlayerDetail*)[GetWicketEventsPlayerDetails objectAtIndex:i];
//                                      if(veb.WICKETNO == N_WICKETNO)
//                                      {
//                                          veb.WICKETTYPECODE=
//                                      }
//                                  }
                                  
                                   }
        
   
        [dbOtherWicket UpdateBattingSummaryForUpdateOtherwicket :  WICKETNO: WICKETTYPE: N_FIELDERCODE : TOTALRUNS:COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO: WICKETPLAYER];
        
        self.WickAddview.hidden=NO;
        self.Btn_Add.hidden =NO;
        isWicketlist=NO;
        GetWicketEventsPlayerDetails=[[NSMutableArray alloc]init];
        //GetWicketEventsPlayerDetails= wicketdetailss;
        //[self.tbl_Wicketlist reloadData];

        
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Other Wicket" message:@"Other Wicket Updated Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];

        
       // NSMutableArray *GetWicketEventsPlayerDetails=[ dbOtherWicket GetWicketEventDetailsForUpdateOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
        
      
        
        
        
        
        
    }
    NSMutableArray *GetPlayerDetails=[ dbOtherWicket GetPlayerDetailForUpdateOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE];
      [ dbOtherWicket GetWicketNoForUpdateOtherwicket :COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
}


//--------------------
//DELETE OTHER WICKETS
//---------------------

-(void) DeleteOtherwickets:(NSString *)COMPETITIONCODE: (NSString *)  MATCHCODE : (NSString *) TEAMCODE : (NSNumber *)INNINGSNO : (NSNumber*)WICKETNO


{
   if(![[dbOtherWicket GetBallCodeForDeleteOtherwicket:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO  :WICKETNO]isEqual:@""])
   {
    NSMutableArray *GetWicketPlayerandtypePlayerDetails=[ dbOtherWicket GetWicketPlayerandTypeForDeleteOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETNO ];
    
//    if(GetWicketPlayerandtypePlayerDetails.count>0)
//    {
//        
//        WICKETPLAYER = [GetWicketPlayerandtypePlayerDetails objectAtIndex:0];
//							 N_WICKETTYPE = [GetWicketPlayerandtypePlayerDetails objectAtIndex:1];
//        
//        
//    }
       
       if(GetWicketPlayerandtypePlayerDetails.count>0)
       {
           GetWicketEventsPlayerDetail *deletewicketdetailss =[GetWicketPlayerandtypePlayerDetails objectAtIndex:0];
           
            N_FIELDERCODE =deletewicketdetailss.WICKETPLAYER;
            N_WICKETTYPE =deletewicketdetailss.WICKETTYPE;
           
       }
    
    if (N_WICKETTYPE = @"MSC107" )
    {
						  
	[ dbOtherWicket UpdateBattingSummaryForDeleteOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:N_FIELDERCODE ];
    }
    else
    {
        
    [dbOtherWicket DeleteBattingSummaryForDeleteOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:N_FIELDERCODE];
        
    }
    
    [dbOtherWicket UpdateBattingSummaryDetailForDeleteOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETNO];
    
    [ dbOtherWicket UpdateInningsSummaryDetailForDeleteOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO ];
    
    [ dbOtherWicket DeleteWicketEventsForDeleteOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETNO ];
    
    [ dbOtherWicket UpdateWicketEventsForDeleteOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:WICKETNO ];
    
   }
				
    NSMutableArray *GetPlayerDetailForDeleteOtherwicket=[ dbOtherWicket GetPlayerDetailForUpdateOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE];
    
  //  NSMutableArray *GetWicketEventDetailsForDeleteOtherwicket=[ dbOtherWicket GetWicketEventDetailsForUpdateOtherwicket :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO];
    
    [dbOtherWicket GetWicketNoForDeleteOtherwicket :COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"Other Wicket" message:@"Other Wicket Deleted Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];
}


- (IBAction)check:(id)sender {
     [self FetchOtherwickets :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : WICKETTYPE:STRIKERCODE:NONSTRIKERCODE];
}

@end
