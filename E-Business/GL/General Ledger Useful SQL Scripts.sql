GL Set of Books Configuration Overview
 
SELECT SOB.SET_OF_BOOKS_ID "ID"
,      SOB.NAME
,      SOB.SHORT_NAME
,      SOB.DESCRIPTION
,      SOB.CHART_OF_ACCOUNTS_ID "COA ID"
,      FST.ID_FLEX_STRUCTURE_CODE "CHART OF ACCOUNTS"
,      SOB.CURRENCY_CODE "CURR"
,      PT.USER_PERIOD_TYPE "PERIOD"
,      SOB.PERIOD_SET_NAME
,      SOB.FUTURE_ENTERABLE_PERIODS_LIMIT "FUT. PER"
,      SOB.LATEST_OPENED_PERIOD_NAME "LATEST OPEN"
,      SOB.ATTRIBUTE1"OPERATIONAL BOOK"
,      SOB.ATTRIBUTE2"PPL ?"
,      SOB.ENABLE_REVAL_SS_TRACK_FLAG||'.'||ENABLE_SECONDARY_TRACK_FLAG"SEC SEG TRACK?"
,      RET.SEGMENT1||'-'||RET.SEGMENT2||'-'||RET.SEGMENT3||'-'||RET.SEGMENT4||'-'||RET.SEGMENT5||'-'||RET.SEGMENT6 "RETAINED EARNINGS"
,      TRAN.SEGMENT1||'-'||TRAN.SEGMENT2||'-'||TRAN.SEGMENT3||'-'||TRAN.SEGMENT4||'-'||TRAN.SEGMENT5||'-'||TRAN.SEGMENT6 "TRAN EARNINGS"
,      '---JOURNALS---'
,      SOB.ALLOW_INTERCOMPANY_POST_FLAG"INTERCO?"
,      SOB.ENABLE_JE_APPROVAL_FLAG"JRNL APP?"
,      SOB.ENABLE_AUTOMATIC_TAX_FLAG"AUTO TAX?"
,      SOB.SUSPENSE_ALLOWED_FLAG"SUSP?"
,      SOB.TRACK_ROUNDING_IMBALANCE_FLAG"TRK RND?"
,      '---AV BAL---'
,      SOB.ENABLE_AVERAGE_BALANCES_FLAG||SOB.CONSOLIDATION_SOB_FLAG||SOB.TRANSACTION_CALENDAR_ID||SOB.NET_INCOME_CODE_COMBINATION_ID
       ||SOB.DAILY_TRANSLATION_RATE_TYPE||SOB.TRANSLATE_EOD_FLAG||SOB.TRANSLATE_QATD_FLAG||SOB.TRANSLATE_YATD_FLAG "NOT USED"
,      '---BUDGET CNTL---'
,      SOB.ENABLE_BUDGETARY_CONTROL_FLAG||SOB.REQUIRE_BUDGET_JOURNALS_FLAG||SOB.RES_ENCUMB_CODE_COMBINATION_ID "NOT USED"
,      '---MRC---'
,      SOB.MRC_SOB_TYPE_CODE "NOT USED"
FROM GL_SETS_OF_BOOKS SOB, FND_ID_FLEX_STRUCTURES FST, GL_CODE_COMBINATIONS TRAN, GL_CODE_COMBINATIONS RET, GL_PERIOD_TYPES PT
WHERE FST.ID_FLEX_NUM = SOB.CHART_OF_ACCOUNTS_ID
AND RET.CODE_COMBINATION_ID(+) =  SOB.RET_EARN_CODE_COMBINATION_ID
AND TRAN.CODE_COMBINATION_ID(+) =  SOB.CUM_TRANS_CODE_COMBINATION_ID
AND PT.PERIOD_TYPE = SOB.ACCOUNTED_PERIOD_TYPE
--AND SUBSTR(SOB.SHORT_NAME,1,2) IN ('BE','LU','ES','IT','HU','CZ','PL','RU')
ORDER BY 2




GL Summary Account Template Definition Review
 
SELECT SOB.NAME
,      ST.TEMPLATE_NAME
,      ST.CONCATENATED_DESCRIPTION
,      ST.ACCOUNT_CATEGORY_CODE"CAT"
,      ST.START_ACTUALS_PERIOD_NAME "FROM"
,      ST.SEGMENT1_TYPE||'-'||ST.SEGMENT2_TYPE||'-'||ST.SEGMENT3_TYPE||'-'||ST.SEGMENT4_TYPE||'-'||ST.SEGMENT5_TYPE||'-'||
       ST.SEGMENT6_TYPE||'-'||ST.SEGMENT7_TYPE||'-'||ST.SEGMENT8_TYPE||'-'||ST.SEGMENT9_TYPE||'-'||ST.SEGMENT10_TYPE "SEGMENT TYPE"
