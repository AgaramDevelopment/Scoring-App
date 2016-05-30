//
//  NewMatchSetUpVC.m
//  CAPScoringApp
//
//  Created by mac on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "NewMatchSetUpVC.h"
#import "DBManager.h"
#import "FixturesRecord.h"
#import "TeamLogoRecords.h"
#import "SelectPlayersVC.h"
#import "MatchOfficalsVC.h"

@interface NewMatchSetUpVC ()

@property (nonatomic,strong)NSMutableArray *FetchCompitionArray;
@property (nonatomic,strong) NSMutableArray *selectedPlayerArray;
@property (nonatomic,strong) NSMutableArray *selectedPlayerFilterArray;

@end


@implementation NewMatchSetUpVC
@synthesize  matchCode;
@synthesize teamAcode;
@synthesize teamBcode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //fetch data from fixture screen and display in controls
    
    //self.matchTypeCode = @"MSC114";
    
    
    
    
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
    
    //logo image
    NSMutableArray *playersCode = [[NSMutableArray alloc]init];
    
    [playersCode addObject:@"PYC0000001"];
    [playersCode addObject:@"PYC0000002"];
    [playersCode addObject:@"PYC0000003"];
    [playersCode addObject:@"PYC0000004"];
    
    
    for(int i=0;i<[playersCode count];i++){
        
        [self addImageInAppDocumentLocation:[playersCode objectAtIndex:i]];
    }
    
    
    //        self.selectedPlayerArray =   [DBManager SelectTeamPlayers:self.matchCode teamCode:self.teamAcode];
    
    
    NSMutableArray *mTeam = [[NSMutableArray alloc]init];
    [mTeam addObject:self.matchCode];
    [mTeam addObject:self.teamAcode];
    
    
    
    
    self.selectedPlayerFilterArray = [[NSMutableArray alloc]initWithArray: self.selectedPlayerArray];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,@"PYC0000001"];
    
    
    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
    UIImage *img;
    if(isFileExist){
        img = [UIImage imageWithContentsOfFile:pngFilePath];
        self.img_teamALogo = img;
    }else{
        img  = [UIImage imageNamed: @"no_image.png"];
        _img_teamALogo = img;
    }
    
    
    
    
    NSFileManager *fileManagerB = [NSFileManager defaultManager];
    NSString *docDirB = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePathB = [NSString stringWithFormat:@"%@/%@.png", docDirB,self.teamAcode];
    BOOL isFileExistB = [fileManagerB fileExistsAtPath:pngFilePathB];
    UIImage *imgB;
    if(isFileExistB){
        imgB = [UIImage imageWithContentsOfFile:pngFilePathB];
        _img_teamBLogo = imgB;
    }else{
        imgB  = [UIImage imageNamed: @"no_image.png"];
        _img_teamBLogo = imgB;
    }
}
-(void) addImageInAppDocumentLocation:(NSString*) fileName{
    
    BOOL success = [self checkFileExist:fileName];
    
    if(!success) {//If file not exist
        
        UIImage  *newImage = [UIImage imageNamed:fileName];
        NSData *imageData = UIImagePNGRepresentation(newImage);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
        
        if (![imageData writeToFile:imagePath atomically:NO])
        {
            NSLog((@"Failed to cache image data to disk"));
        }else
        {
            NSLog(@"the cachedImagedPath is %@",imagePath);
        }
    }
}

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
    NSMutableArray *countTeamB = [DBManager SelectTeamPlayers:self.matchCode teamCode:self.teamBcode];
    
    if(countTeamB.count > 0){
        
        _view_teamB.backgroundColor = [UIColor colorWithRed:(114/255.0f) green:(114/255.0f) blue:(114/255.0f) alpha:(1)];
        
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectPlayersVC *selectvc =(SelectPlayersVC*) [storyBoard instantiateViewControllerWithIdentifier:@"SelectPlayers"];
    selectvc.teamCode=teamBcode;
    [selectvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:selectvc animated:NO completion:nil];
}

- (IBAction)btn_selectPlayersTeamA:(id)sender {
    
    //to change selected team players A color after selected 7 players
    NSMutableArray *countTeam = [DBManager SelectTeamPlayers:self.matchCode teamCode:self.teamAcode];
    
    if(countTeam.count > 0){
        
        _view_teamA.backgroundColor = [UIColor colorWithRed:(114/255.0f) green:(114/255.0f) blue:(114/255.0f) alpha:(1)];
        
    }
    
    NSLog(@"COUNT = %@",countTeam);
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectPlayersVC *selectvc =(SelectPlayersVC*) [storyBoard instantiateViewControllerWithIdentifier:@"SelectPlayers"];
      selectvc.teamCode=teamAcode;
    selectvc.matchCode = matchCode;
    [selectvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:selectvc animated:NO completion:nil];
    
    
}

- (IBAction)btn_edit:(id)sender {
    
    _view_overs.backgroundColor = [UIColor colorWithRed:(20/255.0f) green:(161/255.0f) blue:(79/255.0f) alpha:(1)];
    
    _txt_overs.enabled = YES;
    
}

- (IBAction)btn_proceed:(id)sender {
    
    [self overValidation];
    
    
    [DBManager updateOverInfo:self.txt_overs.text matchCode:self.matchCode competitionCode:self.competitionCode];
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MatchOfficalsVC *matchvc =(MatchOfficalsVC*) [storyBoard instantiateViewControllerWithIdentifier:@"matchofficial"];
    //matchvc.teamCode=teamAcode;
    matchvc.Matchcode = matchCode;
    [matchvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:matchvc animated:NO completion:nil];

    
    
}

/**
 * Show message for given title and cntent
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}

//Validation for over update validation
-(BOOL) overValidation{
    NSString *oversTxt = self.txt_overs.text;
    NSInteger twentyText = [oversTxt intValue];
    NSInteger OdiText = [oversTxt intValue];
    
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){
        if(twentyText > 20){
            [self showDialog:@"Please enter below 20 overs" andTitle:@"Error"];
        }else{
            [self showDialog:@"Updated successfully" andTitle:@"Message"];
        }
        return NO;
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){
        if(OdiText > 50){
            
            [self showDialog:@"Please enter below 50 overs" andTitle:@"Error"];
        }else {
            
            [self showDialog:@"Updated successfully" andTitle:@"Message"];
        }
        return NO;
        
    }
    return YES;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self viewDidLoad];
    
}
@end
