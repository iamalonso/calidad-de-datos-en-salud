# libreria para la coneción a la base de datos
#install.packages(DatabaseConnector)
library(DatabaseConnector)

# Conectarse a la base de datos
connection_details = createConnectionDetails(
  dbms = "postgresql",
  server = "SERVIDOR/BASE DE DATOS",
  user = "USUARIO",
  password = "CONTRASENA",
  port = "PUERTO",
  pathToDriver = "RUTA AL DRIVER PSQL")

# Para leer la consulta desde un archivo .sql
#sql = read_file("archivo.sql")
#sql = render(sql)

# Para añadir directamente la consulta SQL
sql = "SELECT * FROM person"

# Conectar a la base de datos y ejecutar la consulta
conn = connect(connectionDetails = connection_details)
data = dbGetQuery(conn, sql)
dbDisconnect(conn)