FROM GL_SUMMARY_TEMPLATES ST, GL_SETS_OF_BOOKS SOB
WHERE ST.SET_OF_BOOKS_ID = SOB.SET_OF_BOOKS_ID
--AND SUBSTR(SOB.NAME,1,2) IN ('ES','BE','LU')
GL Segment Value Listing
 
SELECT FFVS1.FLEX_VALUE_SET_NAME
--,   FFVS1.FLEX_VALUE_SET_ID
,     FFVAL1.FLEX_VALUE"VALUE"
,     FFVAL1.SUMMARY_FLAG"PARENT ACC ?"
,     FFVTL1.DESCRIPTION
,     FFVAL1.ENABLED_FLAG
,     FH.HIERARCHY_CODE
,     SUBSTR(TO_CHAR(FFVAL1.COMPILED_VALUE_ATTRIBUTES),1,1)"BUDGET"
,     SUBSTR(TO_CHAR(FFVAL1.COMPILED_VALUE_ATTRIBUTES),3,1)"POST"
,     SUBSTR(TO_CHAR(FFVAL1.COMPILED_VALUE_ATTRIBUTES),5,1)"TYPE"
,     SUBSTR(TO_CHAR(FFVAL1.COMPILED_VALUE_ATTRIBUTES),7,1)"CNTL"
,     SUBSTR(TO_CHAR(FFVAL1.COMPILED_VALUE_ATTRIBUTES),9,1)"RECON"
--SELECT DISTINCT FFVS1.FLEX_VALUE_SET_NAME
, FFVAL1.LAST_UPDATED_BY
, FFVAL1.LAST_UPDATE_DATE
FROM FND_FLEX_VALUES FFVAL1
, FND_FLEX_VALUES_TL FFVTL1
, FND_FLEX_VALUE_SETS FFVS1
, FND_ID_FLEX_SEGMENTS SEG
, FND_FLEX_HIERARCHIES_VL FH
WHERE FFVAL1.FLEX_VALUE_SET_ID(+) = FFVS1.FLEX_VALUE_SET_ID
AND SEG.FLEX_VALUE_SET_ID = FFVS1.FLEX_VALUE_SET_ID
AND SEG.ID_FLEX_NUM = 51974 /* COA ID IS NEEDED IF SEGMENT IS CHART IN MULTPLE COA.  UPDATE FOR YOU CONFIGURATION OR REMOVE IF NOT APPLICABLE. */
AND FFVAL1.FLEX_VALUE_ID = FFVTL1.FLEX_VALUE_ID(+)
AND FFVS1.FLEX_VALUE_SET_NAME = 'OPERATIONS ACCOUNT'
AND FFVAL1.STRUCTURED_HIERARCHY_LEVEL = FH.HIERARCHY_ID(+)
--AND SUBSTR(TO_CHAR(FFVAL1.COMPILED_VALUE_ATTRIBUTES),7,1) != 'N' -- NON-CONTROL ACCOUNTS ONLY
--AND SUBSTR(TO_CHAR(FFVAL1.COMPILED_VALUE_ATTRIBUTES),7,1) = 'Y' -- CONTROL ACCOUNTS ONLY
--AND FFVAL1.SUMMARY_FLAG = 'Y'
--AND FFVAL1.FLEX_VALUE >= '8000'
--AND FFVAL1.FLEX_VALUE <= '99999'
--AND FFVTL1.DESCRIPTION LIKE '%FTE%'
--AND FFVAL1.FLEX_VALUE LIKE '16%'
ORDER BY FFVS1.FLEX_VALUE_SET_NAME, FFVAL1.FLEX_VALUE





GL Period Status
SELECT SOB.SHORT_NAME
,      PS.PERIOD_NAME
,      PS.SHOW_STATUS
,      PS.START_DATE||' TO '||PS.END_DATE    
,      PS.PERIOD_YEAR
,      PS.PERIOD_NUM
FROM GL_PERIOD_STATUSES_V PS, GL_SETS_OF_BOOKS SOB
WHERE PS.SET_OF_BOOKS_ID = SOB.SET_OF_BOOKS_ID
AND APPLICATION_ID = 101
--AND PERIOD_YEAR = 2006
--AND SUBSTR(SOB.SHORT_NAME,1,2) IN ('ES','LU','BE')
AND PS.SHOW_STATUS NOT IN ('NEVER OPENED')
ORDER BY 1,5,6 DESC
 
SELECT SOB.SHORT_NAME
,      PS.PERIOD_NAME
,      PS.START_DATE
,      PS.END_DATE      
,      PS.PERIOD_YEAR
,      PS.PERIOD_NUM
,      PS.SHOW_STATUS
FROM GL_PERIOD_STATUSES_V PS, GL_SETS_OF_BOOKS SOB
WHERE PS.SET_OF_BOOKS_ID = SOB.SET_OF_BOOKS_ID
AND APPLICATION_ID = 101
AND PERIOD_YEAR = 2006
--AND SUBSTR(SOB.SHORT_NAME,1,2) IN ('GB')
ORDER BY 1,5,6 DESC





