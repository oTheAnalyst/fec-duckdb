/*
individual_contributions
data cleaning and organizing:
- only varchars and bigint.
- need to add a properly formatted datafield.
- need to id high cardnality attributes
- use a data dictionary to fill the columns
- data is date not timestamp
- https://www.fec.gov/campaign-finance-data/contributions-individuals-file-description/
- monitary transaction are decimal(38,2)s
*/---------------------
CREATE schema IF NOT EXISTS inter;
CREATE schema IF NOT EXISTS stg;

SET memory_limit = '4GB';
CREATE
OR REPLACE TABLE inter.individual_contributions_s1 AS SELECT
  column00 AS committee_identification,
  column01 AS amendment_indicator,
  column02 AS report_type,
  column03 AS primary_general_indicator,
  column04 AS image_number,
  column05 AS transaction_type,
  column06 AS entity_type,
  LOWER(column07) AS contributor_lender_name,
  column08 AS city,
  column09 AS state,
  column10 AS zip_code,
  column11 AS employer,
  column12 AS occupation,
  strptime(
    column13,
    '%m%d%Y'
  ) ::DATE AS transaction_date,
  column14 ::DECIMAL(
    38,
    2
  ) AS transaction_amount,
  column15 AS other_id_number,
  column16 AS transaction_id,
  column17 ::BIGINT AS report_id,
  column18 AS memo_code,
  column19 AS memo_text,
  column20 ::BIGINT AS fec_record_number
FROM
  stg.individual_contributions;
CREATE
OR REPLACE TABLE inter.commitees_to_canidates_s1 AS SELECT
  column00 AS committee_identification,
  column01 AS amendment_indicator,
  column02 AS report_type,
  column03 AS primary_general_indicator,
  column04 AS image_number,
  column05 AS transaction_type,
  column06 AS entity_type,
  LOWER(column07) AS name,
  column08 AS city,
  column09 AS state,
  column10 AS zip_code,
  column11 AS employer,
  column12 AS occupation,
  strptime(
    column13,
    '%m%d%Y'
  ) ::DATE AS transaction_date,
  column14 ::DECIMAL(
    38,
    2
  ) AS transaction_amount,
  column15 AS other_id_number,
  column16 AS candidate_id,
  column17 AS transaction_id,
  column18 ::INT AS file_number,
  column19 AS memo_code,
  column20 AS memo_text,
  column21 ::BIGINT AS fec_record_number
FROM
  stg.committees_to_canidates_independent_expenditures;
CREATE
OR REPLACE TABLE inter.one_commitee_to_another AS SELECT
  column00 AS committee_identification,
  column01 AS amendment_indicator,
  column02 AS report_type,
  column03 AS primary_general_indicator,
  column04 AS image_number,
  column05 AS transaction_type,
  column06 AS entity_type,
  LOWER(column07) AS name,
  column08 AS city,
  column09 AS state,
  column10 AS zip_code,
  column11 AS employer,
  column12 AS occupation,
  strptime(
    column13,
    '%m%d%Y'
  ) ::DATE AS transaction_date,
  column14 ::DECIMAL(
    38,
    2
  ) AS transaction_amount,
  column15 AS other_id_number,
  column16 AS transaction_id,
  column17 ::INT AS file_number,
  column18 AS memo_cd,
  column19 AS memo_text,
  column20 ::BIGINT AS fec_record_number
FROM
  stg.one_commitee_to_another;
CREATE
OR REPLACE TABLE inter.candidate_summary_s1 AS SELECT
  column00 AS candidate_id,
  LOWER(column01) AS candidate_name,
  column02 AS incumbent_challenger_status,
  column03 AS party_code,
  column04 AS party_affiliation,
  column05 ::DECIMAL(
    38,
    2
  ) AS total_receipts,
  column06 ::DECIMAL(
    38,
    2
  ) AS transfers_from_authorized_committees,
  column07 ::DECIMAL(
    38,
    2
  ) AS total_disbursements,
  column08 ::DECIMAL(
    38,
    2
  ) AS transfers_to_authorized_committees,
  column09 ::DECIMAL(
    38,
    2
  ) AS beginning_cash,
  column10 ::DECIMAL(
    38,
    2
  ) AS ending_cash,
  column11 ::DECIMAL(
    38,
    2
  ) AS contributions_from_candidate,
  column12 ::DECIMAL(
    38,
    2
  ) AS loans_from_candidate,
  column13 ::DECIMAL(
    38,
    2
  ) AS other_loans,
  column14 ::DECIMAL(
    38,
    2
  ) AS candidate_loan_repayment,
  column15 ::DECIMAL(
    38,
    2
  ) AS other_loan_repayments,
  column16 ::DECIMAL(
    38,
    2
  ) AS debts_owed_by,
  column17 ::DECIMAL(
    38,
    2
  ) AS total_individual_contributions,
  column18 AS candidate_state,
  column19 AS candidate_district,
  column20 AS special_election_status,
  column21 AS primary_election_status,
  column22 AS runoff_election_status,
  column23 AS general_election_status,
  column24 AS general_election_percentage,
  column25 AS contribution_from_other_politcal_committees,
  column26 AS contribution_from_party_committees,
  column27 AS coverage_end_date,
  column28 ::DECIMAL(
    38,
    2
  ) AS refunds_to_individuals,
  column29 ::DECIMAL(
    38,
    2
  ) AS refunds_to_committees
FROM
  stg.candidate_summary;
CREATE
OR REPLACE TABLE inter.committee_master_s1 AS SELECT
  column00 AS committee_identification,
  column01 AS committee_name,
  column02 AS treasurer_name,
  column03 AS street_one,
  column04 AS street_two,
  column05 AS city_or_town,
  column06 AS state,
  column07 AS zip_code,
  column08 AS committee_designation,
  column09 AS committee_type,
  column10 AS committee_party,
  column11 AS filing_frequency,
  column12 AS interest_group_category,
  column13 AS connected_organization_name,
  column14 AS candidate_id
FROM
  stg.committee_master;
CREATE
OR REPLACE TABLE inter.candidate_commitee_linkage AS SELECT
  column0 AS candidate_id,
  column1 ::INT AS candidate_election_year,
  column2 ::INT AS fec_election_year,
  column3 AS committee_id,
  column4 AS committee_type,
  column5 AS committee_design,
  column6 ::INT AS linkg_age
FROM
  stg.candidate_commitee_linkage;
