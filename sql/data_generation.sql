-- ============================================================
-- PHARMACEUTICAL LABORATORY QC ANALYTICS
-- DATA GENERATION SCRIPT
-- Oracle SQL / PL/SQL
-- ============================================================

SET SERVEROUTPUT ON;

-- ============================================================
-- 1. PRODUCT MASTER DATA
-- ============================================================

INSERT INTO PRODUCTS VALUES
('P001','Paracetamol 500mg','Tablet','Chennai');

INSERT INTO PRODUCTS VALUES
('P002','Atorvastatin 20mg','Tablet','Pune');

INSERT INTO PRODUCTS VALUES
('P003','Amoxicillin 500mg','Capsule','Hyderabad');

INSERT INTO PRODUCTS VALUES
('P004','Metformin 500mg','Tablet','Bengaluru');

INSERT INTO PRODUCTS VALUES
('P005','Azithromycin 250mg','Tablet','Ahmedabad');

INSERT INTO PRODUCTS VALUES
('P006','Omeprazole 20mg','Capsule','Mumbai');

INSERT INTO PRODUCTS VALUES
('P007','Cetirizine 10mg','Tablet','Chennai');

INSERT INTO PRODUCTS VALUES
('P008','Pantoprazole 40mg','Tablet','Hyderabad');

INSERT INTO PRODUCTS VALUES
('P009','Ibuprofen 400mg','Tablet','Pune');

INSERT INTO PRODUCTS VALUES
('P010','Losartan 50mg','Tablet','Bengaluru');


-- ============================================================
-- 2. SPECIFICATION MASTER DATA
-- ============================================================

INSERT INTO SPECIFICATIONS VALUES
('SP001','Assay','%',98,102,'HPLC');

INSERT INTO SPECIFICATIONS VALUES
('SP002','Related Substances','%',0,2,'HPLC');

INSERT INTO SPECIFICATIONS VALUES
('SP003','Dissolution','%',80,100,'Dissolution Tester');

INSERT INTO SPECIFICATIONS VALUES
('SP004','Uniformity','%',85,115,'UV Spectrophotometer');

INSERT INTO SPECIFICATIONS VALUES
('SP005','Moisture','%',0,5,'Karl Fischer');

INSERT INTO SPECIFICATIONS VALUES
('SP006','pH','pH',5,7,'pH Meter');

INSERT INTO SPECIFICATIONS VALUES
('SP007','Average Weight','mg',450,550,'Analytical Balance');

INSERT INTO SPECIFICATIONS VALUES
('SP008','Hardness','N',50,150,'Tablet Hardness Tester');

INSERT INTO SPECIFICATIONS VALUES
('SP009','Friability','%',0,1,'Friability Tester');

INSERT INTO SPECIFICATIONS VALUES
('SP010','Disintegration','min',5,30,'Disintegration Tester');


-- ============================================================
-- 3. ANALYST MASTER DATA
-- ============================================================

INSERT INTO ANALYSTS VALUES
('A001','Arun Kumar',5.5,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A002','Priya Sharma',4.0,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A003','Rahul Menon',6.5,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A004','Divya Krishnan',3.5,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A005','Karthik Raj',7.0,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A006','Meena Iyer',5.0,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A007','Vijay Kumar',4.5,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A008','Sneha Rao',3.0,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A009','Suresh Babu',8.0,'Quality Control');

INSERT INTO ANALYSTS VALUES
('A010','Anitha Devi',2.5,'Quality Control');


-- ============================================================
-- 4. INSTRUMENT MASTER DATA
-- ============================================================

INSERT INTO INSTRUMENTS VALUES
('INS001','Agilent HPLC System','HPLC','Agilent');

INSERT INTO INSTRUMENTS VALUES
('INS002','Waters HPLC System','HPLC','Waters');

INSERT INTO INSTRUMENTS VALUES
('INS003','Shimadzu HPLC System','HPLC','Shimadzu');

INSERT INTO INSTRUMENTS VALUES
('INS004','Dissolution Tester','Dissolution Tester','Electrolab');

INSERT INTO INSTRUMENTS VALUES
('INS005','Karl Fischer Titrator','Karl Fischer','Metrohm');

INSERT INTO INSTRUMENTS VALUES
('INS006','Analytical Balance','Analytical Balance','Mettler Toledo');

INSERT INTO INSTRUMENTS VALUES
('INS007','Tablet Hardness Tester','Hardness Tester','Electrolab');

INSERT INTO INSTRUMENTS VALUES
('INS008','Friability Tester','Friability Tester','Electrolab');

INSERT INTO INSTRUMENTS VALUES
('INS009','Disintegration Tester','Disintegration Tester','Electrolab');

INSERT INTO INSTRUMENTS VALUES
('INS010','UV Spectrophotometer','UV Spectrophotometer','Thermo Fisher');

INSERT INTO INSTRUMENTS VALUES
('INS011','Metrohm pH Meter','pH Meter','Metrohm');

INSERT INTO INSTRUMENTS VALUES
('INS012','Shimadzu UV Spectrophotometer','UV Spectrophotometer','Shimadzu');


