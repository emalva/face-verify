Backend: Lambdas Python para RegisterUser y VerifyUser.

us-east-2
1) Crea S3 bucket (ej: users-photos-bucket)
    Entra a S3 → Create bucket users-photos-bucket-1169-8180-7351
    Región: elige la misma donde desplegarás tu Lambda (por ejemplo us-east-1)
    Desactiva “Block all public access” solo si necesitas ver las fotos directamente desde un navegador.
    Crea el bucket.

2) Crea DynamoDB UsersTable (PK=email)
    Entra a DynamoDB → Tables → Create table
    Nombre de la tabla: UsersTable
    Clave primaria:
    Partition key: email (tipo String)
    (Opcional) Usa modo “On-demand” para no preocuparte de capacidad.
    Crea la tabla.
3) Crea role IAM para Lambdas con permisos: S3, DynamoDB, Rekognition, CloudWatch Logs
    Entra a IAM → Roles → Create role
    Tipo de entidad confiable: AWS service
    Caso de uso: Lambda
    Adjunta las siguientes políticas administradas:
    AmazonS3FullAccess (o una más restringida si prefieres)
    AmazonDynamoDBFullAccess
    AWSLambdaBasicExecutionRole (logs en CloudWatch)
    Nombre del rol: lambda-register-user-role


4) Creal lambda register_user_lambda.py
    Entra a Lambda → Create function
    Nombre: register_user_lambda
    Runtime: Python 3.12
    Rol: selecciona el que creaste (lambda-register-user-role)
    Crea la función.
    Sube archivo register_user_lambda.py :
        En Code → Upload from → .zip file
    Agrega variables de entorno:
        USERS_TABLE = UsersTable
        USERS_BUCKET = users-photos-bucket-<tu-nombre>

5) Subir archivo verify_user_lambda.py como lambda
6) Crear API Gateway HTTP API con rutas POST /register y POST /verify apuntando a cada lambda
7) Habilitar CORS en API Gateway para el dominio desde donde se servirá la app
