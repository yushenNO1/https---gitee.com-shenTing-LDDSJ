//
//  JF_CalendarView.m
//  JF_Calendar
//
//  Created by 孙建飞 on 16/5/16.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "JF_CalendarView.h"
#import "NetURL.h"
@implementation JF_CalendarView

-(NSMutableArray*)registerArr{
    if (!_registerArr) {
#pragma arguments-初始化应该加载本地或者服务器端签到日期，敲到完成上传或者本地存储；
        
        _registerArr=[[NSMutableArray alloc]init];
        
    }
    return _registerArr;
    
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self=[super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        [self registerClass:[JF_CalendarCell class] forCellWithReuseIdentifier:@"cell"];
        self.scrollEnabled=NO;
       // UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        //layout.minimumInteritemSpacing=0;
        //
        self.delegate=self;
        self.backgroundColor=[UIColor whiteColor];
        self.dataSource=self;
        //[self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        //
        self.year=[JF_CalendarTools getYear];
        self.searchYear=self.year;
        
        self.month=[JF_CalendarTools getMonth];
        self.searchMonth=self.month;
        
        self.day=[JF_CalendarTools getDay];
        self.searchDay=self.day;
        //
        [self.registerArr addObject:[NSString stringWithFormat:@"%.4d%.2d%.2d",self.year,self.month,self.day]];
        
        self.daysOfMonth=[JF_CalendarTools getDaysOfMonthWithYear:self.year withMonth:self.month];
        self.searchDaysOfMonth=self.daysOfMonth;
        
        //
        self.cellWidth=(frame.size.width-8*5)/7;
        //
        [self setHeaderViewWithWidth:frame.size.width];
        //
     //  NSLog(@"%d",[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.year withMonth:self.month]);
        
    }
    return self;
}
-(void)setHeaderViewWithWidth:(CGFloat)width{
    NSArray *a=[NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
    [self.headerView removeFromSuperview];
    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 80 *kScreenHeight1)];
    //self.headerView.backgroundColor=[UIColor blueColor];
    //
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(width-90 *kScreenWidth1, 10 *kScreenHeight1, 20 *kScreenWidth1, 20 *kScreenHeight1)];
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
   // nextButton.backgroundColor=[UIColor blackColor];
    [self.headerView addSubview:nextButton];
    UIButton *preButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setFrame:CGRectMake(70 *kScreenWidth1, 10 *kScreenHeight1, 20 *kScreenWidth1, 20 *kScreenHeight1)];
    [preButton addTarget:self action:@selector(pre:) forControlEvents:UIControlEventTouchUpInside];
    [preButton setImage:[UIImage imageNamed:@"pre.png"] forState:UIControlStateNormal];
   // preButton.backgroundColor=[UIColor blackColor];

    [self.headerView addSubview:preButton];
    //
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 16 *kScreenHeight1, 100 *kScreenWidth1, 30 *kScreenHeight1)];
    dateLabel.textAlignment=1;
    dateLabel.center=CGPointMake(width/2, 20);
    dateLabel.text=[NSString stringWithFormat:@"%d-%.2d",self.searchYear,self.searchMonth];
    [self.headerView addSubview:dateLabel];
    //
    UIView *blueView=[[UIView alloc]initWithFrame:CGRectMake(10 *kScreenWidth1, 40 *kScreenHeight1, width-20 *kScreenWidth1, 30 *kScreenHeight1)];
    blueView.backgroundColor=Blue_textColor;
    [self.headerView addSubview:blueView];
    CGFloat labelWidth=(width-35)/7;
    for (int i=0; i<7; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth+3 *kScreenWidth1, 0, labelWidth, 30 *kScreenHeight1)];
        label.text=[a objectAtIndex:i];
        label.textAlignment=1;
        label.textColor=[UIColor whiteColor];
        [blueView addSubview:label];
    }
    [self addSubview:self.headerView];
    
    UIButton *nextButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton1 setFrame:CGRectMake(100 *kScreenWidth1, 300 *kScreenHeight1, width-200 *kScreenWidth1, 30 *kScreenHeight1)];
    nextButton1.tag = 6545;
    nextButton1.backgroundColor = Blue_textColor;
    [nextButton1 setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton1 addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
    nextButton1.layer.cornerRadius = 5;
    nextButton1.layer.masksToBounds = YES;
// nextButton.backgroundColor=[UIColor blackColor];
    [self addSubview:nextButton1];
}

- (void)Action:(UIButton*)sender
{
    NSLog(@"视图内部输出%@", _str);
   
    if (_str == nil) {
        _str = @"0000000";
    }
    NSDictionary* dic =@{ @"date":_str};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DatePass" object:nil userInfo:dic];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"calender"];
    [self removeFromSuperview];
    
    
}



-(void)next:(UIButton*)sender{
    //NSLog(@"next");
    if (self.searchMonth==12) {
        self.searchMonth=1;
        self.searchYear++;
        
    }else{
        self.searchMonth++;
    }
    // self.searchDay=[JF_CalendarTools getDay]
    
    [self setHeaderViewWithWidth:self.frame.size.width];
    [self reloadData];
}

