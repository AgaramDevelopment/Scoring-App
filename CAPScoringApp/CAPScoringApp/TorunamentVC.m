//
//  TorunamentVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "TorunamentVC.h"
#import "DBManager.h"
#import "EventRecord.h"
#import "TossDetailsVC.h"
#import "FixturesVC.h"
#import "CustomNavigationVC.h"
#import "ArchivesVC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"
#import "DBMANAGERSYNC.h"
#import "DashBoardVC.h"
#import "ScorEnginVC.h"
@interface TorunamentVC ()
{
    BOOL isEnableTbl;
    NSMutableArray * selectindexarray;
    UIRefreshControl *refreshControl;
    int selectePosition;
    //NSMutableArray * FetchArchiveCompitionArray;
    DBManager *objDBManager;
    NSMutableArray * FetchCompitionArray;

   }
@property (nonatomic,strong)NSMutableArray*resultArray;
@property(nonatomic,weak) IBOutlet UIView *selectmatchTittleview;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@end
@implementation TorunamentVC
@synthesize resultArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    objDBManager = [[DBManager alloc]init];

    [self customnavigationmethod];
    // Do any additional setup after loading the view.
    [self.tableView setHidden:YES];
   // self.Nextbtn_outlet.enabled = NO;
    //[self didClickNextBtnAction setHidden:YES];
    [self.selectmatchTittleview .layer setBorderWidth:2.0];
    [self.selectmatchTittleview.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.selectmatchTittleview .layer setMasksToBounds:YES];
    
//    NSMutabl
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor greenColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView addSubview:refreshControl];
   

    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self startService:@"DONE"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userCode = [defaults objectForKey:@"userCode"];
    
    resultArray=[[NSMutableArray alloc]init];
    FetchCompitionArray =[[NSMutableArray alloc]init];
    
    if([self.selectDashBoard isEqualToString:@"Newmatch"])
    {
        FetchCompitionArray = [objDBManager RetrieveEventData:userCode];
    }
    else{
        FetchCompitionArray = [objDBManager RetrieveEventData1:userCode];
    }

    
    for(int i=0; i < [FetchCompitionArray count]; i++)
    {
        
        EventRecord *objEventRecord=(EventRecord*)[FetchCompitionArray objectAtIndex:i];
        NSLog(@"%@",objEventRecord.recordstatus);
        NSString *matchStatus=objEventRecord.recordstatus;
        if([matchStatus isEqualToString:@"MSC001"])
        {
            [resultArray addObject:objEventRecord];
        }
        //NSString * matchStatus=[FetchCompitionArray valueForKey:@""];
    }

    // Do your job, when done:
    [refreshControl endRefreshing];
}

