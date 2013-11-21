//
//  MasterViewController.m
//  OpenCV_Demo14
//
//  Created by 國武　正督 on 2013/07/05.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CustomUIActionSheet.h"

@interface MasterViewController () {
    NSMutableArray *_converters;
    NSMutableArray *_converter_sections;
    BOOL selected;
}
@end

@implementation MasterViewController

#pragma mark - Initialize
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // システム標準画像を使ったボタン作成
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh  // スタイルを指定
                            target:self  // デリゲートのターゲットを指定
                            action:@selector(actionSheetRefresh)  // ボタンが押されたときに呼ばれるメソッドを指定
    ];
    
    self.navigationItem.rightBarButtonItem = refreshBtn;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    // テーブルビューを表示
    [self makeConvertersTable];
    
    // アクションシートを表示させる
    if(!selected) [self actionSheetRefresh];
}

#pragma mark - Action Sheet
- (void)actionSheetRefresh
{
    // アクションシートを作る
    UIActionSheet *actionSheet;
    // 横向き対応のため、カスタムクラスを使う
    actionSheet = [[CustomUIActionSheet alloc]
                   initWithTitle:NSLocalizedString(@"Select Soruce Type",@"Select Soruce Type")
                   delegate:self
                   cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                   destructiveButtonTitle:nil
                   otherButtonTitles:NSLocalizedString(@"Photo Library",@"Photo Library"), NSLocalizedString(@"Camera",@"Camera"), NSLocalizedString(@"Saved Photos",@"Saved Photos"), nil];
    
    // アクションシートを表示する
    [actionSheet showInView:self.view];
    selected = YES;
}

// アクションシートで選択されたときの処理
- (void)actionSheet: (UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // ユーザーデフォルトの設定
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:buttonIndex forKey:@"kIndex"];
}

#pragma mark - Table View
- (void)makeConvertersTable
{
    
    // xmlファイルのパス
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourceDirectoryPath = [bundle bundlePath];
    NSString *filename = [resourceDirectoryPath stringByAppendingString:@"/converters.txt"];
    
    _converters = [[NSMutableArray alloc] init];
    _converter_sections = [[NSMutableArray alloc] init];
    
    // セクションの数だけ繰り返し
    NSString *content = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    NSMutableArray *_cells = nil;
    for (NSString *line in lines) {
        if ([line hasPrefix:@"#"]){
            // Do nothing.
        }else if ([line hasPrefix:@"  "]) {
            NSMutableDictionary *_dic =  [NSMutableDictionary dictionary];
            NSString *classname = [line substringFromIndex:2];
            
            [_dic setObject:classname forKey:@"class"];
            // タイトル国際化対応
            [_dic setObject:NSLocalizedString([classname stringByAppendingString:@"_title"],@"title") forKey:@"title"];
            // サブタイトル国際化対応
            [_dic setObject:NSLocalizedString([classname stringByAppendingString:@"_subtitle"],@"subtitle") forKey:@"subtitle"];
            
            [_cells addObject:_dic];
        }else{
            if(_cells != nil) [_converters addObject:_cells];
            // セクションタイトル国際化対応
            [_converter_sections addObject:NSLocalizedString([@"Section_" stringByAppendingString:line],@"SectionTitle")];
            _cells = [[NSMutableArray alloc] init];
        }
    }
    if(_cells != nil) [_converters addObject:_cells];
    
    [self.tableView reloadData];
}

// セクション数を決める
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_converter_sections count];
}

// セクションタイトル入力
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_converter_sections objectAtIndex: section];
}


// セル数を決める
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *_cvcell = [_converters objectAtIndex: section];
    return _cvcell.count;
}

// セルのラベルをセット
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSMutableArray *_cvcell   = [_converters objectAtIndex: indexPath.section];
    NSMutableDictionary *_dic = [_cvcell objectAtIndex: indexPath.row];
    
    cell.textLabel.text       = [_dic objectForKey:@"title"];
    cell.detailTextLabel.text = [_dic objectForKey:@"subtitle"];
    
    // サブタイトルを複数行表示できるようにする
    cell.detailTextLabel.numberOfLines = 2;
    
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
        [_converters removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Exit
// DetailViewへ遷移するときに呼び出される
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableArray *_cvcell   = [_converters objectAtIndex: indexPath.section];
        NSMutableDictionary *_dic = [_cvcell objectAtIndex: indexPath.row];
        
        Class aClass = NSClassFromString( [_dic objectForKey:@"class"] );
        id converter = nil;
        if (aClass) {
            converter = [[aClass alloc] init];
        }
        else {
            converter = [[Converter alloc] init];
        }
        
        DetailViewController *DetailViewController = segue.destinationViewController;
        DetailViewController.converter  = converter;
        
        // ユーザーデフォルト（画像のソース選択結果）の呼び出し
        NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
        DetailViewController.img_source = [userDefaults integerForKey:@"kIndex"];
    }
}

#pragma mark - Error
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
