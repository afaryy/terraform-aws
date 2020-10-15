#!/bin/bash

# Ref: https://medium.com/analytics-vidhya/deploying-aws-lambda-function-with-terraform-custom-dependencies-7874407cd4fc
echo "Executing build-package.sh..."

# path_cwd=~/Repo/terraform-aws-project/TDL-12-Python-Lambda-Cloudwatch/terraform-code
# function_name='terminate_aged_instances_with_snapshots'
# runtime=python3.8
# source_code_path=lambda_function

set -eo pipefail
cd $path_cwd
rm -rf $path_cwd/package
rm -rf $path_cwd/package_zip

echo $path_cwd
# Create and activate virtual environment...
$runtime -m venv boto3_venv
source  $path_cwd/boto3_venv/bin/activate
 

# Installing and deploying python dependencies...
FILE=$path_cwd/$source_code_path/requirements.txt

if [ -f "$FILE" ]; then
  echo "Installing dependencies..."
  echo "From: requirement.txt file exists..."
  # python3.8 -m pip install --upgrade pip
  pip3.8 install --target $path_cwd/package/lambda_function/ -r "$FILE"
else
  echo "Error: requirement.txt does not exist!"
fi

# Deactivate virtual environment...
deactivate

# Create function package...
echo "Creating deployment package..."
cp -r $path_cwd/$source_code_path/ $path_cwd/package/

# Removing virtual environment folder...
echo "Removing virtual environment folder..."
rm -rf $path_cwd/boto3_venv

echo "Finished build package!"
