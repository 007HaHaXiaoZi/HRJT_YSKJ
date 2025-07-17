//
//  ARPetRulesView.m
//  THTAPP
//
//

#import "ARPetRulesView.h"
#import "View+MASAdditions.h"
#import "Macro.h"
@interface ARPetRulesView()<UITableViewDataSource,UITableViewDelegate,MyTouchViewDlegate>
@property (weak, nonatomic) IBOutlet UIButton *toB;
@property (weak, nonatomic) IBOutlet UIButton *toBFather;
@property (weak, nonatomic) IBOutlet UILabel *rulesText;
@property (weak, nonatomic) IBOutlet UIButton *toCFather;
@property (weak, nonatomic) IBOutlet UIButton *toGFather;
@property (nonatomic , strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIStackView *styleList;
@property (weak, nonatomic) IBOutlet UILabel *duochangjingfengge;

@end
@implementation ARPetRulesView{
    UIScrollView *uiscrollView;
    NSInteger *currentIndex;
    UIImageView *currentView;
    UIView *borderMove;
    NSMutableArray *imageViewList;
    NSMutableArray *menuStringList;
    NSArray *mARDataTotal;
    NSArray *mARData;
    UIStackView *uistack;
    NSString *deviceType;
    MyTouchView *fatherView;
    UILabel *selectedUILabel;
    int currentMenuIndex;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"ARPetRulesView" owner:self options:nil] lastObject];
    //self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    
    UIImageView *mapReset = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-63, self.frame.size.height-60, 43, 43)];
    [mapReset setImage:[UIImage imageNamed:@"ic_map_reset"]];
    [mapReset setUserInteractionEnabled:YES];
    [mapReset setMultipleTouchEnabled:YES];
    mapReset.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewReset:)];
    singleTap1.numberOfTapsRequired = 1;
    singleTap1.numberOfTouchesRequired = 1;
    [mapReset addGestureRecognizer:singleTap1];
    //[self addSubview:mapReset];

    _toBFather.backgroundColor = [UIColor whiteColor];
    _toBFather.layer.cornerRadius = 10;
    _toCFather.backgroundColor = [UIColor whiteColor];
    _toCFather.layer.cornerRadius = 10;
    _toGFather.backgroundColor = [UIColor whiteColor];
    _toGFather.layer.cornerRadius = 10;
    
    [_toBFather setHidden:true];
    [_toCFather setHidden:true];
    [_toGFather setHidden:true];
    imageViewList = [[NSMutableArray alloc]init];
    menuStringList = [[NSMutableArray alloc]init];
    
    deviceType = [UIDevice currentDevice].model;
    NSLog(@"yuan  shebei:%@", deviceType);
    
    UIView *uiView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-250, 150, 250)];
    [uiView setClipsToBounds:YES];
    fatherView = [[MyTouchView alloc]initWithFrame:CGRectMake(0, 0, 150, 250)];
    fatherView.delegate = self;
    [uiView addSubview:fatherView];
    [self addSubview:uiView];
//
//    for (int a = 0; a<5; a++) {
//        UILabel *uiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, a*50, 150, 50)];
//        uiLabel.text = [[NSString alloc]initWithFormat:@"矩芯%d楼", a+1];
//        if (a==0) {
//            currentMenuIndex = 0;
//            selectedUILabel = uiLabel;
//            uiLabel.font = [UIFont systemFontOfSize:20];
//            uiLabel.textColor = [UIColor whiteColor];
//        }else{
//            uiLabel.textColor = [UIColor grayColor];
//            uiLabel.font = [UIFont systemFontOfSize:16];
//        }
//        [uiLabel setUserInteractionEnabled:YES];
//        [uiLabel setMultipleTouchEnabled:YES];
//        uiLabel.clipsToBounds = YES;
//        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenu:)];
//        //NSNumber a = [NSNumber numberWithInt:i] ;
//        [uiLabel setTag:a];
//        [uiLabel addGestureRecognizer:singleTap1];
//        uiLabel.textAlignment = NSTextAlignmentCenter;
//        [fatherView addSubview:uiLabel];
//    }
//    [self->fatherView setFrame:CGRectMake(0, (2-currentMenuIndex)*50, 150, 250)];
        UIImageView *bgSelected = [[UIImageView alloc]initWithFrame:CGRectMake(20, 107, 110, 36)];
        bgSelected.image = [UIImage imageNamed:@"ic_selected_menu"];
        [uiView addSubview:bgSelected];
    
        uiscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(150, self.frame.size.height-250, self.frame.size.width-150 , 250)];
        uistack = [[UIStackView alloc]initWithFrame:CGRectMake(0, 0, 4*170, 190)];
    //[uiscrollView.layer insertSublayer:gradient atIndex:0];
    //3.将内容视图作为scrollView的子视图
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3*126+5, 15, 116, 116)];
    //[self.styleList addSubview:imageView];
    [uistack addSubview:imageView];
    [imageView setTag:3];
    //[self.scrollView addSubview: view];
    [imageView setImage:[UIImage imageNamed:@"ic_scene_aveter"]];
    if ([deviceType isEqualToString:@"iPad"]) {
        borderMove = [[UIView alloc]initWithFrame:CGRectMake(3*170+5, 15,150,150)];
    }else{
        borderMove = [[UIView alloc]initWithFrame:CGRectMake(3*126+5, 15,116,116)];
    }

    borderMove.layer.borderWidth = 3;
    borderMove.layer.cornerRadius = 13;
    borderMove.layer.borderColor = [UIColor whiteColor].CGColor;
    [imageViewList addObject:imageView];
    //[imageView insertSubview:borderMove atIndex:1];
    [uiscrollView addSubview:borderMove];
    currentIndex = 0;
    [uiscrollView addSubview:uistack];
    uiscrollView.contentSize = uistack.bounds.size;
    currentView  = imageView;
       
    //4.当然了，还得把scrollView添加到视图结构中
    [self addSubview: uiscrollView];
    
