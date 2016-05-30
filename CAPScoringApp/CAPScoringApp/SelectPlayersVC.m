//
//  SelectPlayersVC.m
//  CAPScoringApp
//
//  Created by Sathish on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "SelectPlayersVC.h"
#import "SelectPlayerRecord.h"
#import "SelectPlayerCVCell.h"


#import "DBManager.h"

@interface SelectPlayersVC ()

@property (nonatomic,strong) NSMutableArray *selectedPlayerArray;
@property (nonatomic,strong) NSMutableArray *selectedPlayerFilterArray;

@end

@implementation SelectPlayersVC


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    NSMutableArray *playersCode = [[NSMutableArray alloc]init];
    
    [playersCode addObject:@"PYC0000001"];
    [playersCode addObject:@"PYC0000002"];
    [playersCode addObject:@"PYC0000003"];
    [playersCode addObject:@"PYC0000004"];
    [playersCode addObject:@"PYC0000005"];
    [playersCode addObject:@"PYC0000006"];
    
    [playersCode addObject:@"PYC0000050"];
    [playersCode addObject:@"PYC0000051"];
    [playersCode addObject:@"PYC0000052"];
    [playersCode addObject:@"PYC0000053"];
    
    [playersCode addObject:@"PYC0000065"];
    [playersCode addObject:@"PYC0000066"];
    [playersCode addObject:@"PYC0000067"];
    [playersCode addObject:@"PYC0000068"];
    [playersCode addObject:@"PYC0000069"];
    [playersCode addObject:@"PYC0000070"];
    
    
    for(int i=0;i<[playersCode count];i++){
        [self addImageInAppDocumentLocation:[playersCode objectAtIndex:i]];
    }
    
   // self.teamCode = @"TEA0000001";
    //self.matchCode= @"IMSC0221C6F6595E95A00002";
    self.selectedPlayerArray = [DBManager getSelectingPlayerArray:self.teamCode matchCode:self.matchCode];
    self.selectedPlayerFilterArray = [[NSMutableArray alloc]initWithArray: self.selectedPlayerArray ];
    
    [self setSelectCount];
    
    //self.selectedPlayerPosition = [[NSMutableArray alloc]init];
    
    //    for(int i=0; i<[self.selectedPlayerFilterArray count];i++){
    //        NSNumber selected
    //        [self.selectedPlayerPosition addObject:YES];
    //    }
    
    
}

-(void) addImageInAppDocumentLocation:(NSString*) fileName{
    
    BOOL success = [self checkFileExist:fileName];
    
    if(!success) {//If file not exist
        
        UIImage  *newImage = [UIImage imageNamed:fileName];
        NSData *imageData = UIImagePNGRepresentation(newImage);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
        
        if (![imageData writeToFile:imagePath atomically:NO])
        {
            NSLog((@"Failed to cache image data to disk"));
        }else
        {
            NSLog(@"the cachedImagedPath is %@",imagePath);
        }
    }
}

//Check given file name exist in document directory
- (BOOL) checkFileExist:(NSString*) fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
    return [fileManager fileExistsAtPath:filePath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.selectedPlayerFilterArray count];
}

