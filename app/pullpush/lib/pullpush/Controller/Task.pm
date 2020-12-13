package pullpush::Controller::Task;

use warnings;
use strict;

# use Moose;
# use MooseX::NonMoose;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON qw(decode_json encode_json);

sub status ($self) {
    $self->render(text => sprintf('status of %s has been called', $self->stash('task_name')))
}

sub capabilities ($self) {
    $self->render(text => sprintf('capabilities of %s has been called', $self->stash('task_name')))
}

sub do ($self) {
    my $args = $self->stash('task_args') // {};
    my $job_id = $self->minion->enqueue($self->stash('task_name'), [ $args ]);
    $self->render(text => sprintf('do of %s has been called with args:(%s) resulting in job_id:%s', $self->stash('task_name'), encode_json($args), $job_id), format => 'html');
}

1;
