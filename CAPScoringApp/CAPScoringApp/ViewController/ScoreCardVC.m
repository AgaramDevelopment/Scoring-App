//
//  ScoreCardVC.m
//  CAPScoringApp
//
//  Created by Sathish on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ScoreCardVC.h"
#import "ScoreCardCellTVCell.h"
#import "FetchScorecard.h"
#import "BattingSummaryDetailsForScoreBoard.h"
#import "BowlingSummaryDetailsForScoreBoard.h"
#import "CustomNavigationVC.h"
#import "FetchSEPageLoadRecord.h"

@interface ScoreCardVC (){
    CustomNavigationVC *objCustomNavigation;
}
@end

@implementation ScoreCardVC

@synthesize competitionCode;
@synthesize matchCode;
@synthesize inningsNo;
@synthesize RunRate;
FetchScorecard *fetchScorecard ;
FetchSEPageLoadRecord *fetchSEpage;

int batsmanHeaderPosition = 0;
int batsmanPostion = 0;
int bowlerHeaderPosition = 0;
int bowlerPostion = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customnavigationmethod];
    
    //    competitionCode = @"UCC0000004";
    //    matchCode = @"IMSC02200224DB2663B00002";
    //    inningsNo = @"1";
    self.matchTypeCode = @"MSC115";
    
    
    fetchScorecard = [[FetchScorecard alloc]init];
    [fetchScorecard FetchScoreBoard:competitionCode :matchCode :inningsNo];
    
    
    
     fetchSEpage = [[FetchSEPageLoadRecord alloc]init];
    [fetchSEpage fetchSEPageLoadDetails:competitionCode :matchCode];
    

    
    //Set Table Cell Position
    batsmanHeaderPosition = 0;
    batsmanPostion =fetchScorecard.BattingSummaryForScoreBoard.count > 0 ? 1 :0;
    bowlerHeaderPosition =fetchScorecard.BattingSummaryForScoreBoard.count>0?fetchScorecard.BattingSummaryForScoreBoard.count+1:1; bowlerPostion = bowlerHeaderPosition+1;
    
    [self hideLabelBasedOnMatchType];
    
    _lbl_battingShrtName.text = _BATTEAMSHORTNAME;
    _lbl_firstIngsTeamName.text = _BATTEAMSHORTNAME;
    _lbl_secIngsTeamName.text = _BOWLTEAMSHORTNAME;
    
    _lbl_battingScoreWkts.text = [NSString stringWithFormat:@"%ld / %ld",(unsigned long)_BATTEAMRUNS,(unsigned long)fetchSEpage.BATTEAMWICKETS];
    
    _lbl_overs.text = [NSString stringWithFormat:@"%ld.%ld OVS" ,(unsigned long)_BATTEAMOVERS,(unsigned long)_BATTEAMOVRBALLS];
    
    _lbl_runRate.text = [NSString stringWithFormat:@"RR %.02f | RRR %.02f",[fetchSEpage.BATTEAMRUNRATE floatValue], [fetchSEpage.RUNSREQUIRED floatValue]];
    
    _lbl_teamAfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@", _SECONDINNINGSTOTAL,_SECONDINNINGSWICKET];
    _lbl_teamAfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",_SECONDINNINGSOVERS];
    
    _lbl_teamBfirstIngsScore.text = [NSString stringWithFormat:@"%@ / %@",_FIRSTINNINGSTOTAL,
                                     _FIRSTINNINGSWICKET];
    _lbl_teamBfirstIngsOvs.text = [NSString stringWithFormat:@"%@ OVS",_FIRSTINNINGSOVERS];
    
    [self setInitView];
    int btnSize =self.btn_sec_inns_id.frame.origin.x;
    
    //    self.btn_tab_fst_inns.constant =200;
    ////    self.btn_tab_second_inns.constant =400;
    //self.btn_fst_inn_x.constant=btnSize*2;
    //    self.btn_fst_inn_width.constant = 200;
    ////    self.btn_sec_inn_x.constant=400;
    
    //
    //    self.lbl_strip.constant=500;
    //
    //
    //    self.btn_tab_fst_inns.constant=500;
    //
    //    self.btn_tab_second_inns.constant=500;
    
    
[self.btn_fst_inns_id setTitle:[NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BATTINGTEAMNAME] forState: UIControlStateNormal];
    
[self.btn_sec_inns_id setTitle: [NSString stringWithFormat:@"%@ 1st INNS",fetchScorecard.BOWLINGTEAMNAME] forState: UIControlStateNormal];
    
    
}