GL Chart of Accounts Structure
 
SELECT  FST.ID_FLEX_STRUCTURE_NAME
--,    FST.DESCRIPTION
--,    FST.ID_FLEX_NUM
--,    FST.ID_FLEX_STRUCTURE_CODE
,      FST.CROSS_SEGMENT_VALIDATION_FLAG"X-VAL"
,      FST.FREEZE_STRUCTURED_HIER_FLAG"FZ-HIER"
,      FST.FREEZE_FLEX_DEFINITION_FLAG"FZ-DEFN"
,      FSEG.SEGMENT_NUM "SEG#"
,      FSEG.SEGMENT_NAME "SEG NAME"
,      VS.FLEX_VALUE_SET_NAME "VALUE SET"
,      FSEG.FLEX_VALUE_SET_ID"VAL_SET_ID"
,      FSEG.DEFAULT_TYPE"DEF TYPE"
,      FSEG.DEFAULT_VALUE"DEF. VALUE"
,      FSEG.ENABLED_FLAG"ENBLD"
,      FSEG.REQUIRED_FLAG"REQD"
FROM FND_ID_FLEX_STRUCTURES_VL FST, FND_ID_FLEX_SEGMENTS FSEG, FND_FLEX_VALUE_SETS VS
WHERE FST.ID_FLEX_NUM = FSEG.ID_FLEX_NUM
AND FSEG.FLEX_VALUE_SET_ID = VS.FLEX_VALUE_SET_ID
--AND SUBSTR(FST.ID_FLEX_STRUCTURE_CODE,1,2) IN ('BE','LU','ES','IT','HU','CZ','PL','RU')
AND FST.APPLICATION_ID = 101
AND FST.ID_FLEX_CODE = 'GL#'
ORDER BY 1, FSEG.SEGMENT_NUM




GL Chart of Accounts Structure Overview
 
/* CHART OF ACCOUNTS STRUCTURE
GIVES AN OVERVIEW OF THE CHART OF ACCOUNTS DEFINITIONS AND ALSO STATUS.  
THIS IS USED WHEN IMPLEMENTING MULTIPLE CHARTS OF ACCOUNTS TO ENSURE CONSISTENT SETUP ACROSS COUNTRIES AND BETWEEN ENVIRONMENTS.
WHERE CLAUSE CAN BE ADDED OR COMMENTED OUT TO JUST LOOK AT SPECIFIC COUNTRIES. */
 
SELECT  FST.ID_FLEX_STRUCTURE_NAME
--,    FST.DESCRIPTION
--,    FST.ID_FLEX_NUM
--,    FST.ID_FLEX_STRUCTURE_CODE
,      FST.CROSS_SEGMENT_VALIDATION_FLAG"X-VAL"
,      FST.FREEZE_STRUCTURED_HIER_FLAG"FZ-HIER"
,      FST.FREEZE_FLEX_DEFINITION_FLAG"FZ-DEFN"
,      FSEG.SEGMENT_NUM "SEG#"
,      FSEG.SEGMENT_NAME "SEG NAME"
,      VS.FLEX_VALUE_SET_NAME "VALUE SET"
,      FSEG.FLEX_VALUE_SET_ID"VAL_SET_ID"
,      FSEG.DEFAULT_TYPE"DEF TYPE"
,      FSEG.DEFAULT_VALUE"DEF. VALUE"
,      FSEG.ENABLED_FLAG"ENBLD"
,      FSEG.REQUIRED_FLAG"REQD"
FROM FND_ID_FLEX_STRUCTURES_VL FST, FND_ID_FLEX_SEGMENTS FSEG, FND_FLEX_VALUE_SETS VS
WHERE FST.ID_FLEX_NUM = FSEG.ID_FLEX_NUM
AND FSEG.FLEX_VALUE_SET_ID = VS.FLEX_VALUE_SET_ID
--AND SUBSTR(FST.ID_FLEX_STRUCTURE_CODE,1,2) IN ('BE','LU','ES','IT','HU','CZ','PL','RU')
AND FST.APPLICATION_ID = 101
AND FST.ID_FLEX_CODE = 'GL#'
ORDER BY 1, FSEG.SEGMENT_NUM



GL Journal Header Summary
/* GL JOURNAL HEADER SUMMARY
SUMMARY LISTING OF JOURNAL HEADER RECORDS BY CATEGORY AND SOURCE ACROSS MULTIPLE SETS OF BOOKS.
 */
 
