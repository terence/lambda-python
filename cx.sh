# AWS Lambda Scripts Command-line Assistant
#================================================================
clear
#source ./vars.sh
PWD=pwd

# DEFAULTS
PROFILE="ipadev"
REGION="ap-southeast-2"
OUTPUT="json"
EMR_CLUSTER_ID="xxx"



echo =============================================================
echo Hi $USER@$HOSTNAME. You are in $PWD directory.
echo -------------------------------------------------------------
echo 001 : AWS Configure
echo 002 : AWS S3 List
echo 003 : AWS Lambda
echo ----------------------------------------------
echo 100 : AWS Lambda Account Settings
echo 101 : AWS Lambda List Functions
echo 102 : AWS Lambda List Layers
echo 110 : AWS Lambda Create Zip
echo 111 : AWS Lambda Create Function
echo ----------------------------------------------




echo Enter [Selection] to continue
echo =============================================================





# Command line selection
if [ -n "$1" ]; then
  SELECTION=$1
else
  read  -n 3 SELECTION
fi

if [ -n "$2" ]; then
  PROFILE=$2
fi


echo Your selection is : $SELECTION.
echo Your profile is : $PROFILE.


case "$SELECTION" in
"001" )
  echo "===== AWS Configure - Setup"
  aws configure
  ;;


"002" )
  echo "===== AWS S3 List:" $PROFILE
  aws s3 ls --profile $PROFILE
  echo "Count:"
  aws s3 ls --profile $PROFILE | wc -l

  #aws s3 ls s3://bucketname
  #aws s3 cp
  # aws s3 sync local s3://remote
  ;;

"100" )
  echo "===== AWS Lambda Get Account Settings:" $PROFILE
  aws lambda get-account-settings \
    --profile $PROFILE \
    --output $OUTPUT
  ;;


"101" )
  echo "===== AWS Lambda List Functions:" $PROFILE
  aws lambda list-functions \
    --profile $PROFILE \
    --output $OUTPUT
  ;;


"102" )
  echo "===== AWS Lambda List Layers:" $PROFILE
  aws lambda list-layers \
    --profile $PROFILE \
    --output $OUTPUT
  ;;



"110" )
  echo "===== AWS Lambda Create Zip:" $PROFILE
  cd ./lambda-helloworld1/
  zip -r ../lambda-helloworld1.zip *
  ;;





"111" )
  echo "===== AWS Lambda Create Function:" $PROFILE
  cd lambda-helloworld1
  rm lambda-helloworld1.zip
  zip -r lambda-helloworld1.zip .
  cd ..
  aws lambda create-function \
    --function-name terence-test1 \
    --runtime python3.6 \
    --zip-file fileb://lambda-helloworld1/lambda-helloworld1.zip \
    --handler lambda_function.lambda_handler \
    --role arn:aws:iam::832435373672:role/service-role/lambda-helloworld1-role-rpwjd1ud \
    --profile $PROFILE \
    --output $OUTPUT
  ;;



# Attempt to cater for ESC
"\x1B" )
  echo ESC1
  exit 0
  ;;


# Attempt to cater for ESC
"^[" )
  echo ESC2
  exit 0
  ;;

# ------------------------------------------------
#  GIT
# ------------------------------------------------
* )
  # Default option.
  # Empty input (hitting RETURN) fits here, too.
  echo
  echo "Not a recognized option."
  ;;
esac




