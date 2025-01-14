#!/bin/bash
set -e

export BULK_DIR='/nvme/courtlistener'
export BULK_DB_HOST='localhost'
export BULK_DB_USER='postgres'

# Default from schema is 'courtlistener'
export BULK_DB_NAME=courtlistener
export PGPASSWORD=babar

# echo "Loading schema to database: clean_schema.sql"
# psql -f clean_schema.sql --host "$BULK_DB_HOST" --username "$BULK_DB_USER"

# echo "Loading courts-2024-12-31.csv to database"
# psql --command "\COPY public.search_court (
# 	       id, pacer_court_id, pacer_has_rss_feed, pacer_rss_entry_types, date_last_pacer_contact,
# 	       fjc_court_id, date_modified, in_use, has_opinion_scraper,
# 	       has_oral_argument_scraper, position, citation_string, short_name, full_name,
# 	       url, start_date, end_date, jurisdiction, notes, parent_court_id
# 	       ) FROM '$BULK_DIR/courts-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

# echo "Loading originating-court-information-2024-12-31.csv to database"
# psql --command "\COPY public.search_originatingcourtinformation (
# 	       id, date_created, date_modified, docket_number, assigned_to_str,
# 	       ordering_judge_str, court_reporter, date_disposed, date_filed, date_judgment,
# 	       date_judgment_eod, date_filed_noa, date_received_coa, assigned_to_id,
# 	       ordering_judge_id
# 	       ) FROM '$BULK_DIR/originating-court-information-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

# echo "Loading dockets-2024-12-31.csv to database"
# psql --command "\COPY public.search_docket (id, date_created, date_modified, source, appeal_from_str,
# 	       assigned_to_str, referred_to_str, panel_str, date_last_index, date_cert_granted,
# 	       date_cert_denied, date_argued, date_reargued,
# 	       date_reargument_denied, date_filed, date_terminated,
# 	       date_last_filing, case_name_short, case_name, case_name_full, slug,
# 	       docket_number, docket_number_core, pacer_case_id, cause,
# 	       nature_of_suit, jury_demand, jurisdiction_type,
# 	       appellate_fee_status, appellate_case_type_information, mdl_status,
# 	       filepath_local, filepath_ia, filepath_ia_json, ia_upload_failure_count, ia_needs_upload,
# 	       ia_date_first_change, view_count, date_blocked, blocked, appeal_from_id, assigned_to_id,
# 	       court_id, idb_data_id, originating_court_information_id, referred_to_id,
# 	       federal_dn_case_type, federal_dn_office_code, federal_dn_judge_initials_assigned,
# 	       federal_dn_judge_initials_referred, federal_defendant_number, parent_docket_id
# 	       ) FROM '$BULK_DIR/dockets-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

# echo "Loading opinion-clusters-2024-12-31.csv to database"
# psql --command "\COPY public.search_opinioncluster (
#        id, date_created, date_modified, judges, date_filed,
#        date_filed_is_approximate, slug, case_name_short, case_name,
#        case_name_full, scdb_id, scdb_decision_direction, scdb_votes_majority,
#        scdb_votes_minority, source, procedural_history, attorneys,
#        nature_of_suit, posture, syllabus, headnotes, summary, disposition,
#        history, other_dates, cross_reference, correction, citation_count,
#        precedential_status, date_blocked, blocked, filepath_json_harvard,
# 	       filepath_pdf_harvard, docket_id, arguments, headmatter
#    ) FROM '$BULK_DIR/opinion-clusters-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

# echo "Loading search_opinioncluster_panel-2024-12-31.csv to database"
# psql --command "\COPY public.search_opinioncluster_panel (
# 	       id, opinioncluster_id, person_id
# 	   ) FROM '$BULK_DIR/search_opinioncluster_panel-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

# echo "Loading search_opinioncluster_non_participating_judges-2024-12-31.csv to database"
# psql --command "\COPY public.search_opinioncluster_non_participating_judges (
# 	       id, opinioncluster_id, person_id
# 	   ) FROM '$BULK_DIR/search_opinioncluster_non_participating_judges-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

echo "Loading opinions-2024-12-31.csv to database"
psql --command "\COPY public.search_opinion (
	       id, date_created, date_modified, author_str, per_curiam, joined_by_str,
	       type, sha1, page_count, download_url, local_path, plain_text, html,
	       html_lawbox, html_columbia, html_anon_2020, xml_harvard,
	       html_with_citations, extracted_by_ocr, author_id, cluster_id
	   ) FROM '$BULK_DIR/opinions_cleaned-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\"', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

echo "Loading search_opinion_joined_by-2024-12-31.csv to database"
psql --command "\COPY public.search_opinion_joined_by (
			id, opinion_id, person_id
) FROM '$BULK_DIR/search_opinion_joined_by-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

echo "Loading courthouses-2024-12-31.csv to database"
psql --command "\COPY public.search_courthouse (id, court_seat, building_name, address1, address2, city, county,
state, zip_code, country_code, court_id) FROM '$BULK_DIR/courthouses-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

echo "Loading court-appeals-to-2024-12-31.csv to database"
psql --command "\COPY public.search_court_appeals_to (id, from_court_id, to_court_id) FROM '$BULK_DIR/court-appeals-to-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

echo "Loading citation-map-2024-12-31.csv to database"
psql --command "\COPY public.search_opinionscited (
	       id, depth, cited_opinion_id, citing_opinion_id
	   ) FROM '$BULK_DIR/citation-map-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

echo "Loading citations-2024-12-31.csv to database"
psql --command "\COPY public.search_citation (
	       id, volume, reporter, page, type, cluster_id
	   ) FROM '$BULK_DIR/citations-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"

echo "Loading parentheticals-2024-12-31.csv to database"
psql --command "\COPY public.search_parenthetical (
	       id, text, score, described_opinion_id, describing_opinion_id, group_id
	   ) FROM '$BULK_DIR/parentheticals-2024-12-31.csv' WITH (FORMAT csv, ENCODING utf8, QUOTE '\`', HEADER)" --host "$BULK_DB_HOST" --username "$BULK_DB_USER" --dbname "$BULK_DB_NAME"
