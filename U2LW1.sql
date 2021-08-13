select * from SA_CUSTOMER_USER.SA_CUSTOMER;
select * from SA_TNX_SALES_USER.SA_TNX_SALES;
select * from SA_TOUR_OPER_USER.SA_TOUR_OPER;
select * from SA_LOCATION_USER.SA_LOCATION;
select * from SA_OFFER_USER.SA_OFFER;

GRANT UNLIMITED TABLESPACE TO SA_CUSTOMER_USER;
GRANT UNLIMITED TABLESPACE TO SA_TNX_SALES_USER;
GRANT UNLIMITED TABLESPACE TO SA_TOUR_OPER_USER;
GRANT UNLIMITED TABLESPACE TO SA_LOCATION_USER;
GRANT UNLIMITED TABLESPACE TO SA_OFFER_USER;

create or replace function RandomString(p_Characters varchar2, p_length number)
  return varchar2
  is
    l_res varchar2(256);
  begin
    select substr(listagg(substr(p_Characters, level, 1)) within group(order by dbms_random.value), 1, p_length)
      into l_res
      from dual
    connect by level <= length(p_Characters);
    return l_res;
  end;
  /
  
  insert into SA_CUSTOMER_USER.SA_CUSTOMER(CUSTOMER_ID,
                                           CUSTOMER_DESC,
                                           CUSTOMER_GENDER,
                                           CUSTOMER_AGE,
                                           CUSTOMER_NUMBER,
                                           CUSTOMER_FIRST_NAME,
                                           CUSTOMER_LAST_NAME)
 SELECT ROWNUM,
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,30)),
 RandomString('FM', 1),
 DBMS_RANDOM.value(1,100),
 '+375' || RandomString('1234567890', 9),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,20)),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,20))
 FROM DUAL
 CONNECT BY LEVEL <= 1000000;
 commit;
 
 
 
 
 SELECT * FROM SA_CUSTOMER_USER.SA_CUSTOMER;
 
 truncate table SA_TNX_SALES_USER.SA_TNX_SALES;
 insert into SA_TNX_SALES_USER.SA_TNX_SALES(SALES_ID,
                                          SALES_AMOUNT,
                                          SALES_PRICE,
                                          CURRENT_COUNTRY)
 SELECT ROWNUM,
 ROUND(DBMS_RANDOM.value(1,20),0),
 ROUND(DBMS_RANDOM.value(1,100),1),
 DBMS_RANDOM.STRING('u', DBMS_RANDOM.VALUE (3,15))
 FROM DUAL
 CONNECT BY LEVEL <= 1000000;
 commit;
 
   
DROP TABLE sa_tnx_sales_user.sa_tnx_sales;
CREATE TABLE sa_tnx_sales_user.sa_tnx_sales
(
   offer_id             NUMBER                         NOT NULL,
   tour_oper_id         NUMBER                         NOT NULL,
   customer_id          NUMBER                         NOT NULL,
   date_key             NUMBER                         NOT NULL,
   location_id          NUMBER                         NOT NULL,
   sales_id             NUMBER                         NOT NULL,
   periods_id           NUMBER                         NOT NULL,
   sales_amount         NUMBER                         NULL,
   sales_price          NUMBER                         NULL,
   current_country      varchar(20)                    NULL,
   CONSTRAINT pk_sa_sales PRIMARY KEY (sales_id)
)
TABLESPACE ts_sa_sales_data_01;


--TRUNcATE TABLE sa_tnx_sales_user.sa_tnx_sales;
INSERT INTO sa_tnx_sales_user.sa_tnx_sales(offer_id
                                           , tour_oper_id
                                           , customer_id
                                           , date_key
                                           , location_id
                                           , sales_id
                                           , periods_id
                                           , sales_amount
                                           , sales_price
                                           , current_country)
SELECT ROUNd((DBMS_RANdOM.VALUE(1, 1000000)),0)
       , ROUNd((DBMS_RANdOM.VALUE(1, 1000000)),0)
       , ROUNd((DBMS_RANdOM.VALUE(1, 1000000)),0)
       , to_number(to_char((DATE '2017-01-01' + ROUNd((DBMS_RANdOM.VALUE(1, 1000)),0) - 1), 'yyyymmdd'))
       , ROUNd((DBMS_RANdOM.VALUE(702, 706)),0)
       , ROWNUM
       , ROUNd((DBMS_RANdOM.VALUE(1, 4)),0)
       , ROUNd((DBMS_RANdOM.VALUE(1, 1000000)),0)
       , ROUNd((DBMS_RANdOM.VALUE(1, 100000000)),0)
       , DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,20))
  FROM dUAL
