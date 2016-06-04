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
    BOOL isSelectCaptainType;
    BOOL isSelectWKTKeeperType;
    
    UIGestureRecognizer *_dndLongPressGestureRecognizer;
    

}
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
    UIView * searchView= [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+10,objCustomNavigation.view.frame.origin.y+20,self.view.frame.size.width-20, 90)];
    [bg_img addSubview:searchView];
    [searchView setBackgroundColor:[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f]];
    
    self.txt_search = [[UITextField alloc] initWithFrame:CGRectMake(20,objCustomNavigation.view.frame.origin.y+objCustomNavigation.view.frame.size.height+20,self.view.frame.size.width-150,80)];
    [self.view addSubview:self.txt_search];
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"SEARCH PLAYER" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] ,NSFontAttributeName : [UIFont systemFontOfSize:40]}];
   
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
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.tbl_playerSelectList addGestureRecognizer: self.longPress];

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
    [self.tbl_playerSelectList reloadData];
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
        [self.tbl_playerSelectList reloadData];

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
    
    if(self.selectedPlayerFilterArray > 0)
   {
      return [self.selectedPlayerFilterArray count];
   }
 else
   {
      return [slecteplayerlist count];
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
   // NSInteger variable = indexPath.row;
    int ordernumber ;//(int) variable +1;
    SelectPlayerRecord *objSelectPlayerRecord;
    
    if (cell == nil) {
        cell = [[PlayerLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
       
        
        
    }
    [cell.Btn_Captain addTarget:self action:@selector(didClickCaptain_BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Btn_WktKeeper addTarget:self action:@selector(didClickWktKeeper_BtnAction:) forControlEvents:UIControlEventTouchUpInside];

    _dndLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressGestureRecognizerTap:)];
    [cell addGestureRecognizer:_dndLongPressGestureRecognizer];
    if(self.selectedPlayerFilterArray > 0)
    {
        objSelectPlayerRecord=(SelectPlayerRecord*)[self.selectedPlayerFilterArray objectAtIndex:indexPath.row];
    }
    else
    {
       objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
    }
    
    NSString *playerOrder=[NSString stringWithFormat:@"%@",objSelectPlayerRecord.playerOrder];
    
    cell.Lbl_playerordernumber.text=playerOrder;
    ordernumber=[playerOrder intValue];
    
    if(ordernumber==12)
    {
        cell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (12 Member)",objSelectPlayerRecord.playerName] ;
    }
    else if (ordernumber > 12)
    {
        cell.lbl_playerName.text =[NSString stringWithFormat:@"%@   (Sub)",objSelectPlayerRecord.playerName] ;
    }
    else if(ordernumber < 12)
    {
        cell.lbl_playerName.text =[NSString stringWithFormat:@"%@",objSelectPlayerRecord.playerName] ;
    }
    cell.IMg_captain.image=([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])?[UIImage imageNamed:@"Img_Captain"]:nil;
    cell.Img_wktkeeper.image=([objSelectPlayerRecord.isSelectWKTKeeper isEqualToString:@"YES"])?[UIImage imageNamed:@"Img_wktKeeper"]:nil;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    PlayerLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   NSIndexPath * indexPaths = [self.tbl_playerSelectList indexPathForCell:cell];
   SelectPlayerRecord* objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPaths.row];
    if(isSelectCaptainType==NO)
    {
        cell.IMg_captain.frame=CGRectMake(cell.contentView.frame.size.width-130, 15,50, 50);
        cell.Btn_Captain.frame=CGRectMake(cell.contentView.frame.size.width-130, 15,50, 50);
        cell.IMg_captain.image=[UIImage imageNamed:@"Img_Captain"];
        [cell.IMg_captain setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
               objSelectPlayerRecord.isSelectCapten=@"YES";
       

        isSelectCaptainType=YES;
    }
    else{
        if(isSelectWKTKeeperType== NO)
        {
            //objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
           
            if([objSelectPlayerRecord.isSelectCapten isEqualToString:@"YES"])
            {
                cell.IMg_captain.frame=CGRectMake(cell.contentView.frame.size.width-180, 15,50, 50);
                cell.Btn_Captain.frame=CGRectMake(cell.contentView.frame.size.width-190, 15,50, 50);
            }
            else{
                cell.IMg_captain.frame=CGRectMake(cell.contentView.frame.size.width-180, 15,50, 50);
                cell.Btn_Captain.frame=CGRectMake(cell.contentView.frame.size.width-190, 15,50, 50);
            }
            cell.Img_wktkeeper.image=[UIImage imageNamed:@"Img_wktKeeper"];
             objSelectPlayerRecord=(SelectPlayerRecord*)[slecteplayerlist objectAtIndex:indexPath.row];
            objSelectPlayerRecord.isSelectWKTKeeper=@"YES";
            [cell.Img_wktkeeper setBackgroundColor:[UIColor colorWithRed:(0/255.0f) green:(160/255.0f) blue:(90/255.0f) alpha:1.0f]];
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


- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self];
    NSIndexPath *indexPath = [self.tbl_playerSelectList indexPathForRowAtPoint:location];
    
    int sections = [self.tbl_playerSelectList numberOfSections];
    int rows = 0;
    for(int i = 0; i < sections; i++) {
        rows += [self.tbl_playerSelectList numberOfRowsInSection:i];
    }
    
    // get out of here if the long press was not on a valid row or our table is empty
    // or the dataSource tableView:canMoveRowAtIndexPath: doesn't allow moving the row
    if (rows == 0 || (gesture.state == UIGestureRecognizerStateBegan && indexPath == nil) ||
        (gesture.state == UIGestureRecognizerStateEnded && self.currentLocationIndexPath == nil) ||
        (gesture.state == UIGestureRecognizerStateBegan &&
         [self.tbl_playerSelectList.dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)] &&
         indexPath && ![self.tbl_playerSelectList.dataSource tableView:self canMoveRowAtIndexPath:indexPath])) {
           // [self.tbl_playerSelectList cancelGesture];
            return;
        }
    
    // started
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        UITableViewCell *cell = [self.tbl_playerSelectList cellForRowAtIndexPath:indexPath];
        //self.tbl_playerSelectList.draggingRowHeight = cell.frame.size.height;
        [cell setSelected:NO animated:NO];
        [cell setHighlighted:NO animated:NO];
        
        
        // make an image from the pressed tableview cell
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // create and image view that we will drag around the screen
        if (!self.draggingView) {
           self. draggingView = [[UIImageView alloc] initWithImage:cellImage];
            [self.tbl_playerSelectList addSubview:self.draggingView];
            CGRect rect = [self.tbl_playerSelectList rectForRowAtIndexPath:indexPath];
           self. draggingView.frame = CGRectOffset(self.draggingView.bounds, rect.origin.x, rect.origin.y);
            
            // add drop shadow to image and lower opacity
            self.draggingView.layer.masksToBounds = NO;
            self.draggingView.layer.shadowColor = [[UIColor blackColor] CGColor];
            self.draggingView.layer.shadowOffset = CGSizeMake(0, 0);
            self.draggingView.layer.shadowRadius = 4.0;
           self. draggingView.layer.shadowOpacity = 0.7;
          // self. draggingView.layer.opacity = self.draggingViewOpacity;
            
            // zoom image towards user
            [UIView beginAnimations:@"zoom" context:nil];
            self.draggingView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.draggingView.center = CGPointMake(self.tbl_playerSelectList.center.x, location.y);
            [UIView commitAnimations];
        }
        
        [self.tbl_playerSelectList beginUpdates];
        [self.tbl_playerSelectList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tbl_playerSelectList insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if ([self.tbl_playerSelectList.delegate respondsToSelector:@selector(saveObjectAndInsertBlankRowAtIndexPath:)]) {
            //self.savedObject = [self.tbl_playerSelectList.delegate saveObjectAndInsertBlankRowAtIndexPath:indexPath];
        }
        else {
            NSLog(@"saveObjectAndInsertBlankRowAtIndexPath: is not implemented");
        }
        
        self.currentLocationIndexPath = indexPath;
        self.initialIndexPath = indexPath;
        [self.tbl_playerSelectList endUpdates];
        
        // enable scrolling for cell
        self.scrollDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableWithCell:)];
        [self.scrollDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    // dragging
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        // update position of the drag view
        // don't let it go past the top or the bottom too far
        if (location.y >= 0 && location.y <= self.tbl_playerSelectList.contentSize.height + 50) {
            self.draggingView.center = CGPointMake(self.tbl_playerSelectList.center.x, location.y);
        }
        
        CGRect rect = self.tbl_playerSelectList.bounds;
        // adjust rect for content inset as we will use it below for calculating scroll zones
        rect.size.height -= self.tbl_playerSelectList.contentInset.top;
        CGPoint location = [gesture locationInView:self];
        
        //[self updateCurrentLocation:gesture];
        
        // tell us if we should scroll and which direction
        CGFloat scrollZoneHeight = rect.size.height / 6;
        CGFloat bottomScrollBeginning = self.tbl_playerSelectList.contentOffset.y + self.tbl_playerSelectList.contentInset.top + rect.size.height - scrollZoneHeight;
        CGFloat topScrollBeginning = self.tbl_playerSelectList.contentOffset.y + self.tbl_playerSelectList.contentInset.top  + scrollZoneHeight;
        // we're in the bottom zone
        if (location.y >= bottomScrollBeginning) {
            self.scrollRate = (location.y - bottomScrollBeginning) / scrollZoneHeight;
        }
        // we're in the top zone
        else if (location.y <= topScrollBeginning) {
            self.scrollRate = (location.y - topScrollBeginning) / scrollZoneHeight;
        }
        else {
            self.scrollRate = 0;
        }
    }
    // dropped
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        NSIndexPath *indexPath = self.currentLocationIndexPath;
        
        // remove scrolling CADisplayLink
        [self.scrollDisplayLink invalidate];
        self.scrollDisplayLink = nil;
        self.scrollRate = 0;
        
        // animate the drag view to the newly hovered cell
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = [self.tbl_playerSelectList rectForRowAtIndexPath:indexPath];
                            self. draggingView.transform = CGAffineTransformIdentity;
                             self.draggingView.frame = CGRectOffset(self.draggingView.bounds, rect.origin.x, rect.origin.y);
                         } completion:^(BOOL finished) {
                             [self.draggingView removeFromSuperview];
                             
                             [self.tbl_playerSelectList beginUpdates];
                             [self.tbl_playerSelectList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             [self.tbl_playerSelectList insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             
                             if ([self.tbl_playerSelectList.delegate respondsToSelector:@selector(finishReorderingWithObject:atIndexPath:)])
                             {
                                // [self.tbl_playerSelectList.delegate finishReorderingWithObject:self.savedObject atIndexPath:indexPath];
                             }
                             else {
                                 NSLog(@"finishReorderingWithObject:atIndexPath: is not implemented");
                             }
                             [self.tbl_playerSelectList endUpdates];
                             
                             // reload the rows that were affected just to be safe
                             NSMutableArray *visibleRows = [[self.tbl_playerSelectList indexPathsForVisibleRows] mutableCopy];
                             [visibleRows removeObject:indexPath];
                             [self.tbl_playerSelectList reloadRowsAtIndexPaths:visibleRows withRowAnimation:UITableViewRowAnimationNone];
                             
                             self.currentLocationIndexPath = nil;
                             self.draggingView = nil;
                         }];
    }
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
