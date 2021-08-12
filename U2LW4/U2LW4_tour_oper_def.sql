
CREATE OR REPLACE PACKAGE DW_CL_USER.pkg_etl_dim_tour_oper_dw
AS
    CURSOR tour IS SELECT tour_oper_id FROM sa_tour_oper_user.sa_tour_oper where tour_oper_id not in (SELECT tour_oper_id FROM ts_dw_data_user.dw_tour_oper);
    CURSOR tour_updt IS SELECT tour_oper_id FROM sa_tour_oper_user.sa_tour_oper where tour_oper_id in (SELECT tour_oper_id FROM ts_dw_data_user.dw_tour_oper);
    TYPE type1 IS TABLE OF NUMBER;
    tour_oper_array type1 ;
    updt_tour_oper_array type1 ;
    PROCEDURE load_tour_oper;
END;
/