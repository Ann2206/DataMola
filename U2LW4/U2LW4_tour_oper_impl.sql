CREATE OR REPLACE PACKAGE BODY DW_CL_USER.pkg_etl_dim_tour_oper_dw AS

   PROCEDURE load_tour_oper 
   IS  
        BEGIN
--        EXECUTE IMMEDIATE 'TRUNCATE TABLE ts_dw_data_user.dw_tour_oper';
        IF tour %ISOPEN THEN
        CLOSE tour ;
        END IF;
        OPEN tour;
        FETCH tour BULK COLLECT INTO tour_oper_array;

        FORALL i IN tour_oper_array.FIRST .. tour_oper_array.LAST
                INSERT INTO ts_dw_data_user.dw_tour_oper(tour_oper_id
                                                         , tour_oper_name
                                                         , tour_oper_desc
                                                         , tour_oper_code
                                                         , tour_oper_site
                                                         , insert_dt
                                                         , update_dt)
                VALUES (tour_oper_array(i)
                        , (SELECT tour_oper_name from sa_tour_oper_user.sa_tour_oper where tour_oper_id = tour_oper_array(i))
                        , (SELECT tour_oper_desc from sa_tour_oper_user.sa_tour_oper where tour_oper_id = tour_oper_array(i))
                        , (SELECT tour_oper_code from sa_tour_oper_user.sa_tour_oper where tour_oper_id = tour_oper_array(i))
                        , (SELECT tour_oper_site from sa_tour_oper_user.sa_tour_oper where tour_oper_id = tour_oper_array(i))
                        , (SELECT CURRENT_DATE FROM DUAL)
                        , (SELECT CURRENT_DATE FROM DUAL));
        COMMIT;	
        
        CLOSE tour;
        
        IF tour_updt %ISOPEN THEN
        CLOSE tour_updt ;
        END IF;
        OPEN tour_updt;
        FETCH tour_updt BULK COLLECT INTO updt_tour_oper_array;
        FORALL j IN updt_tour_oper_array.FIRST .. updt_tour_oper_array.LAST
                UPDATE ts_dw_data_user.dw_tour_oper  
                SET       tour_oper_name = (SELECT tour_oper_name from sa_tour_oper_user.sa_tour_oper where tour_oper_id = updt_tour_oper_array(j))
                        , tour_oper_desc = (SELECT tour_oper_desc from sa_tour_oper_user.sa_tour_oper where tour_oper_id = updt_tour_oper_array(j))
                        , tour_oper_code = (SELECT tour_oper_code from sa_tour_oper_user.sa_tour_oper where tour_oper_id = updt_tour_oper_array(j))
                        , tour_oper_site = (SELECT tour_oper_site from sa_tour_oper_user.sa_tour_oper where tour_oper_id = updt_tour_oper_array(j))
                          , update_dt =    (SELECT CURRENT_DATE FROM DUAL)
                WHERE tour_oper_id = updt_tour_oper_array(j);
        COMMIT;	
        CLOSE tour_updt;
   END load_tour_oper;
END;
/

grant all on sa_tour_oper_user.sa_tour_oper to DW_CL_USER;
grant all on sa_tour_oper_user.sa_tour_oper to ts_dw_data_user;
grant all on ts_dw_data_user.dw_tour_oper to DW_CL_USER;
commit;

select *from ts_dw_data_user.dw_tour_oper;