CREATE TABLESPACE ts_sa_customer_data_01
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sa_customer_data_01.dat'
SIZE 150M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;

 
CREATE TABLESPACE ts_sa_sales_data_01
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sa_sales_data_01.dat'
SIZE 150M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE ts_sa_tour_oper_data_01
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sa_tour_oper_data_01.dat'
SIZE 150M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE ts_sa_location_data_01
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sa_location_data_01.dat'
SIZE 150M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE ts_dw_cl
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_dw_cl.dat'
SIZE 150M
 AUTOEXTEND ON NEXT 50
 SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE ts_dw_data
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_dw_data.dat'
SIZE 150M
 AUTOEXTEND ON  NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE ts_sal_dw_cl
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sal_dw_cl.dat'
SIZE 50M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE ts_sal_cl
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sal_cl.dat'
SIZE 50M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;


CREATE TABLESPACE ts_sal_data_0001
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sal_data_0001.dat'
SIZE 150M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;
 drop TABLESPACE ts_sal_data_0001;

CREATE TABLESPACE ts_sa_offer_data_001
DATAFILE '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sa_offer_data_001.dat'
SIZE 150M
 AUTOEXTEND ON NEXT 50M
 SEGMENT SPACE MANAGEMENT AUTO;
 
 
create tablespace ts_sa_gen_periods_01
datafile '/oracle/u02/oradata/DMORCL19DB/astepanenko_db/ts_sa_gen_periods_01.dat'
size 150M
    autoextend on next 50M
segment space management auto;



CREATE USER SA_CUSTOMER_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sa_customer_data_01;

GRANT CONNECT,RESOURCE TO SA_CUSTOMER_USER;


CREATE USER SA_TNX_SALES_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sa_sales_data_01;

GRANT CONNECT,RESOURCE TO SA_TNX_SALES_USER;


CREATE USER SA_TOUR_OPER_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sa_tour_oper_data_01;

GRANT CONNECT,RESOURCE TO SA_TOUR_OPER_USER;


CREATE USER SA_LOCATION_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sa_location_data_01;

GRANT CONNECT,RESOURCE, CREATE VIEW TO SA_LOCATION_USER;


CREATE USER SA_OFFER_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sa_offer_data_001;

GRANT CONNECT,RESOURCE, CREATE VIEW TO SA_OFFER_USER;


CREATE USER DW_CL_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_dw_cl;

GRANT CONNECT,RESOURCE, CREATE VIEW TO DW_CL_USER;


CREATE USER TS_DW_DATA_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_dw_data;

GRANT CONNECT,RESOURCE, CREATE VIEW TO TS_DW_DATA_USER;


CREATE USER SAL_DW_CL_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sal_dw_cl;

GRANT CONNECT,RESOURCE, CREATE VIEW TO SAL_DW_CL_USER;


CREATE USER SAL_CL_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sal_cl;

GRANT CONNECT,RESOURCE, CREATE VIEW TO SAL_CL_USER;


CREATE USER TS_SAL_DATA_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE ts_sal_data_0001;

GRANT CONNECT,RESOURCE, CREATE VIEW TO TS_SAL_DATA_USER;



GRANT UNLIMITED TABLESPACE TO DW_CL_USER;
GRANT UNLIMITED TABLESPACE TO SAL_DW_CL_USER; 
GRANT UNLIMITED TABLESPACE TO SAL_CL_USER;
commit;

drop table SA_CUSTOMER_USER.SA_CUSTOMER;
create table SA_CUSTOMER_USER.SA_CUSTOMER 
(
   customer_id          number(20, 0)                     not null,
   customer_desc        varchar2(30 char)                 not null,
   customer_gender      varchar2(10 char)                 not null,
   customer_age         number (20, 0)                    not null,
   customer_number      number (20, 0)                    not null,
   customer_first_name  varchar2(20 char)                 not null,
   customer_last_name   varchar2(20 char)                 not null,   
   constraint PK_SA_CUSTOMER primary key (customer_id)
)
tablespace ts_sa_customer_data_01;

drop table SA_TOUR_OPER_USER.SA_TOUR_OPER;
create table SA_TOUR_OPER_USER.SA_TOUR_OPER 
(
   tour_oper_id           number                              not null,
   tour_oper_name         varchar(30 char)                    not null,
   tour_oper_desc         varchar(30 char)                    not null,
   tour_oper_code         varchar(20 char)                    not null,
   tour_oper_site         varchar(30 char)                    not null,
   constraint PK_SA_TOUR_OPER primary key (tour_oper_id)
)
tablespace ts_sa_tour_oper_data_01;

