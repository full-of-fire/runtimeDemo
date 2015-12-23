//
//  Father.m
//  runtime机制
//
//  Created by  jason on 15/12/23.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import "Father.h"

@interface Father ()

{

    NSString *_name;
    NSString *_age;
}

@end

@implementation Father

- (void)print {

    NSLog(@"我是一个父类哦");
}
- (void)test1 {

    NSLog(@"test1");
}

- (void)test2 {

    NSLog(@"test2");
}


- (void)test3 {

    NSLog(@"这是个私有方法");
}

@end
