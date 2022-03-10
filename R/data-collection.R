# Data collection for the UW SOC 533A final

# Setup ----
library(dplyr)
library(HMDHFDplus)
library(readr)
library(tidyr)

# US age-specific start-of-year population counts ----
periods <- c(1905:2016)
us_population <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Population5",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)

# US age-specific exposures ----
us_exposures <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Exposures_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)

# US age-specific mortality ----
us_asmr <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Mx_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)

# US age-specific deaths ----
us_deaths <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Deaths_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)

# US cause- and age-specific mortality ----
us_deaths_despair <- readr::read_csv("raw/USA_d_interm_idr.csv") %>%
  dplyr::mutate(despair = cause %in% c(40, 41, 76, 99)) %>%
  dplyr::filter(despair, year == 2015, sex == 3) %>%
  dplyr::select(starts_with("d"), -d85p, -d90p, -d95p, -despair) %>%
  dplyr::summarize_all(sum) %>%
  tidyr::pivot_longer(
    cols = starts_with("d"),
    names_to = "Age",
    names_prefix = "d",
    values_to = "D_despair"
  ) %>%
  dplyr::mutate(Age = as.integer(stringr::str_replace_all(Age, "p", "")))

# U.S. death counts by Lexis triangles ----
us_deaths_lexis <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "Deaths_lexis",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year == 2015) %>%
  dplyr::select(-Year)

# US age-specific fertility ----
us_asfr <- HMDHFDplus::readHFDweb(
  CNTRY = "USA",
  item = "asfrRR",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)

# US age-specific births ----
us_births <- HMDHFDplus::readHFDweb(
  CNTRY = "USA",
  item = "birthsRR",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)

# US parity progression ratios for birth cohorts 1918, 1943, and 1968 ----
us_ppr <- HMDHFDplus::readHFDweb(
  CNTRY = "USA",
  item = "pprVHbo",
  username = keyring::key_list("human-fertility-database")$username,
  password = keyring::key_get(
    service = "human-fertility-database",
    username = keyring::key_list("human-fertility-database")$username
  )
) %>%
  dplyr::filter(Cohort %in% c(1918, 1943, 1968))

# 5x1 life tables for males, females, and both sexes combined ----
us_mltper <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "mltper_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)
us_fltper <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "fltper_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)
us_bltper <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "bltper_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year %in% periods)

# 1x1 female life table ----
us_fltper_2009 <- HMDHFDplus::readHMDweb(
  CNTRY = "USA",
  item = "fltper_1x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year == 2009)

# Write list of data sets to .rds
saveRDS(mget(ls()), "data/final_data.rds")