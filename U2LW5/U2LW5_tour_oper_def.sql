DECLARE
 min_num           NUMBER;
 max_num           NUMBER;
 sql_stmt3         VARCHAR2(2000);
 
 
BEGIN   
 sql_stmt3 := 'SELECT min(tour_oper_id) FROM ts_dw_data_user.dw_tour_oper';
 EXECUTE IMMEDIATE sql_stmt3 INTO min_num;
 EXECUTE IMMEDIATE 'SELECT max(tour_oper_id) FROM ts_dw_data_user.dw_tour_oper' INTO max_num;
 dw_cl_user.etl_tour_oper(min_num, max_num); 
     
END;