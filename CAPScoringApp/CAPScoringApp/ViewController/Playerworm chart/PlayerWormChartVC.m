//
//  PlayerWormChartVC.m
//  CAPScoringApp
//
//  Created by Mac on 26/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerWormChartVC.h"
#import "BvsBBatsman.h"
#import "PlayerWormChart.h"
#import "MCMultiLineChartView.h"
#import "PlayerWormChartRecords.h"


@interface PlayerWormChartVC () <MCMultiLineChartViewDataSource, MCMultiLineChartViewDelegate>{
    
    BOOL isStriker;
    // NSString *selectedFilterStricker;
    BvsBBatsman *selectedFilterBatsman;
    int selectedBatsmanPosition;
    int selectedInningsPosition;
    
    NSString *fstInningsHighScore;
    NSString *secInningsHighScore;


}
@property (strong, nonatomic) MCMultiLineChartView *lineChartViewOne;
@property (strong, nonatomic) MCMultiLineChartView *lineChartViewTwo;


@property(strong,nonatomic)NSMutableArray *playerWormInninsOneArray;
@property(strong,nonatomic)NSMutableArray *playerWormInninsTwoArray;

@property(strong,nonatomic)NSMutableArray *batsmanFilterInnsOneArray;
@property(strong,nonatomic)NSMutableArray *batsmanFilterInnsTwoArray;


@end

