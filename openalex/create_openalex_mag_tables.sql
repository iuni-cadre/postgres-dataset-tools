-- This SQL script creates the tables to hold OpenAlex
-- data that is stored in backwards compatible MAG format.

-- Reminders:
-- Add FOREIGN KEY REFERENCES, they are missing here for some reason.
--
-- Investigate how Family and PaperUrls.version is
-- used to associate preprints with published versions

----

-- Modifications:
-- changed affiliation_id to bigint
--
-- rank is no longer being updated by OpenAlex.
--
-- changed rank type to integer
--
-- Additions:
-- ror_id replaces grid_id and grid_id is
-- no longer updated by OpenAlex.
-- Users should read the GRID-to-ROR transition FAQ:
-- https://ror.readme.io/docs/gridror-transition-faq
--
-- Added iso3166_code
-- 
-- 
CREATE TABLE IF NOT EXISTS oamag_core.affiliations (
affiliation_id bigint PRIMARY KEY,
rank integer CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
grid_id varchar,
ror_id varchar,
official_page varchar,
wiki_page varchar,
paper_count bigint DEFAULT 0,
citation_count bigint DEFAULT 0,
iso3166_code varchar,
created_date varchar NOT NULL
);


-- Modifications:
-- changed author_id type to bigint
--
-- rank is no longer updated by OpenAlex
--
-- changed rank type to integer
--
-- changed last_known_affiliation_id to bigint
--
-- Additions:
-- added reference to affiliations.affiliation_id
--
-- Added orcid
--
CREATE TABLE IF NOT EXISTS oamag_core.authors (
author_id bigint PRIMARY KEY,
rank integer CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
orcid varchar,
last_known_affiliation_id bigint REFERENCES oamag_core.affiliations(affiliation_id),
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);


-- Modifications:
-- changed journal_id type to bigint
--
-- rank is no longer updated by OpenAlex
--
-- changed rank type to integer
--
-- Updates:
-- issn is now using the ISSN-L
--
-- Additions:
-- issns is a list of all ISSN for all mediums of publication
--
-- is_oa is a field for indicating open access
--
-- is_in_doaj is the paper in the doaj collection of open-access
-- journals
CREATE TABLE IF NOT EXISTS oamag_core.journals (
journal_id bigint PRIMARY KEY,
rank integer CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
issn varchar,
issns varchar,
is_oa boolean,
is_in_doaj boolean,
publisher varchar,
web_page varchar,
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);

-- NOTE: ConferenceSeries is frozen and no longer update by
-- OpenAlex.
-- Modifications:
-- changed conference_series_id type to bigint
--
-- rank is no longer updated by OpenAlex
CREATE TABLE IF NOT EXISTS oamag_core.conference_series (
conference_series_id bigint PRIMARY KEY,
rank integer CHECK (rank > 0),
normalized_name varchar,
display_name varchar,
paper_count bigint,
citation_count bigint,
created_date varchar NOT NULL
);