-(void)customnavigationmethod
{
    CustomNavigationVC *objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"SELECT TOURNAMENT";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)Back_BtnAction:(id)sender
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ScoreEnginExit"]) {
        NSLog(@"yes");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ScoreEnginExit"];
        DashBoardVC*loginVC = [[DashBoardVC alloc]init];
        
        loginVC =  (DashBoardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
        //tournmentVc.selectDashBoard=selectType;
        [self.navigationController pushViewController:loginVC animated:YES];
        
    } else {
        NSLog(@"no");
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.selectmatchTittleview .layer setBorderWidth:2.0];
    [self.selectmatchTittleview.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.selectmatchTittleview .layer setMasksToBounds:YES];
    isEnableTbl=YES;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [resultArray count];    //count number of row from counting array hear cataGorry is An Array
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
    
    EventRecord *objEventRecord=(EventRecord*)[resultArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text =objEventRecord.competitionname;
   
    //cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectindexarray=[[NSMutableArray alloc]init];
    EventRecord *objEventRecord=(EventRecord*)[resultArray objectAtIndex:indexPath.row];
    self.selectMatchName.text =objEventRecord.competitionname;
    [selectindexarray addObject:objEventRecord];
    
    self.tableView.hidden=YES;
    isEnableTbl=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)Btn_touch:(id)sender {
    
    if(isEnableTbl==YES)
    {
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userCode = [defaults objectForKey:@"userCode"];
        
        
        resultArray=[[NSMutableArray alloc]init];
        FetchCompitionArray =[[NSMutableArray alloc]init];
        
        if([self.selectDashBoard isEqualToString:@"Newmatch"])
        {
            FetchCompitionArray = [objDBManager RetrieveEventData:userCode];
        }
        else{
            FetchCompitionArray = [objDBManager RetrieveEventData1:userCode];
        }
        
        
       // NSMutableArray * FetchCompitionArray =[objDBManager RetrieveEventData:userCode];
        for(int i=0; i < [FetchCompitionArray count]; i++)
        {
            
            EventRecord *objEventRecord=(EventRecord*)[FetchCompitionArray objectAtIndex:i];
            NSLog(@"%@",objEventRecord.recordstatus);
            NSString *matchStatus=objEventRecord.recordstatus;
            if([matchStatus isEqualToString:@"MSC001"])
            {
                [resultArray addObject:objEventRecord];
            }
            //NSString * matchStatus=[FetchCompitionArray valueForKey:@""];
        }
        
        for(int i=0; i < [resultArray count]; i++)
        {
            EventRecord *objEventRecord=(EventRecord*)[resultArray objectAtIndex:i];
            
            if([objEventRecord.competitionname isEqualToString:self.selectMatchName.text])
            {
                selectePosition= i;
            }
            
            
        }
        [self.tableView reloadData];
        if(selectePosition!=nil)
        {
           NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
          [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
          [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
             _tableView.sectionIndexBackgroundColor = [UIColor greenColor];
            UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:0];
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                              green:161/255.0
                                                               blue:79/255.0
                                                              alpha:0.5];
            cell.selectedBackgroundView =  customColorView;

        }
       
     
        
        
        self.tableView.hidden=NO;
        isEnableTbl=NO;
        CGFloat contensizeheight =self.tableView.contentSize.height;
        self.tableviewheight.constant =(contensizeheight>44)?200:contensizeheight;   //self.tableView.contentSize.height;
       // self.Nextbtn_outlet.enabled = YES;
    }
    else{
         self.tableView.hidden=YES;
        
         isEnableTbl=YES;
    }

}

-(IBAction)didClickNextBtnAction:(id)sender
{  if([self formValidation])
{
    if([self.selectDashBoard isEqualToString:@"Newmatch"])
    {
        FixturesVC*Fixvc = [[FixturesVC alloc]init];
    
        Fixvc =  (FixturesVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"fixtureSBID"];
        EventRecord *eventRecord = [selectindexarray objectAtIndex:0] ;
        Fixvc.CompitionCode=eventRecord.competitioncode;

        [self.navigationController pushViewController:Fixvc animated:YES];
    }
else{
        ArchivesVC * objArchiveVC=[[ArchivesVC alloc]init];
        objArchiveVC=(ArchivesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
    EventRecord *eventRecord = [selectindexarray objectAtIndex:0] ;
    objArchiveVC.CompitionCode=[eventRecord competitioncode];
        [self.navigationController pushViewController:objArchiveVC animated:YES];
    }
    
}}


- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}




