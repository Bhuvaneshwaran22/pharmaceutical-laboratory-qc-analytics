-- ============================================================
-- PHARMACEUTICAL LABORATORY QC ANALYTICS
-- ADVANCED SQL ANALYSIS
-- Oracle SQL / SQL*Plus
-- ============================================================


-- ============================================================
-- 1. OOS INVESTIGATION
-- Identify OOS results and deviation from specification
-- ============================================================

SELECT
    RESULT_ID,
    SAMPLE_ID,
    BATCH_ID,
    PRODUCT_NAME,
    PARAMETER_NAME,
    RESULT_VALUE,
    SPECIFICATION_MIN,
    SPECIFICATION_MAX,
    RESULT_STATUS,

    CASE
        WHEN RESULT_VALUE < SPECIFICATION_MIN
            THEN 'Below Minimum'

        WHEN RESULT_VALUE > SPECIFICATION_MAX
            THEN 'Above Maximum'

        ELSE 'Within Range'
    END AS DEVIATION_TYPE,

    CASE
        WHEN RESULT_VALUE < SPECIFICATION_MIN
            THEN ROUND(SPECIFICATION_MIN - RESULT_VALUE,3)

        WHEN RESULT_VALUE > SPECIFICATION_MAX
            THEN ROUND(RESULT_VALUE - SPECIFICATION_MAX,3)

        ELSE 0
    END AS DEVIATION_VALUE,

    RETEST_FLAG,
    PRIORITY,
    ANALYST_NAME,
    INSTRUMENT_NAME,
    TURNAROUND_HOURS

FROM LABORATORY_RESULTS

WHERE RESULT_STATUS = 'OOS'

ORDER BY
    DEVIATION_VALUE DESC;


-- ============================================================
-- 2. PRODUCT OOS RISK RANKING
-- Rank products based on OOS percentage
-- ============================================================

SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS'
            THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    RANK() OVER (
        ORDER BY
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) DESC
    ) AS PRODUCT_RISK_RANK

FROM LABORATORY_RESULTS

GROUP BY
    PRODUCT_ID,
    PRODUCT_NAME

ORDER BY
    PRODUCT_RISK_RANK;


-- ============================================================
-- 3. LATEST TEST RESULT PER PRODUCT
-- ROW_NUMBER() WITH PARTITION BY
-- ============================================================

SELECT
    RESULT_ID,
    PRODUCT_ID,
    PRODUCT_NAME,
    BATCH_ID,
    TEST_DATE,
    RESULT_STATUS,
    RESULT_VALUE,
    ANALYST_NAME,
    INSTRUMENT_NAME

FROM
(
    SELECT
        RESULT_ID,
        PRODUCT_ID,
        PRODUCT_NAME,
        BATCH_ID,
        TEST_DATE,
        RESULT_STATUS,
        RESULT_VALUE,
        ANALYST_NAME,
        INSTRUMENT_NAME,

        ROW_NUMBER() OVER (
            PARTITION BY PRODUCT_ID
            ORDER BY TEST_DATE DESC, RESULT_ID DESC
        ) AS RN

    FROM LABORATORY_RESULTS
)

WHERE RN = 1

ORDER BY PRODUCT_ID;


-- ============================================================
-- 4. ANALYST PERFORMANCE RANKING
-- Rank analysts using workload and OOS performance
-- ============================================================

SELECT
    ANALYST_ID,
    ANALYST_NAME,
    ANALYST_EXPERIENCE_YEARS,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS'
            THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    ROUND(AVG(TURNAROUND_HOURS),2)
        AS AVG_TAT_HOURS,

    RANK() OVER (
        ORDER BY
        COUNT(*) DESC
    ) AS WORKLOAD_RANK,

    RANK() OVER (
        ORDER BY
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) ASC
    ) AS OOS_PERFORMANCE_RANK

FROM LABORATORY_RESULTS

GROUP BY
    ANALYST_ID,
    ANALYST_NAME,
    ANALYST_EXPERIENCE_YEARS

ORDER BY
    WORKLOAD_RANK;


-- ============================================================
-- 5. PRODUCT RISK CLASSIFICATION
-- ============================================================

SELECT
    PRODUCT_ID,
    PRODUCT_NAME,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS'
            THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    CASE

        WHEN
            SUM(
                CASE
                    WHEN RESULT_STATUS = 'OOS'
                    THEN 1
                    ELSE 0
                END
            ) / COUNT(*) * 100 >= 10
            THEN 'HIGH RISK'

        WHEN
            SUM(
                CASE
                    WHEN RESULT_STATUS = 'OOS'
                    THEN 1
                    ELSE 0
                END
            ) / COUNT(*) * 100 >= 5
            THEN 'MEDIUM RISK'

        ELSE 'LOW RISK'

    END AS RISK_CLASSIFICATION

FROM LABORATORY_RESULTS

GROUP BY
    PRODUCT_ID,
    PRODUCT_NAME

ORDER BY
    OOS_PERCENTAGE DESC;


-- ============================================================
-- 6. MONTHLY QC TREND
-- ============================================================

SELECT
    TO_CHAR(TEST_DATE,'YYYY-MM') AS TEST_MONTH,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'PASS'
            THEN 1
            ELSE 0
        END
    ) AS PASSED_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS'
            THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE

FROM LABORATORY_RESULTS

