Backend: Lambdas Python para RegisterUser y VerifyUser.

1) Crea S3 bucket (ej: users-photos-bucket)
2) Crea DynamoDB UsersTable (PK=email)
3) Crea role IAM para Lambdas con permisos: S3, DynamoDB, Rekognition, CloudWatch Logs
4) Subir los archivos register_user_lambda.py y verify_user_lambda.py como lambdas
5) Crear API Gateway HTTP API con rutas POST /register y POST /verify apuntando a cada lambda
6) Habilitar CORS en API Gateway para el dominio desde donde se servirá la app
