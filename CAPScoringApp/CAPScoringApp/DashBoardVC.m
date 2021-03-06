//
//  DashBoardVC.m
//  CAPScoringApp
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DashBoardVC.h"
#import "TorunamentVC.h"
#import "LoginVC.h"
#import "EndInnings.h"
#import "EndInningsVC.h"
#import "DBManager.h"
#import "DBMANAGERSYNC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"
#import "LoginDBmanager.h"
#import "FixtureAndResultsVC.h"

@interface DashBoardVC ()


@end

@implementation DashBoardVC

@synthesize checkErrorItem;
@synthesize CompitisionArray;
@synthesize Competitionteamdetailsarray;
@synthesize MatchRegistraionarray;
@synthesize MatchteamplayerdetailsArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"onlineSyn"])
    {
        [self.onlineenabledisable setOn:YES animated:YES];

    }
   else
    {
        [self.onlineenabledisable setOn:NO animated:YES];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_syn_Data:(id)sender {
    
    _img_synData.image = [UIImage imageNamed:@"ico-sync-data02.png"];
    
    _view_syn_data.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
     if(self.checkInternetConnection){
         AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
         
         //Show indicator
         [delegate showLoading];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSString *secureId = [defaults stringForKey:[Utitliy SecureId]];
        
             
    NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/PULLSCORERDATAFROMSERVER/%@",[Utitliy getSyncIPPORT],secureId];
    NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (responseData != nil) {
        DBMANAGERSYNC *objDBMANAGERSYNC = [[DBMANAGERSYNC alloc] init];
        NSDictionary *serviceResponse=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
       checkErrorItem=[serviceResponse objectForKey:@"lstErrorItem"];
        
        NSDictionary * ErrorNoDict =[checkErrorItem objectAtIndex:0];
        
        NSString *ErrorNoStr=[ErrorNoDict valueForKey:@"ErrorNo"];
         NSString *message=[ErrorNoDict valueForKey:@"DataItem"];
        NSString *CompareErrorno=@"MOB0005";
        if ([ErrorNoStr isEqualToString:CompareErrorno]) {
       
           //CompitisionArray=[serviceResponse objectForKey:@"Competition"];
    //Competition
           NSArray *temp =   [serviceResponse objectForKey:@"Competition"];
            [CompitisionArray removeAllObjects];
            CompitisionArray = [NSMutableArray new];
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
                        [objDBMANAGERSYNC UPDATECOMPETITION :COMPETITIONCODE: COMPETITIONNAME:SEASON: TROPHY:STARTDATE:ENDDATE:MATCHTYPE:ISOTHERSMATCHTYPE : MODIFIEDBY: MODIFIEDDATE];
                    }
                    
                    else
                    {
                        [objDBMANAGERSYNC  InsertMASTEREvents:COMPETITIONCODE:COMPETITIONNAME:SEASON:TROPHY:STARTDATE:ENDDATE:MATCHTYPE: ISOTHERSMATCHTYPE :MANOFTHESERIESCODE:BESTBATSMANCODE : BESTBOWLERCODE:BESTALLROUNDERCODE:MOSTVALUABLEPLAYERCODE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                    
                    }
                    
                    
                    
                 //   [CompitisionArray addObject:add];
                    
                    
               
                }
            
         //  Competitionteamdetails
            
            NSArray *temp1 =   [serviceResponse objectForKey:@"Competitionteamdetails"];
            [Competitionteamdetailsarray removeAllObjects];
            Competitionteamdetailsarray = [NSMutableArray new];
            int j;
            for (j=0; j<[temp1 count]; j++) {
                NSDictionary*test1=[temp1 objectAtIndex:j];
                NSString*COMPETITIONTEAMCODE=[test1 objectForKey:@"Competitionteamcode"];
                NSString *COMPETITIONCODE=[test1 objectForKey:@"Competitioncode"];
                NSString *TEAMCODE=[test1 objectForKey:@"Teamcode"];
                NSString *RECORDSTATUS=[test1 objectForKey:@"Recordstatus"];
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckCompetitionCodeTeamCode :COMPETITIONCODE:TEAMCODE];
                if (CheckStatus1==NO) {
                   [objDBMANAGERSYNC  InsertCompetitionTeamDetails:COMPETITIONTEAMCODE:COMPETITIONCODE:TEAMCODE: RECORDSTATUS];
                }
                
                else{ [objDBMANAGERSYNC DELETECompetitionCodeTeamCode :COMPETITIONCODE:TEAMCODE];
                    [objDBMANAGERSYNC  InsertCompetitionTeamDetails:COMPETITIONTEAMCODE:COMPETITIONCODE:TEAMCODE: RECORDSTATUS];
                    
                }

            
            }
            
            
            //scorerUserDetail
            
            
            NSArray *scorerUserDetailArray =   [serviceResponse objectForKey:@"scorerUserDetail"];
            
            
            for (int fa=0; fa<[scorerUserDetailArray count]; fa++) {
                NSDictionary*test21 =[scorerUserDetailArray objectAtIndex:fa];
                
                NSString *UserCode=[test21 objectForKey:@"UserCode"];
                NSString *UserRoleID=[test21 objectForKey:@"UserRoleID"];
                NSString *LoginID=[test21 objectForKey:@"LoginID"];
                NSString *Password=[test21 objectForKey:@"Password"];
                NSString *Rememberme=[test21 objectForKey:@"Rememberme"];
                NSString *RementDate=[test21 objectForKey:@"RementDate"];
                NSString *UserFullName=[test21 objectForKey:@"UserFullName"];
                NSString *MachineID=[test21 objectForKey:@"MachineID"];
                NSString*LicenseUpTo=[test21 objectForKey:@"LicenseUpTo"];
                NSString *Recordstatus=[test21 objectForKey:@"Recordstatus"];
                NSString *Createdby=[test21 objectForKey:@"Createdby"];
                NSString *Createddate=[test21 objectForKey:@"Createddate"];
                NSString*Modifiedby=[test21 objectForKey:@"Modifiedby"];
                NSString*Modifieddate=[test21 objectForKey:@"Modifieddate"];
                
                LoginDBmanager *objLoginDBmanager = [[LoginDBmanager alloc] init];
                bool CheckStatus= [objLoginDBmanager CheckUserScorerDetails:UserCode];
                if (CheckStatus==YES)
                {
                    [objLoginDBmanager UpdateUserScorerDetails:UserCode :UserRoleID :LoginID :Password :Rememberme :RementDate :UserFullName :MachineID:LicenseUpTo :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                }
                
                else
                {
                    [objLoginDBmanager InsertUserScorerDetails:UserCode :UserRoleID :LoginID :Password :Rememberme :RementDate :UserFullName :MachineID:LicenseUpTo :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    
                }
                
                
            }
            
            
          //Competitionteamplayer
            
            
            NSArray *temp2 =   [serviceResponse objectForKey:@"Competitionteamplayer"];
            [Competitionteamdetailsarray removeAllObjects];
            Competitionteamdetailsarray = [NSMutableArray new];
            int k;
            for (k=0; k<[temp2 count]; k++) {
                NSDictionary*test2=[temp2 objectAtIndex:k];
                NSString*COMPETITIONCODE=[test2 objectForKey:@"Competitioncode"];
                NSString *TEAMCODE=[test2 objectForKey:@"Teamcode"];
                NSString *PLAYERCODE=[test2 objectForKey:@"Playercode"];
                NSString *RECORDSTATUS=[test2 objectForKey:@"Recordstatus"];
                NSString*CREATEDBY=[test2 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test2 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test2 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test2 objectForKey:@"Modifieddate"];
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckCompetitionteamplayer:COMPETITIONCODE :TEAMCODE :PLAYERCODE];
                if (CheckStatus1==NO) {
                 [objDBMANAGERSYNC  InsertCompetitionTeamPlayer:COMPETITIONCODE:TEAMCODE:PLAYERCODE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
                
             
            }
            
            
            
     //Matchregistration
            
            NSArray *temp3 =   [serviceResponse objectForKey:@"Matchregistration"];
            [MatchRegistraionarray removeAllObjects];
            MatchRegistraionarray = [NSMutableArray new];
            int l;
            for (l=0; l<[temp3 count]; l++) {
          NSDictionary*test3=[temp3 objectAtIndex:l];
                NSString*MATCHCODE=[test3 objectForKey:@"Matchcode"];
                NSString *MATCHNAME=[test3 objectForKey:@"Matchname"];
                NSString *COMPETITIONCODE=[test3 objectForKey:@"Competitioncode"];
                NSString *MATCHOVERS=[test3 objectForKey:@"Matchovers"];
                NSString*MATCHOVERCOMMENTS=[test3 objectForKey:@"Matchovercomments"];
                NSString *MATCHDATE1=[test3 objectForKey:@"Matchdate"];
                
                NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
             //   6/23/2016 5:45:00 PM
                [dateFmt setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
                NSDate *date = [dateFmt dateFromString:MATCHDATE1];
                NSLog(@"date:",date);
                
                [dateFmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSString *MATCHDATE = [dateFmt stringFromDate:date];
                NSLog(@"dateString:",MATCHDATE);
                
                NSString *ISDAYNIGHT=[test3 objectForKey:@"Isdaynight"];
                NSString *ISNEUTRALVENUE=[test3 objectForKey:@"Isneutralvenue"];
                NSString*GROUNDCODE=[test3 objectForKey:@"Groundcode"];
                NSString *TEAMACODE=[test3 objectForKey:@"Teamacode"];
                NSString *TEAMBCODE=[test3 objectForKey:@"Teambcode"];
                NSString *TEAMACAPTAIN=[test3 objectForKey:@"Teamacaptain"];
                NSString *TEAMBCAPTAIN=[test3 objectForKey:@"Teambcaptain"];
                NSString*TEAMAWICKETKEEPER=[test3 objectForKey:@"Teamawicketkeeper"];
                NSString *TEAMBWICKETKEEPER=[test3 objectForKey:@"Teambwicketkeeper"];
                NSString *UMPIRE1CODE=[test3 objectForKey:@"Umpire1code"];
                NSString *UMPIRE2CODE=[test3 objectForKey:@"Umpire2code"];
                NSString*UMPIRE3CODE=[test3 objectForKey:@"Umpire3code"];
                NSString *MATCHREFEREECODE=[test3 objectForKey:@"Matchrefereecode"];
                NSString *MATCHRESULT=[test3 objectForKey:@"Matchresult"];
                NSString *MATCHRESULTTEAMCODE=[test3 objectForKey:@"Matchresultteamcode"];
                NSString*TEAMAPOINTS=[test3 objectForKey:@"Teamapoints"];
                NSString *TEAMBPOINTS=[test3 objectForKey:@"Teambpoints"];
                NSString *MATCHSTATUS=[test3 objectForKey:@"Matchstatus"];
                NSString *RECORDSTATUS=[test3 objectForKey:@"Recordstatus"];
                NSString*CREATEDBY=[test3 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test3 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test3 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test3 objectForKey:@"Modifieddate"];
                NSString*ISDEFAULTORLASTINSTANCE=[test3 objectForKey:@"Isdefaultorlastinstance"];
             //   NSString *RELATIVEVIDEOLOCATION=[test3 objectForKey:@"Relativevideolocation"];
              
                
                
               
                 bool CheckStatus2=[objDBMANAGERSYNC CheckAlreadySyncMatchregistration:MATCHCODE];
                if (CheckStatus2==NO) {
                   bool CheckStatus1=[objDBMANAGERSYNC Matchregistration:MATCHCODE];
               
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC UpdateMatchregistration:MATCHCODE:MATCHNAME:COMPETITIONCODE:MATCHOVERS:MATCHOVERCOMMENTS:MATCHDATE:ISDAYNIGHT:ISNEUTRALVENUE:GROUNDCODE:TEAMACODE:TEAMBCODE:TEAMACAPTAIN:TEAMAWICKETKEEPER:TEAMBCAPTAIN:TEAMBWICKETKEEPER:UMPIRE1CODE:UMPIRE2CODE:UMPIRE3CODE:MATCHREFEREECODE:MATCHRESULT:MATCHRESULTTEAMCODE:TEAMAPOINTS:TEAMBPOINTS:MATCHSTATUS: RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:ISDEFAULTORLASTINSTANCE];
                }
                else{
                    [objDBMANAGERSYNC InsertMatchregistration:MATCHCODE: MATCHNAME:COMPETITIONCODE:MATCHOVERS: MATCHOVERCOMMENTS:MATCHDATE:ISDAYNIGHT: ISNEUTRALVENUE: GROUNDCODE:TEAMACODE:TEAMBCODE:TEAMACAPTAIN:TEAMAWICKETKEEPER:TEAMBCAPTAIN:TEAMBWICKETKEEPER: UMPIRE1CODE: UMPIRE2CODE:UMPIRE3CODE:MATCHREFEREECODE:MATCHRESULT: MATCHRESULTTEAMCODE: TEAMAPOINTS:TEAMBPOINTS:MATCHSTATUS:RECORDSTATUS:CREATEDBY:CREATEDDATE: MODIFIEDBY:MODIFIEDDATE:ISDEFAULTORLASTINSTANCE];
                }
                }
                
            }
            
//  Matchteamplayerdetails
            
            NSArray *temp4 =   [serviceResponse objectForKey:@"Matchteamplayerdetails"];
            [MatchteamplayerdetailsArray removeAllObjects];
            MatchteamplayerdetailsArray = [NSMutableArray new];
            int M;
            for (M=0; M<[temp4 count]; M++) {
                NSDictionary*test4=[temp4 objectAtIndex:M];
                NSString*MATCHTEAMPLAYERCODE=[test4 objectForKey:@"Matchteamplayercode"];
                NSString *MATCHCODE=[test4 objectForKey:@"Matchcode"];
                NSString *TEAMCODE=[test4 objectForKey:@"Teamcode"];
                NSString *PLAYERCODE=[test4 objectForKey:@"Playercode"];
                NSString*PLAYINGORDER=[test4 objectForKey:@"Playingorder"];
                NSString *RECORDSTATUS=[test4 objectForKey:@"Recordstatus"];
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckMatchteamplayerdetails :MATCHCODE :TEAMCODE :PLAYERCODE];
                if (CheckStatus1==NO) {
                  [objDBMANAGERSYNC InsertMatchteamplayerdetails:MATCHTEAMPLAYERCODE:MATCHCODE:TEAMCODE:PLAYERCODE:PLAYINGORDER:RECORDSTATUS];
                }
                
                
                          }
            
            
            //Match Scorer Details
            
            NSArray *matchScorerDetailsArray =   [serviceResponse objectForKey:@"Matchscorerdetails"];
            
            
            for (int k=0; k<[matchScorerDetailsArray count]; k++) {
                NSDictionary*test1 =[matchScorerDetailsArray objectAtIndex:k];
                
                NSString *Competitioncode=[test1 objectForKey:@"Competitioncode"];
                NSString *Matchcode=[test1 objectForKey:@"Matchcode"];
                NSString *Scorercode=[test1 objectForKey:@"Scorercode"];
                NSString *Recordstatus=[test1 objectForKey:@"Recordstatus"];
                NSString *Createdby=[test1 objectForKey:@"Createdby"];
                NSString *Createddate=[test1 objectForKey:@"Createddate"];
                NSString *Modifiedby=[test1 objectForKey:@"Modifiedby"];
                NSString*Modifieddate=[test1 objectForKey:@"Modifieddate"];
                
                
                
                LoginDBmanager *objLoginDBmanager = [[LoginDBmanager alloc] init];
                bool CheckStatus= [objLoginDBmanager CheckMatchScorerDetails:Competitioncode :Matchcode :Scorercode ];
                if (CheckStatus==YES)
                {
                    [objLoginDBmanager UpdateMatchScorerDetails:Competitioncode :Matchcode :Scorercode :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                }
                
                else
                {
                    [objLoginDBmanager InsertMatchScorerDetails:Competitioncode :Matchcode :Scorercode :Recordstatus :Createdby :Createddate :Modifiedby :Modifieddate];
                    
                    
                }
                
                
            }
            
            
            
            
   //TeamMaster
            
            NSArray *temp5 =   [serviceResponse objectForKey:@"Teammaster"];
         [MatchteamplayerdetailsArray removeAllObjects];
          MatchteamplayerdetailsArray = [NSMutableArray new];
            int N;
            for (N=0; N<[temp5 count]; N++) {
                NSDictionary*test5=[temp5 objectAtIndex:N];
                NSString*TEAMCODE=[test5 objectForKey:@"Teamcode"];
                NSString *TEAMNAME=[test5 objectForKey:@"Teamname"];
                NSString *SHORTTEAMNAME=[test5 objectForKey:@"Shortteamname"];
                NSString *TEAMTYPE=[test5 objectForKey:@"Teamtype"];
                NSString*TEAMLOGO=[test5 objectForKey:@"Teamlogo"];
                NSString *RECORDSTATUS=[test5 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test5 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test5 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test5 objectForKey:@"Modifiedby"];
                NSString*MODIFIEDDATE=[test5 objectForKey:@"Modifieddate"];
               
                
                
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckTeamMaster:TEAMCODE];
                if (CheckStatus1==YES) {
                    
                    [objDBMANAGERSYNC UpdateTeamMaster :TEAMNAME:SHORTTEAMNAME:TEAMTYPE:TEAMLOGO:RECORDSTATUS: MODIFIEDBY:MODIFIEDDATE:TEAMCODE];

                }
                else{
                      [objDBMANAGERSYNC InsertTeamMaster :TEAMCODE:TEAMNAME:SHORTTEAMNAME:TEAMTYPE:TEAMLOGO: RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
                
            }

            
//Playermaster
            
            NSArray *temp6 =   [serviceResponse objectForKey:@"Playermaster"];
            [MatchteamplayerdetailsArray removeAllObjects];
            MatchteamplayerdetailsArray = [NSMutableArray new];
            int p;
            for (p=0; p<[temp6 count]; p++) {
                NSDictionary*test6=[temp6 objectAtIndex:p];
                NSString*PLAYERCODE=[test6 objectForKey:@"Playercode"];
                NSString *PLAYERNAME=[test6 objectForKey:@"Playername"];
                NSString *PLAYERDOB=[test6 objectForKey:@"Playerdob"];
             NSString *PLAYERPHOTO=[test6 objectForKey:@"Playerphoto"];
                // NSData *bytes = [PLAYERPHOTO dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString*BATTINGSTYLE=[test6 objectForKey:@"Battingstyle"];
                NSString *BATTINGORDER=[test6 objectForKey:@"Battingorder"];
                NSString *BOWLINGSTYLE=[test6 objectForKey:@"Bowlingstyle"];
                NSString *BOWLINGTYPE=[test6 objectForKey:@"Bowlingtype"];
                NSString *BOWLINGSPECIALIZATION=[test6 objectForKey:@"Bowlingspecialization"];
                NSString*PLAYERROLE=[test6 objectForKey:@"Playerrole"];
                NSString*PLAYERREMARKS=[test6 objectForKey:@"Playerremarks"];
                NSString *RECORDSTATUS=[test6 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test6 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test6 objectForKey:@"Createddate"];
                NSString*MODIFIEDBY=[test6 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test6 objectForKey:@"Modifieddate"];
                NSString *BALLTYPECODE=[test6 objectForKey:@"Balltypecode"];
                NSString *SHOTTYPE=[test6 objectForKey:@"Shottype"];
                NSString *SHOTCODE=[test6 objectForKey:@"Shotcode"];
                NSString*PMLENGTHCODE=[test6 objectForKey:@"Pmlengthcode"];
                NSString*PMLINECODE=[test6 objectForKey:@"Pmlinecode"];
                NSString *PMXVALUE=[test6 objectForKey:@"Pmxvalue"];
                NSString *PMYVALUE=[test6 objectForKey:@"Pmyvalue"];
                NSString *ATWOROTW=[test6 objectForKey:@"Atworotw"];
                
                
             
                
                
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckPlayermaster :PLAYERCODE];
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC UpdatePlayermaster:PLAYERCODE:PLAYERNAME:PLAYERDOB:PLAYERPHOTO: BATTINGSTYLE: BATTINGORDER: BOWLINGSTYLE:BOWLINGTYPE:BOWLINGSPECIALIZATION:PLAYERROLE: PLAYERREMARKS: RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:BALLTYPECODE:SHOTTYPE: SHOTCODE:PMLENGTHCODE:PMLINECODE:PMXVALUE:PMYVALUE:ATWOROTW];
               }
                else{
                    [objDBMANAGERSYNC InsertPlayermaster:PLAYERCODE:PLAYERNAME:PLAYERDOB:PLAYERPHOTO:BATTINGSTYLE:BATTINGORDER:BOWLINGSTYLE:BOWLINGTYPE:BOWLINGSPECIALIZATION:PLAYERROLE:PLAYERREMARKS: RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:BALLTYPECODE:SHOTTYPE:SHOTCODE:PMLENGTHCODE:PMLINECODE:PMXVALUE:PMYVALUE:ATWOROTW];
                }
                
                
            }
            
            
            
            
            
            
          //Playerteamdetails
            NSArray *temp7 =   [serviceResponse objectForKey:@"Playerteamdetails"];
            [MatchteamplayerdetailsArray removeAllObjects];
            MatchteamplayerdetailsArray = [NSMutableArray new];
            int f;
            for (f=0; f<[temp7 count]; f++) {
                NSDictionary*test7=[temp7 objectAtIndex:f];
                NSString*PLAYERCODE=[test7 objectForKey:@"Playercode"];
                NSString *TEAMCODE=[test7 objectForKey:@"Teamcode"];
                NSString *RECORDSTATUS=[test7 objectForKey:@"Recordstatus"];
                
                  bool CheckStatus1=[objDBMANAGERSYNC CheckPlayerTeamDetails :PLAYERCODE :TEAMCODE];
                
                if (CheckStatus1==YES) {
                 [objDBMANAGERSYNC  UpdatePlayerTeamDetails :PLAYERCODE:TEAMCODE:RECORDSTATUS];
                }
                else{
                    [objDBMANAGERSYNC InsertPlayerTeamDetails :PLAYERCODE:TEAMCODE:RECORDSTATUS];
                }

            }
            
            
            // Officialsmaster
            
            
            
            NSArray *temp8 =   [serviceResponse objectForKey:@"Officialsmaster"];
         
            int h;
            for (h=0; h<[temp8 count]; h++) {
                NSDictionary*test8=[temp8 objectAtIndex:h];
                NSString*OFFICIALSCODE=[test8 objectForKey:@"Officialscode"];
                NSString *NAME=[test8 objectForKey:@"Name"];
                NSString *ROLE=[test8 objectForKey:@"Role"];
                NSString *COUNTRY=[test8 objectForKey:@"Country"];
                NSString *STATE=[test8 objectForKey:@"State"];
                NSString *CATEGORY=[test8 objectForKey:@"Category"];
//                NSString *RECORDSTATUS=[test8 objectForKey:@"Officialsphoto"];
                NSString *RECORDSTATUS=[test8 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test8 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test8 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test8 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test8 objectForKey:@"Modifieddate"];
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckOfficialsmaster:OFFICIALSCODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdateOfficialsmaster:OFFICIALSCODE:NAME:ROLE:COUNTRY:STATE:CATEGORY:OFFICIALSCODE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                else{
                    [objDBMANAGERSYNC InsertOfficialsmaster:OFFICIALSCODE:NAME:ROLE:COUNTRY:STATE:CATEGORY:OFFICIALSCODE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
            }

          
            
            //Coachmaster
            
            
            NSArray *temp9 =   [serviceResponse objectForKey:@"Coachmaster"];
            
            int b;
            for (b=0; b<[temp9 count]; b++) {
                NSDictionary*test9=[temp9 objectAtIndex:b];
                NSString*COACHCODE=[test9 objectForKey:@"Coachcode"];
                NSString *COACHNAME=[test9 objectForKey:@"Coachname"];
                NSString *COACHTEAMCODE=[test9 objectForKey:@"Coachteamcode"];
                NSString *COACHSPECIALIZATION=[test9 objectForKey:@"Coachspecialization"];
                NSString *COACHPHOTO=[test9 objectForKey:@"Coachphoto"];
                NSString *RECORDSTATUS=[test9 objectForKey:@"Recordstatus"];
                //                NSString *RECORDSTATUS=[test8 objectForKey:@"Officialsphoto"];
                NSString *CREATEDBY=[test9 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test9 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test9 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test9 objectForKey:@"Modifieddate"];
               
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckCoachmaster:COACHCODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdateCoachmaster:COACHCODE:COACHNAME:COACHTEAMCODE:COACHSPECIALIZATION:COACHPHOTO:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                else{
                    [objDBMANAGERSYNC InsertCoachmaster:COACHCODE:COACHNAME:COACHTEAMCODE:COACHSPECIALIZATION:COACHPHOTO:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
            }

            //Groundmaster
            
           NSArray *temp10 =   [serviceResponse objectForKey:@"Groundmaster"];
            
            int D;
            for (D=0; D<[temp10 count]; D++) {
                NSDictionary*test10=[temp10 objectAtIndex:D];
                NSString*GROUNDCODE=[test10 objectForKey:@"Groundcode"];
                NSString *GROUNDNAME=[test10 objectForKey:@"Groundname"];
                NSString *COUNTRY=[test10 objectForKey:@"Country"];
                NSString *STATE=[test10 objectForKey:@"State"];
                NSString *CITY=[test10 objectForKey:@"City"];
                NSString *GROUNDPROFILE=[test10 objectForKey:@"Groundprofile"];
                //                NSString *GROUNDIMAGE=[test8 objectForKey:@"Groundimage"];
                NSString *GSTOPLEFT=[test10 objectForKey:@"Gstopleft"];
                NSString *GSTOPRIGHT=[test10 objectForKey:@"Gstopright"];
                NSString *GSBOTTOMLEFT=[test10 objectForKey:@"Gsbottomleft"];
                NSString *GSBOTTOMRIGHT=[test10 objectForKey:@"Gsbottomright"];
                NSString*RECORDSTATUS=[test10 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test10 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test10 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test10 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test10 objectForKey:@"Modifieddate"];
                
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckGroundmaster:GROUNDCODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdateGroundmaster:GROUNDCODE:GROUNDNAME:COUNTRY:STATE:CITY:GROUNDPROFILE:GSTOPLEFT:GSTOPRIGHT:GSBOTTOMLEFT:GSBOTTOMRIGHT:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                else{
                    [objDBMANAGERSYNC InsertGroundmaster:GROUNDCODE:GROUNDNAME:COUNTRY:STATE:CITY:GROUNDPROFILE:GSTOPLEFT:GSTOPRIGHT:GSBOTTOMLEFT:GSBOTTOMRIGHT:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
            }
            
            
            //Shottype
            
            NSArray *temp11 =   [serviceResponse objectForKey:@"Shottype"];
            
            int V;
            for (V=0; V<[temp11 count]; V++) {
                NSDictionary*test11=[temp11 objectAtIndex:V];
                NSString*SHOTCODE=[test11 objectForKey:@"Shotcode"];
                NSString *SHOTNAME=[test11 objectForKey:@"Shotname"];
                NSString *SHOTTYPE=[test11 objectForKey:@"ShottypeS"];
                NSString *DISPLAYORDER=[test11 objectForKey:@"Displayorder"];
                NSString *RECORDSTATUS=[test11 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test11 objectForKey:@"Createdby"];
               NSString *CREATEDDATE=[test11 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test11 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test11 objectForKey:@"Modifieddate"];
           
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckShottype:SHOTCODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdateShottype:SHOTCODE:SHOTNAME:SHOTTYPE:DISPLAYORDER:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                else{
                    [objDBMANAGERSYNC InsertShottype:SHOTCODE:SHOTNAME:SHOTTYPE:DISPLAYORDER:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
            }
            
         //Bowltype
            
            
            NSArray *temp12 =   [serviceResponse objectForKey:@"Bowltype"];
            
            int X;
            for (X=0; X<[temp12 count]; X++) {
                NSDictionary*test12=[temp12 objectAtIndex:X];
                NSString*BOWLTYPECODE=[test12 objectForKey:@"Bowltypecode"];
                NSString *BOWLTYPE=[test12 objectForKey:@"BowltypeS"];
                NSString *BOWLERTYPE=[test12 objectForKey:@"Bowlertype"];
                NSString *DISPLAYORDER=[test12 objectForKey:@"Displayorder"];
                NSString *RECORDSTATUS=[test12 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test12 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test12 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test12 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test12 objectForKey:@"Modifieddate"];
                
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckBowltype:BOWLTYPECODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdateBowltype:BOWLTYPECODE:BOWLTYPE:BOWLERTYPE:DISPLAYORDER:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                else{
                    [objDBMANAGERSYNC InsertBowltype:BOWLTYPECODE:BOWLTYPE:BOWLERTYPE:DISPLAYORDER:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
            }

            
          //Bowlerspecialization
            
            
            NSArray *temp13=   [serviceResponse objectForKey:@"Bowlerspecialization"];
            
            int R;
            for (R=0; R<[temp13 count]; R++) {
                NSDictionary*test13=[temp13 objectAtIndex:R];
                NSString*BOWLERSPECIALIZATIONCODE=[test13 objectForKey:@"Bowlerspecializationcode"];
                NSString *BOWLERSPECIALIZATION=[test13 objectForKey:@"BowlerspecializationS"];
                NSString *BOWLERSTYLE=[test13 objectForKey:@"Bowlerstyle"];
                NSString *BOWLERTYPE=[test13 objectForKey:@"Bowlertype"];
                NSString *RECORDSTATUS=[test13 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test13 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test13 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test13 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test13 objectForKey:@"Modifieddate"];
                
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckBowlerspecialization:BOWLERSPECIALIZATIONCODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdateBowltype:BOWLERSPECIALIZATIONCODE:BOWLERSPECIALIZATION:BOWLERSTYLE:BOWLERTYPE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                else{
                    [objDBMANAGERSYNC InsertBowltype:BOWLERSPECIALIZATIONCODE:BOWLERSPECIALIZATION:BOWLERSTYLE:BOWLERTYPE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
            }

            
            
          //Fieldingfactor
            
            
            NSArray *temp14=   [serviceResponse objectForKey:@"Fieldingfactor"];
            
            int Q;
            for (Q=0; Q<[temp14 count]; Q++) {
                NSDictionary*test14=[temp14 objectAtIndex:Q];
                NSString*FIELDINGFACTORCODE=[test14 objectForKey:@"Fieldingfactorcode"];
                NSString *FIELDINGFACTOR=[test14 objectForKey:@"FieldingfactorS"];
                NSString *DISPLAYORDER=[test14 objectForKey:@"Displayorder"];
                NSString *RECORDSTATUS=[test14 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test14 objectForKey:@"Createdby"];
              NSString *CREATEDDATE=[test14 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test14 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test14 objectForKey:@"Modifieddate"];
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckFieldingfactor:FIELDINGFACTORCODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdateFieldingfactor:FIELDINGFACTORCODE:FIELDINGFACTOR:DISPLAYORDER:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                else{
                    [objDBMANAGERSYNC InsertFieldingfactor:FIELDINGFACTORCODE:FIELDINGFACTOR:DISPLAYORDER:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                }
                
            }
            
            
            //MetaData
            
            NSArray *temp15=   [serviceResponse objectForKey:@"Metadata"];
            
            int B;
            for (B=0; B<[temp15 count]; B++) {
                NSDictionary*test15=[temp15 objectAtIndex:B];
                NSString*METASUBCODE=[test15 objectForKey:@"Metasubcode"];
                NSString *METADATATYPECODE=[test15 objectForKey:@"Metadatatypecode"];
                NSString *METADATATYPEDESCRIPTION=[test15 objectForKey:@"Metadatatypedescription"];
                NSString *METASUBCODEDESCRIPTION=[test15 objectForKey:@"Metasubcodedescription"];
              
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckMetaData:METASUBCODE];
                
                if (CheckStatus1==NO) {
                      [objDBMANAGERSYNC InsertMetaData:METASUBCODE:METADATATYPECODE:METADATATYPEDESCRIPTION:METASUBCODEDESCRIPTION];
                }

                
            }

            
       //PowerplayType
            NSArray *temp16=   [serviceResponse objectForKey:@"PowerplayType"];
            
            int G;
            for (G=0; G<[temp16 count]; G++) {
                NSDictionary*test16=[temp16 objectAtIndex:G];
                NSString*POWERPLAYTYPECODE=[test16 objectForKey:@"Powerplaytypecode"];
                NSString *POWERPLAYTYPENAME=[test16 objectForKey:@"Powerplaytypename"];
                NSString *RECORDSTATUS=[test16 objectForKey:@"Recordstatus"];
                NSString *CREATEDBY=[test16 objectForKey:@"Createdby"];
                NSString *CREATEDDATE=[test16 objectForKey:@"Createddate"];
                NSString *MODIFIEDBY=[test16 objectForKey:@"Modifiedby"];
                NSString *MODIFIEDDATE=[test16 objectForKey:@"Modifieddate"];
                NSString *ISSYSTEMREFERENCE=[test16 objectForKey:@"Issystemreference"];
                
                
                bool CheckStatus1=[objDBMANAGERSYNC CheckPowerplayType:POWERPLAYTYPECODE];
                
                if (CheckStatus1==YES) {
                    [objDBMANAGERSYNC  UpdatePowerplayType:POWERPLAYTYPECODE:POWERPLAYTYPENAME:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:ISSYSTEMREFERENCE];
                }
                else{
                    [objDBMANAGERSYNC InsertPowerplayType:POWERPLAYTYPECODE:POWERPLAYTYPENAME:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE:ISSYSTEMREFERENCE];
                }
                
            }

            
            
            
            [self playercodeimage];
            [self teamCodeImage];
            //[self officialcodeimage];
            //[self groundcodeimage];
            
        [self showDialog1:@"SYNC DATA COMPLETED" andTitle:@"DashBoard"];
            
            }
            
     
            
        
        else
        {
    
    
       
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"DashBoard"
                                  message:@"Failed"
                                  delegate:nil //or self
                                  cancelButtonTitle:@"Failed"
                                  otherButtonTitles:nil];
            
            [alert show];
    
    }
    
    
    }        [delegate hideLoading];
         });
    
     }
    
     else{
          [self showDialog:@"Network Error" andTitle:@"DashBoard"];
     }
    
}

-(void) showDialog1:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alertDialog show];
}


-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}


- (IBAction)btn_new_Match:(id)sender {
    
    _img_newMatch.image = [UIImage imageNamed:@"ico-new-mach02.png"];
    
    _view_new_Match.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    _img_synData.image = [UIImage imageNamed:@"ico-sync-data01.png"];
    _view_syn_data.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:(0.3f)];
    
    [self tournmentView:@"Newmatch"];
}

- (IBAction)btn_archives:(id)sender {
    
    _img_archives.image = [UIImage imageNamed:@"ico-archives02.png"];
    _view_archives.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
     [self tournmentView:@"Archives"];


}

- (IBAction)btn_reports:(id)sender {

    _img_reports.image = [UIImage imageNamed:@"ico-reports02.png"];
    
    _view_reports.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    FixtureAndResultsVC*TETS =  (FixtureAndResultsVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"FixtureAndResultsVC"];
    //TETS.selectDashBoard=selectType;
    [self.navigationController pushViewController:TETS animated:YES];
    
}

-(IBAction)didClicksynenableanddisable:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
        
       // [self.btn_synenableanddisable setImage:[UIImage imageNamed:@"syn_disable_img"] forState:UIControlStateNormal];
        //self.btn_synenableanddisable.titleLabel.textColor =[UIColor colorWithRed:(204/255.0f) green:(204/255.0f) blue:(204/255.0f) alpha:(1.0)];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"onlineSyn"];
        [delegate SynenableanddisbleMethod];
    } else{
        NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"onlineSyn"];
        
       // self.btn_synenableanddisable.titleLabel.textColor =[UIColor colorWithRed:(24/255.0f) green:(162/255.0f) blue:(84/255.0f) alpha:(1)];
        
        [delegate SynenableanddisbleMethod];
    }
    
    
  //  if([self.btn_synenableanddisable.currentImage isEqual:[UIImage imageNamed:@"syn_enable_img"]])
    //{
    // [self.btn_synenableanddisable setImage:[UIImage imageNamed:@"syn_disable_img"] forState:UIControlStateNormal];
    //    self.btn_synenableanddisable.titleLabel.textColor =[UIColor colorWithRed:(204/255.0f) green:(204/255.0f) blue:(204/255.0f) alpha:(1.0)];
        
     //   [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"onlineSyn"];
     //   [delegate SynenableanddisbleMethod];
   // }
    //else {
     //   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"onlineSyn"];

     //   [self.btn_synenableanddisable setImage:[UIImage imageNamed:@"syn_enable_img"] forState:UIControlStateNormal];
      //  self.btn_synenableanddisable.titleLabel.textColor =[UIColor colorWithRed:(24/255.0f) green:(162/255.0f) blue:(84/255.0f) alpha:(1)];

     //   [delegate SynenableanddisbleMethod];
        
    //}
}

- (IBAction)btn_signOut:(id)sender {
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"DashBoard"
                                                   message: @"Are You Sure Want to Signout?"
                                                  delegate: self
                                         cancelButtonTitle:@"Signout"
                                         otherButtonTitles:@"Cancel",nil];
    
    
    [alert show];
   alert.tag =1;
    
    


    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if (alertView.tag == 1) { // UIAlertView with tag 1 detected
    if (buttonIndex == 0)
    {
        NSUserDefaults * removeUDCode = [NSUserDefaults standardUserDefaults];
        [removeUDCode removeObjectForKey:@"userCode"];
        [[NSUserDefaults standardUserDefaults]synchronize ];
        
        NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
        [removeUD removeObjectForKey:@"isUserLoggedin"];
        [[NSUserDefaults standardUserDefaults]synchronize ];
        
        
        NSUserDefaults * onlineSyn = [NSUserDefaults standardUserDefaults];
        [onlineSyn removeObjectForKey:@"onlineSyn"];
        [[NSUserDefaults standardUserDefaults]synchronize ];
        
        
        NSLog(@"user pressed Button Indexed 0");
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        
        loginVC =  (LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"login_sbid"];
        [self.navigationController pushViewController:loginVC animated:YES];

    }
   }
//    else
//    {
//        NSLog(@"user pressed Button Indexed 1");
//        
//        
//        DashBoardVC *dashBoard =(DashBoardVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
//        [self.navigationController pushViewController:dashBoard animated:YES];
//        //Fixvc.CompitionCode=selectindexarray;
//            }
//
}



-(void) tournmentView :(NSString *) selectType{
    
    TorunamentVC*TETS =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
    TETS.selectDashBoard=selectType;
    [self.navigationController pushViewController:TETS animated:YES];
    
//    TorunamentVC*tournmentVc = [[TorunamentVC alloc]init];
//    
//    tournmentVc =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
//    tournmentVc.selectDashBoard=selectType;
// [self.navigationController pushViewController:tournmentVc animated:YES];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    _img_newMatch.image = [UIImage imageNamed:@"ico-new-mach01.png"];
    _view_new_Match.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:(0.3f)];

    
    _img_synData.image = [UIImage imageNamed:@"ico-sync-data01.png"];
    _view_syn_data.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:(0.3f)];

    
    _img_archives.image = [UIImage imageNamed:@"ico-archives01.png"];
    _view_archives.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:(0.3f)];
    
    _img_reports.image = [UIImage imageNamed:@"ico-reports01.png"];
    _view_reports.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:(0.3f)];
   
    
}


