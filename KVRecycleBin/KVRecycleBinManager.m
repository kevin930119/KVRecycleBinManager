//
//  KVRecycleBinManager.m
//  KVRecycleBin
//
//  Created by kevin on 16/7/12.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "KVRecycleBinManager.h"

@implementation KVRecycleBinManager
{
    NSMutableDictionary * _recycleDict;  //复用池
}
//为了保证能够在不同的地方使用不同的回收站，所以不打算使用单例
- (instancetype)init {
    if (self = [super init]) {
        _recycleDict = [NSMutableDictionary dictionary];;
    }
    return self;
}

- (id)recycleWithIdentify:(NSString *)identify build:(id (^)(void))build{
    NSMutableArray * recycleArr = [_recycleDict objectForKey:identify];
    if (recycleArr) {
        if (recycleArr.count) {
            id object = [recycleArr objectAtIndex:0];   //取出第一个
            [recycleArr removeObject:object];   //删除
            return object;
        }else {
            return [self buildWithBlock:build];
        }
    }else {
        //没有对应key值的数组
        recycleArr = [NSMutableArray array];
        [_recycleDict setObject:recycleArr forKey:identify];    //加入到复用池
        return [self buildWithBlock:build];
    }
}
//好像没什么用，这方法，有点想要swift的内部函数，这样就可以在方法内部定义函数了，解决代码重用，/(ㄒoㄒ)/~~
- (id)buildWithBlock:(id (^)(void))build {
    //没有，那么就创建,使用回调函数，让外部实现创建对象的代码
    id buildObject = build();
    if (buildObject) {
        return buildObject;
    }else {
        //外部没有实现创建对象的代码
        return nil;
    }
}

- (void)save:(id)object withIdentify:(NSString *)identify {
    NSMutableArray * recycleArr = [_recycleDict objectForKey:identify];
    if (recycleArr) {
        [recycleArr addObject:object];//加入到复用池
    }else {
        recycleArr = [NSMutableArray array];
        [recycleArr addObject:object];//加入到复用池
        [_recycleDict setObject:recycleArr forKey:identify];
    }
}

@end
