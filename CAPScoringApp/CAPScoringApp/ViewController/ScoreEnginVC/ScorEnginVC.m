//
//  ScorEnginVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "ScorEnginVC.h"
#import "CDRTranslucentSideBar.h"
#import "DBManager.h"
#import "BallEventRecord.h"
#import "AppealRecord.h"
#import "AppealCell.h"
#import "AppealSystemRecords.h"
#import "AppealComponentRecord.h"
#import "AppealUmpireRecord.h"
#import "FieldingFactorRecord.h"
#import "BowlerEvent.h"
#import "FastBowlTypeCell.h"
#import "BowlAndShotTypeRecords.h"
#import "BowlTypeCell.h"
#import "FastBowlTypeCell.h"
#import "AggressiveShotTypeCell.h"
#import "FieldingFactorCell.h"

@interface ScorEnginVC () <CDRTranslucentSideBarDelegate,UITableViewDelegate,UITableViewDataSource>
{   //appeal System
    BOOL isEnableTbl;
    NSMutableArray * AppealSystemSelectionArray;
    NSString*AppealSystemSelectCode;
    AppealSystemRecords *objAppealSystemEventRecord;
    
    //AppealComponent
    NSMutableArray * AppealComponentSelectionArray;
    NSString*AppealComponentSelectCode;
    AppealComponentRecord *objAppealComponentEventRecord;
    
    //AppealUmpire
    NSMutableArray * AppealUmpireSelectionArray;
    NSString*AppealUmpireSelectCode;
    AppealUmpireRecord *objAppealUmpireEventRecord;
    
    //AppealBatsmen
    NSMutableArray *AppealBatsmenSelectionArray;
    NSArray*AppealBatsmenSelectCode;
    
    
    
    NSMutableArray *Btn_NameArray;
    BOOL isSelectleftview;
    UITableView* extrasTableView;
    UITableView* overThrowTableView;
    
    
    UITableView* objextras;
    BallEventRecord *objBalleventRecord;
    
    //RBW and Miscfilters
    UITableView* rbwTableview;
    UITableView* miscFiltersTableview;
    BOOL isRBWSelected;
    BOOL ismiscFilters;
    
    BOOL isMoreRunSelected;
    BOOL isExtrasSelected;
    BOOL isOverthrowSelected;
    BOOL isFieldingSelected;
    int fieldingOption;
    BOOL isOTWselected;
    BOOL isRTWselected;
    BOOL isSpinSelected;
    BOOL isFastSelected;
    BOOL isAggressiveSelected;
    BOOL isDefensiveSelected;
    
    NSString * ballnoStr;
    NSDate * startBallTime;
    
    
    FieldingFactorRecord *selectedfieldFactor;
    BowlerEvent *selectedfieldPlayer;
    NSString *selectedNRS;

}


@property(nonatomic,strong) NSMutableArray *selectbtnvalueArray;
@property(nonatomic,strong) NSMutableArray *extrasOptionArray;
@property(nonatomic,strong) NSMutableArray *overThrowOptionArray;
@property(nonatomic,strong) NSMutableArray *otwRtwArray;
@property(nonatomic,strong) BallEventRecord *ballEventRecord;

//RBW and Miscfilters
@property(nonatomic,strong) NSMutableArray *rbwOptionArray;
@property(nonatomic,strong) NSMutableArray *miscfiltersOptionArray;

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
//@property(nonatomic,strong) NSMutableArray *selectbtnvalueArray;

//Fielding Factors
@property (nonatomic,strong)NSMutableArray *fieldingfactorArray;
@property (nonatomic,strong)NSMutableArray *fieldingPlayerArray;
@property (nonatomic,strong)NSMutableArray *nrsArray;



@property (nonatomic,strong)NSMutableArray *bowlTypeArray;
@property(nonatomic,strong)NSMutableArray *fastBowlTypeArray;
@property(nonatomic,strong)NSMutableArray *aggressiveShotTypeArray;
@property(nonatomic,strong)NSMutableArray *defensiveShotTypeArray;

//@property(nonatomic,strong)BallEventRecord *ballEventRecord;

//appeal
@property (nonatomic,strong)NSMutableArray*AppealSystemArray;
@property (nonatomic,strong)NSMutableArray*AppealComponentArray;
@property (nonatomic,strong)NSMutableArray*AppealUmpireArray;
@property(nonatomic,strong) NSMutableArray *AppealBatsmenArray;
@property(nonatomic,strong) NSMutableArray *AppealValuesArray;


@end

@implementation ScorEnginVC
@synthesize table_Appeal;
@synthesize tbl_bowlType;
@synthesize tbl_fastBowl;
@synthesize tbl_aggressiveShot;
@synthesize tbl_fieldingfactor;

//appeal
@synthesize AppealSystemArray;
@synthesize AppealComponentArray;
@synthesize AppealUmpireArray;
@synthesize AppealBatsmenArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetBallObject];
    
    //bowl type - spin array
    _bowlTypeArray=[[NSMutableArray alloc]init];
    _bowlTypeArray =[DBManager getBowlType];
    
    self.view_bowlType.hidden = YES;
    self.tbl_bowlType.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //fast bowl type
    
    _fastBowlTypeArray = [[NSMutableArray alloc]init];
    _fastBowlTypeArray = [DBManager getBowlFastType];
    
    self.view_fastBowl.hidden = YES;

    
    
    //aggressive shot type
    
    _aggressiveShotTypeArray = [[NSMutableArray alloc]init];
    _aggressiveShotTypeArray =[DBManager getAggressiveShotType];
    self.view_aggressiveShot.hidden = YES;
    

    
    //defensice shot type
    _defensiveShotTypeArray = [[NSMutableArray alloc]init];
    _defensiveShotTypeArray = [DBManager getDefenceShotType];
    self.view_defensive.hidden = YES;
    
    self.View_Appeal.hidden = YES;
    
//    
//    self.sideBar = [[CDRTranslucentSideBar alloc] init];
//    self.sideBar.sideBarWidth = 200;
//    self.sideBar.delegate = self;
//    self.sideBar.tag = 0;
    
    // Create Right SideBar
//    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
//    self.rightSideBar.delegate = self;
//    self.rightSideBar.translucentStyle = UIBarStyleBlack;
//    self.rightSideBar.tag = 1;
    
    // Add PanGesture to Show SideBar by PanGesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    // Create Content of SideBar
    //    UITableView *tableView = [[UITableView alloc] init];
    //    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    //    v.backgroundColor = [UIColor clearColor];
    //    [tableView setTableHeaderView:v];
    //    [tableView setTableFooterView:v];
    //
    //    //If you create UITableViewController and set datasource or delegate to it, don't forget to add childcontroller to this viewController.
    //    //[[self addChildViewController: @"your view controller"];
    //    tableView.dataSource = self;
    //    tableView.delegate = self;
    //
    //    // Set ContentView in SideBar
    //    [self.sideBar setContentViewInSideBar:tableView];
    
    
     _View_Appeal.hidden=YES;
    _view_table_select.hidden=YES;
    _AppealValuesArray=[[NSMutableArray alloc]init];
    _AppealValuesArray =[DBManager AppealRetrieveEventData];
    
    
    //OTW and RTW
    _otwRtwArray = [[NSMutableArray alloc]init];
    _otwRtwArray = [DBManager getOtwRtw];
    
    
    //RBW and Misc Filters
    self.ballEventRecord = [[BallEventRecord alloc] init];
    self.ballEventRecord.objRbw =[NSNumber numberWithInt:0];
    self.ballEventRecord.objIswtb=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsuncomfort=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsreleaseshot=[NSNumber numberWithInt:0];
    self.ballEventRecord.objIsbeaten=[NSNumber numberWithInt:0];
    
    isRBWSelected = NO;
    ismiscFilters = NO;
    isFieldingSelected = NO;
    isSpinSelected = NO;
    isFastSelected = NO;
    isAggressiveSelected = NO;

    fieldingOption = 0;
    
    //Fielding Factor
    //_fieldingfactorArray=[[NSMutableArray alloc]init];
   // _fieldingfactorArray =[DBManager RetrieveFieldingFactorData];
    
//    self.view_fieldingfactor.hidden = YES;
//    self.view_fieldername.hidden = YES;
//    self.view_nrs.hidden=YES;
    
    
    
    //Appeal
    
    [self.view_AppealSystem.layer setBorderWidth:2.0];
    [self.view_AppealSystem.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealSystem .layer setMasksToBounds:YES];
    [_table_AppealSystem setHidden:YES];
    
    
    [self.view_AppealComponent.layer setBorderWidth:2.0];
    [self.view_AppealComponent.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealComponent .layer setMasksToBounds:YES];
    [_table_AppealComponent setHidden:YES];
    
    
    
    [self.view_umpireName.layer setBorderWidth:2.0];
    [self.view_umpireName.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_umpireName .layer setMasksToBounds:YES];
    [_tanle_umpirename setHidden:YES];
    
    
    [self.view_batsmen.layer setBorderWidth:2.0];
    [self.view_batsmen.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_batsmen .layer setMasksToBounds:YES];
    [_table_BatsmenName setHidden:YES];
    
