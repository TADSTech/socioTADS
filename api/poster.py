import os
import json
import tweepy
from datetime import datetime, timezone
import glob
from dotenv import load_dotenv

load_dotenv()

JSON_PATH = ".github/json/content.json"
IMAGES_DIR = ".github/images/"
FLAG_FILE = ".posted_flag"

def get_clients():
    """
    Initializes BOTH v1.1 (for media) and v2 (for posting) clients.
    """
    api_key = os.environ.get("X_API_KEY")
    api_secret = os.environ.get("X_API_KEY_SECRET")
    access_token = os.environ.get("X_ACCESS_TOKEN")
    access_secret = os.environ.get("X_ACCESS_TOKEN_SECRET")
    bearer_token = os.environ.get("X_BEARER_TOKEN")

    client = tweepy.Client(
        bearer_token=bearer_token,
        consumer_key=api_key,
        consumer_secret=api_secret,
        access_token=access_token,
        access_token_secret=access_secret
    )

    auth = tweepy.OAuth1UserHandler(
        api_key, api_secret, access_token, access_secret
    )
    api = tweepy.API(auth)

    return client, api

def process_queue():
    if not os.path.exists(JSON_PATH):
        print(f"No content file found at {JSON_PATH}")
        return

    with open(JSON_PATH, 'r') as f:
        try:
            posts = json.load(f)
        except json.JSONDecodeError:
            print("Invalid JSON format.")
            return

    client, api = get_clients()
    now = datetime.now(timezone.utc)
    posts_updated = False

    for post in posts:
        if post.get('posted', False):
            continue

        # Handle ISO 8601 format with optional milliseconds
        time_str = post['time']
        # Remove milliseconds if present (e.g., .000)
        if '.' in time_str:
            time_str = time_str.split('.')[0]
        post_time = datetime.strptime(time_str, "%Y-%m-%dT%H:%M:%S").replace(tzinfo=timezone.utc)
        
        if post_time <= now:
            print(f" Time to post: {post['id']}")
            
            media_id = None
            if post.get('image'):
                image_path = post['image']
                # Check if it's a local file path (doesn't start with http)
                if not image_path.startswith('http'):
                    image_path = os.path.join(IMAGES_DIR, image_path)
                
                if not image_path.startswith('http') and os.path.exists(image_path):
                    print(f"   Uploading image: {image_path}")
                    try:
                        media = api.media_upload(filename=image_path)
                        media_id = media.media_id
                    except Exception as e:
                        print(f"Image upload failed: {e}")
                elif image_path.startswith('http'):
                    print(f"   Skipping remote URL image: {image_path}")
                else:
                    print(f"Image file not found: {image_path}")

            # Actually posting
            try:
                if media_id:
                    client.create_tweet(text=post['text'], media_ids=[media_id])
                else:
                    client.create_tweet(text=post['text'])
                
                print(f"Successfully posted!")
                post['posted'] = True
                posts_updated = True
                
            except Exception as e:
                print(f"Failed to post tweet: {e}")

    # Save updates
    if posts_updated:
        with open(JSON_PATH, 'w') as f:
            json.dump(posts, f, indent=4)
        
        # Create a dummy file to trigger the git commit step in YAML
        with open(FLAG_FILE, 'w') as f:
            f.write("updated")

if __name__ == "__main__":
    process_queue()