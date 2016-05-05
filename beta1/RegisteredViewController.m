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
@property (nonatomic, strong) NSString *status;
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
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)signUpAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *username = _inPutName.text;
    NSString *email = _inPutID.text;
    NSString *password = _inPutPwd.text;
    NSString *confirmPwd = _pwdAgain.text;
    NSString *nickname = _inPutNikname.text;
    
    if ([username isEqualToString:@""] || [email isEqualToString:@""] || [password isEqualToString:@""] || [confirmPwd isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    if (![password isEqualToString:confirmPwd]) {
        [Utilities popUpAlertViewWithMsg:@"确认密码必须与密码保持一致" andTitle:nil];
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    user[@"nickName"] = nickname;
    
    TAOverlayOptions options = TAOverlayOptionNone;
    _status = nil;
    _status = @"加载中";
    
    [TAOverlay showOverlayWithLabel:_status Options:(options | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeActivityBlur)];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_inPutName.text password:_inPutPwd.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
                //                NSLog(@"进来了");
                [TAOverlay hideOverlay];
                if (!error) {
                    NSLog(@"环信注册成功");
                    [Utilities setUserDefaults:@"userName" content:username];
                    [Utilities setUserDefaults:@"password" content:password];
                    [[storageMgr singletonStorageMgr] addKeyAndValue:@"signUp" And:@1];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [Utilities popUpAlertViewWithMsg:@"该用户名已被使用，请尝试其它名称" andTitle:nil];
                }
            } onQueue:nil];
        } else{
            [TAOverlay hideOverlay];
            if (error.code == 202) {
                [Utilities popUpAlertViewWithMsg:@"该用户名已被使用，请尝试其它名称" andTitle:nil];
            } else if (error.code == 203) {
                [Utilities popUpAlertViewWithMsg:@"该电子邮箱已被使用，请尝试其它名称" andTitle:nil];
            } else if (error.code == 125) {
                [Utilities popUpAlertViewWithMsg:@"该电子邮箱地址为非法地址格式" andTitle:nil];
            } else if (error.code == 100) {
                [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
            } else {
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            }
            
        }
    }];

}

- (IBAction)cancelAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
