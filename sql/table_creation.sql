-- ============================================================
-- PHARMACEUTICAL LABORATORY QC ANALYTICS
-- TABLE CREATION SCRIPT
-- Oracle SQL / SQL*Plus
-- ============================================================

-- ------------------------------------------------------------
-- 1. PRODUCTS
-- ------------------------------------------------------------

CREATE TABLE PRODUCTS (
    PRODUCT_ID          VARCHAR2(10) PRIMARY KEY,
    PRODUCT_NAME        VARCHAR2(100) NOT NULL,
    PRODUCT_TYPE        VARCHAR2(50),
    MANUFACTURING_SITE  VARCHAR2(100)
);


-- ------------------------------------------------------------
-- 2. SPECIFICATIONS
-- ------------------------------------------------------------

CREATE TABLE SPECIFICATIONS (
    PARAMETER_ID      VARCHAR2(10) PRIMARY KEY,
    PARAMETER_NAME    VARCHAR2(100) NOT NULL,
    UNIT              VARCHAR2(20),
    SPECIFICATION_MIN NUMBER(12,3),
    SPECIFICATION_MAX NUMBER(12,3),
    TEST_METHOD       VARCHAR2(100)
);


-- ------------------------------------------------------------
-- 3. ANALYSTS
-- ------------------------------------------------------------

CREATE TABLE ANALYSTS (
    ANALYST_ID              VARCHAR2(10) PRIMARY KEY,
    ANALYST_NAME            VARCHAR2(100) NOT NULL,
    ANALYST_EXPERIENCE_YEARS NUMBER(4,1),
    DEPARTMENT              VARCHAR2(100)
);


-- ------------------------------------------------------------
-- 4. INSTRUMENTS
-- ------------------------------------------------------------

CREATE TABLE INSTRUMENTS (
    INSTRUMENT_ID    VARCHAR2(10) PRIMARY KEY,
    INSTRUMENT_NAME  VARCHAR2(100) NOT NULL,
    INSTRUMENT_TYPE  VARCHAR2(50),
    MANUFACTURER     VARCHAR2(100)
);


-- ------------------------------------------------------------
-- 5. LABORATORY_RESULTS
-- Central Laboratory QC Fact Table
-- ------------------------------------------------------------

CREATE TABLE LABORATORY_RESULTS (
    RESULT_ID                  VARCHAR2(15) PRIMARY KEY,
    SAMPLE_ID                  VARCHAR2(15) NOT NULL,
    BATCH_ID                   VARCHAR2(20) NOT NULL,

    PRODUCT_ID                 VARCHAR2(10),
    PRODUCT_NAME               VARCHAR2(100),
    PRODUCT_TYPE               VARCHAR2(50),
    MANUFACTURING_SITE         VARCHAR2(100),

    TEST_DATE                  DATE,
    PRIORITY                   VARCHAR2(20),

    PARAMETER_ID               VARCHAR2(10),
    PARAMETER_NAME             VARCHAR2(100),
    UNIT                       VARCHAR2(20),

    RESULT_VALUE               NUMBER(12,3),
    SPECIFICATION_MIN          NUMBER(12,3),
    SPECIFICATION_MAX          NUMBER(12,3),

    RESULT_STATUS              VARCHAR2(10),
    RETEST_FLAG                VARCHAR2(5),

    ANALYST_ID                 VARCHAR2(10),
    ANALYST_NAME               VARCHAR2(100),
    ANALYST_EXPERIENCE_YEARS   NUMBER(4,1),

    INSTRUMENT_ID              VARCHAR2(10),
    INSTRUMENT_NAME            VARCHAR2(100),
    INSTRUMENT_TYPE            VARCHAR2(50),

    TURNAROUND_HOURS           NUMBER(10,1)
);


-- ============================================================
-- CONSTRAINTS
-- ============================================================

-- Laboratory Result Status
ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_STATUS_CH
CHECK (RESULT_STATUS IN ('PASS','OOS'));


-- Retest Flag
ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_RETEST_CH
CHECK (RETEST_FLAG IN ('Yes','No'));


-- Priority
ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_PRIORITY_CH
CHECK (PRIORITY IN ('Normal','High','Critical'));


-- Turnaround Time
ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_TAT_CH
CHECK (TURNAROUND_HOURS >= 0);


-- ============================================================
-- FOREIGN KEY CONSTRAINTS
-- ============================================================

ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_PRODUCT_FK
FOREIGN KEY (PRODUCT_ID)
REFERENCES PRODUCTS(PRODUCT_ID);


ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_PARAMETER_FK
FOREIGN KEY (PARAMETER_ID)
REFERENCES SPECIFICATIONS(PARAMETER_ID);


ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_ANALYST_FK
FOREIGN KEY (ANALYST_ID)
REFERENCES ANALYSTS(ANALYST_ID);


ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_INSTRUMENT_FK
FOREIGN KEY (INSTRUMENT_ID)
REFERENCES INSTRUMENTS(INSTRUMENT_ID);


-- ============================================================
-- NOT NULL CONSTRAINTS
-- ============================================================

ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_SAMPLE_NN
CHECK (SAMPLE_ID IS NOT NULL);


ALTER TABLE LABORATORY_RESULTS
ADD CONSTRAINT LR_BATCH_NN
CHECK (BATCH_ID IS NOT NULL);


-- ============================================================
-- END OF TABLE CREATION SCRIPT
-- ============================================================
