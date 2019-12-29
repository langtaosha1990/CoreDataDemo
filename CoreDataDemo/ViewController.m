//
//  ViewController.m
//  CoreDataDemo
//
//  Created by Gpf on 2019/12/26.
//  Copyright © 2019 Gpf. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee+CoreDataClass.h"

@interface ViewController () {
    NSManagedObjectContext * _context;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
            1.创建模型文件（相当于一个数据库里的表）
            2.添加实体类
            3.创建实体类
            4.生成上下文，关联模型文件生成数据库
            关联时如果本地没有数据库文件Coredata会自行创建
     */
    //上下文
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    // 创建model模型文件
    NSManagedObjectModel * model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 持久化调度器
    // 持久化，把数据保存到一个文件，而不是内存
    NSPersistentStoreCoordinator * store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 创建路径
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * sqlitePath = [doc stringByAppendingString:@"company.sqlites"];
    
    // 告诉coredata数据库的名称和路径
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    
    _context.persistentStoreCoordinator = store;
    
    
}

// 数据库的操作  CURD creat/updata/read/delete
- (IBAction)addEmployee:(id)sender
{
    // 创建员工对象
    for (int i = 0; i < 100; i++) {
        Employee * emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
        emp.name = [NSString stringWithFormat:@"gpf%d", i];
        emp.height = 1 + i * 0.01;
        emp.birthday = [NSDate date];
        
        // 保存到数据库
        NSError * error = nil;
        [_context save:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
    }

}


- (IBAction)updataEmployee:(id)sender
{
    // 修改gpf10的身高为1.80
    //查找对象
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate * predocate = [NSPredicate predicateWithFormat:@"name = %@", @"gpf10"];
    request.predicate = predocate;
    NSError * error = nil;
    NSArray * result = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    //修改数据
    for (Employee * emp in result) {
        emp.height = 2.10;
    }
    
    //
    [_context save:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
}

- (IBAction)deleteEmployee:(id)sender
{
    NSFetchRequest * deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    //删除条件
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d", 10];
//    deleRequest.predicate = pre;
    
    //返回需要删除的对象数组
     NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
     
     //从数据库中删除
     for (Employee *emp in deleArray) {
         [_context deleteObject:emp];
     }
    
     NSError *error = nil;
     //保存--记住保存
     if ([_context save:&error]) {
         NSLog(@"数据删除成功");
     }else{
         NSLog(@"删除数据失败, %@", error);
     }
    
}

- (IBAction)readEmployee:(id)sender
{
    //创建查询请求
       NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
//       //查询条件
//       NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", @"gpf"];
//       request.predicate = pre;
    
    // 设置排序条件
    NSSortDescriptor * heightSort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    request.sortDescriptors = @[heightSort];
    
       // 从第几页开始显示
       // 通过这个属性实现分页
       request.fetchOffset = 0;
       // 每页显示多少条数据
       request.fetchLimit = 6;

    NSError * error = nil;
       //发送查询请求
    NSArray *resArray = [_context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    for (Employee * emp in resArray) {
        NSLog(@"%@ -- %f -- %@", emp.name, emp.height, emp.birthday);
    }
       
}

@end
