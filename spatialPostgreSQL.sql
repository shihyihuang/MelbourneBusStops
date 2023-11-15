/***** Create schema *****/
create schema a5;

/***** Restore the table in the spatial database *****/
/*
docker exec -it <dockerId> bash
cd /data/vector
wget "transfered google drive url" -O toBusLoop.gpx
ogr2ogr PG: "dbnamegisdb user=postgres" "toBusLoop. gpx" -nln a5.shua0107 -overwrite
 */

/******* 2 Pre-processing data *******/
alter table a5.shua0107 
drop column track_fid,
drop column track_seg_id,
drop column magvar,
drop column geoidheight,
drop column name,
drop column cmt,
drop column "desc",
drop column src,
drop column link1_href,
drop column link1_text,
drop column link1_type,
drop column link2_href,
drop column link2_text,
drop column link2_type,
drop column sym,
drop column type,
drop column fix,
drop column sat,
drop column hdop,
drop column vdop,
drop column pdop,
drop column ageofdgpsdata,
drop column dgpsid;

/***** create PTV schema  *****/
CREATE SCHEMA IF NOT EXISTS ptv;

/***** create GTFS tables *****/
-- drop table
drop table if exists ptv.ext_agency;
drop table if exists ptv.ext_calendar_dates;
drop table if exists ptv.ext_calendar;
drop table if exists ptv.ext_shapes;
drop table if exists ptv.ext_routes;
drop table if exists ptv.ext_trips;
drop table if exists ptv.ext_stops;
drop table if exists ptv.ext_stop_times;
drop table if exists ptv.agency;
drop table if exists ptv.calendar_dates;
drop table if exists ptv.calendar;
drop table if exists ptv.shapes;
drop table if exists ptv.routes;
drop table if exists ptv.trips;
drop table if exists ptv.stops;
drop table if exists ptv.stop_times;

/* Create agency table */
CREATE TABLE ptv.ext_agency(
agency_id integer,
agency_name varchar(3),
agency_url varchar(100),
agency_timezone varchar(20),
agency_lang varchar(3)
);
-- Load data using COPY method
COPY ptv.ext_agency(agency_id, agency_name, agency_url, agency_timezone, agency_lang)
FROM '/data/adata/gtfs/agency.txt'
delimiter ','
csv header;
-- create the agency table with the geometry column using the data from the ext_agency
create table ptv.agency as
select ea.agency_id ,
ea.agency_name,
ea.agency_url ,
ea.agency_timezone ,
ea.agency_lang
from ptv.ext_agency ea ;

/* Create calendar＿dates table */
CREATE TABLE ptv.ext_calendar_dates(
service_id varchar(10),
date date,
exception_type integer
);
-- Load data using COPY method
COPY ptv.ext_calendar_dates(service_id,date,exception_type)
FROM '/data/adata/gtfs/calendar_dates.txt'
delimiter ','
csv header;
-- create the calendar_dates table with the geometry column using the data from the ext_calendar_dates
create table ptv.calendar_dates as
select ecd.service_id,
ecd.date,
ecd.exception_type
from ptv.ext_calendar_dates ecd;

/* Create calendar table */
CREATE TABLE ptv.ext_calendar(
service_id varchar(20),
monday boolean,
tuesday boolean,
wednesday boolean,
thursday boolean,
friday boolean,
saturday boolean,
sunday boolean,
start_date date,
end_date date
);
-- Load data using COPY method
COPY ptv.ext_calendar(service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date)
FROM '/data/adata/gtfs/calendar.txt'
delimiter ','
csv header;
-- create the calendar table with the geometry column using the data from the ext_calendar
create table ptv.calendar as
select ec.service_id,
ec.monday,
ec.tuesday ,
ec.wednesday ,
ec.thursday,
ec.friday,
ec.saturday,
ec.sunday,
ec.start_date,
ec.end_date
from ptv.ext_calendar ec ;

