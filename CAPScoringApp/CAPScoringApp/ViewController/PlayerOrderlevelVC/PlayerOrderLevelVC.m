//
//  PlayerOrderLevelVC.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 01/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerOrderLevelVC.h"
#import "CustomNavigationVC.h"
#import "PlayerLevelCell.h"
#import "SelectPlayerRecord.h"

@interface PlayerOrderLevelVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CustomNavigationVC *objCustomNavigation;
    NSMutableArray * slecteplayerlist;
}
@property(nonatomic,strong)UITableView * tbl_playerSelectList;
@end

@implementation PlayerOrderLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self customnavigationmethod];
    slecteplayerlist=[[NSMutableArray alloc]init];
    slecteplayerlist=self.objSelectplayerList_Array;
    
    UIImageView *bg_img=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height,self.view.frame.size.width,self.view.frame.size.height)];
    bg_img.image=[UIImage imageNamed:@"BackgroundImg"];
    [self.view addSubview:bg_img];
    
    
    // search design
    UIView * searchView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,objCustomNavigation.view.frame.origin.y+20,self.view.frame.size.width-20, 100)];
    [bg_img addSubview:searchView];
    [searchView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
    UITextField *lastName = [[UITextField alloc] initWithFrame:CGRectMake(10,110,300,70)];
    [searchView addSubview:lastName];
    
    lastName.placeholder = @"Enter your last name here";
    lastName.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0]; // text font
    lastName.adjustsFontSizeToFitWidth = YES;     //adjust the font size to fit width.
    
    lastName.textColor = [UIColor greenColor];             //text color
    lastName.keyboardType = UIKeyboardTypeAlphabet;        //keyboard type of ur choice
    lastName.returnKeyType = UIReturnKeyDone;              //returnKey type for keyboard
    lastName.clearButtonMode = UITextFieldViewModeWhileEditing;//for clear button on right side
    
    lastName.delegate = self;              //use this when ur using Delegate methods of UITextField
    
    
    UIButton *Btn_objSearch=[[UIButton alloc]initWithFrame:CGRectMake(searchView.frame.size.width-80,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+30,70,70)];
    [Btn_objSearch setBackgroundColor:[UIColor clearColor]];
    [Btn_objSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
    [Btn_objSearch addTarget:self action:@selector(didClickSearchplayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn_objSearch];
    
    
    
    
    // Bottomview design
    
    
    UIView * BottomView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,bg_img.frame.size.height-200,self.view.frame.size.width-20, 100)];
    [bg_img addSubview:BottomView];
    [BottomView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
    
    UIImageView *Img_Delete=[[UIImageView alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-190,15,70,70)];
    
    [Img_Delete setImage:[UIImage imageNamed:@"ico-cancel"]];
    [BottomView addSubview:Img_Delete];
    
    
    UIImageView *Img_Save=[[UIImageView alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-90,15,70,70)];
    
    [Img_Save setImage:[UIImage imageNamed:@"ico-proceed"]];
    [BottomView addSubview:Img_Save];
    
    
    UIButton *Btn_Delete=[[UIButton alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-190,15,70,70)];
    [Btn_Delete setBackgroundColor:[UIColor clearColor]];
    //[Btn_Delete setImage:[UIImage imageNamed:@"ico-cancel"] forState:UIControlStateNormal];
    [Btn_Delete addTarget:self action:@selector(didClickDeleteplayer) forControlEvents:UIControlEventTouchUpInside];
    [BottomView addSubview:Btn_Delete];
    
    
    
    UIButton *Btn_Save=[[UIButton alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-90,15,70,70)];
    [Btn_Save setBackgroundColor:[UIColor clearColor]];
    //[Btn_Save setImage:[UIImage imageNamed:@"ico-proceed"] forState:UIControlStateNormal];
    [Btn_Save addTarget:self action:@selector(didClickSaveplayer) forControlEvents:UIControlEventTouchUpInside];
    
    [BottomView addSubview:Btn_Save];
    
    
    // tableview design
    
    
    self. tbl_playerSelectList= [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+20,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+150,self.view.frame.size.width-40,BottomView.frame.origin.y-160)];
    [self.view addSubview: self.tbl_playerSelectList];
    self.tbl_playerSelectList.backgroundColor=[UIColor clearColor];
    //[ self.tbl_playerSelectList setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    self.tbl_playerSelectList.delegate=self;
    self.tbl_playerSelectList.dataSource=self;
    self.tbl_playerSelectList.scrollEnabled=YES;
    
    
    // self.tbl_playerSelectList.bounces = YES;
    
    // Do any additional setup after loading the view.
}

-(void)customnavigationmethod
{
    objCustomNavigation=[[CustomNavigationVC alloc] initWithNibName:@"CustomNavigationVC" bundle:nil];
    [self.view addSubview:objCustomNavigation.view];
    objCustomNavigation.lbl_titleName.text=@"PLAYING XI";
    [objCustomNavigation.Btn_Back addTarget:self action:@selector(Back_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didClickSearchplayer
{
    
}
-(void)didClickDeleteplayer
{
    
}

-(void)didClickSaveplayer
{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [slecteplayerlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger variable = indexPath.row;
    int ordernumber = (int) variable +1;
    
    if (cell == nil) {
        cell = [[PlayerLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    SelectPlayerRecord *objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
    
    
    cell.Lbl_playerordernumber.text=[NSString stringWithFormat:@"%d",ordernumber];
    if(ordernumber == 12)
    {
        cell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (12 Member)",objSelectPlayerRecord.playerName] ;
    }
    else if (ordernumber > 12)
    {
        cell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (Sub)",objSelectPlayerRecord.playerName] ;
    }
    else
    {
        cell.lbl_playerName.text =[NSString stringWithFormat:@"%@",objSelectPlayerRecord.playerName] ;
    }
    self.tbl_playerSelectList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
    PlayerLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
