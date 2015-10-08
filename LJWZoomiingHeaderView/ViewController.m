//
//  ViewController.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollViewContentOffsetObserver.h"
#import "UIScrollView+LJWZoomingHeader.h"
#import "TestZoomingHeaderView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //墙裂建议把这个设成NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self testTableView];
    
//    [self testScrollView];
    
//    [self.tableView removeZoomingHeaderView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter & Getter 
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        CGRect bounds = self.view.bounds;
        bounds.origin.y += 64.f;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:bounds];
        _scrollView.backgroundColor = [UIColor blueColor];
        
    }
    return _scrollView;
}

#pragma mark - Test
- (TestZoomingHeaderView *)testHeaderView
{
    //给出合适的高宽，乱来的话我也不知道会怎样~
    TestZoomingHeaderView *headerView = [[TestZoomingHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300.f)];
    headerView.backgroundColor = [UIColor orangeColor];

    return headerView;
}

- (void)testScrollView
{
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = [UIColor grayColor];
    [self.scrollView addZoomingHeaderView:[self testHeaderView]];
    self.scrollView.contentSize = CGSizeMake(0, 1000.f);
}

- (void)testTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    headerView.backgroundColor = [UIColor orangeColor];
//    
//    self.tableView.tableHeaderView = headerView;
    
    [self.tableView addZoomingHeaderView:[self testHeaderView]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testcell" forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%lf", scrollView.contentOffset.y);
}

@end
