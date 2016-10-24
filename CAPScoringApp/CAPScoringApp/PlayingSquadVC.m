//
//  PlayingSquadVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayingSquadVC.h"
#import "CustomNavigationVC.h"
#import "PlayingSquadCell.h"
#import "DBManagerReports.h"
#import "PlayingSquadRecords.h"


@interface PlayingSquadVC ()

{
    CustomNavigationVC *objCustomNavigation;
    DBManagerReports *objDBManagerReports;
}
@property (nonatomic,strong) NSMutableArray *playerArray;
@property (nonatomic,strong) NSMutableArray *teamBplayerArray;

@end

@implementation PlayingSquadVC
@synthesize matchCode;
@synthesize teamAname;
@synthesize teamBname;
@synthesize venu;
@synthesize city;
@synthesize date;
@synthesize month;
@synthesize year;
@synthesize teamACode;
@synthesize teamBCode;
@synthesize matchType;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    objDBManagerReports = [[DBManagerReports alloc]init];
    

    _playerArray =[objDBManagerReports fetchPlayers: self.matchCode : teamACode];
    
    _teamBplayerArray = [objDBManagerReports fetchPlayers: self.matchCode : teamBCode];
    
    
    [self customnavigationmethod];
    [self fetchMatchdetails];
    [self setImage:self.teamACode :_img_teamA];
    [self setImage:self.teamBCode :_img_teamB];
    
    self.tbl_players.separatorColor = [UIColor clearColor];
    
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"PLAYING SQUAD";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void) setImage:(NSString *)teamCode :(UIImageView *)teamLogoImg {
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,teamCode];
    
    
    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
    UIImage *img;
    if(isFileExist){
        img = [UIImage imageWithContentsOfFile:pngFilePath];
        teamLogoImg.image = img;
    }else{
        img  = [UIImage imageNamed: @"no_image.png"];
        teamLogoImg.image = img;
    }
}


-(void)fetchMatchdetails{
    
    
    self.txt_hme_name.text = [NSString stringWithFormat:@"%@ in %@ - %@",teamAname,teamBname,matchType];
    self.txt_teamA.text = teamAname;
    self.txt_teamB.text = teamBname;
    self.txt_date_venu.text = [NSString stringWithFormat:@"%@ %@ %@ at %@,%@",date,month,year,venu,city];
    self.txt_teamA_heading.text = teamAname;
    self.txt_teamB_heading.text = teamBname;
 
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_playerArray count];
    return [_teamBplayerArray count];
    
    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *playingSquad = @"playingSquadCell";
    
    PlayingSquadCell *cell = [tableView dequeueReusableCellWithIdentifier:playingSquad
                                                             forIndexPath:indexPath];
    
        [cell setBackgroundColor:[UIColor clearColor]];
  
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PlayingSquadRecords *record = [_playerArray objectAtIndex:indexPath.row];
        PlayingSquadRecords *recordB = [_teamBplayerArray objectAtIndex:indexPath.row];
    
    
//    if ([_playerArray count] < indexPath.row) {
//        
//        
//        cell.txt_teamA_players.text = record.playerName;
//        cell.txt_teamB_players.text = recordB.playerName;
//        
//        
//    }else{
//        
//        cell.txt_teamA_players.text = @"";
//        cell.txt_teamB_players.text = @"";
//        
//    }
    
    
//    if ([_teamBplayerArray count]<indexPath.row) {
//        
//        
//        cell.txt_teamA_players.text = record.playerName;
//        cell.txt_teamB_players.text = recordB.playerName;
//
//        
//    }else{
//        
//        cell.txt_teamA_players.text = @"";
//        cell.txt_teamB_players.text = @"";
//
//    }
//
    
    
    cell.txt_teamA_players.text = record.playerName;
    cell.txt_teamB_players.text = recordB.playerName;
    
    
    //set icon for player roles - team A
    
    if ([record.playerRole isEqualToString:@"All Rounder"]) {
    
        cell.img_teamA.image = [UIImage imageNamed:@"ico_allrounder.png"];
        
        
    }
    
    if ([record.playerRole isEqualToString:@"Bowler"]) {
        
        cell.img_teamA.image = [UIImage imageNamed:@"ico_bowler.png"];
        
        
    }
    
    if ([record.playerRole isEqualToString:@"Batsman"]) {
        
        cell.img_teamA.image = [UIImage imageNamed:@"ico_batsmen.png"];
        
    }
    
    
    
      //set icon for player roles - team B
    if ([recordB.playerRole isEqualToString:@"All Rounder"]) {
        
        cell.img_teamB.image = [UIImage imageNamed:@"ico_allrounder.png"];
        
    }
    
    if ([recordB.playerRole isEqualToString:@"Bowler"]) {
        
       
        cell.img_teamB.image = [UIImage imageNamed:@"ico_bowler.png"];
        
    }
    
    if ([recordB.playerRole isEqualToString:@"Batsman"]) {
        
       
        cell.img_teamB.image = [UIImage imageNamed:@"ico_batsmen.png"];
    }
    
    
    
        //[self setImage:record.teamCode :cell.img_teamA];
        //[self setImage:record.teamBcode :cell.lbl_team_b_logo ];
    
        
        return cell;
    
    }



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 52;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

  
    
}

- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
