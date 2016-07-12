//
//  KVRecycleBinManager.h
//  KVRecycleBin
//
//  Created by kevin on 16/7/12.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVRecycleBinManager : NSObject

//通过标识取出复用池中的对象
- (id)recycleWithIdentify:(NSString*)identify build:(id(^)(void))build;
//通过标识保存复用池的对象
- (void)save:(id)object withIdentify:(NSString*)identify;

@end
