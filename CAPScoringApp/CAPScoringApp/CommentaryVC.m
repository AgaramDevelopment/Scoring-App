//
//  CommentaryVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 20/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "CommentaryVC.h"
#import "DBManagerReports.h"
#import "CommentaryReport.h"

@interface CommentaryVC ()
@property (nonatomic,strong) NSMutableArray *commentaryArray;

@end

@implementation CommentaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentary_tableview.separatorColor = [UIColor clearColor];
    
    
    DBManagerReports *dbReports = [[DBManagerReports alloc]init];
    
    _commentaryArray = [dbReports retrieveCommentaryData:self.matchCode:@"1"];
    
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





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentaryArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==_commentary_tableview){
        static NSString * commentaryCell = @"commentry_cell";
        
        
        CommentaryReport *cmntryRpt = [_commentaryArray objectAtIndex:indexPath.row];
        
        CommentaryTVC *cell = (CommentaryTVC *)[tableView dequeueReusableCellWithIdentifier:commentaryCell];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CommentaryTVC" owner:self options:nil];
            cell = self.commentry_tvc;
        }
        
        
        
       [cell setBackgroundColor:[UIColor clearColor]];
      tableView.allowsSelection = NO;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
                
        cell.lbl_header_over.text = cmntryRpt.overString;
        cell.lbl_commentary.text = cmntryRpt.commentary;
        cell.lbl_team_score.text = cmntryRpt.teamTotal;
        cell.lbl_players_name.text = cmntryRpt.sAndNsName;
        cell.lbl_over.text = cmntryRpt.ballNo;
        if([cmntryRpt.isHeader isEqualToString:@"1"]){
            cell.view_header.hidden = NO;
        }else{
            cell.view_header.hidden = YES;
        }
        
        return cell;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentaryReport *cmntryRpt = [_commentaryArray objectAtIndex:indexPath.row];
    if([cmntryRpt.isHeader isEqualToString:@"1"]){
        return 200;
    }else{
        return 200-46;
    }
    
}

