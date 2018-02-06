//
//  lableTableViewCell.m
//  goods
//
//  Created by 王松松 on 2016/11/7.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "lableTableViewCell.h"
#import "NetURL.h"

@implementation lableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.centerLabel];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.textField];

    }
    return self;
}
- (UILabel *)centerLabel  {
    if (!_centerLabel)
    {
        _centerLabel =[[UILabel alloc]initWithFrame:CGRectMake(130 * kScreenWidth1, 0 , 100 * kScreenWidth1, 50 * kScreenHeight1)];
        _centerLabel.textAlignment =NSTextAlignmentLeft;

    }
    return _centerLabel;
}

- (UILabel *)leftLabel  {
    if (!_leftLabel)
    {
        _leftLabel =[[UILabel alloc]initWithFrame:CGRectMake(10 * kScreenWidth1, 0, 100 * kScreenWidth1, 50 * kScreenHeight1)];
        _leftLabel.textAlignment =NSTextAlignmentLeft;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel  {
    if (!_rightLabel)
    {
        _rightLabel =[[UILabel alloc]initWithFrame:CGRectMake(240 * kScreenWidth1, 0, 100 * kScreenWidth1, 50 * kScreenHeight1)];
        _rightLabel.textAlignment =NSTextAlignmentRight;

    }
    return _rightLabel;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(120 * kScreenWidth1, 5 * kScreenHeight1, 200 * kScreenWidth1, 40 * kScreenHeight1)];
        _textField.borderStyle =UITextBorderStyleRoundedRect;
        _textField.textAlignment =NSTextAlignmentLeft;
        _textField.clearButtonMode =UITextFieldViewModeUnlessEditing;
        _textField.clearsOnBeginEditing =YES;
        _textField.adjustsFontSizeToFitWidth =YES;
        [_textField addTarget:self action:@selector(tf) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    
    return _textField;
    
}
- (void)tf{
   
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.window endEditing:YES];
//}




@end
