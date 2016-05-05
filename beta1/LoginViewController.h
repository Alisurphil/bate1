//
//  LoginViewController.h
//  beta1
//
//  Created by 袁文轶 on 16/5/3.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Bate1ViewController.h"
#import "LeftViewController.h"
@interface LoginViewController : UIViewController<UIViewControllerAnimatedTransitioning, ECSlidingViewControllerDelegate, ECSlidingViewControllerLayout>
@property (weak, nonatomic) IBOutlet UIButton *avatarImg;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (strong, nonatomic) ECSlidingViewController *slidingViewController;
@property (assign, nonatomic) ECSlidingViewControllerOperation operation;

@end