@implementation PlayerWormChartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view_filter_batsman .layer setBorderWidth:2.0];
    [self.view_filter_batsman.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_filter_batsman .layer setMasksToBounds:YES];
    
    [self setInningsView];
    [self setInningsBySelection:@"1"];
    self.tableview_batsman.separatorColor = [UIColor clearColor];
    
    self.tableview_batsman.separatorColor = [UIColor clearColor];
    self.tableview_batsman.hidden=YES;
    
    self.view_filter.hidden=YES;
    
    PlayerWormChart *playerWC = [[PlayerWormChart alloc]init];
    
    [playerWC fetchPlayerWormChart : self.compititionCode :self.matchCode ];
    
    
    self.playerWormInninsOneArray = [[NSMutableArray alloc] init];
    self.playerWormInninsTwoArray = [[NSMutableArray alloc] init];
    
    self.batsmanFilterInnsOneArray = [[NSMutableArray alloc] init];
    self.batsmanFilterInnsTwoArray = [[NSMutableArray alloc] init];
    
    
    NSMutableArray *xAxisValuesFstInns = [[NSMutableArray alloc]init];
    NSMutableArray *xAxisValuesSecInns = [[NSMutableArray alloc]init];

    
    fstInningsHighScore = @"0";
    secInningsHighScore = @"0";
    selectedInningsPosition =1;
    
    BvsBBatsman *allBatsMan = [[BvsBBatsman alloc]init];
    allBatsMan.name = @"Select Player";
    allBatsMan.strickerCode = @"";
    
    selectedFilterBatsman = allBatsMan;
    
    [self.batsmanFilterInnsOneArray addObject:allBatsMan];
    [self.batsmanFilterInnsTwoArray addObject:allBatsMan];
    
    
    
    for(int i=0;i<playerWC.playerWormList.count;i++){
        
        PlayerWormChartRecords *record= [playerWC.playerWormList objectAtIndex:i];
        
        if([record.INNINGSNO isEqual:@"1"]){
            
            fstInningsHighScore = fstInningsHighScore.intValue> record.STRIKERRUNS.intValue ? fstInningsHighScore : record.STRIKERRUNS;
            
            [xAxisValuesFstInns addObject:record];
            
            
            int fetchPosition = 0;
            bool flag = NO;
            
            for(int j=0;j<self.batsmanFilterInnsOneArray.count;j++){
                BvsBBatsman *batsMan = [self.batsmanFilterInnsOneArray objectAtIndex:j];

                if([batsMan.strickerCode isEqualToString:record.STRIKERCODE]){
                    flag = YES;
                    fetchPosition = j-1;
                    break;
                }
            }
            
            if(!flag){
            BvsBBatsman *batsMan = [[BvsBBatsman alloc]init];
            batsMan.name = record.STRIKERNAME;
            batsMan.strickerCode = record.STRIKERCODE;
            
            [self.batsmanFilterInnsOneArray addObject:batsMan];
            
            NSMutableArray  *subplayerWormInninsOneArray = [[NSMutableArray alloc] init];
            [subplayerWormInninsOneArray addObject:record];
            [self.playerWormInninsOneArray addObject:subplayerWormInninsOneArray];

            }else{
                NSMutableArray  *subplayerWormInninsOneArray = [self.playerWormInninsOneArray objectAtIndex:fetchPosition];
                [subplayerWormInninsOneArray addObject:record];
            }
            
            
        }else{
            [xAxisValuesSecInns addObject:record];

            int fetchPosition = 0;
            bool flag = NO;
            
            for(int j=0;j<self.batsmanFilterInnsTwoArray.count;j++){
                BvsBBatsman *batsMan = [self.batsmanFilterInnsTwoArray objectAtIndex:j];
                
                if([batsMan.strickerCode isEqualToString:record.STRIKERCODE]){
                    flag = YES;
                    fetchPosition = j-1;
                    break;
                }
                
                
            }
            
            if(!flag){
                BvsBBatsman *batsMan = [[BvsBBatsman alloc]init];
                batsMan.name = record.STRIKERNAME;
                batsMan.strickerCode = record.STRIKERCODE;
                
                [self.batsmanFilterInnsTwoArray addObject:batsMan];
                
                
                NSMutableArray  *subplayerWormInninsTwoArray = [[NSMutableArray alloc] init];
                [subplayerWormInninsTwoArray addObject:record];
                [self.playerWormInninsTwoArray addObject:subplayerWormInninsTwoArray];
                
            }else{
                NSMutableArray  *subplayerWormInninsTwoArray = [self.playerWormInninsTwoArray objectAtIndex:fetchPosition];
                [subplayerWormInninsTwoArray addObject:record];
            }


        }
        
        
        
    }
    
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"XAXIS" ascending:YES];
    [xAxisValuesFstInns sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [xAxisValuesSecInns sortUsingDescriptors:[NSArray arrayWithObject:sort]];

    
   // [xAxisValuesFstInns sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
   // [xAxisValuesSecInns sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    
        if([self.playerWormInninsOneArray count]>0){
            [self.playerWormInninsOneArray insertObject:xAxisValuesFstInns atIndex:0];
            [self setChartOne];
        }
    
    if([self.playerWormInninsTwoArray count]>0){
        
        [self.playerWormInninsTwoArray insertObject:xAxisValuesSecInns atIndex:0];

    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setChartOne{
    

    
    if(self.lineChartViewTwo != nil){
        self.lineChartViewTwo.hidden = YES;
    }
    
    if(self.lineChartViewOne==nil){
    
    self.lineChartViewOne = [[MCMultiLineChartView alloc] initWithFrame:CGRectMake(20, 150, [UIScreen mainScreen].bounds.size.width-40, 300)];
    
    self.lineChartViewOne.dotRadius = 5;
    self.lineChartViewOne.dataSource = self;
    self.lineChartViewOne.delegate = self;
    self.lineChartViewOne.minValue = @1;
    self.lineChartViewOne.maxValue = fstInningsHighScore;
    self.lineChartViewOne.solidDot = YES;
    self.lineChartViewOne.numberOfYAxis = 7;
    
    //self.lineChartViewInnsOne.unitOfYAxis = @"Score";
    self.lineChartViewOne.colorOfXAxis = [UIColor whiteColor];
    self.lineChartViewOne.colorOfXText = [UIColor whiteColor];
    self.lineChartViewOne.colorOfYAxis = [UIColor whiteColor];
    self.lineChartViewOne.colorOfYText = [UIColor whiteColor];
    
    [self.view addSubview:self.lineChartViewOne];
    }else{
        self.lineChartViewOne.hidden = NO;
    }
    
    
    UIView * tittleview =[[UIView alloc]initWithFrame:CGRectMake(_lineChartViewOne.frame.origin.x, _lineChartViewOne.frame.origin.y-60,self.lineChartViewOne.frame.size.width, 60)];
    
    UILabel * title_lbl =[[UILabel alloc]initWithFrame:CGRectMake(0, 10,self.lineChartViewOne.frame.size.width, 30)];
    
    
    title_lbl.text =@"INNING 1 & 2";
    title_lbl.textColor =[UIColor whiteColor];
    title_lbl.textAlignment=UITextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:25];
    
    //[tittleview addSubview:title_lbl];
    
    UILabel * BattingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(60,title_lbl.frame.origin.y+30,70, 30)];
    BattingTeam_lbl.text =self.fstInnShortName;
    BattingTeam_lbl.backgroundColor= [UIColor  colorWithRed:(218/255.0f) green:(61/255.0f) blue:(67/255.0f) alpha:1.0f];
    BattingTeam_lbl.textColor =[UIColor whiteColor];
    BattingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BattingTeam_lbl.font = [UIFont systemFontOfSize:23];
    
    
   // [tittleview addSubview:BattingTeam_lbl];
    
    UILabel * BowlingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(self.lineChartViewOne.frame.size.width-120,title_lbl.frame.origin.y+30,70, 30)];
    BowlingTeam_lbl.text =self.secInnShortName;
    BowlingTeam_lbl.backgroundColor=[UIColor  colorWithRed:(35/255.0f) green:(116/255.0f) blue:(203/255.0f) alpha:1.0f];
    BowlingTeam_lbl.textColor =[UIColor whiteColor];
    BowlingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BowlingTeam_lbl.font = [UIFont systemFontOfSize:23];
    
    
  //  [tittleview addSubview:BowlingTeam_lbl];
    
    [self.view addSubview:tittleview];
    
    
    
    [self.lineChartViewOne reloadDataWithAnimate:YES];
}



