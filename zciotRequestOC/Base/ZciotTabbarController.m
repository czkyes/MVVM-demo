//
//  ZciotTabbarController.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/21.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "ZciotTabbarController.h"
#import "ViewController.h"
#import "ViewController1.h"
@interface ZciotTabbarController ()
{
    NSArray *vcs;
}
@end

@implementation ZciotTabbarController

- (void)viewDidLoad {
    
    ViewController *vc = [ViewController new];
    ViewController1 *vc1 = [ViewController1 new];
    vcs = @[vc,vc1];
    super.views = vcs;
    super.tabTitles = @[@"控制器1",@"控制器2"];
    super.tabNorImgs = @[@"footbar_icon_off_03",@"footbar_icon_off_03"];
    super.tabSelImgs = @[@"footbar_icon_off_03",@"footbar_icon_off_03"];
    [super viewDidLoad];
    self.delegate = (id)self;
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

@end
