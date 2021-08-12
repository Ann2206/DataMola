CREATE OR REPLACE PACKAGE BODY DW_CL_USER.pkg_etl_dim_location_dw AS

   PROCEDURE load_location
   IS
    BEGIN
        OPEN curs;
        LOOP
            BEGIN
            FETCH curs INTO  I; 
            EXIT WHEN curs%NOTFOUND;  
            SELECT country_id INTO X FROM  ts_dw_data_user.dw_location WHERE country_id = I;
                UPDATE ts_dw_data_user.dw_location
                   SET ts_dw_data_user.dw_location.location_id        = I
                       ,ts_dw_data_user.dw_location.location_desc     = (SELECT country_desc FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)                   
                       ,ts_dw_data_user.dw_location.country_name      = (SELECT country_desc FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.region_id        = (SELECT region_id FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.region_code      = (SELECT region_code FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.region_name      = (SELECT region_desc FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.part_id          = (SELECT part_id FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.part_code        = (SELECT part_code FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.part_name        = (SELECT part_desc FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.geo_system_id   = (SELECT geo_systems_id FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.geo_system_code = (SELECT geo_systems_code FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.geo_system_name = (SELECT geo_systems_desc FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                       , ts_dw_data_user.dw_location.update_dt        = (SELECT CURRENT_DATE FROM DUAL)
                WHERE ts_dw_data_user.dw_location.country_id          = I;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                INSERT INTO ts_dw_data_user.dw_location( location_id
                                                         , location_desc
                                                         , country_id
                                                         , country_name
                                                         , region_id
                                                         , region_code
                                                         , region_name
                                                         , part_id
                                                         , part_code
                                                         , part_name
                                                         , geo_system_id
                                                         , geo_system_code
                                                         , geo_system_name
                                                         , insert_dt
                                                         , update_dt) 
                VALUES (I
                        , (SELECT country_desc     FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , I
                        , (SELECT country_desc     FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT region_id        FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT region_code      FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT region_desc      FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT part_id          FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT part_code        FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT part_desc        FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT geo_systems_id   FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT geo_systems_code FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT geo_systems_desc FROM sb_mbackup_user.sb_mbackup WHERE country_id = I)
                        , (SELECT CURRENT_DATE     FROM DUAL)
                        , (SELECT CURRENT_DATE     FROM DUAL));
            END;
        END LOOP;
        COMMIT;	
        
        CLOSE curs;
        

   END load_location;
END;
/

select * from ts_dw_data_user.dw_location
