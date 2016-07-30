//
//  NewMatchSetUpVC.m
//  CAPScoringApp
//
//  Created by deepak on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "NewMatchSetUpVC.h"
#import "DBManager.h"
#import "FixturesRecord.h"
#import "TeamLogoRecords.h"
#import "SelectPlayersVC.h"
#import "MatchOfficalsVC.h"
#import "CustomNavigationVC.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utitliy.h"

@interface NewMatchSetUpVC ()
{
    DBManager *objDBManager;
}
@property (nonatomic,strong)NSMutableArray *FetchCompitionArray;
@property (nonatomic,strong) NSMutableArray *selectedPlayerArray;
@property (nonatomic,strong) NSMutableArray *selectedPlayerFilterArray;
@property (nonatomic,strong)NSMutableArray *countTeam;
@property (nonatomic,strong)NSMutableArray *countTeamB;

@end

BOOL IsResult;

NSRegularExpression *isMatchedByRegex;

@implementation NewMatchSetUpVC
@synthesize  matchCode;
@synthesize teamAcode;
@synthesize teamBcode;
@synthesize competitionCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //fetch data from fixture screen and display in controls
    
    objDBManager=[[DBManager alloc]init];
    
    
    [self customnavigationmethod];
    
    [self colorChange];

    _countTeam = [objDBManager SelectTeamPlayers:self.matchCode teamCode:self.teamAcode];
    _countTeamB = [objDBManager SelectTeamPlayers:self.matchCode teamCode:self.teamBcode];
    
    self.lbl_teamA.text = self.teamA;
    self.lbl_teamB.text = self.teamB;
    self.lab_matchType.text = self.matchType;
    self.txt_overs.text = self.overs;
    self.lbl_date.text = self.date;
    self.lbl_time.text = self.time;
    self.lbl_monYear.text = self.month;
    self.lbl_venu.text = self.matchVenu;
    
    // Number of overs
    self.txt_overs.enabled = NO;
    
    
    //hide edit button in over menu
    if ([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]) {
        
        self.img_editIcon.hidden = YES;
        self.view_editOvers.hidden = YES;
        self.btn_editOvers.hidden = YES;
    }
    
//    //logo image
//    NSMutableArray *teamCode = [[NSMutableArray alloc]init];
//    
//    [teamCode addObject:@"TEA0000005"];
//    [teamCode addObject:@"TEA0000006"];
//    [teamCode addObject:@"TEA0000008"];
//    
//    
//    
//    for(int i=0;i<[teamCode count];i++){
//        
//        [self addImageInAppDocumentLocation:[teamCode objectAtIndex:i]];
//    }
//    
    
    
    NSMutableArray *mTeam = [[NSMutableArray alloc]init];
    [mTeam addObject:self.matchCode];
    [mTeam addObject:self.teamAcode];
    
    
    self.selectedPlayerFilterArray = [[NSMutableArray alloc]initWithArray: self.selectedPlayerArray];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,self.teamAcode];
    
    
    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
    UIImage *img;
    if(isFileExist){
        img = [UIImage imageWithContentsOfFile:pngFilePath];
        self.img_teamALogo.image = img;
    }else{
        img  = [UIImage imageNamed: @"no_image.png"];
        _img_teamALogo.image = img;
    }
     self.btnUpdateOutlet.userInteractionEnabled=YES;
    
      [self.btnUpdateOutlet setBackgroundColor:[UIColor colorWithRed:(16/255.0f) green:(210/255.0f) blue:(158/255.0f) alpha:1.0f]];
    

    if(self.isEdit==YES)
    {
        self.btnUpdateOutlet.userInteractionEnabled=NO;
          self.btnUpdateOutlet.backgroundColor = [UIColor colorWithRed:(114/255.0f) green:(114/255.0f) blue:(114/255.0f) alpha:(1)];
        

    }
    
    
    NSFileManager *fileManagerB = [NSFileManager defaultManager];
    NSString *docDirB = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePathB = [NSString stringWithFormat:@"%@/%@.png", docDirB,self.teamBcode];
    BOOL isFileExistB = [fileManagerB fileExistsAtPath:pngFilePathB];
    UIImage *imgB;
    if(isFileExistB){
        imgB = [UIImage imageWithContentsOfFile:pngFilePathB];
        _img_teamBLogo.image = imgB;
    }else{
        imgB  = [UIImage imageNamed: @"no_image.png"];
        _img_teamBLogo.image = imgB;
    }
    
    
    self.txt_overs.keyboardType = UIKeyboardTypeNumberPad;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector: @selector(check) userInfo:nil repeats : YES ];
}



