CREATE TABLE IF NOT EXISTS mag_core.affiliations (
affiliation_id varchar PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
grid_id varchar,
official_page varchar,
wiki_page varchar,
paper_count bigint DEFAULT 0,
citation_count bigint DEFAULT 0,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core.authors (
author_id varchar PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
last_known_affiliation_id varchar,
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core.journals (
journal_id varchar PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
issn varchar,
publisher varchar,
web_page varchar,
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core.conference_series (
conference_series_id varchar PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS mag_core.fields_of_study (
field_of_study_id varchar PRIMARY KEY,
rank bigint CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
main_type varchar,
level integer CHECK (level < 6),
CHECK (level > -1),
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


CREATE TABLE IF NOT EXISTS conference_instances (
conference_instance_id varchar PRIMARY KEY,
normalized_name varchar,
display_name varchar,
conference_series_id varchar REFERENCES mag_core.conference_series(conference_series_id),
location varchar,
official_url varchar,
start_date varchar,
end_date varchar,
abstract_registration_date varchar,
submission_deadline_date varchar,
notification_due_date varchar,
final_version_due_date varchar,
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);



CREATE TABLE IF NOT EXISTS papers (
paper_id varchar PRIMARY KEY,
rank bigint CHECK (rank > 0),
doi varchar,
doc_type varchar,
paper_title varchar,
original_title varchar,
book_title varchar,
year varchar,
date timestamp,
publisher varchar,
journal_id varchar,
conference_series_id varchar,
conference_instance_id varchar,
volume varchar,
issue varchar,
first_name varchar,
last_name varchar,
reference_count bigint,
citation_count bigint,
estimated_citation bigint,
original_venue varchar,
created_date varchar NOT NULL
);



CREATE TABLE IF NOT EXISTS mag_core.paper_resources (
paper_id varchar REFERENCES mag_core.papers(paper_id),
resource_type integer,
resource_url varchar,
source_url varchar,
relationship_type integer
);



CREATE TABLE IF NOT EXISTS mag_core.related_field_of_study (
field_of_study_id1 varchar REFERENCES mag_core.fields_of_study(field_of_study_id),
type1 varchar,
field_of_study_id2 varchar REFERENCES mag_core.fields_of_study(field_of_study_id),
type2 varchar,
rank numeric
);



CREATE TABLE IF NOT EXISTS mag_core.paper_urls (
paper_id varchar REFERENCES mag_core.papers(paper_id),
source_type varchar,
source_url varchar
);



CREATE TABLE IF NOT EXISTS mag_core.paper_abstract_inverted_index (
paper_id varchar REFERENCES mag_core.papers(paper_id),
indexed_abstract varchar
);


CREATE TABLE IF NOT EXISTS mag_core.paper_author_affiliations (
paper_id varchar REFERENCES mag_core.papers(paper_id),
author_id varchar REFERENCES mag_core.authors(author_id),
affiliation_id varchar,
author_sequence_number bigint CHECK (author_sequence_number > 0),
original_affiliation varchar
);



CREATE TABLE IF NOT EXISTS mag_core.paper_citation_contexts (
paper_id varchar REFERENCES mag_core.papers(paper_id),
paper_reference_id varchar REFERENCES mag_core.papers(paper_id),
citation_context varchar
);

CREATE TABLE IF NOT EXISTS mag_core.paper_citation_contexts (
paper_id varchar REFERENCES mag_core.papers(paper_id),
paper_reference_id varchar REFERENCES mag_core.papers(paper_id),
citation_context varchar
);

CREATE TABLE IF NOT EXISTS paper_citation_contexts (
paper_id varchar REFERENCES mag_core.papers(paper_id),
paper_reference_id varchar REFERENCES mag_core.papers(paper_id),
citation_context varchar
);


CREATE TABLE IF NOT EXISTS mag_core.paper_fields_of_study (
paper_id bigint varchar mag_core.papers(paper_id),
field_of_study_id varchar REFERENCES mag_core.fields_of_study(field_of_study_id),
score numeric
);


CREATE TABLE IF NOT EXISTS mag_core.paper_languages (
paper_id varchar REFERENCES mag_core.papers(paper_id),
language_code varchar
);


CREATE TABLE IF NOT EXISTS mag_core.paper_recommendations (
paper_id varchar REFERENCES mag_core.papers(paper_id),
recommended_paper_id varchar REFERENCES mag_core.papers(paper_id),
score numeric
);


CREATE TABLE IF NOT EXISTS mag_core.paper_references (
paper_id varchar REFERENCES mag_core.papers(paper_id),
paper_reference_id varchar REFERENCES mag_core.papers(paper_id)
);



CREATE TABLE IF NOT EXISTS mag_core.fields_of_study_children (
field_of_study_id varchar REFERENCES mag_core.fields_of_study(field_of_study_id),
child_field_of_study_id varchar REFERENCES mag_core.fields_of_study(field_of_study_id)
);


