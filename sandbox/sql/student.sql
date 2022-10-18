      /* Student Validation Query */
         SELECT a.student_id,
                b.dixie_ssn AS ssn,
                b.dixie_previous_student_id AS previous_student_id,
                b.first_name,
                b.last_name,
                b.middle_name,
                b.name_suffix,
                b.dixie_previous_last_name AS previous_last_name,
                b.dixie_previous_first_name AS previous_first_name,
                b.dixie_previous_middle_name AS previous_middle_name,
              --  b.previous_name_suffix,
                b.local_address_zip_code,
                b.mailing_address_zip_code,
                b.us_citizenship_code,
                b.first_admit_county_code,
                b.dixie_first_admit_state_code AS first_admit_state_code,
                b.birth_date,
                b.gender_code,
                b.is_hispanic_latino_ethnicity,
                b.is_asian,
                b.is_black,
                b.is_american_indian_alaskan,
                b.is_hawaiian_pacific_islander,
                b.is_white,
                b.is_international,
                b.is_other_race,
                a.residential_housing_code AS residency_code,
                a.primary_major_cip_code,
                a.student_type_code,
                a.student_type_code,
                a.primary_level_class_id,
                a.primary_degree_id,
                a.institutional_cumulative_credits_earned,
                a.institutional_cumulative_gpa,
                a.transfer_cumulative_credits_earned,
                a.full_time_part_time_code,
                b.first_admit_country_iso_code AS first_admit_country_code,
                a.secondary_major_cip_code,
                a.total_cumulative_clep_credits_earned,
                a.total_cumulative_ap_credits_earned,
                b.highest_act_composite_score AS act_composite_score,
                b.highest_act_english_score AS act_english_score,
                b.highest_act_math_score AS act_math_score,
                b.highest_act_reading_score AS act_reading_score,
                b.highest_act_science_score AS act_science_score,
                b.latest_high_school_code AS high_school_code,
                b.latest_high_school_desc AS high_school_desc,
                b.high_school_graduation_date,
                a.house_bill_75_waiver,
                a.is_pell_eligible,
                a.is_pell_awarded,
                a.dixie_is_bia AS is_bia,
                a.primary_major_college_id,
                a.primary_major_college_desc,
                a.primary_major_id,
                a.primary_major_desc,
                a.secondary_major_college_id,
                a.secondary_major_college_desc,
                a.secondary_major_id,
                a.secondary_major_desc,
                a.level_id,
                a.term_id,
            -- "TODO : add activity dates"
                b.spbpers_activity_date,
                b.goradid_activity_date,
                b.sabsupl_activity_date,
                a.sgbstdn_activity_date,
                a.shrtgpa_activity_date,
                b.sortest_activity_date,
                b.spraddr_activity_date,
                b.spriden_activity_date,
                b.sorhsch_activity_date,
                a.stvmajr_activity_date
                -- add shrlgpa_activity_date
                -- add rpratrm_activity_date
           FROM quad.student_term_level a
      LEFT JOIN quad.student b
             ON b.student_id = a.student_id
          WHERE a.term_id >= (SELECT term_id FROM export.term WHERE is_previous_term)
            AND a.is_primary_level = TRUE
            AND a.is_enrolled
         ORDER BY student_id
