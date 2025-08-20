env               = "dev"
region            = "ap-south-1"
project           = "three-tier"
tf_state_bucket   = "<YOUR_TF_STATE_BUCKET_NAME>"
tf_lock_table     = "<YOUR_TF_LOCK_TABLE_NAME>"

# ECR repos you created
ecr_repo_frontend = "<ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/three-tier-frontend"
ecr_repo_backend  = "<ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/three-tier-backend"

# Provide a secure value before apply (or use TF_VAR_db_password env var)
db_password       = "ChangeMe_StrongPass1!"
