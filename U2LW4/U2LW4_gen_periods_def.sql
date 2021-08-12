CREATE TABLE gen_periods(
    periods_id NUMBER NOT NULL, 
	periods_desc VARCHAR2(30 BYTE) NOT NULL, 
	start_dt NUMBER NOT NULL, 
	end_dt NUMBER NOT NULL
);
--truncate TABLE gen_periods
INSERT INTO gen_periods(periods_id
                        , periods_desc
                        , start_dt
                        , end_dt)
--VALUES (1, 'travel period', 900001, 1000000);
--VALUES (2, 'travel period', 900001, 1000000);
--VALUES (3, 'travel period', 900001, 1000000);
VALUES (4, 'travel period', 900001, 1000000);
commit;

GRANT ALL PRIVILEGES ON astepanenko.gen_periods TO dw_cl_user;
GRANT ALL PRIVILEGES ON ts_dw_data_user.dw_gen_periods TO dw_cl_user;

CREATE OR REPLACE PACKAGE dw_cl_user.pkg_etl_dim_gen_periods_dw
AS
    TYPE curs IS REF CURSOR; 
    TYPE ids IS TABLE OF NUMBER;
    periods_ids_array ids ;
    updt_periods_ids_array ids ;
    PROCEDURE load_gen_periods(first_curs IN OUT curs, second_curs IN OUT curs);

END;
/

select*from astepanenko.gen_periods