SELECT SOB.SHORT_NAME"BOOK"
,      GJH.STATUS
,      GJH.POSTED_DATE
,      GJH.CREATION_DATE
,      GLS.USER_JE_SOURCE_NAME"SOURCE"
,      GLC.USER_JE_CATEGORY_NAME"CATEGORY"
,      GJH.PERIOD_NAME"PERIOD"
,      GJB.NAME"BATCH NAME"
,      GJH.NAME"JOURNAL NAME"
,      GJH.CURRENCY_CODE"CURRENCY"
FROM GL_JE_BATCHES GJB, GL_JE_HEADERS GJH,GL_SETS_OF_BOOKS SOB,
     GL_JE_SOURCES GLS, GL_JE_CATEGORIES GLC
WHERE GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
AND GJH.SET_OF_BOOKS_ID = SOB.SET_OF_BOOKS_ID
AND GLS.JE_SOURCE_NAME = GJH.JE_SOURCE
AND  GLC.JE_CATEGORY_NAME = GJH.JE_CATEGORY
--AND GJH.NAME     = 'QUV-DECLARATION TVA 11/04'  -- JOURNAL NAME   
--AND GLS.USER_JE_SOURCE_NAME LIKE '%MASS%'     -- JOURNAL SOURCE
--AND GLC.USER_JE_CATEGORY_NAME= 'ADJUSTMENT'   -- JOURNAL CATEGORY
--AND GJH.PERIOD_NAME IN ('MAY-06')             -- JOURNAL PERIOD
AND (TRUNC(GJH.CREATION_DATE) >= TO_DATE('01/07/2002','DD/MM/YYYY')
    OR TRUNC(GJH.POSTED_DATE) >= TO_DATE('01/07/2002','DD/MM/YYYY'))
--AND SUBSTR(SOB.SHORT_NAME,1,2) IN ('DE')
ORDER BY 1,2 DESC,3,4,5,7



GL Journal Line Based Trial Balance Report
/* GL JOURNAL BASED TRIAL BALANCE
CREATES A TRIAL BALANCE BASED ON JOURNAL LINES.  CAN BE USED FOR NERVOUS DATA CONVERSION MANAGERS AS YOU CAN SEE THE IMPACT
OF JOURNALS ON ACCOUNT BALANCES WITHOUT THE NEED TO POST THE JOURNALS.
*/
 
SELECT SOB.SHORT_NAME
,      SOB.NAME
,      GJH.NAME
,      GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6||'-'||GCC.SEGMENT7||'-'||GCC.SEGMENT8||'-'||GCC.SEGMENT9 "ACCOUNT"
,      GJH.CURRENCY_CODE
,      SUM(GJL.ACCOUNTED_DR)"DR"
,      SUM(GJL.ACCOUNTED_CR)"CR"
,      SUM( NVL(GJL.ACCOUNTED_DR,0) - NVL(GJL.ACCOUNTED_CR,0))"END BALANCE"
,      GJL.PERIOD_NAME
FROM GL_JE_LINES GJL
,    GL_JE_HEADERS GJH
,    GL_CODE_COMBINATIONS GCC
,    GL_SETS_OF_BOOKS SOB
WHERE GJL.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
AND GJL.JE_HEADER_ID = GJH.JE_HEADER_ID
AND GJL.SET_OF_BOOKS_ID = GJH.SET_OF_BOOKS_ID
AND SOB.SET_OF_BOOKS_ID = GJH.SET_OF_BOOKS_ID
AND SOB.SET_OF_BOOKS_ID = GJL.SET_OF_BOOKS_ID
AND GJL.PERIOD_NAME = 'JUL-03'
--AND SOB.SHORT_NAME = 'GBMAN'
--AND GJH.NAME LIKE '%PPL%'
--AND GCC.SEGMENT1 = '85'
--AND GCC.SEGMENT2 = '70'
--AND GCC.SEGMENT3 = '0000'
--AND GCC.SEGMENT4 = '88165'
--AND GJH.STATUS = 'P'
--AND GJL.EFFECTIVE_DATE >= TO_DATE('06/04/2002','DD/MM/YYYY')
--AND GJL.EFFECTIVE_DATE <= TO_DATE('30/11/2002','DD/MM/YYYY')
GROUP BY SOB.SHORT_NAME, SOB.NAME, GJH.NAME
, GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6||'-'||GCC.SEGMENT7||'-'||GCC.SEGMENT8||'-'||GCC.SEGMENT9
,GJH.CURRENCY_CODE, GJL.PERIOD_NAME






GL Journal Lines With AP Source Reference Fields
/* GL JOURNAL LINES WITH AP SOURCE REFERENCE FIELDS
 
*/
 
SELECT SOB.SHORT_NAME"BOOK"
,      GLS.USER_JE_SOURCE_NAME"SOURCE"
,      GLC.USER_JE_CATEGORY_NAME"CATEGORY"
,      GJB.NAME"BATCH NAME"
,      GJH.NAME"JOURNAL NAME"
,      GJH.CURRENCY_CODE"CURRENCY"
,      GJL.JE_LINE_NUM"JRNL LINE#"
,      GJL.EFFECTIVE_DATE"ACCOUNTING DATE"
,      GJH.PERIOD_NAME"PERIOD"
,      GJH.DATE_CREATED"CREATED DATE"
,      GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6
       ||'-'||GCC.SEGMENT7||'-'||GCC.SEGMENT8||'-'||GCC.SEGMENT9||'-'||GCC.SEGMENT10 "ACCOUNT COMBINATION"