-(void) startService:(NSString *)OPERATIONTYPE{
    if(self.checkInternetConnection){
        
              
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETACTIVECOMPETITION/%@",[Utitliy getSyncIPPORT],[Utitliy SecureId]];
            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            
            NSData *responseData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (responseData != nil) {
                DBMANAGERSYNC *objDBMANAGERSYNC = [[DBMANAGERSYNC alloc]init];
                NSDictionary *serviceResponse=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
              NSMutableArray *checkErrorItem=[serviceResponse objectForKey:@"lstErrorItem"];
                
                NSDictionary * ErrorNoDict =[checkErrorItem objectAtIndex:0];
                
                NSString *ErrorNoStr=[ErrorNoDict valueForKey:@"ErrorNo"];
                NSString *message=[ErrorNoDict valueForKey:@"DataItem"];
                NSString *CompareErrorno=@"MOB0005";
                if ([ErrorNoStr isEqualToString:CompareErrorno]) {
                    
                  //Cometititon
                    NSArray *temp =   [serviceResponse objectForKey:@"lstCompetition"];
                     int i;
                    for (i=0; i<[temp count]; i++) {
                        NSDictionary*test=[temp objectAtIndex:i];
                        NSString*COMPETITIONCODE=[test objectForKey:@"Competitioncode"];
                        NSString *COMPETITIONNAME=[test objectForKey:@"Competitionname"];
                        NSString *SEASON=[test objectForKey:@"Season"];
                        NSString *TROPHY=[test objectForKey:@"Trophy"];
                        NSString *STARTDATE=[test objectForKey:@"Startdate"];
                        NSString *ENDDATE=[test objectForKey:@"Enddate"];
                        NSString *MATCHTYPE=[test objectForKey:@"Matchtype"];
                        NSString *ISOTHERSMATCHTYPE=[test objectForKey:@"Isothersmatchtype"];
                        NSString*MANOFTHESERIESCODE=[test objectForKey:@"Manoftheseriescode"];
                        NSString*BESTBATSMANCODE =[test objectForKey:@"Bestbatsmancode"];
                        NSString*BESTBOWLERCODE=[test objectForKey:@"Bestbowlercode"];
                        NSString*BESTALLROUNDERCODE=[test objectForKey:@"Bestallroundercode"];
                        NSString*MOSTVALUABLEPLAYERCODE=[test objectForKey:@"Mostvaluableplayercode"];
                        NSString*RECORDSTATUS=[test objectForKey:@"Recordstatus"];
                        NSString*CREATEDBY=[test objectForKey:@"Createdby"];
                        NSString*CREATEDDATE=[test objectForKey:@"Createddate"];
                        NSString*MODIFIEDBY=[test objectForKey:@"Modifiedby"];
                        NSString*MODIFIEDDATE=[test objectForKey:@"Modifieddate"];
                        
                        
                        
                        
                        
                        bool CheckStatus=[objDBMANAGERSYNC CheckCompetitionCode:COMPETITIONCODE];
                        if (CheckStatus==YES) {
                            [objDBMANAGERSYNC UPDATECOMPETITION:COMPETITIONCODE: COMPETITIONNAME:SEASON: TROPHY:STARTDATE:ENDDATE:MATCHTYPE:ISOTHERSMATCHTYPE : MODIFIEDBY: MODIFIEDDATE];
                        }
                        
                        else
                        {
                            [objDBMANAGERSYNC  InsertMASTEREvents:COMPETITIONCODE:COMPETITIONNAME:SEASON:TROPHY:STARTDATE:ENDDATE:MATCHTYPE: ISOTHERSMATCHTYPE :MANOFTHESERIESCODE:BESTBATSMANCODE : BESTBOWLERCODE:BESTALLROUNDERCODE:MOSTVALUABLEPLAYERCODE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                            
                        }
                         }
                    
                    //  Competitionteamdetails
                    
                    NSArray *temp1 =   [serviceResponse objectForKey:@"Competitionteamdetails"];
                     int j;
                    for (j=0; j<[temp1 count]; j++) {
                        NSDictionary*test1=[temp1 objectAtIndex:j];
                        NSString*COMPETITIONTEAMCODE=[test1 objectForKey:@"Competitionteamcode"];
                        NSString *COMPETITIONCODE=[test1 objectForKey:@"Competitioncode"];
                        NSString *TEAMCODE=[test1 objectForKey:@"Teamcode"];
                        NSString *RECORDSTATUS=[test1 objectForKey:@"Recordstatus"];
                        
                        
                        bool CheckStatus1=[objDBMANAGERSYNC CheckCompetitionCodeTeamCode:COMPETITIONCODE:TEAMCODE];
                        if (CheckStatus1==NO) {
                            [objDBMANAGERSYNC  InsertCompetitionTeamDetails:COMPETITIONTEAMCODE:COMPETITIONCODE:TEAMCODE: RECORDSTATUS];
                        }
                else{ [objDBMANAGERSYNC DELETECompetitionCodeTeamCode:COMPETITIONCODE:TEAMCODE];
                    [objDBMANAGERSYNC  InsertCompetitionTeamDetails:COMPETITIONTEAMCODE:COMPETITIONCODE:TEAMCODE: RECORDSTATUS];
                        
                        }
                        
                    }
            
                }
            }
        });
        
        //[delegate hideLoading];
    }
}



- (BOOL) formValidation
{
    
    if([ self.selectMatchName.text isEqualToString:@"Select"] || self.selectMatchName.text==nil)
    {
        [self ShowAlterView:@"Please Select Any Tournament"];
        return NO;
    }
    return YES;
}


-(void)ShowAlterView:(NSString *) alterMsg
{
    UIAlertView *objAlter=[[UIAlertView alloc]initWithTitle:nil message:alterMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [objAlter show];
}
@end



