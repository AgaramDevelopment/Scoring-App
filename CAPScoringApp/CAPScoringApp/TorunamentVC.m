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
#import "FixturesTvc.h"
@interface TorunamentVC ()
{
    BOOL isEnableTbl;
    NSMutableArray * selectindexarray;
}
@property (nonatomic,strong)NSMutableArray*resultArray;
@property(nonatomic,weak) IBOutlet UIView *selectmatchTittleview;

@end

@implementation TorunamentVC
@synthesize resultArray;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    [self.tableView setHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.selectmatchTittleview .layer setBorderWidth:2];
    [self.selectmatchTittleview.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.selectmatchTittleview .layer setMasksToBounds:YES];
    isEnableTbl=YES;
    
}

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
    }
}

-(IBAction)didClickNextBtnAction:(id)sender
{

UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FixturesTvc *fixt =  (FixturesTvc*)[storyboard instantiateViewControllerWithIdentifier:@"Fixtures"];
     fixt.fixArray=selectindexarray;
    [self.navigationController pushViewController:fixt animated:YES];

}
@end
