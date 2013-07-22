//
//  MasterViewController.m
//  OpenCV_Demo14
//
//  Created by 國武　正督 on 2013/07/05.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#include <libxml/parser.h>
#include <libxml/xpath.h>

@interface MasterViewController () {
    NSMutableArray *_converters;
    NSMutableArray *_converter_sections;
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
    
    // テーブルビューを表示
    [self makeConvertersTable];
    
    // アクションシートを表示させる
    [self actionSheetRefresh];
}

#pragma mark - Action Sheet
- (void)actionSheetRefresh
{
    // アクションシートを作る
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@"Select Soruce Type"
                   delegate:self
                   cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                   otherButtonTitles:@"Photo Library", @"Camera", @"Saved Photos", nil];
    
    // アクションシートを表示する
    [actionSheet showInView:self.view];
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
    
    xmlChar *_xp_cvs= (xmlChar*)[@"//Converters"     cStringUsingEncoding:NSUTF8StringEncoding];
    xmlChar *_xp_cv = (xmlChar*)[@"/Converter"       cStringUsingEncoding:NSUTF8StringEncoding];
    xmlChar *_xp_cl = (xmlChar*)[@"/class/text()"    cStringUsingEncoding:NSUTF8StringEncoding];
    xmlChar *_xp_tt = (xmlChar*)[@"/title/text()"    cStringUsingEncoding:NSUTF8StringEncoding];
    xmlChar *_xp_st = (xmlChar*)[@"/subtitle/text()" cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourceDirectoryPath = [bundle bundlePath];
    NSString *filename = [resourceDirectoryPath stringByAppendingString:@"/converters.xml"];
    
    xmlDocPtr document = xmlParseFile([filename cStringUsingEncoding:NSUTF8StringEncoding]);
    xmlXPathContextPtr context = xmlXPathNewContext(document);
    
    xmlXPathObjectPtr result = xmlXPathEvalExpression( _xp_cvs, context );
    xmlNodeSetPtr nodeset = result->nodesetval;
    
    _converters = [[NSMutableArray alloc] init];
    _converter_sections = [[NSMutableArray alloc] init];
    
    for (int j=0; j<nodeset->nodeNr; j++) {
        xmlNodePtr node3 = xmlXPathNodeSetItem(nodeset, j);
        xmlXPathContextPtr context3 = xmlXPathNewContext((xmlDocPtr)node3);
    
        xmlXPathObjectPtr result3 = xmlXPathEvalExpression( _xp_cv, context3 );
        xmlNodeSetPtr nodeset3 = result3->nodesetval;
        NSMutableArray *_cvcell = [[NSMutableArray alloc] init];
        
        xmlChar *attr = xmlGetProp(nodeset->nodeTab[j], (const xmlChar*)"section");
        
        for (int i=0; i<nodeset3->nodeNr; i++) {
            xmlNodePtr node2 = xmlXPathNodeSetItem(nodeset3, i);
            xmlXPathContextPtr context2 = xmlXPathNewContext((xmlDocPtr)node2);
            
            xmlNodeSetPtr result21 = xmlXPathEvalExpression(_xp_cl, context2)->nodesetval;
            xmlNodeSetPtr result22 = xmlXPathEvalExpression(_xp_tt, context2)->nodesetval;
            xmlNodeSetPtr result23 = xmlXPathEvalExpression(_xp_st, context2)->nodesetval;
            
            NSMutableDictionary *_dic =  [NSMutableDictionary dictionary];
            [_dic setObject:[NSString stringWithUTF8String:(char *)result21->nodeTab[0]->content] forKey:@"class"];
            [_dic setObject:[NSString stringWithUTF8String:(char *)result22->nodeTab[0]->content] forKey:@"title"];
            [_dic setObject:[NSString stringWithUTF8String:(char *)result23->nodeTab[0]->content] forKey:@"subtitle"];
            
            [_cvcell addObject:_dic];
            
            xmlXPathFreeContext(context2);
        }
        
        [_converters addObject:_cvcell];
        [_converter_sections addObject:[NSString stringWithUTF8String:(char *)attr]];
        
        xmlXPathFreeContext(context3);
    }
    xmlXPathFreeContext(context);
    
}

// セクション数を決める
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