drop table SA_OFFER_USER.SA_OFFER;
create table SA_OFFER_USER.SA_OFFER 
(
   offer_id              number                       not null,
   offer_name            varchar(30)                  not null,
   offer_desc            varchar(30)                  not null,
   offer_act_cost        decimal                      not null,
   offer_days            number                       not null,
   offer_transp_id       number                       not null,
   offer_transp_desc     varchar(30)                  not null,
   constraint PK_SA_OFFER primary key (offer_id)
)
tablespace ts_sa_offer_data_001;

drop table SA_TNX_SALES_USER.SA_TNX_SALES;
create table SA_TNX_SALES_USER.SA_TNX_SALES
(
   sales_id           number                  not null,
   sales_amount       number                  null,
   sales_price        decimal                 null,
   current_country    varchar(20)             not null,
   constraint PK_SA_SALES primary key (sales_id)
)
tablespace ts_sa_sales_data_01;

drop table SA_LOCATION_USER.SA_LOCATION;
create table SA_LOCATION_USER.SA_LOCATION
(
   location_id          number                         not null,
   location_desc        varchar(100)                    not null,
   country_id           number                         not null,
   country_name         varchar(100)                    not null,
   region_id            number                         not null,
   region_code          varchar(100)                    null,
   region_name          varchar(100)                    not null,
   part_id              number                         not null,
   part_code            varchar(100)                    null,
   part_name            varchar(100)                    not null,
   geo_system_id        number                         not null,
   geo_system_code      varchar(100)                    not null,
   geo_system_name      varchar(100)                    not null,
   constraint PK_SA_LOCATION primary key (location_id)
)
tablespace ts_sa_location_data_01;

drop table TS_SAL_DATA_USER.DIM_DATE;
create table TS_SAL_DATA_USER.DIM_DATE 
(
   date_id                 number                         not null,
   date_full               varchar(20)                    not null,
   date_desc               varchar(30)                    not null,
   date_full_string        varchar(50)                    not null,
   date_weekday_fl         number                         not null,
   date_is_holiday         number                         not null,
   week_last_day           number                         not null,
   month_last_day          number                         not null,
   quarter_last_day        number                         not null,
   year_last_day           number                         not null,
   day_of_week_name        varchar2(20)                   not null,
   month_name              varchar2(20)                   not null,
   day_id                  number                         not null,
   day_of_week_number      number                         not null,
   day_of_month_number     number                         not null,
   day_of_quarter_number   number                         not null,
   day_of_year_number      number                         not null,
   week_id                 number                         not null,
   week_number_of_month    number                         not null,
   week_number_of_quarter  number                         not null,
   week_number_of_year     number                         not null,
   month_number_of_year    number                         not null,
   quarter_number_of_year  number                         not null,
   year_number             number                         not null,
   week_begin_dt           date                           not null,
   week_end_dt             date                           not null,
   month_id                number                         not null,
   month_begin_dt          date                           not null,
   month_end_dt            date                           not null,
   quarter_id              number                         not null,
   quarter_start_dt        date                           not null,
   quarter_end_dt          date                           not null,
   year_id                 number                         not null,
   year_fd                 date                           not null,
   year_ld                 date                           not null,
   insert_dt               date                           not null,
   update_dt               date                           not null,
   constraint PK_DIM_DATE primary key (date_id)
)
tablespace ts_sal_data_0001;


drop table TS_SAL_DATA_USER.DIM_LOCATION;
create table TS_SAL_DATA_USER.DIM_LOCATION
(
   location_id          number                         not null,
   location_desc        varchar(30)                    not null,
   country_id           number                         not null,
   country_code         varchar(30)                    not null,
   country_name         varchar(30)                    not null,
   region_id            number                         not null,
   region_code          varchar(30)                    not null,
   region_name          varchar(30)                    not null,
   state_id             number                         not null,
   state_code           varchar(30)                    not null,
   state_name           varchar(30)                    not null,
   city_id              number                         not null,
   city_code            varchar(30)                    not null,
   city_name            varchar(30)                    not null,
   street_id            number                         not null,
   street_code          varchar(30)                    not null,
   street_name          varchar(30)                    not null,
   insert_dt            date                           not null,
   update_dt            date                           not null,
   constraint PK_DIM_LOCATION primary key (location_id)
)
tablespace ts_sal_data_0001;

