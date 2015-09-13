#import "ToDoViewController.h"

#import "TodoTableView.h"

@interface ToDoViewController ()

@property (nonatomic, strong) TodoTableView *todoTable;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.todoTable == nil) {
		self.todoTable = [[TodoTableView alloc] initWithFrame:self.viewTodoTable.bounds];
		[self.viewTodoTable addSubview:self.todoTable];
	}
	
	if (self.todoItem == nil) {
		self.todoTable.data = [NSMutableArray array];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onAddItem:(id)sender {
	[self.todoTable insertRowAtEnd];
}

- (IBAction)onSave:(id)sender {
}

- (IBAction)onCancel:(id)sender {
}

- (IBAction)onSaveItem:(id)sender {
}
@end
