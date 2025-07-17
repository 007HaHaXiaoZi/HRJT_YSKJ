//
//  ARGuideView.m
//  swiftONE
//
//  Created by Candy.Yuan on 2022/10/10.
//

#import "ARGuideView.h"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@interface ARGuideView()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic ,strong)UITextField *phoneTextFiled;

@end

@implementation ARGuideView{
    NSMutableArray *dataList;
    NSArray *totalDataList;
    UITableView *table;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle]loadNibNamed:@"ARGuideView" owner:self options:nil]lastObject];
    if (self) {
        self.frame = frame;
    }
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 15;
    dataList=[[NSMutableArray alloc]initWithObjects:
                  @"武汉",
                  @"上海",nil];
        table=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, self.frame.size.height-50) style:UITableViewStylePlain];

        table.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iphone.jpg"]];

        table.delegate=self;

        table.dataSource=self;

        [self addSubview:table];
    NSString *palcehoderStr = @"请输入";
    NSMutableAttributedString *placehoddlerAtt = [[NSMutableAttributedString alloc]initWithString:palcehoderStr];
    [placehoddlerAtt addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, palcehoderStr.length)];
    self.phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    self.phoneTextFiled.delegate = self;
    self.phoneTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextFiled.placeholder = @"请输入";
    self.phoneTextFiled.textColor = [UIColor whiteColor];
    self.phoneTextFiled.font = [UIFont systemFontOfSize:14];
    self.phoneTextFiled.backgroundColor = UIColor.grayColor;
    self.phoneTextFiled.layer.cornerRadius = 8;
    self.phoneTextFiled.clipsToBounds = YES;
    self.phoneTextFiled.attributedPlaceholder = placehoddlerAtt;
    [self addSubview:self.phoneTextFiled];
    return self;
}

-(void)loadData:(NSArray *)newDataList{
    totalDataList = newDataList;
    [dataList removeAllObjects];
    [dataList addObjectsFromArray:totalDataList];
    [table reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{

    NSString *identifier=@"identifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if(cell==NULL)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    NSInteger row=[indexPath row];

    cell.textLabel.text=[dataList objectAtIndex:row];

    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [dataList count];
}

//这个方法返回表格每个分组的行数，非分组的表格默认为一个分组。

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{

    if([indexPath row]%2==0)

    {

        cell.backgroundColor=[UIColor greenColor];

    }

    else{

        cell.backgroundColor=[UIColor blueColor];

    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSLog(@"1234");
    if ([self.delegate respondsToSelector:@selector(itemClick:)]) {
        [self.delegate itemClick:dataList[indexPath.row]];
    }
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:dataList[indexPath.row] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    [alert show];

}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{

    NSLog(@"执行删除");

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}
- (void)textFieldDidChangeSelection:(UITextField *)textField API_AVAILABLE(ios(13.0), tvos(13.0)){
    NSString *text = textField.text;
    NSLog(@"textField %@",text);
    [dataList removeAllObjects];
    if(text==nil||text.length==0){
        [dataList addObjectsFromArray:totalDataList];
        [table reloadData];
        return;
    }
    dataList = [[NSMutableArray alloc]init];
    for (int i = 0; i < totalDataList.count; i++) {
        NSString *name = totalDataList[i];
        NSLog([name uppercaseString]);
        NSLog([name lowercaseString]);
        if([name containsString:text]|| [[name uppercaseString] containsString:text] || [[name lowercaseString] containsString:text]){
            [dataList addObject:name];
        }
    }
    [table reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end
