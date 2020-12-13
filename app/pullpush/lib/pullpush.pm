package pullpush;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

    # Load configuration from config file
    # XXX use Mojo::File
    # XXX use $moniker $mode $user
    my $config = $self->plugin(Config => {file => 'conf/pullpush.default.conf'});

    # Configure the application
    $self->secrets($config->{secrets});

    # Router
    my $r = $self->routes;

    # Normal route to controller
    # $r->get('/')->to('example#welcome');
    use Mojo::SQLite;
    # XXX use Mojo::File
    $self->plugin(Minion => { SQLite => Mojo::SQLite->new($config->{minion_db}) });
    # $self->plugin('Minion::Admin');
    foreach my $a_task (keys %{$config->{task}}) { 
        my $task_lib = sprintf('%s::%s',  $config->{task_base}, $a_task);
        # XXX task != worker?
        $self->app->log->debug(sprintf('loading task %s', $task_lib));
        $self->plugin($task_lib);

#         # routing default methods
#         my $method = 'capabilities';
#         $r->get(sprintf('/task/%s/%s', $a_task, $method)   )
#             ->to( controller => 'Task', action => $method,  task_name => $a_task )
#             ->name(sprintf('task_%s_%s', $a_task, $method));
#         $method = 'status';
#         $r->get(sprintf('/task/%s/%s', $a_task, $method)   )
#             ->to( controller => 'Task', action => $method,  task_name => $a_task )
#             ->name(sprintf('task_%s_%s', $a_task, $method));
#         $method = 'do';
#         $r->get(sprintf('/task/%s/%s/:ioc', $a_task, $method)   )
#             ->to( controller => 'Task', action => $method,  task_name => $a_task )
#             ->name(sprintf('task_%s_%s', $a_task, $method));
        $r->get($config->{task}{$a_task}{url})
            ->to( controller => $config->{task}{$a_task}{controller},
                  action     => $config->{task}{$a_task}{action},
                  %{ $config->{task}{$a_task}{params} } )
            ->name(sprintf('task_%s_%s', $a_task, $config->{task}{$a_task}{action}));

    }
    # test method used in development
    # XXX only in dev mode
    my $method = 'test';
    $r->get('test')
        ->to( controller => 'Test', action => $method )
        ->name(sprintf('%s', $method));

    $r->post('result/:job_id')
        ->to( controller => 'Result', action => 'set')
        ->name('result_set');
}

1;