//Navigation bar action
-(void)customnavigationmethod
{
    CustomNavigationVC *objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"MATCH SETUP";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
}

//-(void) addImageInAppDocumentLocation:(NSString*) fileName{
//    
//    BOOL success = [self checkFileExist:fileName];
//    
//    if(!success) {//If file not exist
//        
//        UIImage  *newImage = [UIImage imageNamed:fileName];
//        NSData *imageData = UIImagePNGRepresentation(newImage);
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
//        
//        if (![imageData writeToFile:imagePath atomically:NO])
//        {
//            NSLog((@"Failed to cache image data to disk"));
//        }else
//        {
//            NSLog(@"the cachedImagedPath is %@",imagePath);
//        }
//    }
//}

//Check given file name exist in document directory
- (BOOL) checkFileExist:(NSString*) fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
    return [fileManager fileExistsAtPath:filePath];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)didClickinfoBtn_Action:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.btnUpdateOutlet.tag=button.tag;
    
    
}

- (IBAction)btn_selectPlayersTeamB:(id)sender {
    
    //to change selected team players B color after selected 7 players
    
    NSMutableArray *countTeamB = [objDBManager SelectTeamPlayers :self.matchCode teamCode :self.teamBcode];
    
    
    
    FixturesRecord *fixture = (FixturesRecord*) [countTeamB objectAtIndex:0];
    
    
    NSUInteger teamCountB = [fixture.count integerValue];
    
    
    if(teamCountB >= 7){
        
        _view_teamB.backgroundColor = [UIColor colorWithRed:(114/255.0f) green:(114/255.0f) blue:(114/255.0f) alpha:(1)];
        
    }else{
        
        _view_teamB.backgroundColor = [UIColor colorWithRed:(228/255.0f) green:(98/255.0f) blue:(58/255.0f) alpha:(1)];
    }
    [self RedirectSelectPlayerVC:@"SelectTeamB" :teamBcode];
    
    
    
}
-(void)RedirectSelectPlayerVC:(NSString *)selectTeam :(NSString *)selectteamcode
{
    SelectPlayersVC * selectvc = [[SelectPlayersVC alloc]init];
    
    selectvc =  (SelectPlayersVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectPlayers"];
    
    selectvc.SelectTeamCode=selectteamcode;
    selectvc.matchCode = matchCode;
    //selectvc.teamAcode=teamAcode;
    // selectvc.teamBcode=teamBcode;
    
    
    
    selectvc.teamA = self.teamA;
    selectvc.teamB = self.teamB;
    selectvc.matchType = self.matchType;
    selectvc.overs = self.overs;
    selectvc.date = self.date;
    selectvc.time = self.time;
    selectvc.month = self.month;
    selectvc.matchVenu = self.matchVenu;
    selectvc.overs= self.overs;
    selectvc.teamAcode=self.teamAcode;
    selectvc.teamBcode=self.teamBcode;
    selectvc.competitionCode=competitionCode;
    selectvc.matchTypeCode=_matchTypeCode;
    selectvc.chooseTeam   =selectTeam;
    selectvc.isEdit = self.isEdit;
    
    selectvc.playingXIPlayers = self.playingXIPlayers;
    
    
    
    [self.navigationController pushViewController:selectvc animated:YES];
}

- (IBAction)btn_selectPlayersTeamA:(id)sender {
    
    //to change selected team players A color after selected 7 players
    NSMutableArray *countTeam = [objDBManager SelectTeamPlayers:self.matchCode teamCode:self.teamAcode];
    
    
    
    FixturesRecord *fixture = (FixturesRecord*) [countTeam objectAtIndex:0];
    
    
    NSUInteger teamCountA = [fixture.count integerValue];
    
    
    
    if(teamCountA >= 7){
        
        _view_teamA.backgroundColor = [UIColor colorWithRed:(114/255.0f) green:(114/255.0f) blue:(114/255.0f) alpha:(1)];
        
    }else{
        
        _view_teamA.backgroundColor = [UIColor colorWithRed:(228/255.0f) green:(98/255.0f) blue:(58/255.0f) alpha:(1)];
        
        
    }
    
    NSLog(@"COUNT = %@",_countTeam);
    
    [self RedirectSelectPlayerVC:@"SelectTeamA" :teamAcode];
    //    SelectPlayersVC * selectvc = [[SelectPlayersVC alloc]init];
    //
    //    selectvc =  (SelectPlayersVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectPlayers"];
    //
    //    selectvc.SelectTeamCode=teamAcode;
    //    selectvc.matchCode = matchCode;
    //
    //    [self.navigationController pushViewController:selectvc animated:YES];
    
    
    
}

- (IBAction)btn_edit:(id)sender {
    
    _view_overs.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    _txt_overs.enabled = YES;
    
    _txt_overs.keyboardType = UIKeyboardTypePhonePad;
    
    [_txt_overs becomeFirstResponder];
    
}

//alphabet validation
-(BOOL)textValidation:(NSString*) validation{
    
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    
    filtered = [[validation componentsSeparatedByCharactersInSet:charcter] componentsJoinedByString:@""];
    return [validation isEqualToString:filtered];
    
    
    
    
    
}

- (IBAction)btn_proceed:(id)sender {
    //    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //
    //    //Show indicator
    //    [delegate showLoading];
    if (![self textValidation:self.txt_overs.text]) {
        
        
        [self showDialog:@"Please Enter Valid Overs" andTitle:@"Match Setup"];
        
    }else{
        [self overValidation];
        
    }
    //    [delegate hideLoading];
}

- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Show message for given title and cntent
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alertDialog show];
}




