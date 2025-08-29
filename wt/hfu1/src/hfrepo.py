# This python file is for creating and uploading files to huggingface

from src.utz import header1, header2
import os
from dotenv import load_dotenv
from huggingface_hub import (
    create_repo,
    SpaceHardware,
    SpaceStorage,
    upload_folder,
    delete_repo,
)

# Loading the env file
load_dotenv("src/.env")
hf_token = os.getenv("HF")


# Main function that will call the sub functions
def hf_repo_ops():
    """
    Main function for Hugging Face repository operations.
    """
    # hf_create_repo()
    # hf_upload_dirz()
    hf_delete_repos()

# --- Function for creating a repo ---


def hf_create_repo():
    header1("Creating a Hugging Face Repository - Model")
    """
    Create a Hugging Face repository with secrets from an .env file.

    Parameters:
    - token (str): Hugging Face token for authentication. 
    - repo_id (str): A namespace (user or an organization) and a repo name separated by a /.
    - repo_type (str): Type of the repo ("model", "dataset", "space"). Default is "space".
    - private (bool): Whether to make the repo private. Default is False.
    - space_sdk (str): Choice of SDK to use if repo_type is "space". Default is "gradio".
    - space_hardware (SpaceHardware): Choice of hardware if repo_type is "space". Default is SpaceHardware.CPU_SMALL.
    - space_storage (SpaceStorage): Choice of persistent storage tier. Default is SpaceStorage.SMALL.
    - space_sleep_time (int): Number of seconds of inactivity to wait before a Space is put to sleep.
    - env_file (str): Path to the .env file containing secrets. Default is ".env".
    """

    # Name of the repo
    repo_name = "Liqo/MakefromPy2"

    # Create the repository
    make_repo_model = create_repo(repo_id=repo_name, repo_type="model", token=hf_token)

    header2(f"{repo_name}")
    return make_repo_model


# --- Uploading files to repo ---


def hf_upload_dirz():
    header1("Uploading a Folder to Hugging Face Repository")
    """
    Upload a folder to a Hugging Face repository.

    Parameters Reference for upload_folder:
    ---------------------------------------
    - repo_id (str): The repository to upload to (e.g., "username/my-model")
    - folder_path (str | Path): Path to the local folder you want to upload
    - path_in_repo (str, optional): Target directory in the repo (default: root)
    - token (str | bool | None): Hugging Face token (None uses default local auth)
    - repo_type (str, optional): "model", "dataset", or "space" (default: "model")
    - revision (str, optional): Git branch or commit SHA (default: "main")
    - commit_message (str, optional): Short commit summary/title
    - commit_description (str, optional): Longer commit body/description
    - create_pr (bool, optional): If True, opens a pull request instead of committing directly
    - parent_commit (str, optional): Expected parent commit SHA (to prevent race conditions)
    - allow_patterns (list[str] or str, optional): Only upload files matching these glob patterns
    - ignore_patterns (list[str] or str, optional): Skip files matching these glob patterns
    - delete_patterns (list[str] or str, optional): Remove remote files matching these patterns
    - run_as_future (bool, optional): If True, runs in background and returns Future

    Returns:
        CommitInfo or Future: The result of the upload.
    """

    # Folder to upload
    local_folder_path = "TEMP/"  # Path to your local folder
    repo_id = "Liqo/MakefromPy2"  # Your Hugging Face repo
    path_in_repo = ""  # Upload to repo root (change to subdir like "folder/" if needed)

    # Upload the folder
    upload_result = upload_folder(
        folder_path=local_folder_path,
        path_in_repo=path_in_repo,
        repo_id=repo_id,
        token=hf_token,
        repo_type="model",  # Change to "dataset" or "space" if needed
        commit_message="Smell Panty",
        commit_description="bootySmelling Now",
        create_pr=False,  # Set to True if you want to create a PR instead
    )

    print(f"✅ Uploaded folder to: {upload_result.commit_url}")
    return upload_result


# --- Deleteing Spaces ---


def hf_delete_repos():
    header1("Deleting Multiple Hugging Face Repositories")

    """
    Delete multiple Hugging Face repositories.

    Parameters:
    - repo_ids (list[str]): List of repos in "namespace/repo" format
    - token (str): Hugging Face token
    - repo_type (str): "model", "dataset", or "space"
    - missing_ok (bool): Skip error if repo is missing

    Returns:
    - None
    """

    # Config
    repo_ids = ["Liqo/MakefromPy1", "Liqo/but1", "Liqo/buty1"]
    repo_type = "model"
    token = hf_token
    missing_ok = True

    for repo_id in repo_ids:
        try:
            delete_repo(
                repo_id=repo_id, token=token, repo_type=repo_type, missing_ok=missing_ok
            )
            print(f"✅ Deleted: {repo_id}")
        except Exception as e:
            print(f"❌ Failed to delete {repo_id}: {e}")
