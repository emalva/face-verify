import boto3, base64, uuid, json, os, time

s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

TABLE_NAME = os.environ.get('USERS_TABLE', 'UsersTable')
BUCKET = os.environ.get('USERS_BUCKET', 'users-photos-bucket-1169-8180-7351')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        # Aceptar tanto API Gateway (body string) como invocación directa
        body = json.loads(event.get('body') or event)
        photo_b64 = body.get('photo')
        email = body.get('email')
        first_name = body.get('first_name', '')
        last_name = body.get('last_name', '')

        if not photo_b64 or not email:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'photo and email required'}),
                'headers': {'Access-Control-Allow-Origin': '*'}
            }

        # Quitar encabezado si viene como data:image/jpeg;base64,...
        if photo_b64.startswith("data:image"):
            photo_b64 = photo_b64.split(",")[1]

        # Agregar relleno por si la cadena viene incompleta
        missing_padding = len(photo_b64) % 4
        if missing_padding:
            photo_b64 += '=' * (4 - missing_padding)

        # Decodificar imagen
        image_bytes = base64.b64decode(photo_b64)

        # Subir imagen a S3
        filename = f"{str(uuid.uuid4())}.jpg"
        s3.put_object(Bucket=BUCKET, Key=filename, Body=image_bytes, ContentType='image/jpeg')

        # Generar URL pública (si el bucket lo permite)
        photo_url = f"https://{BUCKET}.s3.amazonaws.com/{filename}"

        # Guardar datos en DynamoDB
        table.put_item(Item={
            'email': email,
            'first_name': first_name,
            'last_name': last_name,
            'photo_url': photo_url,
            'created_at': str(int(time.time()))
        })

        return {
            'statusCode': 200,
            'body': json.dumps({'status': 'ok', 'photo_url': photo_url}),
            'headers': {'Access-Control-Allow-Origin': '*'}
        }

    except Exception as e:
        print("Error:", str(e))
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)}),
            'headers': {'Access-Control-Allow-Origin': '*'}
        }