-- ============================================================
-- 5. GENERATE 1,010 LABORATORY QC RECORDS
-- ============================================================

DECLARE

    v_product_no       NUMBER;
    v_parameter_no     NUMBER;
    v_analyst_no       NUMBER;
    v_instrument_no    NUMBER;

    v_product_id       VARCHAR2(10);
    v_product_name     VARCHAR2(100);
    v_product_type     VARCHAR2(50);
    v_site             VARCHAR2(100);

    v_parameter_id     VARCHAR2(10);
    v_parameter_name   VARCHAR2(100);
    v_unit             VARCHAR2(20);

    v_min              NUMBER;
    v_max              NUMBER;

    v_status            VARCHAR2(10);
    v_retest            VARCHAR2(5);
    v_priority          VARCHAR2(20);

    v_result_value      NUMBER;
    v_tat               NUMBER;

BEGIN

    FOR n IN 1..1010 LOOP

        --------------------------------------------------------
        -- PRODUCT ASSIGNMENT
        --------------------------------------------------------

        IF MOD(n,20) = 0 THEN

            -- Distribute OOS records across all 10 products
            v_product_no := MOD(TRUNC(n/20)-1,10) + 1;

        ELSE

            v_product_no := MOD(n-1,10) + 1;

        END IF;


        --------------------------------------------------------
        -- PRODUCT DETAILS
        --------------------------------------------------------

        v_product_id := 'P' || LPAD(v_product_no,3,'0');

        CASE v_product_no

            WHEN 1 THEN
                v_product_name := 'Paracetamol 500mg';
                v_product_type := 'Tablet';
                v_site := 'Chennai';

            WHEN 2 THEN
                v_product_name := 'Atorvastatin 20mg';
                v_product_type := 'Tablet';
                v_site := 'Pune';

            WHEN 3 THEN
                v_product_name := 'Amoxicillin 500mg';
                v_product_type := 'Capsule';
                v_site := 'Hyderabad';

            WHEN 4 THEN
                v_product_name := 'Metformin 500mg';
                v_product_type := 'Tablet';
                v_site := 'Bengaluru';

            WHEN 5 THEN
                v_product_name := 'Azithromycin 250mg';
                v_product_type := 'Tablet';
                v_site := 'Ahmedabad';

            WHEN 6 THEN
                v_product_name := 'Omeprazole 20mg';
                v_product_type := 'Capsule';
                v_site := 'Mumbai';

            WHEN 7 THEN
                v_product_name := 'Cetirizine 10mg';
                v_product_type := 'Tablet';
                v_site := 'Chennai';

            WHEN 8 THEN
                v_product_name := 'Pantoprazole 40mg';
                v_product_type := 'Tablet';
                v_site := 'Hyderabad';

            WHEN 9 THEN
                v_product_name := 'Ibuprofen 400mg';
                v_product_type := 'Tablet';
                v_site := 'Pune';

            WHEN 10 THEN
                v_product_name := 'Losartan 50mg';
                v_product_type := 'Tablet';
                v_site := 'Bengaluru';

        END CASE;


        --------------------------------------------------------
        -- PARAMETER ASSIGNMENT
        --------------------------------------------------------

        v_parameter_no := MOD(n-1,10) + 1;

        v_parameter_id := 'SP' || LPAD(v_parameter_no,3,'0');

        CASE v_parameter_no

            WHEN 1 THEN
                v_parameter_name := 'Assay';
                v_unit := '%';
                v_min := 98;
                v_max := 102;

            WHEN 2 THEN
                v_parameter_name := 'Related Substances';
                v_unit := '%';
                v_min := 0;
                v_max := 2;

            WHEN 3 THEN
                v_parameter_name := 'Dissolution';
                v_unit := '%';
                v_min := 80;
                v_max := 100;

            WHEN 4 THEN
                v_parameter_name := 'Uniformity';
                v_unit := '%';
                v_min := 85;
                v_max := 115;

            WHEN 5 THEN
                v_parameter_name := 'Moisture';
                v_unit := '%';
                v_min := 0;
                v_max := 5;

            WHEN 6 THEN
                v_parameter_name := 'pH';
                v_unit := 'pH';
                v_min := 5;
                v_max := 7;

            WHEN 7 THEN
                v_parameter_name := 'Average Weight';
                v_unit := 'mg';
                v_min := 450;
                v_max := 550;

            WHEN 8 THEN
                v_parameter_name := 'Hardness';
                v_unit := 'N';
                v_min := 50;
                v_max := 150;

            WHEN 9 THEN
                v_parameter_name := 'Friability';
                v_unit := '%';
                v_min := 0;
                v_max := 1;

            WHEN 10 THEN
                v_parameter_name := 'Disintegration';
                v_unit := 'min';
                v_min := 5;
                v_max := 30;

        END CASE;


        --------------------------------------------------------
        -- ANALYST
        --------------------------------------------------------

        v_analyst_no := MOD(n-1,10) + 1;


        --------------------------------------------------------
        -- INSTRUMENT
        --------------------------------------------------------

        v_instrument_no := MOD(n-1,12) + 1;


        --------------------------------------------------------
        -- RESULT STATUS
        --------------------------------------------------------

        IF MOD(n,20) = 0 THEN

            v_status := 'OOS';
            v_retest := 'Yes';

            -- Generate OOS value above specification maximum
            v_result_value := v_max + 2;

        ELSE

            v_status := 'PASS';
            v_retest := 'No';

            -- Generate value within specification
            v_result_value :=
                ROUND(
                    v_min +
                    ((v_max - v_min) * (MOD(n,80) / 100)),
                    3
                );

        END IF;


        --------------------------------------------------------
        -- PRIORITY
        --------------------------------------------------------

        IF MOD(n,20) = 0 THEN

            v_priority := 'Critical';

        ELSIF MOD(n,5) = 0 THEN

            v_priority := 'High';

        ELSE

            v_priority := 'Normal';

        END IF;


        --------------------------------------------------------
        -- TURNAROUND TIME
        --------------------------------------------------------

        v_tat := 4 + MOD(n,48);


        --------------------------------------------------------
        -- INSERT LABORATORY RESULT
        --------------------------------------------------------

        INSERT INTO LABORATORY_RESULTS
        (
            RESULT_ID,
            SAMPLE_ID,
            BATCH_ID,
            PRODUCT_ID,
            PRODUCT_NAME,
            PRODUCT_TYPE,
            MANUFACTURING_SITE,
            TEST_DATE,
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
            TURNAROUND_HOURS
        )
        VALUES
        (
            'RES' || LPAD(n,6,'0'),
            'SMP' || LPAD(n,6,'0'),
            'BATCH' || LPAD(MOD(n,100)+1,4,'0'),

            v_product_id,
            v_product_name,
            v_product_type,
            v_site,

            TRUNC(SYSDATE) - MOD(n,365),

            v_priority,

            v_parameter_id,
            v_parameter_name,
            v_unit,

            v_result_value,
            v_min,
            v_max,

            v_status,
            v_retest,

            'A' || LPAD(v_analyst_no,3,'0'),

            CASE v_analyst_no
                WHEN 1 THEN 'Arun Kumar'
                WHEN 2 THEN 'Priya Sharma'
                WHEN 3 THEN 'Rahul Menon'
                WHEN 4 THEN 'Divya Krishnan'
                WHEN 5 THEN 'Karthik Raj'
                WHEN 6 THEN 'Meena Iyer'
                WHEN 7 THEN 'Vijay Kumar'
                WHEN 8 THEN 'Sneha Rao'
                WHEN 9 THEN 'Suresh Babu'
                WHEN 10 THEN 'Anitha Devi'
            END,

            CASE v_analyst_no
                WHEN 1 THEN 5.5
                WHEN 2 THEN 4.0
                WHEN 3 THEN 6.5
                WHEN 4 THEN 3.5
                WHEN 5 THEN 7.0
                WHEN 6 THEN 5.0
                WHEN 7 THEN 4.5
                WHEN 8 THEN 3.0
                WHEN 9 THEN 8.0
                WHEN 10 THEN 2.5
            END,

            'INS' || LPAD(v_instrument_no,3,'0'),

            CASE v_instrument_no
                WHEN 1 THEN 'Agilent HPLC System'
                WHEN 2 THEN 'Waters HPLC System'
                WHEN 3 THEN 'Shimadzu HPLC System'
                WHEN 4 THEN 'Dissolution Tester'
                WHEN 5 THEN 'Karl Fischer Titrator'
                WHEN 6 THEN 'Analytical Balance'
                WHEN 7 THEN 'Tablet Hardness Tester'
                WHEN 8 THEN 'Friability Tester'
                WHEN 9 THEN 'Disintegration Tester'
                WHEN 10 THEN 'UV Spectrophotometer'
                WHEN 11 THEN 'Metrohm pH Meter'
                WHEN 12 THEN 'Shimadzu UV Spectrophotometer'
            END,

            CASE v_instrument_no
                WHEN 1 THEN 'HPLC'
                WHEN 2 THEN 'HPLC'
                WHEN 3 THEN 'HPLC'
                WHEN 4 THEN 'Dissolution Tester'
                WHEN 5 THEN 'Karl Fischer'
                WHEN 6 THEN 'Analytical Balance'
                WHEN 7 THEN 'Hardness Tester'
                WHEN 8 THEN 'Friability Tester'
                WHEN 9 THEN 'Disintegration Tester'
                WHEN 10 THEN 'UV Spectrophotometer'
                WHEN 11 THEN 'pH Meter'
                WHEN 12 THEN 'UV Spectrophotometer'
            END,

            v_tat
        );

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE('LABORATORY QC DATA GENERATION COMPLETED');
    DBMS_OUTPUT.PUT_LINE('Records Generated : 1,010');
    DBMS_OUTPUT.PUT_LINE('OOS Records       : 50');
    DBMS_OUTPUT.PUT_LINE('PASS Records      : 960');
    DBMS_OUTPUT.PUT_LINE('==============================================');

END;
/
