# vim: sw=4 sts=4 et tw=75 wm=5
package EventBot::Schema::Votes;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('votes');
__PACKAGE__->add_columns(
    election => { data_type => "INTEGER", is_nullable => 0 },
    person => { data_type => "INTEGER", is_nullable => 0 },
    pub => { data_type => 'INTEGER', is_nullable => 0 },
);
__PACKAGE__->set_primary_key(qw(election person pub));

__PACKAGE__->belongs_to(
    election => 'EventBot::Schema::Elections'
);
__PACKAGE__->belongs_to(
    person => 'EventBot::Schema::People'
);
__PACKAGE__->belongs_to(
    pub => 'EventBot::Schema::Pubs'
);

1;
