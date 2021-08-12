CREATE OR REPLACE PACKAGE BODY dw_cl_user.pkg_etl_dim_gen_periods_dw AS

   PROCEDURE load_gen_periods(first_curs IN OUT curs, second_curs IN OUT curs)
   IS
     BEGIN
        OPEN first_curs FOR SELECT periods_id FROM astepanenko.gen_periods WHERE periods_id NOT IN (SELECT periods_id FROM ts_dw_data_user.dw_gen_periods);
        FETCH first_curs BULK COLLECT INTO periods_ids_array;

        FORALL I IN periods_ids_array.FIRST .. periods_ids_array.LAST
                INSERT INTO ts_dw_data_user.dw_gen_periods(periods_id
                                                           , periods_desc
                                                           , start_dt
                                                           , end_dt
                                                           , insert_dt
                                                           , update_dt)
                VALUES (periods_ids_array(I)
                        , (SELECT periods_desc   FROM astepanenko.gen_periods WHERE periods_id = periods_ids_array(I))
                        , (SELECT start_dt       FROM astepanenko.gen_periods WHERE periods_id = periods_ids_array(I))
                        , (SELECT end_dt         FROM astepanenko.gen_periods WHERE periods_id = periods_ids_array(I))
                        , (SELECT current_date   FROM dual)
                        , (SELECT current_date   FROM dual));
        COMMIT;	
        
        CLOSE first_curs;
        

        OPEN second_curs FOR SELECT periods_id FROM astepanenko.gen_periods WHERE periods_id IN (SELECT periods_id FROM ts_dw_data_user.dw_gen_periods);
        FETCH second_curs BULK COLLECT INTO updt_periods_ids_array;
        FORALL j IN updt_periods_ids_array.FIRST .. updt_periods_ids_array.LAST
                UPDATE ts_dw_data_user.dw_gen_periods   
                SET     periods_desc = (SELECT periods_desc   FROM astepanenko.gen_periods WHERE periods_id = updt_periods_ids_array(j))
                        , start_dt   = (SELECT start_dt       FROM astepanenko.gen_periods WHERE periods_id = updt_periods_ids_array(j))
                        , end_dt     = (SELECT end_dt         FROM astepanenko.gen_periods WHERE periods_id = updt_periods_ids_array(j))
                        , update_dt  = (SELECT current_date   FROM dual)
                WHERE periods_id = updt_periods_ids_array(j);
        COMMIT;	
        CLOSE second_curs;
        
            
   END load_gen_periods;
END;
/


select * from ts_dw_data_user.dw_gen_periods