-(void) setChartTwo{
    
    
    if(self.lineChartViewOne != nil){
        self.lineChartViewOne.hidden = YES;
    }
    
    if(self.lineChartViewTwo==nil){
        
        self.lineChartViewTwo = [[MCMultiLineChartView alloc] initWithFrame:CGRectMake(20, 150, [UIScreen mainScreen].bounds.size.width-40, 300)];
        
        self.lineChartViewTwo.dotRadius = 5;
        self.lineChartViewTwo.dataSource = self;
        self.lineChartViewTwo.delegate = self;
        self.lineChartViewTwo.minValue = @1;
        self.lineChartViewTwo.maxValue = fstInningsHighScore;
        self.lineChartViewTwo.solidDot = YES;
        self.lineChartViewTwo.numberOfYAxis = 7;
        
        //self.lineChartViewInnsOne.unitOfYAxis = @"Score";
        self.lineChartViewTwo.colorOfXAxis = [UIColor whiteColor];
        self.lineChartViewTwo.colorOfXText = [UIColor whiteColor];
        self.lineChartViewTwo.colorOfYAxis = [UIColor whiteColor];
        self.lineChartViewTwo.colorOfYText = [UIColor whiteColor];
        
        [self.view addSubview:self.lineChartViewTwo];
    }else{
        self.lineChartViewTwo.hidden = NO;
    }
    
    
    UIView * tittleview =[[UIView alloc]initWithFrame:CGRectMake(_lineChartViewTwo.frame.origin.x, _lineChartViewTwo.frame.origin.y-60,self.lineChartViewTwo.frame.size.width, 60)];
    
    UILabel * title_lbl =[[UILabel alloc]initWithFrame:CGRectMake(0, 10,self.lineChartViewTwo.frame.size.width, 30)];
    
    
    title_lbl.text =@"INNING 1 & 2";
    title_lbl.textColor =[UIColor whiteColor];
    title_lbl.textAlignment=UITextAlignmentCenter;
    title_lbl.font = [UIFont systemFontOfSize:25];
    
    //[tittleview addSubview:title_lbl];
    
    UILabel * BattingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(60,title_lbl.frame.origin.y+30,70, 30)];
    BattingTeam_lbl.text =self.fstInnShortName;
    BattingTeam_lbl.backgroundColor= [UIColor  colorWithRed:(218/255.0f) green:(61/255.0f) blue:(67/255.0f) alpha:1.0f];
    BattingTeam_lbl.textColor =[UIColor whiteColor];
    BattingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BattingTeam_lbl.font = [UIFont systemFontOfSize:23];
    
    
    // [tittleview addSubview:BattingTeam_lbl];
    
    UILabel * BowlingTeam_lbl =[[UILabel alloc]initWithFrame:CGRectMake(self.lineChartViewTwo.frame.size.width-120,title_lbl.frame.origin.y+30,70, 30)];
    BowlingTeam_lbl.text =self.secInnShortName;
    BowlingTeam_lbl.backgroundColor=[UIColor  colorWithRed:(35/255.0f) green:(116/255.0f) blue:(203/255.0f) alpha:1.0f];
    BowlingTeam_lbl.textColor =[UIColor whiteColor];
    BowlingTeam_lbl.textAlignment=UITextAlignmentCenter;
    BowlingTeam_lbl.font = [UIFont systemFontOfSize:23];
    
    
    //  [tittleview addSubview:BowlingTeam_lbl];
    
    [self.view addSubview:tittleview];
    
    
    
    [self.lineChartViewTwo reloadDataWithAnimate:YES];
}

