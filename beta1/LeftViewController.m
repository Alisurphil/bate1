//
//  LeftViewController.m
//  beta1
//
//  Created by 袁文轶 on 16/5/3.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imview;
- (IBAction)exitID:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)userImage:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *userImage2;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
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

- (IBAction)exitID:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)userImage:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
