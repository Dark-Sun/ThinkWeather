//
//  SearchLocationController.m
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "SearchLocationController.h"
#import "WeatherModel.h"

@interface SearchLocationController () {
    NSArray* data;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation SearchLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = @[];
    
    self.searchDisplayController.active = YES;
}

- (void) viewDidAppear: (BOOL)animated {
    [self.searchBar becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchTableCell";
//    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    cell.textLabel.text = data[indexPath.row][@"name"];
    
    return cell;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // to limit network activity, reload half a second after last key press.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(search) object:nil];
    [self performSelector:@selector(search) withObject:nil afterDelay:.5];
}

- (void) search {
    NSLog(@"Search...");
    NSString* query = [self.searchBar text];
    
    if(query.length < 2) {
        data = @[];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
    
    [WeatherModel findByName:query completion:^(id responseObject) {
        data = responseObject[@"list"];
        NSLog(@"success!");
        [self.searchDisplayController.searchResultsTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateWeatherWithLocation" object:data[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
