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
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self testTableView];
    
//    [self testScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
}

#pragma mark - Setter & Getter 
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blueColor];
        
    }
    return _scrollView;
}

#pragma mark - Test
- (TestZoomingHeaderView *)testHeaderView
{
    TestZoomingHeaderView *headerView = [[TestZoomingHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
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
    [self.tableView addZoomingHeaderView:[self testHeaderView]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
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