AppealBatsmenArray=[[NSMutableArray alloc]initWithObjects:@"ADITYA TARE" ,nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.btn_StartBall.userInteractionEnabled=NO;
    [self AllBtndisableMethod];
    
    
    
    //Appeal
    
    [self.view_AppealSystem.layer setBorderWidth:2.0];
    [self.view_AppealSystem.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealSystem .layer setMasksToBounds:YES];
    [_table_AppealSystem setHidden:YES];
    
    
    [self.view_AppealComponent.layer setBorderWidth:2.0];
    [self.view_AppealComponent.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_AppealComponent .layer setMasksToBounds:YES];
    [_table_AppealComponent setHidden:YES];
    
    
    
    [self.view_umpireName.layer setBorderWidth:2.0];
    [self.view_umpireName.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_umpireName .layer setMasksToBounds:YES];
    [_tanle_umpirename setHidden:YES];
    
    
    [self.view_batsmen.layer setBorderWidth:2.0];
    [self.view_batsmen.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.view_batsmen .layer setMasksToBounds:YES];
    [_table_BatsmenName setHidden:YES];
    isEnableTbl=YES;

}
-(void)SaveBallEventREcordvalue
{
    objBalleventRecord=[[BallEventRecord alloc]init];
    
    NSMutableArray * teamCodeArray=[DBManager getTeamCodemethod];
    if(teamCodeArray.count > 0 && teamCodeArray != NULL)
    {
        NSString * objTeamCode = [NSString stringWithFormat:@"%@",teamCodeArray.lastObject];
        objBalleventRecord.objTeamcode =objTeamCode;
    }
    
    NSMutableArray * inningsNoArray=[DBManager getInningsNomethod];
    if(inningsNoArray.count > 0 && inningsNoArray != NULL)
    {
        NSString * objInningsno = [NSString stringWithFormat:@"%@",inningsNoArray.lastObject];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        objBalleventRecord.objInningsno = [f numberFromString:objInningsno];
        
    }
    
    [self getDayNOValue];
    NSMutableArray * ballCodevalueArray=[DBManager getballcodemethod];
    NSLog(@"array : %@",[ballCodevalueArray lastObject]);
    if(ballCodevalueArray.count > 0 && ballCodevalueArray!= NULL)
    {
        
        NSString*ballcode= [NSString stringWithFormat:@"%@",ballCodevalueArray.lastObject];
        
        NSString *code = [ballcode substringFromIndex: [ballcode length] - 10];
        
        NSString * myURL = [NSString stringWithFormat:@"1%@",code];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * myNumber = [f numberFromString:myURL];
        NSInteger value = [myNumber integerValue]+1;
        NSString *addcode = [@(value) stringValue];
        
        NSString * ballno = [addcode substringFromIndex:1];
        
        
        ballnoStr = [self.matchCode stringByAppendingFormat:@"%@",ballno];
        NSLog(@"array : %@",ballnoStr);
        
        
    }
    else{
        NSString * myURL = [NSString stringWithFormat:@"10000000001"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * myNumber = [f numberFromString:myURL];
        NSInteger value = [myNumber integerValue];
        NSString *ballno1 = [@(value) stringValue];
        NSString * ballno = [ballno1 substringFromIndex:1];
        ballnoStr = [self.matchCode stringByAppendingFormat:@"%@",ballno];
        NSLog(@"array : %@",ballnoStr);
        
    }
    
    
    objBalleventRecord.objBallcode   = ballnoStr;
    objBalleventRecord.objmatchcode=self.matchCode;
    objBalleventRecord.objcompetitioncode=self.competitionCode;
}

-(void)getDayNOValue
{
    NSMutableArray * DayNoArray=[DBManager getDayNomethod];
    NSString * objDayno;
    if(DayNoArray.count > 0 && DayNoArray != NULL)
    {
        objDayno = [NSString stringWithFormat:@"%@",DayNoArray.lastObject];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber * myNumber = [f numberFromString:objDayno];
        NSInteger value = [myNumber integerValue]+1;
        objBalleventRecord.objDayno = [NSNumber numberWithInteger:value];
        objBalleventRecord.objSessionno = [NSNumber numberWithInteger:value];
    }
    else{
        objDayno = @"1";
        objBalleventRecord.objDayno=@1;
        objBalleventRecord.objSessionno=@1;
    }
    
    
}


#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    // if you have left and right sidebar, you can control the pan gesture by start point.
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        CGPoint startPoint = [recognizer locationInView:self.view];
//        
//        // Left SideBar
//        if (startPoint.x < self.view.bounds.size.width / 2.0) {
//            self.sideBar.isCurrentPanGestureTarget = YES;
//        }
//        // Right SideBar
//        else {
//            self.rightSideBar.isCurrentPanGestureTarget = YES;
//        }
//    }
//    
//    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
//    [self.rightSideBar handlePanGestureToShow:recognizer inViewController:self];
//    
    // if you have only one sidebar, do like following
    
    // self.sideBar.isCurrentPanGestureTarget = YES;
    //[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar did appear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar did appear");
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar will appear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar will appear");
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar did disappear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar did disappear");
    }
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated {
    if (sideBar.tag == 0) {
        NSLog(@"Left SideBar will disappear");
    }
    
    if (sideBar.tag == 1) {
        NSLog(@"Right SideBar will disappear");
    }
}

