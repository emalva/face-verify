import boto3, base64, json, os

rekognition = boto3.client('rekognition')
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('USERS_TABLE', 'UsersTable')
BUCKET = os.environ.get('USERS_BUCKET', 'users-photos-bucket')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        body = json.loads(event.get('body') or event)
        email = body.get('email')
        photo_b64 = body.get('photo')
        if not email or not photo_b64:
            return {'statusCode': 400, 'body': 'email and photo required', 'headers': {'Access-Control-Allow-Origin': '*'}}

        new_image = base64.b64decode(photo_b64)
        # obtener usuario
        resp = table.get_item(Key={'email': email})
        if 'Item' not in resp:
            return {'statusCode': 404, 'body': json.dumps({'match': False, 'reason': 'user_not_found'}), 'headers': {'Access-Control-Allow-Origin': '*'}}
        user = resp['Item']
        photo_url = user.get('photo_url')  # s3://bucket/key
        key = photo_url.split('/', 3)[-1] if photo_url else None
        if not key:
            return {'statusCode': 500, 'body': 'stored photo not found', 'headers': {'Access-Control-Allow-Origin': '*'}}

        original = s3.get_object(Bucket=BUCKET, Key=key)['Body'].read()

        result = rekognition.compare_faces(
            SourceImage={'Bytes': original},
            TargetImage={'Bytes': new_image},
            SimilarityThreshold=85
        )

        if result.get('FaceMatches'):
            return {'statusCode': 200, 'body': json.dumps({'match': True, 'user': user}), 'headers': {'Access-Control-Allow-Origin': '*'}}
        else:
            return {'statusCode': 200, 'body': json.dumps({'match': False}), 'headers': {'Access-Control-Allow-Origin': '*'}}
    except Exception as e:
        return {'statusCode': 500, 'body': str(e), 'headers': {'Access-Control-Allow-Origin': '*'}}
