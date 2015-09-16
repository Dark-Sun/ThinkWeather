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
    [super viewWillAppear: animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SearchTableCell";
    UITableViewCell *cell           = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                             reuseIdentifier: cellIdentifier];
 
    cell.textLabel.text = data[indexPath.row][@"name"];
    
    return cell;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(search) object:nil];
    [self performSelector:@selector(search) withObject:nil afterDelay:.5];
}

- (void) search {
    NSString* query = [self.searchBar text];
    
    if(query.length < 2) {
        data = @[];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
    
    [WeatherModel getWeatherByName: query
                        completion:^(id responseObject) {
        data = responseObject[@"list"];
        [self.searchDisplayController.searchResultsTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateWeatherWithLocation" object: data[indexPath.row]];
    [self.navigationController popViewControllerAnimated: YES];
}

@end
