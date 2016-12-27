# SlidingDrawer
简洁易用的抽屉效果,一如既往的详细注解
## 主要代码的实现

```
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
```
```
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

```
![image](https://github.com/nemo316/SlidingDrawer/blob/master/gif/抽屉效果.gif)   


