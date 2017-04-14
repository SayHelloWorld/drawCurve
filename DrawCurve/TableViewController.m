//
//  TableViewController.m
//  DrawCurve
//
//  Created by hanliqiang on 17/4/14.
//  Copyright © 2017年 ustb. All rights reserved.
//

#import "TableViewController.h"
#import "CurveViewController.h"
#import "CircleCurveViewController.h"
@interface TableViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArrayM;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self setupData];
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id celldata = [self.dataArrayM objectAtIndex:indexPath.row];
    if ([[celldata description] isEqualToString:@"curve"]) {
        static NSString *curveId = @"curveId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:curveId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:curveId];
        }
        cell.textLabel.text = @"连接不在同一条直线上的点画curve";
        return cell;
    } else if ([[celldata description] isEqualToString:@"circleCurve"]) {
        static NSString *circleCurveId = @"circleCurveId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:circleCurveId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:circleCurveId];
        }
        cell.textLabel.text = @"连接不在同一条直线上的点画curve首尾相接";
        return cell;
    } else {
        return [[UITableViewCell alloc] init];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrayM.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id celldata = [self.dataArrayM objectAtIndex:indexPath.row];
    if ([[celldata description] isEqualToString:@"curve"]) {
        return 44;
    } else if ([[celldata description] isEqualToString:@"circleCurve"]) {
        return 44;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    id celldata = [self.dataArrayM objectAtIndex:indexPath.row];
    if ([[celldata description] isEqualToString:@"curve"]) {
        CurveViewController *curve = [[CurveViewController alloc] init];
        [self.navigationController pushViewController:curve animated:YES];
    } else if ([[celldata description] isEqualToString:@"circleCurve"]) {
        CircleCurveViewController *circleCurve = [[CircleCurveViewController alloc] init];
        [self.navigationController pushViewController:circleCurve animated:YES];
    } else {
        
    }

}

- (void) setupData {
    if (self.dataArrayM == nil) {
        self.dataArrayM = [NSMutableArray array];
    }
    [self.dataArrayM removeAllObjects];
    [self.dataArrayM addObject:@"curve"];
    [self.dataArrayM addObject:@"circleCurve"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