//
//- (void) CreateBallTickers: (NSMutableArray *) arrayBallDetails
//{
//    for (BallEventRecord *drballdetails in arrayBallDetails)
//    {
//        NSMutableArray* dicBallKeysArray = [[NSMutableArray alloc] init];
//        NSMutableDictionary *dicBall = [[NSMutableDictionary alloc] init];
//        int _overthrow = [drballdetails.objOverthrow intValue];
//        int _runs = [drballdetails.objRuns intValue] + _overthrow;
//        int _noball = [drballdetails.objNoball intValue];
//        int _wide = [drballdetails.objWide intValue];
//        int _legbyes = [drballdetails.objLegByes intValue];
//        int _byes = [drballdetails.objByes intValue];
//        
//        _noball = _noball > 1 ? _noball - 1 : _noball;
//        
//        if ([drballdetails.objIsFour intValue] == 1)//Boundary Four
//            [dicBall setValue:@"4" forKey: @"RUNS"];
//        else if ([drballdetails.objIssix intValue] == 1)//Boundary Six
//            [dicBall setValue:@"6" forKey: @"RUNS"];
//        else
//            [dicBall setValue:[NSString stringWithFormat:@"%i", _runs] forKey: @"RUNS"];
//        [dicBallKeysArray addObject:@"RUNS"];
//        if (_noball != 0)//Ball ticker for no balls.
//        {
//            if (_noball > 0)
//            {
//                [dicBall removeObjectForKey:@"RUNS"];
//                [dicBall setValue:[NSString stringWithFormat:@"%i", (_runs + _noball - 1)] forKey: @"RUNS"];
//            }
//            [dicBall setValue:@"NB" forKey: @"EXTRAS-NB"];
//            [dicBallKeysArray addObject:@"EXTRAS-NB"];
//        }
//        
//        if (_wide != 0)//Ball ticker for wide balls.
//        {
//            if (_wide > 0)
//            {
//                [dicBall removeObjectForKey:@"RUNS"];
//                [dicBall setValue:[NSString stringWithFormat:@"%i", (_wide - 1)] forKey: @"RUNS"];
//            }
//            [dicBall setValue:@"WD" forKey: @"EXTRAS"];
//            [dicBallKeysArray addObject:@"EXTRAS"];
//        }
//        
//        if (_legbyes != 0)//Ball ticker for leg byes.
//        {
//            if (_legbyes > 0)
//            {
//                [dicBall removeObjectForKey:@"RUNS"];
//                [dicBall setValue:[NSString stringWithFormat:@"%i", (_legbyes + /*_overthrow +*/ (_noball == 0 ? 0 : _noball - 1))] forKey: @"RUNS"];
//            }
//            if (_noball == 0)
//            {
//                [dicBall setValue:@"LB" forKey: @"EXTRAS"];
//                [dicBallKeysArray addObject:@"EXTRAS"];
//            }
//        }
//        
//        if (_byes != 0)//Ball ticker for byes.
//        {
//            if (_byes > 0)
//            {
//                [dicBall removeObjectForKey:@"RUNS"];
//                [dicBall setValue:[NSString stringWithFormat:@"%i", (_byes + /*_overthrow +*/ (_noball == 0 ? 0 : _noball - 1))] forKey: @"RUNS"];
//            }
//            if (_noball == 0)
//            {
//                [dicBall setValue:@"B" forKey: @"EXTRAS"];
//                [dicBallKeysArray addObject:@"EXTRAS"];
//            }
//        }
//        if ([drballdetails.objWicketno intValue] > 0)
//        {
//            if ([drballdetails.objWicketType  isEqual: @"MSC102"])
//                [dicBall setValue:@"RH" forKey: @"WICKETS"];
//            else
//                [dicBall setValue:@"W" forKey: @"WICKETS"];
//            [dicBallKeysArray addObject:@"WICKETS"];
//        }
//        //MSC134 - BATTING, MSC135 - BOWLING
//        int _penalty;
//        NSString* _penaltyLabel = drballdetails.objPenaltytypecode;
//        _penalty = [drballdetails.objPenalty intValue];
//        if (_penaltyLabel.length > 0 && _penalty > 0)
//        {
//            _penaltyLabel = [_penaltyLabel isEqual: @"MSC134"] ?
//            ([@"BP " stringByAppendingString: [NSString stringWithFormat:@"%i", _penalty]]) :
//            ([_penaltyLabel isEqual: @"MSC135"] ?
//             ([@"FP " stringByAppendingString: [NSString stringWithFormat:@"%i", _penalty]]) :
//             @"");
//            [dicBall setValue:_penaltyLabel forKey: @"PENALTY"];
//            [dicBallKeysArray addObject:@"PENALTY"];
//        }
//        
//        NSString* content = [[NSString alloc] init];
//        bool isExtras = false;
//        bool isSix = [drballdetails.objIssix intValue] == 1;
//        bool isFour = [drballdetails.objIsFour intValue] == 1;
//        bool isSpecialEvents = isFour || isSix || !([[NSString stringWithFormat:@"%i",[drballdetails.objWicketno intValue]]  isEqual: @"0"]);
//        
//        for(int i = 0; i < dicBallKeysArray.count; i++)
//        {
//            NSString *dicBallKey = [dicBallKeysArray objectAtIndex:i];
//            isExtras = [[dicBall objectForKey:dicBallKey] isEqual : @"WD"] ||
//            [[dicBall objectForKey:dicBallKey] isEqual : @"NB"] ||
//            [[dicBall objectForKey:dicBallKey] isEqual : @"B"] ||
//            [[dicBall objectForKey:dicBallKey] isEqual : @"LB"] ||
//            [[dicBall objectForKey:dicBallKey] isEqual : @"PENALTY"];
//            
//            if ([dicBallKey isEqual: @"RUNS"] && [[dicBall objectForKey:dicBallKey] isEqual : @"0"] && dicBall.count > 1)
//                content = [content stringByAppendingString: content];
//            else
//                content = [content stringByAppendingString: [[dicBall objectForKey:dicBallKey] stringByAppendingString:@" " ]];
//        }
//        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        //To Create ball tiker for each row.
//        
//        
//        [ScrollViewer insertSubview: [self CreateBallTickerInstance
//                                      :content
//                                      :isExtras
//                                      :isSpecialEvents
//                                      :[drballdetails.objMarkedforedit intValue] == 1
//                                      :drballdetails.objBallno
//                                      :xposition
//                                      :index] atIndex:0];
//        if (content.length >= 5)
//            xposition = xposition + 7 + (15 * content.length);
//        else if (content.length >= 3)
//            xposition = xposition + 7 + (13 * content.length);
//        else
//            xposition = xposition + (isExtras ? 57 : 47);
//        
//        index ++;
//    }
//   
//}
//

