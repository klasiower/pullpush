package pullpush::Controller::Task;

use warnings;
use strict;

# use Moose;
# use MooseX::NonMoose;
use Mojo::Base 'Mojolicious::Controller', -strict, -signatures;
use Mojo::JSON qw(decode_json encode_json);

sub status ($self) {
    $self->render(text => sprintf('status of:%s has been called', $self->stash('task_name')))
}

sub capabilities ($self) {
    $self->render(text => sprintf('capabilities of:%s has been called', $self->stash('task_name')))
}

sub do ($self) {
    my $args = $self->stash('task_args') // {};
    # $self->app->log->debug(sprintf('enqueuing task_name:%s task_args:%s', $self->stash('task_name'), to_json($args)));
    # $self->app->log->debug(sprintf('enqueuing task_name:%s', $self->stash('task_name')));
    my $job_id = $self->minion->enqueue($self->stash('task_name'), [ $args ]);
    $self->app->log->debug(sprintf('enqueuing task_name:%s job_id:%s', $self->stash('task_name'), $job_id));

	my $polling_interval = 1;
    # my $result = $self->minion->job($job_id)->info->{result};
	$self->minion->result_p($job_id, {interval => $polling_interval })->timeout(3)->then(sub {
		my ($info) = @_;
		my $result = ref $info ? $info->{result} : 'Job already removed';
		say "Finished: ".encode_json($result);
		my $job_status = $self->minion->job($job_id)->info();
		$self->render(
			text => sprintf('do of:%s has been called with args:(%s) job_id:%s status:(%s) result:(%s)',
				$self->stash('task_name'),
				encode_json($args),
				$job_id,
				encode_json($job_status),
				encode_json($result)
			),
			format => 'html'
	   );
	})->catch(sub {
		my ($info) = @_;
# Unhandled rejected promise: Can't use string ("Promise timeout") as a HASH ref while "strict refs" in use at /home/dst/scripts/TMP/pullpush/app/pullpush/lib/pullpush/Controller/Task.pm line 45. at /home/dst/perl5/lib/perl5/Mojo/Reactor/Poll.pm line 131.
	  	say "Failed: ".(ref $info ? $info->{result} : $info);
    	# $self->app->log->debug(sprintf('enqueuing task_name:%s job_id:%s', $self->stash('task_name'), $job_id));
		$self->render(
			text => sprintf('promise failed, task_name:%s job_id:%s result:%s',
				$self->stash('task_name'),
				$job_id,
	  			(ref $info ? $info->{result} : $info),
			),
			format => 'html'
	   )
	})->wait;

}

1;
