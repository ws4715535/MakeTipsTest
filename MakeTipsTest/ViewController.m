//
//  ViewController.m
//  MakeTipsTest
//
//  Created by ws on 16/9/8.
//  Copyright © 2016年 ws. All rights reserved.
//

#import "ViewController.h"
#import "TipFooterView.h"
#import "TipHeaderView.h"
#import "NSObject+AlbumAdd.h"
#import "TipImgeCell.h"
#import "TipLabelCell.h"

typedef NS_ENUM(NSUInteger, TipCellType) {
    NormalCell = 0,
    TextCell,
    ImageCell
};


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>


@property (strong, nonatomic) NSMutableArray *m_datas;
@property (strong, nonatomic) NSMutableDictionary *m_mdicHeight;
@property (weak, nonatomic) UITableView *m_tableView;
@property (weak, nonatomic) TipHeaderView *m_headerView;
@property (weak, nonatomic) TipFooterView *m_footerView;
@property (assign, nonatomic) CGFloat m_offsetY;
@property (weak, nonatomic) UIView *m_locationView;
@property (strong, nonatomic) NSMutableArray *m_marrayParam;
@property (strong, nonatomic) NSMutableDictionary *m_mdicTemp;

@end

@implementation ViewController

static NSString *sCellIdentifier = @"sCellIdentifier";
static NSString *sImageCell = @"imageCell";
static NSString *sTextviewCell = @"textviewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init tableView
    [self initTableView];
    
    // config footer and Header
    [self configHeaderAndFooter];
    
    // config notification
    
    [self configNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void)initTableView {
    // add tableView and init
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.m_tableView = tableView;
    [self.view addSubview:self.m_tableView];
    
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
    self.m_tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);

    // registser
    [self.m_tableView registerNib:[UINib nibWithNibName:@"TipImgeCell" bundle:nil] forCellReuseIdentifier:sImageCell];
    [self.m_tableView registerNib:[UINib nibWithNibName:@"TipLabelCell" bundle:nil] forCellReuseIdentifier:sTextviewCell];
    
    
    
    // add longPress to tableView
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.m_tableView addGestureRecognizer:longPress];
    

}

#pragma mark - configHeaderAndFooter

- (void)configHeaderAndFooter {
    
    // add header
    TipHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TipHeaderView class]) owner:nil options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 520);
    // header action
    [headerView.m_addHeaderBtn addTarget:self action:@selector(addHeaderImage) forControlEvents:UIControlEventTouchUpInside];
    self.m_headerView.m_headerImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.m_headerView = headerView;
    self.m_tableView.tableHeaderView = headerView;
    
    // add footer
    TipFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TipFooterView class]) owner:nil options:nil] lastObject];
    
    // add footer Action
    [footerView.m_addTipBtn addTarget:self action:@selector(addTipClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView.m_textBtn addTarget:self action:@selector(addTextClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView.m_imgBtn addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
    footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 155);
    self.m_footerView = footerView;
    self.m_tableView.tableFooterView = self.m_footerView;
    
    
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
    UIButton *locationBtn = [[UIButton alloc] initWithFrame:locationView.bounds];
    [locationView addSubview:locationBtn];
    [locationBtn setBackgroundColor:[UIColor darkGrayColor]];
    [locationBtn setTitle:@"雕刻时光咖啡师大店" forState:UIControlStateNormal];
    [locationBtn setFont:[UIFont systemFontOfSize:14]];
    [locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.m_locationView = locationView;
    [self.view addSubview:locationView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.m_datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TipLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:sTextviewCell];
    if ([self.m_datas[indexPath.row] isKindOfClass:[NSString class]]) {

        cell.m_textView.index = indexPath.row;
        cell.m_textView.delegate = self;
        cell.m_textView.text = @"cell";
        return cell;
    }else {
        TipImgeCell *imageCell = [tableView dequeueReusableCellWithIdentifier:sImageCell];
        [imageCell.m_deleBtn setTag:indexPath.row];
        [imageCell.m_deleBtn addTarget:self action:@selector(deleImage:) forControlEvents:UIControlEventTouchUpInside];
        imageCell.m_imageV.image = self.m_datas[indexPath.row];
        return imageCell;
    }
    
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.m_datas[indexPath.row] isKindOfClass:[NSString class]]) {
        if (self.m_mdicHeight[@(indexPath.row)] == nil) {
            CGFloat fHeight = 120;//-- computed height
            [self.m_mdicHeight setObject:@(fHeight) forKey:@(indexPath.row)];
            return fHeight;
        } else {
            return [self.m_mdicHeight[@(indexPath.row)] floatValue];
        }

    } else {
        return 375;
    }

}


//- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    //	Uncomment these lines to enable moving a row just within it's current section
//    //	if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
//    //		proposedDestinationIndexPath = sourceIndexPath;
//    //	}
//    
//    return proposedDestinationIndexPath;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   self.m_offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >self.m_offsetY ) {//向上滑动
        //按钮消失
        
        [UIView animateWithDuration:0.1 animations:^{
            
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];

    }else if (scrollView.contentOffset.y < self.m_offsetY ){//向下滑动
        //按钮出现
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];

        }];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
//    [self.m_tableView endEditing:YES];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);

    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y>0) {
        //按钮消失
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }];
    }else if(translation.y<0){
        //按钮出现
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }];
    }

}

#pragma mark - UITextViewDelegate 


- (void)textViewDidChange:(WSTextView *)textView {
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    NSLog(@"%@", textView.superview);
    NSLog(@"input input ");
    if (textView.index < 0) {
        return;
    }
    [self.m_mdicHeight setValue:@(size.height + 20) forKey:@(textView.index)];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textView.index inSection:0];
//    [self.m_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.m_tableView beginUpdates];
    [self.m_tableView endUpdates];
    [self.m_mdicHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"key:%@ - value:%@", key,obj);
    }];
    NSLog(@"DIC = %@", indexPath);
}



#pragma mark - pick image

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.m_datas addObject:image];
    
    [self dismissViewControllerAnimated:YES completion:^{
      [self InsertItemAndScrollTableViewToBottom];
    }];
}
#pragma mark -Private Method

- (void)addHeaderImage {
    
    self.m_headerView.m_headerImageV.image = [UIImage imageNamed:@"warp_4"];
    
    
}
- (void)addTipClick {
    
    NSLog(@"添加标签");
    
    
}

-(void)addTextClick {
    
    [self.m_datas addObject:@"123"];
    [self InsertItemAndScrollTableViewToBottom];
    
    TipLabelCell *cell = [[self.m_tableView visibleCells] lastObject];
    // turn off When test!
//    [cell.m_textView becomeFirstResponder];
}


- (void)addImageClick {
    
    [NSObject addAlumByController:self indexPath:nil];
    
    
}

- (void)deleImage:(UIButton *)button {
    
    [self RemoveItemsAndScrollToBottom:button.tag];
    
    
}

