//
//  LeftViewController.m
//  beta1
//
//  Created by 袁文轶 on 16/5/3.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import "LeftViewController.h"
#import <EaseMobSDKFull/EaseMob.h>
#import <SDWebImage/UIButton+WebCache.h>

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
-(void)viewDidAppear:(BOOL)animated{
    
    PFUser *currentUser = [PFUser currentUser];
    PFFile *avatar = currentUser[@"avatar"];
    NSString *avatarUrl = avatar.url;
    NSLog(@"avatarUrl = %@", avatarUrl);
    [_userImage2 sd_setBackgroundImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
        NSString *currentStr = [Utilities getUserDefaults:@"userName"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [directories objectAtIndex:0];
        __block NSString *filePath = nil;
        filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", currentStr]];
        if ([fileManager fileExistsAtPath:filePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [_userImage2 setBackgroundImage:image forState:UIControlStateNormal];
        } else {
            [_userImage2 setBackgroundImage:[UIImage imageNamed:@"default"] forState:UIControlStateNormal];
        }
    }
    
    
    
    _userNameLabel.text = [NSString stringWithFormat:@"昵称：%@", currentUser[@"nickName"]];
    [_userImage2 addTarget:self action:@selector(avatarAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)avatarAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet setExclusiveTouch:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2)
        return;
    //根据actionSheet中选择的按钮决定照片选择器控制器会打开拍照还是照片应用
    UIImagePickerControllerSourceType temp;
    if (buttonIndex == 0) {
        temp = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        temp = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //判断设备上的UIImagePickerController是否具有上述选择的UIImagePickerControllerSourceType的功能
    if ([UIImagePickerController isSourceTypeAvailable:temp]) {
        _imagePickerController = nil;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = temp;
        _imagePickerController.mediaTypes=@[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        //如果无照相功能则弹出提示框“当前设备无照相功能”
        if (temp == UIImagePickerControllerSourceTypeCamera) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前设备无照相功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    //UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    PFUser *userPhoto = [PFUser currentUser];
    userPhoto[@"avatar"] = imageFile;
    [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [_userImage2 setBackgroundImage:image forState:UIControlStateNormal];
        [Utilities popUpAlertViewWithMsg:@"上传成功" andTitle:nil];
        
        NSString *currentStr = [Utilities getUserDefaults:@"userName"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [directories objectAtIndex:0];
        __block NSString *filePath = nil;
        filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", currentStr]];
        [fileManager removeItemAtPath:filePath error:nil];
        if (![fileManager fileExistsAtPath:filePath]) {
            static dispatch_queue_t backgroundQueue;
            if (backgroundQueue == nil) {
                backgroundQueue = dispatch_queue_create("com.beilyton.queue", NULL);
            }
            dispatch_async(backgroundQueue, ^(void) {
                [imageData writeToFile:filePath atomically:YES];
            });
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    [PFUser logOut];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:(@"提示") message:(@"您的账号已退出") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)userImage:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
