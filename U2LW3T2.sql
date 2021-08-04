truncate table SA_OFFER_USER.SA_OFFER;
insert into SA_OFFER_USER.SA_OFFER(OFFER_ID,
                                    OFFER_NAME,
                                    OFFER_DESC,
                                    OFFER_ACT_COST,
                                    OFFER_DAYS,
                                    OFFER_TRANSP_ID,
                                    OFFER_TRANSP_DESC,
                                    IS_ACTIVE)
 SELECT ROWNUM,
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,10)),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,30)),
 DBMS_RANDOM.value(10,100),
 ROUND(DBMS_RANDOM.value(1,60),0),
 ROUND(DBMS_RANDOM.value(1,7),0),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,30)),
 RandomString('YN', 1)
 FROM DUAL
 CONNECT BY LEVEL <= 1000000;


truncate table SA_CUSTOMER_USER.SA_CUSTOMER;
insert into SA_CUSTOMER_USER.SA_CUSTOMER(CUSTOMER_ID,
                                           CUSTOMER_SUR_ID,
                                           CUSTOMER_DESC,
                                           CUSTOMER_GENDER,
                                           CUSTOMER_AGE,
                                           CUSTOMER_NUMBER,
                                           CUSTOMER_FIRST_NAME,
                                           CUSTOMER_LAST_NAME)
 SELECT ROWNUM,
 ROWNUM,
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,30)),
 RandomString('FM', 1),
 DBMS_RANDOM.value(1,100),
 '+375' || RandomString('1234567890', 9),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,20)),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,20))
 FROM DUAL
 CONNECT BY LEVEL <= 1000000;
 
 
 truncate table SA_TOUR_OPER_USER.SA_TOUR_OPER;
 insert into SA_TOUR_OPER_USER.SA_TOUR_OPER(TOUR_OPER_ID,
                                            TOUR_OPER_SUR_ID,
                                            TOUR_OPER_NAME,
                                            TOUR_OPER_DESC,
                                            TOUR_OPER_CODE,
                                            TOUR_OPER_SITE)
 SELECT ROWNUM,
 ROWNUM,
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (5,30)),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (5,30)),
 RandomString('1234567890', 9),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,25)) || '.com'
 FROM DUAL
 CONNECT BY LEVEL <= 100000;
 
 truncate table SA_TNX_SALES_USER.SA_TNX_SALES;
 insert into SA_TNX_SALES_USER.SA_TNX_SALES(SALES_ID,
                                          offer_id,
                                          tour_oper_id,
                                          customer_id,
                                          date_id,
                                          SALES_AMOUNT,
                                          SALES_PRICE,
                                          CURRENT_COUNTRY,
                                          DEST_COUNTRY)
SELECT ROWNUM + 1461*11
       , ROUNd((dBMS_RANdOM.VALUE(1, 1000000)),0)
       , ROUNd((dBMS_RANdOM.VALUE(1, 100000)),0)
       , ROUNd((dBMS_RANdOM.VALUE(1, 1000000)),0)
       , to_number(to_char((DATE '2017-01-01' + LEVEL - 1), 'yyyymmdd')) 
       , ROUNd((dBMS_RANdOM.VALUE(1, 1000000)),0)
       , ROUNd((dBMS_RANdOM.VALUE(1, 100000000)),0)
, DBMS_RANDOM.STRING('u', DBMS_RANDOM.VALUE (3,15)),
 DBMS_RANDOM.STRING('u', DBMS_RANDOM.VALUE (3,15))
 FROM DUAL
 CONNECT BY LEVEL <= DATE '2020-12-31' - DATE '2017-01-01' + 1;

drop table sb_mbackup_user.offer_objects;
CREATE TABLE sb_mbackup_user.offer_objects
(
   object_id               NUMBER                        NULL,
   object_desc             VARCHAR(100)                  NULL,
   object_parent_id        NUMBER                        NULL
)
TABLESPACE sb_mbackup;

DROP TABLE sb_mbackup_user.offer;
CREATE TABLE sb_mbackup_user.offer
(
   offer_id              NUMBER                         NULL,
   offer_desc            VARCHAR(100)                   NULL,
   offer_transp_id       NUMBER                         NULL
)
TABLESPACE sb_mbackup;

  DROP TABLE sb_mbackup_user.offer_transp;
CREATE TABLE sb_mbackup_user.offer_transp
(
   offer_transp_id               NUMBER                         NULL,
   offer_transp_desc             VARCHAR(100)                   NULL
)
TABLESPACE sb_mbackup;


truncate table SB_MBackUp_USER.offer;
INSERT INTO SB_MBackUp_USER.offer(offer_id
                                  , offer_desc
                                  , offer_transp_id)
SELECT ROWNUM + 10
       , 'Offer ' || to_char(ROWNUM)
       , round((DBMS_RANDOM.VALUE(1, 10)),0)
  FROM dual
CONNECT BY LEVEL <= 100000;
COMMIT;


truncate table SB_MBackUp_USER.offer_transp;
INSERT INTO SB_MBackUp_USER.offer_transp(offer_transp_id
                                         , offer_transp_desc)
 SELECT ROWNUM 
        , 'Transport ' || to_char(ROWNUM)
   FROM dual
CONNECT BY LEVEL <= 10;
 COMMIT;

truncate table sb_mbackup_user.offer_objects;
INSERT INTO sb_mbackup_user.offer_objects(object_id
                                        , object_desc
                                        , object_parent_id)
SELECT * FROM sb_mbackup_user.offer;

INSERT INTO sb_mbackup_user.offer_objects(object_id
                                        , object_desc)
SELECT * FROM sb_mbackup_user.offer_transp;


SELECT * FROM sb_mbackup_user.offer_objects;


  DROP TABLE sb_mbackup_user.offer_transp_analyze;
CREATE TABLE sb_mbackup_user.offer_transp_analyze
(
   object_desc           VARCHAR(100)                   NULL,
   object_id             NUMBER                         NULL,
   object_parent_id      NUMBER                         NULL,
   object_root           VARCHAR(1000)                  NULL,
   object_is_leaf        NUMBER                         NULL,
   object_level          NUMBER                         NULL,
   object_path           VARCHAR(1000)                  NULL

)
TABLESPACE sb_mbackup;

TRUNCATE TABLE sb_mbackup_user.offer_transp_analyze;

 INSERT INTO sb_mbackup_user.offer_transp_analyze(object_desc
                                              , object_id
                                              , object_parent_id
                                              , object_root
                                              , object_is_leaf
                                              , object_level
                                              , object_path)
 SELECT lpad(' ', LEVEL*2-1,' ') || off.object_desc
        , object_id, object_parent_id
        ,  CONNECT_BY_ROOT object_desc AS ROOT
        ,  CONNECT_BY_ISLEAF, LEVEL
        , sys_connect_by_path(object_desc,':') PATH
   FROM sb_mbackup_user.offer_objects off
  START WITH off.object_parent_id IS NULL
CONNECT BY PRIOR off.object_id = off.object_parent_id
  ORDER SIBLINGS BY off.object_desc;

select * from sb_mbackup_user.offer_transp_analyze;