-(void) setInitView{
    
    if([inningsNo isEqual:@"1"]){
        self.lbl_strip.constant=0;
    }else if([inningsNo isEqual:@"2"]){
        self.lbl_strip.constant=self.btn_sec_inns_id.frame.origin.x;
    }else if([inningsNo isEqual:@"3"]){
        self.lbl_strip.constant=self.btn_third_inns_id.frame.origin.x;
    }else if([inningsNo isEqual:@"4"]){
        self.lbl_strip.constant=self.btn_fourth_inns_id.frame.origin.x;
    }
    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
        self.btn_third_inns_id.hidden = YES;
        self.btn_fourth_inns_id.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"Score Card";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hideLabelBasedOnMatchType{
    
    
    
    if ([self.matchTypeCode isEqualToString:@"MSC115"] || [self.matchTypeCode isEqualToString:@"MSC116"] ||
        [self.matchTypeCode isEqualToString:@"MSC022"] || [self.matchTypeCode isEqualToString:@"MSC024"]) {
        
        
        _lbl_teamAsecIngsHeading.hidden = YES;
        _lbl_teamBsecIngsHeading.hidden = YES;
        
        _lbl_teamASecIngsScore.hidden = YES;
        _lbl_teamASecIngsOvs.hidden = YES;
        _lbl_teamBSecIngsScore.hidden = YES;
        _lbl_teamBSecIngsOvs.hidden = YES;
        
    }else{
        _lbl_teamAsecIngsHeading.hidden = NO;
        _lbl_teamBsecIngsHeading.hidden = NO;
        
        _lbl_teamASecIngsScore.hidden = NO;
        _lbl_teamASecIngsOvs.hidden = NO;
        _lbl_teamBSecIngsScore.hidden = NO;
        _lbl_teamBSecIngsOvs.hidden = NO;
        
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return fetchScorecard.BowlingSummaryForScoreBoard.count+ fetchScorecard.BattingSummaryForScoreBoard .count+2;    //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *batsmanCell = @"scorecard_batsman_cell";
    static NSString *batsmanHeaderCell = @"batsman_header_cell";
    static NSString *bowlerHeaderCell = @"bowler_header_cell";
    static NSString *bowlerCell = @"scorecard_bowler_cell";
    
    
    if(indexPath.row == 0){
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:batsmanHeaderCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.batsManHeaderCell;
            self.batsManHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }else if(batsmanPostion <= indexPath.row && bowlerHeaderPosition>indexPath.row){
        BattingSummaryDetailsForScoreBoard *battingSummaryDetailsForSB = [fetchScorecard.BattingSummaryForScoreBoard objectAtIndex:indexPath.row-1];
        
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:batsmanCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.batsmanCell;
            self.batsmanCell = nil;
        }
        cell.lbl_player_name.text = battingSummaryDetailsForSB.BATSMANNAME;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.lbl_sr.text = [NSString stringWithFormat:@"%.02f",[battingSummaryDetailsForSB.STRIKERATE floatValue]];
        
        
        cell.lbl_rss.text = [NSString stringWithFormat:@"%.02f",[battingSummaryDetailsForSB.RUNSPERSCORINGSHOTS floatValue]];
        cell.lbl_runs.text = battingSummaryDetailsForSB.RUNS;
        cell.lbl_balls.text = battingSummaryDetailsForSB.BALLS;
        cell.lbl_b_fours.text = battingSummaryDetailsForSB.FOURS;
        cell.lbl_b_sixes.text = battingSummaryDetailsForSB.SIXES;
        cell.lbl_how_out.text = battingSummaryDetailsForSB.WICKETDESCRIPTION;
        cell.lbl_dot_ball.text = battingSummaryDetailsForSB.DOTBALLS;
        cell.lbl_dot_ball_percent.text = [NSString stringWithFormat:@"%.02f",[battingSummaryDetailsForSB.DOTBALLPERCENTAGE floatValue]];
        
        
        return cell;
    }else if(bowlerHeaderPosition == indexPath.row){
        ScoreCardCellTVCell *cell = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:bowlerHeaderCell];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            cell = self.bowlerHeaderCell;
            self.bowlerHeaderCell = nil;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
        
    }else if(indexPath.row >= bowlerPostion){
        BowlingSummaryDetailsForScoreBoard *bowlingSummaryForScoreBoard = [fetchScorecard.BowlingSummaryForScoreBoard objectAtIndex:indexPath.row-bowlerPostion];
        
        ScoreCardCellTVCell *bowlerCellTvc = (ScoreCardCellTVCell *)[tableView dequeueReusableCellWithIdentifier:bowlerCell];
        if (bowlerCellTvc == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ScoreCardCellTVCell" owner:self options:nil];
            bowlerCellTvc = self.bowlerCell;
            self.bowlerCell = nil;
        }
        [bowlerCellTvc setBackgroundColor:[UIColor clearColor]];
        
        bowlerCellTvc.lbl_bowler_ecno.text =[NSString stringWithFormat:@"%.02f",[bowlingSummaryForScoreBoard.ECONOMY floatValue]];
        
        bowlerCellTvc.lbl_bowler_name.text = bowlingSummaryForScoreBoard.BOWLERNAME;
        
        bowlerCellTvc.lbl_bowler_over.text = bowlingSummaryForScoreBoard.OVERS;
        
        bowlerCellTvc.lbl_bowler_runs.text = bowlingSummaryForScoreBoard.RUNS;
        bowlerCellTvc.lbl_bowler_wide.text = bowlingSummaryForScoreBoard.WIDES;
        bowlerCellTvc.lbl_bowler_fours.text = bowlingSummaryForScoreBoard.FOURS;
        bowlerCellTvc.lbl_bowler_sixes.text = bowlingSummaryForScoreBoard.SIXES;
        bowlerCellTvc.lbl_bowler_maiden.text = bowlingSummaryForScoreBoard.MAIDENS;
        bowlerCellTvc.lbl_bowler_noball.text = bowlingSummaryForScoreBoard.NOBALLS;
        bowlerCellTvc.lbl_bowler_wicket.text = bowlingSummaryForScoreBoard.WICKETS;
        
        
        return bowlerCellTvc;
        
    }
    
    
    
    return nil;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 44;
    }else if(batsmanPostion <= indexPath.row && bowlerHeaderPosition>indexPath.row){
        
        return 70;
    }
    else if(bowlerHeaderPosition == indexPath.row){
        return 44;
    }
    else if(indexPath.row >= bowlerPostion){
        return 70;
    }
    
    return 70;
}

