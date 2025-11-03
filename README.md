# Flutter Face Verify (Starter)

Proyecto de ejemplo: **Flutter** (frontend) + **AWS Lambda (Python)** (backend) usando **DynamoDB**, **S3** y **Rekognition**.

Despues de crear proyecto en ChatGPT aplicar:
# agregar assets para desplegar como web
fvm flutter create . --platforms web
# compilar para web
fvm flutter build web
# correr en web
fvm flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000

# debuf Flutter web app
  Open the app in Chrome, then press:
  Ctrl + Shift + I   (Windows/Linux)
  Cmd + Option + I   (Mac)
  Then go to the Console tab.
  Here you’ll see:
  Dart print() outputs
  JavaScript errors
  Flutter web runtime logs (e.g. "Service worker registered", “CanvasKit loaded”, etc.)

# PASOS

Habilitar cuenta AWS OK

Habilitar user awsadmin OK  

Habilitar lambda registro OK

Habilitar S3 para imagen rostro OK

Habilitar tabla Dynamo DB OK 

Probar lambda registro con S3 y DynamoDB OK

Habilitar API Gateway OK

Conectar lambda registro con API Gateway OK

Probar API Gateway con lambda register desde Postman OK

Conectar Flutter APP con API Gateway OK

# TODO

DESHABILITAR API GATEWAY DIARIO

Asegurar API Gateway para ser llamado solo desde Flutter con token

Habilitar lambda verify

Probar lambda verify con S3 y DynamoDB 

Conectar lambda verify con API Gateway

Probar API Gateway con lambda verify 




Conectar codigo fuente lambdas con proyecto GitHub

Formatear README de backend 

PRUEBAS

json Prueba lambda register
{
  "body": "{\"email\": \"demo1@example.com\", \"first_name\": \"Ana\", \"last_name\": \"López\", \"photo\": \"data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUQEhIWFRUVFRUVFRUVFRUVFRUXFRUWFhUVFRUYHSggGBolGxUVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGxAQGy0lICYtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAOEA4QMBIgACEQEDEQH/xAAZAAADAQEBAAAAAAAAAAAAAAABAgMABAX/xAAiEAABAwQCAgMBAAAAAAAAAAABAgMRAAQFEiExEyJBQmH/xAAXAQADAQAAAAAAAAAAAAAAAAABAgME/8QAHhEAAgICAgMAAAAAAAAAAAAAAQIAAwQRITESIkH/2gAMAwEAAhEDEQA/APqigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiig//Z\"}"
}

api gateway
https://u58yr6zew3.execute-api.us-east-2.amazonaws.com/dev/register


probar desde postman

Content-Type application/json
{
        "email":"demo3@example.com",
        "first_name": "Sandra",
        "last_name": "Cervantes",
        "photo": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUQEhIWFRUVFRUVFRUVFRUVFRUXFRUWFhUVFRUYHSggGBolGxUVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGxAQGy0lICYtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAOEA4QMBIgACEQEDEQH/xAAZAAADAQEBAAAAAAAAAAAAAAABAgMABAX/xAAiEAABAwQCAgMBAAAAAAAAAAABAgMRAAQFEiExEyJBQmH/xAAXAQADAQAAAAAAAAAAAAAAAAABAgME/8QAHhEAAgICAgMAAAAAAAAAAAAAAQIAAwQRITESIkH/2gAMAwEAAhEDEQA/APqigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiig//Z\"}"
}


GIT

Traer cambios de remoto

git pull origin main

git status

En caso de conflicto 

git pull --no-rebase origin main

Subir cambios a remoto


git add .

git commit -m "

git push origin main




Estructura:
- `lib/` : código Flutter (pantallas, servicios, modelos)
- `backend/` : Lambdas Python (`register_user_lambda.py`, `verify_user_lambda.py`)
- `pubspec.yaml` : dependencias Flutter
- `README-backend.md` : instrucciones rápidas de despliegue AWS

## Notas rápidas
1. Reemplaza los endpoints en `lib/constants/api_urls.dart` por tus URLs de API Gateway.
2. Crea en AWS: un bucket S3 (`users-photos-bucket`), una tabla DynamoDB (`UsersTable`) con `email` como PK y las Lambdas conectadas a API Gateway.
3. Asigna a las Lambdas permisos para S3, DynamoDB y Rekognition (roles IAM).
4. Este proyecto mantiene un flujo simple: el correo funciona como identificador sin autenticación.

## Contenido
- Frontend: código listo para compilar (`flutter pub get`) y probar.
- Backend: handlers Python listos para subir a AWS Lambda.

