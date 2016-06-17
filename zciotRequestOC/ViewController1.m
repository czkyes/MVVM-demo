//
//  ViewController1.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/21.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "ViewController1.h"
#import "AppDelegate.h"
#import "Person.h"
@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    //保存新数据
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    person.name = @"czk";
    person.age = [NSNumber numberWithInt:25];
    person.score = [NSNumber numberWithInt:100];
    
    
   
    
    [self.appDelegate saveContext];
    
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  － app代理
-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
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