//-(void)teamLogo{
//    //logo image
//    NSMutableArray *teamCode = [[NSMutableArray alloc]init];
//
//    [teamCode addObject:@"TEA0000005"];
//    [teamCode addObject:@"TEA0000006"];
//    [teamCode addObject:@"TEA0000008"];
//
//
//    for(int i=0;i<[teamCode count];i++){
//
//        [self addImageInAppDocumentLocation:[teamCode objectAtIndex:i]];
//    }
//
//
//
//    NSMutableArray *mTeam = [[NSMutableArray alloc]init];
//    [mTeam addObject:self.matchCode];
//    [mTeam addObject:self.teamAcode];
//
//
//    self.selectedTeamFilterArray = [[NSMutableArray alloc]initWithArray: self.selectedTeamArray];
//
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,self.teamAcode];
//
//
//    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
//    UIImage *img;
//    if(isFileExist){
//        img = [UIImage imageWithContentsOfFile:pngFilePath];
//        self.img_firstIngsTeamName.image = img;
//    }else{
//        img  = [UIImage imageNamed: @"no_image.png"];
//        _img_firstIngsTeamName.image = img;
//    }
//
//
//
//
//    NSFileManager *fileManagerB = [NSFileManager defaultManager];
//    NSString *docDirB = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *pngFilePathB = [NSString stringWithFormat:@"%@/%@.png", docDirB,self.teamBcode];
//    BOOL isFileExistB = [fileManagerB fileExistsAtPath:pngFilePathB];
//    UIImage *imgB;
//    if(isFileExistB){
//        imgB = [UIImage imageWithContentsOfFile:pngFilePathB];
//        _img_secIngsTeamName.image = imgB;
//    }else{
//        imgB  = [UIImage imageNamed: @"no_image.png"];
//        _img_secIngsTeamName.image = imgB;
//    }
//}
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
//
////Check given file name exist in document directory
//- (BOOL) checkFileExist:(NSString*) fileName{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
//    NSString *documentsDir = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
//    return [fileManager fileExistsAtPath:filePath];
//}

- (IBAction)btn_fst_inns_action:(id)sender {
    self.lbl_strip.constant=0;
    inningsNo = @"1";
    [self reloadScroeCard];
    
}
- (IBAction)btn_sec_inns_action:(id)sender {
    self.lbl_strip.constant=self.btn_sec_inns_id.frame.origin.x;
    inningsNo = @"2";
    [self reloadScroeCard];
}
- (IBAction)btn_third_inns_action:(id)sender {
    self.lbl_strip.constant=self.btn_third_inns_id.frame.origin.x;
    inningsNo = @"3";
    [self reloadScroeCard];
}
- (IBAction)btn_fourth_inns_action:(id)sender {
    self.lbl_strip.constant=self.btn_fourth_inns_id.frame.origin.x;
    inningsNo = @"4";
    [self reloadScroeCard];
}






-(void) reloadScroeCard{
    @try {
        fetchScorecard = [[FetchScorecard alloc]init];
        [fetchScorecard FetchScoreBoard:competitionCode :matchCode :inningsNo];
        //Set Table Cell Position
        batsmanHeaderPosition = 0;
        batsmanPostion =fetchScorecard.BattingSummaryForScoreBoard.count > 0 ? 1 :0;
        bowlerHeaderPosition =fetchScorecard.BattingSummaryForScoreBoard.count>0?fetchScorecard.BattingSummaryForScoreBoard.count+1:1;
        bowlerPostion = bowlerHeaderPosition+1;
        
        [_tbl_scorecard reloadData];
    }
    @catch (NSException *exception) {
    }
    
    
    
}
@end
