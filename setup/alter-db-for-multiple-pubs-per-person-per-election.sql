-- Alter the votes table to include a unique per-vote ID
-- This is intended to be used as in an ORDER BY clause
-- of SQL queries on the votes table.
--
-- Thus if someone Pe votes on an election E for pubs 'A D B C E'
-- then the following rows are created:
--
-- election person pub id
-- E        Pe     A   x
-- E        Pe     D   x+1
-- E        Pe     B   x+2
-- E        Pe     C   x+3
-- E        Pe     E   x+4
--
-- and thus Pe's preference order for the pubs is preserved.
--
-- As the only intent of this column is use in ORDER BY there
-- seems no reason to alter the table's PRIMARY KEY definition.
--
-- Also note that before this alteration only one vote per person per
-- pub can be recorded anyway, and indeed that tuple is the PRIMARY KEY
-- on the table and thus unique, so we don't need to be careful about
-- assigning different IDs to multiple instances of the same tuple.
--

-- Create the id, we can't constraint it to NULL yet as the extant rows
-- have no values for the column.
ALTER TABLE votes ADD COLUMN id integer;
-- Create the SEQUENCE and associate it with the COLUMN
CREATE SEQUENCE votes_id_seq;
ALTER SEQUENCE votes_id_seq OWNED BY votes.id;
ALTER TABLE votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);
-- Now use the SEQUENCE to assign values to the extant rows
UPDATE votes SET id = nextval('votes_id_seq');
-- And finally clean things up by now specifying the new column is NOT NILL
ALTER TABLE votes ALTER COLUMN id SET NOT NULL;

-- This view is a way to get at voters per election without considering
-- all their votes, and without having too much of a 'flag day' on the
-- database structure.
CREATE VIEW voters AS SELECT DISTINCT elections.id as election_id, people.id as person_id FROM elections,people,votes WHERE votes.election = elections.id AND people.id = votes.person;
