//
//  LoginViewController.m
//  beta1
//
//  Created by 袁文轶 on 16/5/3.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import "LoginViewController.h"
#import <EaseMobSDKFull/EaseMob.h>
#import "RegisteredViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
- (IBAction)signIn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (nonatomic, strong) NSString *status;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _avatarImg.layer.borderColor = [[UIColor colorWithRed:123.f/255.f green:236.f/255.f blue:255.f/255.f alpha:1.f] CGColor];
    
    if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
        _usernameTF.text = [Utilities getUserDefaults:@"userName"];
        NSString *currentStr = _usernameTF.text;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [directories objectAtIndex:0];
        __block NSString *filePath = nil;
        filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", currentStr]];
        if ([fileManager fileExistsAtPath:filePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [_avatarImg setBackgroundImage:image forState:UIControlStateNormal];
        } else {
            [_avatarImg setImage:[UIImage imageNamed:@"default"] forState:UIControlStateNormal];
        }
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[[storageMgr singletonStorageMgr] objectForKey:@"signUp"] integerValue] == 1) {
        [[storageMgr singletonStorageMgr] removeObjectForKey:@"signUp"];
        
        [self loginWithUsername:[Utilities getUserDefaults:@"userName"] andPassword:[Utilities getUserDefaults:@"password"]];
    }
    self.passwordTF.userInteractionEnabled = YES;
    self.usernameTF.userInteractionEnabled = YES;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popUpHomeTab {
    Bate1ViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Bate"];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];
    naviVC.navigationBarHidden = YES;
    _slidingViewController = [ECSlidingViewController slidingWithTopViewController:naviVC];
    _slidingViewController.delegate = self;
    //_slidingViewController.defaultTransitionDuration = 0.25;
    _slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    [naviVC.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    LeftViewController *leftVC = [Utilities getStoryboardInstanceByIdentity:@"Left"];
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

#pragma mark - ECSlidingViewControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)slidingViewController:(ECSlidingViewController *)slidingViewController animationControllerForOperation:(ECSlidingViewControllerOperation)operation topViewController:(UIViewController *)topViewController {
    _operation = operation;
    return self;
}

- (id<ECSlidingViewControllerLayout>)slidingViewController:(ECSlidingViewController *)slidingViewController layoutControllerForTopViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {
    return self;
}

#pragma mark - ECSlidingViewControllerLayout

- (CGRect)slidingViewController:(ECSlidingViewController *)slidingViewController frameForViewController:(UIViewController *)viewController topViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {
    if (topViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight && viewController == slidingViewController.topViewController) {
        return [self topViewAnchoredRightFrame:slidingViewController];
    } else {
        return CGRectInfinite;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    UIViewController *underLeftViewController  = [transitionContext viewControllerForKey:ECTransitionContextUnderLeftControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *topView = topViewController.view;
    topView.frame = containerView.bounds;
    underLeftViewController.view.layer.transform = CATransform3DIdentity;
    
    if (_operation == ECSlidingViewControllerOperationAnchorRight) {
        [containerView insertSubview:underLeftViewController.view belowSubview:topView];
        
        [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewEndState:underLeftViewController.view];
            [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext finalFrameForViewController:topViewController]];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                underLeftViewController.view.frame = [transitionContext finalFrameForViewController:underLeftViewController];
                underLeftViewController.view.alpha = 1;
                [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
            }
            [transitionContext completeTransition:finished];
        }];
    } else if (_operation == ECSlidingViewControllerOperationResetFromRight) {
        [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
        [self underLeftViewEndState:underLeftViewController.view];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
            [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [self underLeftViewEndState:underLeftViewController.view];
                [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
            } else {
                underLeftViewController.view.alpha = 1;
                underLeftViewController.view.layer.transform = CATransform3DIdentity;
                [underLeftViewController.view removeFromSuperview];
            }
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - Private

- (CGRect)topViewAnchoredRightFrame:(ECSlidingViewController *)slidingViewController {
    CGRect frame = slidingViewController.view.bounds;
    
    frame.origin.x = slidingViewController.anchorRightRevealAmount;
    frame.size.width = frame.size.width * 0.75;
    frame.size.height = frame.size.height * 0.75;
    frame.origin.y = (slidingViewController.view.bounds.size.height - frame.size.height) / 2;
    
    return frame;
}

- (void)topViewStartingStateLeft:(UIView *)topView containerFrame:(CGRect)containerFrame {
    topView.layer.transform = CATransform3DIdentity;
    topView.layer.position = CGPointMake(containerFrame.size.width / 2, containerFrame.size.height / 2);
}

- (void)underLeftViewStartingState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame {
    underLeftView.alpha = 0;
    underLeftView.frame = containerFrame;
    underLeftView.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1);
}

- (void)underLeftViewEndState:(UIView *)underLeftView {
    underLeftView.alpha = 1;
    underLeftView.layer.transform = CATransform3DIdentity;
}

- (void)topViewAnchorRightEndState:(UIView *)topView anchoredFrame:(CGRect)anchoredFrame {
    topView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
    topView.frame = anchoredFrame;
    topView.layer.position  = CGPointMake(anchoredFrame.origin.x + ((topView.layer.bounds.size.width * 0.75) / 2), topView.layer.position.y);
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

- (IBAction)signIn:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    self.passwordTF.userInteractionEnabled = NO;
    self.usernameTF.userInteractionEnabled = NO;
    [self loginWithUsername:username andPassword:password];
}

- (void)loginWithUsername:(NSString *)un andPassword:(NSString *)pwd {
    if ([un isEqualToString:@""] || [pwd isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    
    TAOverlayOptions options = TAOverlayOptionNone;
    _status = nil;
    _status = @"加载中";
    
    [TAOverlay showOverlayWithLabel:_status Options:(options | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeActivityBlur)];
    
    [PFUser logInWithUsernameInBackground:un password:pwd block:^(PFUser *user, NSError *error) {
        if (user) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:un password:pwd completion:^(NSDictionary *loginInfo, EMError *error) {
                [TAOverlay hideOverlay];
                NSLog(@"进来了");
                if (!error && loginInfo) {
                    NSLog(@"环信登陆成功");
                    [Utilities setUserDefaults:@"userName" content:un];
                    [Utilities setUserDefaults:@"password" content:pwd];
                    _passwordTF.text = @"";
                    PFUser *currentUser = [PFUser currentUser];
                    PFFile *avatar = currentUser[@"avatar"];
                    [avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentDirectory = [directories objectAtIndex:0];
                        __block NSString *filePath = nil;
                        filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", currentUser.username]];
                        if (![fileManager fileExistsAtPath:filePath]) {
                            static dispatch_queue_t backgroundQueue;
                            if (backgroundQueue == nil) {
                                backgroundQueue = dispatch_queue_create("com.beilyton.queue", NULL);
                            }
                            dispatch_async(backgroundQueue, ^(void) {
                                [data writeToFile:filePath atomically:YES];
                            });
                        }
                    }];
                    [self performSelector:@selector(popUpHomeTab) withObject:nil afterDelay:0.05];
                    //                    [self popUpHomeTab];
                } else {
                    NSLog(@"error = %@",error);
                }
                
            } onQueue:nil];
            
        } else {
            [TAOverlay hideOverlay];
            self.passwordTF.userInteractionEnabled = YES;
            self.usernameTF.userInteractionEnabled = YES;
            if (error.code == 101) {
                [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
            } else if (error.code == 100) {
                [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
            } else {
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            }
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _usernameTF){
        NSLog(@"string = %@", string);
        NSString *currentStr = textField.text;
        if (string.length == 0) {
            currentStr = [currentStr substringToIndex:(currentStr.length - 1)];
        } else {
            currentStr = [NSString stringWithFormat:@"%@%@", currentStr, string];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [directories objectAtIndex:0];
        __block NSString *filePath = nil;
        filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", currentStr]];
        if ([fileManager fileExistsAtPath:filePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [_avatarImg setBackgroundImage:image forState:UIControlStateNormal];
        } else {
            [_avatarImg setBackgroundImage:[UIImage imageNamed:@"default"] forState:UIControlStateNormal];
        }
    }
    return YES;
}


@end
