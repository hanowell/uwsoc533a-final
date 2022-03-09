# Data collection for the UW SOC 533A final

# Setup ----
library(dplyr)
library(HMDHFDplus)

# US age-specific start-of-year population counts in 2006 and 2019 ----
us_population <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Population5",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% c(2006, 2019))

# US age-specific exposures in 2006 and 2019 ----
us_exposures <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Exposures_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% c(2006, 2019))

# US age-specific mortality in 2006 and 2019 ----
us_asmr <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Mx_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% c(2006, 2019))

# US age-specific fertility in 2006 and 2019 ----
us_asfr <- HMDHFDplus::readHFDweb(
  CNTRY = "USA",
  item = "asfrRR",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Year %in% c(2006, 2019))

# US age-specific births in 2006 and 2019 ----
us_asfr <- HMDHFDplus::readHFDweb(
  CNTRY = "USA",
  item = "birthsRR",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Year %in% c(2006, 2019))

# US parity progression ratios for birth cohorts 1918, 1943, and 1968 ----
us_ppr <-  HMDHFDplus::readHFDweb(
  CNTRY = "USA",
  item = "pprVHbo",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Cohort %in% c(1918, 1943, 1968))

# Write list of data sets to .rds
saveRDS(mget(ls()), "data/final_data.rds")