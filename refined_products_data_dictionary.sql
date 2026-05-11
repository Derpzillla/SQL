============================================================================
DATA DICTIONARY: CARGO_TRACKING_FOR_REFINED_PRODUCTS.REFINED_PRODUCTS
Generated: 2026-04-28
============================================================================

============================================================================
1. CARGO_TRACKING (46 columns, 26 sample rows)
   Seaborne flows by vessel and product cargo details, from Jan 2015 onwards
============================================================================
Column Name                   | Description                              | Sample Values (categorical)                                        | N   | Pct %  | Min                  | Max
------------------------------|------------------------------------------|--------------------------------------------------------------------|-----|--------|----------------------|----------------------
IMO                           | Vessel IMO number                        |                                                                    | 26  | 100.00 | 9307827              | 9942500
VESSEL_NAME                   | Name of the vessel                       | Bass, FPMC 31, Fpmc 34, Minerva Virgo, Nord Mirai                  | 26  | 100.00 | 4 (len)              | 17 (len)
VESSEL_CLASS                  | Vessel size classification                | Aframax, MR2                                                       | 26  | 100.00 | 3 (len)              | 7 (len)
LOAD_DATE                     | Date of cargo loading                    |                                                                    | 26  | 100.00 | 2023-12-01           | 2023-12-31
LOAD_AREA                     | Loading geographic area                  | US Gulf                                                            | 26  | 100.00 | 7 (len)              | 7 (len)
LOAD_COUNTRY                  | Loading country                          | United States                                                      | 26  | 100.00 | 13 (len)             | 13 (len)
LOAD_SUBCOUNTRY_AREA          | Loading sub-country area                 | PADD 3: Gulf Coast                                                 | 26  | 100.00 | 18 (len)             | 18 (len)
LOAD_PORT                     | Loading port name                        | Beaumont, Garyville, Houston, Lake Charles, St. Charles (Louisiana) | 26  | 100.00 | 7 (len)              | 23 (len)
LOAD_STS_INDICATOR            | Ship-to-ship transfer indicator at load  |                                                                    | 26  | 100.00 | 0                    | 0
LOAD_STS_IMO                  | IMO of STS vessel at load                |                                                                    | 26  | 100.00 | -1                   | -1
LOAD_QUANTITY_KT              | Load quantity in kilotonnes              |                                                                    | 26  | 100.00 | 2.33                 | 77.51
LOAD_QUANTITY_KBBL            | Load quantity in kilobarrels             |                                                                    | 26  | 100.00 | 21                   | 690
ORIGIN_COUNTRY                | Country of cargo origin                  | United States                                                      | 26  | 100.00 | 13 (len)             | 13 (len)
ORIGIN_COUNTRY_GROUP          | Origin country grouping                  | OECD Americas                                                      | 26  | 100.00 | 13 (len)             | 13 (len)
CARGO_TYPE                    | Type of cargo product                    | Diesel, Gasoil, Gasoline, Naphtha                                  | 26  | 100.00 | 6 (len)              | 8 (len)
DISCHARGE_DATE                | Date of cargo discharge                  |                                                                    | 26  | 100.00 | 2023-12-20           | 2024-02-06
DISCHARGE_AREA                | Discharge geographic area                | Continent                                                          | 26  | 100.00 | 9 (len)              | 9 (len)
DISCHARGE_COUNTRY             | Discharge country                        | Belgium, France, Germany, Netherlands                              | 26  | 100.00 | 6 (len)              | 11 (len)
DISCHARGE_SUBCOUNTRY_AREA     | Discharge sub-country area               |                                                                    | 0   | 0.00   |                      |
DISCHARGE_PORT                | Discharge port name                      | Amsterdam, Antwerp, Grand-Couronne, Rotterdam, Terneuzen           | 26  | 100.00 | 7 (len)              | 14 (len)
DISCHARGE_STS_INDICATOR       | STS transfer indicator at discharge      |                                                                    | 26  | 100.00 | 0                    | 0
DISCHARGE_STS_IMO             | IMO of STS vessel at discharge           |                                                                    | 26  | 100.00 | -1                   | -1
DESTINATION_COUNTRY           | Destination country                      | Belgium, France, Germany, Netherlands                              | 26  | 100.00 | 6 (len)              | 11 (len)
DESTINATION_COUNTRY_GROUP     | Destination country grouping             | OECD Europe                                                        | 26  | 100.00 | 11 (len)             | 11 (len)
CHARTERER                     | Charterer name                           | Atlantic Trading and Marketing, Trafigura, Valero, Vitol           | 8   | 30.77  | 5 (len)              | 30 (len)
SUPPLIER                      | Supplier name                            |                                                                    | 0   | 0.00   |                      |
BUYER                         | Buyer name                               | Gunvor                                                             | 1   | 3.85   | 6 (len)              | 6 (len)
LAST_UPDATE_DATE              | Last data update date                    |                                                                    | 26  | 100.00 | 2025-05-21           | 2025-11-25
LOAD_GEO_ASSET                | Geographic asset at load                 | Donaldsonville Nitrogen Complex, Houston Magellan Terminal, ...     | 26  | 100.00 | 15 (len)             | 34 (len)
DISCHARGE_GEO_ASSET           | Geographic asset at discharge            | Delwaide Dock, Odfjell Terminal (Netherlands), ...                  | 26  | 100.00 | 12 (len)             | 41 (len)
CARGO_TYPE_SOURCE             | Source of cargo type classification       | Estimation, Market Info                                            | 26  | 100.00 | 10 (len)             | 11 (len)
GRADE_NAME                    | Product grade name                       | Heavy Naphtha, High Sulphur Gasoil, Light Naphtha, ...             | 26  | 100.00 | 11 (len)             | 24 (len)
GRADE_SOURCE                  | Source of grade classification            | Estimation, Market Info                                            | 26  | 100.00 | 10 (len)             | 11 (len)
SANCTION_ENTITIES             | Sanction entities involved               |                                                                    | 0   | 0.00   |                      |
LOAD_STS_ID                   | STS transfer ID at load                  |                                                                    | 0   | 0.00   |                      |
DISCHARGE_STS_ID              | STS transfer ID at discharge             |                                                                    | 0   | 0.00   |                      |
LOAD_GEO_ASSET_SOURCE         | Source of load geo asset                 | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
LOAD_PORT_SOURCE              | Source of load port                      | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
LOAD_COUNTRY_SOURCE           | Source of load country                   | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
LOAD_AREA_SOURCE              | Source of load area                      | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
DISCHARGE_GEO_ASSET_SOURCE    | Source of discharge geo asset             | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
DISCHARGE_PORT_SOURCE         | Source of discharge port                 | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
DISCHARGE_COUNTRY_SOURCE      | Source of discharge country              | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
DISCHARGE_AREA_SOURCE         | Source of discharge area                 | Realized                                                           | 26  | 100.00 | 8 (len)              | 8 (len)
VOYAGE_ID                     | Unique voyage identifier                 |                                                                    | 0   | 0.00   |                      |
FLOW_ID                       | Unique flow identifier                   |                                                                    | 0   | 0.00   |                      |


