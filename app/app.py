from flask import Flask
import redis

app = Flask(__name__)

try:
    # Establish a connection to Redis
    redisClient = redis.StrictRedis(host='redis', port=6379, db=0, decode_responses=True)
    # 'redis-service' should be the name of your Redis service in the Kubernetes cluster
except Exception as e:
    print(f"Error connecting to Redis: {e}")
    redisClient = None

@app.route('/')
def index():
    if redisClient:
        try:
            count = redisClient.incr('visitor')
            return f'Welcome to the Site, This is the {count} visitor.'
        except Exception as e:
            return f"Error accessing Redis: {e}"
    else:
        return "Error connecting to Redis. Please check the connection."

if __name__ == '__main__':
    # In production, use a production-ready server like Gunicorn instead of Flask's built-in server
    app.run(host='0.0.0.0', port=3000, debug=False)
