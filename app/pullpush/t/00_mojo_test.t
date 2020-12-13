use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('pullpush',
    {   
        secrets     => ['ahChooW7eesh'],
        minion_db   => 'sqlite:t/data/minion.sqlite',
        result_db   => 'sqlite:t/data/result.sqlite',
        state_db    => 'sqlite:t/data/state.sqlite',
    }
);
$t->get_ok('/test')->status_is(200)->content_like(qr/pullpush test page/i);

done_testing();