============================================================================
2. FLOATING_STORAGE (12 columns, 21 sample rows)
   Historical volumes of floating storage of refined products by vessel
============================================================================
Column Name                   | Description                              | Sample Values (categorical)                                        | N   | Pct %  | Min                  | Max
------------------------------|------------------------------------------|--------------------------------------------------------------------|-----|--------|----------------------|----------------------
IMO                           | Vessel IMO number                        |                                                                    | 21  | 100.00 | 8763309              | 9876426
VESSEL_NAME                   | Name of the vessel                       | Aktros, Astrid 1, Inda, New Dynasty, Utaki                         | 21  | 100.00 | 4 (len)              | 19 (len)
VESSEL_CLASS                  | Vessel size classification                | Aframax, MR1, Panamax, Suezmax, VLCC                               | 21  | 100.00 | 3 (len)              | 7 (len)
REFERENCE_DATE                | Reference date for storage               |                                                                    | 21  | 100.00 | 2023-12-01           | 2023-12-01
START_DATE                    | Storage start date                       |                                                                    | 21  | 100.00 | 2022-07-29           | 2023-12-29
END_DATE                      | Storage end date                         |                                                                    | 21  | 100.00 | 2024-01-11           | 2024-09-17
QUANTITY_KILO_BARRELS         | Quantity in kilobarrels                  |                                                                    | 21  | 100.00 | 216                  | 2023
AREA                          | Geographic area                          | Arabian Gulf & Red Sea, Black Sea & Sea Of Marmara, ...            | 21  | 100.00 | 13 (len)             | 34 (len)
RUN_DATE                      | Data run date                            |                                                                    | 21  | 100.00 | 2025-11-26           | 2025-11-26
ORIGIN_COUNTRY                | Country of origin                        | Iran, Iraq, Oman, Russia, United Arab Emirates                     | 21  | 100.00 | 4 (len)              | 20 (len)
PRODUCT                       | Product type                             | Fuel Oil, Gasoil/Diesel, Gasoline, Jet/Kero, Naphtha, Other       | 21  | 100.00 | 7 (len)              | 14 (len)
QUANTITY_KILO_TONNES          | Quantity in kilotonnes                   |                                                                    | 21  | 100.00 | 24.27                | 318.58


