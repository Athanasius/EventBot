package EventBot::WWW::C::Event;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

EventBot::WWW::C::Event - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

#sub index : Private {
#    my ( $self, $c ) = @_;
#
#    $c->response->body('Matched EventBot::WWW::C::Event in Event.');
#}

=head2 list

list all events

=cut

sub list :Local {
    my ($self, $c) = @_;

    my $events = $c->model('DB::Events')->search({}, { order_by => 'startdate' });
    $c->stash->{events} = $events;
}

=head view

view this event's details

=cut

sub view :Local {
    my ($self, $c, $id) = @_;

    my $event = $c->model('DB::Events')->find($id);
    $c->stash->{event} = $event;
}


=head1 AUTHOR

Toby Corkindale

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