-(void)playercodeimage
{
    DBMANAGERSYNC *objDBMANAGERSYNC = [[DBMANAGERSYNC alloc] init];
    NSMutableArray*playercode=[objDBMANAGERSYNC getPlayerCode];
    int i;
    for (i=0; i<[playercode count]; i++)
     {
          NSDictionary*test=[playercode objectAtIndex:i];
         NSString *playercodestr=[test valueForKey:@"playercodeimage"];
     NSString *ImgeURL1 = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETIMAGE/%@",[Utitliy getSyncIPPORT],playercodestr];
         
         
         UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgeURL1]]];
         
         NSLog(@"%f,%f",image.size.width,image.size.height);
         
         NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
         
         NSString *Dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         
         NSString *pngPath = [Dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",playercodestr]];// this path if you want save reference path in sqlite
        
         [data1 writeToFile:pngPath atomically:YES];
         
         
//         
//         UIImage  *newImage = [UIImage imageNamed:fileName];
//         NSData *imageData = UIImagePNGRepresentation(newImage);
//         
//         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//         NSString *documentsDirectory = [paths objectAtIndex:0];
//         
//         NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
         
    }
    
    
    
}


-(void)officialcodeimage{
    DBMANAGERSYNC *objDBMANAGERSYNC = [[DBMANAGERSYNC alloc] init];
NSMutableArray*officialscode=[objDBMANAGERSYNC getofficailCode];
int i;
for (i=0; i<[officialscode count]; i++)
{
    NSDictionary*test=[officialscode objectAtIndex:i];
    NSString *officialscodestr=[test valueForKey:@"officialscodeimage"];
    NSString *ImgeURL1 = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETIMAGE/%@",[Utitliy getSyncIPPORT],officialscodestr];
    
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgeURL1]]];
    
    NSLog(@"%f,%f",image.size.width,image.size.height);
    
    
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    
    NSString *Dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *pngPath = [Dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",officialscodestr]];// this path if you want save reference path in sqlite
    
    [data1 writeToFile:pngPath atomically:YES];
    
    
}
}



