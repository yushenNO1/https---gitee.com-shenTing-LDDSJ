//
//  ScanVC.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/17.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "ScanVC.h"
#import <AVFoundation/AVFoundation.h>
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)
@interface ScanVC ()
<UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**边框*/
@property (nonatomic,weak) UIImageView *QRImageView;
/**扫描*/
@property (nonatomic,weak) UIImageView *scanImageView;
/**最底层的view*/
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) CIDetector *detector;

@end

@implementation ScanVC

- (void)viewDidLoad {
     [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
     
     [self setupNav];
     
     [self setupContentView];
     
     [self startScan];
     
}
#pragma mark - 开始扫描
- (void)startScan
{
     // 判断有没有相机
     //判断是否可以打开相机，模拟器此功能无法使用
     if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
          return;
     }
     
     //如果没获得权限
     NSString *mediaType = AVMediaTypeVideo;
     AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
     if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
          UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,请先到系统“隐私”中打开相机权限哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
          [alert show];
          return;
     }
     //获取摄像设备
     self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
     //创建输入流
     self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
     //创建输出流
     self.output = [[AVCaptureMetadataOutput alloc] init];
     //设置代理 在主线程里刷新
     [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
     //初始化链接对象
     self.session = [[AVCaptureSession alloc] init];
     //高质量采集率
     [self.session setSessionPreset:AVCaptureSessionPresetHigh];
     
     [self.session addInput:self.input];
     [self.session addOutput:self.output];
     
     
     //设置扫码支持的编码格式
     self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code];
     //AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeQRCode
     
     AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
     layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
     layer.frame = self.view.layer.bounds;
     [self.view.layer insertSublayer:layer atIndex:0];
     
     //扫描框
     self.output.rectOfInterest =  CGRectMake ((ScreenH-self.bottomView.frame.size.height)*0.5/ScreenH,(ScreenW-self.bottomView.frame.size.width)*0.5/ScreenW,self.bottomView.frame.size.height/ScreenH,self.bottomView.frame.size.width/ScreenW);
     NSLog(@"%@",NSStringFromCGRect(self.output.rectOfInterest));
     //开始捕获
     [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
     if (metadataObjects.count == 0) {
          NSLog(@"111%@", metadataObjects);
          return;
     }
     
     if (metadataObjects.count > 0) {
          
          [self.scanImageView.layer removeAllAnimations];
          
          //停止扫描
          [self.session stopRunning];
          AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
          //扫描得到的文本 可以拿到扫描后的文本做其他操作哦
          NSLog(@"222%@", metadataObject.stringValue);
          
          //快递信息验证通过
          NSDictionary *dic = @{@"code":metadataObject.stringValue};
          [[NSNotificationCenter defaultCenter] postNotificationName:@"Scan" object:nil userInfo:dic];
          [self.navigationController popViewControllerAnimated:YES];
     }
}

- (void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
}

