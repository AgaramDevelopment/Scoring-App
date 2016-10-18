//
//  OUTViewController.m
//  CAPScoringApp
//
//  Created by APPLE on 27/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BatsManINOUT.h"
#import "BatsManINOutTime.h"
#import "BatsmaninoutRecord.h"
#import "Reachability.h"
#import "DBManagerBatsmanInOutTime.h"
#import "BatsmanPlayerList.h"
#import "AppDelegate.h"

@interface BatsManINOUT ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate>
{
    NSString *MatchDateWithTime;
    
    
    BOOL back;
    BOOL IsDropDown;
    BOOL isEndDate;
    BOOL startTimeEqual;
    NSDateFormatter *formatter;
    NSMutableArray * BatsManInOutArray;
    NSMutableArray * BatsmanlistArray;
    UITableView *objDrobDowntbl;
    NSString * BtnurrentTittle;
    BatsmaninoutRecord * batsmaninoutRecord;
    DBManagerBatsmanInOutTime * DBManagerBatsmanTime;
    NSString  * Playercode;
    DBManagerBatsmanInOutTime * objDBManagerBatsmanInOutTime;
    NSString * oldPlayercode;
    
}
@end

@implementation BatsManINOUT

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.tbl_BatsManTime setBackgroundColor:[UIColor clearColor]];
    _btn_save.hidden = YES;
    _btn_delete.hidden = YES;
    
    self.btn_delete.backgroundColor=[UIColor colorWithRed:(119/255.0f) green:(57/255.0f) blue:(58/255.0f) alpha:1.0f];
    
    BatsManInOutArray= [[NSMutableArray alloc]init];
    objDBManagerBatsmanInOutTime =[[DBManagerBatsmanInOutTime alloc] init];
    BatsManInOutArray = [objDBManagerBatsmanInOutTime getBatsManBreakTime:_compitionCode :_MATCHCODE :_INNINGSNO :_TEAMCODE];

    
    [_btn_delete setUserInteractionEnabled:NO];
    _tbl_BatsManTime.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.View_playerlist.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.View_playerlist.layer.borderWidth = 2;
    
    [self.View_StartTime.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.View_StartTime.layer.borderWidth = 2;
    
    [self.View_EndTime.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.View_EndTime.layer.borderWidth = 2;
    
    [self.View_Duration.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.View_Duration.layer.borderWidth = 2;

    
    self.view_Allcontrols.hidden = YES;
    self.view_datePicker.hidden=YES;
    self.btn_save.hidden = YES;
    self.btn_delete.hidden = YES;
}


-(void)datePicker{
    
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    self.view_datePicker.hidden=NO;
    
    datePicker =[[UIDatePicker alloc]init];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.txt_startTime setInputView:datePicker];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * currentDate = [dateFormat dateFromString:MatchDateWithTime];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    if([self.MATCHTYPECODE isEqual:@"MSC114"] || [self.MATCHTYPECODE isEqual:@"MSC023"])
//    {
//        [comps setDay:5];
//        [comps setMonth:0];
//        [comps setYear:0];
//    }
//    else if([self.INNINGSNO isEqualToString:@"1"])
//    {
//        [comps setDay:1];
//        [comps setMonth:0];
//        [comps setYear:0];
//        
//    }else{
//        
//        [comps setDay:1];
//        [comps setMonth:0];
//        [comps setYear:0];
//    }
//    
//    
    
    // self.timestamp = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
//    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//    //[comps setYear:-1];
//    [comps setDay:0];
//    [comps setMonth:0];
//    [comps setYear:0];
//    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(self.txt_startTime.frame.origin.x,self.txt_startTime.frame.origin.y+30,self.view.frame.size.width,100)];
    //[datePicker setMaximumDate:maxDate];
    //[datePicker setMinimumDate:minDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [datePicker setLocale:locale];
    
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
   // [datePicker setMinimumDate:minDate];
    //[datePicker setMaximumDate:maxDate];
    //[datePicker setDate:minDate animated:YES];
    [datePicker reloadInputViews];
    [self.view_datePicker addSubview:datePicker];
}


-(void)endDatePicker{
    
    if(datePicker!= nil)
    {
        [datePicker removeFromSuperview];
        
    }
    [self datePicker];
    
}

-(void)showSelecteddate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.txt_startTime.text=[NSString stringWithFormat:@"%@",
                             [formatter stringFromDate:datePicker.date]];
    [self.txt_startTime resignFirstResponder];
    [self duration];
    
}