============================================================================
3. FLOWS_REVISIONS (24 columns, 18 sample rows)
   Revisions in flows data from last 6 months between data updates
============================================================================
Column Name                          | Description                              | Sample Values (categorical)                                   | N   | Pct %  | Min                  | Max
-------------------------------------|------------------------------------------|---------------------------------------------------------------|-----|--------|----------------------|----------------------
REVISION_DATE                        | Date of the revision                     |                                                               | 18  | 100.00 | 2025-06-11           | 2025-11-20
REVISION_STATUS                      | Status of the revision                   | Added, Removed, Updated                                       | 18  | 100.00 | 5 (len)              | 7 (len)
IMO                                  | Vessel IMO number                        |                                                               | 18  | 100.00 | 8763309              | 9105346
VESSEL_NAME                          | Name of the vessel                       | Interim, PD Ace, Seri Mayaa, Svetah Venetia                   | 18  | 100.00 | 6 (len)              | 14 (len)
VESSEL_CLASS                         | Vessel size classification                | MR1, Panamax, Small                                           | 18  | 100.00 | 3 (len)              | 7 (len)
VOYAGE_ID                            | Unique voyage identifier                 |                                                               | 18  | 100.00 | 1                    | 3
LOAD_DATE                            | Date of cargo loading                    |                                                               | 18  | 100.00 | 2023-11-01           | 2023-11-26
DISCHARGE_DATE                       | Date of cargo discharge                  |                                                               | 18  | 100.00 | 2025-06-14           | 2025-11-28
PREVIOUS_LOAD_PORT                   | Load port before revision                | Fujairah, Singapore                                           | 5   | 27.78  | 8 (len)              | 9 (len)
REVISED_LOAD_PORT                    | Load port after revision                 | Fujairah, Okoro Setu Oil Field, Port Klang, ...               | 18  | 100.00 | 8 (len)              | 21 (len)
PREVIOUS_DISCHARGE_SUEZ_POSITION     | Discharge Suez position before revision  | East of Suez                                                  | 5   | 27.78  | 12 (len)             | 12 (len)
REVISED_DISCHARGE_SUEZ_POSITION      | Discharge Suez position after revision   | East of Suez, West of Suez                                    | 18  | 100.00 | 12 (len)             | 12 (len)
PREVIOUS_DISCHARGE_AREA              | Discharge area before revision           | Singapore / Malaysia                                          | 5   | 27.78  | 20 (len)             | 20 (len)
REVISED_DISCHARGE_AREA               | Discharge area after revision            | Africa Atlantic Coast, Singapore / Malaysia, Thailand / ...   | 18  | 100.00 | 18 (len)             | 21 (len)
PREVIOUS_DISCHARGE_REGION            | Discharge region before revision         | Asia                                                          | 5   | 27.78  | 4 (len)              | 4 (len)
REVISED_DISCHARGE_REGION             | Discharge region after revision          | Africa, Asia                                                  | 18  | 100.00 | 4 (len)              | 6 (len)
PREVIOUS_DISCHARGE_COUNTRY           | Discharge country before revision        | Malaysia, Singapore                                           | 5   | 27.78  | 8 (len)              | 9 (len)
REVISED_DISCHARGE_COUNTRY            | Discharge country after revision         | Malaysia, Myanmar, Nigeria, Singapore                         | 18  | 100.00 | 7 (len)              | 9 (len)
PREVIOUS_DISCHARGE_PORT              | Discharge port before revision           | Pasir Gudang, Penang, Singapore                               | 5   | 27.78  | 6 (len)              | 12 (len)
REVISED_DISCHARGE_PORT               | Discharge port after revision            | Penang, Qua Iboe Oil Terminal, Singapore, Yangon              | 18  | 100.00 | 6 (len)              | 21 (len)
PREVIOUS_CARGO_TYPE                  | Cargo type before revision               | Fuel Oil, Gasoline, Murban                                    | 5   | 27.78  | 6 (len)              | 8 (len)
REVISED_CARGO_TYPE                   | Cargo type after revision                | Fuel Oil, Gasoil/Diesel, Gasoline                             | 18  | 100.00 | 8 (len)              | 13 (len)
LOAD_QUANTITY_KBBL                   | Load quantity in kilobarrels             |                                                               | 18  | 100.00 | 2                    | 503
LOAD_QUANTITY_KT                     | Load quantity in kilotonnes              |                                                               | 18  | 100.00 | 0.22                 | 60