drop table TS_SAL_DATA_USER.DIM_OFFER_SCD;
create table TS_SAL_DATA_USER.DIM_OFFER_SCD 
(
   offer_id              number                       not null,
   offer_sur_id          number                       not null,
   offer_name            varchar(30)                  not null,
   offer_desc            varchar(30)                  not null,
   offer_act_cost        decimal                      not null,
   offer_days            number                       not null,
   offer_transp_id       number                       not null,
   offer_transp_desc     varchar(30)                  not null,
   is_active             number                       not null,
   insert_dt             date                         not null,
   update_dt             date                         not null,
   constraint PK_DIM_OFFER_SCD primary key (offer_sur_id)
)
tablespace ts_sal_data_0001;


drop table TS_SAL_DATA_USER.DIM_GEN_PERIODS;
create table TS_SAL_DATA_USER.DIM_GEN_PERIODS 
(
   periods_id           number                         not null,
   periods_desc         varchar(30)                    not null,
   start_dt             number                         not null,
   end_dt               number                         not null,
   insert_dt            date                           not null,
   update_dt            date                           not null,
   constraint PK_DIM_GEN_PERIODS primary key (periods_id)
)
tablespace ts_sal_data_0001;

drop table TS_SAL_DATA_USER.DIM_CUSTOMER;
create table TS_SAL_DATA_USER.DIM_CUSTOMER 
(
   customer_id          number(20, 0)                     not null,
   customer_desc        varchar2(30 char)                 not null,
   customer_gender      varchar2(10 char)                 not null,
   customer_age         number (20, 0)                    not null,
   customer_number      number (20, 0)                    not null,
   customer_first_name  varchar2(20 char)                 not null,
   customer_last_name   varchar2(20 char)                 not null,   
   insert_dt            date                              not null,
   update_dt            date                              not null,
   constraint PK_DIM_CUSTOMER primary key (customer_id)
)
tablespace ts_sal_data_0001;

drop table TS_SAL_DATA_USER.DIM_TOUR_OPER;
create table TS_SAL_DATA_USER.DIM_TOUR_OPER 
(
   tour_oper_id           number                              not null,
   tour_oper_name         varchar(30 char)                    not null,
   tour_oper_desc         varchar(30 char)                    not null,
   tour_oper_code         varchar(20 char)                    not null,
   tour_oper_site         varchar(30 char)                    not null,
   insert_dt              date                                not null,
   update_dt              date                                not null,
   constraint PK_DIM_TOUR_OPER primary key (tour_oper_id)
)
tablespace ts_sal_data_0001;

drop table TS_SAL_DATA_USER.FCT_SALES_DD;
create table TS_SAL_DATA_USER.FCT_SALES_DD
(
   offer_sur_id       number                         not null,
   tour_oper_id       number                         not null,
   customer_id        number                         not null,
   date_id            number                         not null,
   location_id        number                         not null,
   sales_id           number                         not null,
   periods_id         number                         not null,
   sales_amount       number                         null,
   sales_price        decimal                        null,
   current_country    varchar(20)                    not null,
   insert_dt          date                           not null
)
tablespace ts_sal_data_0001;



alter table TS_SAL_DATA_USER.FCT_SALES_DD
   add constraint FK_FCT_SALE_REFERENCE_DIM_LOCATION foreign key (location_id)
      references TS_SAL_DATA_USER.DIM_LOCATION (location_id)
      on delete cascade;

alter table TS_SAL_DATA_USER.FCT_SALES_DD
   add constraint FK_FCT_SALE_REFERENCE_DIM_OFFER foreign key (offer_sur_id)
      references TS_SAL_DATA_USER.DIM_OFFER_SCD (offer_sur_id)
     on delete cascade;

alter table TS_SAL_DATA_USER.FCT_SALES_DD
   add constraint FK_FCT_SALE_REFERENCE_DIM_TOUR_OPER foreign key (tour_oper_id)
      references TS_SAL_DATA_USER.DIM_TOUR_OPER (tour_oper_id)
      on delete cascade;

alter table TS_SAL_DATA_USER.FCT_SALES_DD
   add constraint FK_FCT_SALE_REFERENCE_DIM_CUSTOMER foreign key (customer_id)
      references TS_SAL_DATA_USER.DIM_CUSTOMER (customer_id)
      on delete cascade;

