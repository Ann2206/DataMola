SELECT DISTINCT tour_oper_id
                , location_id
                , date_id
                , FIRST_VALUE(sales_amount) OVER 
       (PARTITION BY tour_oper_id
                    , location_id
                    , date_id 
            ORDER BY sales_amount DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
                  AS "HIGHEST_SALES_AMOUNT"
                , FIRST_VALUE(sales_price) OVER 
       (PARTITION BY tour_oper_id
                    , location_id
                    , date_id 
            ORDER BY sales_price DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                  AS "HIGHEST_SALES_DOLLARS"
  FROM ts_dw_data_user.dw_sales
 ORDER BY tour_oper_id, location_id, date_id;



SELECT DISTINCT offer_sur_id
                , LAST_VALUE(sales_amount) OVER 
                (PARTITION BY offer_sur_id ORDER BY sales_amount DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                AS "LOW_SALES_AMOUNT"
                , LAST_VALUE(sales_price) OVER 
                (PARTITION BY offer_sur_id ORDER BY sales_price DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                AS "LOW_SALES_DOLLARS"
  FROM ts_dw_data_user.dw_sales
 ORDER BY offer_sur_id;

SELECT * FROM (
    SELECT tour_oper_id
           , sales_amount
           , RANK() OVER (PARTITION BY periods_id ORDER BY sales_amount)sales_rank
      FROM ts_dw_data_user.dw_sales
     WHERE periods_id BETWEEN 1 AND 3
)   
 WHERE sales_rank<=10;


SELECT * FROM (
    SELECT tour_oper_id
           , sales_amount
           , DENSE_RANK() OVER (PARTITION BY periods_id ORDER BY sales_amount)sales_rank
      FROM ts_dw_data_user.dw_sales
     WHERE periods_id BETWEEN 1 AND 3
)  
 WHERE sales_rank<=10; 
 

SELECT * FROM (
    SELECT tour_oper_id 
           , sales_amount
           , RANK()       OVER (PARTITION BY periods_id ORDER BY sales_amount)sales_rank
           , DENSE_RANK() OVER (PARTITION BY periods_id ORDER BY sales_amount)sales_dense_rank
           , row_number() OVER (PARTITION BY periods_id ORDER BY sales_amount)sales_rn
      FROM ts_dw_data_user.dw_sales
     WHERE periods_id BETWEEN 1 AND 3
)  
 WHERE sales_rank<=10;


SELECT DISTINCT location_id
                , MAX(sales_amount)
  OVER (PARTITION BY  location_id ORDER BY sales_amount DESC
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
       AS "MAX_SALES_AMOUNT"
                , MAX(sales_price)
  OVER (PARTITION BY  location_id ORDER BY sales_price DESC
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
       AS "MAX_SALES_DOLLARS"
                , MIN(sales_amount)
  OVER (PARTITION BY location_id ORDER BY sales_amount DESC
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
       AS "MIN_SALES_AMOUNT"
                , MIN(sales_price)
  OVER (PARTITION BY location_id ORDER BY sales_price DESC
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
       AS "MIN_SALES_DOLLARS"
                , ROUND(AVG(sales_amount)
  OVER (PARTITION BY location_id ORDER BY sales_amount DESC
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 0)
       AS "AVG_SALES_AMOUNT"
                , ROUND(AVG(sales_price)
  OVER (PARTITION BY location_id ORDER BY sales_price DESC
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),0)
       AS "AVG_SALES_DOLLARS"
  FROM ts_dw_data_user.dw_sales
 ORDER BY location_id;