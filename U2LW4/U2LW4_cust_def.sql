 GRANT ALL PRIVILEGES ON sa_customer_user.sa_customer TO dw_cl_user;
 GRANT ALL PRIVILEGES ON ts_dw_data_user.dw_customer TO dw_cl_user;
 GRANT UNLIMITED TABLESPACE TO ts_dw_data_user;
CREATE OR REPLACE PACKAGE dw_cl_user.pkg_etl_dim_customer_dw
    AS
    PROCEDURE load_customer;
END;
/