/* Create shapes table */
CREATE TABLE ptv.ext_shapes(
shape_id varchar(50),
shape_pt_lat numeric(16,13),
shape_pt_lon numeric(16,13),
shape_pt_sequence integer,
shape_dist_traveled numeric(8,2)
);
-- Load data using COPY method
COPY ptv.ext_shapes(shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled)
FROM '/data/adata/gtfs/shapes.txt'
delimiter ','
csv header;
-- create the shapes table with the geometry column using the data from the ext_shapes
create table ptv.shapes as
select es.shape_id,
es.shape_pt_lat,
es.shape_pt_lon ,
es.shape_pt_sequence ,
es.shape_dist_traveled
from ptv.ext_shapes es ;

/* Create routes table */
CREATE TABLE ptv.ext_routes(
route_id varchar(50),
agency_id integer,
route_short_name varchar,
route_long_name varchar(100),
route_type integer,
route_color varchar(6),
route_text_color varchar(6)
);
-- Load data using COPY method
COPY ptv.ext_routes(route_id,agency_id,route_short_name,route_long_name,route_type,route_color,route_text_color)
FROM '/data/adata/gtfs/routes.txt'
delimiter ','
csv header;
-- create the routes table with the geometry column using the data from the ext_routes
create table ptv.routes as
select er.route_id,
er.agency_id,
er.route_short_name ,
er.route_long_name ,
er.route_type ,
er.route_color ,
er.route_text_color
from ptv.ext_routes er ;

/* Create trips table */
CREATE TABLE ptv.ext_trips(
route_id varchar(50),
service_id varchar(20),
trip_id varchar(50),
shape_id varchar(50),
trip_headsign varchar(50),
direction_id integer
);
-- Load data using COPY method
COPY ptv.ext_trips(route_id,service_id,trip_id,shape_id,trip_headsign,direction_id)
FROM '/data/adata/gtfs/trips.txt'
delimiter ','
csv header;
-- create the trips table with the geometry column using the data from the ext_trips
create table ptv.trips as
select et.route_id,
et.service_id,
et.trip_id ,
et.shape_id ,
et.trip_headsign ,
et.direction_id
from ptv.ext_trips et ;

/* Create stops table */
CREATE TABLE ptv.ext_stops(
stop_id integer,
stop_name varchar(100),
stop_lat numeric(16,13),
stop_lon numeric(16,13)
);
-- Load data using COPY method
COPY ptv.ext_stops(stop_id,stop_name,stop_lat,stop_lon)
FROM '/data/adata/gtfs/stops.txt'
delimiter ','
csv header;
-- create the stops table with the geometry column using the data from the ext_stops
create table ptv.stops as
select es.stop_id,
es.stop_name,
es.stop_lat ,
es.stop_lon
from ptv.ext_stops es ;

/* Create stop_times table */
CREATE TABLE ptv.ext_stop_times(
trip_id varchar(50),
arrival_time varchar(8),
departure_time varchar(8),
stop_id integer,
stop_sequence integer,
stop_headsign varchar(1),
pickup_type char(1),
drop_off_type char(1),
shape_dist_traveled varchar(10)
);
-- Load data using COPY method
COPY ptv.ext_stop_times(trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,shape_dist_traveled)
FROM '/data/adata/gtfs/stop_times.txt'
delimiter ','
csv header;
-- create the stop_times table with the geometry column using the data from the ext_stop_times
create table ptv.stop_times as
select est.trip_id,
est.stop_id,
est.arrival_time ,
est.departure_time ,
est.stop_sequence ,
est.stop_headsign,
est.pickup_type ,
est.drop_off_type ,
est.shape_dist_traveled
from ptv.ext_stop_times est ;

