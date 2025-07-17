//
//  ARIllustratedBookTableViewCell.m
//  THTAPP
//
//  Created by LiuGaoSheng on 2021/7/27.
//

#import "ARIllustratedBookTableViewCell.h"
#import "Macro.h"

@interface ARIllustratedBookTableViewCell()
@property(nonatomic , strong)UIImageView *illustratedBookimageView;
@property(nonatomic , strong)UILabel *hintLabel;
@end
@implementation ARIllustratedBookTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        self.illustratedBookimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WizardIllustratedBook_1"]];
        [self addSubview:self.illustratedBookimageView];
        
        self.hintLabel = [[UILabel alloc]init];
        self.hintLabel.backgroundColor = RGBA(0, 0, 0, 0.65);
        self.hintLabel.textColor = [UIColor whiteColor];
        self.hintLabel.font = [UIFont systemFontOfSize:12];
        self.hintLabel.layer.cornerRadius = 10;
        self.hintLabel.layer.masksToBounds = YES;
        self.hintLabel.hidden = YES;
        self.hintLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.hintLabel];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.illustratedBookimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-46);
        make.bottom.equalTo(self.mas_bottom).offset(-43);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(20);

    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    _imgUrlStr = imgUrlStr;
    [self.illustratedBookimageView yy_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:nil];
}
- (void)setCollectedStr:(NSString *)collectedStr {
    _collectedStr = collectedStr;
    self.hintLabel.hidden = NO;
    self.hintLabel.text = [NSString stringWithFormat:@"已收集：%@",collectedStr];
}
@end
