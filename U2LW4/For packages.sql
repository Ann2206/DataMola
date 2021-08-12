DECLARE
--  TYPE date_curs IS REF CURSOR; 
--  curs date_curs;
    TYPE curs IS REF CURSOR; 
    first_curs curs; 
    second_curs curs;
BEGIN   
 
DW_CL_USER.pkg_etl_dim_sales_dw.load_sales; 

END;


--    DW_CL_USER.pkg_etl_dim_sales_dw.load_sales; 
--    DW_CL_USER.pkg_etl_dim_gen_periods_dw.load_gen_periods(first_curs, second_curs);
--    DW_CL_USER.pkg_etl_dim_location_dw.load_location;
--    DW_CL_USER.pkg_etl_dim_date_dw.load_date(curs);
--    DW_CL_USER.pkg_etl_dim_customer_dw.load_customer;
--    DW_CL_USER.pkg_etl_dim_tour_oper_dw.load_tour_oper;
--    DW_CL_USER.pkg_etl_dim_offer_dw.load_offer;