//-(NSString *)writeDataAsFile:(NSData *)imageData
//{
//
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * documentsDirectory = [paths objectAtIndex:0];
//    NSString * thumbNailFilename = [NSString stringWithFormat:@"%@.png",[self GetUUID]]; // Create unique iD
//    NSString * thumbNailAppFile = [documentsDirectory stringByAppendingPathComponent:thumbNailFilename];
//
//    if ([imageData writeToFile:thumbNailAppFile atomically:YES])
//    {
//        return thumbNailFilename;
//    }
//
//    return nil;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //  UIImage *thumbnailHomeImage = [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"%@",imageName]];
    
    SelectPlayerCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SelectPlayerRecord *selectedPlayer = [self.selectedPlayerFilterArray objectAtIndex:indexPath.row];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir,selectedPlayer.playerCode];
    BOOL isFileExist = [fileManager fileExistsAtPath:pngFilePath];
    UIImage *img;
    if(isFileExist){
        img = [UIImage imageWithContentsOfFile:pngFilePath];
    }else{
        img  = [UIImage imageNamed: @"no_image.png"];
    }
    
    
    
    cell.img_player.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.img_player.layer.cornerRadius=70;
    cell.img_player.layer.borderWidth=2.0;
    cell.img_player.layer.masksToBounds = YES;
    cell.img_player.image = img;
    
    
    //Set data
    cell.lbl_player_code.text =  selectedPlayer.playerCode;
    cell.lbl_player_name.text = selectedPlayer.playerName;
    
    //Swap image
    if([[selectedPlayer isSelected] boolValue]){
        UIImage *image = [UIImage imageNamed: @"ico-added.png"];
        [cell.img_selector setImage:image];
    }else{
        UIImage *image = [UIImage imageNamed: @"ico-deleted.png"];
        [cell.img_selector setImage:image];
    }
    
    return cell;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectPlayerRecord *selectedPlayerFilterRecord = [self.selectedPlayerFilterArray objectAtIndex:indexPath.row];
    
    
    
    for(int i=0;i<[self.selectedPlayerArray count];i++){
        SelectPlayerRecord *selectedPlayerMainRecord = [self.selectedPlayerArray objectAtIndex:i];
        if([[selectedPlayerMainRecord playerCode] isEqualToString:[selectedPlayerFilterRecord playerCode]]){
            //Swap value
            if([[selectedPlayerFilterRecord isSelected] boolValue]){
                selectedPlayerMainRecord.isSelected = [NSNumber numberWithInteger:0];
                selectedPlayerFilterRecord.isSelected = [NSNumber numberWithInteger:0];
            }else{
                selectedPlayerMainRecord.isSelected = [NSNumber numberWithInteger:1];
                selectedPlayerFilterRecord.isSelected = [NSNumber numberWithInteger:1];
            }
            break;
        }
    }
    
    //Relaod view
    [self.collectionView reloadData];
    
    [self setSelectCount];
    
    return YES;
}

//Display selected players count
-(void) setSelectCount{
    
    int selectCount = 0;
    
    //Set selected count
    for(int i=0;i<[self.selectedPlayerArray count];i++){
        SelectPlayerRecord *selectedPlayerFilterRecord = [self.selectedPlayerArray objectAtIndex:i];
        if([[selectedPlayerFilterRecord isSelected] boolValue]){
            selectCount++;
        }
    }
    self.lbl_select_count.text = [NSString stringWithFormat: @" %d / 15 SELECTED",selectCount];
    
}

- (IBAction)btn_cancel:(id)sender {
}

- (IBAction)btn_select:(id)sender {
    
    if([self selectionValidation]){
        
        for(int i=0;i<[self.selectedPlayerArray count];i++){
            SelectPlayerRecord *selectedPlayerFilterRecord = [self.selectedPlayerArray objectAtIndex:i];
            NSString *recordStatus = [[selectedPlayerFilterRecord isSelected]boolValue]? @"MSC001":@"MSC002";
            [DBManager updateSelectedPlayersResultCode:[selectedPlayerFilterRecord playerCode] matchCode:[self matchCode] recordStatus:recordStatus];
        }}else{
            [self showDialog:@"Please select minimum seven players" andTitle:@""];
        }
    
    
}
- (IBAction)btn_search:(id)sender {
    
    if([[self.txt_search text] isEqual:@""]){
        [self.selectedPlayerFilterArray removeAllObjects];
        self.selectedPlayerFilterArray = [[NSMutableArray alloc]initWithArray: self.selectedPlayerArray ];
        
        
    }else{
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"playerName contains[c] %@",self.txt_search.text];
        
        NSArray *filtedPlayerArray =  [self.selectedPlayerArray filteredArrayUsingPredicate:resultPredicate];
        
        // NSLog(@"count %lu",(unsigned long)[self.selectedPlayerArray count]);
        
        [self.selectedPlayerFilterArray removeAllObjects];
        
        //    NSLog(@"count2 %lu",(unsigned long)[self.selectedPlayerArray count]);
        
        self.selectedPlayerFilterArray = [[NSMutableArray alloc] initWithArray:filtedPlayerArray];
        
        
    }
    //Relaod view
    [self.collectionView reloadData];
}

/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    
    [alertDialog show];
}


/**
 * Selecting players Validation
 */
- (BOOL) selectionValidation{
    int selectCount = 0;
    
    //Set selected count
    for(int i=0;i<[self.selectedPlayerArray count];i++){
        SelectPlayerRecord *selectedPlayerFilterRecord = [self.selectedPlayerArray objectAtIndex:i];
        if([[selectedPlayerFilterRecord isSelected] boolValue]){
            selectCount++;
        }
    }
    return selectCount>=7?YES:NO;
}
@end
