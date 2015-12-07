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

@interface MultiSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *selectedValue;
@property (nonatomic) NSArray *selections;
@property (nonatomic) NSString *questionTitle;

@end

@implementation MultiSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    cell.checkImageView.hidden = ![title isEqualToString:self.selectedValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedValue = [self.selections objectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (IBAction)onNextButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mutliSelectionViewControllerDidSelect:value:)]) {
        [self.delegate mutliSelectionViewControllerDidSelect:self value:self.selectedValue];
    }
}


@end
