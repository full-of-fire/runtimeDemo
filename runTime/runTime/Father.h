//
//  Father.h
//  runtime机制
//
//  Created by  jason on 15/12/23.
//  Copyright © 2015年 renlairenwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Father : NSObject

@property(nonatomic, copy) int(^change)(NSString*str);


@property(nonatomic, strong) UIView *testView;
- (void)print;


- (void)test1;

- (void)test2;

@end