-(void)groundcodeimage{
    DBMANAGERSYNC *objDBMANAGERSYNC = [[DBMANAGERSYNC alloc] init];
    NSMutableArray*groundcode=[objDBMANAGERSYNC getgroundcode];
    int i;
    for (i=0; i<[groundcode count]; i++)
    {
        NSDictionary*test=[groundcode objectAtIndex:i];
        NSString *groundcodestr=[test valueForKey:@"groundcodeimage"];
        NSString *ImgeURL1 = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETIMAGE/%@",[Utitliy getSyncIPPORT],groundcodestr];
        
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgeURL1]]];
        
        NSLog(@"%f,%f",image.size.width,image.size.height);
        
        
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
        
        NSString *Dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *pngPath = [Dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",groundcodestr]];// this path if you want save reference path in sqlite
        
        [data1 writeToFile:pngPath atomically:YES];
        
    }
}

-(void)teamCodeImage{
    DBMANAGERSYNC *objDBMANAGERSYNC = [[DBMANAGERSYNC alloc] init];
    NSMutableArray*groundcode=[objDBMANAGERSYNC getTeamCode];
    int i;
    for (i=0; i<[groundcode count]; i++)
    {
        NSDictionary*test=[groundcode objectAtIndex:i];
        NSString *groundcodestr=[test valueForKey:@"teamCodeImage"];
        NSString *ImgeURL1 = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETIMAGE/%@",[Utitliy getSyncIPPORT],groundcodestr];
        
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgeURL1]]];
        
        NSLog(@"%f,%f",image.size.width,image.size.height);
        
        
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
        
        NSString *Dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *pngPath = [Dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",groundcodestr]];// this path if you want save reference path in sqlite
        
        [data1 writeToFile:pngPath atomically:YES];
        
    }
}



- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
