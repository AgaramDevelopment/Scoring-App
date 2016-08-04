//
//  PlayerOrderLevelVC.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 01/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerOrderLevelVC.h"
#import "CustomNavigationVC.h"
#import "PlayerLevelCell.h"
#import "SelectPlayerRecord.h"
#import "DBManager.h"
#import "NewMatchSetUpVC.h"
#import "CapitainWicketKeeperRecord.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"

@interface PlayerOrderLevelVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CustomNavigationVC *objCustomNavigation;
   
    BOOL isSelectCaptainType;
    BOOL isSelectWKTKeeperType;
    NSMutableArray*slecteplayerlist;
    UIGestureRecognizer *_dndLongPressGestureRecognizer;
    PlayerLevelCell*playercell;
    NSMutableArray *objPreviousorderList;
    NSMutableArray* capitainWicketkeeperarray;
    CapitainWicketKeeperRecord* objCapitainWicketKeeper;
    BOOL  isCaptain;
    NSMutableArray * previousArray;
    NSMutableArray * wickplayerlist;
    
    DBManager *objDBManager;
    BOOL isMoveBottom;

}
@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;
@property(nonatomic,strong)UITableView * tbl_playerSelectList;
@property(nonatomic,strong)UITextField *txt_search;
@property(nonatomic,strong) NSMutableArray*selectedPlayerFilterArray;
@property(nonatomic,strong)  UIButton *Btn_objSearch;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UIImageView *draggingView;
@property (nonatomic, assign) CGFloat scrollRate;
@property (nonatomic, strong) NSIndexPath *currentLocationIndexPath;
@property (nonatomic, strong) NSIndexPath *initialIndexPath;
@property (nonatomic, retain) id savedObject;
@property (nonatomic, strong) CADisplayLink *scrollDisplayLink;
@property (nonatomic, assign) CGFloat draggingRowHeight;
@property (nonatomic, assign) CGFloat draggingViewOpacity;

@end

