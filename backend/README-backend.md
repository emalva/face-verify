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

5) Conectar con API Gateway
5.1)  Crear API en API Gateway
	Ve a API Gateway → Create API → HTTP API (más simple que REST API).
	Ponle un nombre, por ejemplo UsersAPI.
	Selecciona Add integration → Lambda → elige tu Lambda.
	Asegúrate de que Lambda Proxy integration esté habilitado (para que event['body'] llegue correctamente).

5.2)  Configurar rutas y métodos
	Crea una ruta, por ejemplo: /upload-photo.
	Selecciona método POST.
	Conecta la ruta a tu Lambda (si elegiste Lambda Proxy, la integración será directa).

5.3)  Permisos Lambda → API Gateway
	Cuando conectas Lambda a API Gateway, AWS normalmente crea un resource-based policy que permite que API Gateway invoque Lambda.
	Para revisarlo:
	Ve a tu Lambda → Configuration → Permissions → Resource-based policy.
	Debe aparecer algo como:
	{
		"Effect": "Allow",
		"Principal": {"Service": "apigateway.amazonaws.com"},
		"Action": "lambda:InvokeFunction",
		"Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:YOUR_LAMBDA"
	}

5.4)  Deploy API
    En API Gateway → Deployments → Create → selecciona un Stage, por ejemplo dev.
    Esto generará un Invoke URL, algo como:
    https://u58yr6zew3.execute-api.us-east-2.amazonaws.com/dev/register
    
5.5)  Habilitar CORS (si usas web frontend)
    En API Gateway → tu ruta → CORS → enable.
    Selecciona:
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: POST,OPTIONS
    Access-Control-Allow-Headers: Content-Type
    Deploy nuevamente.

5.6)  Revisar logs
    Ve a CloudWatch Logs → tu Lambda → busca el log de la invocación.
    Útil para depurar errores de Base64, S3 o DynamoDB.

5.7a)  Eliminar el Stage (o quitar el deployment activo)
    Esto no destruye la API, solo remueve su deployment activo, por lo que el endpoint público deja de responder.
        Abre API Gateway en la consola.
        Selecciona tu API.
        Ve a Deployments → selecciona el Stage (por ejemplo dev o prod).
        Haz clic en Delete Stage.
    Resultado:
        La API sigue existiendo (sus rutas, métodos e integraciones siguen configurados).
        Pero no hay URL pública ni endpoint desplegado, por lo tanto nadie puede invocarla.

5.7b)  Eliminar el Stage (o quitar el deployment activo)
    Método alternativo: agregar una Resource Policy que deniegue todo
    Si no quieres borrar el stage, puedes bloquear todo el tráfico temporalmente.
        Ve a tu API → Resource Policy.
        Agrega esta política:
        {
            "Version": "2012-10-17",
            "Statement": [
            {
                "Effect": "Deny",
                "Principal": "*",
                "Action": "execute-api:Invoke",
                "Resource": "arn:aws:execute-api:us-east-1:123456789012:abcdefghij/*/*/*"
            }
            ]
        }

        Reemplaza arn:aws:execute-api:... con el ARN real de tu API.
        Esta política bloquea todas las solicitudes, sin eliminar nada.
        Puedes quitarla más tarde para reactivar el acceso.

6) Subir archivo verify_user_lambda.py como lambda
7) Crear API Gateway HTTP API con ruta POST /register y POST /verify apuntando a cada lambda
8) Habilitar CORS en API Gateway para el dominio desde donde se servirá la app
