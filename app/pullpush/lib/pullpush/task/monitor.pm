package pullpush::task::monitor;

use Moose;
use MooseX::NonMoose;
extends 'pullpush::task::generic';
# use Mojo::Base 'Mojolicious::Plugin' -strict, -signatures;
use Mojo::JSON qw(decode_json encode_json);
# use Moose;
# use MooseX::NonMoose;
# extends 'pullpush::task::generic';
# 
# use JSON;
# has json    => (
#     isa     => 'JSON',
#     is      => 'rw',
#     default => sub { JSON->new() }
# );
# 
# use Mojo::UserAgent;
# has ua      => (
#     isa     => 'Mojo::UserAgent',
#     is      => 'rw',
#     default => sub { Mojo::UserAgent->new() }
# );

use Sys::CpuLoad;

sub register {
	my ($self, $app) = @_;
    # $self->{json} = JSON->new();
	my $method = 'monitor';
	$app->log->debug(sprintf('registering %s', $method));
	$app->minion->add_task($method => sub {
    	my ($job, $args) = @_;
                
 		my $result = $self->do($job);
#         my $tx = $self->ua->post(sprintf('http://localhost:3000/result/%s', $job->id),
#             json => $result
#         );
# 		$job->app->log->debug(sprintf('[%s][%s] callback response:%s result:%s', $method, $job->id, $tx->res->code, $self->json->encode($result)));
		$job->app->log->debug(sprintf('[%s][%s] result:%s', $method, $job->id, encode_json($result)));
    	$job->finish($result);
	});
}

sub do{
	my ($self, $job) = @_;
    my $load = [Sys::CpuLoad::load];
	my $result = {
        load    => {
            1   => $load->[0],
            5   => $load->[1],
            15  => $load->[2],
        },
        # uptime  => Sys::CpuLoad::uptime(),
    };
    return $result;
}

1;
