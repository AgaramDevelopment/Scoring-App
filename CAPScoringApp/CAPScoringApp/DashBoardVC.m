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

@interface DashBoardVC ()


@end

@implementation DashBoardVC

@synthesize checkErrorItem;
@synthesize CompitisionArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

  
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_syn_Data:(id)sender {
    
    _img_synData.image = [UIImage imageNamed:@"ico-sync-data02.png"];
    
    _view_syn_data.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    
    
    NSString *baseURL = [NSString stringWithFormat:@"http://192.168.1.49:8079/CAPMobilityService.svc/PULLSCORERDATAFROMSERVER/1"];
    NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    
    NSData *responseData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (responseData != nil) {
        
        NSDictionary *serviceResponse=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
       checkErrorItem=[serviceResponse objectForKey:@"lstErrorItem"];
        
        NSDictionary * ErrorNoDict =[checkErrorItem objectAtIndex:0];
        NSString *ErrorNoStr=[ErrorNoDict valueForKey:@"ErrorNo"];
        NSString *CompareErrorno=@"MOB0005";
        if ([ErrorNoStr isEqualToString:CompareErrorno]) {
       
           //CompitisionArray=[serviceResponse objectForKey:@"Competition"];
          
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
                   
                    
                    
                    
                    
                    bool CheckStatus=[DBMANAGERSYNC CheckCompetitionCode:COMPETITIONCODE];
                    if (CheckStatus==YES) {
                        [DBMANAGERSYNC UPDATECOMPETITION:COMPETITIONCODE: COMPETITIONNAME:SEASON: TROPHY:STARTDATE:ENDDATE:MATCHTYPE:ISOTHERSMATCHTYPE : MODIFIEDBY: MODIFIEDDATE];
                    }
                    
                    else
                    {
                        [DBMANAGERSYNC  InsertMASTEREvents:COMPETITIONCODE:COMPETITIONNAME:SEASON:TROPHY:STARTDATE:ENDDATE:MATCHTYPE: ISOTHERSMATCHTYPE :MANOFTHESERIESCODE:BESTBATSMANCODE : BESTBOWLERCODE:BESTALLROUNDERCODE:MOSTVALUABLEPLAYERCODE:RECORDSTATUS:CREATEDBY:CREATEDDATE:MODIFIEDBY:MODIFIEDDATE];
                    
                    }
                    
                    
                    
                 //   [CompitisionArray addObject:add];
                    
                    
               
                }
            }
            
     
            
        
        else
        {
    
    
       
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"Message"
                                  delegate:nil //or self
                                  cancelButtonTitle:@"Failed"
                                  otherButtonTitles:nil];
            
            [alert show];
    
    }
    
    
    }
    
    
    
}

- (IBAction)btn_new_Match:(id)sender {
    
    _img_newMatch.image = [UIImage imageNamed:@"ico-new-mach02.png"];
    
    _view_new_Match.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    
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
    
       
    
    
}



- (IBAction)btn_signOut:(id)sender {
    
        
    NSUserDefaults * removeUDCode = [NSUserDefaults standardUserDefaults];
    [removeUDCode removeObjectForKey:@"userCode"];
    [[NSUserDefaults standardUserDefaults]synchronize ];
    
    
    
    


    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Alert"
                                                   message: @"Are sure you want to signout?"
                                                  delegate: self
                                         cancelButtonTitle:@"Signout"
                                         otherButtonTitles:@"Cancel",nil];
    
    
    [alert show];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if (alertView.tag == 1) { // UIAlertView with tag 1 detected
    if (buttonIndex == 0)
    {
        
        NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
        [removeUD removeObjectForKey:@"isUserLoggedin"];
        [[NSUserDefaults standardUserDefaults]synchronize ];
        
        NSLog(@"user pressed Button Indexed 0");
        
        LoginVC *loginVC = [[LoginVC alloc]init];
        
        loginVC =  (LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"login_sbid"];
        [self.navigationController pushViewController:loginVC animated:YES];

    }
    else
    {
        NSLog(@"user pressed Button Indexed 1");
        
        
        DashBoardVC *dashBoard =(DashBoardVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
        [self.navigationController pushViewController:dashBoard animated:YES];
        //Fixvc.CompitionCode=selectindexarray;
            }
}



-(void) tournmentView :(NSString *) selectType{
    
    TorunamentVC*tournmentVc = [[TorunamentVC alloc]init];
    
    tournmentVc =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
    tournmentVc.selectDashBoard=selectType;
 [self.navigationController pushViewController:tournmentVc animated:YES];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    _img_newMatch.image = [UIImage imageNamed:@"ico-new-mach01.png"];
    _view_new_Match.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:(0.3f)];

    
}
@end