// This is just a sample for tableview menu
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    //Fielding array
    if(isFieldingSelected && fieldingOption == 1)
    {
        return [self.fieldingfactorArray count];
    }
    if(isFieldingSelected && fieldingOption == 2)
    {
        return [self.fieldingPlayerArray count];
    }
    if(isFieldingSelected && fieldingOption == 3)
    {
        return [self.nrsArray count];
    }

    
    if(extrasTableView == tableView){
        return self.extrasOptionArray.count;
    }else if(overThrowTableView == tableView){
        return self.overThrowOptionArray.count;
    }

    if([self.selectbtnvalueArray count] > 0)
    {
        return self.selectbtnvalueArray.count;
        
    }else if (tableView == table_Appeal) {
        
        return self.AppealValuesArray.count;
        
    }else if(tableView == tbl_bowlType){
        
        return self.bowlTypeArray.count;
        
    }else if(tableView == tbl_fastBowl){
        return [self.fastBowlTypeArray count];
    }else if(tableView == tbl_aggressiveShot){
        return[self.aggressiveShotTypeArray count];
        
    }else if(tableView == _tbl_defensive){
        return [self.defensiveShotTypeArray count];
    }
    
    //Rbw,miscfilters and fieldingfactor
    if(rbwTableview == tableView)
    {
        return self.rbwOptionArray.count;
    }
    
    if(miscFiltersTableview == tableView)
    {
        return self.miscfiltersOptionArray.count;
    }
    
    if (tableView == self.table_AppealSystem)
    {
        return [AppealSystemArray count];
    }
    
    if (tableView == self.table_AppealComponent)
    {
        return [AppealComponentArray count];
    }
    
    
    if (tableView == self.tanle_umpirename)
    {
        return [AppealUmpireArray count];
    }
    
    
    if (tableView == self.table_BatsmenName)
    {
        return [AppealBatsmenArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
        cell.selectedBackgroundView = bgColorView;
        
        
        //Fielding factor
        if(isFieldingSelected && fieldingOption == 1)
        {
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *fieldFactorCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            FieldingFactorRecord *objFieldingFactorRecord=(FieldingFactorRecord*)[_fieldingfactorArray objectAtIndex:indexPath.row];
            fieldFactorCell.lbl_fastBowl.text = objFieldingFactorRecord.fieldingfactor;
         
            
            return fieldFactorCell;
        }
        if(isFieldingSelected && fieldingOption == 2)
        {
            static NSString *CellIdentifier = @"fastBowlCell";
            FastBowlTypeCell *fieldFactorCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            BowlerEvent *bowlerEvent=(BowlerEvent*)[_fieldingPlayerArray objectAtIndex:indexPath.row];
            fieldFactorCell.lbl_fastBowl.text = bowlerEvent.BowlerName;
            return fieldFactorCell;
        }
        if(isFieldingSelected && fieldingOption == 3)
        {
            static NSString *CellIdentifier = @"fastBowlCell";
            
            FastBowlTypeCell *fieldFactorCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
            NSString *nrs=(NSString*)[_nrsArray objectAtIndex:indexPath.row];
            fieldFactorCell.lbl_fastBowl.text = nrs;
            return fieldFactorCell;
        }
        
        
        
        
    }
    if(tableView == extrasTableView){
        cell.textLabel.text = [self.extrasOptionArray objectAtIndex:indexPath.row];
    }else if(tableView == overThrowTableView){
        cell.textLabel.text = [self.overThrowOptionArray objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [self.selectbtnvalueArray objectAtIndex:indexPath.row];
    } 
    
    if (tableView == table_Appeal) {

                static NSString *CellIdentifier = @"Cell";
                    AppealCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                         forIndexPath:indexPath];
        
                    AppealRecord *objAppealrecord=(AppealRecord*)[_AppealValuesArray objectAtIndex:indexPath.row];
        
        
                    cell.AppealName_lbl.text=objAppealrecord.MetaSubCodeDescriptision;
        return cell;
        
    } else if(tableView == tbl_bowlType){
        static NSString *CellIdentifier = @"cell";
        
        BowlTypeCell *bowlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                 forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objBowlRecord=(BowlAndShotTypeRecords*)[_bowlTypeArray objectAtIndex:indexPath.row];
        
        
        bowlCell.lbl_BowlTypeOdd.text = objBowlRecord.BowlType;
        
        // this is where you set your color view
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:20/255.0
                                                          green:161/255.0
                                                           blue:79/255.0
                                                          alpha:0.5];
        bowlCell.selectedBackgroundView =  customColorView;
        
        
        return bowlCell;
    }else if (tableView == tbl_fastBowl){
        
        static NSString *CellIdentifier = @"fastBowlCell";
        
        FastBowlTypeCell *fastBowlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                         forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objBowlRecord=(BowlAndShotTypeRecords*)[_fastBowlTypeArray objectAtIndex:indexPath.row];
        
        
        fastBowlCell.lbl_fastBowl.text = objBowlRecord.BowlType;
        
        return fastBowlCell;

        
    }else if (tableView == tbl_aggressiveShot){
        
        
        static NSString *CellIdentifier = @"aggressiveCell";
        
        AggressiveShotTypeCell *aggressiveCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                         forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objShotRecord=(BowlAndShotTypeRecords*)[_aggressiveShotTypeArray objectAtIndex:indexPath.row];
        
        
        aggressiveCell.lbl_aggressive.text = objShotRecord.ShotType;
        
        return aggressiveCell;
        
    }else if(tableView == _tbl_defensive){
        
        static NSString *CellIdentifier = @"defensiveCell";
        
        AggressiveShotTypeCell *aggressiveCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                                 forIndexPath:indexPath];
        
        BowlAndShotTypeRecords *objShotRecord=(BowlAndShotTypeRecords*)[_defensiveShotTypeArray objectAtIndex:indexPath.row];
        
        
        aggressiveCell.lbl_defensive.text = objShotRecord.ShotType;
        
        return aggressiveCell;
    }
    
    if(tableView == rbwTableview){
        cell.textLabel.text = [self.rbwOptionArray objectAtIndex:indexPath.row];
    }else if(tableView == miscFiltersTableview){
        cell.textLabel.text = [self.miscfiltersOptionArray objectAtIndex:indexPath.row];
    }
    
    
    if (tableView == self.table_AppealSystem)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objAppealSystemEventRecord=(AppealSystemRecords*)[AppealSystemArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objAppealSystemEventRecord.AppealSystemMetaSubCodeDescription;
        return cell;
    }
    
    
    
    if (tableView == self.table_AppealComponent)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        objAppealComponentEventRecord=(AppealComponentRecord*)[AppealComponentArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =objAppealComponentEventRecord.AppealComponentMetaSubCodeDescription;
        return cell;
    }
    
    
    if (tableView == self.tanle_umpirename)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        
        objAppealUmpireEventRecord=(AppealUmpireRecord*)[AppealUmpireArray objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text =objAppealUmpireEventRecord.AppealUmpireName1;
        cell.textLabel.text =objAppealUmpireEventRecord.AppealUmpireName2;
        return cell;
    }
    
    
    if (tableView == self.table_BatsmenName)
    {
        static NSString *MyIdentifier = @"MyIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
     // ll.textLabel.text=[AppealComponentArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text =[AppealBatsmenArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(IBAction)DidClickStartBall:(id)sender
{
    NSLog(@"btnname=%@",self.btn_StartBall.currentTitle);
    float startballandendballdifference;
   
      NSDate * EndBallTime;
    if([self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
    {
        [self SaveBallEventREcordvalue];
       startBallTime = [NSDate date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
//        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        NSString *currentTime = [dateFormatter stringFromDate:today];
//        
//        NSString*text ;
//        text = [currentTime stringByReplacingOccurrencesOfString:@"AM" withString:@""];
//        text = [currentTime stringByReplacingOccurrencesOfString:@"PM" withString:@""];
//        NSLog(@"User's current time in their preference format:%@",text);
//         NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        startBallTime = [dateFormatter1 dateFromString:currentTime];;
        //startBallTime=[text floatValue];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        NSString *time =[dateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        startBallTime= [dateFormatter1 dateFromString:time];
        [self.btn_StartBall setTitle:@"END BALL" forState:UIControlStateNormal];
        self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
//        self.btn_StartOver.userInteractionEnabled=NO;
        [self AllBtnEnableMethod];
        
    }
    else
    {
        [self.btn_StartBall setTitle:@"START BALL" forState:UIControlStateNormal];
        self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
        self.btn_StartOver.userInteractionEnabled=YES;
//        self.btn_StartBall.userInteractionEnabled=NO;
        [self AllBtndisableMethod];
       //EndBallTime = [NSDate date];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
//        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        NSString *currentTime = [dateFormatter stringFromDate:today];
//        
//        NSString*text ;
//        text = [currentTime stringByReplacingOccurrencesOfString:@"AM" withString:@""];
//        text = [currentTime stringByReplacingOccurrencesOfString:@"PM" withString:@""];
//        NSLog(@"User's current time in their preference format:%@",text);
//        
//        EndBallTime =[text floatValue];
        //startballandendballdifference =EndBallTime-startBallTime;
        //objBalleventRecord.objballduration=startballandendballdifference;
        
        [self timeLeftSinceDate:startBallTime];
        
        
        [DBManager saveBallEventData:objBalleventRecord];
        [DBManager insertBallCodeAppealEvent:objBalleventRecord];
        [DBManager insertBallCodeFieldEvent:objBalleventRecord];
        [DBManager insertBallCodeWicketEvent:objBalleventRecord];
        
        //[DBManager saveBallEventData:objBalleventRecord otwOrRtw:];
    }
}




-(NSMutableString*) timeLeftSinceDate: (NSDate *) dateT{
    
    NSMutableString *timeLeft = [[NSMutableString alloc]init];
    
    NSDate *today10am =[NSDate date];
    
    NSInteger seconds = [today10am timeIntervalSinceDate:dateT];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    if(days) {
        [timeLeft appendString:[NSString stringWithFormat:@"%ld Days", (long)days*-1]];
        
        objBalleventRecord.objballduration=[NSNumber numberWithInteger:days];
    }
    
    if(hours) {
        [timeLeft appendString:[NSString stringWithFormat: @"%ld H", (long)hours*-1]];
         objBalleventRecord.objballduration=[NSNumber numberWithInteger:hours];
    }
    
    if(minutes) {
        [timeLeft appendString: [NSString stringWithFormat: @"%ld M",(long)minutes*-1]];
         objBalleventRecord.objballduration=[NSNumber numberWithInteger:minutes];
    }
    
    if(seconds) {
        [timeLeft appendString:[NSString stringWithFormat: @"%lds", (long)seconds*1]];
        objBalleventRecord.objballduration=[NSNumber numberWithInteger:seconds];
    }
    
    return timeLeft;
}


-(IBAction)DidClickStartOver:(id)sender
{
    NSLog(@"btnname%@",self.btn_StartOver.currentTitle);
    if([self.btn_StartOver.currentTitle isEqualToString:@"START OVER"])
    {
        self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
        [self.btn_StartOver setTitle:@"END OVER" forState:UIControlStateNormal];
        if(![self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
            [self DidClickStartBall : self.btn_StartBall];
        self.btn_StartBall.userInteractionEnabled=YES;
       
    }
    else
    {
        [self.btn_StartOver setTitle:@"START OVER" forState:UIControlStateNormal];
        self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
        self.btn_StartBall.userInteractionEnabled=NO;
        [self AllBtndisableMethod];
    }
}

-(void)AllBtnEnableMethod
{
    self.btn_run1.userInteractionEnabled=YES;
    self.btn_run2.userInteractionEnabled=YES;
    self.btn_run3.userInteractionEnabled=YES;
    self.btn_highRun.userInteractionEnabled=YES;
    self.btn_B4.userInteractionEnabled=YES;
    self.btn_B6.userInteractionEnabled=YES;
    self.btn_extras.userInteractionEnabled=YES;
    self.btn_wkts.userInteractionEnabled=YES;
    self.btn_overthrow.userInteractionEnabled=YES;
    self.btn_miscFilter.userInteractionEnabled=YES;
    self.btn_pichmap.userInteractionEnabled=YES;
    self.btn_wagonwheel.userInteractionEnabled=YES;
    self.btn_OTW.userInteractionEnabled=YES;
    self.btn_RTW.userInteractionEnabled=YES;
    self.btn_Spin.userInteractionEnabled=YES;
    self.btn_Fast.userInteractionEnabled=YES;
    self.btn_Aggressive.userInteractionEnabled=YES;
    self.btn_Defensive.userInteractionEnabled=YES;
    self.btn_Fielding.userInteractionEnabled=YES;
    self.btn_RBW.userInteractionEnabled=YES;
    self.btn_Remarks.userInteractionEnabled=YES;
    self.btn_Edit.userInteractionEnabled=YES;
    self.btn_Appeals.userInteractionEnabled=YES;
    self.btn_lastinstance.userInteractionEnabled=YES;
    
    
}
-(void)AllBtndisableMethod
{
    self.btn_run1.userInteractionEnabled=NO;
    self.btn_run2.userInteractionEnabled=NO;
    self.btn_run3.userInteractionEnabled=NO;
    self.btn_highRun.userInteractionEnabled=NO;
    self.btn_B4.userInteractionEnabled=NO;
    self.btn_B6.userInteractionEnabled=NO;
    self.btn_extras.userInteractionEnabled=NO;
    self.btn_wkts.userInteractionEnabled=NO;
    self.btn_overthrow.userInteractionEnabled=NO;
    self.btn_miscFilter.userInteractionEnabled=NO;
    self.btn_pichmap.userInteractionEnabled=NO;
    self.btn_wagonwheel.userInteractionEnabled=NO;
    self.btn_OTW.userInteractionEnabled=NO;
    self.btn_RTW.userInteractionEnabled=NO;
    self.btn_Spin.userInteractionEnabled=NO;
    self.btn_Fast.userInteractionEnabled=NO;
    self.btn_Aggressive.userInteractionEnabled=NO;
    self.btn_Defensive.userInteractionEnabled=NO;
    self.btn_Fielding.userInteractionEnabled=NO;
    self.btn_RBW.userInteractionEnabled=NO;
    self.btn_Remarks.userInteractionEnabled=NO;
    self.btn_Edit.userInteractionEnabled=NO;
    self.btn_Appeals.userInteractionEnabled=NO;
    self.btn_lastinstance.userInteractionEnabled=NO;
}

-(IBAction)didClickLeftSideBtn_Action:(id)sender
{
    if(objextras!=nil)
    {
        [objextras removeFromSuperview];
    }
    
//    if(extrasTableView !=nil){
//        [extrasTableView removeFromSuperview];
//    }
//    
//    if(overThrowTableView !=nil){
//        [overThrowTableView removeFromSuperview];
//    }
    UIButton *selectBtnTag=(UIButton*)sender;
    
    if(isExtrasSelected && selectBtnTag.tag!=106){//Already open state
        
        
        if(self.ballEventRecord.objNoball.integerValue ==0 && self.ballEventRecord.objWide.integerValue ==0 && self.ballEventRecord.objByes.integerValue ==0 && self.ballEventRecord.objLegByes.integerValue ==0){//Nothing selected
            
            [self unselectedButtonBg:self.btn_extras];
        }else{//If any one selected
            
            [self selectedButtonBg:self.btn_extras];
        }
        
        if(extrasTableView!=nil){
            [extrasTableView removeFromSuperview];
        }
        
        
        isExtrasSelected = NO;
        
    }
    
    if(isOverthrowSelected  && selectBtnTag.tag!=108){// Already open state
        if(overThrowTableView!=nil){
            [overThrowTableView removeFromSuperview];
        }
        
        if(self.ballEventRecord.objOverthrow.integerValue!=0){
            [self selectedButtonBg:self.btn_overthrow];
        }else{
            [self unselectedButtonBg:self.btn_overthrow];
        }
        
        isOverthrowSelected = NO;
        
    }
    
    if(selectBtnTag.tag==100)//Run one
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==101)// Run two
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==102)// Run three
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==103)//More Runs
    {
        [self calculateRuns:selectBtnTag.tag];
        
    }
    else if(selectBtnTag.tag==104)// B4
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==105)// B6
    {
        [self calculateRuns:selectBtnTag.tag];
    }
    else if(selectBtnTag.tag==106)//Extras
    {
        [self extrasPopupMenu:selectBtnTag];
        //[self selectBtncolor_Action:@"106" :self.btn_extras :0];
        //self.selectbtnvalueArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
        //[self selelectbtnPop_View:selectBtnTag];
    }
    else if(selectBtnTag.tag==107)
    {
        [self selectBtncolor_Action:@"107" :self.btn_wkts :0];
    }
    else if(selectBtnTag.tag==108)//Overthrow
    {
        
        [self overThrowPopupMenu:selectBtnTag];
        
        //  [self selectBtncolor_Action:@"108" :self.btn_overthrow :0];
        //  self.selectbtnvalueArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
        //  [self selelectbtnPop_View:selectBtnTag];
    }
    else if(selectBtnTag.tag==109)
    {
        if (ismiscFilters) {
            if(self.ballEventRecord.objIsbeaten.integerValue ==0 && self.ballEventRecord.objIswtb.integerValue ==0 && self.ballEventRecord.objIsuncomfort.integerValue ==0 && self.ballEventRecord.objIsreleaseshot.integerValue ==0){
                self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Black
                
                
            }else{
                
                self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Green
            }
            [miscFiltersTableview removeFromSuperview];
            
            ismiscFilters = NO;
        }else{
            ismiscFilters = YES;
            
            self.btn_miscFilter.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            self.miscfiltersOptionArray=[[NSMutableArray alloc]initWithObjects:@"Uncomfort",@"Beaten",@"Release Shot",@"WTB", nil];
            
            
            
            miscFiltersTableview=[[UITableView alloc]initWithFrame:CGRectMake(self.commonleftrightview.frame.size.width-570, self.btn_miscFilter.frame.origin.y-80,130,190)];
            miscFiltersTableview.backgroundColor=[UIColor whiteColor];
            
            miscFiltersTableview.dataSource = self;
            miscFiltersTableview.delegate = self;
            [self.commonleftrightview addSubview:miscFiltersTableview];
            miscFiltersTableview.allowsMultipleSelection = YES;
            [miscFiltersTableview reloadData];
            
            
            if(self.ballEventRecord.objIsuncomfort.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            if(self.ballEventRecord.objIsbeaten.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            if(self.ballEventRecord.objIsreleaseshot.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            if(self.ballEventRecord.objIswtb.integerValue!=0){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [miscFiltersTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }

    }
    else if(selectBtnTag.tag==110)
    {
        [self selectBtncolor_Action:@"110" :self.btn_pichmap :0];
        [self.img_pichmap setImage:[UIImage imageNamed:@"pitchmap_img"]];
           _View_Appeal.hidden=YES;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden = YES;
    }
    else if(selectBtnTag.tag==111)
    {
        [self selectBtncolor_Action:@"111" :self.btn_wagonwheel :0];
        [self.img_pichmap setImage:[UIImage imageNamed:@"WagonWheel_img"]];
         _View_Appeal.hidden=YES;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden = YES;

        
    }
}
-(void)selelectbtnPop_View:(UIButton *)btn_selection
{
    objextras=[[UITableView alloc]initWithFrame:CGRectMake(btn_selection.frame.origin.x+btn_selection.frame.size.width+10, btn_selection.frame.origin.y-50,100,200)];
    objextras.backgroundColor=[UIColor whiteColor];
    
    objextras.dataSource = self;
    objextras.delegate = self;
    [self.commonleftrightview addSubview:objextras];
    [objextras reloadData];
    
}

-(IBAction)didClickRightSideBtn_Action:(id)sender
{
    UIButton *selectBtnTag=(UIButton*)sender;
    //isSelectleftview=NO;
    if(selectBtnTag.tag==112)
    {
        

         [self otwSelectAndDeselect];
        
    }
    else if(selectBtnTag.tag==113)
    {
        [self rtwSelectAndDeselect];
        
    }
    else if(selectBtnTag.tag==114)
    {
        //  [self selectBtncolor_Action:@"114" :nil :203];
        
        self.view_bowlType.hidden = NO;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden = YES;
        
        if(isSpinSelected){
            
            NSInteger position = [self.bowlTypeArray indexOfObject:self.ballEventRecord.objBowltype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_bowlType selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_bowlType scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }else{
            objBalleventRecord.objBowltype = nil;
            [tbl_bowlType reloadData];
        }
        
        //View
        _view_spin.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_fast.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        


    }
    else if(selectBtnTag.tag==115)//fast
    {
        //[self selectBtncolor_Action:@"115" :nil :204];
        self.view_aggressiveShot.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        self.view_defensive.hidden = YES;
        
        if(isFastSelected){
            
            NSInteger position = [self.bowlTypeArray indexOfObject:self.ballEventRecord.objBowltype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        }else{
            objBalleventRecord.objBowltype = nil;
            [tbl_bowlType reloadData];
        }
        
        //View
        _view_fast.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_spin.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        
        
    }
    else if(selectBtnTag.tag==116)//aggressive
    {
        //[self selectBtncolor_Action:@"116" :nil :205];
        self.view_aggressiveShot.hidden = NO;
        self.view_fastBowl.hidden = YES;
        self.view_bowlType.hidden = YES;
        self.view_defensive.hidden = YES;
        
        if(isAggressiveSelected){
            
            NSInteger position = [self.aggressiveShotTypeArray indexOfObject:self.ballEventRecord.objShottype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [tbl_aggressiveShot selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [tbl_aggressiveShot scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
        }else{
            objBalleventRecord.objShottype = nil;
            [tbl_aggressiveShot reloadData];
        }
        
        //View
        _view_aggressive.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_defense.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        
        
        
        
    }
    else if(selectBtnTag.tag==117)
    {
        //[self selectBtncolor_Action:@"117" :nil :206];
        self.view_defensive.hidden = NO;
        self.view_aggressiveShot.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_bowlType.hidden = YES;
        
        if(isDefensiveSelected){
            
            NSInteger position = [self.defensiveShotTypeArray indexOfObject:self.ballEventRecord.objShottype];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [_tbl_defensive selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [_tbl_defensive scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        }else{
            objBalleventRecord.objShottype = nil;
            [_tbl_defensive reloadData];
        }
        
        //View
        _view_aggressive.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        
        _view_defense.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        
     
        
    }
    else if(selectBtnTag.tag==118) //fielding factor
    {
        //[self selectBtncolor_Action:@"118" :nil :207];
        
        if(isFieldingSelected){
            
            selectedNRS = nil;
            selectedfieldPlayer = nil;
            selectedfieldFactor = nil;
            
            isFieldingSelected = NO;
            fieldingOption = 0;
            self.view_aggressiveShot.hidden = YES;
            self.view_defensive.hidden = YES;
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = YES;
           [self unselectedButtonBg:selectBtnTag];
        }else{
            //Fielding Factor
            _fieldingfactorArray=[[NSMutableArray alloc]init];
            _fieldingfactorArray =[DBManager RetrieveFieldingFactorData];
            
            [self selectedButtonBg:selectBtnTag];
            isFieldingSelected = YES;
            fieldingOption = 1;
            
            self.view_aggressiveShot.hidden = YES;
            self.view_defensive.hidden = YES;
            self.view_bowlType.hidden = YES;
            self.view_fastBowl.hidden = NO;
            
            [self.tbl_fastBowl reloadData];
            
            if(selectedNRS!=nil){
                
                int indx=0;
                int selectePosition = -1;
                for (FieldingFactorRecord *record in _fieldingfactorArray)
                {
                    bool chk = ([[record fieldingfactorcode] isEqualToString:selectedfieldFactor.fieldingfactorcode]);
                    if (chk)
                    {
                        selectePosition = indx;
                        break;
                    }
                    indx ++;
                }
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
                [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionTop
                                                  animated:YES];
                
            }
        }

    }
    else if(selectBtnTag.tag==119)//RBW
    {
        if (isRBWSelected) {
            if(self.ballEventRecord.objRbw!=0){
                
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
               
            }else{
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
               
            }
            [rbwTableview removeFromSuperview];
            
            isRBWSelected = NO;
        }else{
            isRBWSelected = YES;
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            self.rbwOptionArray=[[NSMutableArray alloc]initWithObjects:@"-5",@"-4",@"-3",@"-2",@"-1",@"1",@"2",@"3",@"4",@"5", nil];
            
            
            rbwTableview=[[UITableView alloc]initWithFrame:CGRectMake(self.commonleftrightview.frame.size.width-180, self.btn_RBW.frame.origin.y-80,100,250)];
            rbwTableview.backgroundColor=[UIColor whiteColor];
            
            rbwTableview.dataSource = self;
            rbwTableview.delegate = self;
            [self.commonleftrightview addSubview:rbwTableview];
            [rbwTableview reloadData];
            
            
            if(self.ballEventRecord.objRbw!=0){
                NSInteger position = [self.rbwOptionArray indexOfObject:self.ballEventRecord.objRbw];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
                [rbwTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    else if(selectBtnTag.tag==120)
    {
        [self selectBtncolor_Action:@"120" :nil :209];
        //[self RemarkMethode];
        
    }
    else if(selectBtnTag.tag==121)
    {
        [self selectBtncolor_Action:@"121" :nil :210];
    }
    else if(selectBtnTag.tag==122)
    {
        [self selectBtncolor_Action:@"122" :nil :211];
         _View_Appeal.hidden=NO;
        
        
    }
    else if(selectBtnTag.tag==123)
    {
        [self selectBtncolor_Action:@"123" :nil :212];
    }
    
}


//otw select,deselect and reset values
-(void)otwSelectAndDeselect{
    
    //    NSString *otw;
    //
    //    AppealRecord *objRtwRecord = (AppealRecord*)[_otwRtwArray objectAtIndex:0];
    //    otw = objRtwRecord.MetaSubCode;
    //
    
    if ([objBalleventRecord.objAtworotw isEqual: @"MSC148"]){
        
        // _btn_OTW.selected = YES;
        
        _view_otw.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        objBalleventRecord.objAtworotw = nil;
        
        
    }else{
        _view_otw.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        _view_rtw.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        objBalleventRecord.objAtworotw = @"MSC148";
        
    }
    
    
    
}

//rtw select,deselect and reset values
-(void)rtwSelectAndDeselect{
    if ([objBalleventRecord.objAtworotw isEqual: @"MSC149"]){
        
        // _btn_OTW.selected = YES;
        
        _view_rtw.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        objBalleventRecord.objAtworotw = nil;
        
        
    }else{
        _view_rtw.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];//Selected
        _view_otw.backgroundColor = [UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];//Normal
        objBalleventRecord.objAtworotw = @"MSC149";
        
    }
    
    
}



-(void)RemarkMethode
{
    UIView * objcommonRemarkview=[[UIView alloc]initWithFrame:CGRectMake(self.Allvaluedisplayview.frame.origin.x-110,self.Allvaluedisplayview.frame.origin.y+50, self.Allvaluedisplayview.frame.size.width-100, 200)];
    [objcommonRemarkview setBackgroundColor:[UIColor redColor]];
    UITextView *txt_Remark=[[UITextView alloc]initWithFrame:CGRectMake(objcommonRemarkview.frame.origin.x,objcommonRemarkview.frame.origin.y-100, objcommonRemarkview.frame.size.width-100,100)];
    [txt_Remark setBackgroundColor:[UIColor grayColor]];
    
    [objcommonRemarkview addSubview:txt_Remark];
    
    [self.Allvaluedisplayview addSubview:objcommonRemarkview];
    
    
    
    UIButton *btn_save=[[UIButton alloc]initWithFrame:CGRectMake(objcommonRemarkview.frame.origin.x+50,objcommonRemarkview.frame.size.height-50,50,50)];
    [btn_save setBackgroundColor:[UIColor whiteColor]];
    [btn_save setTitle:@"Save" forState:UIControlStateNormal];
    [btn_save addTarget:self action:@selector(didClickRemarkSave_Action:) forControlEvents:UIControlEventTouchUpInside];
    [objcommonRemarkview addSubview:btn_save];
    UIButton *btn_Cancel=[[UIButton alloc]initWithFrame:CGRectMake(objcommonRemarkview.frame.size.width-50,objcommonRemarkview.frame.size.height-50,50,50)];
    [btn_Cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btn_Cancel setBackgroundColor:[UIColor whiteColor]];
    [btn_save addTarget:self action:@selector(didClickRemarkCancel_Action:) forControlEvents:UIControlEventTouchUpInside];
    [objcommonRemarkview addSubview:btn_Cancel];
    
    
}








-(IBAction)didClickRemarkSave_Action:(id)sender
{
    
}
-(IBAction)didClickRemarkCancel_Action:(id)senderf
{
    
}

-(void)selectBtncolor_Action:(NSString*)select_Btntag :(UIButton *)select_BtnName :(NSInteger)selectview
{
    if(select_BtnName!= 0)
    {
        for (id obj in self.leftsideview.subviews) {
            
            NSString *classStr = NSStringFromClass([obj class]);
            
            if ([classStr isEqualToString:@"UIButton"]) {
                UIButton *button = (UIButton*)obj;
                NSLog(@"tag=%ld",(long)button.tag);
                button.backgroundColor=[UIColor blackColor];
                if(button.tag== select_BtnName.tag)
                {
                    
                    if(isSelectleftview==NO)
                    {
                        for (id obj in self.Rightsideview.subviews) {
                            
                            NSString *classStr = NSStringFromClass([obj class]);
                            
                            if ([classStr isEqualToString:@"UIView"]) {
                                UIView *button = (UIView*)obj;
                                NSLog(@"tag=%ld",(long)button.tag);
                                button.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
                            }
                        }
                        
                    }
                    isSelectleftview=YES;
                    button.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
                    
                }
            }
        }
        
    }
    else{
        for (id obj in self.Rightsideview.subviews) {
            
            NSString *classStr = NSStringFromClass([obj class]);
            
            if ([classStr isEqualToString:@"UIView"]) {
                UIView *button = (UIView*)obj;
                NSLog(@"tag=%ld",(long)button.tag);
                button.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
                if(button.tag== selectview)
                {
                    
                    if(isSelectleftview==YES)
                    {
                        for (id obj in self.leftsideview.subviews) {
                            
                            NSString *classStr = NSStringFromClass([obj class]);
                            
                            if ([classStr isEqualToString:@"UIButton"]) {
                                UIButton *button = (UIButton*)obj;
                                NSLog(@"tag=%ld",(long)button.tag);
                                button.backgroundColor=[UIColor blackColor];
                            }
                        }
                        
                    }
                    isSelectleftview=NO;
                    
                    button.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
                }
                
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Sathish

-(void) resetBallObject{
    self.ballEventRecord = [[BallEventRecord alloc] init];
    self.ballEventRecord.objIsFour = 0;
    self.ballEventRecord.objIssix = 0;
    self.ballEventRecord.objRuns = 0;
    
    
    self.ballEventRecord.objByes = 0;
    self.ballEventRecord.objLegByes = 0;
    self.ballEventRecord.objWide = 0;
    self.ballEventRecord.objNoball = 0;
    self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:1];
    
    
    self.ballEventRecord.objOverthrow = 0;
    self.ballEventRecord.objTotalruns = 0;
    self.ballEventRecord.objPenalty = 0;
    self.ballEventRecord.objTotalextras = 0;
    self.ballEventRecord.objGrandtotal = 0;
    
    isMoreRunSelected = NO;
    isExtrasSelected = NO;
    isOverthrowSelected = NO;
}

//Set to normal background for runs button
-(void) resetRunsBoundriesView{
    [self unselectedButtonBg: self.btn_run1];
    [self unselectedButtonBg: self.btn_run2];
    [self unselectedButtonBg: self.btn_run3];
    [self unselectedButtonBg: self.btn_B4];
    
    if(!isMoreRunSelected && (self.ballEventRecord.objLegByes.integerValue==1 || self.ballEventRecord.objWide.integerValue==1 || self.ballEventRecord.objByes.integerValue==1)){//Check for LB,WD,B selected
        [self disableButtonBg: self.btn_B6];
    }else{
        [self unselectedButtonBg: self.btn_B6];
    }
    
    
}


- (IBAction)appeal_btn:(id)sender {
    if(isEnableTbl==YES)
    {
        AppealSystemArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchAppealSystemArray =[DBManager AppealSystemRetrieveEventData];
        for(int i=0; i < [FetchAppealSystemArray count]; i++)
        {
            
            objAppealSystemEventRecord=(AppealSystemRecords*)[FetchAppealSystemArray objectAtIndex:i];
            
            [AppealSystemArray addObject:objAppealSystemEventRecord];
            
            
        }
        
        
        [self.table_AppealSystem reloadData];
        self.table_AppealSystem.hidden=NO;
        isEnableTbl=NO;
    }
    
    
}
- (IBAction)btn_AppealComponent:(id)sender {
    
    if(isEnableTbl==YES)
    {
        AppealComponentArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchAppealComponentArray =[DBManager AppealComponentRetrieveEventData];
        for(int i=0; i < [FetchAppealComponentArray count]; i++)
        {
            
            objAppealComponentEventRecord=(AppealComponentRecord*)[FetchAppealComponentArray objectAtIndex:i];
            
            [AppealComponentArray addObject:objAppealComponentEventRecord];
            
            
        }
        
        
        [self.table_AppealComponent reloadData];
        self.table_AppealComponent.hidden=NO;
        isEnableTbl=NO;
    }
}
- (IBAction)btn_umpireName:(id)sender {
    
    
    if(isEnableTbl==YES)
    {
        AppealUmpireArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchAppealumpireArray =[DBManager AppealUmpireRetrieveEventData:_competitionCode :_matchCode];
        for(int i=0; i < [FetchAppealumpireArray count]; i++)
        {
            
            objAppealUmpireEventRecord=(AppealUmpireRecord*)[FetchAppealumpireArray objectAtIndex:i];
            
            [AppealUmpireArray addObject:objAppealUmpireEventRecord];
            
            
        }
        
        
        [self.tanle_umpirename reloadData];
        self.tanle_umpirename.hidden=NO;
        isEnableTbl=NO;
    }

}
- (IBAction)btn_batsmen:(id)sender {
    if (self.table_BatsmenName.hidden ==YES) {
        
        self.table_BatsmenName.hidden=NO;
        
    }
    else
        self.table_BatsmenName.hidden=YES;
}

//Reset boundries and runs values
-(void) resetRunsBoundriesValue{
    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
    self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:0];
}


-(void) calculateRuns:(long) tagNumber{
    
    switch ((int)tagNumber) {
        case 100: // One, Four
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objRuns.integerValue == 1){// If runs has one
                [self resetRunsBoundriesValue];
                
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:4];
                    [self selectedButtonBg: self.btn_run1];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run1];
                }
                
            }else if(self.ballEventRecord.objRuns.integerValue == 4){// If runs has four
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:1];
                    [self selectedButtonBg: self.btn_run1];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run1];
                }
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?4:1];
                [self selectedButtonBg: self.btn_run1];
            }
            
            break;
        case 101: // Two, Five
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objRuns.integerValue == 2){// If runs has two
                [self resetRunsBoundriesValue];
                
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:5];
                    [self selectedButtonBg: self.btn_run2];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run2];
                }
                
            }else if(self.ballEventRecord.objRuns.integerValue == 5){// If runs has five
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:2];
                    [self selectedButtonBg: self.btn_run2];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run2];
                }
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?5:2];
                [self selectedButtonBg: self.btn_run2];
                
            }
            
            break;
        case 102: // Three, Six
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objRuns.integerValue == 3){// If runs has three
                [self resetRunsBoundriesValue];
                
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:6];
                    [self selectedButtonBg: self.btn_run3];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run3];
                }
                
            }else if(self.ballEventRecord.objRuns.integerValue == 6){// If runs has six
                [self resetRunsBoundriesValue];
                
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:3];
                    [self selectedButtonBg: self.btn_run3];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_run3];
                }
            }else{//Other run selected
                [self resetRunsBoundriesValue];
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:isMoreRunSelected?6:3];
                [self selectedButtonBg: self.btn_run3];
                
            }
            
            break;
        case 103: // More runs
            [self didSelectMoreRuns];
            break;
        case 104: // B4, Seven
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            if(self.ballEventRecord.objIsFour.integerValue == 1){// If isFour has one
                [self resetRunsBoundriesValue];
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B4];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:7];
                    [self selectedButtonBg: self.btn_B4];
                }
                
            } else if( self.ballEventRecord.objRuns.integerValue == 7){// If runs has seven
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B4];
                }else{
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:1];
                    [self selectedButtonBg: self.btn_B4];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
            }
            else{//Other run selected
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:7];
                }else{
                    self.ballEventRecord.objIsFour = [NSNumber numberWithInt:1];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                    
                }
                
                [self selectedButtonBg: self.btn_B4];
                
            }
            
            break;
        case 105: // B6, Eight
            
            [self resetRunsBoundriesView];
            [self resetOverthrowViewAndValue];//Reset overthrow
            
            
            if(self.ballEventRecord.objIssix.integerValue == 1){// If isSix has one
                [self resetRunsBoundriesValue];
                if(!isMoreRunSelected){//More unselected
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B6];
                }else{
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:8];
                    [self selectedButtonBg: self.btn_B6];
                }
                
            } else if( self.ballEventRecord.objRuns.integerValue == 8){// If runs has eight
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
                    [self unselectedButtonBg: self.btn_B6];
                }else{
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:1];
                    [self selectedButtonBg: self.btn_B6];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
            }
            else{//Other run selected
                [self resetRunsBoundriesValue];
                if(isMoreRunSelected){//More selected
                    self.ballEventRecord.objRuns = [NSNumber numberWithInt:8];
                }else{
                    self.ballEventRecord.objIssix = [NSNumber numberWithInt:1];
                    
                    //Hide overthrow
                    [self disableButtonBg: self.btn_overthrow];
                    self.btn_overthrow.userInteractionEnabled=NO;
                    self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
                }
                
                [self selectedButtonBg: self.btn_B6];
                
            }
            
            break;
        default:
            break;
    }
    
}