,      GJL.ENTERED_DR
,      GJL.ENTERED_CR
,      GJL.ACCOUNTED_DR
,      GJL.ACCOUNTED_CR
,      GJH.CURRENCY_CONVERSION_RATE"CONV RATE"
,      GJH.CURRENCY_CONVERSION_DATE"CONV DATE"
,      GJH.CURRENCY_CONVERSION_TYPE"CONV TYPE"
,      GJL.DESCRIPTION
,      GJL.REFERENCE_1"AP VAND NAME"
,      GJL.REFERENCE_2"AP INV_ID"
,      GJL.REFERENCE_3"AP INV LINE#CHEQUEID"
,      GJL.REFERENCE_4"AP PAYDOC#"
,      GJL.REFERENCE_5"AP INVOICE #"
,      GJL.REFERENCE_6"AP ACCOUNTING TYPE"
,      GJL.REFERENCE_7"AP SOURCE ID"
,      GJL.REFERENCE_8"AP NA"
,      GJL.REFERENCE_9"AP DOCUMENT ID"
,      GJL.REFERENCE_10"AP LINE TYPE"
FROM GL_JE_BATCHES GJB, GL_JE_HEADERS GJH, GL_JE_LINES GJL,GL_CODE_COMBINATIONS GCC, GL_SETS_OF_BOOKS SOB,
     GL_JE_SOURCES GLS, GL_JE_CATEGORIES GLC
WHERE GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
AND GJB.JE_BATCH_ID = GJH.JE_BATCH_ID
AND GCC.CODE_COMBINATION_ID = GJL.CODE_COMBINATION_ID
AND GJH.SET_OF_BOOKS_ID = SOB.SET_OF_BOOKS_ID
AND GLS.JE_SOURCE_NAME = GJH.JE_SOURCE
AND  GLC.JE_CATEGORY_NAME = GJH.JE_CATEGORY
AND GLS.USER_JE_SOURCE_NAME = 'Payables'
and GJH.PERIOD_NAME = 'JUL-04'
--and sob.set_of_books_id = 87
order by 1,2,3,4,5,7
 
 
 
 
GL Mass Allocation Rule Migration Script in Dataload Classic Format
/* MASS ALLOCATION MIGRATION - DATALOAD CLASSIC LAYOUT
 
CREATES A PRE-FORMATED SPREADSHEET LAYOUT TO MIGRATE MASS ALLOCATIONS BETWEEN ENVIRONMENTS AND/OR BOOKS USING DATALOAD CLASSIC.
IT HAS BEEN WRITTEN FOR A 10 SEGMENT COA BUT CAN BE MODIFIED TO SUIT DIFFERENT STRUCTURES.
*/
 