- (void)InsertItemAndScrollTableViewToBottom {
    if (self.m_datas.count == 0) {
        return;
    }
    
    NSUInteger row = [self.m_datas  count] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.m_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.m_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.m_datas.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)RemoveItemsAndScrollToBottom:(NSInteger)index {
    if (self.m_datas.count == 0) {
        return;
    }
    NSLog(@"删除前还有%lu个row",self.m_datas.count);
    [self.m_datas removeObjectAtIndex:index];
    NSLog(@"删除后还有%lu个row",self.m_datas.count);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.m_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self.m_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//    [self.m_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.m_datas.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 获取任意一个位置的cell类型
- (TipCellType)cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    TipCellType type = NormalCell;
    if ( [[self.m_tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TipImgeCell class]]) {
        type = ImageCell;
    }
    if ([[self.m_tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[TipLabelCell class]]) {
        type = TextCell;
    }
    return type;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.m_tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeNone;

}

#pragma mark - Button Action
- (void)locationBtnClick {
    NSLog(@"location click...");
}

- (IBAction)makeNote:(id)sender {
//    self.m_mdicTemp = tempDic;
    
    for (NSUInteger i = 0; i < self.m_datas.count; i ++) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        NSIndexPath *indexpatch = [NSIndexPath indexPathForRow:i inSection:0];
        TipCellType cellType = [self cellTypeAtIndexPath:indexpatch];
        if (cellType == TextCell) {
            TipLabelCell *textCell = [self.m_tableView cellForRowAtIndexPath:indexpatch];
            NSString *string_value = textCell.m_textView.text;
            [tempDic setValue:@"2" forKey:@"type"];   // 1图 2文
            [tempDic setValue:string_value forKey:@"value"];  // 1,url 2,text
            [tempDic setValue:@(i) forKey:@"order"];
            [self.m_marrayParam addObject:tempDic];
            continue;
        }
        
        else if (cellType == ImageCell) {
            TipImgeCell *imageCell = [self.m_tableView cellForRowAtIndexPath:indexpatch];
            [tempDic setValue:@"1" forKey:@"type"];   // 1图 2文
            [tempDic setValue:@"这是图片" forKey:@"value"];  // 1,url 2,text
            [tempDic setValue:@(i) forKey:@"order"];
            [self.m_marrayParam addObject:tempDic];

        }
        
        NSLog(@"%@",self.m_marrayParam);
    }
    
//    [self.m_datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@ << %lu",obj , idx);
//        NSIndexPath *indexpatch = [NSIndexPath indexPathForRow:idx inSection:0];
//        TipCellType cellType = [self cellTypeAtIndexPath:indexpatch];
//        if (cellType == TextCell) {
//            TipLabelCell *textCell = [self.m_tableView cellForRowAtIndexPath:indexpatch];
//            NSString *string_value = textCell.m_textView.text;
//            [tempDic setValue:@"2" forKey:@"type"];   // 1图 2文
//            [tempDic setValue:string_value forKey:@"value"];  // 1,url 2,text
//        }
//        
//        else if (cellType == ImageCell) {
//            TipImgeCell *imageCell = [self.m_tableView cellForRowAtIndexPath:indexpatch];
//            [tempDic setValue:@"1" forKey:@"type"];   // 1图 2文
//            [tempDic setValue:@"这是图片" forKey:@"value"];  // 1,url 2,text
//        }
//        
//        [tempDic setValue:@(idx) forKey:@"order"];
//        [self.m_marrayParam addObject:tempDic];
//    }];
//    
    NSLog(@"%@",self.m_marrayParam);
}




#pragma mark - Gesture Method
- (void)longPress:(id)longPressGesture {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)longPressGesture;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                
                UITableViewCell *cell = [self.m_tableView cellForRowAtIndexPath:indexPath];
                
                switch ([self cellTypeAtIndexPath:indexPath]) {
                    case TextCell:
                        cell = (TipLabelCell *)cell;
                        break;
                    case ImageCell:
                        cell = (TipImgeCell *)cell;
                        break;
                    default:
                        break;
                }
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.m_tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.m_datas exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.m_tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.m_tableView cellForRowAtIndexPath:sourceIndexPath];
            
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}





#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


#pragma mark - Notification Method

- (void)configNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTextView:) name:TextViewRemovedNotification object:nil];
    
    
}


- (void)removeTextView:(NSNotification *)notification {
    NSInteger index_row  = [[notification.userInfo valueForKey:@"info"] integerValue];
    [self RemoveItemsAndScrollToBottom:index_row];
    [self.m_mdicHeight removeObjectForKey:[notification.userInfo valueForKey:@"info"]];

    // 调整高度缓存中key的位置
    [self.m_mdicHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"Enumrate:%@-%@",key,obj);
    }];
    
    [self.m_tableView reloadData];
}

#pragma mark - LazyLoad




- (NSMutableArray *)m_datas {
    if (!_m_datas) {
        _m_datas = [NSMutableArray array];
    }
    return _m_datas;
}


- (NSMutableDictionary *)m_mdicHeight {
    if (!_m_mdicHeight) {
        _m_mdicHeight = [NSMutableDictionary dictionary];
    }
    return _m_mdicHeight;
}


- (NSMutableArray *)m_marrayParam {
    
    if (!_m_marrayParam) {
        _m_marrayParam = [NSMutableArray array];
    }
    return _m_marrayParam;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TextViewRemovedNotification object:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
@end
