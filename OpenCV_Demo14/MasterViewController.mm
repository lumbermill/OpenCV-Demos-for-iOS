//
//  MasterViewController.m
//  OpenCV_Demo14
//
//  Created by 國武　正督 on 2013/07/05.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_functions;
}
@end

@implementation MasterViewController

//セル番号の受け渡し
@synthesize cellIndex;
- (id)init
{
    if (self = [super init]) {
        self.cellIndex = 10;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

/*
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
*/
    
    //セルの初期化
    if (!_functions) {
        _functions = [[NSMutableArray alloc] init];
    }
    //セル作成
    for (int i = 0; i <= 20; i++) {
        NSString *funcIndex = [NSString stringWithFormat:@"%d", i];
        [_functions addObject:funcIndex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 - (void)insertNewObject:(id)sender
{
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //セルタイトル入力
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"ネガポジ反転";
            break;
        case 1:
            cell.textLabel.text = @"２値化　Binary";
            break;
        case 2:
            cell.textLabel.text = @"２値化　Binary_Inv";
            break;
        case 3:
            cell.textLabel.text = @"２値化　Trunk";
            break;
        case 4:
            cell.textLabel.text = @"２値化　ToZero";
            break;
        case 5:
            cell.textLabel.text = @"２値化　ToZero_Inv";
            break;
        case 6:
            cell.textLabel.text = @"２値化　Adaptive";
            break;
        case 7:
            cell.textLabel.text = @"輪郭検出 Sobel";
            break;
        case 8:
            cell.textLabel.text = @"輪郭検出 Laplacian";
            break;
        case 9:
            cell.textLabel.text = @"-";
            break;
        case 10:
            cell.textLabel.text = @"-";
            break;
        case 11:
            cell.textLabel.text = @"-";
            break;
        case 12:
            cell.textLabel.text = @"-";
            break;
        case 13:
            cell.textLabel.text = @"楕円フィッティング";
            break;
        case 14:
            cell.textLabel.text = @"直線検出 Hough";
            break;
        case 15:
            cell.textLabel.text = @"特徴点検出 ORB";
            break;
        case 16:
            cell.textLabel.text = @"-";
            break;
        case 17:
            cell.textLabel.text = @"-";
            break;
        case 18:
            cell.textLabel.text = @"-";
            break;
        case 19:
            cell.textLabel.text = @"顔検出";
            break;
        case 20:
            cell.textLabel.text = @"人検出 HOG";
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_functions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _functions[indexPath.row];
        //セル番号の受け渡し
        cellIndex = indexPath.row;
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
