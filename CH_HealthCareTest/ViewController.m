//
//  ViewController.m
//  CH_HealthCareTest
//
//  Created by 陈浩 on 2017/4/14.
//  Copyright © 2017年 easyGroup. All rights reserved.
//

#import "ViewController.h"
#import "CHHealthKitManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addStepTextField;

@property (weak, nonatomic) IBOutlet UILabel *systemStepLbl;

@property (weak, nonatomic) IBOutlet UITextField *addKiloTextField;

@property (weak, nonatomic) IBOutlet UILabel *systemKiloLbl;


@end

@implementation ViewController{
    CHHealthKitManager *_manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _manager = [CHHealthKitManager shareInstance];
    [_manager getAuthorizedForHealthKit:^(BOOL isFinished) {
         //YES 说明获取到了权限
        if (isFinished) {
           
        }
    }];
    [_manager getStepCount:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _systemStepLbl.text=[NSString stringWithFormat:@"%.f步", value];
        });
    }];
    [_manager getDistance:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _systemKiloLbl.text=[NSString stringWithFormat:@"%.f公里", value];
        });
    }];

}

- (IBAction)addStepCount:(UIButton *)sender {
    __block typeof(self) weakSelf = self;
    [_manager recordStep:[_addStepTextField.text doubleValue] callBack:^(BOOL success) {
        if (success) {
           __block typeof(weakSelf) strongSelf = weakSelf;
            double totalCount = [_systemStepLbl.text doubleValue] + [_addStepTextField.text doubleValue];
            strongSelf -> _systemStepLbl.text = [NSString stringWithFormat:@"%.f步",totalCount];
        }
    }];
}

- (IBAction)addKiloCount:(UIButton *)sender {
    __block typeof(self) weakSelf = self;
    [_manager recordKilo:[_addKiloTextField.text doubleValue] callBack:^(BOOL success) {
        if (success) {
            __block typeof(weakSelf) strongSelf = weakSelf;
            double totalCount = [_systemKiloLbl.text doubleValue] + [_addKiloTextField.text doubleValue];
            strongSelf -> _systemKiloLbl.text = [NSString stringWithFormat:@"%.f公里",totalCount];
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