SELECT SUBSTR(FST.ID_FLEX_STRUCTURE_CODE,1,2)"BOOK"
,      GAB.NAME "ALLOCATION NAME"
/*, (CASE WHEN GAFL.LINE_NUMBER = 1 THEN  GAB.NAME  ELSE NULL END )"ALLOCATION NAME"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN  'TAB' ELSE NULL END )"TAB"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN 'A' ELSE NULL END )"A"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN   'TAB' ELSE NULL END )"TAB"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN  GAB.DESCRIPTION  ELSE NULL END )"ALLOC DESCRIPTION"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN   '*AR' ELSE NULL END )"TAB"
,*/ 
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN  '\'||GAF.NAME  ELSE NULL END )"FORMULA NAME"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN 'TAB' ELSE NULL END )"TAB"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN 'ALLOCATION' ELSE NULL END )"ALLOCATION"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN 'TAB' ELSE NULL END )"TAB"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN  GAF.DESCRIPTION  ELSE NULL END )"FORMULA DESC"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN 'TAB' ELSE NULL END )"TAB"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN 'TAB' ELSE NULL END )"TAB"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN '*SB' ELSE NULL END )"FCP"
,   (CASE WHEN GAFL.LINE_NUMBER = 1 THEN 'TAB' ELSE NULL END )"TAB"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN (CASE WHEN GAFL.LINE_NUMBER IN (1,2,3,4) THEN 'TAB' ELSE NULL END )ELSE NULL END )"TAB"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT1 ELSE '\'||TO_CHAR(GAFL.AMOUNT) END )"1"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,0,1) ELSE NULL END )"1T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT2 ELSE NULL END )"2"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,3,1)ELSE NULL END )"2T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT3 ELSE NULL END )"3"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,5,1)ELSE NULL END )"3T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT4 ELSE NULL END )"4"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,7,1)ELSE NULL END )"4T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT5 ELSE NULL END )"5"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,9,1)ELSE NULL END )"5T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT6 ELSE NULL END )"6"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,11,1)ELSE NULL END )"6T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT7 ELSE NULL END )"7"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,13,1)ELSE NULL END )"7T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT8 ELSE NULL END )"8"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,15,1)ELSE NULL END )"8T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT9 ELSE NULL END )"9"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,17,1)ELSE NULL END )"9T"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||GAFL.SEGMENT10 ELSE NULL END )"10"
,      (CASE WHEN GAFL.AMOUNT IS NULL THEN '\'||SUBSTR(GAFL.SEGMENT_TYPES_KEY,19,1)ELSE NULL END )"10T"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (1,2,3,4,5) THEN 'ENT' ELSE NULL END )ELSE NULL END )"TAB1"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (1,2,3,4) THEN GAFL.CURRENCY_CODE ELSE NULL END )ELSE NULL END )"CURR"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (1,2,3,4) THEN 'TAB' ELSE NULL END )ELSE NULL END)"TAB2"
,   (CASE WHEN GAFL.AMOUNT IS NOT NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (2) THEN 'TAB' ELSE NULL END )ELSE NULL END)"TAB2"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (1,2,3) THEN GAFL.AMOUNT_TYPE ELSE NULL END )ELSE NULL END )"PTD/YTD"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (1,2) THEN '\{TAB 3}' ELSE (CASE WHEN GAFL.LINE_NUMBER IN (3) THEN '\{TAB 2}' ELSE NULL END) END)ELSE NULL END )"TAB3"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (5) THEN '*SAVE' ELSE NULL END )ELSE NULL END )"*SAVE"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (5) THEN '*PB' ELSE NULL END )ELSE NULL END )"*PB"
,   (CASE WHEN GAFL.AMOUNT IS NULL THEN(CASE WHEN GAFL.LINE_NUMBER IN (5) THEN '*NR' ELSE NULL END )ELSE NULL END )"*NR"
FROM GL_ALLOC_BATCHES GAB, GL_ALLOC_FORMULAS GAF, GL_ALLOC_FORMULA_LINES GAFL, FND_ID_FLEX_STRUCTURES_VL FST
WHERE GAB.ALLOCATION_BATCH_ID = GAF.ALLOCATION_BATCH_ID
AND GAB.CHART_OF_ACCOUNTS_ID = FST.ID_FLEX_NUM
AND GAF.ALLOCATION_FORMULA_ID = GAFL.ALLOCATION_FORMULA_ID
--AND SUBSTR(FST.ID_FLEX_STRUCTURE_CODE,1,2) IN ('DE')
ORDER BY 1,GAB.NAME, GAF.NAME, GAFL.LINE_NUMBER
 
     
     
     
     
GL Balances and Movements
/* GL BALANCES & MOVEMENTS
 
GIVES A TRIAL BALANCE WITH OPENING, MOVEMENT AND CLOSING BALANCES FOR UPTO TEN SEGMENTS IN THE CHART OF ACCOUNTS BY CURRENCY.
THIS CAN BE USED TO AS A QUICK METHOD OF RUNNING A TRIAL BALANCE FOR DATA EXTRACT IN THE DESIRED FORMAT. 
FOR EXAMPLE TO USE TO EXTRACT TO A THIRD PARTY REPORTING SYSTEM SUCH AS HYPERION
IT IS RECOMMENDED THAT THIS SCRIPT IS RUN FOR A SINGLE PERIOD AND BOOK FIRST TO GAUGE PERFORMANCE IN YOUR ENVIRONMENT.
*/
 
SELECT SOB.NAME
,      GB.ACTUAL_FLAG
,      GB.PERIOD_NAME
,      GCC.CODE_COMBINATION_ID
,      GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6
       ||'-'||GCC.SEGMENT7||'-'||GCC.SEGMENT8||'-'||GCC.SEGMENT9||'-'||GCC.SEGMENT10 "DISTRIBUTION"