============================================================================
4. VESSEL_FLOWS (12 columns, 10 sample rows)
   Aggregate flows from Jan 2015 to present including Nowcast
============================================================================
Column Name                   | Description                              | Sample Values (categorical)                                        | N   | Pct %  | Min                  | Max
------------------------------|------------------------------------------|--------------------------------------------------------------------|-----|--------|----------------------|----------------------
ORIGIN_COUNTRY_NAME           | Origin country name                      | United States                                                      | 10  | 100.00 | 13 (len)             | 13 (len)
DESTINATION_COUNTRY_NAME      | Destination country name                 | Belgium, Netherlands                                               | 10  | 100.00 | 7 (len)              | 11 (len)
GROUPBY_DATE_INDICATOR        | Date grouping indicator                  | Exports                                                            | 10  | 100.00 | 7 (len)              | 7 (len)
ORIGIN_SUB_COUNTRY            | Origin sub-country region                | PADD 1: East Coast, PADD 3: Gulf Coast                             | 10  | 100.00 | 18 (len)             | 18 (len)
DESTINATION_SUB_COUNTRY       | Destination sub-country region           |                                                                    | 0   | 0.00   |                      |
REFERENCE_DATE                | Reference date for flows                 |                                                                    | 10  | 100.00 | 2023-12-01           | 2023-12-01
PRODUCT                       | Product type                             | Gasoil/Diesel, Naphtha                                             | 10  | 100.00 | 7 (len)              | 13 (len)
PRODUCT_GRADE                 | Product grade                            | Heavy Naphtha, Light Naphtha, Low Sulphur Diesel, ...              | 10  | 100.00 | 11 (len)             | 24 (len)
QUANTITY_KBD                  | Quantity in kilobarrels per day           |                                                                    | 10  | 100.00 | 1.39                 | 33.9
QUANTITY_KBBL                 | Quantity in kilobarrels                  |                                                                    | 10  | 100.00 | 43                   | 1051
QUANTITY_KT                   | Quantity in kilotonnes                   |                                                                    | 10  | 100.00 | 4.75                 | 140.94
RUN_DATE                      | Data run date                            |                                                                    | 10  | 100.00 | 2025-11-26           | 2025-11-26
