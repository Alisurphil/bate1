//
//  LoginViewController.m
//  beta1
//
//  Created by 袁文轶 on 16/5/3.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//侧滑
- (void)popUpHomeTab {
    Bate1ViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Bate"];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];
    naviVC.navigationBarHidden = YES;
    _slidingViewController = [ECSlidingViewController slidingWithTopViewController:naviVC];
    _slidingViewController.delegate = self;
    //_slidingViewController.defaultTransitionDuration = 0.25;
    _slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    [naviVC.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    LeftViewController *leftVC = [Utilities getStoryboardInstanceByIdentity:@"left"];
    _slidingViewController.underLeftViewController = leftVC;
    _slidingViewController.anchorRightPeekAmount = UI_SCREEN_W / 4;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSwitchAction) name:@"leftSwitch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePanGesOnSliding) name:@"enablePanGes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disablePanGesOnSliding) name:@"disablePanGes" object:nil];
    
    [self presentViewController:_slidingViewController animated:YES completion:nil];
}

- (void)leftSwitchAction {
    if (_slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [_slidingViewController resetTopViewAnimated:YES];
    } else {
        [_slidingViewController anchorTopViewToRightAnimated:YES];
    }
}

- (void)enablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = YES;
}

- (void)disablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = NO;
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
