# 1. You need configure aws-cli `aws configure`
# 2. Run this script to set automatically the variables in the export command

# Check if the variables are set
if [ -z "$TF_VAR_aws_access_key_id" ]; then
    # Set the variables
    export TF_VAR_aws_access_key_id=$(aws configure get aws_access_key_id)
    export TF_VAR_aws_secret_access_key=$(aws configure get aws_secret_access_key)
    export TF_VAR_aws_region=$(aws configure get region)
fi

# Check if the first command is pland, validate, apply, destroy
if [ "$1" != "plan" ] && [ "$1" != "validate" ] && [ "$1" != "apply" ] && [ "$1" != "destroy" ]; then
    echo "The first command must be plan, validate or apply"
    exit 1
fi

# Check if the environment is dev, qa or prod
if [ "$2" != "dev" ] && [ "$2" != "qa" ] && [ "$2" != "prod" ]; then
    echo "The second command must be dev, qa or prod"
    exit 1
fi

# Check if the environment is dev, qa or prod exist the file
if [ ! -f "$2.tfvars" ]; then
    echo "The file $2.tfvars doesn't exist"
    exit 1
fi

# Configuration commands to terraform
# commands="-var-file=$2.tfvars -var aws_region=$TF_VAR_aws_region -var aws_access_key=$TF_VAR_aws_access_key_id -var aws_secret_key=$TF_VAR_aws_secret_access_key"
commands="-var-file=$2.tfvars -var aws_region=$TF_VAR_aws_region"

# If main command is validate, don't need the variables
if [ "$1" == "validate" ]; then
    commands=""
fi
# If the command is destroy, ask for confirmation
if [ "$1" == "destroy" ]; then
    read -p "Are you sure you want to destroy the infrastructure? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# If the command is destroy, add the auto-approve flag
if [ "$1" == "destroy" ]; then
    commands="$commands -auto-approve"
fi

# Execute terraform
all_commands="terraform $1 $commands"

# Run the command
eval $all_commands