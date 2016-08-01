//
//  FixturesVC.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 5/24/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FixturesVC.h"
#import "FixturesCell.h"
#import "FixturesRecord.h"
#import "NewMatchSetUpVC.h"
#import "CustomNavigationVC.h"
#import "ScorEnginVC.h"
#import "DBManager.h"
#import "Reachability.h"
#import "Utitliy.h"


@interface FixturesVC ()
{    UIRefreshControl *refreshControl;
    DBManager *objDBManager;
    NSString*passSelectdashboard;

}

@property (nonatomic,strong)NSMutableArray *FetchCompitionArray;

//@property (nonatomic,strong)NSString *Updatefixturecomments;


@end

@implementation FixturesVC
@synthesize CompitionCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    
    
 //  passSelectdashboard=[_selectDashBoard valueForKey:@"selectdashboard"];
   
    
//    if(self.checkInternetConnection)
//    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
//            refreshControl.tintColor = [UIColor greenColor];
//            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
//       
//            
//            
//            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/GETCOMPETITONFIXTURES/0x0100000088F0BDA6134BA1A808FA82837D998FD8C45AC41C001C2762A27AC7C22D0961149CE3F7B7D0EB9047/%@",[Utitliy getSyncIPPORT],CompitionCode];
//            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            NSURLResponse *response;
//            NSError *error;
//            
//            NSData *responseData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            if (responseData != nil) {
//                
//                NSMutableArray *serviceResponse=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//                NSDictionary*CheckErrorItem=[serviceResponse valueForKey:@"lstErrorItem"];
//                  NSMutableArray * ErrorNoDict =[CheckErrorItem objectForKey:@"ErrorNo"];
//                NSString *ErrorNoStr=[ErrorNoDict valueForKey:@"ErrorNo"];
//                NSString *message=[ErrorNoDict valueForKey:@"DataItem"];
//                NSString *CompareErrorno=@"MOB0005";
//                if ([ErrorNoStr isEqualToString:CompareErrorno])
//                {
//                
//                }
//
//                    //Competition
////                    NSMutableArray *CompetitionMatchArry =   [serviceResponse objectForKey:@"lstCompetitionMatch"];
////                    //[CompitisionArray removeAllObjects];
////                    //CompitisionArray = [NSMutableArray new];
////                    int i;
////                    for (i=0; i<[CompetitionMatchArry count]; i++) {
////                        NSDictionary*test=[temp objectAtIndex:i];
////                        NSString*COMPETITIONCODE=[test objectForKey:@"MatchDate"];
////                        NSString *COMPETITIONNAME=[test objectForKey:@"TeamAName"];
////                        NSString *SEASON=[test objectForKey:@"TeamBName"];
////                        NSString *TROPHY=[test objectForKey:@"GroundName"];
////                        NSString *STARTDATE=[test objectForKey:@"City"];
//                
//                
//                }
//           
//            
//            [self.FixtureTVC addSubview:refresh];
//            
//            [self.FixtureTVC reloadData];
//            
//            [refreshControl endRefreshing];
//            
//        });
//    }
    
    
    objDBManager = [[DBManager alloc]init];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userCode = [defaults objectForKey:@"userCode"];
        _FetchCompitionArray=[[NSMutableArray alloc]init];
    _FetchCompitionArray =[objDBManager RetrieveFixturesData:CompitionCode:userCode];
    self.popView.hidden=YES;
    [self customnavigationmethod];
   
    
}


- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_FetchCompitionArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    FixturesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                         forIndexPath:indexPath];
    
    FixturesRecord *objFixtureRecord=(FixturesRecord*)[_FetchCompitionArray objectAtIndex:indexPath.row];
    

    
    cell.lbl_teamA.text=objFixtureRecord.teamAname;
    cell.lbl_teamB.text=objFixtureRecord.teamBname;
    cell.lbl_stadium.text=objFixtureRecord.groundname;
    cell.lbl_state.text=objFixtureRecord.city;
    // self.txt_info.text=objFixtureRecord.matchovercomments;
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:objFixtureRecord.matchdate];
    [formatter setDateFormat:@"dd"];
    NSString *newDate = [formatter stringFromDate:date];
    cell.lbl_date.text=newDate;
    
    [formatter setDateFormat:@"MMM ''yy"];
    newDate = [formatter stringFromDate:date];
    cell.lbl_monthandyear.text=newDate;
    
    [formatter setDateFormat:@"hh:mm a"];
    newDate = [formatter stringFromDate:date];
    cell.lbl_time.text=newDate;
    [cell.btn_info addTarget:self action:@selector(didClickinfoBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_info setTag:indexPath.row+1];
    
    // change background color of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
    
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.viewborder.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.viewborder.layer.borderWidth = 3.0f;
    cell.viewborder.layer.masksToBounds=YES;
    return cell;
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *mSetUp = [[NSMutableArray alloc]init];
    
    FixturesRecord *objFixtureRecord=(FixturesRecord*)[_FetchCompitionArray objectAtIndex:indexPath.row];
    
    [mSetUp addObject:objFixtureRecord];
    
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //
    //NewMatchSetUpVC *detail =(NewMatchSetUpVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"matchSetUpSBID"];
    
    //
        NewMatchSetUpVC*detail = [[NewMatchSetUpVC alloc]init];
    
    detail =  (NewMatchSetUpVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"matchSetUpSBID"];
    
    NSString*teamAcode = objFixtureRecord.teamAcode;
    NSString*teamBcode = objFixtureRecord.teamBcode;
    
    NSString*teamA =  objFixtureRecord.teamAname;
    NSString*teamB = objFixtureRecord.teamBname;
    NSString*matchType = objFixtureRecord.matchTypeName;
    NSString*matchCode = objFixtureRecord.matchcode;
    NSString*competitionCode = self.CompitionCode;
    NSString*matchTypeCode = objFixtureRecord.matchTypeCode;
    NSString*overs = objFixtureRecord.overs;
    NSString *MatchStatus = objFixtureRecord.MatchStatus;
    
    if([MatchStatus  isEqual: @"MSC123"] || [MatchStatus  isEqual: @"MSC281"])
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *date = [formatter dateFromString:objFixtureRecord.matchdate];
        [formatter setDateFormat:@"dd"];
        NSString *newDate = [formatter stringFromDate:date];
        
        
        
        
        //NSDate *monthYY = [formatter dateFromString:objFixtureRecord.matchdate];
        [formatter setDateFormat:@"MMM ''yy"];
        NSString*newMonth = [formatter stringFromDate:date];
        
        
        
        // NSDate *time = [formatter dateFromString:objFixtureRecord.matchdate];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *newTime = [formatter stringFromDate:date];
        
        
        
        NSString*matchVenu = objFixtureRecord.city;
        
        
        
        detail.matchSetUp = mSetUp;
        detail.teamA = teamA;
        detail.teamB = teamB;
        detail.date = newDate;
        detail.matchVenu = matchVenu;
        detail.matchType = matchType;
        detail.overs = overs;
        detail.month = newMonth;
        detail.time = newTime;
        detail.matchCode = matchCode;
        detail.competitionCode = competitionCode;
        detail.matchTypeCode = matchTypeCode;
        detail.teamAcode = teamAcode;
        detail.teamBcode = teamBcode;
        detail.isEdit = NO;

        
        
        //    [detail setModalPresentationStyle:UIModalPresentationFullScreen];
        //    [self presentViewController:detail animated:NO completion:nil];
        [self.navigationController pushViewController:detail animated:YES];
        NSLog(@"indexframe=%@",selectedIndexPath);
    }
    else
    {
        //UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ScorEnginVC *scoreEngine=[[ScorEnginVC alloc]init];
        
        scoreEngine =(ScorEnginVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreEngineID"];
        scoreEngine.matchSetUp = mSetUp;
        scoreEngine.matchCode=matchCode;
        scoreEngine.competitionCode=competitionCode;
        scoreEngine.matchTypeCode=matchTypeCode;
        [self.navigationController pushViewController:scoreEngine animated:YES];
       // [scoreEngine setModalPresentationStyle:UIModalPresentationFullScreen];
        //[self presentViewController:scoreEngine animated:NO completion:nil];
    }
    
    
    
    //
    //    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    //    NSLog(@"indexframe=%@",selectedIndexPath);
    //    FixturesCell *cell =(FixturesCell *) [tableView cellForRowAtIndexPath:indexPath];
    //    cell.lbl_date.backgroundColor=[UIColor whiteColor];
    
}