/***** process ABS Allocation Files *****/
/* Create lga2021 table */
-- drop table
drop table if exists ptv.ext_lga2021;
drop table if exists ptv.lga2021;
-- create ext_lga2021 table
create table ptv.ext_lga2021(
MB_CODE_2021 varchar(15),
LGA_CODE_2021 varchar(5),
LGA_NAME_2021 varchar(60),
STATE_CODE_2021 char(1),
STATE_NAME_2021 varchar(50),
AUS_CODE_2021 char(3),
AUS_NAME_2021 varchar(20),
AREA_ALBERS_SQKM numeric(10,4),
ASGS_LOCI_URI_2021 varchar(100)
);
-- Load data using COPY method
copy ptv.ext_lga2021(MB_CODE_2021,
LGA_CODE_2021,
LGA_NAME_2021,
STATE_CODE_2021,
STATE_NAME_2021,
AUS_CODE_2021,
AUS_NAME_2021,
AREA_ALBERS_SQKM,
ASGS_LOCI_URI_2021)
from
'/data/adata/LGA_2021_AUST.csv'
delimiter ','
csv header;
-- create the lga2021 table with the geometry column using the data from the ext_lga2021
create table ptv.lga2021 as
select
	el.MB_CODE_2021,
	el.LGA_CODE_2021,
	el.LGA_NAME_2021 ,
	el.STATE_CODE_2021 ,
	el.STATE_NAME_2021,
	el.AUS_CODE_2021,
	el.AUS_NAME_2021,
	el.AREA_ALBERS_SQKM,
	el.ASGS_LOCI_URI_2021
from
	ptv.ext_lga2021 el ;

/* Create suburb2021 table */
-- drop table
drop table if exists ptv.ext_suburb2021;
drop table if exists ptv.suburb2021;
-- create ext_suburb2021 table
create table ptv.ext_suburb2021(
MB_CODE_2021 varchar(15),
SAL_CODE_2021 varchar(5),
SAL_NAME_2021 varchar(60),
STATE_CODE_2021 char(1),
STATE_NAME_2021 varchar(50),
AUS_CODE_2021 char(3),
AUS_NAME_2021 varchar(20),
AREA_ALBERS_SQKM numeric(10,
4),
ASGS_LOCI_URI_2021 varchar(100)
);
-- Load data using COPY method
copy ptv.ext_suburb2021(MB_CODE_2021,
SAL_CODE_2021,
SAL_NAME_2021,
STATE_CODE_2021,
STATE_NAME_2021,
AUS_CODE_2021,
AUS_NAME_2021,
AREA_ALBERS_SQKM,
ASGS_LOCI_URI_2021)
from
'/data/adata/SAL_2021_AUST.csv'
delimiter ','
csv header;
-- create the suburb2021 table with the geometry column using the data from the ext_suburb2021
create table ptv.suburb2021 as
select
	es.MB_CODE_2021,
	es.SAL_CODE_2021,
	es.SAL_NAME_2021 ,
	es.STATE_CODE_2021 ,
	es.STATE_NAME_2021,
	es.AUS_CODE_2021,
	es.AUS_NAME_2021,
	es.AREA_ALBERS_SQKM,
	es.ASGS_LOCI_URI_2021
from
	ptv.ext_suburb2021 es ;




/******* 3.1 Speed analysis *******/
-- average speed in kiolmeters per hour (km/h)
-- https://stackoverflow.com/questions/2816544/convert-time-to-seconds-in-postgresql
with walking_time as (
select
	extract(EPOCH
from
	(MAX(time) - MIN(time)))/ 3600 as time_hour
from
	a5.shua0107
),
walking_distance as (
select
	st_length(st_makeline(wkb_geometry)::geography)/ 1000 as distance_km
from
	a5.shua0107
)
select
	round((wd.distance_km / wt.time_hour)::numeric,
	2) as avg_speed_km_h
from
	walking_distance wd
cross join walking_time wt;
-- average speed in meters per second (m/s)
with walking_time as (
select
	extract(EPOCH
from
	(MAX(time) - MIN(time))) as time_sec
from
	a5.shua0107
),
walking_distance as (
select
	st_length(st_makeline(wkb_geometry)::geography) as distance_m
from
	a5.shua0107
)
select
	round((wd.distance_m / wt.time_sec)::numeric,
	2) as avg_speed_m_sec
from
	walking_distance wd
cross join walking_time wt;

/******* 3.2 Further Data Analysis *******/

/***** shortest distance from home to bus loop *****/
-- retrieve geom of start point(home)
with start_point as (
select
	wkb_geometry as start_geom
from
	a5.shua0107
where
	track_seg_point_id = '0')
,
-- retrieve geom of end point(bus loop)
end_point as (
select
	wkb_geometry as end_geom
from
	a5.shua0107
where
	track_seg_point_id = '296'
)
-- calculate cloest distance from start to end point
select
	st_distance(s.start_geom::geography,
	e.end_geom::geography) as distance_m
