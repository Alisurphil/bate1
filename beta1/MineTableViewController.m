//
//  MineTableViewController.m
//  beta1
//
//  Created by 袁文轶 on 16/5/5.
//  Copyright © 2016年 袁文轶. All rights reserved.
//

#import "MineTableViewController.h"

@interface MineTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *useImage;
@property (weak, nonatomic) IBOutlet UIView *headView;
- (IBAction)useImag:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation MineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
        if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
            NSString *currentStr = [Utilities getUserDefaults:@"userName"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [directories objectAtIndex:0];
            __block NSString *filePath = nil;
            filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", currentStr]];
            if ([fileManager fileExistsAtPath:filePath]) {
                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                [_useImage setBackgroundImage:image forState:UIControlStateNormal];
            } else {
                [_useImage setBackgroundImage:[UIImage imageNamed:@"default"] forState:UIControlStateNormal];
            }
        }
    }
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"enablePanGes" object:nil];
    [self.tableView reloadData];
}
//每当离开该页面以后调用以下方法（进入其他视图页面以后）
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"disablePanGes" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)useImag:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFUser *user = [PFUser currentUser];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = user[@"nickName"];
        }
            break;
        case 1: {
            cell.textLabel.text = @"性别";
            if ([user[@"gender"]  isEqual: @"nan"]) {
                cell.detailTextLabel.text = @"男";
            }else if ([user[@"gender"]  isEqual: @"nv"]){
                cell.detailTextLabel.text = @"女";
            }else{
                cell.detailTextLabel.text = @"";
            }
        }
            break;
        case 2: {
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = [dateFormatter stringFromDate:user[@"birthDate"]];;
        }
            break;
        case 3: {
            cell.textLabel.text = @"所在地";
            cell.detailTextLabel.text = user[@"address"];
        }
            break;
        case 4: {
            cell.textLabel.text = @"常用种族";
            cell.detailTextLabel.text = user[@"race"];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

    
@end