-(void)didClickinfoBtn_Action:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"indexPath.row: %d", button.tag);
    //CGFloat frameyposition=button.tag*50;
    
   // CGFloat yposition=frameyposition+30;
    [self.view layoutIfNeeded];
   // self.popviewYposition.constant=yposition;
    self.popView.hidden =NO;
    NSLog(@"TAG %ld",(long)button.tag);
    self.btnSaveOutlet.tag=button.tag;
    //self.txt_info.text= @"";
    
    FixturesRecord *fixtureRecords= [self.FetchCompitionArray objectAtIndex:(self.btnSaveOutlet.tag-1)];
    
    self.txt_info.text=fixtureRecords.matchovercomments;
    
}

//Navigation bar action
-(void)customnavigationmethod
{
    CustomNavigationVC *objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"FIXTURES";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)btn_back:(id)sender {
//        [self.navigationController popViewControllerAnimated:YES];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"NewMatchSetupExit"]) {
        NSLog(@"yes");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewMatchSetupExit"];
        TorunamentVC*tournmentVc = [[TorunamentVC alloc]init];
        
        tournmentVc =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
      
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _selectDashBoard = [defaults objectForKey:@"selectdashboard"];
      tournmentVc.selectDashBoard=_selectDashBoard;
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *userCode = [defaults objectForKey:@"userCode"];
//     tournmentVc.userCode=userCode;
       // tournmentVc .selectindexarray=_selectindexarray;
        [self.navigationController pushViewController:tournmentVc animated:YES];
        
    }
  
    
    else {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Defaultexit"];
        TorunamentVC*tournmentVc = [[TorunamentVC alloc]init];
        
        tournmentVc =  (TorunamentVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"tornmentid"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _selectDashBoard = [defaults objectForKey:@"selectdashboard"];
        tournmentVc.selectDashBoard=_selectDashBoard;
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSString *userCode = [defaults objectForKey:@"userCode"];
        //     tournmentVc.userCode=userCode;
        // tournmentVc .selectindexarray=_selectindexarray;
        [self.navigationController pushViewController:tournmentVc animated:YES];

    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (IBAction)chk_btn:(id)sender {
//     NSMutableArray * FetchCompitionArray =[DBManager RetrieveFixturesData];
//
////    FixturesRecord *obj=(FixturesRecord*)[FetchCompitionArray objectAtIndex:i];
//    NSLog(@"%@",FetchCompitionArray);
//
//}


- (IBAction)btnCancel:(id)sender {
    self.popView.hidden =YES;
    
}

- (IBAction)btnsave:(id)sender {
    
    //Updatefixturecomments=[[NSString alloc]init];
    //_Updatefixturecomments =[DBManager Upda];
    
    FixturesRecord *fixtureRecords= [self.FetchCompitionArray objectAtIndex:(self.btnSaveOutlet.tag-1)];
    fixtureRecords.matchovercomments = self.txt_info.text;

    
    [objDBManager updateFixtureInfo:self.txt_info.text matchCode:fixtureRecords.matchcode competitionCode:fixtureRecords.competitioncode];
    
    
    self.popView.hidden =YES;
    
    
    
    
    
}
@end
