//
//  PNFundationController.m
//  Penn
//
//  Created by PENN on 2017/11/11.
//  Copyright © 2017年 PENN. All rights reserved.
//

#import "PNFundationController.h"
#import "PNGrandparent.h"
#import "PNParent.h"
#import "PNSon.h"
//#import "NSMutableArray+PNAddE.h"
#import "PNRuntimeController.h"
#import "PNClassClustersViewController.h"
#import "NSObject+PNAdd.h"
#import "PNMemManController.h"
#import <sys/utsname.h>
#import "PNBlockViewController.h"
#import "PNWaterModel.h"
#import "PNGCDViewController.h"

typedef void(^NBlock)(void);

@interface PNFundationController ()
@property (nonatomic, copy) NSString *foo;

@property (nonatomic, assign) BOOL ret;

@property (nonatomic, copy) NSString *_obj;

@property (nonatomic, strong) NSTimer *timer;
//单例
@property (nonatomic, class, readonly) UIView *shareView;

@property (nonatomic, copy) NBlock block;

@end

@implementation PNFundationController
{
    NSString * __obj;//_obj不行,成员变量已经存在,自动合成就不再生成__obj
}
@synthesize foo;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;


}
+ (UIView *)shareView {
    return [UIView new];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self inheritAndCategoryFunTest];
    [self operation];

    //字符串存在静态区,不会被ARC释放
    id o1 = @"aipinn";
    //只是指向,不存在拥有关系,当o1释放后,o2也指向nil
    __weak id o2 = o1;
    
    id o3 = [NSObject new];
    //编译器警告:Assigning retained object to weak variable; object will be released after assignment
    //[NSObject new]是临时创建的对象,没有人愿意引用它立马就会释放
    __weak id o4 = [NSObject new];
    {
        id o5 = [NSObject new];
    }
    //在最近的一次的runLoop结束pop时被释放
    __autoreleasing id o6 = [NSObject new];
    //__unsafe_unretained 
    __unsafe_unretained id o7 = self;
    
    //self.view是懒加载过程, 如果没有其他方法在调用就黑屏,如果有人调用就会递归调用最后崩溃.
    //self.view = nil;
    
    //UITableView
    /*
     number row
     height
     cell
     */
    
    
}

- (void)operation {
    __weak typeof(self) weakself = self;
    self.block = ^{
        NSLog(@"%@", @[weakself]);
    };
    
}
- (void)operation1 {
    __weak typeof(self) weakself = self;
    self.block = ^{
        __typeof(weakself)strongSelf = weakself;
        //只是发消息没啥,但是下面操作就不行了
        NSLog(@"%@", @[strongSelf]);
    };
}

- (void)operation2 {
    __weak typeof(self) weakself = self;
    self.block = ^{
        __typeof(weakself)strongSelf = weakself;
        //简单判断
        if (strongSelf) {
            NSLog(@"%@", @[strongSelf]);
        }
    };
}

- (void)doSome:(NSString *)str {
    
}

void ReversedStr(char *str) {
    unsigned long len = strlen(str);
    //1. 倒序遍历
//    for (int i = 0; i<= len; i++) {
//        char c = str[len-i-1];
//        printf("%c", c);
//    }
    
    //2. 前后交换
    char tmp;
    for (int i = 0; i < len/2; i++) {
        tmp = str[i];
        str[i] = str[len-i-1];
        str[len-i-1] = tmp;
    }
    printf("%s", str);
    
}

- (void)testModel{
    
    NSMutableArray * arr = [NSMutableArray new];
    arr = [self loadDataFromPath:@"tmp"];
    sleep(3);
    NSMutableArray *tmp = [NSMutableArray new];
    tmp = [self loadDataFromPath:@"tmp1"];
    
    NSMutableArray *names = [NSMutableArray new];
    for (PNWaterModel * model in arr) {
        [names addObject:model.name];
        
    }
    for (PNWaterModel * model in tmp) {
        if ([names containsObject:model.name]) {//已存在
            for (NSInteger i = 0; i<arr.count; i++) {
                if ([[arr[i] name] isEqualToString:model.name]) {
                    [[arr[i] list] addObjectsFromArray:model.list];
                }
            }
        }else{
            [arr addObject:model];
        }
    }
    NSLog(@"%@", arr);
}