-(void) resetOverthrowViewAndValue{
    if(self.ballEventRecord.objIssix.integerValue == 1 || self.ballEventRecord.objIsFour.integerValue == 1){
        [self unselectedButtonBg: self.btn_overthrow];
        self.btn_overthrow.userInteractionEnabled=YES;
        self.ballEventRecord.objOverthrow = [NSNumber numberWithInt:0];
    }
}

//Selected background for button
-(void) selectedButtonBg:(UIButton *) select_btn{
    select_btn.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
}

//Normal background for button
-(void) unselectedButtonBg:(UIButton *) select_btn{
    
    select_btn.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
}

//Disable background for button
-(void) disableButtonBg:(UIButton *) select_btn{
    select_btn.backgroundColor=[UIColor colorWithRed:(139/255.0f) green:(137/255.0f) blue:(137/255.0f) alpha:1.0f];
}

//-(void) didSelectOTWRTW
//{
//    [self unselectedButtonBg:self.btn_OTW];
//    [self unselectedButtonBg:self.btn_RTW];
//    
//    if(!isOTWselected)
//    {
//        [self selectedButtonBg:self.btn_OTW];
//        isOTWselected = YES;
//        
//    }
//}


//Toggle for more runs
-(void) didSelectMoreRuns
{
    
    //[self resetRunsBoundriesView];
    [self unselectedButtonBg: self.btn_run1];
    [self unselectedButtonBg: self.btn_run2];
    [self unselectedButtonBg: self.btn_run3];
    [self unselectedButtonBg: self.btn_B4];
    [self unselectedButtonBg: self.btn_B6];
   
    
    if(!isMoreRunSelected)//Not selected state
    {
        //Set down toggle image
        [self.btn_highRun setImage:[UIImage imageNamed:@"dropDown"] forState:UIControlStateNormal];
        [self selectedButtonBg: self.btn_highRun];
        isMoreRunSelected = YES;
    
        //Set run button name
        [self.btn_run1 setTitle:@"4" forState:UIControlStateNormal];
        [self.btn_run2 setTitle:@"5" forState:UIControlStateNormal];
        [self.btn_run3 setTitle:@"6" forState:UIControlStateNormal];
        [self.btn_B4 setTitle:@"7" forState:UIControlStateNormal];
        [self.btn_B6 setTitle:@"8" forState:UIControlStateNormal];
        
        //Set run button highlight
        if(self.ballEventRecord.objRuns.integerValue == 4){
            [self selectedButtonBg: self.btn_run1];
        }else if(self.ballEventRecord.objRuns.integerValue == 5){
            [self selectedButtonBg: self.btn_run2];
        }else if(self.ballEventRecord.objRuns.integerValue == 6){
            [self selectedButtonBg: self.btn_run3];
        }else if(self.ballEventRecord.objRuns.integerValue == 7){
            [self selectedButtonBg: self.btn_B4];
        }else if(self.ballEventRecord.objRuns.integerValue == 8){
            [self selectedButtonBg: self.btn_B6];
        }
        
        self.btn_B6.userInteractionEnabled=YES;
    }
    else{//Selected state
        
        //Set up toggle image
        [self.btn_highRun setImage:[UIImage imageNamed:@"moreRuns"] forState:UIControlStateNormal];
        [self unselectedButtonBg: self.btn_highRun];
        isMoreRunSelected = NO;
        
        //Set run button values
        [self.btn_run1 setTitle:@"1" forState:UIControlStateNormal];
        [self.btn_run2 setTitle:@"2" forState:UIControlStateNormal];
        [self.btn_run3 setTitle:@"3" forState:UIControlStateNormal];
        [self.btn_B4 setTitle:@"B4" forState:UIControlStateNormal];
        [self.btn_B6 setTitle:@"B6" forState:UIControlStateNormal];
        
        //Set run button highlight
        if(self.ballEventRecord.objRuns.integerValue == 1){
            [self selectedButtonBg: self.btn_run1];
        }else if(self.ballEventRecord.objRuns.integerValue == 2){
            [self selectedButtonBg: self.btn_run2];
        }else if(self.ballEventRecord.objRuns.integerValue == 3){
            [self selectedButtonBg: self.btn_run3];
        }else if(self.ballEventRecord.objIsFour.integerValue == 1){
            [self selectedButtonBg: self.btn_B4];
        }
        
        if(self.ballEventRecord.objIssix.integerValue == 1){
                [self selectedButtonBg: self.btn_B6];
        }else{
            if(self.ballEventRecord.objLegByes.integerValue==1 || self.ballEventRecord.objWide.integerValue==1 || self.ballEventRecord.objByes.integerValue==1){//Check for LB,WD,B selected
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;
            }
        }
        
        
    }
}

