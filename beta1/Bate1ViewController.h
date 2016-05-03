//
//  Bate1ViewController.h
//  beta1
//
//  Created by 袁文轶 on 16/5/3.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
@interface Bate1ViewController : UITabBarController<UITabBarControllerDelegate>

@property (strong,nonatomic) UINavigationController *FirstNC;
@property (strong,nonatomic) FirstViewController *FirstVC;

@property (strong,nonatomic) UINavigationController *SecondNC;
@property (strong,nonatomic) SecondViewController *SecondVC;

@property (strong,nonatomic) UINavigationController *ThirdNC;
@property (strong,nonatomic) SecondViewController *ThirdVC;


@end
