//
//  SettingVC.m
//  swiftONE
//
//  Created by Candy.Yuan on 2022/2/14.
//

#import "SettingVC.h"

@interface SettingVC ()
@property (weak, nonatomic) IBOutlet UIButton *chooseServerIP;
@property (weak, nonatomic) IBOutlet UILabel *serverIP;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dingweiTime;
@property (weak, nonatomic) IBOutlet UISwitch *recordingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *openFilterSwitch;

@end

@implementation SettingVC

- (IBAction)dingweijiange:(UIButton *)sender {
        [UIAlertView requestWithTitle:@"请输入整数时间（1~500）" message:nil defaultText:_dingweiTime.text sure:^(UIAlertView * , NSString *text) {
            NSLog(@"===123%@",text);
            int dingweiTime = [text intValue];
            if (dingweiTime<1) {
                dingweiTime = 1;
            }else if(dingweiTime>500){
                dingweiTime = 500;
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:dingweiTime forKey:@"dingweiTime"];
            NSString *dingweiTimes = [[NSString alloc]initWithFormat:@"%d",[userDefaults integerForKey:@"dingweiTime"]];
            [self->_dingweiTime setText:dingweiTimes];
            //NSLog(@"===%d",[userDefaults integerForKey:@"dingweiTime"]);
        }];
}
- (IBAction)openRecordingMode:(UISwitch *)sender {
    NSLog(@"===%@",sender.on?@"YES":@"NO");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:sender.on forKey:@"recording"];
}
- (IBAction)openFilter:(UISwitch *)sender {
    NSLog(@"===%@",sender.on?@"YES":@"NO");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:sender.on forKey:@"openFilter"];
}

- (IBAction)openDebugMode:(UISwitch *)sender {
    NSLog(@"===%@",sender.on?@"YES":@"NO");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:sender.on forKey:@"debug"];
    [userDefaults boolForKey:@"debug"];
}
- (IBAction)clearARData:(id)sender {
    // 获取Library文件夹路径
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    // 获取Library下Caches文件夹路径
    //NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    // 实例化NSFileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取Caches文件夹下的所有文件及文件夹
    NSArray *array = [fileManager contentsOfDirectoryAtPath:libPath error:nil];
    // 循环删除Caches下的所有文件及文件夹
    for (NSString *fileName in array) {
        NSLog(fileName);
        //[fileManager copyItemAtPath:[libPath stringByAppendingPathComponent:fileName] toPath:@"/123/" error:nil];
        [fileManager removeItemAtPath:[libPath stringByAppendingPathComponent:fileName] error:nil];
    }
    if (false) {
            UIDocumentPickerViewController *documentPickerVC = [[UIDocumentPickerViewController alloc] initWithURL:[NSURL fileURLWithPath:[libPath stringByAppendingPathComponent:@"Caches"]] inMode:UIDocumentPickerModeExportToService];
            // 设置代理
            documentPickerVC.delegate = self;
            // 设置模态弹出方式
            documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
            [self.navigationController presentViewController:documentPickerVC animated:YES completion:nil];
        }
}
- (IBAction)chooseServerIP:(id)sender {
    [self creatActionSheet];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 44, 30)];
    [imageView setImage:[UIImage imageNamed:@"ic_back"]];
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setUserInteractionEnabled:YES];
    [imageView setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backPress:)];
    [imageView addGestureRecognizer:singleTap1];
    [self.view addSubview:imageView];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *serverIP = [userDefaults stringForKey:@"serverIP"];
    [_serverIP setText:serverIP];
    
    if([userDefaults boolForKey:@"debug"]){
        [_settingSwitch setOn:TRUE];
    }else{
        [_settingSwitch setOn:FALSE];
    }
    if([userDefaults boolForKey:@"recording"]){
        [_recordingSwitch setOn:TRUE];
    }else{
        [_recordingSwitch setOn:FALSE];
    }
    if([userDefaults boolForKey:@"openFilter"]){
        [_openFilterSwitch setOn:TRUE];
    }else{
        [_openFilterSwitch setOn:FALSE];
    }
    NSString *dingweiTimes = [[NSString alloc]initWithFormat:@"%d",[userDefaults integerForKey:@"dingweiTime"]];
    [self->_dingweiTime setText:dingweiTimes];
}
-(void)backPress:(UITapGestureRecognizer *)gestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:false];
    //[self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)creatActionSheet {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"请选择服务器ip" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.popoverPresentationController.sourceView = _chooseServerIP;
    actionSheet.popoverPresentationController.sourceRect = _chooseServerIP.bounds;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"116.196.107.117" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"116.196.107.117" forKey:@"serverIP"];
        [self->_serverIP setText:@"116.196.107.117"];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"114.67.225.7" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"114.67.225.7" forKey:@"serverIP"];
        [self->_serverIP setText:@"114.67.225.7"];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"114.67.232.99" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"114.67.232.99" forKey:@"serverIP"];
        [self->_serverIP setText:@"114.67.232.99"];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
@end
