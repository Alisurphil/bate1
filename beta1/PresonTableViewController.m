//
//  PresonTableViewController.m
//  beta1
//
//  Created by 袁文轶 on 16/5/5.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import "PresonTableViewController.h"
#import "ThirdViewController.h"
@interface PresonTableViewController ()
- (IBAction)backToMe:(UIBarButtonItem *)sender;
- (IBAction)finishChange:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *changeNikName;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UITextField *changeFavourite;
@property (weak, nonatomic) IBOutlet UITextField *changeLocation;
@property (weak, nonatomic) IBOutlet UITableViewCell *birthday;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) NSDate *selected;
@property (strong, nonatomic) UIPickerView *sexPickerView;
@property (strong, nonatomic) NSArray *sexArr;

@end

@implementation PresonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _coverView = nil;
    _coverView = [[UIView alloc] initWithFrame:self.tableView.frame];
    _coverView.hidden = YES;
    _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_coverView addSubview:self.datePicker];
    //[self.datePicker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _datePicker.frame.origin.y - 46, self.view.frame.size.width, 46)];
    self.toolBar.barStyle = UIBarStyleDefault;
    self.toolBar.translucent = YES;
    UIBarButtonItem *flixSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flixSpace.width = 15;
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtn:)];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtn:)];
    UIBarButtonItem *flexSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolBar setItems:@[flixSpace, cancelBtn, flexSpace, doneBtn, flixSpace] animated:YES];
    [_coverView addSubview:self.toolBar];
    self.sexPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
    self.sexPickerView.dataSource = self;
    self.sexPickerView.delegate = self;
    _sexPickerView.backgroundColor = [UIColor whiteColor];
    _sexArr = [NSArray arrayWithObjects:@"男",@"女",nil];
    [_coverView addSubview:self.sexPickerView];
    UITapGestureRecognizer *tapTrick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
    [_coverView addGestureRecognizer:tapTrick];
    
    [_sexPickerView selectRow:2 inComponent:0 animated:NO];
    [_sexPickerView reloadComponent:0];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _sexArr.count;
    } else {
        return 1;
    }
}


// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_sexArr objectAtIndex:row];
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat screenWidth = self.view.frame.size.width;
    if (component == 0) {
        return screenWidth / 4;
    } else {
        return screenWidth / 6;
    }
}

- (void)bgTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        _coverView.hidden = YES;
        self.tableView.userInteractionEnabled = YES;
    }
}


- (IBAction)backToMe:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2 ) {
        [self.view endEditing:YES];
        _coverView.hidden = NO;
        _datePicker.hidden = NO;
        _sexPickerView.hidden = YES;
        self.tableView.userInteractionEnabled = NO;
    }
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        _coverView.hidden = NO;
        _sexPickerView.hidden = NO;
        _datePicker.hidden = YES;
        self.tableView.userInteractionEnabled = NO;
    }
}

- (void)cancelBtn:(id)sender {
    _coverView.hidden = YES;
    self.tableView.userInteractionEnabled = YES;
}

- (void)doneBtn:(id)sender {
    
    if (self.sexPickerView.hidden == YES) {
        _selected = [_datePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _dateLabel.text = [dateFormatter stringFromDate:_selected];
    }
    if (self.datePicker.hidden == YES) {
        NSInteger row = [_sexPickerView selectedRowInComponent:0];
        _sexLabel.text = [_sexArr objectAtIndex:row];
    }
    _coverView.hidden = YES;
    self.tableView.userInteractionEnabled = YES;
    
    
    
    
}
//昵称：nickName性别：gender年龄：age地址：address种族：race

- (IBAction)finishChange:(UIBarButtonItem *)sender {
    PFUser *user = [PFUser currentUser];
    if (_changeNikName.text.length > 0) {
        user[@"nickName"] = _changeNikName.text;
    }
    if ([_sexLabel.text isEqual: @"男"]) {
        user[@"gender"] = @"nan";
    }else if([_sexLabel.text isEqual: @"女"]){
        user[@"gender"] = @"nv";
    }
    if (_changeLocation.text.length > 0) {
        user[@"address"] = _changeLocation.text;
    }
    if (_changeFavourite.text.length > 0) {
        user[@"race"] = _changeFavourite.text;
    }
    if (_dateLabel.text.length > 0) {
        user[@"birthDate"] = _selected;
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"OK");
        } else {
            NSLog(@"error = %@", error.description);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
