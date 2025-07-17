//
//  ContentMenuView.h
//  swiftONE
//
//  Created by Candy.Yuan on 2022/5/10.
//
#import "ContentMenuView.h"
#import "MJExtension.h"
#import "TimeJsonBean.h"
#import "UIView+Toast.h"

@interface ContentMenuView()

@end

@implementation ContentMenuView{
    UILabel *minDistance;
    UILabel *maxDistance;
    UISlider *distanceSlider;
    UILabel *distanceText;
    UILabel *timeText;
    UILabel *interestText;
    UILabel *filterText;
    UIView *timeView;
    UIImageView *timeLight;
    UIImageView *timeDay;
    UIImageView *timeNight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle]loadNibNamed:@"ContentMenuView" owner:self options:nil]lastObject];
    if (self) {
        self.frame = frame;
    }
    distanceSlider = [[UISlider alloc]initWithFrame:CGRectMake(frame.size.width/2-300/2, 0, 300, 30)];
    distanceSlider.minimumValue = 0;//指定可变最小值
    distanceSlider.maximumValue = 100;//指定可变最大值
    distanceSlider.value = 50;//指定初始值
    [distanceSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];//设置响应事件
    [self addSubview:distanceSlider];
    minDistance = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-300/2-40, 0, 40, 30)];
    minDistance.text = @"0m";
    minDistance.textColor = [UIColor whiteColor];
    minDistance.font = [UIFont systemFontOfSize:15];
    [self addSubview:minDistance];
    
    maxDistance = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2+300/2+10, 0, 40, 30)];
    maxDistance.text = @"100m";
    maxDistance.textColor = [UIColor whiteColor];
    maxDistance.font = [UIFont systemFontOfSize:15];
    [self addSubview:maxDistance];
    distanceText = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2 , 40, 40, 30)];
    distanceText.text = @"距离";
    distanceText.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapDistance = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDistanceView)];
    [distanceText addGestureRecognizer:singleTapDistance];
    distanceText.textColor = [UIColor yellowColor];
    distanceText.font = [UIFont systemFontOfSize:15];
    [self addSubview:distanceText];
    
    timeText = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2 -50 , 40, 40, 30)];
    timeText.text = @"时间";
    timeText.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTimeView)];
    [timeText addGestureRecognizer:singleTap];
    timeText.textColor = [UIColor whiteColor];
    timeText.font = [UIFont systemFontOfSize:15];
    [self addSubview:timeText];
    interestText = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2 +50 , 40, 50, 30)];
    interestText.text = @"兴趣点";
    interestText.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapFunnyView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFunnyView)];
    [interestText addGestureRecognizer:singleTapFunnyView];
    interestText.textColor = [UIColor whiteColor];
    interestText.font = [UIFont systemFontOfSize:15];
    [self addSubview:interestText];
    filterText = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2 -100 , 40, 40, 30)];
    filterText.text = @"滤镜";
    filterText.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapFilter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFilterView)];
    [filterText addGestureRecognizer:singleTapFilter];
    filterText.textColor = [UIColor whiteColor];
    filterText.font = [UIFont systemFontOfSize:15];
    [self addSubview:filterText];
    
    timeView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 -160/2, 0, 160, 40)];
    timeView.backgroundColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0.2];
    timeView.layer.cornerRadius = 20;
    
    timeLight = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    timeLight.backgroundColor = [UIColor blackColor];
    timeLight.layer.cornerRadius = 15;
    timeLight.image = [self scaleToSize:[UIImage imageNamed:@"ic_light_normal"] size:CGSizeMake(20, 20)];
    timeLight.contentMode = UIViewContentModeCenter;
    timeLight.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapLight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLight)];
    [timeLight addGestureRecognizer:singleTapLight];
    [timeView addSubview:timeLight];
    
    timeDay = [[UIImageView alloc]initWithFrame:CGRectMake(62, 2, 34, 34)];
    timeDay.backgroundColor = [UIColor blackColor];
    timeDay.layer.cornerRadius = 17;
    timeDay.image = [self scaleToSize:[UIImage imageNamed:@"ic_day_selected"] size:CGSizeMake(25, 25)];
    timeDay.contentMode = UIViewContentModeCenter;
    timeDay.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapDay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDay)];
    [timeDay addGestureRecognizer:singleTapDay];
    [timeView addSubview:timeDay];
    
    timeNight = [[UIImageView alloc]initWithFrame:CGRectMake(110, 5, 30, 30)];
    timeNight.backgroundColor = [UIColor blackColor];
    timeNight.layer.cornerRadius = 15;
    timeNight.image = [self scaleToSize:[UIImage imageNamed:@"ic_night_normal"] size:CGSizeMake(15, 20)];
    timeNight.contentMode = UIViewContentModeCenter;
    timeNight.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapNight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNight)];
    [timeNight addGestureRecognizer:singleTapNight];
    [timeView addSubview:timeNight];
    [self addSubview:timeView];
    [timeLight setHidden:true];
    [timeDay setHidden:true];
    [timeNight setHidden:true];
    timeView.hidden = TRUE;
    return self;
}

-(IBAction) updateValue:(id)sender{
    float f = distanceSlider.value; //读取滑块的值
    NSLog(@"updateValued%",f);
    NSString *string = [[NSString alloc]initWithFormat:@"%f",f];
    [[UnityToiOSManger sharedInstance]VisibleDistanceChanged:string];
}

