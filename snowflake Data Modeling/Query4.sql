CREATE OR REPLACE VIEW PROD_CTF_CLEAN.CTF_CLEAN_T3.DONOR_BY_GENDER_V4
AS
SELECT
CASE WHEN OP.TYPE = 'Donation' THEN OP.TYPE ELSE 'Other' END AS TYPE,
OP.AMOUNT AS AMOUNT,
OP.CLOSEDATE AS CLOSEDATE,
AC.HOUSEHOLD_SOFT_CREDITS_TOTAL__C AS SOFTCREDIT,
CASE WHEN AC.HOUSEHOLD_SOFT_CREDITS_TOTAL__C > 0 THEN 'SoftCredit' ELSE 'HardCredit' END AS TYPEofCREDIT,



SUBSTRING(OP.CLOSEDATE,1,4) AS OPP_CLOSE_YEAR,
case when AC.RECORDTYPEID ='012G0000001BKhsIAG' THEN 'household' else 'institution' end as Recordtype,
CASE WHEN CT.GENDER__C IS NULL THEN 'Unknown' ELSE CT.GENDER__C END AS GENDER__C

FROM "PROD_CTF_RAW"."SRC_SF"."CTF_SF_OPPORTUNITY" OP
INNER JOIN "PROD_CTF_RAW"."SRC_SF"."CTF_SF_CONTACT" CT ON CT.ID = OP.CONTACTID
inner JOIN "PROD_CTF_RAW"."SRC_SF"."CTF_SF_ACCOUNT" AC ON AC.ID = OP.ACCOUNTID



WHERE YEAR(CLOSEDATE) >=2016 AND OP.AMOUNT > 0;
