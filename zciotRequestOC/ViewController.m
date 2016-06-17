//
//  ViewController.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "ViewController.h"
#import "PublicWeiboViewModel.h"
#import "PublicCell.h"
#import "ceshi.h"
#import "LXDGameRecord.h"
#import "Person.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
}
@property (nonatomic,strong)FMDatabase *db;
@property (strong, nonatomic) NSArray *publicModelArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"ceshi.plist"];
//    NSFileManager * fileManager = [[NSFileManager alloc]init];
//    
//    [fileManager removeItemAtPath:targetPath error:nil];//删除沙盒写入的文件
    LXDGameRecord *ceshi = [NSKeyedUnarchiver unarchiveObjectWithFile:targetPath];
    NSLog(@"userName = %@",ceshi.userName);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSLog(@"%@",path);
    NSLog(@"文件已提取");
    //self.title = @"dsasdas";
    self.view.backgroundColor = [UIColor yellowColor];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    [self getData];//网络请求获取数据
    
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"student.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
         //3.打开数据库
    if ([db open]) {
            //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        }else
            {
                NSLog(@"创表失败");
            }
        }
    _db=db;
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
//插入数据
-(void)insert
{
         for (int i = 0; i<10; i++) {
                 NSString *name = [NSString stringWithFormat:@"jack-%d", arc4random_uniform(100)];
                 // executeUpdate : 不确定的参数用?来占位
                [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);", name, @(arc4random_uniform(40))];
                //        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);" withArgumentsInArray:@[name, @(arc4random_uniform(40))]];
        
                 // executeUpdateWithFormat : 不确定的参数用%@、%d等来占位
                 //        [self.db executeUpdateWithFormat:@"INSERT INTO t_student (name, age) VALUES (%@, %d);", name, arc4random_uniform(40)];
             }
}

//删除数据
-(void)delete
{
         //    [self.db executeUpdate:@"DELETE FROM t_student;"];
         [self.db executeUpdate:@"DROP TABLE IF EXISTS t_student;"];
         [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
}

//查询
- (void)query
{
         // 1.执行查询语句
         FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
    
        // 2.遍历结果
        while ([resultSet next]) {
                 int ID = [resultSet intForColumn:@"id"];
                 NSString *name = [resultSet stringForColumn:@"name"];
                 int age = [resultSet intForColumn:@"age"];
                 NSLog(@"%d %@ %d", ID, name, age);
             }
}

//获取数据
- (void)getData
{
    PublicWeiboViewModel *publicViewModel = [[PublicWeiboViewModel alloc] init];
    [publicViewModel setBlockWithReturnBlock:^(id returnValue) {
        
        [SVProgressHUD dismiss];
        _publicModelArray = returnValue;
        NSLog(@"%@",_publicModelArray);
        
        [tableview reloadData];
        //DDLog(@"%@",_publicModelArray);
        
    } WithErrorBlock:^(id errorCode) {
        
        [SVProgressHUD dismiss];
        
    } WithFailureBlock:^{
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1.0];
        
    }];
    
    [publicViewModel fetchDianziWeilan:[NSDictionary dictionaryWithObjects:@[@"860755010000661",@"12345678902"] forKeys:@[@"imei",@"userPhone"]] address:@"getFenceList.do?"];
    
    [SVProgressHUD showWithStatus:@"正在获取用户信息……" maskType:SVProgressHUDMaskTypeBlack];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _publicModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PublicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell = [[PublicCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    [cell setValueWithDic:_publicModelArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self delete];
//    [self insert];
//    [self query];
    //查询所有数据
    
    NSError *error;
    
    NSFetchRequest *request = [NSFetchRequest new];
    NSManagedObjectContext *context = self.appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Person" inManagedObjectContext:context];
    
    [request setEntity: entity];
    
    NSArray *results = [[context executeFetchRequest: request error: &error] copy];
    
    for (Person *p in results) {
        
        NSLog(@"%@, %@, %@", p.name, p.age, p.score);
        
    }
    
    
//    NSLog(@"%@",self.appDelegate.phoneImei);
//    [[zciotNetRequest shareSocket] sendScoketMsgDict:[NSDictionary dictionaryWithObjectsAndKeys:@"12345678907",@"mobilePhone",self.appDelegate.phoneImei,@"imei",@"1",@"type", nil] type:WJDataType_SMS];
//    ceshi *ce = [ceshi new];
//    [self.navigationController pushViewController:ce animated:YES];
    
    
}
#pragma mark  － app代理
-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