-(void) setViewWhenNoData{
    self.view_open_filter.hidden = YES;
    self.view_filter.hidden=YES;
}


-(void) setViewWhenDataPresent{
    self.view_open_filter.hidden = NO;
    self.view_filter.hidden=YES;
}

- (IBAction)did_click_inn_one:(id)sender {
    
    
    selectedBatsmanPosition = 0;
    selectedInningsPosition = 1;
    
    
    BvsBBatsman *allBatsMan = [[BvsBBatsman alloc]init];
    allBatsMan.name = @"Select Player";
    allBatsMan.strickerCode = @"";
    
    selectedFilterBatsman = allBatsMan;

    if([self.playerWormInninsOneArray count]>0){
        [self setChartOne];
    }else if(self.lineChartViewTwo !=nil){
        _lineChartViewTwo.hidden = YES;
    }

    
    [self setInningsBySelection:@"1"];
    [_tableview_batsman reloadData];

}

- (IBAction)did_click_inn_two:(id)sender {

    selectedBatsmanPosition = 0;
    selectedInningsPosition = 2;
    
    
    BvsBBatsman *allBatsMan = [[BvsBBatsman alloc]init];
    allBatsMan.name = @"Select Player";
    allBatsMan.strickerCode = @"";
    
    selectedFilterBatsman = allBatsMan;

    if([self.playerWormInninsTwoArray count]>0){
        [self setChartTwo];
    }else if(self.lineChartViewOne !=nil){
        _lineChartViewOne.hidden = YES;
    }
    
    [self setInningsBySelection:@"2"];
[_tableview_batsman reloadData];
    
}

- (IBAction)did_click_inn_three:(id)sender {
    
 //   [self setInningsDetailsView:@"3"];
}

- (IBAction)did_click_inn_four:(id)sender {
 //   [self setInningsDetailsView:@"4"];
}

-(void) setInningsBySelection: (NSString*) innsNo{
    
    [self setInningsButtonUnselect:self.inns_one];
    [self setInningsButtonUnselect:self.inns_two];
    [self setInningsButtonUnselect:self.inns_three];
    [self setInningsButtonUnselect:self.inns_four];
    
    [self.inns_one setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.fstInnShortName] forState:UIControlStateNormal];
    [self.inns_two setTitle:[NSString stringWithFormat:@"%@ 1st INNS",self.secInnShortName] forState:UIControlStateNormal];
    [self.inns_three setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.thrdInnShortName] forState:UIControlStateNormal];
    [self.inns_four setTitle:[NSString stringWithFormat:@"%@ 2nd INNS",self.frthInnShortName] forState:UIControlStateNormal];
    
    if([innsNo isEqualToString:@"1"]){
        
        [self setInningsButtonSelect:self.inns_one];
        
    }else if([innsNo isEqualToString:@"2"]){
        
        [self setInningsButtonSelect:self.inns_two];
        
    }else if([innsNo isEqualToString:@"3"]){
        
        [self setInningsButtonSelect:self.inns_three];
        
    }else if([innsNo isEqualToString:@"4"]){
        
        [self setInningsButtonSelect:self.inns_four];
        
    }
}




-(void) setInningsView{
    if([self.matchTypeCode isEqual:@"MSC116"] || [self.matchTypeCode isEqual:@"MSC024"]){//T20
        
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = YES;
        self.inns_four.hidden = YES;
        
        //   [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //[self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        self.inns_two_width.constant = 384;
        self.inns_one_width.constant = 384;
        
        
    }else if([self.matchTypeCode isEqual:@"MSC115"] || [self.matchTypeCode isEqual:@"MSC022"]){//ODI
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = YES;
        self.inns_four.hidden = YES;
        self.inns_two_width.constant = 384;
        self.inns_one_width.constant = 384;
        
        //     [self.inns_one setFrame:CGRectMake(0, 0, 160, 50)];
        //    [self.inns_two setFrame:CGRectMake(160, 0, 160, 50)];
        
    }else if([self.matchTypeCode isEqual:@"MSC114"] || [self.matchTypeCode isEqual:@"MSC023"]){//Test
        
        self.inns_one.hidden = NO;
        self.inns_two.hidden = NO;
        self.inns_three.hidden = NO;
        self.inns_four.hidden = NO;
    }
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0f];
    
    return color;
}



