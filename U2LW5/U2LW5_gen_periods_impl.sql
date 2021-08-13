CREATE OR REPLACE PROCEDURE DW_CL_USER.etl_gen_periods (
     column_list_in VARCHAR2
     , c_id_in  IN astepanenko.gen_periods.periods_id%TYPE
     , c_id_in2 IN astepanenko.gen_periods.periods_id%TYPE
)
IS
   sql_stmt   CLOB;
   sql_stmt2  CLOB;
   src_cur    SYS_REFCURSOR;
   src_cur2   SYS_REFCURSOR;
   curid      NUMBER;
   curid2     NUMBER;
   desctab    DBMS_SQL.desc_tab;
   colcnt     NUMBER;
   desctab2   DBMS_SQL.desc_tab;
   colcnt2    NUMBER;
   numvar     NUMBER;
   numvar2    NUMBER;
BEGIN

   sql_stmt :=
      'SELECT '
      || column_list_in
      || ' FROM astepanenko.gen_periods WHERE periods_id between :1 and :2';
      
   OPEN src_cur FOR sql_stmt USING c_id_in, c_id_in2;
   curid := DBMS_SQL.to_cursor_number (src_cur);
   DBMS_SQL.describe_columns          (curid, colcnt, desctab);
   DBMS_SQL.define_column             (curid, 1, numvar);
   
   WHILE DBMS_SQL.fetch_rows (curid) > 0
   LOOP
        DBMS_SQL.COLUMN_VALUE (curid, 1, numvar);
        UPDATE ts_dw_data_user.dw_gen_periods   
           SET       periods_desc    = (SELECT periods_desc FROM astepanenko.gen_periods WHERE periods_id = numvar)
                        , start_dt = (SELECT start_dt   FROM astepanenko.gen_periods WHERE periods_id = numvar)
                        , end_dt   = (SELECT end_dt     FROM astepanenko.gen_periods WHERE periods_id = numvar)
                        , update_dt    = (SELECT CURRENT_DATE   FROM DUAL)
         WHERE periods_id = numvar;
        COMMIT;	
   END LOOP;
   DBMS_SQL.close_cursor (curid);
   
   sql_stmt2 :=
      'SELECT '
      || column_list_in
      || ' FROM astepanenko.gen_periods WHERE periods_id > :1';
      
   OPEN src_cur2 FOR sql_stmt2 USING c_id_in2;
   curid2 := DBMS_SQL.to_cursor_number (src_cur2);
   DBMS_SQL.describe_columns           (curid2, colcnt2, desctab2);
   DBMS_SQL.define_column              (curid2, 1, numvar2);
   
   WHILE DBMS_SQL.fetch_rows (curid2) > 0
   LOOP
       DBMS_SQL.COLUMN_VALUE (curid2, 1, numvar2);
       INSERT INTO ts_dw_data_user.dw_gen_periods(periods_id
                                                  , periods_desc
                                                  , start_dt
                                                  , end_dt
                                                  , insert_dt
                                                  , update_dt)
       VALUES           (numvar2
                        , (SELECT periods_desc FROM astepanenko.gen_periods WHERE periods_id = numvar2)
                        , (SELECT start_dt   FROM astepanenko.gen_periods WHERE periods_id = numvar2)
                        , (SELECT end_dt     FROM astepanenko.gen_periods WHERE periods_id = numvar2)
                        , (SELECT CURRENT_DATE   FROM DUAL)
                        , (SELECT CURRENT_DATE   FROM DUAL));
	
        COMMIT;	
   END LOOP;
   DBMS_SQL.close_cursor (curid2);
END;


select * from ts_dw_data_user.dw_gen_periods