from
	start_point s,
	end_point e;


/***** create a buffer with 572m(shortest distance to bus loop) from home *****/
-- drop table
drop table a5.buffer_home;
-- create buffer table for further visualization
create table a5.buffer_home as
with start_point as (
select
	ST_SetSRID(wkb_geometry,
	7844) as geom
from
	a5.shua0107
where
	track_seg_point_id = '0'
),
buffer as (
select
	ST_Buffer(sp.geom::geography,
	572) as buffer
from
	start_point sp
)
-- create buffer with centroid
select
	buffer,
	st_centroid(buffer)
from
	start_point
cross join buffer;


/***** identify bus stops located within 572m (in buffer) from home *****/
-- drop table
drop table a5.bus_stops_within_buffer;
-- create bus_within1km table for further visualization 
create table a5.bus_stops_within_buffer as
with start_point as (
select
	ST_SetSRID(wkb_geometry,
	7844) as geom
from
	a5.shua0107
where
	track_seg_point_id = '0'
)
-- identifying bus stops within 572m from start point
select
	srm.stop_id,
	srm.stop_name,
	srm.coordinates
from
	ptv.stops_routes_mel srm
cross join
  start_point
where
	ST_DWithin(srm.coordinates::geography,
	start_point.geom::geography,
	572)
	and vehicle_type = 'Bus';


/***** count how many stops are located within 572m from home *****/
with start_point as (
select
	ST_SetSRID(wkb_geometry,
	7844) as geom
from
	a5.shua0107
where
	track_seg_point_id = '0'
)
select
	count( distinct srm.stop_id)
from
	ptv.stops_routes_mel srm
cross join
  start_point
where
	ST_DWithin(srm.coordinates::geography,
	start_point.geom::geography,
	572)
	and vehicle_type = 'Bus';


/***** find bus routes that serve these stops located within the buffer  *****/
-- find routes that serve stops located within the buffer
with route as (
select
	srm.route_number
from
	ptv.stops_routes_mel srm
join a5.bus_stops_within_buffer bswb on
	srm.stop_id = bswb.stop_id
where
	srm.vehicle_type = 'Bus'
), 
-- find stops for each route
stops_of_route as (
select
	r.route_number,
	srm.coordinates,
	srm.stop_id
from
	ptv.stops_routes_mel srm
join route r on
	srm.route_number = r.route_number
)
-- Select route number and create lines connecting the stops
select
	sor.route_number,
	st_makeline(sor.coordinates)
from
	stops_of_route sor
group by
	sor.route_number;


/***** create table to visualize route 703 
 which serves these stops located within the buffer  *****/
-- drop table
drop table a5.route_703;
-- create table for route 703 
create table a5.route_703 as 
with stops_of_route as (
select
	route_number, 
	coordinates,
	stop_id
from
	ptv.stops_routes_mel 
)
select
	route_number,
	st_makeline(coordinates)
from
	stops_of_route
where
	route_number = '703'
group by
	route_number;


/***** create table to visualize route 737 
 which serves these stops located within the buffer  *****/
-- drop table
drop table a5.route_737;
-- create table for route 737 
create table a5.route_737 as 
with stops_of_route as (
select
	route_number, 
	coordinates,
	stop_id
from
	ptv.stops_routes_mel 
)
select
	route_number,
	st_makeline(coordinates)
from
	stops_of_route
where
	route_number = '737'
group by
	route_number;


/***** create table to visualize route 742 
 which serves these stops located within the buffer  *****/
-- drop table
drop table a5.route_742;
-- create table for route 742 
create table a5.route_742 as 
with stops_of_route as (
select
	route_number, 
	coordinates,
	stop_id
from
	ptv.stops_routes_mel 
)
-- Select route number and create lines connecting the stops
select
	route_number,
	st_makeline(coordinates)
from
	stops_of_route
where
	route_number = '742'
group by
	route_number;


/***** find suburbs intersected with buffer *****/
with intersects_mesh as (
select
	mm.mb_code21
from
	ptv.mb2021_mel mm
join a5.buffer_home bh on
	ST_Intersects(mm.wkb_geometry,
	bh.buffer)
)
select
	sal_name_2021
