//
//  ViewController.m
//  runtime机制
//
//  Created by  jason on 15/12/22.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import "ViewController.h"
#include <objc/runtime.h>
#import "Father.h"
#import "Child.h"
#import <Foundation/Foundation.h>
#import "UITextField+placeholderColor.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *TestView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
//    [self changeClassTest];
    
//    [self getClassName];
    
//    [self addMethod];
    
//    [self addMethodWithC];
    
//    [self getClassAllMethod];
    
//    [self getAllPropertyName];
    
    [self getAllIvarName];
    
//    [self methodExchange];
    
//    [self methodSetImplementation];
    
    
//    [_TestView setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 20, 20)];
//    label.textColor = [UIColor redColor];
//    label.text = @"测试";
//    [label sizeToFit];
//    [_TestView setValue:label forKey:@"_placeholderLabel"];
    
    _TestView.tintColor = [UIColor greenColor];
    
    
//    _TestView.backgroundColor
//    [_TestView setValue:[UIColor yellowColor] forKeyPath:@"_backgroundView.backgroundColor"];
//    
//    [_TestView setValue:[UIColor redColor] forKeyPath:@"_contentBackdropView.backgroundColor"];
    
    _TestView.placeholderColor = [UIColor redColor];
    
    
    

}



- (void)methodSetImplementation {

    // 获取方法
    Method method = class_getInstanceMethod([Father class], @selector(test1));
    // 获取实现
    IMP originIMP = method_getImplementation(method);
    
    
    Method m1 = class_getInstanceMethod([Father class], @selector(test2));
    
    // 替换test2实现为test1的实现
    method_setImplementation(m1, originIMP);
    
    Father *f = [Father new];
    
    [f test2];
    
    /**
     *  打印结果
     *
     *  2015-12-23 14:32:30.137 runtime机制[7300:153549] test1
     */
    
}

// 系统类的方法实现部分替换
- (void)methodExchange {

    Method m1 = class_getInstanceMethod([NSString class], @selector(uppercaseString));
    
    Method m2 = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    
    method_exchangeImplementations(m1, m2);
    
    NSLog(@"%@",[@"fadfdfFDFD" uppercaseString]);
    
    NSLog(@"%@",[@"AAAAAFDFDafffd" lowercaseString ]);
    
    /*
     打印结果
     2015-12-23 14:22:06.281 runtime机制[7098:147917] fadfdffdfd
     2015-12-23 14:22:06.282 runtime机制[7098:147917] AAAAAFDFDAFFFD
     */
    
    
}


// 获取所有的成员变量（包括私有变量）
- (void)getAllIvarName {

    
//    class_getClassVariable(<#Class cls#>, <#const char *name#>)
    
    u_int count;
   Ivar *ivars =  class_copyIvarList([UITextField class], &count);
    
    for (int i = 0; i<count; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        
        
        
        NSString *strName = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strName);
    }
}


// 获取一个类的所有属性
- (void)getAllPropertyName {

    u_int count;
    
    objc_property_t *propertys = class_copyPropertyList([Father class], &count);
    
    for (int i = 0; i<count; i++) {
        
        const char* propertyName = property_getName(propertys[i]);
        NSString *strName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",strName);
    }
}


// 获取类的所有方法
- (void)getClassAllMethod {

    
    //获取该类中所有的方法，包括私有方法
    u_int count;
    Method *mehtods = class_copyMethodList([Father class], &count);
    
    for (int i = 0; i<count; i++) {
        
        SEL name = method_getName(mehtods[i]);
        
        NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        
        NSLog(@"---%@",strName);
    }
    
}


int testMehodImp (id self,SEL _cmd,NSString*str,NSString*parameter){

    
    NSLog(@"str=%@,parameter=%@",str,parameter);
    return 10;
}


// 用c语言添加方法
- (void)addMethodWithC {

    Child *test = [Child new];
    
    class_addMethod([Child class], @selector(testMethod::), (IMP)testMehodImp, "i@:@@");
    
    /**
     参数说明：
     cls：被添加方法的类
     name：可以理解为方法名
     imp：实现这个方法的函数
     types：一个定义该函数返回值类型和参数类型的字符串,
     i表示返回类型为int，如v则表示void
     第一个@表示 参数id(self)
     ： 表示 SEL(_cmd)
     @ id(参数1)
     @ id(参数2)
     */
    
    
    if ([test respondsToSelector:@selector(testMehod::)]) {
        
        NSLog(@"这个方法实现了");
    }
    else {
    
        NSLog(@"这个方法没实现");
    }
    
//    [test testMethod:@"第一个参数" :@"第二个参数"];

    
    
    
    
}


// 用block动态为某个类添加方法
- (void)addMethod {

    
    int(^test)(NSString*str) = ^(NSString*str){
    
        
        NSLog(@"%@",str);
        return 20;
    };
    
    test(@"block语法都忘记了玩个毛啊");
    
    
    int (^methodImp)(id self,SEL _cmd,NSString*str) = ^(id self, SEL _cmd,NSString *str) {
    
        NSLog(@"-----%@",str);
        
        return 10;
    };
    
    IMP imp = imp_implementationWithBlock(methodImp);
    Child *child = [Child new];
    
    class_addMethod([Child class], @selector(method::), (IMP)testMehodImp, "i@:@");
    
    if ([child respondsToSelector:@selector(method::)]) {
        
        NSLog(@"是的该方法实现了");
    }
    else {
    
        NSLog(@"对不起你方法没有实现");
    }
    
//    int a = methodImp(child,_cmd,@"我是oc方法，却用block来实现了");
    
//    NSLog(@"a=%d",a);
    
    /*
     2015-12-23 10:54:54.890 runtime机制[3020:68399] 是的该方法实现了
     2015-12-23 10:54:54.891 runtime机制[3020:68399] -----我是oc方法，却用block来实现了
     2015-12-23 10:54:54.891 runtime机制[3020:68399] a=10
     */
}


// 货去对象的类名
- (void)getClassName {

    Father *f = [Father new];
    
    NSString *className = [NSString stringWithCString:object_getClassName(f)];
    NSLog(@"className --%@",className);
    
   
    // 打印结果 2015-12-23 10:09:53.832 runtime机制[2155:43676] className --Father
}


// 动态改变对像的类
- (void)changeClassTest {

    Father *f = [Father new];
    
    [f print];
    
    
    /**
     参数说明
     * obj : 需要改变的对象
       cls : 动态改变的类
        返回值：返回需要改变对象的类
     */
    Class changeClass = object_setClass(f, [Child class]);
    
    // 打印对象的类
    NSLog(@"f class is%@",NSStringFromClass([f  class]));
    
    NSLog(@"changeClass is %@",NSStringFromClass(changeClass));
    
    // 改变其类后，再次执行这个方法程序会崩溃
//    [f print];
    
    // 获取对象的类
    Class newClass = object_getClass(f);
    
    NSLog(@"newClass is %@",NSStringFromClass(newClass));
    
    [[newClass new] childPrintf];
    
    /*
     打印结果
     2015-12-23 10:00:23.562 runtime机制[1969:37922] 我是一个父类哦
     2015-12-23 10:00:23.563 runtime机制[1969:37922] f class isChild
     2015-12-23 10:00:23.563 runtime机制[1969:37922] changeClass is Father
     2015-12-23 10:00:23.563 runtime机制[1969:37922] newClass is Child
     2015-12-23 10:00:23.564 runtime机制[1969:37922] 我是一个子类
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
