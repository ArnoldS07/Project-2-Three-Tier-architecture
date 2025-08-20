env               = "dev"
region            = "ap-south-1"
project           = "three-tier"
tf_state_bucket   = "my-proj-terra-state"
tf_lock_table     = "my-terra-state-lock"

# ECR repos you created
ecr_repo_frontend = "412353802976.dkr.ecr.ap-south-1.amazonaws.com/three-tier-frontend"
ecr_repo_backend  = "412353802976.dkr.ecr.ap-south-1.amazonaws.com/three-tier-backend"

# Provide a secure value before apply (or use TF_VAR_db_password env var)
db_password       = "nckd7bM9gYtqqTi"
