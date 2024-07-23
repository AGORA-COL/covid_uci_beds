setwd('/zine/HPC02S1/ex-dveloza/AGORA/apps/fred_colombia_implementation/process_inputs/scripts')
##===============================#
## Process UCI info
## Author: Diego Veloza Diaz
## 2021
##===============================#
library(dplyr)
library(tidyverse)

df_ <- read.csv('/zine/HPC02S1/ex-dveloza/AGORA/apps/fred_colombia_implementation/process_inputs/output_files/camas_uci_colombia.csv')

colnames(df_)


type_capacity = c("Adultos", "Cuidado Intermedio Adulto", "Cuidado Intensivo Adulto")
locations <- c("08 - Atlántico",
               "11 - Bogotá, D.C.",
               "13 - Bolívar",
               "15 - Boyacá",
               "20 - Cesar",
               "05 - Antioquia",
               "25 - Cundinamarca",
               "19 - Cauca",
               "23 - Córdoba",
               "27 - Chocó",
               "17 - Caldas",
               "18 - Caquetá",
               "86 - Putumayo",
               "47 - Magdalena",
               "52 - Nariño",
               "50 - Meta",
               "73 - Tolima",
               "85 - Casanare",
               "68 - Santander",
               "41 - Huila",
               "94 - Guainía",
               "63 - Quindio",
               "70 - Sucre",
               "76 - Valle del Cauca",
               "66 - Risaralda",
               "44 - La Guajira",
               "54 - Norte de Santander",
               "88 - Archipiélago de San Andrés, Providencia y Santa Catalina",
               "81 - Arauca",
               "91 - Amazonas",
               "99 - Vichada",
               "95 - Guaviare",
               "97 - Vaupés")

df_grouped <- df_ %>%
    filter(Departamento %in% locations) %>%
    group_by(Fecha, Departamento, Capacidad) %>%
    summarise(
        non_covid = sum(No_COVID, na.rm = TRUE),
        covid_suspected = sum(COVID_sospechosos, na.rm = TRUE),
        covid_confirmed = sum(COVID_confirmados, na.rm = TRUE),
        available_beds = sum(Camas_disponibles, na.rm = TRUE),
        total_beds = sum(Total_camas, na.rm = TRUE),
        total_covid_cases = sum(Total_casos_COVID, na.rm = TRUE),
        average_percentage_available_beds = mean(Porcentaje_camas_disponibles, na.rm = TRUE),
        total_covid_occupancy = sum(Ocupación_total_COVID, na.rm = TRUE)
    ) %>% rename('date' = 'Fecha', 'department' = 'Departamento', 'capacity' = 'Capacidad')

write.csv(df_grouped, '../output_files/UCI/camas_uci_departamentos_colombia.csv')
