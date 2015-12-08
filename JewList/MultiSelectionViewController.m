//
//  MultiSelectionViewController.m
//  JewList
//
//  Created by Oren Zitoun on 12/6/15.
//  Copyright © 2015 Oren Zitoun. All rights reserved.
//

#import "MultiSelectionViewController.h"
#import "MultiSelectionCell.h"
#import "MultiSelectionHelpers.h"
#import "SHUIHelpers.h"

@interface MultiSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *questionContainerView;
@property (nonatomic) NSString *selectedValue;
@property (nonatomic) NSArray *selections;
@property (nonatomic) NSString *questionTitle;
@property (nonatomic) BOOL supportsMultiSelection;
@property (nonatomic) NSMutableDictionary *selectedKeys;
@end

@implementation MultiSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.supportsMultiSelection = [MultiSelectionHelpers supportsMultiSelectionForType:self.type];
    if (self.supportsMultiSelection) {
        self.selectedKeys = [NSMutableDictionary dictionary];
    }
    self.questionTitleLabel.text = [MultiSelectionHelpers questionTitleForType:self.type];
    self.selections = [MultiSelectionHelpers optionsForType:self.type];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MultiSelectionCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MultiSelectionCell.class)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MultiSelectionCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MultiSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MultiSelectionCell class])];
    NSString *title = [self.selections objectAtIndex:indexPath.row];
    cell.titleLabel.text = title;
    if (self.supportsMultiSelection) {
        cell.checkImageView.hidden = self.selectedKeys[title] ? NO : YES;
    } else {
        cell.checkImageView.hidden = ![title isEqualToString:self.selectedValue];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *value = [self.selections objectAtIndex:indexPath.row];
    
    if (self.supportsMultiSelection) {
        if (self.selectedKeys[value]) {
            [self.selectedKeys removeObjectForKey:value];
        } else {
            self.selectedKeys[value] = @(YES);
        }
    } else {
        self.selectedValue = value;
    }
    
    [self.tableView reloadData];
}

- (IBAction)onNextButtonPressed:(id)sender {
    if (self.supportsMultiSelection) {
        self.selectedValue = [self multiSelectionResultValue];
    }
    
    if ([self.delegate respondsToSelector:@selector(mutliSelectionViewControllerDidSelect:value:)]) {
        [self.delegate mutliSelectionViewControllerDidSelect:self value:self.selectedValue];
    }
}

- (NSString *)multiSelectionResultValue {
    if (self.selectedKeys.allKeys.count == 0) return @"";
    NSString *result = [self.selectedKeys.allKeys componentsJoinedByString:@", "];
    return result;
}

@end
