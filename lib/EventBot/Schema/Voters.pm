package EventBot::Schema::Voters;
use strict;
use warnings;
use parent 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));
__PACKAGE__->table('voters');
__PACKAGE__->add_columns(
    election_id => { data_type => "INTEGER", is_nullable => 0 },
    person_id => { data_type => "INTEGER", is_nullable => 0 },
);
__PACKAGE__->set_primary_key(qw(election_id person_id));

__PACKAGE__->belongs_to(
    'election_id',
    'EventBot::Schema::Elections',
    { 'foreign.id' => 'self.election_id' }
);
__PACKAGE__->has_one(
    'person_id',
    'EventBot::Schema::People',
    { 'foreign.id' => 'self.person_id' }
);
__PACKAGE__->has_many(
    'votes',
    'EventBot::Schema::Votes',
    { 'foreign.person' => 'self.person_id',
      'foreign.election' => 'self.election_id'
    }
);

1;