-(void) setInningsButtonSelect : (UIButton*) innsBtn{
    // innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#2374CD"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}

-(void) setInningsButtonUnselect : (UIButton*) innsBtn{
    //  innsBtn.layer.cornerRadius = 25;
    UIColor *extrasBrushBG = [self colorWithHexString : @"#000000"];
    
    innsBtn.layer.backgroundColor = extrasBrushBG.CGColor;
    
}





- (IBAction)did_click_filter_batsman:(id)sender {
    
    if(isStriker==NO)
    {
        
        self.tableview_batsman.hidden=NO;
        isStriker=YES;
        
    }
    else
    {
        self.tableview_batsman.hidden=YES;
        isStriker=NO;
    }
    
}
- (IBAction)did_click_open_filter:(id)sender {
    if([selectedFilterBatsman.strickerCode isEqual:@""]){
        selectedBatsmanPosition = 0;
    }
    self.view_filter.hidden =NO;
    self.view_open_filter.hidden = YES;
    self.lbl_filter_batsman_name.text = selectedFilterBatsman.name;
    
   
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.tableview_batsman){
        if(selectedInningsPosition == 1){
        return [self.batsmanFilterInnsOneArray count];
        }else if(selectedInningsPosition == 2){
            return [self.batsmanFilterInnsTwoArray count];

        }
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableview_batsman){
        
        
        
        //Other Cells
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        
        BvsBBatsman *bvsBBatsman = [self.batsmanFilterInnsOneArray objectAtIndex:indexPath.row];
        
        
        if(selectedInningsPosition == 1){
            bvsBBatsman = [self.batsmanFilterInnsOneArray objectAtIndex:indexPath.row];
        }else if(selectedInningsPosition == 2){
            bvsBBatsman = [self.batsmanFilterInnsTwoArray objectAtIndex:indexPath.row];
            
        }
        
        
        cell.textLabel.text = [bvsBBatsman name];
        
        
        
        return cell;
        
        
        
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableview_batsman){
        
        selectedBatsmanPosition = indexPath.row;
        
        BvsBBatsman *bvsBBatsman;
        
        if(selectedInningsPosition == 1){
            bvsBBatsman = [self.batsmanFilterInnsOneArray objectAtIndex:indexPath.row];
        }else if(selectedInningsPosition == 2){
            bvsBBatsman = [self.batsmanFilterInnsTwoArray objectAtIndex:indexPath.row];
            
        }
        
        _lbl_filter_batsman_name.text = bvsBBatsman.name;
        self.tableview_batsman.hidden=YES;
        
        isStriker=NO;
        
        
    }
}


- (IBAction)did_click_filter_ok:(id)sender {
    
    
    self.tableview_batsman.hidden=YES;
    isStriker=NO;
    
    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;
    
    
    BvsBBatsman *bvsBBatsman = [self.batsmanFilterInnsOneArray objectAtIndex:selectedBatsmanPosition];
    
    selectedFilterBatsman = bvsBBatsman;
    
    if(selectedInningsPosition ==1 ){
        [_lineChartViewOne reloadDataWithAnimate:YES];

    }else if(selectedInningsPosition == 2){
        [_lineChartViewTwo reloadDataWithAnimate:YES];

    }
    
    


    
}
- (IBAction)did_click_close_filter:(id)sender {
    
    self.tableview_batsman.hidden=YES;
    isStriker=NO;
    
    self.view_filter.hidden =YES;
    self.view_open_filter.hidden = NO;
    
}



- (NSUInteger)numberOfLinesInLineChartView:(MCMultiLineChartView *)lineChartView {
    
    if(lineChartView == _lineChartViewOne){

    if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
        return self.playerWormInninsOneArray.count;
    }else{
        return 2;
    }

    }else if(lineChartView == _lineChartViewTwo){
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            return self.playerWormInninsTwoArray.count;
        }else{
            return 2;
        }
    }
    
    return 0;
}

