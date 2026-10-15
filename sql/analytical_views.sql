-- ============================================================
-- PHARMACEUTICAL LABORATORY QC ANALYTICS
-- ANALYTICAL VIEWS
-- Oracle SQL / SQL*Plus
-- ============================================================

-- ============================================================
-- 1. QC KPI VIEW
-- ============================================================

CREATE OR REPLACE VIEW VW_QC_KPI AS
SELECT
    COUNT(*) AS TOTAL_TESTS,
    SUM(CASE WHEN RESULT_STATUS = 'PASS' THEN 1 ELSE 0 END) AS PASSED_TESTS,
    SUM(CASE WHEN RESULT_STATUS = 'OOS' THEN 1 ELSE 0 END) AS OOS_TESTS,
    ROUND(
        SUM(CASE WHEN RESULT_STATUS = 'PASS' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS PASS_PERCENTAGE,
    ROUND(
        SUM(CASE WHEN RESULT_STATUS = 'OOS' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,
    ROUND(AVG(TURNAROUND_HOURS),2) AS AVG_TAT_HOURS
FROM LABORATORY_RESULTS;


-- ============================================================
-- 2. PRODUCT QC ANALYSIS
-- ============================================================

CREATE OR REPLACE VIEW VW_PRODUCT_QC AS
SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    PRODUCT_TYPE,
    MANUFACTURING_SITE,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'PASS' THEN 1
            ELSE 0
        END
    ) AS PASSED_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS' THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'PASS' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS PASS_PERCENTAGE,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    ROUND(AVG(TURNAROUND_HOURS),2) AS AVG_TAT_HOURS

FROM LABORATORY_RESULTS

GROUP BY
    PRODUCT_ID,
    PRODUCT_NAME,
    PRODUCT_TYPE,
    MANUFACTURING_SITE;


-- ============================================================
-- 3. PARAMETER QC ANALYSIS
-- ============================================================

CREATE OR REPLACE VIEW VW_PARAMETER_QC AS
SELECT
    PARAMETER_ID,
    PARAMETER_NAME,
    UNIT,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'PASS' THEN 1
            ELSE 0
        END
    ) AS PASSED_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS' THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    ROUND(AVG(RESULT_VALUE),3) AS AVG_RESULT_VALUE,

    ROUND(AVG(TURNAROUND_HOURS),2) AS AVG_TAT_HOURS

FROM LABORATORY_RESULTS

GROUP BY
    PARAMETER_ID,
    PARAMETER_NAME,
    UNIT;


-- ============================================================
-- 4. ANALYST PERFORMANCE
-- ============================================================

CREATE OR REPLACE VIEW VW_ANALYST_PERFORMANCE AS
SELECT
    ANALYST_ID,
    ANALYST_NAME,
    ANALYST_EXPERIENCE_YEARS,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'PASS' THEN 1
            ELSE 0
        END
    ) AS PASSED_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS' THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    ROUND(AVG(TURNAROUND_HOURS),2) AS AVG_TAT_HOURS,

    SUM(
        CASE
            WHEN RETEST_FLAG = 'Yes' THEN 1
            ELSE 0
        END
    ) AS RETEST_TESTS

FROM LABORATORY_RESULTS

GROUP BY
    ANALYST_ID,
    ANALYST_NAME,
    ANALYST_EXPERIENCE_YEARS;


-- ============================================================
-- 5. INSTRUMENT PERFORMANCE
-- ============================================================

CREATE OR REPLACE VIEW VW_INSTRUMENT_PERFORMANCE AS
SELECT
    INSTRUMENT_ID,
    INSTRUMENT_NAME,
    INSTRUMENT_TYPE,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'PASS' THEN 1
            ELSE 0
        END
    ) AS PASSED_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS' THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    ROUND(AVG(TURNAROUND_HOURS),2) AS AVG_TAT_HOURS

FROM LABORATORY_RESULTS

GROUP BY
    INSTRUMENT_ID,
    INSTRUMENT_NAME,
    INSTRUMENT_TYPE;


-- ============================================================
-- 6. RETEST ANALYSIS
-- ============================================================

CREATE OR REPLACE VIEW VW_RETEST_ANALYSIS AS
SELECT
    RETEST_FLAG,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'PASS' THEN 1
            ELSE 0
        END
    ) AS PASSED_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS' THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(AVG(TURNAROUND_HOURS),2) AS AVG_TAT_HOURS

FROM LABORATORY_RESULTS

