package pullpush::Controller::Test;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub test ($self) {

  # Render template "example/welcome.html.ep" with message
  $self->render(text => 'pullpush test page');
}

1;
