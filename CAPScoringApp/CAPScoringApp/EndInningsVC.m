//
//  EndInningsVC.m
//  CAPScoringApp
//
//  Created by mac on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndInningsVC.h"

@interface EndInningsVC ()

@end

@implementation EndInningsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view from its nib.
    //self.view.frame =CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 100);
    
  //self.view.frame =CGRectMake(200,500, [[UIScreen mainScreen] bounds].size.width/2,500);
    
    [self.view layoutIfNeeded];
    self.scroll_endInnings.contentSize = CGSizeMake(self.view.frame.size.width, 650);

    [self.view_startInnings.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_startInnings.layer.borderWidth = 2;
    
    
    [self.view_endInnings.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_endInnings.layer.borderWidth = 2;
    
    
    [self.view_duration.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_duration.layer.borderWidth = 2;
    
    
    
    [self.view_teamName.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_teamName.layer.borderWidth = 2;
    
    [self.view_runScored.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_runScored.layer.borderWidth = 2;
    
    
    [self.view_OverPlayed.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_OverPlayed.layer.borderWidth = 2;
    
    [self.view_wkts.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_wkts.layer.borderWidth = 2;
    
    [self.view_innings.layer setBorderColor:[UIColor colorWithRed:(82/255.0f) green:(106/255.0f) blue:(124/255.0f) alpha:(1)].CGColor];
    self.view_innings.layer.borderWidth = 2;
    
    [self datePicker];
    [self endDatePicker];
    
   
   
    
    
    
}

-(void)datePicker{
    
    datePicker =[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self.txt_startInnings setInputView:datePicker];
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
style:UIBarButtonItemStylePlain target:self action:@selector(showSelecteddate)];
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:doneBtn,space, nil]];
    
    [self.txt_startInnings setInputAccessoryView:toolbar];


}
-(void)showSelecteddate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    self.txt_startInnings.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txt_startInnings resignFirstResponder];
    
}

-(void)endDatePicker{
    datePicker =[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self.txt_endInnings setInputView:datePicker];
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0,320,44)];
    [toolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(showEndDatePicker)];
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:doneBtn,space, nil]];
    
    [self.txt_endInnings setInputAccessoryView:toolbar];
}
-(void)showEndDatePicker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    self.txt_endInnings.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txt_endInnings resignFirstResponder];
    
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

@end
