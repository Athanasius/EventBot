package EventBot::WWW::C::Manage::Event;
use strict;
use warnings;
use parent 'Catalyst::Controller';

# This module should contain methods to create a one-off event for eventbot,
# which dispatches a confirmation email, and after that immediately submits the
# event.

sub event : Chained('/manage/manage_base') PathPart CaptureArgs(0) {
    my ($self, $c) = @_;
    # base event creation..
}

sub create :Chained('event') PathPart Args(0) {
    my ($self, $c) = @_;
    $c->stash->{nominees} = $c->model('DB::People')->search(
        {},
        { order_by => 'name' }
    );
    $c->stash->{venues} = $c->model('DB::Pubs')->search(
        {},
        { order_by => 'name' }
    );
    return unless $c->request->method =~ /^POST/i;

    eval {
        my $date = EventBot::Utils->figure_date($c->request->params->{date})
            or die("Invalid date\n");

        my $nom = $c->model('DB::People')->find($c->request->params->{nominee})
            or die("Unknown nominee\n");

#        my $pub = $c->model('DB::Pubs')->find($c->request->params->{venue})
#            or die("Unknown pub\n");

        my $comment = $c->request->params->{comment};
        $comment =~ s/</&lt;/g;
        $comment =~ s/>/&gt;/g;
        die("Comment too long!\n") if length($comment) > 250;

        $c->stash->{event} = $c->model('DB::Events')->create(
            {
                confirmed => 0,
                date => $date,
                comment => $comment,
                starttime => $starttime,
                place => $address,
                # XXX etc
            }
        );
        $c->stash->{confirm} = $c->model('DB::Confirmations')->create(
            {
                person => $nom->id,
                object_type => 'Events',
                object_id => $c->stash->{event}->id,
                action => 'create'
            }
        );
        $c->stash->{confirm}->random_code;

        $c->forward('send_confirmation');
    };
    if ($@) {
        $c->log->error("Failed to create event: $@");
        $c->stash->{message} = $@;
    }
    else {
        $c->stash->{template} = 'manage/event/created.tt';
    }
}

1;
