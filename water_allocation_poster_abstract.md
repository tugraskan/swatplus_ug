# Enhanced Water Allocation Module in SWAT+: Modeling Complex Water Infrastructure Systems

## Poster Abstract

Previously, water allocation in SWAT+ operated with simplified frameworks supporting basic water withdrawal from limited source types with rudimentary priority-based allocation rules. This update significantly enhances SWAT+'s capability to model complex water infrastructure systems, addressing the growing need for detailed simulation of municipal water systems, industrial users, and integrated water management in developed watersheds.

The updated water allocation code expands supported objects to include water treatment plants, water use facilities, water towers, and conveyance infrastructure (pipes, pumps, canals) alongside traditional sources (channels, reservoirs, aquifers). New input files (water_treat.wal, water_use.wal, water_tower.wal, water_pipe.wal) enable detailed specification of treatment processes, storage capacities, lag times, and loss fractions. The module supports sophisticated allocation rules including senior/junior water rights, decision table integration for dynamic demand calculations, and compensation mechanisms when sources are limiting.

Key functionality improvements include multi-source fraction-based allocation, comprehensive tracking of organic/mineral content, pesticides, pathogens, and salts through treatment processes, and enhanced output capabilities providing detailed demand, withdrawal, and unmet demand statistics at multiple temporal scales. The module integrates seamlessly with existing SWAT+ components, enabling realistic simulation of complex water resource management scenarios in urbanized watersheds where infrastructure-mediated water allocation is critical for sustainable water resource planning.

**Keywords:** SWAT+, water allocation, water treatment, municipal water systems, watershed modeling, water infrastructure