-(void)showEndDatePicker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *selectedDate = [datePicker date];
    NSString *recordDate = [formatter stringFromDate:selectedDate];
    self.txt_endTime.text=recordDate;
    [self.txt_endTime resignFirstResponder];
    [self duration];
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        isEndDate=NO;
        [self datePicker];
        [textField resignFirstResponder];
    }
    else if (textField.tag == 2)
    {
        isEndDate=YES;
        [self endDatePicker];
        [textField resignFirstResponder];
    }
}


-(void)duration{
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDateTF = self.txt_startTime.text;
    NSString *startEndTF = self.txt_endTime.text;
    
    NSDate *date1 = [formatter dateFromString:startDateTF];
    NSDate *date2 = [formatter dateFromString:startEndTF];
    
    NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
    int days = timeDifference / 60;
    NSString *Duration = [NSString stringWithFormat:@"%d", days];
    
    self.lbl_duration.text=[NSString stringWithFormat:@"%@", Duration];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
     if(tableView== _tbl_BatsManTime)
     {
       return [BatsManInOutArray count];
     }
    else
    {
        return BatsmanlistArray.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    
    if(tableView== objDrobDowntbl)
    {
        static NSString *CellIdentifier = @"row";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        BatsmanPlayerList * objBatsmanPlayer=(BatsmanPlayerList*)[BatsmanlistArray objectAtIndex:indexPath.row];
        cell.textLabel.text = objBatsmanPlayer.playerName;
        return cell;
        
        
        
    }
    else if(tableView == _tbl_BatsManTime){
        static NSString *CellIdentifier = @"row";
        BatsManINOutTime *cell = (BatsManINOutTime *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"BatsManINOutTime" owner:self options:nil];
            cell = self.GridRow;
            //self.GridRow = nil;
        }
        
        BatsmaninoutRecord * batmaninout=(BatsmaninoutRecord*)[BatsManInOutArray objectAtIndex:indexPath.row];
        
        
        cell.lbl_StartTime.text = [batmaninout.startTime  isEqual: @""] ? @"0" : batmaninout.startTime ;
        cell.lbl_EndTime.text = [batmaninout.EndTime isEqual: @""] ? @"0" : batmaninout.EndTime;
        cell.lbl_PlayerName.text = batmaninout.playerName;
        
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startDateTF = batmaninout.startTime;
        NSString *startEndTF = batmaninout.EndTime;
        
        NSDate *date1 = [formatter dateFromString:startDateTF];
        NSDate *date2 = [formatter dateFromString:startEndTF];
        
        NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
        int days = timeDifference / 60;
        NSString * Duration = [NSString stringWithFormat:@"%d", days];
        cell.lbl_Duration.text = Duration;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    back = NO;
    self.view_addBtn.hidden = YES;
   //BatsmaninoutRecord *obj =(BatsmaninoutRecord *)[BatsManInOutArray objectAtIndex:indexPath.row];
    
    //_scroll_EndSession.scrollEnabled = YES;
    
   // formatter = [[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   // NSString *startDateTF = obj.startTime;
   // NSString *startEndTF = obj.EndTime;
    
   // NSDate *date1 = [formatter dateFromString:startDateTF];
   // NSDate *date2 = [formatter dateFromString:startEndTF];
    
    //NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
    //int days = timeDifference / 60;
   // NSString *Duration = [NSString stringWithFormat:@"%d", days];
    
    if(tableView== objDrobDowntbl)
    {
         BatsmanPlayerList *obj =(BatsmanPlayerList *)[BatsmanlistArray objectAtIndex:indexPath.row];
        if (IsDropDown == YES) {
            
           
            self.lbl_playerName.text = obj.playerName;
            Playercode  =obj.playerCode;
            IsDropDown = NO;
            
        }
        objDrobDowntbl.hidden=YES;
    }
    else
    {
        BatsmaninoutRecord *obj =(BatsmaninoutRecord *)[BatsManInOutArray objectAtIndex:indexPath.row];
        oldPlayercode =obj.playercode;
        
        
        
         formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSString *startDateTF = obj.startTime;
         NSString *startEndTF = obj.EndTime;
        
         NSDate *date1 = [formatter dateFromString:startDateTF];
         NSDate *date2 = [formatter dateFromString:startEndTF];
        
        NSTimeInterval timeDifference = [date2 timeIntervalSinceDate:date1];
        int days = timeDifference / 60;
         NSString * Duration = [NSString stringWithFormat:@"%d", days];

        
        
    
        
       BtnurrentTittle = [NSString stringWithFormat:self.btn_save.currentTitle];
        BtnurrentTittle = @"UPDATE";
        [self.btn_save setTitle: @"UPDATE" forState: UIControlStateNormal];
        
        
        self.txt_startTime.text = obj.startTime;
        self.txt_endTime.text = obj.EndTime;
        self.lbl_playerName.text = obj.playerName;
        
        
       
        //_lbl_sessionEndOver.text = endOverNO = @"" ? @"0" : endOverNO;
        
       
       
        _lbl_duration.text = Duration;
        self.view_heading.hidden = YES;
        self.tbl_BatsManTime.hidden = YES;
        self.view_Allcontrols.hidden = NO;
        
        _btn_save.hidden = NO;
        _btn_delete.hidden = NO;
        
        self.btn_delete.backgroundColor=[UIColor colorWithRed:(255/255.0f) green:(86/255.0f) blue:(88/255.0f) alpha:1.0f];
        [_btn_delete setUserInteractionEnabled:YES];
        
    }
    
}
//Check internet connection
- (BOOL)checkInternetConnection
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)btn_addEndSession:(id)sender {
    
    BtnurrentTittle = [NSString stringWithFormat:self.btn_save.currentTitle];
    BtnurrentTittle = @"INSERT";
    
    [self.btn_save setTitle: @"SAVE" forState: UIControlStateNormal];
    
    self.view_addBtn.hidden = YES;
    self.lbl_playerName.text =@"";
    self.lbl_duration.text = @"";
    self.txt_startTime.text = @"";
    self.txt_endTime.text = @"";
    //self.lbl_sessionDominant.text = @"";
    
    self.view_heading.hidden = YES;
    self.view_Allcontrols.hidden = NO;
    self.tbl_BatsManTime.hidden = YES;
    _btn_save.hidden = NO;
    _btn_delete.hidden = NO;
    back=NO;
    
    self.btn_delete.backgroundColor=[UIColor colorWithRed:(119/255.0f) green:(57/255.0f) blue:(58/255.0f) alpha:1.0f];
    [_btn_delete setUserInteractionEnabled:NO];
    
}

