\COPY mag_core.affiliations FROM '/raw/CleanMAGData/mag_papers_1_affiliations.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER; 

\COPY mag_core.authors FROM '/raw/CleanMAGData/mag_papers_1_authors.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.journals FROM '/raw/CleanMAGData/mag_papers_1_journals.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.conference_series FROM '/raw/CleanMAGData/mag_papers_1_conferenceSeries.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.fields_of_study FROM '/raw/CleanMAGData/mag_papers_1_fieldsOfStudy.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.conference_instances FROM '/raw/CleanMAGData/mag_papers_1_conferenceInstances.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.papers FROM '/raw/CleanMAGData/mag_papers_1_papers.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_resources FROM '/raw/CleanMAGData/mag_papers_1_paperResources.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.related_field_of_study FROM '/raw/CleanMAGData/mag_papers_1_relatedFieldOfStudy.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_urls FROM '/raw/CleanMAGData/mag_papers_1_paperURLs.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_abstract_inverted_index FROM '/raw/CleanMAGData/mag_papers_1_paperAbstractInvertedIndex.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_author_affiliations FROM '/raw/CleanMAGData/mag_papers_1_paperAuthorAffiliations.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

/* The paper citation contexts table has a problem with special characters or control characters. You may want to skip this table but you can try and see if it works for you */

\COPY mag_core.paper_citation_contexts FROM '/raw/CleanMAGData/mag_papers_1_paperCitationContexts.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_fields_of_study FROM '/raw/CleanMAGData/mag_papers_1_paperFieldsOfStudy.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_languages FROM '/raw/CleanMAGData/mag_papers_1_paperLanguages.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_recommendations FROM '/raw/CleanMAGData/mag_papers_1_paperRecommendations.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.paper_references FROM '/raw/CleanMAGData/mag_papers_1_paperReferences.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;

\COPY mag_core.fields_of_study_children FROM '/raw/CleanMAGData/mag_papers_1_fieldsOfStudyChildren.csv' DELIMITER '~' ENCODING 'UTF-8' CSV HEADER;





\COPY paper_citation_contexts FROM '/raw/mag-clean/PaperCitationContexts.txt' DELIMITER E'\t' ENCODING 'UTF-8' CSV HEADER;