- (NSMutableArray *)loadDataFromPath:(NSString *)fileName{
    
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError * error = nil;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray * arr = [NSMutableArray new];
    arr = [PNWaterModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    return arr;
}

- (void)testBase{
    UIButton * btn = [UIButton buttonImage:@"1" title:@"Runtime"];
    
    //object_setIvar(btn, (__bridge Ivar _Nonnull)(name), @"peng");
    btn.frame = CGRectMake(0, 100, 100, 60);
    [self.view addSubview:btn];
    btn.callBack = ^{
        PNRuntimeController * rt = [PNRuntimeController new];
        [self.navigationController pushViewController:rt animated:YES];
        NSLog(@"");
    };
    
    
    
    [self testSubClassOverwriteSuperclassProperty];
    
}

#pragma mark - Outlet Func

- (IBAction)testBlock:(id)sender {
    PNBlockViewController * block = [[PNBlockViewController alloc] init];
    [self.navigationController pushViewController:block animated:YES];
}
- (IBAction)testMemMan:(id)sender {
    PNMemManController * mm = [PNMemManController new];
    [self.navigationController pushViewController:mm animated:YES];
}
- (IBAction)testClassClusters:(id)sender {
    PNClassClustersViewController * clusters = [[PNClassClustersViewController alloc] init];
    [self.navigationController pushViewController:clusters animated:YES];
}
- (IBAction)testGCD:(id)sender {
    PNGCDViewController * gcd = [[PNGCDViewController alloc]init];
    [self.navigationController pushViewController:gcd animated:YES];
}

#pragma mark -  //继承分类方法测试
- (void)inheritAndCategoryFunTest{
    
    PNParent * parent = [[PNParent alloc] init];
//    PNParent * p = [[PNParent alloc] initWithName:@"peng"];
//    PNParent *par = [PNParent pngrandparentWithName:@"allen"];
//    [p play];
//    [par play];
    [parent play];
    [parent work];
    [parent fly];
    
}

#pragma mark - 集合nil错误
- (void)errorBecauseNil{
    /*
     1. setObject：forkey：中value不能够为nil。
     setValue：forKey：中value可以为nil，但是当value为nil的时候，会自动调用removeObject：forKey方法
     2. setValue：forKey：中key的参数只能够是NSString类型，而setObject：forKey：的可以是任何类型
     3. valueForKey:  ObjectForKey:
     */
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSString * nilStr = nil;
    NSString * str = @"not nill string";
    
    //键值都不能为nil
    //[dict setObject:str forKey:nilStr];
    [dict setObject:nilStr forKey:str];
    
    //值可以为nil,键不能为nil
    //[dict setValue:str forKey:nilStr];
    [dict setValue:nilStr forKey:str];
    
    //key不能为nil
    //[dict setObject:@"" forKey:str];
    //[dict setValue:@"" forKey:str];
    
    //键可以不存在或为nil
    [dict valueForKey:@"peng"];
    [dict objectForKey:@"peng"];
    [dict valueForKey:nilStr];
    [dict objectForKey:nilStr];
}
- (void)runtimeAvoidCollectionError{
    //运行时防止数组崩溃
    NSString * str = nil;
    NSMutableArray * mArr = [NSMutableArray new];
    [mArr addObject:str]; // str = nil
    
    [mArr addObject:@"obj0"];
    [mArr addObject:@"obj1"];
    [mArr addObject:@"obj2"];
    [mArr addObject:@"obj3"];
    [mArr addObject:@"obj4"];
    
    [mArr removeObjectAtIndex:0];
    [mArr removeObjectAtIndex:666];
    [mArr replaceObjectAtIndex:10 withObject:str];
}
#pragma mark - 测试子类重写父类的setter方法遇到的问题:
/*
 测试子类重写父类的setter方法遇到的问题:
 1. 子类不能使用"_属性"的原因
 2. synchronize autosynchronize dynamic的交替
 3. 继承
 4. 对象和类的数据结构 继承关系链
 5. runtime获取类的实例变量和属性
 */
- (void)testSubClassOverwriteSuperclassProperty{
    
    PNGrandparent * gp = [PNGrandparent new];
    gp.lastname = @"Smith";
    gp.firstname = @"Jone";
    
    PNParent * p = [PNParent new];
    [p fly];
    p.firstname = @"Jean";
    NSLog(@"ap:%@", gp.firstname);
    p.sons = @[@"Tom",@"Jack"];

    
    PNSon * s = [PNSon new];
    s.firstname = @"Jack";
    
    [gp work];
    [p work];
}
#pragma mark - Fundation Tips
- (void)aboutSet{
    
    NSArray *array1 = @[@"1",@"2",@"3"];//before
    NSArray *array2 = @[@"1",@"2",@"3",@"4",@"5"];//after
    NSMutableSet *set1 = [NSMutableSet setWithArray:array1];
    NSMutableSet *set2 = [NSMutableSet setWithArray:array2];
    
    //    [set1 unionSet:set2];       //取并集后 set1中为1，2，3，5，6
    //    NSLog(@"%@", set1);
    //    [set1 intersectSet:set2];  //取交集后 set1中为1
    //    NSLog(@"%@", set1);
    //    [set1 minusSet:set2];      //取差集后 set1中为2，3，5，6
    //    NSLog(@"%@", set1);
    {//并集 差集之后为2,3
        NSMutableSet * temp = [NSMutableSet setWithArray:set1.allObjects];
        [set1 unionSet:set2];
        [set1 minusSet:temp];
        NSLog(@"%@", set1);//
    }
    {//并集交集之后为:1, 5, 6
        //        [set1 unionSet:set2];
        //        [set1 intersectSet:set2];
        //        NSLog(@"%@", set1);
    }
    
    {
        NSArray * arr = set2.allObjects;
        NSLog(@"%@", arr);
    }
    
}

#pragma mark - Load and Initialize
- (void)loadAndInitialize{
    
    //    PNGrandparent * gp = [[PNGrandparent alloc] init];
    //    PNParent * parent = [[PNParent alloc] init];
    //    [parent work];
    
    //    PNSon * son = [PNSon new];
    
    
    //    PNGrandparent * grand = [[PNGrandparent alloc]init];
    //    [grand work];
    
    //    PNParent * parent = [[PNParent alloc] init];
    //    [parent work];
    
    /* 看官方文档
     + (void)load方法: 当一个类载入运行期系统时会执行此方法.
     1. 本类.分类.父类.分类都实现load:
     先调用父类 再调用子类, 再调用分类;
     父类的分类与子类的分类调用顺序与编译的先后顺序有关, 先编译的先调用.
     Build Phases --> Compile Sources中在上面的先编译.
     2018-05-15 16:00:08.103838+0800 Penn[14282:357903] load++[PNGrandparent load]
     2018-05-15 16:00:08.104466+0800 Penn[14282:357903] load++[PNParent load]
     2018-05-15 16:00:08.104882+0800 Penn[14282:357903] category++[PNParent(PNAdd) load]
     2018-05-15 16:00:08.105431+0800 Penn[14282:357903] category++[PNGrandparent(PNAdd) load]
     2. laod 方法早于main方法的调用
     3. 不需要调用父类
     4. 使用:
     method_swizzling在此处调用.
     不要在load方法中调用其他类, 因为对于给定的程序无法判断各个类的载入顺序, 但是Foundation框架在load之前就载入到系统中去了.
     不要在此做太多或耗时的事情,例如加锁或等待锁的方法, 因为在运行load方法时,系统处于阻塞状态.
     5. 主线程中
     6. 不遵从复写规则, (父类 子类 分类)都会调用.
     */
    
    
    /* 看官方文档
     + (void)initialize;方法: nitializes the class before it receives its first message.
     1. 父类早于子类: 父类子类实现, 分类没有实现
     2018-05-15 17:09:56.408586+0800 Penn[15808:425822] initialize: +[PNGrandparent initialize]
     2018-05-15 17:09:56.408718+0800 Penn[15808:425822] initialize: +[PNParent initialize]
     2. 分类覆盖本类: 类和分类都实现
     2018-05-15 17:14:40.734420+0800 Penn[16033:431224] initialize: +[PNGrandparent(PNAdd) initialize]
     2018-05-15 17:14:40.734580+0800 Penn[16033:431224] initialize: +[PNParent(PNAdd) initialize]
     3. 子类没有实现,父类实现了,也会调用父类的实现, 超类的initialize的调用次数等于继承层级数.
     PNSon * son = [PNSon alloc] init]; // PNSon-->PNParent-->PNGrandparent
     2018-05-15 17:32:49.757401+0800 Penn[16614:448460] initialize: +[PNGrandparent initialize]
     2018-05-15 17:32:49.757582+0800 Penn[16614:448460] initialize: +[PNGrandparent initialize]
     2018-05-15 17:32:49.758000+0800 Penn[16614:448460] initialize: +[PNGrandparent initialize]
     4. 此方法中是线程安全的.意味着,对本类发送消息的其他线程会阻塞,直到此方法的线程执行完毕再执行其他线程的任务:
     The runtime sends the initialize message to classes in a thread-safe manner. That is, initialize is run by the first thread to send a message to a class, and any other thread that tries to send a message to that class will block until initialize completes.
     5. 使用:
     initialize用来初始化内部数据.最好不在此调用其他类的方法甚至自己的方法.因为此时其他类的内部数据可能还没有准备好. 自己类的方法可能还需要再添加一些东西.
     无法再预编译期设定的全局常量,可以放在initiallize方法中初始化.
     6. 主线程
     7. 遵从复写规则
     */
    
    
    // 编译错误,Initializer element is not a compile-time constant.
    //static NSMutableArray * kArr = [NSMutableArray new];
    static const int kInterval = 10;
    static NSString * string = @"You can init this object";
}

#pragma mark - BOOL
- (void)BOOLValueTest{
    NSDictionary * dic = @{@"a":@0, @"b":@1, @"c":@"0", @"d":@"1"};
    
    //1. 不需要初始化,默认为NO
    
    self.ret = dic[@"a"]; // _ret = YES;
    self.ret = [dic[@"a"] boolValue]; // _set = NO;
    
    self.ret = dic[@"b"]; // _ret = YES;
    self.ret = [dic[@"b"] boolValue]; // _ret = YES;
    
    self.ret = dic[@"c"]; // _ret = YES;
    self.ret = [dic[@"c"] boolValue]; // _ret = NO;
    
    self.ret = dic[@"d"]; // _ret = YES;
    self.ret = [dic[@"d"] boolValue]; // _ret = YES;
    
    self.ret = 0; // _ret = NO;
    
    self.ret = @"0"; // _ret = YES;
    
    self.ret = 1; // _ret = YES;
    
    self.ret = dic[@"hello"];// _set = NO;
    
    self.ret = dic; // _set = YES;
    
    self.ret = [NSNull null]; // _ret = YES;
    
    self.ret = @""; // _ret = YES;
    
    self.ret = [@"" boolValue]; // _ret = NO;
    
    //2. 如果等号右边是:一个存在的对象,1,YES则BOOL值为真,即YES;
    //如果等号右边是0,nil则BOOL为假,即NO.
}

@end