// Fetch extras list based on perviously selected option
-(NSMutableArray*) getExtrasOptionArray{
    
    NSMutableArray *extrasOptionArray;
    
    if(self.ballEventRecord.objWide.integerValue == 1){//if wide enable
        extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide", nil];
    }else if(self.ballEventRecord.objIssix.integerValue == 1){//if B6 enable
        extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall", nil];
    }else{// Default
        extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
    }
    
    return extrasOptionArray;
}

//Extras popup screen
-(void) extrasPopupMenu:(UIButton *)btn_selection
{
    
    if(isExtrasSelected){//Already open state
        
        
        if(self.ballEventRecord.objNoball.integerValue ==0 && self.ballEventRecord.objWide.integerValue ==0 && self.ballEventRecord.objByes.integerValue ==0 && self.ballEventRecord.objLegByes.integerValue ==0){//Nothing selected
            
            [self unselectedButtonBg:btn_selection];
        }else{//If any one selected
            
            [self selectedButtonBg:btn_selection];
        }
        
        if(extrasTableView!=nil){
            [extrasTableView removeFromSuperview];
        }
        
        
        isExtrasSelected = NO;
        
    }else{ // Not open state
        //Extras option array
        self.extrasOptionArray=[self getExtrasOptionArray];
        
        //Table view
        extrasTableView=[[UITableView alloc]initWithFrame:CGRectMake(btn_selection.frame.origin.x+btn_selection.frame.size.width+10, btn_selection.frame.origin.y-50,100,200)];
        extrasTableView.backgroundColor=[UIColor whiteColor];
        extrasTableView.allowsMultipleSelection = YES;
        extrasTableView.dataSource = self;
        extrasTableView.delegate = self;
        [self.commonleftrightview addSubview:extrasTableView];
        [extrasTableView reloadData];
        
        //Set highlight for selected options
        if(self.ballEventRecord.objNoball.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if(self.ballEventRecord.objWide.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if(self.ballEventRecord.objByes.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if(self.ballEventRecord.objLegByes.integerValue!=0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //  [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //         indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //
        
        [self selectedButtonBg:btn_selection];
        isExtrasSelected = YES;
    }
    
}

//Shows popup for over throw
-(void) overThrowPopupMenu:(UIButton *)btn_selection
{
    
    if(isOverthrowSelected){// Already open state
        if(overThrowTableView!=nil){
            [overThrowTableView removeFromSuperview];
        }
        
        if(self.ballEventRecord.objOverthrow.integerValue!=0){
             [self selectedButtonBg:btn_selection];
        }else{
           [self unselectedButtonBg:btn_selection];
        }

        isOverthrowSelected = NO;
        
    }else{ // Not open state
        //Overthrow option array
        self.overThrowOptionArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
        
        //Table view
        overThrowTableView=[[UITableView alloc]initWithFrame:CGRectMake(btn_selection.frame.origin.x+btn_selection.frame.size.width+10, btn_selection.frame.origin.y-50,100,200)];
        overThrowTableView.backgroundColor=[UIColor whiteColor];
        overThrowTableView.dataSource = self;
        overThrowTableView.delegate = self;
        [self.commonleftrightview addSubview:overThrowTableView];
        [overThrowTableView reloadData];
        
        if(self.ballEventRecord.objOverthrow!=0){
            NSInteger position = [self.overThrowOptionArray indexOfObject:self.ballEventRecord.objOverthrow];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
            [overThrowTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [overThrowTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
        }

        //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //  [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //         indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        //        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        //
        
        [self selectedButtonBg:btn_selection];
        isOverthrowSelected = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    _view_table_select.hidden=NO;
    
    
    if (tableView == self.table_AppealSystem)
    {
        
        
        AppealSystemSelectionArray=[[NSMutableArray alloc]init];
        objAppealSystemEventRecord=(AppealSystemRecords*)[AppealSystemArray objectAtIndex:indexPath.row];
        
        self.lbl_appealsystem.text =objAppealSystemEventRecord.AppealSystemMetaSubCodeDescription;
        // selectTeam=self.Wonby_lbl.text;
        AppealSystemSelectCode=objAppealSystemEventRecord.AppealSystemMetaSubCode;
        [AppealSystemSelectionArray addObject:objAppealSystemEventRecord];
        
        self.table_AppealSystem.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    
    if (tableView == self.table_AppealComponent)
    {
        
        
        AppealComponentSelectionArray=[[NSMutableArray alloc]init];
        objAppealComponentEventRecord=(AppealComponentRecord*)[AppealComponentArray objectAtIndex:indexPath.row];
        
        self.lbl_appealComponent.text =objAppealComponentEventRecord.AppealComponentMetaSubCodeDescription;
        // selectTeam=self.Wonby_lbl.text;
        AppealComponentSelectCode=objAppealComponentEventRecord.AppealComponentMetaSubCode;
        [AppealComponentSelectionArray addObject:objAppealComponentEventRecord];
        
        self.table_AppealComponent.hidden=YES;
        isEnableTbl=YES;
    }
    
    
    
    if (tableView == self.tanle_umpirename)
    {
        
        
        AppealUmpireSelectionArray=[[NSMutableArray alloc]init];
        objAppealUmpireEventRecord=(AppealUmpireRecord*)[AppealUmpireArray objectAtIndex:indexPath.row];
        
        self.lbl_umpirename.text =objAppealUmpireEventRecord.AppealUmpireName1;
        self.lbl_umpirename.text =objAppealUmpireEventRecord.AppealUmpireName2;
        // selectTeam=self.Wonby_lbl.text;
        AppealUmpireSelectCode=objAppealUmpireEventRecord.AppealUmpireCode1;
        AppealUmpireSelectCode=objAppealUmpireEventRecord.AppealUmpireCode2;
        [AppealUmpireSelectionArray addObject:objAppealUmpireEventRecord];
        
        self.tanle_umpirename.hidden=YES;
        isEnableTbl=YES;
    }
    
    if (tableView == self.table_BatsmenName)
    {
        
        
        AppealUmpireSelectionArray=[[NSMutableArray alloc]init];
        // objAppealComponentEventRecord=(AppealComponentRecord*)[AppealBatsmenArray objectAtIndex:indexPath.row];
        
        self.lbl_batsmen.text =[AppealBatsmenArray objectAtIndex:indexPath.row];
        // selectTeam=self.Wonby_lbl.text;
        AppealComponentSelectCode=@"PYCOOOO050";
        //   [AppealComponentSelectionArray addObject:objAppealComponentEventRecord];
        
        self.table_BatsmenName.hidden=YES;
        isEnableTbl=YES;
    }

    
    //Fielding Factor
    if(isFieldingSelected && fieldingOption == 1)
    {
        selectedfieldFactor = [self.fieldingfactorArray objectAtIndex:indexPath.row];
        
        _fieldingPlayerArray=[[NSMutableArray alloc]init];
        _fieldingPlayerArray =[DBManager RetrieveFieldingPlayerData];
       
        isFieldingSelected = YES;
        fieldingOption = 2;
        
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        
        [self.tbl_fastBowl reloadData];
        
        if(selectedfieldPlayer!=nil){
            
            int indx=0;
            int selectePosition = -1;
            for (BowlerEvent *record in _fieldingPlayerArray)
            {
                bool chk = ([[record BowlerCode] isEqualToString:selectedfieldPlayer.BowlerCode]);
                if (chk)
                {
                    selectePosition = indx;
                    break;
                }
                indx ++;
            }
            
        //NSInteger position = [self.fieldingPlayerArray indexOfObject:selectedfieldPlayer];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectePosition inSection:0];
        [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
        }
        
        
    }else if(isFieldingSelected && fieldingOption == 2)
    {
        selectedfieldPlayer = [self.fieldingPlayerArray objectAtIndex:indexPath.row];
        
        
        self.nrsArray=[[NSMutableArray alloc]initWithObjects:@"-6",@"-5",@"-4",@"-3",@"-2",@"-1",@"0",@"1",@"2",@"3",@"4",@"5",@"6", nil];
        isFieldingSelected = YES;
        fieldingOption = 3;
        
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = NO;
        
        [self.tbl_fastBowl reloadData];
        
        if(selectedNRS!=nil){
        NSInteger position = [self.nrsArray indexOfObject:selectedNRS];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
        [tbl_fastBowl selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [tbl_fastBowl scrollToRowAtIndexPath:indexPath
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
        }
    }else if(isFieldingSelected && fieldingOption == 3)
    {
        
        selectedNRS = [self.nrsArray objectAtIndex:indexPath.row];
        
        fieldingOption = 0;
        self.view_bowlType.hidden = YES;
        self.view_fastBowl.hidden = YES;
        self.view_aggressiveShot.hidden = YES;
        self.view_defensive.hidden =YES;
        
        isFieldingSelected = NO;
    }
    
    _view_table_select.hidden=NO;
    NSLog(@"Index Path %d",indexPath.row);
    
    if(tableView == extrasTableView){//Extras table view
        
        if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"NoBall"]){//No ball
        
            
            //Wide
            self.ballEventRecord.objWide = [NSNumber numberWithInt:0];
           // NSIndexPath *wideIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            //[extrasTableView deselectRowAtIndexPath:wideIndexPath animated:NO];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            //B6
            if(self.ballEventRecord.objIssix.integerValue == 0){//Six un selected
               
                if(!isMoreRunSelected){//Normal state
                    
                    if(self.ballEventRecord.objLegByes.integerValue==1 || self.ballEventRecord.objWide.integerValue==1 || self.ballEventRecord.objByes.integerValue==1){//Check for LB,WD,B selected
                        [self disableButtonBg:self.btn_B6];
                        self.btn_B6.userInteractionEnabled=NO;
                    }
                    else{
                        [self unselectedButtonBg:self.btn_B6];
                        self.btn_B6.userInteractionEnabled=YES;
                    
                    }
                }
                
            }
            
            //Noball
            NSIndexPath *noballIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [extrasTableView selectRowAtIndexPath:noballIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.ballEventRecord.objNoball = [NSNumber numberWithInt:1];
            
            //Is Legal ball
            self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:0];
            
            //Byes Select
            if(self.ballEventRecord.objByes.integerValue !=0){
                NSIndexPath *byesIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [extrasTableView selectRowAtIndexPath:byesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            //Legbyes Select
            if(self.ballEventRecord.objLegByes.integerValue !=0){
                NSIndexPath *legbyesIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [extrasTableView selectRowAtIndexPath:legbyesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Wide"]){//Wide
            
            //B6
            self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
            if(!isMoreRunSelected){
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;
            }
            //Legbyes
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];
            
            //Byes
            self.ballEventRecord.objByes = [NSNumber numberWithInt:0];
            
            //Noball
            self.ballEventRecord.objNoball = [NSNumber numberWithInt:0];
            
            //Wide Value
            self.ballEventRecord.objWide = [NSNumber numberWithInt:1];
            
            //is Legal ball
             self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:0];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            //Wide Selector
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Byes"]){//Byes
            //B6
            self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
            if(!isMoreRunSelected){
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;
            }
            //Legbyes
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];
            NSIndexPath *legbyesIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [extrasTableView deselectRowAtIndexPath:legbyesIndexPath animated:NO];
            
            //Byes
            self.ballEventRecord.objByes = [NSNumber numberWithInt:1];
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"LegByes"]){//Legbyes
            //B6
            self.ballEventRecord.objIssix = [NSNumber numberWithInt:0];
            if(!isMoreRunSelected){
                [self disableButtonBg:self.btn_B6];
                self.btn_B6.userInteractionEnabled=NO;

            }
            
            //Byes
            self.ballEventRecord.objByes = [NSNumber numberWithInt:0];
            NSIndexPath *byesIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [extrasTableView deselectRowAtIndexPath:byesIndexPath animated:NO];
            
            //Legbyes
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:1];

            
        }
    }else if(tableView == overThrowTableView){//Over throw table view
        if( self.ballEventRecord.objOverthrow != [self.overThrowOptionArray objectAtIndex:indexPath.row]){
            self.ballEventRecord.objOverthrow = [self.overThrowOptionArray objectAtIndex:indexPath.row];
            [overThrowTableView removeFromSuperview];
            isOverthrowSelected = NO;
            
            if(self.ballEventRecord.objOverthrow!=0){
                [self selectedButtonBg:self.btn_overthrow];
                //self.btn_RBW.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:0.5f];
            }else{
                [self unselectedButtonBg:self.btn_overthrow];
               // self.btn_RBW.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:0.5f];
            }
        }else{
            self.ballEventRecord.objOverthrow = [NSNumber numberWithInteger:0];
            [overThrowTableView removeFromSuperview];
            [self unselectedButtonBg:self.btn_overthrow];
           // self.btn_RBW.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:0.5f];
            
            isOverthrowSelected = NO;
        }
        
    } else if(rbwTableview == tableView){
        
        if( self.ballEventRecord.objRbw != [self.rbwOptionArray objectAtIndex:indexPath.row]){
            self.ballEventRecord.objRbw = [self.rbwOptionArray objectAtIndex:indexPath.row];
            [rbwTableview removeFromSuperview];
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
            isRBWSelected = NO;
            
            if(self.ballEventRecord.objRbw!=0){
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f];
            }else{
                self.view_Rbw.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
            }
        }else{
            self.ballEventRecord.objRbw = [NSNumber numberWithInteger:0];
            [rbwTableview removeFromSuperview];
            
            self.view_Rbw.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
            
            isRBWSelected = NO;
        }
        
    }else if(miscFiltersTableview == tableView){
        
        if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Uncomfort"]){
            self.ballEventRecord.objIsuncomfort = [NSNumber numberWithInt:1];
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Beaten"]){
            self.ballEventRecord.objIsbeaten = [NSNumber numberWithInt:1];
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Release Shot"]){
            self.ballEventRecord.objIsreleaseshot = [NSNumber numberWithInt:1];
            
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"WTB"]){
            self.ballEventRecord.objIswtb = [NSNumber numberWithInt:1];
        }
    }else if(tbl_bowlType == tableView){
        
        isSpinSelected = YES;
        isFastSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.bowlTypeArray objectAtIndex:indexPath.row];
        objBalleventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        
        //        if([bowlAndShortTypeRecord.BowlTypeCode  isEqualToString:objBalleventRecord.objBowltype])
        //        {
        //            objBalleventRecord.objBowltype = nil;
        //            [tbl_bowlType reloadData];
        //        }
        
        
    }else if (tbl_fastBowl == tableView){
        
        isFastSelected = YES;
        isSpinSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.fastBowlTypeArray objectAtIndex:indexPath.row];
        objBalleventRecord.objBowltype = bowlAndShortTypeRecord.BowlTypeCode;
        
        
    }else if (tbl_aggressiveShot == tableView){
        isAggressiveSelected = YES;
        isDefensiveSelected = NO;
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.aggressiveShotTypeArray objectAtIndex:indexPath.row];
        
        objBalleventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
    }else if (_tbl_defensive == tableView){
        isDefensiveSelected = YES;
        isAggressiveSelected = NO;
        
        
        BowlAndShotTypeRecords *bowlAndShortTypeRecord = [self.defensiveShotTypeArray objectAtIndex:indexPath.row];
        
        objBalleventRecord.objShottype = bowlAndShortTypeRecord.ShotTypeCode;
        
    }


    
    NSLog(@"Index Path %d",indexPath.row);
    
    for (NSIndexPath *indexPath in rbwTableview.indexPathsForSelectedRows) {
        NSLog(@"Loop %d",indexPath.row);
    }
    //    for (NSIndexPath *indexPath in extrasTableView.indexPathsForSelectedRows) {
    //        NSLog(@"Loop %d",indexPath.row);
    //    }
    //  rowcount = count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"D Index Path %d",indexPath.row);
    if(tableView == extrasTableView){//Extras Table view
        if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"NoBall"]){//No ball
            
            //Noball
            self.ballEventRecord.objNoball = [NSNumber numberWithInt:0];
            
            //Legalball
            self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:1];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            
//            if(self.ballEventRecord.objIssix.integerValue == 0){
//                [self unselectedButtonBg:self.btn_B6];
//                self.btn_B6.userInteractionEnabled=YES;
//            }
            
            
            //Byes Select
            if(self.ballEventRecord.objByes.integerValue !=0){
                NSIndexPath *byesIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [extrasTableView selectRowAtIndexPath:byesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            //Legbyes Select
            if(self.ballEventRecord.objLegByes.integerValue !=0){
                NSIndexPath *legbyesIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                [extrasTableView selectRowAtIndexPath:legbyesIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Wide"]){//Wide
            
            
            //B6
            self.btn_B6.userInteractionEnabled=YES;
            if(!isMoreRunSelected){
                [self unselectedButtonBg:self.btn_B6];
            }
            
            //Wide
            self.ballEventRecord.objWide = [NSNumber numberWithInt:0];
            //Is Legal ball
            self.ballEventRecord.objIslegalball = [NSNumber numberWithInt:1];
            
            //Recreate list
            //self.extrasOptionArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
            self.extrasOptionArray=[self getExtrasOptionArray];
            [extrasTableView reloadData];
            
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"Byes"]){//Byes
            
            //B6
            [self unselectedButtonBg:self.btn_B6];
            self.btn_B6.userInteractionEnabled=YES;
            
            //Wide
            self.ballEventRecord.objByes = [NSNumber numberWithInt:0];
            
            
        }else if([[self.extrasOptionArray objectAtIndex:indexPath.row] isEqual:@"LegByes"]){
            
            //B6
            [self unselectedButtonBg:self.btn_B6];
            self.btn_B6.userInteractionEnabled=YES;
            
            //Wide
            self.ballEventRecord.objLegByes = [NSNumber numberWithInt:0];
            
        }
    }else  if(rbwTableview == tableView){
        
    }else if(miscFiltersTableview == tableView){
        if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Uncomfort"]){
            self.ballEventRecord.objIsuncomfort = [NSNumber numberWithInt:0];
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Beaten"]){
            self.ballEventRecord.objIsbeaten = [NSNumber numberWithInt:0];
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"Release Shot"]){
            self.ballEventRecord.objIsreleaseshot = [NSNumber numberWithInt:0];
        }else if([[self.miscfiltersOptionArray objectAtIndex:indexPath.row]  isEqual: @"WTB"]){
            self.ballEventRecord.objIswtb = [NSNumber numberWithInt:0];
        }
    }

    //    for (NSIndexPath *indexPath in extrasTableView.indexPathsForSelectedRows) {
    //        NSLog(@"D Loop %d",indexPath.row);
    //    }
}


