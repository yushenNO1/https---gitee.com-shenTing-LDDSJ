//
//  GoodsDetailsController.m
//  FUll
//
//  Created by july on 16/11/7.
//  Copyright © 2016年 july. All rights reserved.
//

#import "GoodsDetailsController.h"
#import "PositionCell.h"
#import "GoodHeardView.h"
#import "PriceToBuyCell.h"
#import "GoodTitleCell.h"





#import "LocationLiftModel.h"

#import "LiftDetailModel.h"
#import "GoodDetailThreeCell.h"
#import "PositionCell.h"
#import "LYTShareVC.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

static NSString *indentifierBuyCell = @"goodsdetail1";
static NSString *indentifierTitleCell = @"goodsdetail2";
static NSString *indentifierThreeCell = @"goodsdetail4";

@interface GoodsDetailsController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger _offset;
    NSString *coverUrl;
    NSString *nameStr;
}


@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *liftDataSource;
@property(nonatomic, strong) NSMutableArray *packageArray;


@property(nonatomic, strong) LiftDetailModel *liftDetailModel;

@property(nonatomic, strong) GoodHeardView *btView;

@property(nonatomic, copy) NSString *purchaseNoteStr;
@property(nonatomic, copy) NSString *purchaseNoteStr1;


@property(nonatomic, copy) NSString *jifen;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;

@end

@implementation GoodsDetailsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self requestLocationLift:[NSString stringWithFormat:kURL_Lift_ID, self.life_id]];
    //[self.tableView reloadData];
//    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
//    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark  ------懒加载数组----

- (NSMutableArray *)liftDataSource {
    if (!_liftDataSource) {
        self.liftDataSource = [NSMutableArray array];
    }
    return _liftDataSource;
}

- (NSMutableArray *)packageArray {
    if (!_packageArray) {
        self.packageArray = [NSMutableArray array];
    }
    return _packageArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _offset = 0;//初始值
    self.title = @"商品详情";

    [self setTableView];
     [self requestLocationLift:[NSString stringWithFormat:@"%@/api/v1/life/goodsDetail?lifeId=%@",LSKurl, self.life_id]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_ico_write"] style:UIBarButtonItemStylePlain target:self action:@selector(shareRightBar)];
    self.navigationItem.rightBarButtonItem  = item;
}
-(void)shareRightBar{
    NSDictionary *myInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoMy"];
    if ([PublicToors judgeInfoIsNotNull:myInfo]) {
        [LYTShareVC shareImage:coverUrl Title:nameStr content:@"本地生活分享" AndUrl:[NSString stringWithFormat:LSKurl1@"/App/Local/goods_info/id/%@/spreader/%@", _life_id, myInfo[@"userVo"][@"spreadCode"]]];
    }else{
//        returnLogin;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------ 配置tableView ------------------

- (void)setTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.rowHeight = 210;
    _tableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
    _tableView.estimatedRowHeight = 50; //先估计一个高度
    [self.view addSubview:_tableView];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;

    self.tableView.userInteractionEnabled = YES;
   

    [self.tableView registerNib:[UINib nibWithNibName:@"PriceToBuyCell" bundle:nil] forCellReuseIdentifier:indentifierBuyCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTitleCell" bundle:nil] forCellReuseIdentifier:indentifierTitleCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodDetailThreeCell" bundle:nil] forCellReuseIdentifier:indentifierThreeCell];
    
    


    self.btView = [[GoodHeardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];

     
    NSLog(@"-----------------------------444444444444444%@", self.liftDetailModel.cover);
    [self.btView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.liftDetailModel.cover]];
     self.btView.titleLabel.text = self.liftDetailModel.goodName;
     self.btView.describeLabel.text = self.liftDetailModel.profile;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
    
    [self.btView addGestureRecognizer:tap];
    self.tableView.tableHeaderView = _btView;
    self.tableView.tableHeaderView.backgroundColor = [UIColor blackColor];
}

-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    NSLog(@"asda----asd");
    if (![self.btView.backgroundImageView image]) {
        return;
    }
    //scrollView作为背景
    UIScrollView *bgView = [[UIScrollView alloc] init];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [bgView addGestureRecognizer:tapBg];
    
    UIImageView *picView = self.btView.backgroundImageView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = picView.image;
    imageView.frame = [bgView convertRect:picView.frame fromView:self.view];
    [bgView addSubview:imageView];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    self.lastImageView = imageView;
    self.originalFrame = imageView.frame;
    self.scrollView = bgView;
    //最大放大比例
    self.scrollView.maximumZoomScale = 1.5;
    self.scrollView.delegate = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = imageView.frame;
        frame.size.width = bgView.frame.size.width;
        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        frame.origin.x = 0;
        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    }];
}

