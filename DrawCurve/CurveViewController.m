//
//  ViewController.m
//  DrawCurve
//
//  Created by hanliqiang on 17/4/14.
//  Copyright © 2017年 ustb. All rights reserved.
//

#import "CurveViewController.h"
static CGFloat lineBeginY = 0;
static CGFloat lineMargin = 25;
#define SYSFONT(x) [UIFont systemFontOfSize:x]
#define SYSCOLOR(x,y,z,p) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:p]

@interface CurveViewController ()

@property (nonatomic) NSMutableArray *lineArrayM;
@property (nonatomic) NSMutableArray *numberLabelArrayM;
@property (nonatomic) NSMutableArray *dateLabelArrayM;


@property (nonatomic) CAShapeLayer *shaperLayer;
@property (nonatomic) CAGradientLayer *shapeGradientLayer;
@property (nonatomic) CAGradientLayer *gradientLayer;

@property (nonatomic) UILabel *numberLabel;
@property (nonatomic) UIImageView *numberImageView;

@property (nonatomic) NSArray *yOriginArray;
@property (nonatomic) NSArray *yArray;
//@property (nonatomic) NSArray *xOriginArray;
@end

@implementation CurveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //纵坐标数据
    _yOriginArray = @[@10,@8,@6,@4,@2,@0];
    _yArray = @[@8,@2,@6,@4,@4,@7,@2];
    //横坐标数据
//    _xOriginArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    [self setupUI];
    [self drawG];
}

- (void)setupUI {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = [UIColor blackColor].CGColor;
    bottomView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    [self.view addSubview:bottomView];bottomView.frame = CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width-30,5*lineMargin);
    
    self.numberLabel = [[UILabel alloc] init];
    [self.numberLabel setFont:SYSFONT(15)];
    [self.numberLabel setTextColor:SYSCOLOR(0xff, 0x96, 0x00, 1)];
    [bottomView addSubview:self.numberLabel];
    
    //纵坐标，线
    self.numberLabelArrayM = [NSMutableArray array];
    CGFloat beginY = lineBeginY;
    for (int i = 0; i < _yOriginArray.count; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = SYSCOLOR(0xef, 0xef, 0xef, 1);
        [bottomView addSubview:line];
        line.frame = CGRectMake(0, beginY, [UIScreen mainScreen].bounds.size.width-30, 1/[UIScreen mainScreen].scale);
        beginY += lineMargin;
        UILabel *label = [[UILabel alloc] init];
        [label setFont:SYSFONT(10)];
        [label setTextColor:SYSCOLOR(0x99, 0x99, 0x99, 1)];
        [bottomView addSubview:label];
        label.frame = CGRectMake(15, beginY-5, 20, 10);
        [self.numberLabelArrayM addObject:label];
    }
    
    //横坐标
//    self.dateLabelArrayM = [NSMutableArray array];
//    for (int i = 0; i < _xOriginArray.count; i++) {
//        UILabel *label = [[UILabel alloc] init];
//        [label setFont:SYSFONT(10)];
//        [label setTextColor:SYSCOLOR(0x66, 0x66, 0x66, 1)];
//        [bottomView addSubview:label];
//        [self.dateLabelArrayM addObject:label];
//    }
    
    self.shapeGradientLayer = [[CAGradientLayer alloc] init];
    [bottomView.layer addSublayer:self.shapeGradientLayer];
    self.shapeGradientLayer.frame = CGRectMake(0,lineBeginY , [UIScreen mainScreen].bounds.size.width-30, 5*lineMargin);
    self.shapeGradientLayer.colors  = @[(__bridge id)SYSCOLOR(0xf3, 0x4b, 0xa7, 1).CGColor,(__bridge id)SYSCOLOR(0xff, 0xc3, 0x6c, 1).CGColor ];
    self.shapeGradientLayer.locations = @[@(0),@(1)];
    self.shapeGradientLayer.startPoint = CGPointMake(0, 0.5);
    self.shapeGradientLayer.endPoint = CGPointMake(1, 0.5);
    
    self.gradientLayer = [[CAGradientLayer alloc] init];
    [bottomView.layer addSublayer:self.gradientLayer];
    self.gradientLayer.frame = CGRectMake(0,lineBeginY , [UIScreen mainScreen].bounds.size.width-30, 5*lineMargin);
    self.gradientLayer.colors  = @[(__bridge id)SYSCOLOR(0xf3, 0x4b, 0xa7, 0.1).CGColor,(__bridge id)SYSCOLOR(0xff, 0xc3, 0x6c, 0.1).CGColor ];
    self.gradientLayer.locations = @[@(0),@(1)];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
}

