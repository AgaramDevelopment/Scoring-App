//
//  SpiderWagonReportVC.m
//  CAPScoringApp
//
//  Created by Raja sssss on 22/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SpiderWagonReportVC.h"
#import "DBManagerSpiderWagonReport.h"
#import "DBManagerpitchmapReport.h"
#import "SpiderWagonRecords.h"
#import "Utitliy.h"
#import "StrikerDetails.h"

@interface SpiderWagonReportVC ()
{
    BOOL isStriker;
    BOOL isBowler;
    DBManagerSpiderWagonReport *objDBManagerSpiderWagonReport;
    DBManagerpitchmapReport *objDBManagerpitchmapReport;
    
}

@property (nonatomic,strong) NSMutableArray *spiderWagonArray;

@property (nonatomic,strong) NSMutableArray * bowlerArray;
@property (nonatomic,strong) NSMutableArray * strikerArray;

@end

@implementation SpiderWagonReportVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.filter_view.hidden =YES;
    
    
    [self.striker_view .layer setBorderWidth:2.0];
    [self.striker_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.striker_view .layer setMasksToBounds:YES];
    
    
    [self.bowler_view .layer setBorderWidth:2.0];
    [self.bowler_view.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.bowler_view .layer setMasksToBounds:YES];
    
     self.tbl_players.hidden=YES;
    
    objDBManagerSpiderWagonReport = [[DBManagerSpiderWagonReport alloc]init];
    objDBManagerpitchmapReport =[[DBManagerpitchmapReport alloc]init];
    
 self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
    
 _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon :self.matchTypeCode :self.compititionCode :self.matchCode :self.teamCode:@"" :@"" :@"" :@"" :@"" :@"" :@""];
    
    
//     _spiderWagonArray =[objDBManagerSpiderWagonReport getSpiderWagon:self.matchTypeCode :self.compititionCode :self.matchCode :@"" :INNINGSNO :STRIKERCODE :NONSTRIKERCODE :BOWLERCODE :RUNS :ISFOUR :ISSIX];

    [self drawSpiderWagonLine];
    
    
}



-(void)drawSpiderWagonLine{
    
    int x1position;
    int y1position;
    int x2position;
    int y2position;
    
    for(int i=0; i< _spiderWagonArray.count;i++)
    {
        SpiderWagonRecords * objRecord =(SpiderWagonRecords *)[_spiderWagonArray objectAtIndex:i];
        
        
        x1position = [objRecord.WWX1 intValue];
        y1position = [objRecord.WWY1 intValue];
        x2position  =[objRecord.WWX2 intValue];
        y2position  =[objRecord.WWY2 intValue];
        
        
//        if(!(x1position ==221 && x2position ==221 && y1position ==186 && y2position ==186) && !(x1position ==172 && x2position ==172 && y1position ==145 && y2position ==145)){
        
            
            int Xposition = x1position+7;
            int Yposition = y1position+4;
            
            CGMutablePathRef straightLinePath = CGPathCreateMutable();
            CGPathMoveToPoint(straightLinePath, NULL, Xposition, Yposition);
            CGPathAddLineToPoint(straightLinePath, NULL,x2position+7,y2position+4);
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = straightLinePath;
            UIColor *fillColor = [UIColor redColor];
            shapeLayer.fillColor = fillColor.CGColor;
            UIColor *strokeColor = [UIColor colorWithRed:(255/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0f];
            shapeLayer.strokeColor = strokeColor.CGColor;
            shapeLayer.lineWidth = 2.0f;
            shapeLayer.fillRule = kCAFillRuleNonZero;
            shapeLayer.name = @"DrawLine";
            [_img_wagon.layer addSublayer:shapeLayer];
            
        //}
        
    }
    
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

- (IBAction)btn_first_inns:(id)sender {
    
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"1"];
}

- (IBAction)btn_sec_inns:(id)sender {
    
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"2"];
}

- (IBAction)btn_third_inns:(id)sender {
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"3"];
}

- (IBAction)btn_fourth_inns:(id)sender {
    
    self.teamCode =[objDBManagerpitchmapReport getTeamCode:self.compititionCode :self.matchCode :@"4"];
}

- (IBAction)hide_Filer_view:(id)sender {
    
     self.filter_view.hidden =NO;
}

- (IBAction)didClickStricker:(id)sender {
    
    self.strikerTblYposition.constant =self.striker_view.frame.origin.y;
    self.strikerArray=[[NSMutableArray alloc]init];
    self.strikerArray= [objDBManagerpitchmapReport getStrickerdetail:self.matchCode :_teamCode];
    
    if(isStriker==NO)
    {
        
        self.tbl_players.hidden=NO;
        isStriker=YES;
        
    }
    else
    {
        self.tbl_players.hidden=YES;
        isStriker=NO;
    }
    isBowler=NO;
   
    [self.tbl_players reloadData];

    
}

- (IBAction)didClickBowler:(id)sender {
    
    self.strikerTblYposition.constant = self.bowler_view.frame.origin.y;
    self.bowlerArray=[[NSMutableArray alloc]init];
    self.bowlerArray= [objDBManagerpitchmapReport getStrickerdetail:self.matchCode :_teamCode];
    
    if(isBowler==NO)
    {
        
        self.tbl_players.hidden=NO;
        isBowler=YES;
        
    }
    else
    {
        self.tbl_players.hidden=YES;
        isBowler=NO;
    }
    isStriker=NO;
    
    [self.tbl_players reloadData];

    
}

- (IBAction)demo_Ww:(id)sender {
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(isStriker == YES)
    {
        return self.strikerArray.count;
    }
    else if(isBowler == YES)
    {
        return self.bowlerArray.count;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    if(isStriker == YES)
    {
        
        StrikerDetails * objStriker =[self.strikerArray objectAtIndex:indexPath.row];
        cell.textLabel.text =objStriker.playername;
    }
    else if(isBowler == YES)
    {
        StrikerDetails * objStriker =[self.bowlerArray objectAtIndex:indexPath.row];
        cell.textLabel.text = objStriker.playername;

    }
 
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isStriker == YES)
    {
        
        StrikerDetails * objStriker =[self.strikerArray objectAtIndex:indexPath.row];
        self.lbl_striker.text = objStriker.playername;
        self.selectStrikerCode =objStriker.playercode;
        self.tbl_players.hidden=YES;
        
    }
    else if(isBowler == YES)
    {
        StrikerDetails * objBowler =[self.bowlerArray objectAtIndex:indexPath.row];
        self.selectBowlerCode= objBowler.playercode;
        _lbl_bowler.text = objBowler.playername;
        self.tbl_players.hidden = YES;
    }
    
}



@end