,SUM( NVL(GB.BEGIN_BALANCE_DR,0) - NVL(GB.BEGIN_BALANCE_CR,0))"OPEN BAL"
,NVL(GB.PERIOD_NET_DR,0) "DEBIT"
,NVL(GB.PERIOD_NET_CR,0) "CREDIT"
,SUM( NVL(GB.PERIOD_NET_DR,0) - NVL(GB.PERIOD_NET_CR,0))"NET MOVEMENT"
,SUM(( NVL(GB.PERIOD_NET_DR,0) + NVL(GB.BEGIN_BALANCE_DR,0))) - SUM(NVL(GB.PERIOD_NET_CR,0)+NVL(GB.BEGIN_BALANCE_CR,0))"CLOSE BAL"
,      GB.CURRENCY_CODE
,      GB.TRANSLATED_FLAG
,      GB.TEMPLATE_ID
FROM GL_BALANCES GB, GL_CODE_COMBINATIONS GCC, GL_SETS_OF_BOOKS SOB
WHERE GCC.CODE_COMBINATION_ID = GB.CODE_COMBINATION_ID
AND  GB.ACTUAL_FLAG = 'A'
AND    GB.CURRENCY_CODE = SOB.CURRENCY_CODE
AND  GB.TEMPLATE_ID IS NULL
AND GB.SET_OF_BOOKS_ID = SOB.SET_OF_BOOKS_ID
AND  GB.PERIOD_NAME = 'APR-04'
AND SUBSTR(SOB.SHORT_NAME,1,2) IN ('PR')
--AND GCC.SEGMENT1 = '85'
--AND GCC.SEGMENT2 = '70'
--AND GCC.SEGMENT3 = '0000'
--AND GCC.SEGMENT4 IN ('99659')
--AND GCC.SEGMENT7 = 'T'
--AND     NVL(GB.TRANSLATED_FLAG,'X') != 'R'
GROUP BY  SOB.NAME
,      GB.ACTUAL_FLAG
,      GB.PERIOD_NAME
,      GCC.CODE_COMBINATION_ID
,      GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6
       ||'-'||GCC.SEGMENT7||'-'||GCC.SEGMENT8||'-'||GCC.SEGMENT9||'-'||GCC.SEGMENT10
,      NVL(GB.PERIOD_NET_DR,0)
,      NVL(GB.PERIOD_NET_CR,0)
,      GB.CURRENCY_CODE
,      GB.TRANSLATED_FLAG
,      GB.TEMPLATE_ID
HAVING SUM(( NVL(GB.PERIOD_NET_DR,0) + NVL(GB.BEGIN_BALANCE_DR,0))) - SUM(NVL(GB.PERIOD_NET_CR,0)+NVL(GB.BEGIN_BALANCE_CR,0)) <> 0
GL Chart of Account Segment Hierarchy Ranges
/* GL : CCHART OF ACCOUNT SEGMENT HIERARCHY RANGES
 
     
     
     
     
     
CHART OF ACCOUNT SEGMENT HIERARCHY RANGES AND ATTRIBUTES FOR PARENT ACCOUNTS
*/
 
SELECT  FVS.FLEX_VALUE_SET_NAME"VALUE SET"
,      FV.FLEX_VALUE
,      NH.PARENT_FLEX_VALUE "PARENT"
,      FVT.DESCRIPTION
,      NH.RANGE_ATTRIBUTE "INC C OR P?"
,      NH.CHILD_FLEX_VALUE_LOW "FROM"
,      NH.CHILD_FLEX_VALUE_HIGH "TO"
,      NH.PARENT_FLEX_VALUE || ' : ' ||NH.RANGE_ATTRIBUTE || ' : ' ||
       NH.CHILD_FLEX_VALUE_LOW || ' -> ' ||NH.CHILD_FLEX_VALUE_HIGH "HIERARCHY RANGE"
,      SUBSTR(FV.COMPILED_VALUE_ATTRIBUTES,1,1)"POSTING"
,      SUBSTR(FV.COMPILED_VALUE_ATTRIBUTES,3,1)"BUDGETING"
,      SUBSTR(FV.COMPILED_VALUE_ATTRIBUTES,5,1)"ACC TYPE"
,      FV.ENABLED_FLAG"ENABLED"
,      FV.SUMMARY_FLAG"PARENT?"
,      NH.LAST_UPDATE_DATE
,      FV.HIERARCHY_LEVEL"LEVEL"
FROM FND_FLEX_VALUE_NORM_HIERARCHY NH, FND_FLEX_VALUE_SETS FVS, FND_FLEX_VALUES_TL FVT, FND_FLEX_VALUES FV
WHERE FVS.FLEX_VALUE_SET_ID = FV.FLEX_VALUE_SET_ID
AND FVS.FLEX_VALUE_SET_ID = NH.FLEX_VALUE_SET_ID
AND FV.FLEX_VALUE_ID = FVT.FLEX_VALUE_ID
AND NH.PARENT_FLEX_VALUE(+) = FVT.FLEX_VALUE_MEANING
AND FVS.FLEX_VALUE_SET_ID = NH.FLEX_VALUE_SET_ID
AND FVS.FLEX_VALUE_SET_NAME LIKE '%ACCOUNT%' --- CHART OF ACCOUNTS SEGMENT NAME
--  AND SUBSTR(FVS.FLEX_VALUE_SET_NAME,4,2) IN ('BE','LU','ES')
AND FV.SUMMARY_FLAG = 'Y'
AND FV.FLEX_VALUE LIKE '%XYZ%'  --- THIS IS THE PARENT SEGMENT VALUES
--  AND NH.PARENT_FLEX_VALUE = '%%'
--  AND FV.ENABLED_FLAG = 'Y'
--  AND FV.HIERARCHY_LEVEL = '2'
ORDER BY 1,3
     
     
     
     
     
