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
#import "LoginViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "ApplyViewController.h"
#import "UserProfileManager.h"
#import "CallViewController.h"
#import "TTGlobalUICommon.h"
#import "InvitationManager.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface Bate1ViewController : UITabBarController<UITabBarControllerDelegate> {
    EMConnectionState _connectionState;
    ChatListViewController *_chatListVC;
    ContactsViewController *_contactsVC;
    UIBarButtonItem *_addFriendItem;
    
}

@property (strong,nonatomic) UINavigationController *FirstNC;
@property (strong,nonatomic) FirstViewController *FirstVC;

@property (strong,nonatomic) UINavigationController *SecondNC;
@property (strong,nonatomic) SecondViewController *SecondVC;

@property (strong,nonatomic) UINavigationController *ThirdNC;
@property (strong,nonatomic) SecondViewController *ThirdVC;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

@end