alter table TS_SAL_DATA_USER.FCT_SALES_DD
   add constraint FK_FCT_SALE_REFERENCE_DIM_DATE foreign key (date_id)
      references TS_SAL_DATA_USER.DIM_DATE (date_id)
      on delete cascade;

alter table TS_SAL_DATA_USER.FCT_SALES_DD
   add constraint FK_FCT_SALE_REFERENCE_DIM_GEN_PERIODS foreign key (periods_id)
      references TS_SAL_DATA_USER.DIM_GEN_PERIODS (periods_id)
      on delete cascade;
      
      
drop table TS_DW_DATA_USER.DW_DATE
create table TS_DW_DATA_USER.DW_DATE 
(
   date_id                 number                         not null,
   date_full               varchar(20)                    not null,
   date_desc               varchar(30)                    not null,
   date_full_string        varchar(50)                    not null,
   date_weekday_fl         number                         not null,
   date_is_holiday         number                         not null,
   week_last_day           number                         not null,
   month_last_day          number                         not null,
   quarter_last_day        number                         not null,
   year_last_day           number                           not null,
   day_of_week_name        varchar2(20)                   not null,
   month_name              varchar2(20)                   not null,
   day_id                  number                         not null,
   day_of_week_number      number                         not null,
   day_of_month_number     number                         not null,
   day_of_quarter_number   number                         not null,
   day_of_year_number      number                         not null,
   week_id                 number                         not null,
   week_number_of_month    number                         not null,
   week_number_of_quarter  number                         not null,
   week_number_of_year     number                         not null,
   month_number_of_year    number                         not null,
   quarter_number_of_year  number                         not null,
   year_number             number                         not null,
   week_begin_dt           date                           not null,
   week_end_dt             date                           not null,
   month_id                number                         not null,
   month_begin_dt          date                           not null,
   month_end_dt            date                           not null,
   quarter_id              number                         not null,
   quarter_start_dt        date                           not null,
   quarter_end_dt          date                           not null,
   year_id                 number                         not null,
   year_fd                 date                           not null,
   year_ld                 date                           not null,
   insert_dt               date                           not null,
   update_dt               date                           not null,
   constraint PK_DW_DATE primary key (date_id)
)
tablespace ts_dw_data;


drop table TS_DW_DATA_USER.DW_LOCATION
create table TS_DW_DATA_USER.DW_LOCATION
(
   location_id          number                         not null,
   location_desc        varchar(100)                    not null,
   country_id           number                         not null,
   country_name         varchar(100)                    not null,
   region_id            number                         not null,
   region_code          varchar(100)                    null,
   region_name          varchar(100)                    not null,
   part_id              number                         not null,
   part_code            varchar(100)                    null,
   part_name            varchar(100)                    not null,
   geo_system_id        number                         not null,
   geo_system_code      varchar(100)                    not null,
   geo_system_name      varchar(100)                    not null,
   insert_dt            date                           not null,
   update_dt            date                           not null,
   constraint PK_DW_LOCATION primary key (location_id)
)
tablespace ts_dw_data;

drop table TS_DW_DATA_USER.DW_OFFER_SCD 
create table TS_DW_DATA_USER.DW_OFFER_SCD 
(
   offer_id              number                       not null,
   offer_sur_id          number                       not null,
   offer_name            varchar(30)                  not null,
   offer_desc            varchar(30)                  not null,
   offer_act_cost        decimal                      not null,
   offer_days            number                       not null,
   offer_transp_id       number                       not null,
   offer_transp_desc     varchar(30)                  not null,
   is_active             number                       not null,
   insert_dt             date                         not null,
   update_dt             date                         not null,
   constraint PK_DW_OFFER_SCD primary key (offer_sur_id)
)
tablespace ts_dw_data;


drop table TS_DW_DATA_USER.DW_GEN_PERIODS 
create table TS_DW_DATA_USER.DW_GEN_PERIODS 
(
   periods_id           number                         not null,
   periods_desc         varchar(30)                    not null,
   start_dt             number                         not null,
   end_dt               number                         not null,
   insert_dt            date                           not null,
   update_dt            date                           not null,
   constraint PK_DW_GEN_PERIODS primary key (periods_id)
)
tablespace ts_dw_data;

drop table TS_DW_DATA_USER.DW_CUSTOMER 
create table TS_DW_DATA_USER.DW_CUSTOMER 
(
   customer_id          number(20, 0)                     not null,
   customer_desc        varchar2(30 char)                 not null,
   customer_gender      varchar2(10 char)                 not null,
   customer_age         number (20, 0)                    not null,
   customer_number      number (20, 0)                    not null,
   customer_first_name  varchar2(20 char)                 not null,
   customer_last_name   varchar2(20 char)                 not null,   
   insert_dt            date                              not null,
   update_dt            date                              not null,
   constraint PK_DW_CUSTOMER primary key (customer_id)
)
tablespace ts_dw_data;

