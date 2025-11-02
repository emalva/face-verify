# Flutter Face Verify (Starter)

Proyecto de ejemplo: **Flutter** (frontend) + **AWS Lambda (Python)** (backend) usando **DynamoDB**, **S3** y **Rekognition**.

Despues de crear proyecto en ChatGPT aplicar:
# agregar assets para desplegar como web
fvm flutter create . --platforms web
# compilar para web
fvm flutter build web

# correr en web
fvm flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000

# TODO


Habilitar cuenta AWS OK

Habilitar user admin  

Habilitar lambda registro

Habilitar S3 para rostro

Habilitar Dynamo DB

Habilitar API Gateway

Ver como desplegar log




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

