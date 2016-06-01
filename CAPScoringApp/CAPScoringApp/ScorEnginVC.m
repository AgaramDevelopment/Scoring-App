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

@interface ScorEnginVC () <CDRTranslucentSideBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *Btn_NameArray;
    BOOL isSelectleftview;
    UITableView* objextras;
    BallEventRecord *objBalleventRecord;
    
}

@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
@property(nonatomic,strong) NSMutableArray *selectbtnvalueArray;
@property(nonatomic,strong) NSMutableArray *AppealValuesArray;
@property(nonatomic,strong) NSMutableArray *otwRtwArray;

@end

@implementation ScorEnginVC
@synthesize table_Appeal;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    self.sideBar.sideBarWidth = 200;
    self.sideBar.delegate = self;
    self.sideBar.tag = 0;
    
    // Create Right SideBar
    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirectionFromRight:YES];
    self.rightSideBar.delegate = self;
    self.rightSideBar.translucentStyle = UIBarStyleBlack;
    self.rightSideBar.tag = 1;
    
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
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.btn_StartBall.userInteractionEnabled=NO;
    [self AllBtndisableMethod];
}

#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    // if you have left and right sidebar, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            self.sideBar.isCurrentPanGestureTarget = YES;
        }
        // Right SideBar
        else {
            self.rightSideBar.isCurrentPanGestureTarget = YES;
        }
    }
    
    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
    [self.rightSideBar handlePanGestureToShow:recognizer inViewController:self];
    
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
    
    if([self.selectbtnvalueArray count] > 0)
    {
        return self.selectbtnvalueArray.count;
        
    }else if (tableView == table_Appeal) {
        
        return self.AppealValuesArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [self.selectbtnvalueArray objectAtIndex:indexPath.row];
    
    
    
    if (tableView == table_Appeal) {
//        static NSString *CellIdentifier = @"Cell";
//            AppealCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
//                                                                 forIndexPath:indexPath];
//        
//            AppealRecord *objAppealrecord=(AppealRecord*)[_AppealValuesArray objectAtIndex:indexPath.row];
//        
//        
//            cell.AppealName_lbl.text=objAppealrecord.MetaSubCodeDescriptision;
        
//        
//        static NSString *MyIdentifier4 = @"Cell";
        
                static NSString *CellIdentifier = @"Cell";
                    AppealCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                         forIndexPath:indexPath];
        
                    AppealRecord *objAppealrecord=(AppealRecord*)[_AppealValuesArray objectAtIndex:indexPath.row];
        
        
                    cell.AppealName_lbl.text=objAppealrecord.MetaSubCodeDescriptision;
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
    if([self.btn_StartBall.currentTitle isEqualToString:@"START BALL"])
    {
        [self.btn_StartBall setTitle:@"END BALL" forState:UIControlStateNormal];
        self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
        self.btn_StartOver.userInteractionEnabled=NO;
        [self AllBtnEnableMethod];
        
    }
    else
    {
        [self.btn_StartBall setTitle:@"START BALL" forState:UIControlStateNormal];
        self.btn_StartBall.backgroundColor=[UIColor colorWithRed:(12/255.0f) green:(26/255.0f) blue:(43/255.0f) alpha:1.0f];
        self.btn_StartOver.userInteractionEnabled=YES;
        self.btn_StartBall.userInteractionEnabled=NO;
        [self AllBtndisableMethod];
        [DBManager saveBallEventData:objBalleventRecord];
        //[DBManager saveBallEventData:objBalleventRecord otwOrRtw:];
    }
}
-(IBAction)DidClickStartOver:(id)sender
{
    NSLog(@"btnname%@",self.btn_StartOver.currentTitle);
    if([self.btn_StartOver.currentTitle isEqualToString:@"START OVER"])
    {
        self.btn_StartOver.backgroundColor=[UIColor colorWithRed:(243/255.0f) green:(150/255.0f) blue:(56/255.0f) alpha:1.0f];
        [self.btn_StartOver setTitle:@"END OVER" forState:UIControlStateNormal];
        self.btn_StartBall.userInteractionEnabled=YES;
        self.btn_StartOver.userInteractionEnabled=NO;
        
        
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
    
    UIButton *selectBtnTag=(UIButton*)sender;
    
    if(selectBtnTag.tag==100)
    {
        [self selectBtncolor_Action:@"100" :self.btn_run1 :0];
    }
    else if(selectBtnTag.tag==101)
    {
        [self selectBtncolor_Action:@"101" :self.btn_run2 :0];
    }
    else if(selectBtnTag.tag==102)
    {
        [self selectBtncolor_Action:@"102" :self.btn_run3 :0];
    }
    else if(selectBtnTag.tag==103)
    {
        [self selectBtncolor_Action:@"103" :self.btn_highRun :0];
        
        [self highrunMethods:selectBtnTag];
    }
    else if(selectBtnTag.tag==104)
    {
        [self selectBtncolor_Action:@"104" :self.btn_B4 :0];
    }
    else if(selectBtnTag.tag==105)
    {
        [self selectBtncolor_Action:@"105" :self.btn_B6 :0];
    }
    else if(selectBtnTag.tag==106)
    {
        [self selectBtncolor_Action:@"106" :self.btn_extras :0];
        
        self.selectbtnvalueArray=[[NSMutableArray alloc]initWithObjects:@"NoBall",@"Wide",@"Byes",@"LegByes", nil];
        [self selelectbtnPop_View:selectBtnTag];
        
    }
    else if(selectBtnTag.tag==107)
    {
        [self selectBtncolor_Action:@"107" :self.btn_wkts :0];
    }
    else if(selectBtnTag.tag==108)
    {
        [self selectBtncolor_Action:@"108" :self.btn_overthrow :0];
        self.selectbtnvalueArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
        [self selelectbtnPop_View:selectBtnTag];
    }
    else if(selectBtnTag.tag==109)
    {
        [self selectBtncolor_Action:@"109" :self.btn_miscFilter :0];
    }
    else if(selectBtnTag.tag==110)
    {
        [self selectBtncolor_Action:@"110" :self.btn_pichmap :0];
        [self.img_pichmap setImage:[UIImage imageNamed:@"pitchmap_img"]];
           _View_Appeal.hidden=YES;
    }
    else if(selectBtnTag.tag==111)
    {
        [self selectBtncolor_Action:@"111" :self.btn_wagonwheel :0];
        [self.img_pichmap setImage:[UIImage imageNamed:@"WagonWheel_img"]];
         _View_Appeal.hidden=YES;
        
    }
}
-(void) highrunMethods:(UIButton *) select_btn
{
    
    if([self.btn_highRun.currentImage isEqual:[UIImage imageNamed:@"moreRuns"]])
    {
        [self.btn_highRun setImage:[UIImage imageNamed:@"dropDown"] forState:UIControlStateNormal];
        CGFloat btn_1=[[self.btn_run1 currentTitle] integerValue]+3;
        CGFloat btn_2=[[self.btn_run2 currentTitle] integerValue]+3;
        CGFloat btn_3=[[self.btn_run3 currentTitle] integerValue]+3;
        self.btn_run1.titleLabel.text=[NSString stringWithFormat:@"%f",btn_1];
        self.btn_run2.titleLabel.text=[NSString stringWithFormat:@"%f",btn_2];
        self.btn_run3.titleLabel.text=[NSString stringWithFormat:@"%f",btn_3];
    }
    else{
        [self.btn_highRun setImage:[UIImage imageNamed:@"moreRuns"] forState:UIControlStateNormal];
        CGFloat btn_1=[[self.btn_run1 currentTitle] integerValue]-3;
        CGFloat btn_2=[[self.btn_run2 currentTitle] integerValue]-3;
        CGFloat btn_3=[[self.btn_run3 currentTitle] integerValue]-3;
        self.btn_run1.titleLabel.text=[NSString stringWithFormat:@"%f",btn_1];
        self.btn_run2.titleLabel.text=[NSString stringWithFormat:@"%f",btn_2];
        self.btn_run3.titleLabel.text=[NSString stringWithFormat:@"%f",btn_3];
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
        
        [self selectBtncolor_Action:@"112" :nil :201];
        NSString *otw;
        
        AppealRecord *objAppealrecord=(AppealRecord*)[_otwRtwArray objectAtIndex:0];
        otw = objAppealrecord.MetaSubCode;
        
        objBalleventRecord.objAtworotw = [NSString stringWithFormat:@"%@",otw];
        
        
        
    }
    else if(selectBtnTag.tag==113)
    {
        [self selectBtncolor_Action:@"113" :nil :202];
    }
    else if(selectBtnTag.tag==114)
    {
        [self selectBtncolor_Action:@"114" :nil :203];
    }
    else if(selectBtnTag.tag==115)
    {
        [self selectBtncolor_Action:@"115" :nil :204];
    }
    else if(selectBtnTag.tag==116)
    {
        [self selectBtncolor_Action:@"116" :nil :205];
    }
    else if(selectBtnTag.tag==117)
    {
        [self selectBtncolor_Action:@"117" :nil :206];
    }
    else if(selectBtnTag.tag==118)
    {
        [self selectBtncolor_Action:@"118" :nil :207];
    }
    else if(selectBtnTag.tag==119)
    {
        [self selectBtncolor_Action:@"119" :nil :208];
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




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
_view_table_select.hidden=NO;
}


@end