- (NSUInteger)lineChartView:(MCMultiLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number {
    
    if(lineChartView == _lineChartViewOne){
        
        
        
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            
            NSMutableArray * subArray = [self.playerWormInninsOneArray objectAtIndex:number];
            
            return subArray.count;
        }else{
            NSMutableArray * subArray = [self.playerWormInninsOneArray objectAtIndex:selectedBatsmanPosition];
            return subArray.count;

        }
        
        
        
    }else if(lineChartView == _lineChartViewTwo){
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            
            NSMutableArray * subArray = [self.playerWormInninsTwoArray objectAtIndex:number];
        
            return subArray.count;
        }else{
            
            NSMutableArray * subArray = [self.playerWormInninsTwoArray objectAtIndex:selectedBatsmanPosition];

            return subArray.count;

        }
    }
    return 0;
}

- (id)lineChartView:(MCMultiLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    
    if(lineChartView == _lineChartViewOne){
        
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied

        NSMutableArray * subArray = [self.playerWormInninsOneArray objectAtIndex:lineNumber];
        PlayerWormChartRecords *record = [subArray objectAtIndex:index];
        return record.STRIKERRUNS;
        }else{
            NSMutableArray * subArray = [self.playerWormInninsOneArray objectAtIndex:selectedBatsmanPosition];
            PlayerWormChartRecords *record = [subArray objectAtIndex:index];
            return record.STRIKERRUNS;

        }
    }else if(lineChartView == _lineChartViewTwo){

        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            
            NSMutableArray * subArray = [self.playerWormInninsTwoArray objectAtIndex:lineNumber];
            PlayerWormChartRecords *record = [subArray objectAtIndex:index];
            return record.STRIKERRUNS;
        }else{
            NSMutableArray * subArray = [self.playerWormInninsTwoArray objectAtIndex:selectedBatsmanPosition];
            PlayerWormChartRecords *record = [subArray objectAtIndex:index];
            return record.STRIKERRUNS;
            
        }
        
    }
    return @"";
}

//- (NSString *)lineChartView:(MCMultiLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number {
- (NSString *)lineChartView:(MCMultiLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number :(NSInteger)linenumber :(NSInteger)dummy{
    
    
    if(lineChartView == _lineChartViewOne){
        NSMutableArray * subArray;

        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            subArray = [self.playerWormInninsOneArray objectAtIndex:linenumber];
        }else{
            subArray = [self.playerWormInninsOneArray objectAtIndex:selectedBatsmanPosition];

        }
        PlayerWormChartRecords *record = [subArray objectAtIndex:number];
        return [NSString stringWithFormat:@"%@.%@",record.ACTUALOVER,record.BALLNO];
        
        
    }else if(lineChartView == _lineChartViewTwo){
        
        NSMutableArray * subArray;
        
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            subArray = [self.playerWormInninsTwoArray objectAtIndex:linenumber];
        }else{
            subArray = [self.playerWormInninsTwoArray objectAtIndex:selectedBatsmanPosition];
            
        }
        PlayerWormChartRecords *record = [subArray objectAtIndex:number];
        return [NSString stringWithFormat:@"%@.%@",record.ACTUALOVER,record.BALLNO];
        
    }
    return @"";
    
}

