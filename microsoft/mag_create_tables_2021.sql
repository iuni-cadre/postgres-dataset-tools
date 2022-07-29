CREATE TABLE IF NOT EXISTS mag_core_21.affiliations (
affiliation_id bigint PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
grid_id varchar,
official_page varchar,
wiki_page varchar,
paper_count bigint DEFAULT 0,
paper_family_count bigint DEFAULT 0,
citation_count bigint DEFAULT 0,
iso3166_code varchar,
created_date varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS mag_core_21.authors (
author_id bigint PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
last_known_affiliation_id bigint,
paper_count bigint,
paper_family_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core_21.journals (
journal_id bigint PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
issn varchar,
publisher varchar,
web_page varchar,
paper_count bigint,
paper_family_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core_21.conference_series (
conference_series_id bigint PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
paper_count bigint,
paper_family_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core_21.fields_of_study (
field_of_study_id bigint PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
main_type varchar,
level integer CHECK (level < 6),
CHECK (level > -1),
paper_count bigint,
paper_family_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core_21.conference_instances (
conference_instance_id bigint PRIMARY KEY,
normalized_name varchar,
display_name varchar,
conference_series_id bigint REFERENCES mag_core_21.conference_series(conference_series_id),
location varchar,
official_url varchar,
start_date varchar,
end_date varchar,
abstract_registration_date varchar,
submission_deadline_date varchar,
notification_due_date varchar,
final_version_due_date varchar,
paper_count bigint,
paper_family_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core_21.papers (
paper_id bigint PRIMARY KEY,
rank bigint CHECK (rank > 0),
doi varchar,
doc_type varchar,
paper_title varchar,
original_title varchar,
book_title varchar,
year int,
date timestamp,
publisher varchar,
journal_id bigint,
conference_series_id bigint,
conference_instance_id bigint,
volume varchar,
issue varchar,
first_page varchar,
last_page varchar,
reference_count bigint,
citation_count bigint,
estimated_citation bigint,
original_venue varchar,
family_id bigint,
family_rank bigint,
created_date varchar NOT NULL
);



CREATE TABLE IF NOT EXISTS mag_core_21.paper_resources (
paper_id bigint REFERENCES mag_core_21.papers(paper_id),
resource_type integer,
resource_url varchar,
source_url varchar,
relationship_type integer
);



CREATE TABLE IF NOT EXISTS mag_core_21.related_field_of_study (
field_of_study_id1 bigint REFERENCES mag_core_21.fields_of_study(field_of_study_id),
type1 varchar,
field_of_study_id2 bigint REFERENCES mag_core_21.fields_of_study(field_of_study_id),
type2 varchar,
rank numeric
);



CREATE TABLE IF NOT EXISTS mag_core_21.paper_urls (
paper_id bigint REFERENCES mag_core_21.papers(paper_id),
source_type integer,
source_url varchar,
language_code varchar
);



CREATE TABLE IF NOT EXISTS mag_core_21.paper_abstract_inverted_index (
paper_id bigint REFERENCES mag_core_21.papers(paper_id),
indexed_abstract varchar
);


CREATE TABLE IF NOT EXISTS mag_core_21.paper_author_affiliations (
paper_id bigint REFERENCES mag_core_21.papers(paper_id),
author_id bigint REFERENCES mag_core_21.authors(author_id),
affiliation_id bigint,
author_sequence_number bigint CHECK (author_sequence_number > 0),
original_affiliation varchar
);


CREATE TABLE IF NOT EXISTS mag_core_21.paper_citation_contexts (
paper_id bigint REFERENCES mag_core_21.papers(paper_id),
paper_reference_id bigint REFERENCES mag_core_21.papers(paper_id),
citation_context varchar
);


CREATE TABLE IF NOT EXISTS mag_core_21.paper_fields_of_study (
paper_id bigint mag_core_21.papers(paper_id),
field_of_study_id bigint REFERENCES mag_core_21.fields_of_study(field_of_study_id),
score numeric
);


--CREATE TABLE IF NOT EXISTS mag_core.paper_languages (
--paper_id varchar REFERENCES mag_core.papers(paper_id),
--language_code varchar
--);


CREATE TABLE IF NOT EXISTS mag_core_21.paper_recommendations (
paper_id bigint REFERENCES mag_core_21.papers(paper_id),
recommended_paper_id bigint REFERENCES mag_core_21.papers(paper_id),
score numeric
);


CREATE TABLE IF NOT EXISTS mag_core_21.paper_references (
paper_id bigint REFERENCES mag_core_21.papers(paper_id),
paper_reference_id bigint REFERENCES mag_core_21.papers(paper_id)
);



CREATE TABLE IF NOT EXISTS mag_core_21.field_of_study_children (
field_of_study_id bigint REFERENCES mag_core_21.fields_of_study(field_of_study_id),
child_field_of_study_id bigint REFERENCES mag_core_21.fields_of_study(field_of_study_id)
);


