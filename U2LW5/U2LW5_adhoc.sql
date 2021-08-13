VARIABLE n_all_data NUMBER;
VARIABLE n_customer NUMBER;
VARIABLE n_tour_oper NUMBER;
VARIABLE n_summary NUMBER;

BEGIN
 -- set values to 0 to disable
 :n_all_data := 0; -- 1 to enable
 :n_customer := 2; -- 2 to enable
 :n_tour_oper  := 0; -- 3 to enable
 :n_summary  := 4; -- 4 to enable
END;
/

 SELECT /*+ gather_plan_statistics */
          o.offer_desc offer
        , countries.location_desc country
        , decode(GROUPING(T.tour_oper_desc),1,'ALL TOUR OPERS',T.tour_oper_desc) tour_oper
        , decode(GROUPING(cus.customer_desc),1,'ALL CUSTOMERS',cus.customer_desc) customer
        , d.month_number_of_year month
        , gen.periods_desc periods
        , SUM(S.sales_amount) sales_amount_
   FROM ts_dw_data_user.dw_sales s
        , ts_dw_data_user.dw_date d
        , ts_dw_data_user.dw_tour_oper t
        , ts_dw_data_user.dw_customer cus
        , ts_dw_data_user.dw_offer_scd o
        , ts_dw_data_user.dw_location countries
        , ts_dw_data_user.dw_gen_periods gen
  WHERE s.date_id = d.date_id 
    AND s.tour_oper_id = t.tour_oper_id 
    AND s.offer_sur_id = o.offer_sur_id 
    AND s.customer_id = cus.customer_id 
    AND d.year_id IN (2019) 
    AND d.month_number_of_year BETWEEN 1 AND 13
    AND s.location_id = countries.country_id
    AND s.periods_id = gen.periods_id
  GROUP BY d.month_number_of_year
           , o.offer_desc
           , gen.periods_desc
           , countries.location_desc
           , ROLLUP(t.tour_oper_desc, cus.customer_desc)
 HAVING GROUPING_ID(t.tour_oper_desc,cus.customer_desc)+1 IN(:n_all_data,:n_customer,:n_tour_oper,:n_summary)
  ORDER BY 5, 1, 2, 3, 4, 6;
  
  

create or replace view dw_cl_user.mmmain as 
SELECT
        s.sales_id  id
        ,o.offer_desc offer
        , countries.location_desc country
        , t.tour_oper_desc tour_oper
        , cus.customer_desc customer
        , d.month_number_of_year month
        , gen.periods_desc periods
        , S.sales_amount sales_amount_
   FROM   ts_dw_data_user.dw_sales s
        , ts_dw_data_user.dw_date d
        , ts_dw_data_user.dw_tour_oper t
        , ts_dw_data_user.dw_customer cus
        , ts_dw_data_user.dw_offer_scd o
        , ts_dw_data_user.dw_location countries
        , ts_dw_data_user.dw_gen_periods gen
  WHERE s.date_id = d.date_id 
    AND s.tour_oper_id = t.tour_oper_id 
    AND s.offer_sur_id = o.offer_sur_id 
    AND s.customer_id = cus.customer_id 
    AND d.year_id IN (2018) 
    AND d.month_number_of_year BETWEEN 1 AND 13
    AND s.location_id = countries.location_id
    AND s.periods_id = gen.periods_id;

SET AUTOTRACE ON;
--set timing on;
   SELECT /*+ gather_plan_statistics */ *
     FROM dw_cl_user.mmmain
    GROUP BY  month, tour_oper, customer, country, periods
    MODEL
DIMENSION BY (SUM(id) AS ID)
 MEASURES (tour_oper
           , SUM(sales_amount_) sales_amount_
           , periods
           , customer
           , country
           , MONTH
           ,0 AS income)
    RULES (income[ANY] = sales_amount_[cv()]);