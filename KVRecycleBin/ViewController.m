//
//  ViewController.m
//  KVRecycleBin
//
//  Created by kevin on 16/7/12.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "ViewController.h"
#import "KVRecycleBinManager.h"

@interface ViewController ()

@end

@implementation ViewController
{
    KVRecycleBinManager * _manager;
    NSTimer * _timer;
    NSMutableArray * _arr;
    NSInteger _index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _index = 0;
    _manager = [[KVRecycleBinManager alloc] init];
    _arr = [NSMutableArray array];  //写这个数组的目的是为了长期持有label，避免系统将label自动释放
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(recycle) userInfo:nil repeats:YES];
}

- (void)recycle {
    _index++;
    /*
     使用方法：外部通过调用接口实现复用池取出对象，需要传入标识符，并且如果复用池中没有对象，需要开发者在block回调函数中自己实现创建对象的代码，并且返回给内部block；
        如果开发者已经使用完对象，例如弹幕的视图已经移出了屏幕，或者已经完全淡出了，已经不需要使用了，那么需要调用另一个接口将对象保存到复用池中。
     */
    UILabel * label = (UILabel*)[_manager recycleWithIdentify:@"label" build:^id{
        return [[UILabel alloc] init];
    }];
    label.tag = _index; //为了判断取出的label是否同一个
//    [_manager save:label withIdentify:@"label"];    //保存到复用池中，打开注释，那么他会将对象保存到复用池，也就是说点击屏幕后的打印应该都是同一个数字，即复用成功，如果没有打开注释，那么不会保存到复用池，将会重复创建，打印结果应该都是不一样的，证明都是不同的对象
    [_arr addObject:label];
}
//点击屏幕可以查看所有的对象
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_timer invalidate];
    for (UILabel * lable in _arr) {
        NSLog(@"%ld", lable.tag);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
