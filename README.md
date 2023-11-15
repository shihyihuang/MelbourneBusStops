## Spatial data - Trajectory Report

---

### **Table of Contents**

- [INTRODUCTION](#intro)
- [METHODOLOGY](#method)
- [RESULTS](#results)
  - [SPEED ANALYSIS](#SPEED_ANALYSIS)
  - [CLOSER BUS STOPS THAN MONASH BUS LOOP: 572M RADIUS ANALYSIS ](#CLOSER_BUS_STOPS)
  - [BUS ROUTES FOR NEARBY STOPS](#BUS_ROUTES_FOR_NEARBY_STOPS)
  - [SUBURBS WITHIN 572 METERS OF MY LOCATION](#SUBURBS_WITHIN_572_METERS)
  - [BUS STOP DENSITY BY SUBURB (STOPS/KM2)](#BUS_STOP_DENSITY)
  - [PUBLIC TRANSPORTATION STOP DENSITY BY SUBURB (STOPS/KM2)](#PUBLIC_TRANSPORTATION_STOP_DENSITY)
- [CONCLUSION](#conclusion)
- [REFERENCE](#reference)

---

### **INTRODUCTION** <a name="intro"></a>

The GPX data, which records the route I usually take from my home to the Monash bus loop, the bus stop I consider to be the closest, is collected through the GPX Tracker app. Additionally, the report utilizes the PTV/GTFS dataset and Australian Boundary data obtained from the official site, with specific details available in the reference.
The report aims to investigate whether there are bus stops nearer to my home than the Monash bus loop and to explore the accessible destinations via the routes of these bus stops. Furthermore, it identifies the suburbs within this radius to understand the distribution of bus stops near my home and to validate my hypothesis that suburbs near universities have a higher demand for public transportation, resulting in a higher density of bus stops. However, if including other types of public transportation, the density of stops would not be higher, as there are no tram stops within these suburbs. The analysis will provide insights into the distribution of public transportation stops in the region.

### **METHODOLOGY** <a name="method"></a>

**Data Import and Initial Exploration**

Docker was utilized to set up the environment, making use of a pre-built Docker image that included PostgreSQL 14.x and PostGIS 14-3.3. DBeaver was then employed as the database management tool to establish connections with the PostgreSQL and PostGIS databases hosted within the Docker container for data processing. Furthermore, for data restoration, the 'ogr2ogr' program was used to restore data from the GPX file into the database.

**Data Cleaning and Pre-processing**

The data accuracy of the GPX Tracker app was confirmed after opening the GPX file on Google Maps. However, several empty columns with no useful data were removed after reviewing the data in text format. Additionally, tables were restored and created to process the PTV/GTFS dataset and Australian Boundary data.

**Additional Investigations**

The analysis starts by computing the shortest distance between my home and the bus loop, rather than following the longer actual route as the goal is to identify bus stops closer than the Monash bus loop. This distance serves as the radius, with my home as the centre, to establish a buffer. This buffer is then used to find bus stops within this defined range. If any bus stops exist within this range, I can gather related information. This allows me to determine the routes that serve these stops and the destinations reachable via these buses, providing alternative bus options that negate the need to walk to the more distant Monash bus loop each time.
Subsequently, I will identify which suburbs fall within this range and calculate the number of bus stops and public transportation stops, including all types of transportation, in each suburb across Greater Melbourne. This analysis is aimed at comprehending the distribution of bus stops near my home and validating my hypothesis that suburbs near universities exhibit a higher density of buses compared to other suburbs. Density is calculated by dividing the number of bus stops or all transportation stops within each suburb by the square kilometre area of the suburb.

**Data Visualization**

QGIS is employed to visualize my analysis since the results are all related to geometric data. Depending on the type of result, different visualization approaches are used. For instance, to display the density of stops in suburbs, a graduated color is used to represent different levels of density, effectively highlighting suburbs with higher stop density.

### **RESULTS** <a name="results"></a>

**SPEED ANALYSIS** <a name="SPEED_ANALYSIS"></a>

The average speed at which I walk from home to Monash bus loop is approximately 5.08 kilometres per hour, equivalent to roughly 1.41 meters per second.

**Closer Bus Stops Than Monash Bus Loop: 572m Radius Analysis** <a name="CLOSER_BUS_STOPS"></a>

The average speed at which I walk from home to Monash bus loop is approximately 5.08 kilometres per hour, equivalent to roughly 1.41 meters per second.
![stops_closer.png](img%2Fstops_closer.png)

**Bus Routes for Nearby Stops** <a name="BUS_ROUTES_FOR_NEARBY_STOPS"></a>

The analysis reveals that bus routes 703, 737, and 742 serve these nearby stops, and the graph illustrates the destinations accessible through these routes.
![near_route.png](img%2Fnear_route.png)
![near_route_large.png](img%2Fnear_route_large.png)

**SUBURBS WITHIN 572 METERS OF MY LOCATION** <a name="SUBURBS_WITHIN_572_METERS"></a>

The suburbs that fall within 572 meters of my home are Clayton and Notting Hill.
![clayton_nott.png](img%2Fclayton_nott.png)

**BUS STOP DENSITY BY SUBURB (STOPS/KM2)** <a name="BUS_STOP_DENSITY"></a>

The suburbs near my home, namely Clayton and Notting Hill, have 11.51 bus stops per square kilometer and 10.06 bus stops per square kilometer, respectively. Their density falls in the middle position overall, which contradicts the hypothesis that suburbs near schools would have a higher density. The distribution reveals that the suburbs near the center of the Greater Melbourne area have a higher density, while it decreases towards the west and east.
![bus_density.png](img%2Fbus_density.png)
![bus_density_large.png](img%2Fbus_density_large.png)

**PUBLIC TRANSPORTATION STOP DENSITY BY SUBURB (STOPS/KM2)** <a name="PUBLIC_TRANSPORTATION_STOP_DENSITY"></a>

Suburbs with a higher density of bus stops also tend to have a higher overall density of stops, which includes all types of public transportation. As expected in my hypothesis, when considering all types of public transportation and not just buses, the density of stops in suburbs near universities is not higher.
![trans_stops.png](img%2Ftrans_stops.png)
![trans_stops_large.png](img%2Ftrans_stops_large.png)

### **CONCLUSION** <a name="conclusion"></a>

There are 11 bus stops closer to my home than the Monash bus loop, and they are served by 3 routes: 703, 737, and 742. However, due to the high density of bus stops, it is challenging to display and determine if these routes serve the specific destinations I need. This makes it difficult to determine if they can serve as alternatives to the buses, I used to take at the Monash bus loop. I only have a general idea of which suburb they could bring me to. Also, due to the difficulty in distinguishing the round-trip direction, the displayed routes appear messy.
Moreover, the analysis reveals a distribution that contradicts the hypothesis that suburbs near schools would have a higher density. Instead, they fall in the middle position overall. It shows that the suburbs near the center of the Greater Melbourne area have a higher density, while it decreases towards the west and east.

### **REFERENCE** <a name="reference"></a>

Australian Bureau of Statistics. (2021). Allocation files Mesh Blocks - 2021. [Data set]. ABS.
https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/allocation-files.
Australian Bureau of Statistics. (2021). Allocation files Local Government Areas - 2021.[Data set]. ABS.
https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/allocation-files.
Australian Bureau of Statistics. (2021). Allocation files Suburbs and Localities - 2021.[Data set]. ABS.
https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/allocation-files.
PTV. (2023) PTV-GTFS 17 March 2023. [Data set]. Open Mobility Data. https://transitfeeds.com/p/ptv/497/20230317