@implementation PlayerOrderLevelVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    objDBManager = [[DBManager alloc]init];
    [self customnavigationmethod];
    
    
    objPreviousorderList =[[NSMutableArray alloc]init];
         slecteplayerlist=[[NSMutableArray alloc]init];
    capitainWicketkeeperarray=[NSMutableArray alloc];
    capitainWicketkeeperarray=  [objDBManager getTeamCaptainandTeamwicketkeeper :self.competitionCode :self.matchCode];
    if(capitainWicketkeeperarray.count > 0)
    {
        CapitainWicketKeeperRecord *captainWKTRecord=(CapitainWicketKeeperRecord *)[capitainWicketkeeperarray objectAtIndex:0];
        self.captainAcode=captainWKTRecord.objTeamACapitain;
        self.captainBcode=captainWKTRecord.objTeamBCapitain;
        self.WKTkeeperAcode=captainWKTRecord.objTeamAWicketKeeper;
        self.WKTkeeperBcode=captainWKTRecord.objTeamBWicketKeeper;
        isCaptain=YES;
        
        
    }
    wickplayerlist =[[NSMutableArray alloc]init];
    wickplayerlist = [objDBManager getPlayedPlayersForPlayerXI :self.matchCode COMPETITIOMCODE:self.competitionCode OVERNO:self.overs BALLNO:self.ballOver ];
    
   

    
    [self selectplayfilterArray ];
    
   
    UIImageView *bg_img=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height,self.view.frame.size.width,self.view.frame.size.height)];
    bg_img.image=[UIImage imageNamed:@"BackgroundImg"];
    [self.view addSubview:bg_img];
    
    
    // search design
    UIView * searchView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,objCustomNavigation.view.frame.origin.y+20,self.view.frame.size.width-20, 90)];
    [bg_img addSubview:searchView];
    [searchView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
    self.txt_search = [[UITextField alloc] initWithFrame:CGRectMake(20,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+20,self.view.frame.size.width-150,80)];
    [self.view addSubview:self.txt_search];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"SEARCH PLAYER" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] ,NSFontAttributeName : [UIFont systemFontOfSize:35]}];
   
     self.txt_search.attributedPlaceholder = str;
    //lastName.placeholder = @"Enter your last name here";
    
    self.txt_search.font = [UIFont systemFontOfSize:40];
    self.txt_search.adjustsFontSizeToFitWidth = YES;
    self.txt_search.userInteractionEnabled=YES;

    self.txt_search.backgroundColor=[UIColor clearColor];
    
    self.txt_search.textColor = [UIColor whiteColor];
    self.txt_search.keyboardType = UIKeyboardTypeAlphabet;
    self.txt_search.returnKeyType = UIReturnKeyDone;
    self.txt_search.enabled=YES;
    self.txt_search.delegate = self;
    
    
    self.Btn_objSearch=[[UIButton alloc]initWithFrame:CGRectMake(searchView.frame.size.width-80,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+30,70,70)];
    [self.Btn_objSearch setBackgroundColor:[UIColor clearColor]];
    [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
    [self.Btn_objSearch addTarget:self action:@selector(didClickSearchplayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.Btn_objSearch];
    
    
    
    
    // Bottomview design
    
    
    UIView * BottomView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,bg_img.frame.size.height-200,self.view.frame.size.width-20, 100)];
    [bg_img addSubview:BottomView];
    [BottomView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
    
    UIImageView *Img_Delete=[[UIImageView alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-180,25,52,52)];
    
    [Img_Delete setImage:[UIImage imageNamed:@"ico-cancel"]];
    
    [BottomView addSubview:Img_Delete];
    
   
    
    UIImageView *Img_Save=[[UIImageView alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-90,25,52,52)];
    
    [Img_Save setImage:[UIImage imageNamed:@"ico-proceed"]];
    [BottomView addSubview:Img_Save];
    
    
    UIButton *Btn_Delete=[[UIButton alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-180,bg_img.frame.size.height-80,70,70)];
    [Btn_Delete setBackgroundColor:[UIColor clearColor]];
    //[Btn_Delete setImage:[UIImage imageNamed:@"ico-cancel"] forState:UIControlStateNormal];
    [Btn_Delete addTarget:self action:@selector(didClickDeleteplayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn_Delete];
    
    
    
    UIButton *Btn_Save=[[UIButton alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-90,bg_img.frame.size.height-80,70,70)];
    [Btn_Save setBackgroundColor:[UIColor clearColor]];
    //[Btn_Save setImage:[UIImage imageNamed:@"ico-proceed"] forState:UIControlStateNormal];
    [Btn_Save addTarget:self action:@selector(didClickSaveplayer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:Btn_Save];
    
    
    // tableview design
    
    _tbl_playerSelectList = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+20,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+150,self.view.frame.size.width-40,BottomView.frame.origin.y-160)];
    [self.view addSubview:_tbl_playerSelectList];
    _tbl_playerSelectList.backgroundColor=[UIColor clearColor];
    //[ self.tbl_playerSelectList setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    _tbl_playerSelectList.delegate=self;
    _tbl_playerSelectList.dataSource=self;
    //tbl_playerSelectList.scrollEnabled=YES;
  
    
    
    
}
-(void)selectplayfilterArray
{
    for(int i=0; i< self.objSelectplayerList_Array.count; i++)
    {
         SelectPlayerRecord *selectedPlayerFilterRecord = [self.objSelectplayerList_Array objectAtIndex:i];
       // int orderlevel=[selectedPlayerFilterRecord.playerOrder intValue]-1;
        if( [[selectedPlayerFilterRecord isSelected]boolValue])
        {
            if([self.captainAcode isEqualToString :selectedPlayerFilterRecord.playerCode ])
            {
                selectedPlayerFilterRecord.isSelectCapten=@"YES";
                isSelectCaptainType=YES;
            }
            else if ([self.WKTkeeperAcode isEqualToString:selectedPlayerFilterRecord.playerCode])
            {
                selectedPlayerFilterRecord.isSelectWKTKeeper=@"YES";
                isSelectWKTKeeperType=YES;
            }
            else if([self.captainBcode isEqualToString :selectedPlayerFilterRecord.playerCode ])
            {
                selectedPlayerFilterRecord.isSelectCapten=@"YES";
                isSelectCaptainType=YES;
            }
            else if ([self.WKTkeeperBcode isEqualToString:selectedPlayerFilterRecord.playerCode])
            {
                selectedPlayerFilterRecord.isSelectWKTKeeper=@"YES";
                isSelectWKTKeeperType=YES;
            }
            [slecteplayerlist addObject:selectedPlayerFilterRecord];
            
            
            
        }
    }
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"PLAYING XI";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didClickSearchplayer
{
    if([self.Btn_objSearch.currentImage  isEqual: [UIImage imageNamed:@"ico-cancel"]]){
        self.txt_search.text =@"";
        [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
        self.selectedPlayerFilterArray=[[NSMutableArray alloc]init];
        
        self.selectedPlayerFilterArray =nil;
        [slecteplayerlist removeAllObjects];
        
        for(int i=0; i< self.objSelectplayerList_Array.count; i++)
        {
            SelectPlayerRecord *selectedPlayerFilterRecord = [self.objSelectplayerList_Array objectAtIndex:i];
            if( [[selectedPlayerFilterRecord isSelected]boolValue])
            {
                [slecteplayerlist addObject:selectedPlayerFilterRecord];
                
                
            }
        }
        [self.txt_search resignFirstResponder];
         [_tbl_playerSelectList reloadData];
        
    }
    //Relaod view
   
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([self.Btn_objSearch.currentImage  isEqual: [UIImage imageNamed:@"ico-cancel"]])
    {
        [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
        
    }
    else
    {
      [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-cancel"] forState:UIControlStateNormal];
    }
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (![string isEqualToString:@""]) {
        
        NSString *appStr=[textField.text stringByAppendingString:string];
        
        [self.selectedPlayerFilterArray removeAllObjects];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"playerName contains[c] %@",appStr];
        
        NSArray *filtedPlayerArray =  [slecteplayerlist filteredArrayUsingPredicate:resultPredicate];
        
        self.selectedPlayerFilterArray = [[NSMutableArray alloc] initWithArray:filtedPlayerArray];
        
        
        [_tbl_playerSelectList reloadData];

        return YES;
    }
    else {
        NSString *appStr=[textField.text stringByAppendingString:string];
        NSString *newString = [appStr substringToIndex:[appStr length]-1];
        [self.selectedPlayerFilterArray removeAllObjects];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"playerName beginswith[c] %@",newString];
        
        NSArray *filtedPlayerArray =  [slecteplayerlist filteredArrayUsingPredicate:resultPredicate];
        
        self.selectedPlayerFilterArray = [[NSMutableArray alloc] initWithArray:filtedPlayerArray];
        
        if([newString isEqualToString:@""])
        {
            if([self.Btn_objSearch.currentImage  isEqual: [UIImage imageNamed:@"ico-cancel"]]){
                self.txt_search.text =@"";
                [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
                self.selectedPlayerFilterArray=[[NSMutableArray alloc]init];
                
                self.selectedPlayerFilterArray =nil;
                }
                [self.txt_search resignFirstResponder];

        }
        [_tbl_playerSelectList reloadData];
        
        return YES;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
   
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}
-(IBAction)didClickDeleteplayer:(id)sender
{
    capitainWicketkeeperarray=  [objDBManager getTeamCaptainandTeamwicketkeeper :self.competitionCode :self.matchCode];
    if(capitainWicketkeeperarray.count > 0)
    {
        CapitainWicketKeeperRecord *captainWKTRecord=(CapitainWicketKeeperRecord *)[capitainWicketkeeperarray objectAtIndex:0];
        self.captainAcode=captainWKTRecord.objTeamACapitain;
        self.captainBcode=captainWKTRecord.objTeamBCapitain;
        self.WKTkeeperAcode=captainWKTRecord.objTeamAWicketKeeper;
        self.WKTkeeperBcode=captainWKTRecord.objTeamBWicketKeeper;
        isCaptain=YES;
        
        
    }
    

    slecteplayerlist=[[NSMutableArray alloc]init];
    objPreviousorderList=[objDBManager getSelectingPlayerArray :self.TeamCode matchCode:self.matchCode];
    for(int i=0; i< objPreviousorderList.count; i++)
    {
        SelectPlayerRecord *selectedPlayerFilterRecord = [objPreviousorderList objectAtIndex:i];
        // int orderlevel=[selectedPlayerFilterRecord.playerOrder intValue]-1;
        if( [[selectedPlayerFilterRecord isSelected]boolValue])
        {
            if([self.captainAcode isEqualToString :selectedPlayerFilterRecord.playerCode ])
            {
                selectedPlayerFilterRecord.isSelectCapten=@"YES";
                isSelectCaptainType=YES;
            }
            else if ([self.WKTkeeperAcode isEqualToString:selectedPlayerFilterRecord.playerCode])
            {
                selectedPlayerFilterRecord.isSelectWKTKeeper=@"YES";
                isSelectWKTKeeperType=YES;
            }
            else if([self.captainBcode isEqualToString :selectedPlayerFilterRecord.playerCode ])
            {
                selectedPlayerFilterRecord.isSelectCapten=@"YES";
                isSelectCaptainType=YES;
            }
            else if ([self.WKTkeeperBcode isEqualToString:selectedPlayerFilterRecord.playerCode])
            {
                selectedPlayerFilterRecord.isSelectWKTKeeper=@"YES";
                isSelectWKTKeeperType=YES;
            }
            
            [slecteplayerlist addObject:selectedPlayerFilterRecord];
            
            
        }
    }

    [self.tbl_playerSelectList reloadData];
}

-(IBAction)didClickSaveplayer:(id)sender
{

    if(isSelectCaptainType == YES && isSelectWKTKeeperType ==YES)
   {
       AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
       
       
       [delegate showLoading];
    for(int i=0;  i < slecteplayerlist.count; i++)
    {
        SelectPlayerRecord *playerorderRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:i];
        [objDBManager updatePlayerorder :self.matchCode :self.TeamCode PlayerCode:playerorderRecord.playerCode PlayerOrder:playerorderRecord.playerOrder];
        
        if(self.checkInternetConnection){
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            
//            _matchCode = (self.matchCode == nil) ?@"NULL":_matchCode;
//            _TeamCode = (_TeamCode == nil) ?@"NULL":_TeamCode;
//            NSString*PlayerCode = playerorderRecord.playerCode == nil ?@"NULL":playerorderRecord.playerCode;
//             NSString*PlayerOrder = playerorderRecord.playerOrder == nil ?@"NULL":playerorderRecord.playerOrder;
//            
           
            
            
                NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/MATCHTEAMPLAYERORDER/%@/%@/%@/%@",[Utitliy getSyncIPPORT],_matchCode,_TeamCode,playerorderRecord.playerCode ,playerorderRecord.playerOrder];
                NSLog(@"-%@",baseURL);
            
            
                NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response;
                NSError *error;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
                if(responseData !=nil)
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
});
            
        }
                             
        
    }
       [delegate hideLoading];
    [objDBManager updateCapitainWicketkeeper :self.competitionCode :self.matchCode capitainAteam:self.captainAcode capitainBteam:self.captainBcode wicketkeeperAteam:self.WKTkeeperAcode wicketkeeperBteam:self.WKTkeeperBcode];
    
       if([[NSUserDefaults standardUserDefaults] boolForKey:@"ScoreEnginExit"]) {
           NSLog(@"no");
           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ScoreEnginExit"];
           
           
       }
    
          else if([[NSUserDefaults standardUserDefaults] boolForKey:@"NewMatchSetUp"]) {
               NSLog(@"no");
           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewMatchSetUp"];
       }
       
           NewMatchSetUpVC * objNewMatchSetUp = [[NewMatchSetUpVC alloc]init];
       objNewMatchSetUp =  (NewMatchSetUpVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"matchSetUpSBID"];
       objNewMatchSetUp.matchCode=self.matchCode;
       objNewMatchSetUp.teamAcode=self.TeamCode;
       
       objNewMatchSetUp.teamA=self.teamA;
       objNewMatchSetUp.teamB=self.teamB;
       objNewMatchSetUp.teamAcode=self.teamAcode;
       objNewMatchSetUp.teamBcode=self.teamBcode;
       objNewMatchSetUp.matchVenu=self.matchVenu;
       objNewMatchSetUp.matchTypeCode=self.matchTypeCode;
       objNewMatchSetUp.matchType=self.matchType;
       objNewMatchSetUp.month=self.month;
       objNewMatchSetUp.time=self.time;
       objNewMatchSetUp.date=self.date;
       objNewMatchSetUp.overs=self.overs;
       objNewMatchSetUp.competitionCode=self.competitionCode;
       objNewMatchSetUp.overs=self.overs;
       objNewMatchSetUp.isEdit =self.isEdit;
       [self.navigationController pushViewController:objNewMatchSetUp animated:YES];
    
   

}
   else{
       if (isSelectCaptainType == NO && isSelectWKTKeeperType == NO )
       {
           [self AlterviewMethod:@"Please Select Captain And Wicketkeeper"];
       }
      else if(isSelectCaptainType == NO)
       {
           [self AlterviewMethod:@"Please Select Captain"];
       }
       else if(isSelectWKTKeeperType == NO)
       {
           [self AlterviewMethod:@"Please Select Wicketkeeper"];
       }
//       else if (isSelectCaptainType == NO && isSelectWKTKeeperType == NO )
//       {
//           [self AlterviewMethod:@"Please Select Captain And Wicketkeeper"];
//       }
   }
}
-(void) AlterviewMethod:(NSString *) AlterMsg
{
    
    UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"Player XI" message:AlterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.selectedPlayerFilterArray > 0)
   {
      return [self.selectedPlayerFilterArray count];
   }
    else if([previousArray count] >0)
    {
        return [previousArray  count];
    }
 else
   {
      return [slecteplayerlist  count];
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *captainATeam;
    NSString *captainBTeam;
   playercell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger variable = indexPath.row;
    int ordernumber =(int) variable +1;
    SelectPlayerRecord *objSelectPlayerRecord;
    CapitainWicketKeeperRecord*objCapitainWicketRecord;
    
    
    if (playercell == nil) {
        playercell = [[PlayerLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        playercell.backgroundColor = [UIColor clearColor];
       
        
        
    }
    [playercell.Btn_Captain addTarget:self action:@selector(didClickCaptain_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [playercell.Btn_WktKeeper addTarget:self action:@selector(didClickWktKeeper_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [playercell.Btn_drag addTarget:self action:@selector(didClickDrag_BtnAction:) forControlEvents:UIControlEventTouchUpInside];


//    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [playercell addGestureRecognizer: self.longPress];
    
    
    if(self.selectedPlayerFilterArray > 0)
    {
        objSelectPlayerRecord=(SelectPlayerRecord*)[self.selectedPlayerFilterArray objectAtIndex:indexPath.row];
        //objCapitainWicketRecord=(CapitainWicketKeeperRecord*)[capitainWicketkeeperarray objectAtIndex:indexPath.r];
    }
    else
    {
       objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
       // objCapitainWicketRecord=(CapitainWicketKeeperRecord*)[capitainWicketkeeperarray objectAtIndex:0];
      
        
    }
   

    if([objSelectPlayerRecord.playerCode isEqualToString:self.captainAcode] || [objSelectPlayerRecord.playerCode isEqualToString:self.captainBcode])
    {
        //objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
        
        if([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"] && [objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
        {
            
            playercell.IMg_captain.image=[UIImage imageNamed:@"Img_Captain"];
            
            [playercell.IMg_captain setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
            [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            isSelectCaptainType=YES;
            isSelectWKTKeeperType=YES;
            
        }
        else if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
        {
            playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_Captain"];
            
            [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            
            //objSelectPlayerRecord.isSelectCapten=@"YES";
            isSelectCaptainType=YES;
           
        }
        else if(isCaptain == NO)
        {
            playercell.IMg_captain.image=[UIImage imageNamed:@""];
            [playercell.IMg_captain setBackgroundColor:[UIColor clearColor]];
            
            objSelectPlayerRecord.isSelectCapten=nil;
        }
        
    }
    else{
       
        playercell.IMg_captain.image=[UIImage imageNamed:@""];
        [playercell.IMg_captain setBackgroundColor:[UIColor clearColor]];
       
        objSelectPlayerRecord.isSelectCapten=nil;
    }
    
     if ([objSelectPlayerRecord.playerCode isEqualToString:self.WKTkeeperAcode] || [objSelectPlayerRecord.playerCode isEqualToString:self.WKTkeeperBcode])
    {
        //objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
       objSelectPlayerRecord.isSelectWKTKeeper=@"YES";
        isSelectWKTKeeperType=YES;
        
         if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
         {
             if([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])
             {
                 playercell.IMg_captain.image=[UIImage imageNamed:@"Img_Captain"];
             
                 [playercell.IMg_captain setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
                  playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
                 [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
             //objSelectPlayerRecord.isSelectWKTKeeper=@"YES";
             //
                //isSelectWKTKeeperType=YES;
             }
             else
             {
                 playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_Captain"];
                 [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
             }
         }
        
        else if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
        {
            playercell.Img_wktkeeper.image=[UIImage imageNamed:@""];
            [playercell.Img_wktkeeper setBackgroundColor:[UIColor clearColor]];
            
        }
        
        else if([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])
        {
            playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
            [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
           // isSelectWKTKeeperType=YES;
        }
        
    }
     else{
         
         if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
         {
             
             playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_Captain"];
             [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
             
         }
         else
         {
             if([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])
             {
//                 playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
//                 [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
//                 objSelectPlayerRecord.isSelectWKTKeeper=@"YES";

             }
             else
             {
                playercell.Img_wktkeeper.image=[UIImage imageNamed:@""];
                [playercell.Img_wktkeeper setBackgroundColor:[UIColor clearColor]];
                 //objSelectPlayerRecord.isSelectWKTKeeper=nil;
             }
             
         }
        
     }
    
    playercell.Lbl_playerordernumber.text=[NSString stringWithFormat:@"%d",ordernumber];
    //ordernumber=[ intValue];
    
    if(ordernumber==12)
    {
        playercell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (12 Member)",objSelectPlayerRecord.playerName] ;
    }
    else if (ordernumber > 12)
    {
        playercell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (Sub)",objSelectPlayerRecord.playerName] ;
    }
    else if(ordernumber < 12)
    {
        playercell.lbl_playerName.text =[NSString stringWithFormat:@"%@",objSelectPlayerRecord.playerName] ;
    }
   
    playercell.shouldIndentWhileEditing = YES;
    playercell.showsReorderControl = YES;
    [playercell setEditing:self.isEditing];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     playercell.selectionStyle = UITableViewCellSelectionStyleNone;
    return playercell;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

{
    self.pseudoEdit = YES;
    
    
    [super setEditing:editing animated:animated];
}


-(IBAction)didClickDrag_BtnAction:(id)sender
{
    
    [self.tbl_playerSelectList setEditing:!playercell.editing animated:YES];
    
        //user has scrolled to the bottom
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   playercell = [tableView cellForRowAtIndexPath:indexPath];
   NSIndexPath * indexPaths = [_tbl_playerSelectList indexPathForCell:playercell];
   SelectPlayerRecord* objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPaths.row];
    //objCapitainWicketKeeper=(CapitainWicketKeeperRecord*)[capitainWicketkeeperarray objectAtIndex:0];
    int playerorder =[objSelectPlayerRecord.playerOrder intValue];
    
    if(playerorder < 12)
    {

    if(isSelectCaptainType==NO)
    {
                if([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])
        {
            
            playercell.IMg_captain.image=[UIImage imageNamed:@"Img_Captain"];
        
            [playercell.IMg_captain setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
             playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
            [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            
        }
        else
        {
            playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_Captain"];
            
            [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            
        }
        objSelectPlayerRecord.isSelectCapten=@"YES";
        isSelectCaptainType=YES;
        if([self.chooseTeam isEqualToString:@"SelectTeamA"])
        {
            objCapitainWicketKeeper.objTeamACapitain=objSelectPlayerRecord.playerCode;
            self.captainAcode =objSelectPlayerRecord.playerCode;
        }
        else if ([self.chooseTeam isEqualToString:@"SelectTeamB"])
        {
            objCapitainWicketKeeper.objTeamBCapitain=objSelectPlayerRecord.playerCode;
            self.captainBcode =objSelectPlayerRecord.playerCode;
        }
        }
        
    
    else{
        
       if(isSelectWKTKeeperType== NO)
        {
            
            if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
            {
                playercell.IMg_captain.image =[UIImage imageNamed:@"Img_Captain"];
                 playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
                [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
                [playercell.IMg_captain setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            }
            else{
               playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
                [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            }

             //objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
            objSelectPlayerRecord.isSelectWKTKeeper=@"YES";
           
            isSelectWKTKeeperType=YES;
            if([self.chooseTeam isEqualToString:@"SelectTeamA"])
            {
                objCapitainWicketKeeper.objTeamAWicketKeeper=objSelectPlayerRecord.playerCode;
                self.WKTkeeperAcode =objSelectPlayerRecord.playerCode;
            }
            else if ([self.chooseTeam isEqualToString:@"SelectTeamB"])
            {
                objCapitainWicketKeeper.objTeamBWicketKeeper=objSelectPlayerRecord.playerCode;
                self.WKTkeeperBcode =objSelectPlayerRecord.playerCode;
            }

        }
        }
}
    else
    {
        if(isSelectWKTKeeperType==NO)
        {
           [self AlterviewMethod:@"Please select Wicketkeeper from top 11 players"];
        }
        else if(isSelectCaptainType == YES)
        {
            [self AlterviewMethod:@"Please select Capitain from top 11 players"];
        }
    }
    }



-(IBAction)didClickCaptain_BtnAction:(id)sender
{
    
    PlayerLevelCell *Cell = (PlayerLevelCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_tbl_playerSelectList indexPathForCell:Cell];
    SelectPlayerRecord * objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];

    if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
    {
        Cell.IMg_captain.image=[UIImage imageNamed:@""];
        [Cell.IMg_captain setBackgroundColor:[UIColor clearColor]];
       // Cell.IMg_captain.frame=CGRectMake(Cell.contentView.frame.size.width-180, 15,50, 50);
       // Cell.Btn_Captain.frame=CGRectMake(Cell.contentView.frame.size.width-190, 15,50, 50);
        isSelectCaptainType=NO;
        objSelectPlayerRecord.isSelectCapten=nil;
        if([self.chooseTeam isEqualToString:@"SelectTeamA"])
        {
            objCapitainWicketKeeper.objTeamACapitain=nil;
            isCaptain=NO;
        }
        else if ([self.chooseTeam isEqualToString:@"SelectTeamB"])
        {
            objCapitainWicketKeeper.objTeamBCapitain=nil;
            isCaptain=NO;
        }
    }
    
}
-(IBAction)didClickWktKeeper_BtnAction:(id)sender
{
    PlayerLevelCell *Cell = (PlayerLevelCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_tbl_playerSelectList indexPathForCell:Cell];
    SelectPlayerRecord * objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
    if([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])
    {
        Cell.Img_wktkeeper.image=[UIImage imageNamed:@""];
        [Cell.Img_wktkeeper setBackgroundColor:[UIColor clearColor]];
        objSelectPlayerRecord.isSelectWKTKeeper=nil;
        
        isSelectWKTKeeperType=NO;
        if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
        {
            Cell.IMg_captain.image =[UIImage imageNamed:@""];
            [Cell.IMg_captain setBackgroundColor:[UIColor clearColor]];
           Cell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_Captain"];
            [Cell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            
            
        }
        else if([self.chooseTeam isEqualToString:@"SelectTeamA"])
        {
            objCapitainWicketKeeper.objTeamAWicketKeeper=nil;
            self.WKTkeeperAcode  = nil;
        }
        else if ([self.chooseTeam isEqualToString:@"SelectTeamB"])
        {
            objCapitainWicketKeeper.objTeamBWicketKeeper=nil;
             self.WKTkeeperBcode  = nil;
        }
    }
    else if ([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
    {
        if([self.chooseTeam isEqualToString:@"SelectTeamA"])
        {
            Cell.Img_wktkeeper.image=[UIImage imageNamed:@""];
            [Cell.Img_wktkeeper setBackgroundColor:[UIColor clearColor]];
            objSelectPlayerRecord.isSelectCapten=nil;
            
            isSelectCaptainType = NO;
            isCaptain=NO;
            self.captainAcode=nil;
        }
        else if ([self.chooseTeam isEqualToString:@"SelectTeamB"])
        {
            Cell.Img_wktkeeper.image=[UIImage imageNamed:@""];
            [Cell.Img_wktkeeper setBackgroundColor:[UIColor clearColor]];
            objSelectPlayerRecord.isSelectCapten=nil;
            
            isSelectCaptainType = NO;
            isCaptain=NO;
            self.captainBcode=nil;
        }
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.clipsToBounds = YES;
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
     NSInteger proposedDestination = proposedDestinationIndexPath.row;
    if (proposedDestination > 10)
    {
        return sourceIndexPath;
    }
    
   return proposedDestinationIndexPath;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    if(destRow > sourceRow)
    {
        isMoveBottom=YES;
    }
    else{
        isMoveBottom=NO;
    }
    NSString * changeIndexId=[NSString stringWithFormat:@"%ld",destRow+1];
    int newplayerorder =[changeIndexId intValue]-1;
    int orderno;
    SelectPlayerRecord*objRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:sourceRow];
    if(wickplayerlist.count > 0)
    {
    for(int i=0; i<wickplayerlist.count; i++)
    {
        SelectPlayerRecord*objWicket=(SelectPlayerRecord*)[wickplayerlist objectAtIndex:i];
        NSString * objStr =objWicket.playerCode;
        if(![objRecord.playerCode isEqualToString:objStr])
        {
            if(destRow < 11)
            {
                objRecord.playerOrder =changeIndexId;
                
                id object = [slecteplayerlist objectAtIndex:sourceRow];
                
                [slecteplayerlist removeObjectAtIndex:sourceRow];
                
                [slecteplayerlist insertObject:object atIndex:destRow];
                
//                for(int i=0; i < slecteplayerlist.count;i++)
//                {
//                    SelectPlayerRecord * objRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:i];
//                    if(newplayerorder > i)
//                    {
//                        
//                        if(i == 0)
//                        {
//                            orderno = [objRecord.playerOrder intValue];
//                            
//                        }
//                        
//                        else
//                        {
//                            //[objRecord.playerOrder intValue]-1;
//                            orderno = orderno+1;
//                        }
//                        
//                        
//                        objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
//                    }
//                    else if (orderno==[objRecord.playerOrder intValue])
//                    {
//                        orderno = orderno+1;
//                        
//                        objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
//                    }
//                    else if(sourceRow < i)
//                    {
//                        
//                    }
//               
//                
//                    [changeplayerorderArray addObject:objRecord];
//                }
                 [self changePlayerorder:newplayerorder :orderno :isMoveBottom];
//                slecteplayerlist=changeplayerorderArray;
                playercell.editing=NO;
                [self.tbl_playerSelectList setEditing:playercell.editing animated:YES];
                [self.tbl_playerSelectList reloadData];
            }
            else{
                [self tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:destinationIndexPath ];
            }
        }
        
    }
    
    }
    else
    {
        
        id object = [slecteplayerlist objectAtIndex:sourceRow];
        
        [slecteplayerlist removeObjectAtIndex:sourceRow];
        
        [slecteplayerlist insertObject:object atIndex:destRow];
         [self changePlayerorder:newplayerorder :newplayerorder :isMoveBottom];
        playercell.editing=NO;
        [self.tbl_playerSelectList setEditing:playercell.editing animated:YES];
        [self.tbl_playerSelectList reloadData];
    }
}

-(IBAction)Back_BtnAction:(id)sender
{
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ScoreEnginExit"]; 
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changePlayerorder:(int)newplayerorder :(int)changeorder :(BOOL)ismoveorder

{
    NSMutableArray * changeplayerorderArray =[[NSMutableArray alloc]init];
    int orderno;

    for(int i=0; i < slecteplayerlist.count;i++)
    {
        SelectPlayerRecord * objRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:i];
        if(ismoveorder==YES)
        {
        if(newplayerorder > i)
        {
            
            if([objRecord.playerOrder isEqualToString:@"0"])
            {
                orderno = [objRecord.playerOrder intValue];
                
            }
            
            else
            {
               orderno=[objRecord.playerOrder intValue]-1;
                //orderno = orderno-1;
            }
            
            
            objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
        }
        else if (changeorder == newplayerorder)
        {
            if(newplayerorder < i)
            {
                
                if([objRecord.playerOrder isEqualToString:@"0"])
                {
                    orderno = [objRecord.playerOrder intValue];
                    
                }
                
                else
                {
                    orderno=[objRecord.playerOrder intValue]+1;
                    //orderno = orderno-1;
                }
                
                
                objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
            }
            else
            {
            orderno = newplayerorder+1;
            
            objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
            }
        }
        }
        else if (ismoveorder==NO)
        {
            if(newplayerorder < i)
            {
                
                if([objRecord.playerOrder isEqualToString:@"0"])
                {
                    orderno = [objRecord.playerOrder intValue];
                    
                }
                
                else
                {
                    orderno=[objRecord.playerOrder intValue]+1;
                    //orderno = orderno-1;
                }
                
                
                objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
            }
            else if (newplayerorder == changeorder)
            {
                if(newplayerorder > i)
                {
                    
//                    if([objRecord.playerOrder isEqualToString:@"0"])
//                    {
//                        orderno = [objRecord.playerOrder intValue];
//                        
//                    }
//                    
//                    else
//                    {
//                        orderno=[objRecord.playerOrder intValue]-1;
//                        //orderno = orderno-1;
//                    }
                    
                    
//                    objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
                }
                else{
                orderno = newplayerorder+1;
                
                objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
                }
            }

        }
//        else if (orderno==[objRecord.playerOrder intValue])
//        {
//            orderno = orderno+1;
//            
//            objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
//        }
        else if (orderno == newplayerorder)
        {
            orderno = newplayerorder+1;
            
            objRecord.playerOrder=[ objRecord.playerOrder stringByReplacingOccurrencesOfString:objRecord.playerOrder withString:[NSString stringWithFormat:@"%d",orderno]];
        }
//        else if(sourceRow < i)
//        {
//            
//        }
       
        
        [changeplayerorderArray addObject:objRecord];
    }
     slecteplayerlist=changeplayerorderArray;

}

- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


@end