CONNECT BY LEVEL <= 100000;
COMMIT;

 
 select *from SA_TNX_SALES_USER.SA_TNX_SALES;
 
 insert into SA_TOUR_OPER_USER.SA_TOUR_OPER(TOUR_OPER_ID,
                                            TOUR_OPER_NAME,
                                            TOUR_OPER_DESC,
                                            TOUR_OPER_CODE,
                                            TOUR_OPER_SITE)
 SELECT ROWNUM,
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (5,30)),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (5,30)),
 RandomString('1234567890', 9),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,25)) || '.com'
 FROM DUAL
 CONNECT BY LEVEL <= 1000000;
 commit;
 
 SELECT * FROM SA_TOUR_OPER_USER.SA_TOUR_OPER;
 
 
 insert into SA_OFFER_USER.SA_OFFER(OFFER_ID,
                                    OFFER_NAME,
                                    OFFER_DESC,
                                    OFFER_ACT_COST,
                                    OFFER_DAYS,
                                    OFFER_TRANSP_ID,
                                    OFFER_TRANSP_DESC)
 SELECT ROWNUM,
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,10)),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,30)),
 DBMS_RANDOM.value(10,100),
 ROUND(DBMS_RANDOM.value(1,60),0),
 ROUND(DBMS_RANDOM.value(1,100),0),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (3,30))
 FROM DUAL
 CONNECT BY LEVEL <= 1000000;
 commit;
 
 TRUNCATE TABLE SA_OFFER_USER.SA_OFFER;
 SELECT * FROM SA_OFFER_USER.SA_OFFER;
 
 
 SELECT COUNT(*)
       , CUSTOMER_AGE
  FROM SA_CUSTOMER_USER.SA_CUSTOMER
 GROUP BY CUSTOMER_AGE;
 
 SELECT COUNT(*)
       , CUSTOMER_GENDER
  FROM SA_CUSTOMER_USER.SA_CUSTOMER
 GROUP BY CUSTOMER_GENDER;
 
 SELECT COUNT(*)
       , OFFER_ACT_COST
  FROM SA_OFFER_USER.SA_OFFER
 GROUP BY OFFER_ACT_COST;
 
  SELECT COUNT(*)
       , OFFER_DAYS
  FROM SA_OFFER_USER.SA_OFFER
 GROUP BY OFFER_DAYS
 ORDER BY OFFER_DAYS;
 
 drop table SA_CUSTOMER_USER.updated_SA_CUSTOMER;
 CREATE TABLE SA_CUSTOMER_USER.updated_SA_CUSTOMER
(
   CUSTOMER_ID            NUMBER(20, 0)                     NOT NULL,
   CUSTOMER_DESC          VARCHAR2(30 CHAR)                 NOT NULL,
   CUSTOMER_GENDER        VARCHAR2(10 CHAR)                 NOT NULL,
   CUSTOMER_AGE           NUMBER (20, 0)                    NOT NULL,
   CUSTOMER_NUMBER        NUMBER(20, 0)                     NOT NULL,
   CUSTOMER_FIRST_NAME    VARCHAR2(20 CHAR)                 NOT NULL,
   CUSTOMER_LAST_NAME     VARCHAR2(20 CHAR)                 NOT NULL,
   CONSTRAINT PK_upt_SA_CUSTOMER PRIMARY KEY (CUSTOMER_ID)
)
 TABLESPACE ts_sa_customer_data_01;
 
 truncate table SA_CUSTOMER_USER.updated_SA_CUSTOMER;
 insert into SA_CUSTOMER_USER.updated_SA_CUSTOMER(CUSTOMER_ID,
                                           CUSTOMER_DESC,
                                           CUSTOMER_GENDER,
                                           CUSTOMER_AGE,
                                           CUSTOMER_NUMBER,
                                           CUSTOMER_FIRST_NAME,
                                           CUSTOMER_LAST_NAME)
 SELECT ROWNUM,
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,30)),
 RandomString('FM', 1),
 DBMS_RANDOM.value(1,100),
 '+375' || RandomString('1234567890', 9),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,20)),
 DBMS_RANDOM.STRING('L', DBMS_RANDOM.VALUE (1,20))
 FROM DUAL
 CONNECT BY LEVEL <= 1000000;
 commit;
 SELECT * FROM SA_CUSTOMER_USER.updated_SA_CUSTOMER;
 
 MERGE INTO SA_CUSTOMER_USER.updated_SA_CUSTOMER U
USING (SELECT CUSTOMER_AGE,
       COUNT(*) cnt
       FROM SA_CUSTOMER_USER.SA_CUSTOMER
       GROUP BY CUSTOMER_AGE) F
   ON (U.CUSTOMER_AGE = F.CUSTOMER_AGE)
 WHEN MATCHED THEN UPDATE SET CUSTOMER_DESC = to_char(F.cnt);
 
 SELECT * FROM SA_CUSTOMER_USER.updated_SA_CUSTOMER;