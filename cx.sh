# AWS Lambda Scripts Command-line Assistant
#================================================================
clear
source ./vars.sh
PWD=pwd

# DEFAULTS
PROFILE="ipadev"
REGION="ap-southeast-2"
OUTPUT="json"
EMR_CLUSTER_ID="xxx"
S3CODE="ipa-bia-codebase"
FUNCTION_CODE="lambda-dynamo"
FUNCTION_NAME="terence-test1"

echo =============================================================
echo Hi $USER@$HOSTNAME. You are in $PWD directory.
echo -------------------------------------------------------------
echo 001 : AWS Configure
echo 002 : AWS S3 List
echo 003 : AWS STS Assume Role Session
echo ----------------------------------------------
echo 100 : AWS Lambda Account Settings
echo 101 : AWS Lambda List Functions
echo 102 : AWS Lambda List Layers
echo 110 : AWS Lambda Create Function
echo 111 : AWS Lambda Update Function Code
echo 112 : AWS Lambda Invoke Function
echo 113 : AWS Lambda Delete Function
echo 114 : AWS Lambda Get Function Configuration
echo 115 : AWS Lambda Update Function Configuration
echo ----------------------------------------------
echo 200 : AWS Zip Python Package
echo 201 : AWS S3 Upload Layer to S3
echo 202 : AWS Lambda publish-layer-version
echo ----------------------------------------------
echo 500 : V-Env Create
echo 501 : V-Env Activate
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


"003" )
  echo "===== AWS Assume Role:" $PROFILE
  aws sts assume-role \
    --role-arn "$STS_ROLE" \
    --role-session-name AWSCLI-Session
  aws sts get-caller-identity \
    --profile $PROFILE
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
  echo "===== AWS Lambda Create Function:" $PROFILE
  cd $FUNCTION_CODE
  rm $FUNCTION_CODE.zip
  zip -r $FUNCTION_CODE.zip .
  cd ..
  aws s3 cp ./$FUNCTION_CODE/$FUNCTION_CODE.zip s3://ipa-bia-codebase/
	
	aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime python3.8 \
		--code S3Bucket='s3://ipa-bia-code/',S3Key="${FUNCTION_NAME}"
    --zip-file fileb://$FUNCTION_CODE/$FUNCTION_CODE.zip \
    --handler lambda_function.lambda_handler \
    --role arn:aws:iam::832435373672:role/service-role/lambda-helloworld1-role-rpwjd1ud \
    --profile $PROFILE \
    --output $OUTPUT
  ;;


"111" )
  echo "===== AWS Lambda Update Function Code:" $PROFILE
  cd $FUNCTION_CODE
  rm $FUNCTION_CODE.zip
  zip -r $FUNCTION_CODE.zip .
  cd ..
  aws lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://$FUNCTION_CODE/$FUNCTION_CODE.zip \
    --profile $PROFILE \
    --output $OUTPUT
  ;;

"112" )
  echo "===== AWS Lambda Invoke Function:" $PROFILE
  FUNCTION_NAME="terence-test3"
	aws lambda invoke \
    --function-name $FUNCTION_NAME \
		--profile $PROFILE \
    --output $OUTPUT \
		response.json
  ;;

#    --invocation-type Event \
#		-- payload '{"key1":"value1"}' \

"113" )
  echo "===== AWS Lambda Delete Function:" $PROFILE
  aws lambda delete-function \
    --function-name $FUNCTION_NAME \
    --profile $PROFILE \
    --output $OUTPUT
  ;;


"114" )
  echo "===== AWS Lambda Get Function Configuration:" $PROFILE
  aws lambda get-function-configuration \
    --function-name $FUNCTION_NAME \
    --profile $PROFILE \
    --output $OUTPUT
  ;;


"115" )
  echo "===== AWS Lambda Update Function Configuration:" $PROFILE
  aws lambda update-function-configuration \
    --function-name $FUNCTION_NAME \
    --memory-size 256
		--profile $PROFILE \
    --output $OUTPUT
  ;;





"200" )
  echo "===== Zip Python Package:" $PROFILE
  LAYER_NAME="pandas"
  LAYER_CODE="${LAYER_NAME}-layer.zip"
  cd layer-$LAYER_NAME
	zip -r $LAYER_NAME-layer.zip python
  ;;


"201" )
  echo "===== S3 Upload Layer to S3:" $PROFILE
  LAYER_NAME="flask"
  LAYER_CODE="${LAYER_NAME}-layer.zip"
	aws s3 cp ./layer-$LAYER_NAME/$LAYER_CODE s3://$S3CODE/ \
		--profile $PROFILE \
    --output $OUTPUT
  ;;


"202" )
  echo "===== AWS Lambda publish-layer-version:" $PROFILE
  LAYER_NAME="flask"
  LAYER_CODE="${LAYER_NAME}-layer.zip"
	aws lambda publish-layer-version \
    --layer-name $LAYER_NAME \
		--description "${LAYER_NAME} Layer" \
		--content S3Bucket=$S3CODE,S3Key=$LAYER_CODE
#		--compatible-runtimes python3.7 \
    --profile $PROFILE \
    --output $OUTPUT
  ;;


"500" )
  echo "===== V-Env Create:" $PROFILE
  VIRTUAL_ENV="v-env"
	virtualenv $VIRTUAL_ENV
  echo "Try: source bin/activate"
  echo "Try: deactivate"
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




