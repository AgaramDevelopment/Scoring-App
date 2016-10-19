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

@end

@implementation PlayingSquadVC
@synthesize  matchCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    objDBManagerReports = [[DBManagerReports alloc]init];
    

    _playerArray =[objDBManagerReports fetchPlayers: self.matchCode];
    
    [self customnavigationmethod];
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"PLAYING SQUAD";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(btn_back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_playerArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *playingSquad = @"PlayingSquadCell";
    

        PlayingSquadCell *cell = (PlayingSquadCell *)[tableView dequeueReusableCellWithIdentifier:playingSquad];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"PlayingSquadCell" owner:self options:nil];
            cell = self.playingSquadCell;
           
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        //tableView.allowsSelection = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PlayingSquadRecords *record = [_playerArray objectAtIndex:indexPath.row];
        
        cell.txt_teamA_players.text = record.playerName;
        //cell.txt_teamB_players.text = record.playerName;
        
    
    
        //[self setImage:record.teamCode :cell.img_teamA];
        //[self setImage:record.teamBcode :cell.lbl_team_b_logo ];
    
        
        return cell;
    
    }



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 160;
    
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
