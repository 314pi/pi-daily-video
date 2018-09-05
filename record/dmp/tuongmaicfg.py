import os

CLIENT_ID = os.getenv('DM_CLIENT_ID', 'da8631412cc9291fc0f6')
CLIENT_SECRET = os.getenv('DM_CLIENT_SECRET', '9473b91faf4cec662116bb9701497b25f4549bcd')
USERNAME = os.getenv('DM_USERNAME', 'tuongmai2010@gmail.com')
PASSWORD = os.getenv('DM_PASSWORD', '1qaz2wsx!')
REDIRECT_URI = os.getenv('DM_REDIRECT_URI', 'https://dailymotiontop.tk/rejectvideo')
BASE_URL = 'https://api.dailymotion.com'
OAUTH_AUTHORIZE_URL = 'https://www.dailymotion.com/oauth/authorize'
OAUTH_TOKEN_URL = 'https://api.dailymotion.com/oauth/token'
