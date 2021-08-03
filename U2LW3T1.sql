CREATE TABLESPACE SB_MBackUp
DATAFILE '/oracle/u02/oradata/DMORCL21DB/astepanenko_db/SB_MBackUp.dat'
SIZE 200M
 AUTOEXTEND ON NEXT 100M
 SEGMENT SPACE MANAGEMENT AUTO;



CREATE USER SB_MBackUp_USER
  IDENTIFIED BY "%PWD%"
    DEFAULT TABLESPACE SB_MBackUp;

GRANT CONNECT,RESOURCE TO SB_MBackUp_USER;

--drop table SB_MBackUp_USER.SB_MBackUp;
create table SB_MBackUp_USER.SB_MBackUp
(
   country_id           number                         not null,
   country_desc         varchar(100)                   not null,
   region_id            number                         not null,
   region_code          varchar(100)                   null,
   region_desc          varchar(100)                   not null,
   part_id              number                         not null,
   part_code            varchar(100)                   null,
   part_desc            varchar(100)                   not null,
   geo_systems_id       number                         not null,
   geo_systems_code     varchar(100)                   null,
   geo_systems_desc     varchar(100)                   not null
)
tablespace SB_MBackUp;

GRANT UNLIMITED TABLESPACE TO SB_MBackUp_USER;


insert into SB_MBackUp_USER.SB_MBackUp(geo_systems_id,
                                       geo_systems_code,
                                       geo_systems_desc,
                                       part_id,
                                       part_code,
                                       part_desc,
                                       region_id,
                                       region_code,
                                       region_desc,
                                       country_id,
                                       country_desc)
 WITH geo_system AS (
        SELECT geo_id
               , geo_system_id
               , geo_system_code
               , geo_system_desc 
          FROM u_dw_references.lc_geo_systems)
          
               , geo_parts AS (
        SELECT geo_id
               , part_id
               , part_code
               , part_desc 
          FROM u_dw_references.lc_geo_parts)
          
          
               , geo_regions AS (
        SELECT geo_id
               , region_id
               , region_code
               , region_desc 
          FROM u_dw_references.lc_geo_regions) 
          
          
               , geo_countries AS (
        SELECT geo_id
               , country_id
               , country_desc 
        FROM u_dw_references.lc_countries)
        
        
               , link_system_part AS (
        SELECT parent_geo_id
               , child_geo_id 
          FROM u_dw_references.t_geo_object_links 
       CONNECT BY PRIOR child_geo_id = parent_geo_id)
       
       
                , links_part_region AS (
         SELECT parent_geo_id
                , child_geo_id 
           FROM u_dw_references.t_geo_object_links 
        CONNECT BY PRIOR child_geo_id = parent_geo_id)
        
        
                 , links_region_country AS (
          SELECT parent_geo_id
                 , child_geo_id 
            FROM u_dw_references.t_geo_object_links 
         CONNECT BY PRIOR child_geo_id = parent_geo_id)
         
                  , joined AS (
           SELECT geo_system_id
                  , geo_system_code
                  , geo_system_desc
                  , part_id
                  , part_code
                  , part_desc
                  , region_id
                  , region_code
                  , region_desc
                  , country_id
                  , country_desc
             FROM geo_system
                  , geo_parts
                  , geo_regions
                  , geo_countries
                  , link_system_part
                  , links_part_region
                  , links_region_country
            WHERE (geo_system.geo_id = link_system_part.parent_geo_id AND geo_parts.geo_id = link_system_part.child_geo_id) 
                   AND (geo_parts.geo_id = links_part_region.parent_geo_id AND geo_regions.geo_id = links_part_region.child_geo_id) 
                   AND (geo_regions.geo_id = links_region_country.parent_geo_id AND geo_countries.geo_id = links_region_country.child_geo_id))
SELECT DISTINCT * FROM joined;

SELECT * FROM sb_mbackup_user.sb_mbackup ORDER BY country_id;
COMMIT;


CREATE TABLE sb_mbackup_user.sb_mbackup_01
(
   geo_id               NUMBER                         NOT NULL,
   geo_desc             VARCHAR(100)                   NOT NULL,
   geo_code             VARCHAR(100)                   NULL
)
TABLESPACE sb_mbackup;




INSERT INTO sb_mbackup_user.sb_mbackup_01(geo_id, geo_desc, geo_code)
SELECT geo_id, geo_system_desc, geo_system_code FROM u_dw_references.lc_geo_systems;


INSERT INTO sb_mbackup_user.sb_mbackup_01(geo_id, geo_desc, geo_code)
SELECT geo_id, part_desc, part_code FROM u_dw_references.lc_geo_parts;

