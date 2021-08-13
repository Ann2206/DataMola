CREATE OR REPLACE PROCEDURE DW_CL_USER.etl_tour_oper(min_stmt NUMBER, max_stmt NUMBER) IS
  TYPE CurType IS REF CURSOR;
  src_cur         CurType;
  src_cur2        CurType;
  curid           NUMBER;
  curid2          NUMBER;
  sql_stmt        VARCHAR2(200);
  sql_stmt2       VARCHAR2(200);
  ret             INTEGER;
  empnos          DBMS_SQL.Number_Table;
  depts           DBMS_SQL.Number_Table;
  TYPE ids IS TABLE OF NUMBER;
  updt_tour_oper_ids_array ids ;
  tour_oper_ids_array ids ;
BEGIN


  curid := DBMS_SQL.OPEN_CURSOR;
 
  sql_stmt  :=     'SELECT tour_oper_id FROM sa_tour_oper_user.sa_tour_oper where tour_oper_id between :b1 and :b2';
  sql_stmt2 :=     'SELECT tour_oper_id FROM sa_tour_oper_user.sa_tour_oper where tour_oper_id > :1';

  DBMS_SQL.PARSE(curid, sql_stmt, DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(curid, 'b1', min_stmt);
  DBMS_SQL.BIND_VARIABLE(curid, 'b2', max_stmt);
  ret := DBMS_SQL.EXECUTE(curid);

  -- Switch from DBMS_SQL to native dynamic SQL
  src_cur := dbms_sql.to_refcursor(curid);

  -- Fetch with native dynamic SQL
  FETCH src_cur BULK COLLECT INTO updt_tour_oper_ids_array;

  FORALL j IN updt_tour_oper_ids_array.FIRST .. updt_tour_oper_ids_array.LAST
                UPDATE ts_dw_data_user.dw_tour_oper   
                SET       tour_oper_name = (SELECT tour_oper_name FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = updt_tour_oper_ids_array(j))
                        , tour_oper_desc = (SELECT tour_oper_desc FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = updt_tour_oper_ids_array(j))
                        , tour_oper_code = (SELECT tour_oper_code FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = updt_tour_oper_ids_array(j))
                        , tour_oper_site = (SELECT tour_oper_site FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = updt_tour_oper_ids_array(j))
                        , update_dt =    (SELECT current_date FROM dual)
                WHERE tour_oper_id = updt_tour_oper_ids_array(j);
    COMMIT;	
   -- Close cursor
  CLOSE src_cur;
  
  curid2 := dbms_sql.open_cursor;
  dbms_sql.parse(curid2, sql_stmt2, dbms_sql.NATIVE);
  dbms_sql.bind_variable(curid2, '1', max_stmt);
  ret := dbms_sql.EXECUTE(curid2);
  src_cur2 := dbms_sql.to_refcursor(curid2);
  
  FETCH src_cur2 BULK COLLECT INTO tour_oper_ids_array;

        FORALL I IN tour_oper_ids_array.FIRST .. tour_oper_ids_array.LAST
                INSERT INTO ts_dw_data_user.dw_tour_oper(tour_oper_id
                                                        , tour_oper_name
                                                        , tour_oper_desc
                                                        , tour_oper_code
                                                        , tour_oper_site
                                                        , insert_dt
                                                        , update_dt)
                VALUES (tour_oper_ids_array(I)
                        , (SELECT tour_oper_name FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = tour_oper_ids_array(I))
                        , (SELECT tour_oper_desc FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = tour_oper_ids_array(I))
                        , (SELECT tour_oper_code FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = tour_oper_ids_array(I))
                        , (SELECT tour_oper_site FROM sa_tour_oper_user.sa_tour_oper WHERE tour_oper_id = tour_oper_ids_array(I))
                        , (SELECT current_date FROM dual)
                        , (SELECT current_date FROM dual));
        COMMIT;	
        
        CLOSE src_cur2;
  
END;

SELECT * FROM ts_dw_data_user.dw_tour_oper