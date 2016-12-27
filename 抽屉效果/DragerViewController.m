//
//  DragerViewController.m
//  抽屉效果
//
//  Created by 初七 on 2016/12/27.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "DragerViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width

@interface DragerViewController ()

/** 左视图 */
@property (nonatomic, weak)  UIView *leftV;
/** 右视图 */
@property (nonatomic, weak)  UIView *rightV;
/** 主视图 */
@property (nonatomic, weak)  UIView *mainV;

@end

@implementation DragerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加子控件
    [self setUp];
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.mainV addGestureRecognizer:pan];
    
    //给控制器的View添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}
#pragma mark - 点击任意位置复位
- (void)tap{
    
    //让MainV复位
    [UIView animateWithDuration:0.5 animations:^{
        self.mainV.frame = self.view.bounds;
    }];
}

#define targetR 275 // 根据自己的需要设置大小
#define targetL -275
#pragma mark - 拖动事件
- (void)pan:(UIPanGestureRecognizer *)pan{
    
    //获取偏移量
    CGPoint transP = [pan translationInView:self.mainV];
    //为什么不使用transform,是因为我们还要去修改高度,使用transform,只能修改,x,y
    //self.mainV.transform = CGAffineTransformTranslate(self.mainV.transform, transP.x, 0);

    self.mainV.frame = [self frameWithOffsetX:transP.x];
    //判断拖动的方向
    if(self.mainV.frame.origin.x > 0){
        //向右
        self.rightV.hidden = YES;
    }else if(self.mainV.frame.origin.x < 0){
        //向左
        self.rightV.hidden = NO;
    }
    
    //当手指松开时,做自动定位
    CGFloat target = 0;
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (self.mainV.frame.origin.x > screenW * 0.5 ) {
            //1判断在右侧
            //当前View的x有没有大于屏幕宽度的一半,大于就是在右侧
            target = targetR;
        }else if(CGRectGetMaxX(self.mainV.frame) < screenW * 0.5){
            //2.判断在左侧
            //当前View的最大的x有没有小于屏幕宽度的一半,小于就是在左侧
            target = targetL;
        }
       
        //计算当前mainV的frame.
        CGFloat offset = target - self.mainV.frame.origin.x;
//        NSLog(@"qqqqqwwwww  %f",offset);
        [UIView animateWithDuration:0.5 animations:^{

            self.mainV.frame =  [self frameWithOffsetX:offset];
        }];
    }
    
    //复位
    [pan setTranslation:CGPointZero inView:self.mainV];
    
}

#define maxY 100
#pragma mark - 根据偏移量计算MainV的frame
- (CGRect)frameWithOffsetX:(CGFloat)offsetX {
    
//    NSLog(@"offsetX===%f",offsetX);
    
    CGRect frame = self.mainV.frame;
//    NSLog(@"x====%f",frame.origin.x);
    frame.origin.x += offsetX;

    //当拖动的View的x值等于屏幕宽度时,maxY为最大,最大为100
    // 375 * 100 / 375 = 100
    
    //对计算的结果取绝对值
    CGFloat y =  fabs( frame.origin.x *  maxY / screenW);
    frame.origin.y = y;
    
    //屏幕的高度减去两倍的Y值
    frame.size.height = [UIScreen mainScreen].bounds.size.height - (2 * frame.origin.y);
    
    return frame;
}
#pragma mark - 设置子控件
- (void)setUp{
    
    //leftV
    UIView *leftV = [[UIView alloc] initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor blueColor];
    self.leftV = leftV;
    [self.view addSubview:leftV];
    //rightV
    UIView *rightV = [[UIView alloc] initWithFrame:self.view.bounds];
    rightV.backgroundColor = [UIColor greenColor];
    self.rightV = rightV;
    [self.view addSubview:rightV];
    //mianV
    UIView *mainV = [[UIView alloc] initWithFrame:self.view.bounds];
    mainV.backgroundColor = [UIColor redColor];
    self.mainV = mainV;
    [self.view addSubview:mainV];
}

@end