-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer
{
    self.scrollView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.5 animations:^{
        self.lastImageView.frame = self.originalFrame;
        tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [tapBgRecognizer.view removeFromSuperview];
        self.scrollView = nil;
        self.lastImageView = nil;
    }];
}

//返回可缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.lastImageView;
}

#pragma mark ------------------ 直供详情请求 ----------------

- (void)requestLocationLift:(NSString *)url {
     NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
     AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
     [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"直供详情请求:%@-------url------%@", responseObject,url);
          _liftDetailModel = [[LiftDetailModel alloc]initWithDictionary:responseObject[@"data"]];
          [self.tableView reloadData];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
          NSLog(@"直供详情请求shibai :%@", error);
     }];
     


}



#pragma mark ------------------ tableView的代理们 ------------------

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (section == 0) {
          return 1;
     }else{
          return 2;
     }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.btView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.liftDetailModel.cover] placeholderImage:[UIImage imageNamed:@"no_tu"]];//表头视图
     self.btView.titleLabel.text = self.liftDetailModel.goodName;
     self.btView.describeLabel.text = self.liftDetailModel.profile;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PriceToBuyCell *priceCell = [tableView dequeueReusableCellWithIdentifier:indentifierBuyCell forIndexPath:indexPath];
            priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            priceCell.priceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"￥", [self.liftDetailModel.price doubleValue]];
             priceCell.soldLabel.hidden = YES;;
            [priceCell.buyBT setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
             priceCell.buyBT.hidden = YES;
            [priceCell.buyBT addTarget:self action:@selector(priceBT:) forControlEvents:(UIControlEventTouchUpInside)];
            return priceCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GoodTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:indentifierTitleCell forIndexPath:indexPath];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
            titleCell.titleLabel.text = @"商家信息";
            return titleCell;
        } else {
            GoodDetailThreeCell *goodThreeCell = [tableView dequeueReusableCellWithIdentifier:indentifierThreeCell forIndexPath:indexPath];
            goodThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            goodThreeCell.titleLabel.text = self.liftDetailModel.shopName;
            goodThreeCell.locationLabel.text = [NSString stringWithFormat:@"%@", self.liftDetailModel.address];
            goodThreeCell.locationImageView.image = [UIImage imageNamed:@"dingwei"];
            goodThreeCell.distanceLabel.text = @"";
            [goodThreeCell.buttonImageView setBackgroundImage:[UIImage imageNamed:@"iphone_green"] forState:(UIControlStateNormal)];
            [goodThreeCell.buttonImageView addTarget:self action:@selector(makePhoneCall:) forControlEvents:(UIControlEventTouchUpInside)];
            return goodThreeCell;
        }


    }

     return 0;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat {
//    NSLog(@"Select %ld----row %ld", indexPat.section, indexPat.row);
//    
//    if (indexPat.section == 4) {
//        
//        if (indexPat.row !=0) {
//            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];//滑到顶部
//            if (self.liftDetailModel.otherLifes.count != 0) {
//                NSString * liftId = [NSString stringWithFormat:@"%@", self.liftDetailModel.otherLifes[indexPat.row-1][@"lifeId"]];
//                self.life_id = liftId;
//                [self requestLocationLift:[NSString stringWithFormat:@"%@/api/v1/life/goodsDetail?lifeId=%@",LSKurl, self.life_id]];//刷新数据
//            }
//        }
//    }
//
//
//}

- (void)makePhoneCall:(UIButton *)sender {//打电话
    //联系客服
    NSString *allString = [NSString stringWithFormat:@"tel:%@",self.liftDetailModel.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

- (void)priceBT:(UIButton *)sender {//立即购买
    NSDictionary *_myInfo =[[NSUserDefaults standardUserDefaults]objectForKey:@"MyInfo"];
    if ([PublicToors judgeInfoIsNotNull:_myInfo]) {
//        SubmitOrdersViewController *subVC = [[SubmitOrdersViewController alloc] init];
//        ///subVC.hidesBottomBarWhenPushed = YES;//隐藏下面tabar
//        subVC.lift_Id = self.life_id;
//        subVC.lift_name = self.liftDetailModel.name;
//        subVC.lift_price = [NSString stringWithFormat:@"%@",self.liftDetailModel.teamBuyPrice];
//        subVC.lift_RedCount = [NSString stringWithFormat:@"%@", self.liftDetailModel.rebackRed];
//        subVC.jifen = _jifen;
//        [self.navigationController pushViewController:subVC animated:YES];
    }else{
//        returnLogin;
         return;
    }
    
    
}


@end
