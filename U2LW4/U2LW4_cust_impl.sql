CREATE OR REPLACE PACKAGE BODY DW_CL_USER.pkg_etl_dim_customer_dw

AS
   PROCEDURE load_customer
   AS
   BEGIN
      MERGE INTO ts_dw_data_user.dw_customer target
           USING (SELECT * FROM sa_customer_user.sa_customer ) source
              ON ( target.customer_id = source.customer_id)
      WHEN NOT MATCHED THEN
         INSERT (customer_id
                 , customer_desc
                 , customer_gender
                 , customer_age
                 , customer_number
                 , customer_first_name
                 , customer_last_name
                 , insert_dt
                 , update_dt)
             VALUES (source.customer_id
             , source.customer_desc
             , source.customer_gender
             , source.customer_age
             , source.customer_number
             , source.customer_first_name
             , source.customer_last_name
             , (select CURRENT_DATE from DUAL)
             , (select CURRENT_DATE from DUAL))
      WHEN MATCHED THEN
         UPDATE SET target.customer_desc=source.customer_desc
                    , target.customer_gender=source.customer_gender
                    , target.customer_age=source.customer_age 
                    , target.customer_number=source.customer_number
                    , target.customer_first_name=source.customer_first_name
                    , target.customer_last_name=source.customer_last_name
                    , target.update_dt= (select CURRENT_DATE from dual);

      --Commit Resulst
      COMMIT;
   END load_customer;
END;
/


grant all on sa_customer_user.sa_customer to DW_CL_USER;
grant all on sa_customer_user.sa_customer to ts_dw_data_user;
grant all on ts_dw_data_user.dw_customer to DW_CL_USER;
commit;


select * from ts_dw_data_user.dw_customer