- (void) setTimeJson:(NSString *)timeJson{
    TimeJsonBean *timeJsonBean = [TimeJsonBean mj_objectWithKeyValues:timeJson];
    for (NSDictionary *parall in timeJsonBean.parallesverseList) {
        NSLog(@"setTimeJson123:%@", parall[@"name"]);
        NSString *string = [[NSString alloc]initWithFormat:@"收到消息123%@",parall[@"name"]];
        if ([parall[@"id"] isEqual:@"1"]) {
            [timeLight setHidden:false];
        }else if ([parall[@"id"] isEqual:@"2"]) {
            [timeDay setHidden:false];
        }else if ([parall[@"id"] isEqual:@"3"]) {
            [timeNight setHidden:false];
        }
    }
}

-(void) showLight{
    [[UnityToiOSManger sharedInstance]SwitchParallelUniverse:@"1"];
      [UIView animateWithDuration:0.5f animations:^{
          [timeLight setFrame:CGRectMake(18, 2, 34, 34)];
          timeLight.layer.cornerRadius = 17;
          timeLight.image = [self scaleToSize:[UIImage imageNamed:@"ic_light_selected"] size:CGSizeMake(25, 25)];
          
          [timeNight setFrame:CGRectMake(110, 5, 30, 30)];
          timeNight.layer.cornerRadius = 15;
          timeNight.image = [self scaleToSize:[UIImage imageNamed:@"ic_night_normal"] size:CGSizeMake(15, 20)];
          
          [timeDay setFrame:CGRectMake(64, 5, 30, 30)];
          timeDay.layer.cornerRadius = 15;
          timeDay.image = [self scaleToSize:[UIImage imageNamed:@"ic_day_normal"] size:CGSizeMake(20, 20)];
      } completion:^(BOOL finished) {
          
      }];
    NSLog(@"showLight");
    
}

-(void) showDay{
    [[UnityToiOSManger sharedInstance]SwitchParallelUniverse:@"2"];
      [UIView animateWithDuration:0.5f animations:^{
        [timeDay setFrame:CGRectMake(62, 2, 34, 34)];
        timeDay.layer.cornerRadius = 17;
        timeDay.image = [self scaleToSize:[UIImage imageNamed:@"ic_day_selected"] size:CGSizeMake(25, 25)];
        
        [timeNight setFrame:CGRectMake(110, 5, 30, 30)];
        timeNight.layer.cornerRadius = 15;
        timeNight.image = [self scaleToSize:[UIImage imageNamed:@"ic_night_normal"] size:CGSizeMake(15, 20)];
        
        [timeLight setFrame:CGRectMake(20, 5, 30, 30)];
        timeLight.layer.cornerRadius = 15;
        timeLight.image = [self scaleToSize:[UIImage imageNamed:@"ic_light_normal"] size:CGSizeMake(20, 20)];
      } completion:^(BOOL finished) {
          
      }];
}

-(void) showNight{
      [UIView animateWithDuration:0.5f animations:^{
          [timeNight setFrame:CGRectMake(108, 2, 34, 34)];
          timeNight.layer.cornerRadius = 17;
          timeNight.image = [self scaleToSize:[UIImage imageNamed:@"ic_night_selected"] size:CGSizeMake(19, 25)];
          
          [timeLight setFrame:CGRectMake(20, 5, 30, 30)];
          timeLight.layer.cornerRadius = 15;
          timeLight.image = [self scaleToSize:[UIImage imageNamed:@"ic_light_normal"] size:CGSizeMake(20, 20)];
          
          [timeDay setFrame:CGRectMake(64, 5, 30, 30)];
          timeDay.layer.cornerRadius = 15;
          timeDay.image = [self scaleToSize:[UIImage imageNamed:@"ic_day_normal"] size:CGSizeMake(20, 20)];
      } completion:^(BOOL finished) {
          
      }];
    [[UnityToiOSManger sharedInstance]SwitchParallelUniverse:@"3"];
    NSLog(@"showNight");

}


-(void) showTimeView{
    NSLog(@"showTime");
    timeView.hidden = false;
    minDistance.hidden = true;
    maxDistance.hidden = true;
    distanceSlider.hidden = true;
    timeText.textColor = [UIColor yellowColor];
    distanceText.textColor = [UIColor whiteColor];
    filterText.textColor = [UIColor whiteColor];
    interestText.textColor = [UIColor whiteColor];
}

-(void) showDistanceView{
    NSLog(@"showDistanceView");
    timeView.hidden = true;
    minDistance.hidden = false;
    maxDistance.hidden = false;
    distanceSlider.hidden = false;
    timeText.textColor = [UIColor whiteColor];
    distanceText.textColor = [UIColor yellowColor];
    filterText.textColor = [UIColor whiteColor];
    interestText.textColor = [UIColor whiteColor];
}

-(void) showFunnyView{
    NSLog(@"showDistanceView");
    timeView.hidden = true;
    minDistance.hidden = true;
    maxDistance.hidden = true;
    distanceSlider.hidden = true;
    timeText.textColor = [UIColor whiteColor];
    distanceText.textColor = [UIColor whiteColor];
    filterText.textColor = [UIColor whiteColor];
    interestText.textColor = [UIColor yellowColor];
}

-(void) showFilterView{
    NSLog(@"showFilterView");
    timeView.hidden = true;
    minDistance.hidden = true;
    maxDistance.hidden = true;
    distanceSlider.hidden = true;
    timeText.textColor = [UIColor whiteColor];
    distanceText.textColor = [UIColor whiteColor];
    filterText.textColor = [UIColor yellowColor];
    interestText.textColor = [UIColor whiteColor];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
// 创建一个bitmap的context
// 并把它设置成为当前正在使用的context
UIGraphicsBeginImageContext(size);
// 绘制改变大小的图片
[img drawInRect:CGRectMake(0, 0, size.width, size.height)];
// 从当前context中创建一个改变大小后的图片
UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
// 使当前的context出堆栈
UIGraphicsEndImageContext();
// 返回新的改变大小后的图片
return scaledImage;
}

@end