//    CGRect tempFrame = _toB.frame;
//    tempFrame.size.height = 420;
//    tempFrame.size.width = 420;
//    _toB.frame = tempFrame;
    return self;
}

-(void)moveUp{
    NSLog(@"moveeUP123");
    currentMenuIndex--;
    if (currentMenuIndex<0) {
        currentMenuIndex = 0;
        return;
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self->fatherView setFrame:CGRectMake(0, (2-currentMenuIndex)*50, 150, menuStringList.count*50)];
    } completion:^(BOOL finished) {
        selectedUILabel.textColor = [UIColor grayColor];
        selectedUILabel.font = [UIFont systemFontOfSize:16];
        selectedUILabel = fatherView.subviews[currentMenuIndex];
        selectedUILabel.font = [UIFont systemFontOfSize:20];
        selectedUILabel.textColor = [UIColor whiteColor];
        [self setCurrentSelected:currentMenuIndex];
    }];
}
-(void)moveDown{
    NSLog(@"moveDown123");
    currentMenuIndex++;
    if (currentMenuIndex>=menuStringList.count) {
        currentMenuIndex = menuStringList.count-1;
        return;
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self->fatherView setFrame:CGRectMake(0, (2-currentMenuIndex)*50, 150, menuStringList.count*50)];
    } completion:^(BOOL finished) {
        selectedUILabel.textColor = [UIColor grayColor];
        selectedUILabel.font = [UIFont systemFontOfSize:16];
        selectedUILabel = fatherView.subviews[currentMenuIndex];
        selectedUILabel.font = [UIFont systemFontOfSize:20];
        selectedUILabel.textColor = [UIColor whiteColor];
        [self setCurrentSelected:currentMenuIndex];
    }];
}
-(void) clickMenu:(UITapGestureRecognizer *)gestureRecognizer{
    currentMenuIndex = gestureRecognizer.view.tag;
    NSLog(@"点击了第%ld张图片", currentMenuIndex);
    [UIView animateWithDuration:0.5f animations:^{
        [self->fatherView setFrame:CGRectMake(0, (2-currentMenuIndex)*50, 150, menuStringList.count*50)];
    } completion:^(BOOL finished) {
        selectedUILabel.textColor = [UIColor grayColor];
        selectedUILabel.font = [UIFont systemFontOfSize:16];
        selectedUILabel = gestureRecognizer.view;
        selectedUILabel.font = [UIFont systemFontOfSize:20];
        selectedUILabel.textColor = [UIColor whiteColor];
        [self setCurrentSelected:currentMenuIndex];
    }];
}

-(void)mapViewReset:(UITapGestureRecognizer *)gestureRecognizer{
    if ([self.delegate respondsToSelector:@selector(mapReset)]) {
        [self.delegate mapReset];
    }
}

-(void) clickindex:(UITapGestureRecognizer *)gestureRecognizer{
    int  aa = gestureRecognizer.view.tag;
//    if (currentIndex == aa ) {
//        return;
//    }
    currentIndex = gestureRecognizer.view.tag;
    NSLog(@"点击了第%ld张图片", gestureRecognizer.view.tag);
    if ([deviceType isEqualToString:@"iPad"]) {
        [borderMove setFrame:CGRectMake(gestureRecognizer.view.tag*170+5, 15,150,150)];
    }else{
        [borderMove setFrame:CGRectMake(gestureRecognizer.view.tag*126+5, 15,116,116)];
    }
    if ([self.delegate respondsToSelector:@selector(bottomViewClickItem:)]) {
        [self.delegate bottomViewClickItem:mARData[gestureRecognizer.view.tag]];
    }
}

