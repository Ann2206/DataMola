GRANT ALL PRIVILEGES ON sa_offer_user.sa_offer TO dw_cl_user;
GRANT ALL PRIVILEGES ON ts_dw_data_user.dw_offer_scd TO dw_cl_user;

CREATE OR REPLACE PACKAGE dw_cl_user.pkg_etl_dim_offer_dw
AS
    CURSOR curs IS SELECT offer_id FROM SA_OFFER_USER.sa_offer;
    I   NUMBER;
    X   NUMBER;
    y   NUMBER;
    z   NUMBER;
    xxx NUMBER;
    PROCEDURE load_offer;
END;

select * from v$session;
alter SYSTEM kill SESSION '415,56012';
alter SYSTEM kill SESSION '137,62792';
alter SYSTEM kill SESSION '35,45953';