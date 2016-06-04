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
#import "DBManager.h"

@interface PlayerOrderLevelVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CustomNavigationVC *objCustomNavigation;
   
    BOOL isSelectCaptainType;
    BOOL isSelectWKTKeeperType;
    NSMutableArray*slecteplayerlist;
    UIGestureRecognizer *_dndLongPressGestureRecognizer;
    PlayerLevelCell*playercell;
    NSMutableArray *objPreviousorderList;
    

}
@property (nonatomic, getter=isPseudoEditing) BOOL pseudoEdit;
@property(nonatomic,strong)UITableView * tbl_playerSelectList;
@property(nonatomic,strong)UITextField *txt_search;
@property(nonatomic,strong) NSMutableArray*selectedPlayerFilterArray;
@property(nonatomic,strong)  UIButton *Btn_objSearch;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UIImageView *draggingView;
@property (nonatomic, assign) CGFloat scrollRate;
@property (nonatomic, strong) NSIndexPath *currentLocationIndexPath;
@property (nonatomic, strong) NSIndexPath *initialIndexPath;
@property (nonatomic, retain) id savedObject;
@property (nonatomic, strong) CADisplayLink *scrollDisplayLink;
@property (nonatomic, assign) CGFloat draggingRowHeight;
@property (nonatomic, assign) CGFloat draggingViewOpacity;

@end