- (void) hideListView{
    [self setHidden:true];
    //[uiscrollView setHidden:true];
    //[_duochangjingfengge setHidden:true];
}


- (void) setDataList:(NSArray *)ardata{
    [self setHidden:false];
    mARDataTotal = ardata;
    
    for (int i = 0; i< mARDataTotal.count; i++) {
        ARSceneBean *armode = mARDataTotal[i];
        NSString *text = armode.place;
        if (![menuStringList containsObject:text]) {
            [menuStringList addObject:text];
        }
    }
    for (int a = 0; a<menuStringList.count; a++) {
        UILabel *uiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, a*50, 150, 50)];
        NSString *text = menuStringList[a];
        uiLabel.text = text;
        if (a==0) {
            currentMenuIndex = 0;
            selectedUILabel = uiLabel;
            uiLabel.font = [UIFont systemFontOfSize:20];
            uiLabel.textColor = [UIColor whiteColor];
        }else{
            uiLabel.textColor = [UIColor grayColor];
            uiLabel.font = [UIFont systemFontOfSize:16];
        }
        [uiLabel setUserInteractionEnabled:YES];
        [uiLabel setMultipleTouchEnabled:YES];
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenu:)];
        //NSNumber a = [NSNumber numberWithInt:i] ;
        [uiLabel setTag:a];
        [uiLabel addGestureRecognizer:singleTap1];
        uiLabel.textAlignment = NSTextAlignmentCenter;
        [fatherView addSubview:uiLabel];
    }
    [self->fatherView setFrame:CGRectMake(0, (2-currentMenuIndex)*50, 150, menuStringList.count*50)];
    [self setCurrentSelected:currentMenuIndex];
}

-(void)setCurrentSelected:(int)index{
    NSMutableArray *newData = [[NSMutableArray alloc]init];
    for (int a = 0; a<mARDataTotal.count; a++) {
        ARSceneBean *armode = mARDataTotal[a];
        if ([armode.place isEqual:menuStringList[index]]) {
            [newData addObject:armode];
        }
    }
    [self initDataUI:newData];
}

-(void) initDataUI:(NSArray *)ardata{
    //[uiscrollView setHidden:false];
    //[_duochangjingfengge setHidden:false];
    mARData = ardata;
    currentIndex = 0;
    [uistack.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [uistack setFrame:CGRectMake(0, 0, ardata.count*430, 250)];
    [borderMove setFrame:CGRectMake(5, 15,150,150)];
    [borderMove setHidden:true];
    for (int i = 0; i< mARData.count; i++) {
        ARSceneBean *armode = mARData[i];
        UIImageView *imageView ;
        imageView= [[UIImageView alloc]initWithFrame:CGRectMake(i*430+15, 10, 400, 230)];
        //[self.styleList addSubview:imageView];
        [uistack addSubview:imageView];
        [imageViewList addObject:imageView];
        //[self.scrollView addSubview: view];
        UIImageView *bgTitleName = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 400, 50)];
        //bgTitleName.image = [UIImage imageNamed:@"ic_bg_title_name"];
        UIColor *colorOne = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
        UIColor *colorTwo = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:1];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        gradient.startPoint = CGPointMake(0, 1);
        gradient.endPoint = CGPointMake(0, 0);
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0, 400, 50);
        [bgTitleName.layer insertSublayer:gradient atIndex:0];
        [imageView addSubview:bgTitleName];
        UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 50)];
        titleName.text = armode.name;
        titleName.textColor = [UIColor whiteColor];
        [titleName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
        titleName.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:titleName];
        [imageView setImage:[UIImage imageNamed:@"ic_scene_aveter"]];
        imageView.layer.cornerRadius = 12;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setUserInteractionEnabled:YES];
        [imageView setMultipleTouchEnabled:YES];
        imageView.clipsToBounds = YES;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickindex:)];
        //NSNumber a = [NSNumber numberWithInt:i] ;
        [imageView setTag:i];
        [imageView addGestureRecognizer:singleTap1];
        [imageView yy_setImageWithURL:[NSURL URLWithString:armode.avatar] placeholder:[UIImage imageNamed:@"ic_scene_aveter"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:armode.avatar]];//加载图片;
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = [UIImage imageWithData:imgData];
                                              });//异步从网络加载图片
            });
    }
    uiscrollView.contentSize = uistack.bounds.size;
}

#pragma marke uitable
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger rowx = [indexPath row];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell setFrame:CGRectMake(0, 0, 100, 100)];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.imageView setImage:[UIImage imageNamed:@"ic_scene_aveter"]];
    //cell.imageView.frame.size.width = 100;
    //cell.imageView.frame.size.height = 100;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog (@"用户选中了第%d行",[indexPath row]);
    return indexPath;
}

- (IBAction)toB:(id)sender {
    NSLog(@"hhhhhh");
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
