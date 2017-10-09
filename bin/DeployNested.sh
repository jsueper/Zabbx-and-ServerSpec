#!/bin/bash

set -o errexit -o xtrace

region="YOUR KEY HERE"

bucket="YOUR MAIN ASSET FOLDER HERE"
key="YOUR KEY HERE"

serverspec_bucket="YOUR SERVER SPEC BUCKET HERE"


aws s3api create-bucket --bucket ${bucket} --region ${region} --acl public-read

aws s3api create-bucket --bucket ${serverspec_bucket} --region ${region} --acl public-read

aws s3 cp ../BootStrapScripts/ "s3://${bucket}/${key}/Scripts/" --recursive --acl public-read

aws s3 cp ../NestedTemplates/ "s3://${bucket}/${key}/" --recursive --acl public-read

aws s3 cp ../ServerSpecTests/ "s3://${serverspec_bucket}/" --recursive --acl public-read

aws cloudformation create-stack --template-url https://s3.amazonaws.com/"${bucket}/${key}/RootTemplate"/RootNestedTemplate.template --stack-name ZG  --parameters file://paramsNested.json --disable-rollback --capabilities CAPABILITY_IAM
