package pullpush::task::http;

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
use Mojo::UserAgent;
has ua      => (
    isa     => 'Mojo::UserAgent',
    is      => 'rw',
    default => sub { Mojo::UserAgent->new() }
);


sub register {
	my ($self, $app) = @_;
    # $self->{json} = JSON->new();
	my $method = 'http';
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
	my $result = {
    };
    return $result;
}

1;