- (void)drawG {
    NSMutableArray *arrayM = [NSMutableArray array];
    
//    int maxIdx = -1;
//    CGFloat max = -1;
    CGFloat x = 0;
//    CGPoint maxPoint = CGPointZero;

    for (int i = 0; i < _yOriginArray.count; i++) {
        //构造数据
        CGFloat y = ([_yOriginArray.firstObject floatValue] - [[_yArray objectAtIndex:i] floatValue]) / ([_yOriginArray.firstObject floatValue] - [_yOriginArray.lastObject floatValue]) * 5 * lineMargin;
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [arrayM addObject:value];
        x += ([UIScreen mainScreen].bounds.size.width-30)*1.0/(_yOriginArray.count-1);
    }

    UIBezierPath *path = [self createPath:[arrayM copy]];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    self.shapeGradientLayer.mask = shapeLayer;
    
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithCGPath:path.CGPath];
    [bottomPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 5*lineMargin)];
    [bottomPath addLineToPoint:CGPointMake(0, 5*lineMargin)];
    [bottomPath closePath];
    CAShapeLayer *bottomShapeLayer = [[CAShapeLayer alloc] init];
    bottomShapeLayer.lineWidth = 1;
    bottomShapeLayer.path = bottomPath.CGPath;
    self.gradientLayer.mask = bottomShapeLayer;
}

//创建一条曲线路径
//取中点，然后平移
- (UIBezierPath *)createPath:(NSArray *)array {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    CGFloat scale = 0.3;
    CGPoint fristControllerPoint = CGPointZero;
    CGPoint secondControllerPoint = CGPointZero;
    CGPoint thirdControllerPoint = CGPointZero;
    for (int i = 1; i < array.count; i++) {
        point  = [((NSValue *)[array objectAtIndex:i]) CGPointValue];
        CGPoint forwardPoint = [((NSValue *)[array objectAtIndex:i-1]) CGPointValue];
        CGPoint currentPoint = [((NSValue *)[array objectAtIndex:i]) CGPointValue];
        CGPoint backPoint = CGPointZero;
        if (i < array.count-1) {
            backPoint = [((NSValue *)[array objectAtIndex:i + 1]) CGPointValue];
        }
        if (i < array.count - 1) {
            
            CGFloat x1 = (forwardPoint.x+currentPoint.x)/2.0;
            CGFloat y1 = (forwardPoint.y+currentPoint.y)/2.0;
            
            CGFloat x2 = (backPoint.x+currentPoint.x)/2.0;
            CGFloat y2 = (backPoint.y+currentPoint.y)/2.0;
            
            //
            CGFloat d1 = sqrt((currentPoint.x-forwardPoint.x)*(currentPoint.x-forwardPoint.x)+(currentPoint.y-forwardPoint.y)*(currentPoint.y-forwardPoint.y));
            CGFloat d2 = sqrt((backPoint.x-currentPoint.x)*(backPoint.x-currentPoint.x)+(backPoint.y-currentPoint.y)*(backPoint.y-currentPoint.y));
            
            CGFloat y = y1 + (d1 / ( d1 + d2 ) * (y2 - y1));
            CGFloat x = x1 + (d1 / ( d1 + d2 ) * (x2 - x1));
            
            CGPoint midPoint = CGPointMake(x, y);
            
            CGFloat xChange = currentPoint.x-midPoint.x;
            CGFloat yChange = currentPoint.y-midPoint.y;
            
            secondControllerPoint = CGPointMake(x1 +xChange + (currentPoint.x-x1 -xChange) * scale, y1 +yChange + (currentPoint.y - y1 -yChange)* scale);
            thirdControllerPoint = CGPointMake(x2 +xChange + (currentPoint.x-x2 -xChange) * scale, y2 +yChange + (currentPoint.y - y2 -yChange)* scale);
            
            if (__CGPointEqualToPoint(fristControllerPoint,CGPointZero)) {
                [path moveToPoint:forwardPoint];
                [path addQuadCurveToPoint:currentPoint controlPoint:secondControllerPoint];
            } else {
                [path addCurveToPoint:currentPoint controlPoint1:fristControllerPoint controlPoint2:secondControllerPoint];
            }
            fristControllerPoint = thirdControllerPoint;
        } else if (__CGPointEqualToPoint(fristControllerPoint,CGPointZero)){
            [path moveToPoint:forwardPoint];
            [path addLineToPoint:currentPoint];
        } else {
            [path addQuadCurveToPoint:currentPoint controlPoint:fristControllerPoint];
        }
    }
    return path;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
