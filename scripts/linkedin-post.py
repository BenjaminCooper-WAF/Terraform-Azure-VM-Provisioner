import os
import sys
import requests

LINKEDIN_ACCESS_TOKEN = os.environ["LINKEDIN_ACCESS_TOKEN"]
LINKEDIN_PERSON_URN = os.environ["LINKEDIN_PERSON_URN"]

RELEASE_MESSAGE = os.environ.get(
    "RELEASE_MESSAGE",
    "New portfolio project release."
)

PORTFOLIO_URL = os.environ.get(
    "PORTFOLIO_URL",
    "https://benjaminc.cloud"
)

GITHUB_URL = os.environ.get(
    "GITHUB_URL",
    "https://github.com/BenjaminCooper-WAF"
)

LINKEDIN_API_URL = "https://api.linkedin.com/rest/posts"


def clean_release_message(message: str) -> str:
    if message.lower().startswith("release:"):
        return message.split(":", 1)[1].strip()

    return message.strip()


def publish_linkedin_post():
    release_title = clean_release_message(RELEASE_MESSAGE)

    post_text = f"""
New portfolio project update.

{release_title}

I've deployed a new update to my portfolio project.

The project focuses on practical AWS, Terraform, infrastructure automation and DevOps implementation.

Portfolio:
{PORTFOLIO_URL}

GitHub:
{GITHUB_URL}

#AWS #Terraform #DevOps #CloudEngineering #InfrastructureAsCode
""".strip()

    payload = {
        "author": LINKEDIN_PERSON_URN,
        "commentary": post_text,
        "visibility": "PUBLIC",
        "distribution": {
            "feedDistribution": "MAIN_FEED",
            "targetEntities": [],
            "thirdPartyDistributionChannels": []
        },
        "lifecycleState": "PUBLISHED",
        "isReshareDisabledByAuthor": False
    }

    headers = {
        "Authorization": f"Bearer {LINKEDIN_ACCESS_TOKEN}",
        "Linkedin-Version": "202608",
        "X-Restli-Protocol-Version": "2.0.0",
        "Content-Type": "application/json"
    }

    try:
        response = requests.post(
            LINKEDIN_API_URL,
            headers=headers,
            json=payload,
            timeout=30
        )

    except requests.RequestException as exc:
        print(f"LinkedIn API request failed: {exc}")
        sys.exit(1)

    if response.status_code != 201:
        print("LinkedIn post failed.")
        print(f"Status code: {response.status_code}")
        print(response.text)
        sys.exit(1)

    post_id = response.headers.get("x-restli-id")

    print("LinkedIn post published successfully.")

    if post_id:
        print(f"LinkedIn post ID: {post_id}")


if __name__ == "__main__":
    publish_linkedin_post()