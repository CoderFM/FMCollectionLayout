//
//  FMCollViewController.m
//  FMCollectionLayout_Example
//
//  Created by 郑桂华 on 2020/4/11.
//  Copyright © 2020 周发明. All rights reserved.
//

#import "FMCollViewController.h"
#import <FMCollectionLayoutKit.h>
#import <Masonry/Masonry.h>
#import "FMAddViewController.h"

#import "FMCollectionCustomDecoration.h"
#import "FMCollectionCustomCell.h"
#import "FMCollectionNavTitleView.h"

@interface FMCollViewController ()<FMCollectionLayoutViewConfigurationDelegate, UICollectionViewDelegate>

@property(nonatomic, strong)NSMutableArray<FMLayoutBaseSection *> *shareSections;
@property(nonatomic, weak)FMCollectionLayoutView  *collectionView;
@end

@implementation FMCollViewController

- (void)reloadSection{
    [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:1]];
}
- (void)reloadItem{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}
- (void)reloadAll{
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"刷新分组" style:UIBarButtonItemStyleDone target:self action:@selector(reloadSection)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"刷新单个" style:UIBarButtonItemStyleDone target:self action:@selector(reloadItem)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"刷新全部" style:UIBarButtonItemStyleDone target:self action:@selector(reloadAll)];
    self.navigationItem.rightBarButtonItems = @[item2, item1, item3];
    
    self.shareSections = [NSMutableArray array];
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(15, 15, 15, 15) itemSpace:10 lineSpace:10 column:2];

        section.header = [FMSupplementaryHeader supplementaryHeight:100 viewClass:[FMCollectionCustomDecoration class]];
        section.header.bottomMargin = 10;
        section.header.type = FMSupplementaryTypeSuspension;
        section.header.inset = UIEdgeInsetsMake(0, -15, 0, -15);

        section.footer = [FMSupplementaryFooter supplementaryHeight:50 viewClass:[FMCollectionCustomDecoration class]];
        section.footer.topMargin = 10;

        section.itemSize = CGSizeMake(100, 100);
        section.itemDatas = [@[@"1", @"2", @"3"] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.shareSections addObject:section];
    }
    {
        FMLayoutFixedSection *section = [FMLayoutFixedSection sectionWithSectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSpace:10 lineSpace:10 column:3];

        section.header = [FMSupplementaryHeader supplementaryHeight:150 viewClass:[FMCollectionCustomDecoration class]];
        section.header.zIndex = FMSupplementaryZIndexFrontOfItem;
        section.header.type = FMSupplementaryTypeFixed;
        section.header.bottomMargin = 10;

        section.isHorizontalCanScroll = YES;
        section.itemSize = CGSizeMake(150, 100);
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", ] mutableCopy];
        section.cellElement = [FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]];
        [self.shareSections addObject:section];
    }
    
    {
        FMLayoutFillSection *section = [[FMLayoutFillSection alloc] init];
        section.itemDatas = [@[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3",] mutableCopy];
        
        section.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        section.cellElements = @[[FMCollectionViewElement elementWithViewClass:[FMCollectionCustomCell class]]];
        [section setDeqCellReturnReuseId:^NSString * _Nonnull(FMLayoutDynamicSection * _Nonnull section, NSInteger index) {
            return [section.cellElements firstObject].reuseIdentifier;
        }];
        [section setSizeBlock:^CGSize(id  _Nonnull section, NSInteger item) {
//            switch (item) {
//                case 0:
//                    return CGSizeMake(414 * 0.5, 414 * 0.5);
//                    break;
//                case 1:
//                    return CGSizeMake(414 * 0.5, 414);
//                    break;
//                case 2:
//                    return CGSizeMake(414 * 0.5, 414 * 0.5);
//                case 3:
//                    return CGSizeMake(414 * 0.25, 414 * 0.5);
//                case 4:
//                    return CGSizeMake(414 * 0.25, 414 * 0.25);
//                case 5:
//                    return CGSizeMake(414 * 0.5, 414 * 0.5);
//                case 10:
//                    return CGSizeMake(414 * 0.25, 414 * 0.25);
//                default:
//                    return CGSizeMake(414 * 0.25, 414 * 0.5);
//            }
            switch (item) {
                case 2:
                    return CGSizeMake(150, 140.32);
                case 5:
                    return CGSizeMake((self.view.frame.size.width-20-150)/2, 70.19);
                case 8:
                case 11:
                    return CGSizeMake(100, 240);
                case 10:
                    return CGSizeMake(self.view.frame.size.width-20-200, 140);
                case 9:
                case 12:
                    return CGSizeMake(self.view.frame.size.width-20-100, 100);
                case 0:
                case 1:
                case 3:
                case 4:
                    return CGSizeMake((self.view.frame.size.width-20-150)/4, 70.13);
                default:
                    return CGSizeMake((self.view.frame.size.width-20-150)/4, 70.19);
            }
        }];
        [self.shareSections addObject:section];
    }
    
    
    FMCollectionLayoutView *view = [[FMCollectionLayoutView alloc] init];
    view.configuration = self;
    view.delegate = self;
    [view.layout setSections:self.shareSections];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.collectionView = view;
}

///配置cell
- (void)layoutView:(FMCollectionLayoutView *)layoutView configurationCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    FMCollectionCustomCell *custom = (FMCollectionCustomCell *)cell;
    custom.label.text = [NSString stringWithFormat:@"%ld", indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FMAddViewController *vc = [[FMAddViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
