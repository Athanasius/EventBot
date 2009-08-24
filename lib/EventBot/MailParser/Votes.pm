package EventBot::MailParser::Votes;
use strict;
use warnings;

sub parse {
    my ($class, $subject, $body) = @_;
    my @commands;
    my @lines = split("\n", $body);
    foreach my $line (@lines) {
        # Detect election votes:
        if ($line =~
            /^
            \s*
            I\s+vote\s*:\s*
	    ((?:[a-z](?:\s+[a-z])*\s*)?)
	    $
            /ix
        ) {
            my $vote_data = uc($1);
            my @votes;
            while($vote_data =~ /([A-Z])/g) {
                push @votes, $1;
            }
            warn "Found votes: " . join(', ', @votes) . "\n";
            push(@commands, {
                type => 'vote',
                votes => \@votes,
            });
        }
    }

    return @commands;
}

1;