-(void)check{
    
    if([self.txt_overs.text length] >= 4){
        
        self.txt_overs.text = [self.txt_overs.text substringWithRange:NSMakeRange(0, 4) ];
    }
}



//Validation for over update validation
-(BOOL) overValidation{
    
    _countTeam = [objDBManager SelectTeamPlayers:self.matchCode teamCode:self.teamAcode];
    _countTeamB = [objDBManager SelectTeamPlayers:self.matchCode teamCode:self.teamBcode];
    
    FixturesRecord *fixture = (FixturesRecord*) [_countTeam objectAtIndex:0];
    FixturesRecord *fixtureB = (FixturesRecord*) [_countTeamB objectAtIndex:0];
    
    NSString *oversTxt = self.txt_overs.text;
    
    NSInteger twentyText = [oversTxt intValue];
    NSInteger OdiText = [oversTxt intValue];
    
    NSUInteger teamCountA = [fixture.count integerValue];
    NSUInteger teamCountB = [fixtureB.count integerValue];
    
    
    
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){
        if(twentyText > 20){
            [self showDialog:@"Please Enter Below 20 Overs" andTitle:@"Match Setup"];
        }else if (twentyText == 0){
            
            [self showDialog:@"Please Enter Overs" andTitle:@"Match Setup"];
        }
        
        else if (teamCountA >= 7 && teamCountB >= 7){
            [objDBManager updateOverInfo:self.txt_overs.text matchCode:self.matchCode competitionCode:self.competitionCode];
            
            MatchOfficalsVC * matchvc = [[MatchOfficalsVC alloc]init];
            
            matchvc =  (MatchOfficalsVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"matchofficial"];
            
            matchvc.Matchcode = matchCode;
            matchvc.competitionCode = competitionCode;
            
            [self.navigationController pushViewController:matchvc animated:YES];
            [self startService:@"MATCHUPDATEOVER"];
        }else{
            
            [self showDialog:@"Please Select Minimum Seven Players" andTitle:@"Match Setup"];
            
        }
        return NO;
        
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){
        if(OdiText > 50){
            
            [self showDialog:@"Please Enter Below 50 Overs" andTitle:@"Match Setup"];
        }else if (twentyText == 0){
            
            [self showDialog:@"Please Enter Overs" andTitle:@"Match Setup"];
        }
        
        else if (teamCountA >= 7 && teamCountB >= 7){
            [objDBManager updateOverInfo:self.txt_overs.text matchCode:self.matchCode competitionCode:self.competitionCode];
            
            MatchOfficalsVC * matchvc = [[MatchOfficalsVC alloc]init];
            
            matchvc =  (MatchOfficalsVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"matchofficial"];
            
            matchvc.Matchcode = matchCode;
            matchvc.competitionCode = competitionCode;
            
            [self.navigationController pushViewController:matchvc animated:YES];
            [self startService:@"MATCHUPDATEOVER"];
        }else{
            
            [self showDialog:@"Please Select Minimum Seven Players" andTitle:@"Match Setup"];
            
        }
        return NO;
        
    }else if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){
        
        
        if (teamCountA >= 7 && teamCountB >= 7){
            [objDBManager updateOverInfo:self.txt_overs.text matchCode:self.matchCode competitionCode:self.competitionCode];
            
            MatchOfficalsVC * matchvc = [[MatchOfficalsVC alloc]init];
            
            matchvc =  (MatchOfficalsVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"matchofficial"];
            
            matchvc.Matchcode = matchCode;
            matchvc.competitionCode = competitionCode;
            matchvc.matchTypeCode =self.matchTypeCode;
            
            [self.navigationController pushViewController:matchvc animated:YES];
            [self startService:@"MATCHUPDATEOVER"];
        }else{
            
            [self showDialog:@"Please Select Minimum Seven Players" andTitle:@"Match Setup"];
            
        }
        
        return NO;
        
    }
    return YES;
    
}

