CREATE OR REPLACE PACKAGE BODY DW_CL_USER.pkg_etl_dim_date_dw AS

   PROCEDURE load_date(curs IN OUT date_curs)
   IS
        BEGIN
        
        OPEN curs FOR select astepanenko.dim_date.date_key from astepanenko.dim_date;
        LOOP
            BEGIN
            FETCH curs INTO  I; 
            EXIT WHEN curs%NOTFOUND;  
            select date_id into x from  ts_dw_data_user.dw_date where date_id = I;
                UPDATE ts_dw_data_user.dw_date
                SET ts_dw_data_user.dw_date.date_full = (select date_full from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.date_desc = (select date_full_string from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.date_full_string = (select date_full_string from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.date_weekday_fl = (select date_weekday_fl from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.date_is_holiday = (select date_is_holiday from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.week_last_day = (select week_last_day from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.month_last_day = (select month_last_day from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.quarter_last_day = (select quarter_last_day from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.year_last_day = (select year_last_day from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.day_of_week_name = (select day_of_week_name from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.month_name= (select month_name from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.day_id = (select day_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.day_of_week_number = (select day_number_of_week from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.day_of_month_number = (select day_number_of_month from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.day_of_quarter_number = (select day_number_of_qtr from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.day_of_year_number = (select day_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.week_id = (select week_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.week_number_of_month = (select week_number_of_month from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.week_number_of_quarter = (select week_number_of_qtr from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.week_number_of_year = (select week_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.month_number_of_year = (select month_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.quarter_number_of_year = (select qtr_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.year_number = (select year_number from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.week_begin_dt = (select week_begin_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.week_end_dt = (select week_end_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.month_id = (select month_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.month_begin_dt = (select date_month_begin_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.month_end_dt = (select date_month_end_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.quarter_id = (select qtr_number_of_year from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.quarter_start_dt = (select qtr_begin_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.quarter_end_dt = (select qtr_end_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.year_id = (select year_number from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.year_fd = (select date_yr_begin_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.year_ld = (select date_yr_end_dt from astepanenko.dim_date where date_key = I),
                    ts_dw_data_user.dw_date.update_dt = (select CURRENT_DATE FROM DUAL)
                WHERE ts_dw_data_user.dw_date.date_id  = I;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                Insert into ts_dw_data_user.dw_date(date_id, date_full, date_desc, date_full_string, date_weekday_fl, date_is_holiday, week_last_day,
                                                    month_last_day, quarter_last_day, year_last_day, day_of_week_name, month_name,
                                                    day_id, day_of_week_number, day_of_month_number, day_of_quarter_number, day_of_year_number, week_id,
                                                    week_number_of_month, week_number_of_quarter, week_number_of_year, month_number_of_year, quarter_number_of_year,
                                                    year_number, week_begin_dt, week_end_dt, 
                                                    month_id, month_begin_dt, month_end_dt, quarter_id,
                                                    quarter_start_dt, quarter_end_dt, year_id, year_fd, year_ld, insert_dt, update_dt)
                VALUES (I, (select date_full from astepanenko.dim_date where date_key = I), (select date_full_string from astepanenko.dim_date where date_key = I),
                        (select date_full_string from astepanenko.dim_date where date_key = I), (select date_weekday_fl from astepanenko.dim_date where date_key = I),
                        (select date_is_holiday from astepanenko.dim_date where date_key = I), (select week_last_day from astepanenko.dim_date where date_key = I),
                        (select month_last_day from astepanenko.dim_date where date_key = I), (select qtr_last_day from astepanenko.dim_date where date_key = I),
                        (select year_last_day from astepanenko.dim_date where date_key = I), (select day_of_week_name from astepanenko.dim_date where date_key = I),
                        (select month_name from astepanenko.dim_date where date_key = I), (select day_number_of_year from astepanenko.dim_date where date_key = I),
                        (select day_number_of_week from astepanenko.dim_date where date_key = I), (select day_number_of_month from astepanenko.dim_date where date_key = I),
                        (select day_number_of_qtr from astepanenko.dim_date where date_key = I), (select day_number_of_year from astepanenko.dim_date where date_key = I),
                        (select week_number_of_year from astepanenko.dim_date where date_key = I), (select week_number_of_month from astepanenko.dim_date where date_key = I),
                        (select week_number_of_qtr from astepanenko.dim_date where date_key = I), (select week_number_of_year from astepanenko.dim_date where date_key = I),
                        (select month_number_of_year from astepanenko.dim_date where date_key = I), (select qtr_number_of_year from astepanenko.dim_date where date_key = I),
                        (select year_number from astepanenko.dim_date where date_key = I), (select week_begin_dt from astepanenko.dim_date where date_key = I),
                        (select week_end_dt from astepanenko.dim_date where date_key = I), (select month_number_of_year from astepanenko.dim_date where date_key = I),
                        (select date_month_begin_dt from astepanenko.dim_date where date_key = I), (select date_month_end_dt from astepanenko.dim_date where date_key = I),
                        (select qtr_number_of_year from astepanenko.dim_date where date_key = I), (select qtr_begin_dt from astepanenko.dim_date where date_key = I),
                        (select qtr_end_dt from astepanenko.dim_date where date_key = I),
                        (select year_number from astepanenko.dim_date where date_key = I), (select date_yr_begin_dt from astepanenko.dim_date where date_key = I),
                        (select date_yr_end_dt from astepanenko.dim_date where date_key = I), (select CURRENT_DATE FROM DUAL), (select CURRENT_DATE FROM DUAL));
            
        END;
        END LOOP;
        COMMIT;	
        
        CLOSE curs;
        
   END load_date;
END;
/


grant unlimited tablespace to DW_CL_USER;
grant unlimited tablespace to ts_dw_data_user;
grant all on astepanenko.dim_date to DW_CL_USER;
grant all on astepanenko.dim_date to ts_dw_data_user;
grant all on ts_dw_data_user.dw_date to DW_CL_USER;
grant select, insert, update, delete on astepanenko.dim_date to ts_dw_data_user;
grant select, insert, update, delete on astepanenko.dim_date to DW_CL_USER;

commit;


select * from  ts_dw_data_user.dw_date