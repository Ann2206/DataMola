CREATE OR REPLACE PACKAGE BODY dw_cl_user.pkg_etl_dim_locations_2 AS

   PROCEDURE load_locations
   IS
            
        BEGIN
        OPEN curs;
        LOOP
            BEGIN
            FETCH curs INTO  I; 
            EXIT WHEN curs%notfound;  
            sql_stmt := 'select country_id from  ts_dw_data_user.dw_location where country_id = :1';
            EXECUTE IMMEDIATE sql_stmt INTO X USING I;
                UPDATE ts_dw_data_user.dw_location
                SET ts_dw_data_user.dw_location.location_id     = I,
                    ts_dw_data_user.dw_location.location_desc     = (SELECT country_desc     FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.country_name     = (SELECT country_desc     FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.region_id        = (SELECT region_id        FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.region_code        = (SELECT region_code        FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.region_name      = (SELECT region_desc      FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.part_id          = (SELECT part_id          FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.part_code        = (SELECT part_code        FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.part_name        = (SELECT part_desc        FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.geo_system_id   = (SELECT geo_systems_id   FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.geo_system_code = (SELECT geo_systems_code FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),
                    ts_dw_data_user.dw_location.geo_system_name = (SELECT geo_systems_desc FROM sb_mbackup_user.sb_mbackup WHERE country_id = I),            
                    ts_dw_data_user.dw_location.update_dt        = (SELECT current_date     FROM dual)
                WHERE ts_dw_data_user.dw_location.country_id  = I;
            EXCEPTION WHEN no_data_found THEN
                     INSERT INTO ts_dw_data_user.dw_location(location_id
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
                        , (SELECT current_date     FROM dual)
                        , (SELECT current_date     FROM dual));
            END;
        END LOOP;
        COMMIT;	
        
        CLOSE curs;
        

   END load_locations;
END;
/

select * from ts_dw_data_user.dw_location