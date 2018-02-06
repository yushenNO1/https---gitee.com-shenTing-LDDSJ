//
//  SendListVC.m
//  WDHMerchant
//
//  Created by 张敬文 on 2017/8/18.
//  Copyright © 2017年 Zjw. All rights reserved.
//

#import "SendListVC.h"

@interface SendListVC ()
@property (nonatomic, strong)NSArray * ary;
@end

@implementation SendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.rowHeight = 60* kScreenHeight1;
     self.view.backgroundColor = [UIColor whiteColor];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"11"];
     self.ary = @[@"邮政快递包裹", @"圆通速递", @"申通快递", @"韵达快运", @"中通快递", @"顺丰", @"天天快递", @"宅急送", @"德邦物流", @"汇通快运", @"百世汇通", @"天地华宇", @"优速物流", @"快捷速递", @"佳怡物流"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ary.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
     NSDictionary *dic = @{@"text":_ary[indexPath.row]};
     [[NSNotificationCenter defaultCenter] postNotificationName:@"send" object:nil userInfo:dic];
     [self.navigationController popViewControllerAnimated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11" forIndexPath:indexPath];
     cell.textLabel.text = _ary[indexPath.row];
     cell.textLabel.textColor = [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1];
     cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