from
	ptv.suburb2021 s
join intersects_mesh im
on
	s.mb_code_2021 = im.mb_code21
group by
	sal_name_2021;

/***** create table to visualize Clayton
(the suburb intersected with buffer) *****/
-- drop table
drop table a5.suburb_clayton;
-- create table suburb_clayton
create table a5.suburb_clayton as 
 select
	st_union(wkb_geometry)
from
	ptv.suburb2021 s
join ptv.mb2021_mel mm
 on
	s.mb_code_2021 = mm.mb_code21
where
	sal_name_2021 = 'Clayton'
	and state_name_2021 = 'Victoria';

/***** create table to visualize Notting Hill
(the suburb intersected with buffer) *****/
-- drop table
drop table a5.suburb_nottinghill;
-- create table suburb_nottinghill
create table a5.suburb_nottinghill as 
	select
	st_union(wkb_geometry)
from
	ptv.suburb2021 s
join ptv.mb2021_mel mm
 on
	s.mb_code_2021 = mm.mb_code21
where
	sal_name_2021 = 'Notting Hill'
	and state_name_2021 = 'Victoria';


/***** create table to visualize density of bus stops per suburb (stops/km²)  *****/
-- drop table
drop table a5.bus_stops_suburb;
-- create table to visualize
create table a5.bus_stops_suburb as
-- find suburbs within Melbourne
with melbourne_suburbs as (
select
	mm.mb_code21,
	sb.sal_name_2021 as suburb_name
from
	ptv.mb2021_mel mm
join ptv.suburb2021 sb on
	mm.mb_code21 = sb.mb_code_2021
),
-- retrieve distinct bus stops for later counting the amount
bus_stops as (
select
	distinct on
	(srm.stop_id)
        srm.stop_id,
	mm.mb_code21
from
	ptv.stops_routes_mel srm
join ptv.mb2021_mel mm on
	ST_Contains(mm.wkb_geometry,
	srm.coordinates)
where
	srm.vehicle_type = 'Bus'
),
-- retrieve geom for further union for each suburb
geom as (
select
	mm.mb_code21,
	mm.wkb_geometry as geom
from
	ptv.mb2021_mel mm
join ptv.suburb2021 sb on
	mm.mb_code21 = sb.mb_code_2021
),
-- retrieve area size per mesh block for further sum () for each suburb
suburb_area as (
select
	distinct
        mb_code_2021,
	area_albers_sqkm
from
	ptv.suburb2021
)
select
	ms.suburb_name,
	ROUND(COUNT(bs.stop_id) / sa.total_area,
	2) as density,
	ST_Union(geom)
from
	melbourne_suburbs ms
join (
	-- get total area of each suburb
	select
		sb.sal_name_2021 as suburb_name,
		SUM(area_albers_sqkm) as total_area
	from
		ptv.suburb2021 sb
	group by
		sb.sal_name_2021
) sa on
	ms.suburb_name = sa.suburb_name
join geom g on
	ms.mb_code21 = g.mb_code21
left join bus_stops bs on
	ms.mb_code21 = bs.mb_code21
group by
	ms.suburb_name,
	sa.total_area;


/***** create table to visualize density of all stops
(including all types of public transportation) per suburb (stops/km²)  *****/
-- drop table
drop table a5.stops_suburb;
-- create table to visualize
create table a5.stops_suburb as
-- find suburbs within Melbourne
with melbourne_suburbs as (
select
	mm.mb_code21,
	sb.sal_name_2021 as suburb_name
from
	ptv.mb2021_mel mm
join ptv.suburb2021 sb on
	mm.mb_code21 = sb.mb_code_2021
),
-- retrieve all stops for later counting the amount
trans_stops as (
select
	distinct on
	(srm.stop_id)
        srm.stop_id,
	mm.mb_code21
from
	ptv.stops_routes_mel srm
join ptv.mb2021_mel mm on
	ST_Contains(mm.wkb_geometry,
	srm.coordinates)
),
-- retrieve geom for further union for each suburb
geom as (
select
	mm.mb_code21,
	mm.wkb_geometry as geom
from
	ptv.mb2021_mel mm
join ptv.suburb2021 sb on
	mm.mb_code21 = sb.mb_code_2021
),
-- retrieve area size per mesh block for further sum () for each suburb
suburb_area as (
select
	distinct
        mb_code_2021,
	area_albers_sqkm
from
	ptv.suburb2021
)
select
	ms.suburb_name,
	ROUND(COUNT(ts.stop_id) / sa.total_area,
	2) as density,
	ST_Union(geom)