-- Modifications:
-- changed field_of_study_id type to bigint
--
-- rank is no longer updated by OpenAlex
CREATE TABLE IF NOT EXISTS oamag_core.fields_of_study (
field_of_study_id bigint PRIMARY KEY,
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


-- Modifications:
-- changed conference_instance_id type to bigint
--
-- changed conference_series_id type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.conference_instances (
conference_instance_id bigint PRIMARY KEY,
normalized_name varchar,
display_name varchar,
conference_series_id bigint REFERENCES oamag_core.conference_series(conference_series_id),
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


-- Modifications:
-- changed paper_id type to bigint
--
-- changed rank type to bigint
--
-- changed year type to integer
--
-- changed journal_id type to bigint
--
-- changed conference_series_id type to bigint
--
-- changed conference_instance_id to bigint
--
-- changed first_name field to first_page
--
-- changed last_name field to last_page
--
-- Additions:
-- added joural_id foreign key reference to journals.journal_id
--
-- added oa_status
--
CREATE TABLE IF NOT EXISTS oamag_core.papers (
paper_id bigint PRIMARY KEY,
rank integer CHECK (rank > 0),
doi varchar,
doc_type varchar,
genre varchar,
paper_title varchar,
original_title varchar,
book_title varchar,
year integer,
date timestamp,
publisher varchar,
journal_id bigint REFERENCES oamag_core.journals(journal_id),
conference_series_id bigint REFERENCES oamag_core.conference_series(conference_series_id),
conference_instance_id bigint REFERENCES oamag_core.conference_instances(conference_instance_id),
volume varchar,
issue varchar,
first_page varchar,
last_page varchar,
reference_count bigint,
citation_count bigint,
estimated_citation bigint,
original_venue varchar,
oa_status varchar,
doi_lower varchar,
created_date varchar NOT NULL
);


-- Note: PaperResources is no longer being updated by OpenAlex
--
-- Modifications:
-- changed paper_id type to bigint
--
-- 
CREATE TABLE IF NOT EXISTS oamag_core.paper_resources (
paper_id bigint REFERENCES oamag_core.papers(paper_id),
resource_type integer,
resource_url varchar,
source_url varchar,
relationship_type integer
);


-- Notes: rank is no longer updated by OpenAlex
-- Modifications:
-- changed field_of_study_id1 type to bigint
--
-- changed field_of_study_id2 type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.related_field_of_study (
field_of_study_id1 bigint REFERENCES oamag_core.fields_of_study(field_of_study_id),
type1 varchar,
field_of_study_id2 bigint REFERENCES oamag_core.fields_of_study(field_of_study_id),
type2 varchar,
rank numeric
);


-- Modifications:
-- changed paper_id type to bigint
--
-- Additions:
-- added language_code
--
-- oai_pmh_id
CREATE TABLE IF NOT EXISTS oamag_core.paper_urls (
paper_id bigint REFERENCES oamag_core.papers(paper_id),
source_type integer,
source_url varchar,
language_code varchar,
oai_pmh_id varchar
);


-- Modifications:
-- changed paper_id type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.paper_abstract_inverted_index (
--paper_id bigint REFERENCES oamag_core.papers(paper_id),
paper_id bigint,
indexed_abstract varchar
);

-- Modifications:
-- changed paper_id type to bigint
--
-- changed author_sequence_number type to integer
CREATE TABLE IF NOT EXISTS oamag_core.paper_author_affiliations (
--paper_id bigint REFERENCES oamag_core.papers(paper_id),
paper_id bigint,
--author_id bigint REFERENCES oamag_core.authors(author_id),
author_id bigint,
--affiliation_id bigint REFERENCES oamag_core.affiliations(affiliation_id),
affiliation_id bigint,
author_sequence_number integer CHECK (author_sequence_number >= 0),
original_author varchar,
original_affiliation varchar
);


-- Note: PaperCitationContexts is no longer being updated by OpenAlex
--
-- Modifications:
-- changed paper_id type to bigint
--
-- changed paper_reference_id type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.paper_citation_contexts (
--paper_id bigint REFERENCES oamag_core.papers(paper_id),
paper_id bigint,
--paper_reference_id bigint REFERENCES oamag_core.papers(paper_id),
paper_reference_id bigint,
citation_context varchar
);

-- Modifications:
-- changed paper_id type to bigint
--
-- changed field_of_study_id type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.paper_fields_of_study (
--paper_id bigint REFERENCES oamag_core.papers(paper_id),
paper_id bigint,
--field_of_study_id bigint REFERENCES oamag_core.fields_of_study(field_of_study_id),
field_of_study_id bigint,
score numeric
);

-- Note: The paper_languages table does not exist in OpenAlex MAG
--CREATE TABLE IF NOT EXISTS oamag_core.paper_languages (
--paper_id varchar REFERENCES oamag_core.papers(paper_id),
--language_code varchar
--);

-- Modifications:
-- changed paper_id type to bigint
--
-- changed recommended_paper_id type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.paper_recommendations (
--paper_id bigint REFERENCES oamag_core.papers(paper_id),
paper_id bigint,
--recommended_paper_id bigint REFERENCES oamag_core.papers(paper_id),
recommended_paper_id bigint,
score numeric
);

-- Modifications:
-- changed paper_id type to bigint
--
-- changed paper_reference_id type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.paper_references (
--paper_id bigint REFERENCES oamag_core.papers(paper_id),
paper_id bigint,
--paper_reference_id bigint REFERENCES oamag_core.papers(paper_id)
paper_reference_id bigint
);

-- Modifications:
-- changed field_of_study_id type to bigint
--
-- changed child_field_of_study_id type to bigint
CREATE TABLE IF NOT EXISTS oamag_core.field_of_study_children (
field_of_study_id bigint REFERENCES oamag_core.fields_of_study(field_of_study_id),
child_field_of_study_id bigint REFERENCES oamag_core.fields_of_study(field_of_study_id)
);