- (UIView *) CreateBallTickerInstance: (NSString *) content : (bool) isExtras : (bool) isSpecialEvents : (bool) isMarkedForEdit : (NSString *) ballno : (CGFloat) xposition : (int) index
{
    //Hints
    //WD NB LB B = Width="55" BorderBrush="#5283AE" Background="Transparent" (Foreground="#5283AE")
    //0 = Width="30" BorderBrush="#5283AE" Background="Transparent" (Foreground="#5283AE")
    //6 = Width="30" BorderBrush="#9434E3" Background="#9434E3" (Foreground="White")
    //4 = Width="30" BorderBrush="#017EFE" Background="#017EFE" (Foreground="White")
    //W = Width="30" BorderBrush="#FB3536" Background="#FB3536" (Foreground="White")
    
    // Border Brushes
    UIColor *runBrushBDR = [self colorWithHexString : @"#5283AE"];
    UIColor *extrasBrushBDR = [self colorWithHexString : @"#FF4DA6"];
    UIColor *fourBrushBDR = [self colorWithHexString : @"#017EFE"];
    UIColor *sixBrushBDR = [self colorWithHexString : @"#9434E3"];
    UIColor *wicketBrushBDR = [self colorWithHexString : @"#FB3536"];
    UIColor *markedForEditBrushBDR = [self colorWithHexString : @"#EDC03C"];
    
    
    // Background Brushes
    UIColor *runBrushBG = [UIColor clearColor];
    UIColor *extrasBrushBG = [self colorWithHexString : @"#FF4DA6"];
    UIColor *fourBrushBG = [self colorWithHexString : @"#017EFE"];
    UIColor *sixBrushBG = [self colorWithHexString : @"#9434E3"];
    UIColor *wicketBrushBG = [self colorWithHexString : @"#FB3536"];
    
    // Foreground Brushes
    UIColor *brushFGNormal = [self colorWithHexString : @"#5283AE"];
    UIColor *brushFGSplEvents = [UIColor whiteColor];
    
    content = [content  isEqual: @"0 W"] ? @"W" : content;
    content = [content  isEqual: @"0 NB"] ? @"NB" : content;
    content = [content  isEqual: @"0 WD"] ? @"WD" : content;
    content = [content  isEqual: @"0 RH"] ? @"RH" : content;
    double singleInstanceWidth = isExtras ? 50 : 40;
    double totalWidth = singleInstanceWidth;
    if (content.length >= 5)
        totalWidth = 15 * content.length;
    else if (content.length >= 3)
        totalWidth = 13 * content.length;
    
    UIView *BallTicker = [[UIView alloc] initWithFrame: CGRectMake(xposition, 0, totalWidth, 50)];
    
    // Border Control
    UIButton *btnborder = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, BallTicker.frame.size.width, 40)];
    btnborder.layer.cornerRadius = isExtras ? (content.length >= 5 ? btnborder.frame.size.width / 3.5 : btnborder.frame.size.width / 2.5) : (content.length >= 3 ? btnborder.frame.size.width / 2.5 : btnborder.frame.size.width / 2);
    btnborder.clipsToBounds = NO;
    btnborder.layer.borderWidth = 3.5;
    btnborder.layer.borderColor = [UIColor greenColor].CGColor;
    btnborder.layer.masksToBounds = YES;
    
    if ([content isEqual : @"4"])//Fours
    {
        btnborder.layer.borderColor = (isSpecialEvents ? fourBrushBDR : runBrushBDR).CGColor;
        btnborder.layer.backgroundColor = (isSpecialEvents ? fourBrushBDR : (isExtras ? extrasBrushBG : runBrushBG)).CGColor;
    }
    else if([content isEqual : @"6"])//Sixes
    {
        btnborder.layer.borderColor = (isSpecialEvents ? sixBrushBDR : runBrushBDR).CGColor;
        btnborder.layer.backgroundColor = (isSpecialEvents ? sixBrushBDR : (isExtras ? extrasBrushBG : runBrushBG)).CGColor;
    }else if([content isEqual : @"W"])//Wickets
    {
        btnborder.layer.borderColor = wicketBrushBDR.CGColor;
        btnborder.layer.backgroundColor = wicketBrushBG.CGColor;
    }
    else
    {
        btnborder.layer.borderColor = (isExtras ? extrasBrushBDR : runBrushBDR).CGColor;
        btnborder.layer.backgroundColor =(isExtras ? extrasBrushBG : runBrushBG).CGColor;
    }
    
    if (isMarkedForEdit)
        btnborder.layer.borderColor = markedForEditBrushBDR.CGColor;
    
    [btnborder setTitle:content forState:UIControlStateNormal];
    //for showing different color in ballticker text based on event
    //    [btnborder setTitleColor:(isSpecialEvents || isExtras) ? ((content.length > 1 && !isExtras) ? brushFGNormal : brushFGSplEvents) : brushFGNormal forState:UIControlStateNormal] ;
    [btnborder setTitleColor:brushFGSplEvents forState:UIControlStateNormal] ;
    btnborder.titleLabel.font = [UIFont fontWithName:@"Rajdhani-Bold" size:20];
    
    btnborder.tag= index;
    
    
    UILabel *BallTickerNo = [[UILabel alloc] initWithFrame:CGRectMake(0,48, totalWidth,12)];
    BallTickerNo.textAlignment = NSTextAlignmentCenter;
    BallTickerNo.font = [UIFont fontWithName:@"RAJDHANI-REGULAR" size:13];
    [BallTickerNo setText:ballno];
    [BallTickerNo setTextColor:brushFGSplEvents];
    
    
    [BallTicker addSubview:btnborder];
    [BallTicker insertSubview:BallTickerNo atIndex:0];
    return BallTicker;
    
    
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



- (IBAction)did_click_inn_one:(id)sender {
    
    DBManagerReports *dbReports = [[DBManagerReports alloc]init];
    
    _commentaryArray = [dbReports retrieveCommentaryData:self.matchCode:@"1"];
    
    [_commentary_tableview reloadData];
}

- (IBAction)did_click_inn_four:(id)sender {
    
    DBManagerReports *dbReports = [[DBManagerReports alloc]init];
    
    _commentaryArray = [dbReports retrieveCommentaryData:self.matchCode:@"4"];
    [_commentary_tableview reloadData];
}
- (IBAction)did_click_inn_two:(id)sender {
    
    DBManagerReports *dbReports = [[DBManagerReports alloc]init];
    
    _commentaryArray = [dbReports retrieveCommentaryData:self.matchCode:@"2"];
    [_commentary_tableview reloadData];
}

- (IBAction)did_click_inn_three:(id)sender {
    
    DBManagerReports *dbReports = [[DBManagerReports alloc]init];
    
    _commentaryArray = [dbReports retrieveCommentaryData:self.matchCode :@"3"];
    [_commentary_tableview reloadData];
}
@end