GROUP BY
    RETEST_FLAG;


-- ============================================================
-- 7. PRIORITY ANALYSIS
-- ============================================================

CREATE OR REPLACE VIEW VW_PRIORITY_ANALYSIS AS
SELECT
    PRIORITY,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'PASS' THEN 1
            ELSE 0
        END
    ) AS PASSED_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS' THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    ROUND(AVG(TURNAROUND_HOURS),2) AS AVG_TAT_HOURS

FROM LABORATORY_RESULTS

GROUP BY
    PRIORITY;


-- ============================================================
-- 8. POWER BI DASHBOARD DATA VIEW
-- ============================================================

CREATE OR REPLACE VIEW VW_QC_DASHBOARD_DATA AS
SELECT

    RESULT_ID,
    SAMPLE_ID,
    BATCH_ID,

    PRODUCT_ID,
    PRODUCT_NAME,
    PRODUCT_TYPE,
    MANUFACTURING_SITE,

    TEST_DATE,
    TO_CHAR(TEST_DATE,'YYYY-MM') AS TEST_MONTH,

    PRIORITY,

    PARAMETER_ID,
    PARAMETER_NAME,
    UNIT,

    RESULT_VALUE,
    SPECIFICATION_MIN,
    SPECIFICATION_MAX,

    RESULT_STATUS,
    RETEST_FLAG,

    ANALYST_ID,
    ANALYST_NAME,
    ANALYST_EXPERIENCE_YEARS,

    INSTRUMENT_ID,
    INSTRUMENT_NAME,
    INSTRUMENT_TYPE,

    TURNAROUND_HOURS,

    ------------------------------------------------------------
    -- RESULT CATEGORY
    ------------------------------------------------------------

    CASE
        WHEN RESULT_STATUS = 'PASS'
            THEN 'Within Specification'

        WHEN RESULT_STATUS = 'OOS'
            THEN 'Out of Specification'

        ELSE 'Unknown'
    END AS RESULT_CATEGORY,

    ------------------------------------------------------------
    -- DEVIATION TYPE
    ------------------------------------------------------------

    CASE

        WHEN RESULT_VALUE < SPECIFICATION_MIN
            THEN 'Below Minimum'

        WHEN RESULT_VALUE > SPECIFICATION_MAX
            THEN 'Above Maximum'

        ELSE 'Within Range'

    END AS DEVIATION_TYPE,

    ------------------------------------------------------------
    -- DEVIATION VALUE
    ------------------------------------------------------------

    CASE

        WHEN RESULT_VALUE < SPECIFICATION_MIN
            THEN ROUND(
                SPECIFICATION_MIN - RESULT_VALUE,
                3
            )

        WHEN RESULT_VALUE > SPECIFICATION_MAX
            THEN ROUND(
                RESULT_VALUE - SPECIFICATION_MAX,
                3
            )

        ELSE 0

    END AS DEVIATION_VALUE,

    ------------------------------------------------------------
    -- PRIORITY RISK
    ------------------------------------------------------------

    CASE

        WHEN PRIORITY = 'Critical'
            THEN 'High Risk'

        WHEN PRIORITY = 'High'
            THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS PRIORITY_RISK,

    ------------------------------------------------------------
    -- QC ACTION
    ------------------------------------------------------------

    CASE

        WHEN RESULT_STATUS = 'OOS'
             AND RETEST_FLAG = 'Yes'
            THEN 'Investigate & Retest'

        WHEN RESULT_STATUS = 'OOS'
            THEN 'Investigate'

        WHEN RESULT_STATUS = 'PASS'
            THEN 'Release / Monitor'

        ELSE 'Review'

    END AS QC_ACTION

FROM LABORATORY_RESULTS;


-- ============================================================
-- 9. VALIDATION QUERIES
-- ============================================================

SELECT * FROM VW_QC_KPI;

SELECT * FROM VW_PRODUCT_QC;

SELECT * FROM VW_PARAMETER_QC;

SELECT * FROM VW_ANALYST_PERFORMANCE;

SELECT * FROM VW_INSTRUMENT_PERFORMANCE;

SELECT * FROM VW_RETEST_ANALYSIS;

SELECT * FROM VW_PRIORITY_ANALYSIS;

SELECT *
FROM VW_QC_DASHBOARD_DATA
WHERE ROWNUM <= 10;


-- ============================================================
-- END OF ANALYTICAL VIEWS SCRIPT
-- ============================================================