drop table TS_DW_DATA_USER.DW_TOUR_OPER 
create table TS_DW_DATA_USER.DW_TOUR_OPER 
(
   tour_oper_id           number                              not null,
   tour_oper_name         varchar(30 char)                    not null,
   tour_oper_desc         varchar(30 char)                    not null,
   tour_oper_code         varchar(20 char)                    not null,
   tour_oper_site         varchar(30 char)                    not null,
   insert_dt              date                                not null,
   update_dt              date                                not null,
   constraint PK_DW_TOUR_OPER primary key (tour_oper_id)
)
tablespace ts_dw_data;

drop table TS_DW_DATA_USER.DW_SALES 
create table TS_DW_DATA_USER.DW_SALES 
(
   offer_sur_id       number                         not null,
   tour_oper_id       number                         not null,
   customer_id        number                         not null,
   date_id            number                         not null,
   location_id        number                         not null,
   sales_id           number                         not null,
   periods_id         number                         not null,
   sales_amount       number                         null,
   sales_price        decimal                        null,
   current_country    varchar(20)                    not null,
   insert_dt          date                           not null
)
tablespace ts_dw_data;

alter table TS_DW_DATA_USER.DW_SALES
   add constraint FK_FCT_SALE_REFERENCE_DW_LOCATION foreign key (location_id)
      references TS_DW_DATA_USER.DW_LOCATION (location_id)
      on delete cascade;

alter table TS_DW_DATA_USER.DW_SALES
   add constraint FK_FCT_SALE_REFERENCE_DW_OFFER foreign key (offer_sur_id)
      references TS_DW_DATA_USER.DW_OFFER_SCD (offer_sur_id)
     on delete cascade;

alter table TS_DW_DATA_USER.DW_SALES
   add constraint FK_FCT_SALE_REFERENCE_DW_TOUR_OPER foreign key (tour_oper_id)
      references TS_DW_DATA_USER.DW_TOUR_OPER (tour_oper_id)
      on delete cascade;

alter table TS_DW_DATA_USER.DW_SALES
   add constraint FK_FCT_SALE_REFERENCE_DW_CUSTOMER foreign key (customer_id)
      references TS_DW_DATA_USER.DW_CUSTOMER (customer_id)
      on delete cascade;

--drop constraint FK_FCT_SALE_REFERENCE_DW_DATE;
alter table TS_DW_DATA_USER.DW_SALES
   add constraint FK_FCT_SALE_REFERENCE_DW_DATE foreign key (date_id)
      references TS_DW_DATA_USER.DW_DATE (date_id)
      on delete cascade;

alter table TS_DW_DATA_USER.DW_SALES
   add constraint FK_FCT_SALE_REFERENCE_DW_GEN_PERIODS foreign key (periods_id)
      references TS_DW_DATA_USER.DW_GEN_PERIODS (periods_id)
      on delete cascade;
      
 CREATE OR REPLACE PACKAGE SAL_CL_USER.pkg_star_cleansing_lv

AS
  
   PROCEDURE load_st_tour_oper;

   PROCEDURE load_st_date;

   PROCEDURE load_st_location;

   PROCEDURE load_st_customer;
   
   PROCEDURE load_st_gen_periods;
   
   PROCEDURE load_st_offer;
   
   PROCEDURE load_st_sales;

   
END;


CREATE OR REPLACE PACKAGE SAL_DW_CL_USER.pkg_prep_star_cleansing_lv

AS
  
   PROCEDURE load_prep_st_tour_oper;

   PROCEDURE load_prep_st_date;

   PROCEDURE load_prep_st_location;

   PROCEDURE load_prep_st_customer;
   
   PROCEDURE load_prep_st_gen_periods;
   
   PROCEDURE load_prep_st_offer;
   
   PROCEDURE load_prep_st_sales;

   
END;


CREATE OR REPLACE PACKAGE DW_CL_USER.pkg_dw_cl

AS
  
   PROCEDURE load_sa_customer;

   PROCEDURE load_sa_sales;

   PROCEDURE load_sa_tour_oper;

   PROCEDURE load_sa_offer;

   
END;

commit;