-(BOOL) checkValidation{
    
    
    if([self.lbl_playerName.text isEqualToString:@""]){
        [self showDialog:@"Please Choose Player Name" andTitle:@"BatMan IN/OUT TIME"];
        return NO;
    }
    else if([self.txt_startTime.text isEqualToString:@""]){
        [self showDialog:@"Please Choose Start Time" andTitle:@"BatMan IN/OUT TIME"];
        return NO;
    }
    
    else if([self.txt_endTime.text isEqualToString:@""]){
        [self showDialog:@"Please Choose End Time" andTitle:@"BatMan IN/OUT TIME"];
        return NO;
    }
    
   else if([self.lbl_duration.text isEqualToString:@""] && [self.lbl_duration.text integerValue]<=0){
        [self showDialog:@"Duration should be greated than zero" andTitle:@"BatMan IN/OUT TIME"];
        return NO;
    }
    
    
    
    return YES;
}


/**
 * Show message for given title and content
 */
-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alertDialog show];
}

-(void)ValidationStartAndEndTime
{
    startTimeEqual=(BatsManInOutArray.count!=0) ? YES:NO;
    for(int i=0; i<BatsManInOutArray.count; i++)
    {
        BatsmaninoutRecord *obj =(BatsmaninoutRecord*)[BatsManInOutArray objectAtIndex:i];
        if([self.txt_startTime.text isEqualToString:obj.startTime] && [self.txt_endTime.text isEqualToString: obj.EndTime])
        {
            NSLog(@"same");
            startTimeEqual=YES;
        }
        else
        {
            NSLog(@"notsame");
            startTimeEqual=NO;
        }
        
    }
    
}
- (IBAction)btn_save:(id)sender {
    
    if ([self checkValidation]) {
        
        if ([BtnurrentTittle isEqualToString:@"INSERT"])
        {
            
           [objDBManagerBatsmanInOutTime INSERTPLAYERINOUTTIME:_compitionCode :_INNINGSNO :_MATCHCODE :_TEAMCODE :Playercode : self.txt_startTime.text :self.txt_endTime.text];
                

            
            
            //int SESSIONNO =[sessionRecords.SESSIONNO intValue];
           // int STARTOVERNO  = [sessionRecords.STARTOVERNO intValue];
            // float ENDOVERNO   =[sessionRecords.ENDOVERBALLNO floatValue];
            //int  RUNSSCORED =[sessionRecords.RUNSSCORED intValue];
            
           // [self ValidationStartAndEndTime];
            //     if(startTimeEqual== NO)
            //    {
            
           // [sessionRecords InsertEndSession:competitioncode : matchcode :fetchSeRecord.BATTINGTEAMCODE :fetchSeRecord.INNINGSNO :fetchSeRecord.DAYNO : SESSIONNO :_txt_startTime.text :_txt_endTime.text :[NSString stringWithFormat:@"%d",STARTOVERNO]: [NSString stringWithFormat:@"%@",ENDOVERBALLNO] :[NSString stringWithFormat:@"%d" ,RUNSSCORED] :[NSString stringWithFormat:@"%d",fetchSeRecord.BATTEAMWICKETS] :Dominate];
            
            
            if(self.checkInternetConnection){
                
                
                
              //  AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                
                //Show indicator
              //  [delegate showLoading];
                //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                
                //dispatch_get_main_queue(), ^
                {
                    
                  //  NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDSESSION/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],competitioncode, matchcode,fetchSeRecord.BATTINGTEAMCODE,fetchSeRecord.INNINGSNO,sessionRecords.DAYNO,[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO],_txt_startTime.text,_txt_endTime.text ,[NSString stringWithFormat:@"%@",sessionRecords.STARTOVERNO], [NSString stringWithFormat:@"%@",sessionRecords.ENDOVERNO],[NSString stringWithFormat:@"%@" ,sessionRecords.RUNSSCORED],sessionRecords.WICKETLOST,@"(null)",BtnurrentTittle];
                    
                    
                    //NSLog(@"%@",baseURL);
                    
//                    NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                    
//                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                    NSURLResponse *response;
//                    NSError *error;
//                    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//                    
//                    
//                    NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//                    
//                    if(rootArray !=nil && rootArray.count>0){
//                        NSDictionary *valueDict = [rootArray objectAtIndex:0];
//                        NSString *success = [valueDict valueForKey:@"DataItem"];
//                        if([success isEqual:@"Success"]){
//                            
//                        }
//                    }else{
//                        
//                    }
                    
                    //[delegate hideLoading];
                }
                
            }
            
        }
        else{
            
            [objDBManagerBatsmanInOutTime UPDATEPLAYERINOUT:_compitionCode :_MATCHCODE :_TEAMCODE :_INNINGSNO :Playercode :self.txt_startTime.text : self.txt_endTime.text:oldPlayercode];
//            BatsManInOutArray=[[NSMutableArray alloc]init];
//            
//            BatsManInOutArray = [objDBManagerBatsmanInOutTime getBatsManBreakTime:_compitionCode :_MATCHCODE :_INNINGSNO :_TEAMCODE];
            
            if(self.checkInternetConnection){
                
                
                
//                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//                
//                //Show indicator
//                [delegate showLoading];
                //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                
                //dispatch_get_main_queue(), ^
//                {
//                    
//                    
//                    NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDSESSION/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],competitioncode, matchcode,fetchSeRecord.BATTINGTEAMCODE,fetchSeRecord.INNINGSNO,sessionRecords.DAYNO,[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO],_txt_startTime.text,_txt_endTime.text ,[NSString stringWithFormat:@"%@",sessionRecords.STARTOVERNO], [NSString stringWithFormat:@"%@",sessionRecords.ENDOVERNO],[NSString stringWithFormat:@"%@" ,sessionRecords.RUNSSCORED],sessionRecords.WICKETLOST,@"(null)",BtnurrentTittle];
//                    
//                    
                 //   NSLog(@"%@",baseURL);
                    
//                    NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                    
//                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                    NSURLResponse *response;
//                    NSError *error;
//                    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//                    
//                    
//                    NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//                    
//                    if(rootArray !=nil && rootArray.count>0){
//                        NSDictionary *valueDict = [rootArray objectAtIndex:0];
//                        NSString *success = [valueDict valueForKey:@"DataItem"];
//                        if([success isEqual:@"Success"]){
//                            
//                        }
//                    }else{
//                        
//                    }
//                    
//                    [delegate hideLoading];
//                }
//                
//                
           }
//
       }
//        
//       [self fetchPageEndSession : fetchSeRecord: competitioncode : matchcode];
        
        BatsManInOutArray=[[NSMutableArray alloc]init];
        
        BatsManInOutArray = [objDBManagerBatsmanInOutTime getBatsManBreakTime:_compitionCode :_MATCHCODE :_INNINGSNO :_TEAMCODE];
        
          [self.tbl_BatsManTime reloadData];
          self.tbl_BatsManTime.hidden = NO;
          self.view_Allcontrols.hidden = YES;
          self.view_heading.hidden = NO;
          self.view_addBtn.hidden = NO;
            self.btn_save.hidden=YES;
            self.btn_delete.hidden=YES;
        
        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"BatMan IN/OUT TIME" message:@"BatMan IN/OUT TIME Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }
//}

//    else{
//        UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"End Session" message:@"The Session is already exists in the date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alter show];
//
   }


- (IBAction)btn_delete:(id)sender {
    
    
    
    [objDBManagerBatsmanInOutTime DELETEPLAYERINOUTTIME:_compitionCode :_MATCHCODE :_TEAMCODE :_INNINGSNO :oldPlayercode];
    
    
//    if(self.checkInternetConnection){
//        
//        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        
//        //Show indicator
//        [delegate showLoading];
//        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
//        
//        //dispatch_get_main_queue(), ^
//        {
//            
//            NSString *baseURL = [NSString stringWithFormat:@"http://%@/CAPMobilityService.svc/SETENDSESSION/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[Utitliy getIPPORT],competitioncode,matchcode,@"NULL",fetchSeRecord.INNINGSNO,sessionRecords.DAYNO,[NSString stringWithFormat:@"%@",sessionRecords.SESSIONNO],@"NULL",@"NULL",@"NULL",@"NULL",@"NULL",@"NULL",@"NULL"@"DELETE"];
//            
//            
//            NSLog(@"%@",baseURL);
//            NSURL *url = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            NSURLResponse *response;
//            NSError *error;
//            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            
//            
//            NSMutableArray *rootArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//            
//            if(rootArray !=nil && rootArray.count>0){
//                NSDictionary *valueDict = [rootArray objectAtIndex:0];
//                NSString *success = [valueDict valueForKey:@"DataItem"];
//                if([success isEqual:@"Success"]){
//                    
//                }
//            }else{
//                
//            }
//            
//            [delegate hideLoading];
//        }
//        
//        
//    }
    
    
    //[self fetchPageEndSession : fetchSeRecord: competitioncode : matchcode];
    
    
    BatsManInOutArray=[[NSMutableArray alloc]init];
    
    BatsManInOutArray = [objDBManagerBatsmanInOutTime getBatsManBreakTime:_compitionCode :_MATCHCODE :_INNINGSNO :_TEAMCODE];

    
    [self.tbl_BatsManTime reloadData];
    
    // [endSessionArray removeLastObject];
    
    self.tbl_BatsManTime.hidden = NO;
    self.view_heading.hidden = NO;
    self.view_Allcontrols.hidden = YES;
    self.btn_delete.hidden = YES;
    self.btn_save.hidden = YES;
    self.view_addBtn.hidden = NO;
    UIAlertView * alter =[[UIAlertView alloc]initWithTitle:@"BatMan IN/OUT TIME" message:@"BatMan IN/OUT TIME Deleted Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alter show];


}

- (IBAction)btn_dropDown:(id)sender {
    
    [self.view layoutIfNeeded];
    if(IsDropDown ==NO)
    {
        IsDropDown = YES;
        
        objDrobDowntbl=[[UITableView alloc]initWithFrame:CGRectMake(self.View_playerlist.frame.origin.x, self.View_StartTime.frame.origin.y+95, 280, 300)];
        objDrobDowntbl.dataSource=self;
        objDrobDowntbl.delegate=self;
        objDrobDowntbl.hidden=NO;
//
        [self.view addSubview:objDrobDowntbl];
//        self.scroll_EndSession.scrollEnabled = NO;
//
        BatsmanlistArray=[[NSMutableArray alloc]init];
        
        NSMutableArray *teamArray = [objDBManagerBatsmanInOutTime getBATTINGPLAYERSTATISTICS: self.compitionCode : self.MATCHCODE :self.INNINGSNO :self.TEAMCODE];;
        
        BatsmanlistArray = teamArray;
        
        
        [objDrobDowntbl reloadData];
    }
    else{
        IsDropDown = NO;
        objDrobDowntbl.hidden=YES;
       
    }
    
    
}

- (IBAction)btn_back:(id)sender {
    
    if (back == NO) {
        
        self.view_Allcontrols.hidden = YES;
        self.tbl_BatsManTime.hidden = NO;
        self.view_heading.hidden = NO;
        self.view_datePicker.hidden = YES;
        _btn_save.hidden = YES;
        _btn_delete.hidden = YES;
        self.view_addBtn.hidden = NO;
        objDrobDowntbl.hidden=YES;
        back = YES;
        [self.tbl_BatsManTime reloadData];
    }else if (back == YES){
        
        
        //        DashBoardVC * dashVC = [[DashBoardVC alloc]init];
        //
        //        dashVC =  (DashBoardVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"dashboard_sbid"];
        
        
        [self.delegate ChangeVCBackBtnAction];
        
        
        back = NO;
    }
    
    
}
- (IBAction)show_SelectedDate:(id)sender {
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //   2016-06-25 12:00:00
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *matchdate = [dateFormat dateFromString:MatchDateWithTime];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // for minimum date
    [datePicker setMinimumDate:matchdate];
    
    // for maximumDate
    int daysToAdd = 1;
    NSDate *newDate1 = [matchdate dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    [datePicker setMaximumDate:newDate1];
    
    
    NSString *minimumdateStr = [dateFormat stringFromDate:matchdate];
    NSString*maxmimumdateStr=[dateFormat stringFromDate:newDate1];
    if(isEndDate==YES)
    {
        _txt_endTime.text=[dateFormat stringFromDate:datePicker.date];
    }
    else
    {
        _txt_startTime.text=[dateFormat stringFromDate:datePicker.date];
    }
    NSLog(@"check: %@",_txt_startTime.text);
    
    //BREAKSTARTTIME =[NSString stringWithFormat:@"%@",[_txt_startInnings text]];
    
    [self duration];
    [self.view_datePicker setHidden:YES];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
