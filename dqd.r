# Instalar DQD
install.packages("remotes")
remotes::install_github("OHDSI/DataQualityDashboard")

# Librerias
library(DatabaseConnector)
library(Achilles)

# Rellenar con los detalles de conexión
connectionDetails <- DatabaseConnector::createConnectionDetails(
    dbms = "postgresql", 
    user = " ", 
    password = " ", 
    server = " ", 
    #port = "", 
    pathToDriver = "Ruta hacia el driver")

# Ejecutar ACHILLES
achilles(connectionDetails = connectionDetails,
         cdmDatabaseSchema = " ",
         resultsDatabaseSchema = "",
         cdmVersion="5.4",
         outputFolder = "/workdir",
         smallCellCount=0)


cdmDatabaseSchema <- " " # Nombre esquema del cdm
resultsDatabaseSchema <- " "  # Nombre esquema de resultados
cdmSourceName <- " " # Nombre para el CDM

# Cuantas sesiones concurrentes se desean (hilos)
numThreads <- 1


# Especificar si se quiere ejecutar el analisis o solo inspeccionar las consultas SQL
sqlOnly <- FALSE 

# Donde almacenar los resultados
outputFolder <- "~/output"
outputFile <- "results.json"

# Registro de logs
verboseMode <- FALSE # set to TRUE if you want to see activity written to the console

# Escribir los resultados en la tabla
writeToTable <- FALSE # set to FALSE if you want to skip writing to a SQL table in the results schema

# Cuales chequeos DQ ejecutar
checkLevels <- c("TABLE", "FIELD", "CONCEPT")

# Que chequeos ejecutar

checkNames <- c() # Names can be found in inst/csv/OMOP_CDM_v5.3.1_Check_Desciptions.csv

# ¿Cuales tablas del CDM se desean agregar?

tablesToExclude <- c("CONDITION_OCCURRENCE",
                     "DRUG_EXPOSURE",
                     "DEVICE_EXPOSURE",
                     "NOTE",
                     "OBSERVATION",
                     "SPECIMEN",
                     "PAYER_PLAN_PERIOD",
                     "DRUG_ERA",
                     "DOSE_ERA",
                     "CONDITION_ERA",
                     "CARE_SITE",
                     "COST",
                     "FACT_RELATIONSHIP",
                     "LOCATION",
                     "NOTE_NLP",
                     "PROVIDER") 

# Ejecutar el proceso
DataQualityDashboard::executeDqChecks(connectionDetails = connectionDetails, 
                                      cdmDatabaseSchema = cdmDatabaseSchema, 
                                      resultsDatabaseSchema = resultsDatabaseSchema,
                                      cdmSourceName = cdmSourceName, 
                                      numThreads = numThreads,
                                      sqlOnly = sqlOnly,
                                      # New field
                                      cohortDefinitionId = 10,
                                      outputFolder = outputFolder, 
                                      outputFile = outputFile,
                                      verboseMode = verboseMode,
                                      writeToTable = writeToTable,
                                      checkLevels = checkLevels,
                                      tablesToExclude = tablesToExclude,
                                      checkNames = checkNames)

# Inspeccionar los logs
ParallelLogger::launchLogViewer(logFileName = file.path(outputFolder, cdmSourceName, 
                                                        sprintf("log_DqDashboard_%s.txt", cdmSourceName)))

# (Opcional) si dedesea escribir un JSON con los resultados
jsonFilePath <- "~/output/results.json"
DataQualityDashboard::writeJsonResultsToTable(connectionDetails = connectionDetails, 
                                              resultsDatabaseSchema = resultsDatabaseSchema, 
                                              jsonFilePath = jsonFilePath)


DataQualityDashboard::viewDqDashboard(
  jsonPath = "~/output/results.json"
)

jsonPath = file.path(getwd(), outputFolder, cdmSourceName, outputFile, cdmSourceName)

checks = DataQualityDashboard::listDqChecks(cdmVersion = "5.4")