INSERT INTO sb_mbackup_user.sb_mbackup_01(geo_id, geo_desc, geo_code)
SELECT geo_id, region_desc, region_code FROM u_dw_references.lc_geo_regions;

INSERT INTO sb_mbackup_user.sb_mbackup_01(geo_id, geo_desc)
SELECT geo_id, country_desc FROM u_dw_references.lc_countries;

SELECT * FROM sb_mbackup_user.sb_mbackup_01 ORDER BY geo_id;


ALTER TABLE sb_mbackup_user.sb_mbackup_01 ADD geo_parent_id NUMBER NULL;

TRUNCATE TABLE sb_mbackup_user.sb_mbackup_01;


INSERT INTO sb_mbackup_user.sb_mbackup_01(geo_id
                                          , geo_code
                                          , geo_desc         
                                          , geo_parent_id)
  WITH links AS (
        SELECT parent_geo_id
               , child_geo_id 
          FROM u_dw_references.w_geo_object_links 
         WHERE parent_geo_id < 276 AND child_geo_id < 276
       CONNECT BY PRIOR child_geo_id = parent_geo_id)
         , geo_objects AS (
        SELECT geo_id
               , geo_code
               , geo_desc 
          FROM sb_mbackup_user.sb_mbackup_01)
        , joined AS (
        SELECT geo_id
               , geo_code
               , geo_desc
               , parent_geo_id
          FROM geo_objects
               , links
         WHERE geo_objects.geo_id = links.child_geo_id
)
SELECT DISTINCT * FROM joined ORDER BY geo_id;


SELECT * FROM sb_mbackup_user.sb_mbackup_01 ORDER BY geo_id;

DELETE FROM sb_mbackup_user.sb_mbackup_01 
 WHERE geo_parent_id IS NULL AND geo_id != 246;
COMMIT;


CREATE TABLE sb_mbackup_user.sb_mbackup_001
(
   geo_desc               VARCHAR(100)               NULL,
   geo_code               VARCHAR(100)               NULL,
   geo_id                 NUMBER                     NULL,
   geo_parent_id          NUMBER                     NULL,
   geo_is_leaf            NUMBER                     NULL,
   geo_level              NUMBER                     NULL,
   geo_path               VARCHAR(1000)              NULL,
   geo_type               VARCHAR(100)               NULL,
   geo_count_of_childs    NUMBER                     NULL
)
TABLESPACE sb_mbackup;

GRANT UNLIMITED TABLESPACE TO sb_mbackup_user;
COMMIT;

INSERT INTO sb_mbackup_user.sb_mbackup_001(geo_desc
                                          , geo_code
                                          , geo_id
                                          , geo_parent_id
                                          , geo_is_leaf
                                          , geo_level
                                          , geo_path)
 SELECT E.geo_desc
        , geo_code
        , geo_id
        , geo_parent_id
        , CONNECT_BY_ISLEAF
        , LEVEL
        , sys_connect_by_path(geo_desc,':') PATH
   FROM sb_mbackup_user.sb_mbackup_01 E
  START WITH E.geo_parent_id IS NULL
CONNECT BY PRIOR E.geo_id = E.geo_parent_id
  ORDER SIBLINGS BY E.geo_desc;



SELECT sb_01.geo_parent_id
       , COUNT(sb_01.geo_id) 
  FROM sb_mbackup_user.sb_mbackup_01 sb_01
       , sb_mbackup_user.sb_mbackup_001 sb_001 
 WHERE sb_01.geo_id = sb_001 .geo_id 
 GROUP BY sb_01.geo_parent_id;



SELECT geo_parent_id
       , COUNT(geo_id) 
  FROM sb_mbackup_user.sb_mbackup_01 sb_01  
 GROUP BY sb_01.geo_parent_id 
 ORDER BY geo_parent_id;
 
 
SELECT * FROM sb_mbackup_user.sb_mbackup_001;

UPDATE sb_mbackup_user.sb_mbackup_001 SET geo_type='leaf' WHERE geo_is_leaf = 1 ;
UPDATE sb_mbackup_user.sb_mbackup_001 SET geo_type='branch' WHERE geo_is_leaf = 0 ;
UPDATE sb_mbackup_user.sb_mbackup_001 SET geo_type='root' WHERE geo_parent_id IS NULL ;


MERGE INTO sb_mbackup_user.sb_mbackup_001 TARGET  
USING (SELECT geo_parent_id
              , COUNT(geo_id) kol  
         FROM sb_mbackup_user.sb_mbackup_01 sb_01  
        GROUP BY sb_01.geo_parent_id 
        ORDER BY geo_parent_id) SOURCE   
   ON (TARGET.geo_id = SOURCE.geo_parent_id)  
 WHEN MATCHED
         THEN UPDATE SET TARGET.geo_count_of_childs = SOURCE.kol;

COMMIT;