-(void)pre:(UIButton*)sender{
   // NSLog(@"pre");
    if (self.searchMonth==1) {
        self.searchMonth=12;
        self.searchYear--;
        
    }else{
        self.searchMonth--;
    }
    // self.searchDay=[JF_CalendarTools getDay]
    self.searchDaysOfMonth=[JF_CalendarTools getDaysOfMonthWithYear:self.searchYear withMonth:self.searchMonth];
    [self setHeaderViewWithWidth:self.frame.size.width];
    [self reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   // return _datasourceArr.count;
    return 42;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//定义每个UICollectionCell 的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return CGSizeMake((K_Width-5)/4, 130);
    return CGSizeMake(self.cellWidth, self.cellWidth-10);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //  UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    return UIEdgeInsetsMake(80, 17.5, 1, 17.5);
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JF_CalendarCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    int dateNum=(int)indexPath.row-[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth]+1;
    
/*
统一日期设置
*/
        //月内
        if (dateNum>=1&&(indexPath.row<self.searchDaysOfMonth+[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth])) {
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum];
            cell.numLabel.textColor=[UIColor blackColor];

        }
    
        //前一个月
        if (dateNum<1) {
           // cell.numLabel.text=@"";
            cell.numLabel.textColor=[UIColor grayColor];

            int days;
            if (self.searchMonth!=1) {
                days=[JF_CalendarTools getDaysOfMonthWithYear:self.searchYear withMonth:self.searchMonth-1];
            }else if(self.searchMonth==1){
                days=[JF_CalendarTools getDaysOfMonthWithYear:self.searchYear-1 withMonth:12];
            }
             cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum+days];
        }
    
        //后一个月
        if (dateNum>self.searchDaysOfMonth) {
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum-self.searchDaysOfMonth];
            cell.numLabel.textColor=[UIColor grayColor];

        }
/*
背景颜色设置
*/
    //当前月
    if ([NSString stringWithFormat:@"%d%.2d",self.year,self.month].intValue==[NSString stringWithFormat:@"%d%.2d",self.searchYear,self.searchMonth].intValue) {
        cell.numLabel.backgroundColor=[UIColor whiteColor];
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
        //月内
        if (dateNum>=1&&(dateNum<=self.searchDay)) {
            cell.numLabel.backgroundColor=Gray_textColor;
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum];
            cell.numLabel.layer.borderWidth=1;
        }
    }
    //之后的月
    if ([NSString stringWithFormat:@"%d%.2d",self.year,self.month].intValue<[NSString stringWithFormat:@"%d%.2d",self.searchYear,self.searchMonth].intValue) {
       // NSLog(@"大于");
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
        cell.numLabel.backgroundColor=[UIColor whiteColor];
    }
    //之前的月
    if ([NSString stringWithFormat:@"%d%.2d",self.year,self.month].intValue>[NSString stringWithFormat:@"%d%.2d",self.searchYear,self.searchMonth].intValue) {
        //NSLog(@"小于");
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
        cell.numLabel.backgroundColor=[UIColor whiteColor];
        //月内
        if (dateNum>=1&&(indexPath.row<self.searchDaysOfMonth+[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth])) {
            cell.numLabel.backgroundColor=Gray_textColor;
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum];
            cell.numLabel.layer.borderWidth=1;
        }
    }
    
/*
设置签到颜色
*/
#pragma arguments-数组内包含当前日期则说明此日期签到了，设置颜色为蓝色；
    if([self.registerArr containsObject:[NSString stringWithFormat:@"%.4d%.2d%.2d",self.searchYear,self.searchMonth,dateNum]]){
        //NSLog(@"blue");
        cell.numLabel.backgroundColor=Blue_textColor;
        cell.numLabel.textColor=[UIColor whiteColor];
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
    }
    //NSLog(@"%d",[NSString stringWithFormat:@"%d%.2d",self.searchYear,self.searchMonth].intValue);
    return cell;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"calender"]) {
        JF_CalendarCell * cell = (JF_CalendarCell *)[collectionView cellForItemAtIndexPath:_str1];
        cell.numLabel.backgroundColor=[UIColor whiteColor];
        cell.numLabel.textColor=[UIColor blackColor];
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
        JF_CalendarCell * cell1 = (JF_CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        _str1 = indexPath;
        cell1.numLabel.backgroundColor= [UIColor redColor];
        cell1.numLabel.textColor=[UIColor whiteColor];
        cell1.numLabel.layer.masksToBounds=YES;
        cell1.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell1.numLabel.layer.borderWidth=0;
         if (self.searchMonth>9) {
              if ([cell1.numLabel.text intValue]>9) {
                   _str = [NSString stringWithFormat:@"%d-%d-%@", self.searchYear, self.searchMonth, cell1.numLabel.text];
              }else{
                   _str = [NSString stringWithFormat:@"%d-%d-0%@", self.searchYear, self.searchMonth, cell1.numLabel.text];
              }
         }else{
              if ([cell1.numLabel.text intValue]>9) {
                   _str = [NSString stringWithFormat:@"%d-0%d-%@", self.searchYear, self.searchMonth, cell1.numLabel.text];
              }else{
                   _str = [NSString stringWithFormat:@"%d-0%d-0%@", self.searchYear, self.searchMonth, cell1.numLabel.text];
              }
         }

        NSLog(@"第二次以后%@", _str);
    } else {
        JF_CalendarCell * cell = (JF_CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        _str1 = indexPath;
        cell.numLabel.backgroundColor= [UIColor redColor];
        cell.numLabel.textColor=[UIColor whiteColor];
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
         if (self.searchMonth>9) {
              if ([cell.numLabel.text intValue]>9) {
                   _str = [NSString stringWithFormat:@"%d-%d-%@", self.searchYear, self.searchMonth, cell.numLabel.text];
              }else{
                   _str = [NSString stringWithFormat:@"%d-%d-0%@", self.searchYear, self.searchMonth, cell.numLabel.text];
              }
         }else{
              if ([cell.numLabel.text intValue]>9) {
                   _str = [NSString stringWithFormat:@"%d-0%d-%@", self.searchYear, self.searchMonth, cell.numLabel.text];
              }else{
                   _str = [NSString stringWithFormat:@"%d-0%d-0%@", self.searchYear, self.searchMonth, cell.numLabel.text];
              }
         }
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"calender"];
        //记录标识
        NSLog(@"第一次%@", _str);
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