- (UIColor *)lineChartView:(MCMultiLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber {
    if(lineNumber == 0){
        return     [UIColor  clearColor];
    }else if(lineNumber == 1){
        return     [UIColor  colorWithRed:(218/255.0f) green:(61/255.0f) blue:(67/255.0f) alpha:1.0f];
    }else if(lineNumber == 2){
        return     [UIColor  colorWithRed:(150/255.0f) green:(61/255.0f) blue:(67/255.0f) alpha:1.0f];
    }else if(lineNumber == 3){
        return     [UIColor  colorWithRed:(200/255.0f) green:(200/255.0f) blue:(67/255.0f) alpha:1.0f];
    }else if(lineNumber == 4){
        return     [UIColor  colorWithRed:(100/255.0f) green:(200/255.0f) blue:(100/255.0f) alpha:1.0f];
    }else if(lineNumber == 5){
        return     [UIColor  colorWithRed:(218/255.0f) green:(200/255.0f) blue:(200/255.0f) alpha:1.0f];
    }else if(lineNumber == 6){
        return     [UIColor  colorWithRed:(150/255.0f) green:(61/255.0f) blue:(150/255.0f) alpha:1.0f];
    }else if(lineNumber == 7){
        return     [UIColor  colorWithRed:(218/255.0f) green:(180/255.0f) blue:(200/255.0f) alpha:1.0f];
    }else if(lineNumber == 8){
        return     [UIColor  colorWithRed:(200/255.0f) green:(105/255.0f) blue:(67/255.0f) alpha:1.0f];
    }else if(lineNumber == 9){
        return     [UIColor  colorWithRed:(170/255.0f) green:(161/255.0f) blue:(100/255.0f) alpha:1.0f];
    }else if(lineNumber == 10){
        return     [UIColor  colorWithRed:(170/255.0f) green:(61/255.0f) blue:(60/255.0f) alpha:1.0f];
    }else if(lineNumber == 11){
        return     [UIColor  colorWithRed:(218/255.0f) green:(115/255.0f) blue:(120/255.0f) alpha:1.0f];
    }else{
        return     [UIColor  colorWithRed:(35/255.0f) green:(116/255.0f) blue:(203/255.0f) alpha:1.0f];
    }
    
}

- (NSString *)lineChartView:(MCMultiLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    //if (index == 0 || index == _dataSource.count - 1) {
    //  return [NSString stringWithFormat:@"%@", _dataSource[index]];
    //}
    return nil;
}

- (PlayerWormChartRecords *)lineChartView:(MCMultiLineChartView *)lineChartView informationOfWicketInSection:(NSInteger)lineNumber index:(NSInteger)index{
    
    
    
    if(lineChartView == _lineChartViewOne){
        NSMutableArray * subArray;
        
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied

            subArray = [self.playerWormInninsOneArray objectAtIndex:lineNumber];
            
        }else{
            subArray = [self.playerWormInninsOneArray objectAtIndex:selectedBatsmanPosition];
            
        }
        PlayerWormChartRecords *record = [subArray objectAtIndex:index];
        return record;
        
        
    }else if(lineChartView == _lineChartViewTwo){
        
        NSMutableArray * subArray;
        
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            subArray = [self.playerWormInninsTwoArray objectAtIndex:lineNumber];
        }else{
            subArray = [self.playerWormInninsTwoArray objectAtIndex:selectedBatsmanPosition];
            
        }
        PlayerWormChartRecords *record = [subArray objectAtIndex:index];
        return record;
        
    }
    return nil;
    
    
}


- (int)getStartIndex:(MCMultiLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number :(NSInteger)linenumber{
    
 
    
    
    
    if(lineChartView == _lineChartViewOne){
        NSMutableArray * subArray;
        
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            
            subArray = [self.playerWormInninsOneArray objectAtIndex:linenumber];
            
        }else{
            subArray = [self.playerWormInninsOneArray objectAtIndex:selectedBatsmanPosition];
            
        }
        
        if(subArray.count>0){
            PlayerWormChartRecords *recordFst = [subArray objectAtIndex:number];
            NSMutableArray * firstSubArray;
            if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied

             firstSubArray = [self.playerWormInninsOneArray objectAtIndex:0];
            }else{
                firstSubArray = [self.playerWormInninsOneArray objectAtIndex:selectedBatsmanPosition];

            }
            
            
            for(int i=0;i<firstSubArray.count;i++){
                
                PlayerWormChartRecords *record = [firstSubArray objectAtIndex:i];
                
                
                if([recordFst.XAXIS isEqual:record.XAXIS]){
                    return i+1;
                }
                
            }
            
        }
        
    }else if(lineChartView == _lineChartViewTwo){
        
        NSMutableArray * subArray;
        
        if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
            subArray = [self.playerWormInninsTwoArray objectAtIndex:linenumber];
        }else{
            subArray = [self.playerWormInninsTwoArray objectAtIndex:selectedBatsmanPosition];
            
        }
        if(subArray.count>0){
            PlayerWormChartRecords *recordFst = [subArray objectAtIndex:number];
            
            
            NSMutableArray * firstSubArray;
            if([selectedFilterBatsman.strickerCode isEqual:@""]){//Filter not applied
                
                firstSubArray = [self.playerWormInninsTwoArray objectAtIndex:0];
            }else{
                firstSubArray = [self.playerWormInninsTwoArray objectAtIndex:selectedBatsmanPosition];
                
            }
            
            for(int i=0;i<firstSubArray.count;i++){
                
                PlayerWormChartRecords *record = [firstSubArray objectAtIndex:i];
                
                
                if([recordFst.XAXIS isEqual:record.XAXIS]){
                    return i+1;
                }
                
            }
            
        }
        
    }
    return 1;

    
    
}


@end