#pragma mark - 设置导航栏
- (void)setupNav
{
     self.navigationItem.title = @"扫描条形码";
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
     UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftItem)];
     self.navigationItem.leftBarButtonItem = leftBtn;
     UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
     self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)clickLeftItem
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItem
{
     
     self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
     
     if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
          
          if (IOS8) {
               UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
               alert.tag = 4;
               [alert show];
          }
          else{
               UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
               [alert show];
          }
          
          return;
     }
     
     UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
     mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
     mediaUI.allowsEditing = NO;
     mediaUI.delegate = self;
     [self presentViewController:mediaUI animated:YES completion:^{
          [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
     }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     if (!image){
          image = [info objectForKey:UIImagePickerControllerOriginalImage];
     }
     
     NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
     if (features.count >=1) {
          
          [picker dismissViewControllerAnimated:YES completion:^{
               [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
               
               CIQRCodeFeature *feature = [features objectAtIndex:0];
               NSString *scannedResult = feature.messageString;
               
               //快递信息验证通过
               NSDictionary *dic = @{@"code":scannedResult};
               [[NSNotificationCenter defaultCenter] postNotificationName:@"Scan" object:nil userInfo:dic];
               [self.navigationController popViewControllerAnimated:YES];
          }];
          
     }
     else{
          UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含条形码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
          [alertView show];
          
          [picker dismissViewControllerAnimated:YES completion:^{
               [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
               
               //开始捕获
               [self startQRAnimation];
               [self.session startRunning];
          }];
     }
}
#pragma mark - 创建UI
- (void)setupContentView
{
     // 最底层的view
     UIView *bottomView = [[UIView alloc] initWithFrame:WDH_CGRectMake(50, 170, 275, 150)];
     bottomView.center = self.view.center;
     [self.view addSubview:bottomView];
     bottomView.layer.borderColor = [UIColor whiteColor].CGColor;
     bottomView.layer.borderWidth = 1;
     self.bottomView = bottomView;
     
     // 提示
     UILabel *lable = [[UILabel alloc] initWithFrame:WDH_CGRectMake(0, 100, ScreenW, 20)];
     lable.font = [UIFont systemFontOfSize:14];
     lable.text = @"将对应快递单条形码放入扫描框内即可扫描";
     lable.textColor = [UIColor whiteColor];
     lable.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:lable];
     
     // 边框
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
     imageView.image = [UIImage imageNamed:@"qrcode_border"];
     [bottomView addSubview:imageView];
     self.QRImageView = imageView;
     
     // 扫描效果
     UIImageView *scanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 0)];
     scanView.image = [UIImage imageNamed:@"qrcode_scanline_qrcode"];
     [bottomView addSubview:scanView];
     self.scanImageView = scanView;
     
     [self startQRAnimation];
     
//     // 灯泡
//     UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-50)*0.5, ScreenH-180, 50, 50)];
//     [btn setBackgroundImage:[UIImage imageNamed:@"l"] forState:UIControlStateNormal];
//     [btn setBackgroundImage:[UIImage imageNamed:@"l_s"] forState:UIControlStateSelected];
//     [btn addTarget:self action:@selector(clickLight:) forControlEvents:UIControlEventTouchUpInside];
//     [self.view addSubview:btn];
}

//- (void)clickLight:(UIButton *)btn
//{
//     btn.selected = !btn.selected;
//     if (btn.selected) {
//          [self turnTorchOn:YES];
//     } else {
//          [self turnTorchOn:NO];
//     }
//}
//
//#pragma mark - 开关灯
//- (void)turnTorchOn:(bool)on
//{
//     Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
//     if (captureDeviceClass != nil) {
//          AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//          
//          if ([device hasTorch] && [device hasFlash]){
//               
//               [device lockForConfiguration:nil];
//               if (on) {
//                    [device setTorchMode:AVCaptureTorchModeOn];
//                    [device setFlashMode:AVCaptureFlashModeOn];
//                    
//               } else {
//                    [device setTorchMode:AVCaptureTorchModeOff];
//                    [device setFlashMode:AVCaptureFlashModeOff];
//               }
//               [device unlockForConfiguration];
//          }
//     }
//}
//#pragma mark - 创建底部的空间
//- (void)setupBottomView
//{
//     UITabBar *tabbar = [[UITabBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, [UIScreen mainScreen].bounds.size.width, 49)];
//     tabbar.barTintColor = [UIColor blackColor];
//     tabbar.delegate = self;
//     UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"二维码" image:[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode"] selectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode_highlighted"]];
//     UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"条形码" image:[UIImage imageNamed:@"qrcode_tabbar_icon_barcode"] selectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_barcode_highlighted"]];
//     tabbar.items = [NSArray arrayWithObjects:item1,item2, nil];
//     [tabbar setSelectedItem:item1];
//     [self.view addSubview:tabbar];
//}
//
//
//#pragma mark - UITabBarDelegate
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//     if ([item.title isEqualToString:@"条形码"]) {
//          //设置扫码支持的编码格式
//          self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code];
//          self.bottomView.frame = CGRectMake((ScreenW-200)*0.5, 0.5*(ScreenH-100),200, 100);
//          
//          [self startQRAnimation];
//     } else if ([item.title isEqualToString:@"二维码"]) {
//          //设置扫码支持的编码格式
//          self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
//          self.bottomView.frame = CGRectMake((ScreenW-200)*0.5, (ScreenH-200)*0.5, 200, 200);
//          [self startQRAnimation];
//     }
//}

#pragma mark - 开始二维码动画
- (void)startQRAnimation
{
     [self.scanImageView.layer removeAllAnimations];
     
     self.QRImageView.frame = self.bottomView.bounds;
     self.bottomView.center = self.view.center;
     
     CGRect frame = self.scanImageView.frame;
     frame.size.height = 0;
     self.scanImageView.frame = frame;
     [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
          CGRect frame = self.scanImageView.frame;
          frame.size.height = self.bottomView.frame.size.height;
          self.scanImageView.frame = frame;
     } completion:nil];
}

@end
