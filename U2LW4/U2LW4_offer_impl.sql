CREATE OR REPLACE PACKAGE BODY DW_CL_USER.pkg_etl_dim_offer_dw AS

   PROCEDURE load_offer
   IS
        BEGIN
        IF curs %ISOPEN THEN
        CLOSE curs ;
        END IF;
        OPEN curs;
        LOOP
            BEGIN
             FETCH curs INTO  I; 
              EXIT WHEN curs%NOTFOUND;  
            SELECT offer_id       INTO X FROM TS_DW_DATA_USER.dw_offer_scd  WHERE offer_sur_id = I;
            SELECT offer_act_cost INTO y FROM sa_offer_user.sa_offer        WHERE offer_id = I;
            SELECT offer_act_cost INTO z FROM ts_dw_data_user.dw_offer_scd  WHERE offer_sur_id = I;
                IF y = z THEN
                UPDATE ts_dw_data_user.dw_offer_scd
                   SET ts_dw_data_user.dw_offer_scd.offer_name      = (SELECT offer_name         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_desc         = (SELECT offer_desc         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_act_cost     = (SELECT offer_act_cost     FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_days         = (SELECT offer_days         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_transp_id    = (SELECT offer_transp_id    FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_transp_desc  = (SELECT offer_transp_desc  FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.update_dt          = (SELECT CURRENT_DATE       FROM DUAL)
                WHERE ts_dw_data_user.dw_offer_scd.offer_id         = I;
                ELSE
                        
                        
                SELECT MIN(offer_sur_id) INTO xxx  FROM ts_dw_data_user.dw_offer_scd;   
                
                UPDATE ts_dw_data_user.dw_offer_scd
                SET 
                    ts_dw_data_user.dw_offer_scd.offer_sur_id      = (xxx - 1),
                    ts_dw_data_user.dw_offer_scd.offer_name        = (SELECT offer_name         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_desc        = (SELECT offer_desc         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_days        = (SELECT offer_days         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_transp_id   = (SELECT offer_transp_id    FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.offer_transp_desc = (SELECT offer_transp_desc  FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I),
                    ts_dw_data_user.dw_offer_scd.update_dt         = (SELECT CURRENT_DATE       FROM DUAL),
                    ts_dw_data_user.dw_offer_scd.is_active         = 0                 
                WHERE ts_dw_data_user.dw_offer_scd.offer_id = I AND ts_dw_data_user.dw_offer_scd.offer_act_cost = z;
                
                
                INSERT INTO ts_dw_data_user.dw_offer_scd(offer_id, offer_sur_id, offer_name, offer_desc, offer_act_cost, offer_days, offer_transp_id, offer_transp_desc, is_active, insert_dt, update_dt)
                VALUES (I
                        , I 
                        , (SELECT offer_name         FROM sa_offer_user.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_desc         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_act_cost     FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_days         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_transp_id    FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_transp_desc  FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , 1
                        , (SELECT CURRENT_DATE  FROM DUAL)
                        , (SELECT CURRENT_DATE  FROM DUAL));
                END IF;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                INSERT INTO ts_dw_data_user.dw_offer_scd(offer_id
                                                         , offer_sur_id
                                                         , offer_name
                                                         , offer_desc
                                                         , offer_act_cost
                                                         , offer_days
                                                         , offer_transp_id
                                                         , offer_transp_desc
                                                         , is_active
                                                         , insert_dt
                                                         , update_dt) 
                VALUES (I
                        , I 
                        , (SELECT offer_name         FROM sa_offer_user.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_desc         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_act_cost     FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_days         FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_transp_id    FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , (SELECT offer_transp_desc  FROM SA_OFFER_USER.sa_offer  WHERE offer_id = I)
                        , 1
                        , (SELECT CURRENT_DATE  FROM DUAL)
                        , (SELECT CURRENT_DATE  FROM DUAL));
            END;
        END LOOP;
        COMMIT;	
        
        CLOSE curs;
        

   END load_offer;
END;
/

select * from ts_dw_data_user.dw_offer_scd