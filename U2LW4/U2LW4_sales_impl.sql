CREATE OR REPLACE PACKAGE BODY DW_CL_USER.pkg_etl_dim_sales_dw

AS
   PROCEDURE load_sales
   AS
   BEGIN
      MERGE INTO ts_dw_data_user.dw_sales target
           USING (SELECT * FROM sa_tnx_sales_user.sa_tnx_sales ) source
              ON ( target.sales_id = source.sales_id)
      WHEN NOT MATCHED THEN
         INSERT (offer_sur_id
                , tour_oper_id
                , customer_id
                , date_id
                , location_id
                , sales_id
                , periods_id
                , sales_amount
                , sales_price
                , current_country
                , insert_dt)
         VALUES (source.offer_id
                , source.tour_oper_id
                , source.customer_id
                , source.date_key
                , source.location_id
                , source.sales_id
                , source.periods_id
                , source.sales_amount
                , source.sales_price
                , source.current_country 
                , (select CURRENT_DATE from DUAL))
      WHEN MATCHED THEN
         UPDATE 
            SET target.offer_sur_id=source.offer_id
                , target.tour_oper_id=source.tour_oper_id
                , target.customer_id=source.customer_id
                , target.date_id=source.date_key 
                , target.location_id=source.location_id
                , target.periods_id=source.periods_id
                , target.sales_amount=source.sales_amount
                , target.sales_price=source.sales_price
                , target.current_country=source.current_country
                , target.insert_dt= (select CURRENT_DATE from dual);
      --Commit Resulst
      COMMIT;
   END load_sales;
END;
/


select * from ts_dw_data_user.dw_sales

select*FROM sa_tnx_sales_user.sa_tnx_sales;