@implementation PlayerOrderLevelVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self customnavigationmethod];
    
    slecteplayerlist=[[NSMutableArray alloc]init];
    objPreviousorderList=[[NSMutableArray alloc]init];
    slecteplayerlist=self.objSelectplayerList_Array;
    objPreviousorderList=slecteplayerlist;
    UIImageView *bg_img=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height,self.view.frame.size.width,self.view.frame.size.height)];
    bg_img.image=[UIImage imageNamed:@"BackgroundImg"];
    [self.view addSubview:bg_img];
    
    
    // search design
    UIView * searchView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,objCustomNavigation.view.frame.origin.y+20,self.view.frame.size.width-20, 90)];
    [bg_img addSubview:searchView];
    [searchView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
    self.txt_search = [[UITextField alloc] initWithFrame:CGRectMake(20,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+20,self.view.frame.size.width-150,80)];
    [self.view addSubview:self.txt_search];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"SEARCH PLAYER" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] ,NSFontAttributeName : [UIFont systemFontOfSize:35]}];
   
     self.txt_search.attributedPlaceholder = str;
    //lastName.placeholder = @"Enter your last name here";
    
    self.txt_search.font = [UIFont systemFontOfSize:40];
    self.txt_search.adjustsFontSizeToFitWidth = YES;
    self.txt_search.backgroundColor=[UIColor clearColor];
    
    self.txt_search.textColor = [UIColor whiteColor];
    self.txt_search.keyboardType = UIKeyboardTypeAlphabet;
    self.txt_search.returnKeyType = UIReturnKeyDone;
    self.txt_search.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.txt_search.delegate = self;
    
    
    self.Btn_objSearch=[[UIButton alloc]initWithFrame:CGRectMake(searchView.frame.size.width-80,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+30,70,70)];
    [self.Btn_objSearch setBackgroundColor:[UIColor clearColor]];
    [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
    [self.Btn_objSearch addTarget:self action:@selector(didClickSearchplayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.Btn_objSearch];
    
    
    
    
    // Bottomview design
    
    
    UIView * BottomView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,bg_img.frame.size.height-200,self.view.frame.size.width-20, 100)];
    [bg_img addSubview:BottomView];
    [BottomView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
    
    UIImageView *Img_Delete=[[UIImageView alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-180,25,52,52)];
    
    [Img_Delete setImage:[UIImage imageNamed:@"ico-cancel"]];
    
    [BottomView addSubview:Img_Delete];
    
   
    
    UIImageView *Img_Save=[[UIImageView alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-90,25,52,52)];
    
    [Img_Save setImage:[UIImage imageNamed:@"ico-proceed"]];
    [BottomView addSubview:Img_Save];
    
    
    UIButton *Btn_Delete=[[UIButton alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-180,bg_img.frame.size.height-80,70,70)];
    [Btn_Delete setBackgroundColor:[UIColor clearColor]];
    //[Btn_Delete setImage:[UIImage imageNamed:@"ico-cancel"] forState:UIControlStateNormal];
    [Btn_Delete addTarget:self action:@selector(didClickDeleteplayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn_Delete];
    
    
    
    UIButton *Btn_Save=[[UIButton alloc]initWithFrame:CGRectMake(BottomView.frame.size.width-90,bg_img.frame.size.height-80,70,70)];
    [Btn_Save setBackgroundColor:[UIColor clearColor]];
    //[Btn_Save setImage:[UIImage imageNamed:@"ico-proceed"] forState:UIControlStateNormal];
    [Btn_Save addTarget:self action:@selector(didClickSaveplayer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:Btn_Save];
    
    
    // tableview design
    
    _tbl_playerSelectList = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+20,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+150,self.view.frame.size.width-40,BottomView.frame.origin.y-160)];
    [self.view addSubview:_tbl_playerSelectList];
    _tbl_playerSelectList.backgroundColor=[UIColor clearColor];
    //[ self.tbl_playerSelectList setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    _tbl_playerSelectList.delegate=self;
    _tbl_playerSelectList.dataSource=self;
    //tbl_playerSelectList.scrollEnabled=YES;
    
    

    // self.tbl_playerSelectList.bounces = YES;
    
    // Do any additional setup after loading the view.
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Move this asignment to the method/action that
    // handles table editing for bulk operation.
    self.pseudoEdit = YES;
    
    [super setEditing:editing animated:animated];
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
    if([self.Btn_objSearch.currentImage  isEqual: [UIImage imageNamed:@"ico-cancel"]]){
        self.txt_search.text =@"";
        [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
        [self.selectedPlayerFilterArray removeAllObjects];
        self.selectedPlayerFilterArray = [[NSMutableArray alloc]initWithArray: self.objSelectplayerList_Array ];
        
        
    }else{
        
//        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"playerName contains[c] %@",self.txt_search.text];
//        
//        NSArray *filtedPlayerArray =  [self.objSelectplayerList_Array filteredArrayUsingPredicate:resultPredicate];
//        
//        // NSLog(@"count %lu",(unsigned long)[self.selectedPlayerArray count]);
//        
//        [self.selectedPlayerFilterArray removeAllObjects];
//        
//        //    NSLog(@"count2 %lu",(unsigned long)[self.selectedPlayerArray count]);
//        
//        self.selectedPlayerFilterArray = [[NSMutableArray alloc] initWithArray:filtedPlayerArray];
        
        
    }
    //Relaod view
    [_tbl_playerSelectList reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  
    //textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.Btn_objSearch setImage:[UIImage imageNamed:@"ico-cancel"] forState:UIControlStateNormal];
    NSLog(@"textFieldDidBeginEditing");
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (![string isEqualToString:@""]) {
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"playerName contains[c] %@",self.txt_search.text];
        
        NSArray *filtedPlayerArray =  [self.objSelectplayerList_Array filteredArrayUsingPredicate:resultPredicate];
        
        // NSLog(@"count %lu",(unsigned long)[self.selectedPlayerArray count]);
        
        [self.selectedPlayerFilterArray removeAllObjects];
        
        //    NSLog(@"count2 %lu",(unsigned long)[self.selectedPlayerArray count]);
        
        self.selectedPlayerFilterArray = [[NSMutableArray alloc] initWithArray:filtedPlayerArray];
        [_tbl_playerSelectList reloadData];

        return YES;
    }
    else {
        return NO;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
   
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {
        UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}
-(IBAction)didClickDeleteplayer:(id)sender
{
    slecteplayerlist=objPreviousorderList;
    [self.tbl_playerSelectList reloadData];
}

-(IBAction)didClickSaveplayer:(id)sender
{
   
    for(int i=0;  i < slecteplayerlist.count; i++)
    {
        SelectPlayerRecord *playerorderRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:i];
        [DBManager updatePlayerorder:self.MatchCode :self.TeamCode PlayerCode:playerorderRecord.playerCode PlayerOrder:playerorderRecord.playerOrder];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.selectedPlayerFilterArray > 0)
   {
      return [self.selectedPlayerFilterArray count];
   }
 else
   {
      return [slecteplayerlist  count];
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   playercell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger variable = indexPath.row;
    int ordernumber =(int) variable +1;
    SelectPlayerRecord *objSelectPlayerRecord;
    
    if (playercell == nil) {
        playercell = [[PlayerLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        playercell.backgroundColor = [UIColor clearColor];
       
        
        
    }
    [playercell.Btn_Captain addTarget:self action:@selector(didClickCaptain_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [playercell.Btn_WktKeeper addTarget:self action:@selector(didClickWktKeeper_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [playercell.Btn_drag addTarget:self action:@selector(didClickDrag_BtnAction:) forControlEvents:UIControlEventTouchUpInside];


//    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [playercell addGestureRecognizer: self.longPress];
    
    
    if(self.selectedPlayerFilterArray > 0)
    {
        objSelectPlayerRecord=(SelectPlayerRecord*)[self.selectedPlayerFilterArray objectAtIndex:indexPath.row];
    }
    else
    {
       objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
    }
    
    //NSString *playerOrder=[NSString stringWithFormat:@"%@",objSelectPlayerRecord.playerOrder];
    
    playercell.Lbl_playerordernumber.text=[NSString stringWithFormat:@"%d",ordernumber];
    //ordernumber=[ intValue];
    
    if(ordernumber==12)
    {
        playercell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (12 Member)",objSelectPlayerRecord.playerName] ;
    }
    else if (ordernumber > 12)
    {
        playercell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (Sub)",objSelectPlayerRecord.playerName] ;
    }
    else if(ordernumber < 12)
    {
        playercell.lbl_playerName.text =[NSString stringWithFormat:@"%@",objSelectPlayerRecord.playerName] ;
    }
    playercell.IMg_captain.image=([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])?[UIImage imageNamed:@"Img_Captain"]:nil;
    playercell.Img_wktkeeper.image=([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])?[UIImage imageNamed:@"Img_wktKeeper"]:nil;
    
    playercell.shouldIndentWhileEditing = YES;
    playercell.showsReorderControl = YES;
    [playercell setEditing:self.isEditing];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     playercell.selectionStyle = UITableViewCellSelectionStyleNone;
    return playercell;
}


-(IBAction)didClickDrag_BtnAction:(id)sender
{
    //[playercell setEditing: playercell.editing animated: YES];
    
   // self.showsReorderControl = NO;
    
    //self.editingAccessoryView = editing ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourReorderIcon"]] : nil;
   
    [self.tbl_playerSelectList setEditing:!playercell.editing animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   playercell = [tableView cellForRowAtIndexPath:indexPath];
   NSIndexPath * indexPaths = [_tbl_playerSelectList indexPathForCell:playercell];
   SelectPlayerRecord* objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPaths.row];
    if(isSelectCaptainType==NO)
    {
        playercell.IMg_captain.frame=CGRectMake(playercell.contentView.frame.size.width-130, 15,50, 50);
        playercell.Btn_Captain.frame=CGRectMake(playercell.contentView.frame.size.width-130, 15,50, 50);
        playercell.IMg_captain.image=[UIImage imageNamed:@"Img_Captain"];
        [playercell.IMg_captain setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
               objSelectPlayerRecord.isSelectCapten=@"YES";
       

        isSelectCaptainType=YES;
    }
    else{
        if(isSelectWKTKeeperType== NO)
        {
            //objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
           
            if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
            {
                playercell.IMg_captain.frame=CGRectMake(playercell.contentView.frame.size.width-180, 15,50, 50);
                playercell.Btn_Captain.frame=CGRectMake(playercell.contentView.frame.size.width-190, 15,50, 50);
            }
            else{
                playercell.IMg_captain.frame=CGRectMake(playercell.contentView.frame.size.width-180, 15,50, 50);
                playercell.Btn_Captain.frame=CGRectMake(playercell.contentView.frame.size.width-190, 15,50, 50);
            }
            playercell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
             objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
            objSelectPlayerRecord.isSelectWKTKeeper=@"YES";
            [playercell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
            isSelectWKTKeeperType=YES;
        }
    }
}

-(IBAction)didClickCaptain_BtnAction:(id)sender
{
    
    PlayerLevelCell *Cell = (PlayerLevelCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_tbl_playerSelectList indexPathForCell:Cell];
    SelectPlayerRecord * objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];

    if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
    {
        Cell.IMg_captain.image=[UIImage imageNamed:@""];
        [Cell.IMg_captain setBackgroundColor:[UIColor clearColor]];
        Cell.IMg_captain.frame=CGRectMake(Cell.contentView.frame.size.width-180, 15,50, 50);
        Cell.Btn_Captain.frame=CGRectMake(Cell.contentView.frame.size.width-190, 15,50, 50);
        isSelectCaptainType=NO;
        objSelectPlayerRecord.isSelectCapten=nil;
    }
}
-(IBAction)didClickWktKeeper_BtnAction:(id)sender
{
    PlayerLevelCell *Cell = (PlayerLevelCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_tbl_playerSelectList indexPathForCell:Cell];
    SelectPlayerRecord * objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
    if([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])
    {
        Cell.Img_wktkeeper.image=[UIImage imageNamed:@""];
        [Cell.Img_wktkeeper setBackgroundColor:[UIColor clearColor]];
        objSelectPlayerRecord.isSelectWKTKeeper=nil;
        isSelectWKTKeeperType=NO;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.clipsToBounds = YES;
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    NSString * changeIndexId=[NSString stringWithFormat:@"%ld",destRow+1];
    SelectPlayerRecord*objRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:sourceRow];
    objRecord.playerOrder =changeIndexId;
    
    id object = [slecteplayerlist objectAtIndex:sourceRow];
    
    [slecteplayerlist removeObjectAtIndex:sourceRow];
    [slecteplayerlist insertObject:object atIndex:destRow];
    
    playercell.editing=NO;
    [self.tbl_playerSelectList setEditing:playercell.editing animated:YES];
    [self.tbl_playerSelectList reloadData];
    
}

-(IBAction)Back_BtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