from
	melbourne_suburbs ms
join (
	-- get total area of each suburb
	select
		sb.sal_name_2021 as suburb_name,
		SUM(area_albers_sqkm) as total_area
	from
		ptv.suburb2021 sb
	group by
		sb.sal_name_2021
) sa on
	ms.suburb_name = sa.suburb_name
join geom g on
	ms.mb_code21 = g.mb_code21
left join trans_stops ts on
	ms.mb_code21 = ts.mb_code21
group by
	ms.suburb_name,
	sa.total_area;


/***** number of bus stops in each Suburb *****/
-- create index on column coordinates in stops_routes_mel table
create index idx_stops_routes_mel_coordinates on
ptv.stops_routes_mel
	using GIST (coordinates);
-- find suburb within melbourne
with melbourne_suburbs as (
select
	mm.mb_code21,
	sb.sal_name_2021 as suburb_name
from
	ptv.mb2021_mel mm
join ptv.suburb2021 sb on
	mm.mb_code21 = sb.mb_code_2021
)
,
-- find distinct bus stop 
distinct_bus_stops as (
select
	distinct on
	(srm.stop_id,
	srm.coordinates)
    srm.stop_id,
	mm.mb_code21
from
	ptv.stops_routes_mel srm
join ptv.mb2021_mel mm on
	ST_Contains(mm.wkb_geometry,
	srm.coordinates)
where
	srm.vehicle_type = 'Bus'
)
-- calculate num of bus stops in each suburb 
select
	ms.suburb_name,
	COUNT(dbs.stop_id) as total_bus_stops
from
	melbourne_suburbs ms
left join distinct_bus_stops dbs on
	ms.mb_code21 = dbs.mb_code21
group by
	ms.suburb_name;


/***** 3.2 LGA Blankspot *****/
-- evaluate the residential area without Bus Stops. The residential area without any Bus Stops in it is considered as the Blankspot. 
-- percentage of blankspot in Melbourne Metropolitan

-- filter bus stop 
with bus_stops as (
select
	stop_id,
	coordinates
from
	ptv.stops_routes_mel
where
	vehicle_type = 'Bus'
),
-- find residential areas
residential_area as (
select
	l.lga_name_2021 as lga_name,
	m.wkb_geometry as geom
from
	ptv.mb2021_mel m
join ptv.lga2021 l on
	m.mb_code21 = l.mb_code_2021
where
	m.mb_cat21 = 'Residential'
),
-- retrieve all lga 
lga_list as (
select
	l.lga_name_2021 as lga_name
from
	ptv.mb2021_mel m
join ptv.lga2021 l on
	m.mb_code21 = l.mb_code_2021
group by 
	lga_name
),
-- identify blank spots
blankspot as (
select
	ra.*,
	case
		when exists (
		select
			1
		from
			bus_stops bs
		where
			ST_Contains(ra.geom,
			bs.coordinates)
            ) then 0
		else 1
	end as is_blankspot
from
	residential_area ra
)
-- calculate total residential mesh blocks, total residential blank spots, and percentage blank spots
select
	ll.lga_name,
	COUNT(bs.lga_name) as total_residential_mesh_blocks,
	coalesce(SUM(bs.is_blankspot),
	0) as total_residential_blankspot,
	coalesce(SUM(bs.is_blankspot) * 100.0 / COUNT(bs.lga_name),
	0) as percentage_blank_spot
-- display all lga even though there is no resendential area within it
from
	lga_list ll
left join
	blankspot bs
	on
	bs.lga_name = ll.lga_name
group by
	ll.lga_name
order by
	total_residential_mesh_blocks asc;