//
//  CountryListViewController.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListViewController.h"
#import "CountryListDataSource.h"
#import "CountryCell.h"

@interface CountryListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataRows;
@end

@implementation CountryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier=@"tcell";
    CountryCell *cell=(CountryCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell=[[NSBundle mainBundle]loadNibNamed:@"CountryCell" owner:self options:nil][0];

    
    if ([_dataRows count])
    {
        cell.imgFlag.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCode] lowercaseString]]];
        cell.lblname.text=[NSString stringWithFormat:@"%@",[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryName]];
        cell.lblCountrycode.text=[NSString stringWithFormat:@"%@",[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCode]];
        cell.lblphonecode.text=[NSString stringWithFormat:@"%@",[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode]];

    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)done:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectCountry:)]) {
        [self.delegate didSelectCountry:[_dataRows objectAtIndex:[_tableView indexPathForSelectedRow].row]];
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        NSLog(@"CountryListView Delegate : didSelectCountry not implemented");
    }
}

@end