GL Code Combinations CCIDs
/* GL CODE COMBINATIONS   
GL CODE COMBINATIONS EXTRACT. CAN BE SELECT BY CHART OF ACCOUNTS, SPECIFIC SEGMENT VALUES OR SPECIFIC CODE COMBINATION ATTRIBUTES.
THIS CAN BE USED FOR CHART OF ACCOUNTS MAINTENANCE AND REVIEW
*/
 
SELECT FST.ID_FLEX_STRUCTURE_NAME
,    GCC.SEGMENT1||'-'||GCC.SEGMENT2||'-'||GCC.SEGMENT3||'-'||GCC.SEGMENT4||'-'||GCC.SEGMENT5||'-'||GCC.SEGMENT6
,   GCC.CODE_COMBINATION_ID
,   GCC.LAST_UPDATE_DATE
,   GCC.JGZZ_RECON_FLAG
,   GCC.START_DATE_ACTIVE
,   GCC.END_DATE_ACTIVE  
,   GCC.DETAIL_POSTING_ALLOWED_FLAG
,   GCC.ENABLED_FLAG
,   GCC.SUMMARY_FLAG
,   GCC.START_DATE_ACTIVE
FROM GL_CODE_COMBINATIONS GCC
,    FND_ID_FLEX_STRUCTURES_VL FST
WHERE FST.ID_FLEX_NUM = GCC.CHART_OF_ACCOUNTS_ID
AND FST.APPLICATION_ID = 101
AND FST.ID_FLEX_CODE = 'GL#'
--AND GCC.SEGMENT1 IN ('25','26','30')
--AND SUBSTR(FST.ID_FLEX_STRUCTURE_NAME,1,2) IN ('ES','BE','LU')
--AND GCC.SEGMENT4 = '99901'
ORDER BY 1,2,3
GL CVR Cross Validation Rule Detail Listing
/* CVR CROSS VALIDATION RULE DETAIL LISTING
PROVIDES DETAIL VIEW OF CVR DEFINITION INCLUDING ACCOUNT RANGES.
*/
 
SELECT FST.ID_FLEX_STRUCTURE_NAME
,      R.FLEX_VALIDATION_RULE_NAME
,      R.ENABLED_FLAG
--,    R.ERROR_SEGMENT_COLUMN_NAME"ERR SEG"
--,    TL.DESCRIPTION
--,    TL.ERROR_MESSAGE_TEXT"ERROR MESSAGE"
,      L.ENABLED_FLAG
,      L.INCLUDE_EXCLUDE_INDICATOR"INC?"
,      L.CONCATENATED_SEGMENTS_LOW "FROM"
,      L.CONCATENATED_SEGMENTS_HIGH "TO"
,      L.LAST_UPDATED_BY
,      L.LAST_UPDATE_DATE
FROM   FND_FLEX_VALIDATION_RULES R,
       FND_FLEX_VDATION_RULES_TL TL,
       FND_FLEX_VALIDATION_RULE_LINES L,
       FND_ID_FLEX_STRUCTURES_VL FST
WHERE  R.APPLICATION_ID = TL.APPLICATION_ID
AND    FST.ID_FLEX_NUM = R.ID_FLEX_NUM
AND    R.ID_FLEX_CODE = TL.ID_FLEX_CODE
AND    R.ID_FLEX_NUM = TL.ID_FLEX_NUM
AND    R.FLEX_VALIDATION_RULE_NAME = TL.FLEX_VALIDATION_RULE_NAME
AND    R.FLEX_VALIDATION_RULE_NAME = TL.FLEX_VALIDATION_RULE_NAME
AND    R.APPLICATION_ID = L.APPLICATION_ID
AND    R.ID_FLEX_CODE = L.ID_FLEX_CODE
AND    R.ID_FLEX_NUM = L.ID_FLEX_NUM
AND    R.FLEX_VALIDATION_RULE_NAME = L.FLEX_VALIDATION_RULE_NAME
AND    R.FLEX_VALIDATION_RULE_NAME = L.FLEX_VALIDATION_RULE_NAME
AND    R.APPLICATION_ID = 101
--     OPTIONAL FILTERS BELOW TO LIMIT QUERY TO SPECIFIC CVR OR LINES
--AND    R.ERROR_SEGMENT_COLUMN_NAME = 'SEGMENT5'
--AND     TL.ERROR_MESSAGE_TEXT LIKE '%PLEASE USE A VALID R%'
--AND    R.FLEX_VALIDATION_RULE_NAME LIKE 'BE GROUP ERROR%'
--AND     TL.ERROR_MESSAGE_TEXT LIKE '%94005%'
--AND     L.INCLUDE_EXCLUDE_INDICATOR = 'E'
ORDER BY 1,R.FLEX_VALIDATION_RULE_NAME, L.INCLUDE_EXCLUDE_INDICATOR DESC, L.CONCATENATED_SEGMENTS_LOW