import boto3, base64, uuid, json, os, time

s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('USERS_TABLE', 'UsersTable')
BUCKET = os.environ.get('USERS_BUCKET', 'users-photos-bucket')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
        body = json.loads(event.get('body') or event)
        photo_b64 = body.get('photo')
        email = body.get('email')
        first_name = body.get('first_name', '')
        last_name = body.get('last_name', '')

        if not photo_b64 or not email:
            return {'statusCode': 400, 'body': 'photo and email required', 'headers': {'Access-Control-Allow-Origin': '*'}}

        image_bytes = base64.b64decode(photo_b64)
        filename = f"{str(uuid.uuid4())}.jpg"
        s3.put_object(Bucket=BUCKET, Key=filename, Body=image_bytes, ContentType='image/jpeg')

        table.put_item(Item={
            'email': email,
            'first_name': first_name,
            'last_name': last_name,
            'photo_url': f"s3://{BUCKET}/{filename}",
            'created_at': str(int(time.time()))
        })

        return {'statusCode': 200, 'body': json.dumps({'status': 'ok'}), 'headers': {'Access-Control-Allow-Origin': '*'}}
    except Exception as e:
        return {'statusCode': 500, 'body': str(e), 'headers': {'Access-Control-Allow-Origin': '*'}}