GROUP BY
    TO_CHAR(TEST_DATE,'YYYY-MM')

ORDER BY
    TEST_MONTH;


-- ============================================================
-- 7. INSTRUMENT RISK ANALYSIS
-- ============================================================

SELECT
    INSTRUMENT_ID,
    INSTRUMENT_NAME,
    INSTRUMENT_TYPE,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS'
            THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    ROUND(
        AVG(TURNAROUND_HOURS),
        2
    ) AS AVG_TAT_HOURS,

    CASE

        WHEN
            SUM(
                CASE
                    WHEN RESULT_STATUS = 'OOS'
                    THEN 1
                    ELSE 0
                END
            ) / COUNT(*) * 100 >= 10
            THEN 'HIGH RISK'

        WHEN
            SUM(
                CASE
                    WHEN RESULT_STATUS = 'OOS'
                    THEN 1
                    ELSE 0
                END
            ) / COUNT(*) * 100 >= 5
            THEN 'MEDIUM RISK'

        ELSE 'LOW RISK'

    END AS INSTRUMENT_RISK

FROM LABORATORY_RESULTS

GROUP BY
    INSTRUMENT_ID,
    INSTRUMENT_NAME,
    INSTRUMENT_TYPE

ORDER BY
    OOS_PERCENTAGE DESC;


-- ============================================================
-- 8. PARAMETER RISK RANKING
-- ============================================================

SELECT
    PARAMETER_ID,
    PARAMETER_NAME,
    UNIT,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS'
            THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS OOS_PERCENTAGE,

    DENSE_RANK() OVER (
        ORDER BY
        SUM(
            CASE
                WHEN RESULT_STATUS = 'OOS'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) DESC
    ) AS PARAMETER_RISK_RANK

FROM LABORATORY_RESULTS

GROUP BY
    PARAMETER_ID,
    PARAMETER_NAME,
    UNIT

ORDER BY
    PARAMETER_RISK_RANK;


-- ============================================================
-- 9. ANALYST MONTHLY PERFORMANCE
-- Window Function Example
-- ============================================================

SELECT
    TO_CHAR(TEST_DATE,'YYYY-MM') AS TEST_MONTH,
    ANALYST_NAME,

    COUNT(*) AS TOTAL_TESTS,

    SUM(
        CASE
            WHEN RESULT_STATUS = 'OOS'
            THEN 1
            ELSE 0
        END
    ) AS OOS_TESTS,

    ROUND(
        AVG(TURNAROUND_HOURS),
        2
    ) AS AVG_TAT_HOURS,

    RANK() OVER (
        PARTITION BY TO_CHAR(TEST_DATE,'YYYY-MM')
        ORDER BY COUNT(*) DESC
    ) AS MONTHLY_WORKLOAD_RANK

FROM LABORATORY_RESULTS

GROUP BY
    TO_CHAR(TEST_DATE,'YYYY-MM'),
    ANALYST_NAME

ORDER BY
    TEST_MONTH,
    MONTHLY_WORKLOAD_RANK;


-- ============================================================
-- 10. QC ACTION PRIORITIZATION
-- ============================================================

SELECT
    RESULT_ID,
    PRODUCT_NAME,
    PARAMETER_NAME,
    RESULT_STATUS,
    PRIORITY,
    RETEST_FLAG,
    TURNAROUND_HOURS,

    CASE

        WHEN RESULT_STATUS = 'OOS'
             AND PRIORITY = 'Critical'
             AND RETEST_FLAG = 'Yes'
            THEN 'IMMEDIATE INVESTIGATION'

        WHEN RESULT_STATUS = 'OOS'
             AND RETEST_FLAG = 'Yes'
            THEN 'INVESTIGATE & RETEST'

        WHEN RESULT_STATUS = 'OOS'
            THEN 'INVESTIGATE'

        WHEN PRIORITY = 'High'
            THEN 'PRIORITY MONITORING'

        ELSE
            'NORMAL MONITORING'

    END AS QC_ACTION

FROM LABORATORY_RESULTS

ORDER BY
    CASE

        WHEN RESULT_STATUS = 'OOS'
             AND PRIORITY = 'Critical'
            THEN 1

        WHEN RESULT_STATUS = 'OOS'
            THEN 2

        WHEN PRIORITY = 'High'
            THEN 3

        ELSE 4

    END;


-- ============================================================
-- 11. TOP PRODUCTS BY TESTING VOLUME
-- ============================================================

SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    COUNT(*) AS TOTAL_TESTS,

    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS TESTING_VOLUME_RANK

FROM LABORATORY_RESULTS

GROUP BY
    PRODUCT_ID,
    PRODUCT_NAME

ORDER BY
    TESTING_VOLUME_RANK;


-- ============================================================
-- 12. TOP INSTRUMENTS BY TESTING VOLUME
-- ============================================================

SELECT
    INSTRUMENT_ID,
    INSTRUMENT_NAME,
    INSTRUMENT_TYPE,
    COUNT(*) AS TOTAL_TESTS,

    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS INSTRUMENT_VOLUME_RANK

FROM LABORATORY_RESULTS

GROUP BY
    INSTRUMENT_ID,
    INSTRUMENT_NAME,
    INSTRUMENT_TYPE

ORDER BY
    INSTRUMENT_VOLUME_RANK;


-- ============================================================
-- END OF ADVANCED SQL ANALYSIS
-- ============================================================