-(void)colorChange{
    
    
    _countTeam = [objDBManager SelectTeamPlayers:self.matchCode teamCode:self.teamAcode];
    _countTeamB = [objDBManager SelectTeamPlayers:self.matchCode teamCode:self.teamBcode];
    
    
    FixturesRecord *fixture = (FixturesRecord*) [_countTeam objectAtIndex:0];
    FixturesRecord *fixtureB = (FixturesRecord*) [_countTeamB objectAtIndex:0];
    
    
    NSUInteger teamCountA = [fixture.count integerValue];
    NSUInteger teamCountB = [fixtureB.count integerValue];
    
    if (teamCountA >= 7) {
        
        //grey color
        _view_teamA.backgroundColor = [UIColor colorWithRed:(114/255.0f) green:(114/255.0f) blue:(114/255.0f) alpha:(1)];
        
    }else{
        
        //orange color
        _view_teamA.backgroundColor = [UIColor colorWithRed:(228/255.0f) green:(98/255.0f) blue:(58/255.0f) alpha:(1)];
        
    }
    
    if (teamCountB >= 7) {
        
        
        _view_teamB.backgroundColor = [UIColor colorWithRed:(114/255.0f) green:(114/255.0f) blue:(114/255.0f) alpha:(1)];
        
    }else{
        
        //orange color
        
        
        _view_teamB.backgroundColor = [UIColor colorWithRed:(228/255.0f) green:(98/255.0f) blue:(58/255.0f) alpha:(1)];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self colorChange];
}





- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void) startService:(NSString *)OPERATIONTYPE{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //Show indicator
    [delegate showLoading];
    if(self.checkInternetConnection){
        NSString*OVER=self.txt_overs.text;
        
        matchCode = matchCode == nil ?@"NULL":matchCode;
        competitionCode = competitionCode == nil ?@"NULL":competitionCode;
        OVER = OVER == nil ?@"NULL":OVER;
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/MATCHUPDATEOVER/%@/%@/%@",[Utitliy getSyncIPPORT], competitionCode,matchCode,OVER];
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
        });
    }
    [delegate hideLoading];
}
@end
