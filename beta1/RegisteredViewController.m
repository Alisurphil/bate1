//
//  RegisteredViewController.m
//  beta1
//
//  Created by 袁文轶 on 16/5/3.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import "RegisteredViewController.h"

@interface RegisteredViewController ()
- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cancelAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITextField *inPutName;
@property (weak, nonatomic) IBOutlet UITextField *inPutID;
@property (weak, nonatomic) IBOutlet UITextField *inPutNikname;
@property (weak, nonatomic) IBOutlet UITextField *inPutPwd;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgain;


@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)cancelAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
