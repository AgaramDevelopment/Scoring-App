//
//  TorunamentVC.m
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "TorunamentVC.h"
#import "DBManager.h"
#import "EventRecord.h"
#import "TossDetailsVC.h"
#import "FixturesVC.h"
#import "CustomNavigationVC.h"
#import "ArchivesVC.h"
#import "Reachability.h"

@interface TorunamentVC ()
{
    BOOL isEnableTbl;
    NSMutableArray * selectindexarray;
    UIRefreshControl *refreshControl;
   }
@property (nonatomic,strong)NSMutableArray*resultArray;
@property(nonatomic,weak) IBOutlet UIView *selectmatchTittleview;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@end

@implementation TorunamentVC
@synthesize resultArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customnavigationmethod];
    // Do any additional setup after loading the view.
    [self.tableView setHidden:YES];
    self.Nextbtn_outlet.enabled = NO;
    //[self didClickNextBtnAction setHidden:YES];
    [self.selectmatchTittleview .layer setBorderWidth:2.0];
    [self.selectmatchTittleview.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.selectmatchTittleview .layer setMasksToBounds:YES];
   
    if(self.checkInternetConnection)
    {
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refreshControl.tintColor = [UIColor blueColor];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
        
        
        resultArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchCompitionArray =[DBManager RetrieveEventData];
        for(int i=0; i < [FetchCompitionArray count]; i++)
        {
            
            EventRecord *objEventRecord=(EventRecord*)[FetchCompitionArray objectAtIndex:i];
            NSLog(@"%@",objEventRecord.recordstatus);
            NSString *matchStatus=objEventRecord.recordstatus;
            if([matchStatus isEqualToString:@"MSC001"])
            {
                [resultArray addObject:objEventRecord];
            }
            //NSString * matchStatus=[FetchCompitionArray valueForKey:@""];
        }
        
        
        [self.tableView reloadData];
        
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
        [refreshControl endRefreshing];
        
        [self.tableView addSubview:refresh];
    }
}



-(void)crunchNumbers
{
    resultArray=[[NSMutableArray alloc]init];
    NSMutableArray * FetchCompitionArray =[DBManager RetrieveEventData];
    for(int i=0; i < [FetchCompitionArray count]; i++)
    {
        
        EventRecord *objEventRecord=(EventRecord*)[FetchCompitionArray objectAtIndex:i];
        NSLog(@"%@",objEventRecord.recordstatus);
        NSString *matchStatus=objEventRecord.recordstatus;
        if([matchStatus isEqualToString:@"MSC001"])
        {
            [resultArray addObject:objEventRecord];
        }
        //NSString * matchStatus=[FetchCompitionArray valueForKey:@""];
    }
    
    
    [self.tableView reloadData];
    
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];

}


- (void)stopRefresh

{
    
    [refreshControl endRefreshing];
    
}



-(void)customnavigationmethod
{
    CustomNavigationVC *objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"SELECT TOURNAMENT";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.selectmatchTittleview .layer setBorderWidth:2.0];
    [self.selectmatchTittleview.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    [self.selectmatchTittleview .layer setMasksToBounds:YES];
    isEnableTbl=YES;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [resultArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    EventRecord *objEventRecord=(EventRecord*)[resultArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text =objEventRecord.competitionname;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectindexarray=[[NSMutableArray alloc]init];
    EventRecord *objEventRecord=(EventRecord*)[resultArray objectAtIndex:indexPath.row];
    self.selectMatchName.text =objEventRecord.competitionname;
    [selectindexarray addObject:objEventRecord];
    
    self.tableView.hidden=YES;
    isEnableTbl=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)Btn_touch:(id)sender {
    if(isEnableTbl==YES)
    {
        resultArray=[[NSMutableArray alloc]init];
        NSMutableArray * FetchCompitionArray =[DBManager RetrieveEventData];
        for(int i=0; i < [FetchCompitionArray count]; i++)
        {
            
            EventRecord *objEventRecord=(EventRecord*)[FetchCompitionArray objectAtIndex:i];
            NSLog(@"%@",objEventRecord.recordstatus);
            NSString *matchStatus=objEventRecord.recordstatus;
            if([matchStatus isEqualToString:@"MSC001"])
            {
                [resultArray addObject:objEventRecord];
            }
            //NSString * matchStatus=[FetchCompitionArray valueForKey:@""];
        }
        
        
        [self.tableView reloadData];
        self.tableView.hidden=NO;
        isEnableTbl=NO;
        self.Nextbtn_outlet.enabled = YES;
    }
}

-(IBAction)didClickNextBtnAction:(id)sender
{
    if([self.selectDashBoard isEqualToString:@"Newmatch"])
    {
        FixturesVC*Fixvc = [[FixturesVC alloc]init];
    
        Fixvc =  (FixturesVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"fixtureSBID"];
        EventRecord *eventRecord = [selectindexarray objectAtIndex:0] ;
        Fixvc.CompitionCode=eventRecord.competitioncode;

        [self.navigationController pushViewController:Fixvc animated:YES];
    }
else{
        ArchivesVC * objArchiveVC=[[ArchivesVC alloc]init];
        objArchiveVC=(ArchivesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ArchivesVC"];
    EventRecord *eventRecord = [selectindexarray objectAtIndex:0] ;
    objArchiveVC.CompitionCode=[eventRecord competitioncode];
        [self.navigationController pushViewController:objArchiveVC animated:YES];
    }
    
}


- (BOOL)checkInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end