-(void) selectExtrasOption{
    
    [extrasTableView reloadData];
    
    if([self.ballEventRecord objNoball].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
    if([self.ballEventRecord objWide].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    if([self.ballEventRecord objLegByes].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
    if([self.ballEventRecord objByes].integerValue==1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [extrasTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
}


-(void) calculateRunsOnEndBall   {
    //Wides and Noball calculation.
    if (self.ballEventRecord.objIslegalball.integerValue == 0)//Illegal ball.
    {
        if (self.ballEventRecord.objWide.integerValue != 0)
        {
            self.ballEventRecord.objWide = [NSNumber numberWithInt: (self.ballEventRecord.objRuns.intValue + self.ballEventRecord.objOverthrow.intValue) + 1];
            self.ballEventRecord.objRuns = 0;
        }
        else if (self.ballEventRecord.objNoball.integerValue != 0)
        {
            if (self.ballEventRecord.objByes.integerValue != 0 || self.ballEventRecord.objLegByes.integerValue != 0)
            {
                
                self.ballEventRecord.objNoball = [NSNumber numberWithInt:1];
                
                self.ballEventRecord.objByes = self.ballEventRecord.objByes.integerValue > 0 ?  [NSNumber numberWithInt: (self.ballEventRecord.objRuns.intValue + self.ballEventRecord.objOverthrow.intValue)] : self.ballEventRecord.objByes;
                
                self.ballEventRecord.objLegByes =  self.ballEventRecord.objLegByes.integerValue>0?
                [NSNumber numberWithInt: self.ballEventRecord.objRuns.intValue+ self.ballEventRecord.objOverthrow.intValue]:
                self.ballEventRecord.objLegByes;
                self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
            }
            else
            {
                self.ballEventRecord.objNoball = [NSNumber numberWithInt:1];
            }
        }
    }
    else//Legal ball.
    {
        
        if (self.ballEventRecord.objByes.integerValue != 0 || self.ballEventRecord.objLegByes.integerValue != 0)
        {
            
            self.ballEventRecord.objByes = self.ballEventRecord.objByes.integerValue > 0 ?  [NSNumber numberWithInt: self.ballEventRecord.objRuns.intValue + self.ballEventRecord.objOverthrow.intValue] : self.ballEventRecord.objByes;
            
            self.ballEventRecord.objLegByes =  self.ballEventRecord.objLegByes.integerValue>0?
            [NSNumber numberWithInt: self.ballEventRecord.objRuns.intValue+ self.ballEventRecord.objOverthrow.intValue]:
            self.ballEventRecord.objLegByes;
            self.ballEventRecord.objRuns = [NSNumber numberWithInt:0];
        }
          }
    
    self.ballEventRecord.objTotalruns =
    (self.ballEventRecord.objRuns.intValue+( self.ballEventRecord.objByes.intValue == 0 &&  self.ballEventRecord.objLegByes.intValue == 0 &&  self.ballEventRecord.objWide.intValue == 0)) ? [NSNumber numberWithInt: self.ballEventRecord.objOverthrow.intValue]: [NSNumber numberWithInt:0];
    //Total runs scored for the particular ball including byes or legbyes.
    
    int totalExtras = 0;
    self.ballEventRecord.objTotalextras = [NSNumber numberWithInt: self.ballEventRecord.objNoball.intValue +self.ballEventRecord.objWide.intValue+self.ballEventRecord.objByes.intValue+self.ballEventRecord.objLegByes.intValue+self.ballEventRecord.objPenalty.intValue];
    /*+ ((Byes > 0 || Legbyes > 0) ? Overthrow : 0)*/;
}




//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}


- (IBAction)btn_AppealSave:(id)sender {
    
   // UIColor colorWithRed:84 green:106 blue:126 alpha:0
     NSString *commentText =[NSString stringWithFormat:@"%@",[_comments_txt text]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:AppealSystemSelectCode forKey:@"AppealSystemSelct"];
    [dic setValue:AppealComponentSelectCode forKey:@"AppealComponentSelct"];
    [dic setValue:AppealUmpireSelectCode forKey:@"AppealUmpireSelct"];
     [dic setValue:AppealBatsmenSelectCode forKey:@"AppealBatsmenSelct"];
    [dic setValue:commentText forKey:@"Commenttext"];
}
@end
