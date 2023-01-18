hun_mod_full = readRDS("data-raw/hunt_mod_full.rds")
usethis::use_data(hun_mod_full, overwrite = T)

hun_mod_rel = readRDS("data-raw/hunt_mod_rel.rds")
usethis::use_data(hun_mod_rel, overwrite = T)

hun_mod_sta = readRDS("data-raw/hunt_mod_sta.rds")
usethis::use_data(hun_mod_sta, overwrite = T)

nat_mod_full = readRDS("data-raw/nat_mod_full.rds")
usethis::use_data(nat_mod_full, overwrite = T)

nat_mod_rel = readRDS("data-raw/nat_mod_rel.rds")
usethis::use_data(nat_mod_rel, overwrite = T)

nat_mod_sta = readRDS("data-raw/nat_mod_sta.rds")
usethis::use_data(nat_mod_sta, overwrite = T)

nat_mod_trim = readRDS("data-raw/nat_mod_trim.rds")
usethis::use_data(nat_mod_trim, overwrite = T)

bio_mod_full = readRDS("data-raw/bio_mod_full.rds")
usethis::use_data(bio_mod_full, overwrite = T)

bio_mod_exp = readRDS("data-raw/bio_mod_exp.rds")
usethis::use_data(bio_mod_exp, overwrite = T)

bio_mod_pers = readRDS("data-raw/bio_mod_pers.rds")
usethis::use_data(bio_mod_pers, overwrite = T)

mop = readRDS("data-raw/mop.rds")
usethis::use_data(mop, overwrite = T)
