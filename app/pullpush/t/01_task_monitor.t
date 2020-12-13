use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('pullpush',
    {   
        secrets     => ['ahChooW7eesh'],
        minion_db   => 'sqlite:t/data/minion.sqlite',
        result_db   => 'sqlite:t/data/result.sqlite',
        state_db    => 'sqlite:t/data/state.sqlite',
    },
    task_base   => 'pullpush::task',
    task        => {
		monitor	=> {
			url	=> '/task/monitor',
			controller	=> 'Task',
			action		=> 'do',
			name		=> 'task_monitor',
			params		=> {
				task_name	=> 'monitor',
			},
		},
	},
);
$t->get_ok('/task/monitor')->status_is(200);

done_testing();
