
# === clone repository ===
git clone https://github.com/wey-yu/thingworx-distribution.git 
cd thingworx-distribution

organization="wey-yu"
bucket_name="thingworx-storage"
application_name="thingworx-poc"

clever addon create fs-bucket $bucket_name --plan s --org $organization --region eu
clever create $application_name -t war --org $organization --region par --alias $application_name

clever env set JAVA_VERSION 8 --alias $application_name
clever env set PORT 8080 --alias $application_name

clever domain add $application_name.cleverapps.io --alias $application_name  
clever scale --flavor S --alias $application_name

# connect to bucket
# link the addon to the application
clever service link-addon $bucket_name --alias $application_name

# get environment variables: BUCKET_HOST
bucket_host=$(echo $(clever env) | sed -n 's/.*BUCKET_HOST=//p')

echo "-------------------"
echo " $bucket_host"
echo "-------------------"

# bucket connected
clever env set THINGWORX_PLATFORM_SETTINGS /app/thingworx/
clever env set CC_PRE_BUILD_HOOK 'sh ./clevercloud/install.sh'
clever env set CC_FS_BUCKET /thingworx:$bucket_host --alias $application_name
clever env set LD_LIBRARY_PATH /home/bas/cargo-home/webapps/Thingworx/WEB-INF/extensions/

clever deploy

echo "> Login Name: Administrator Password: trUf6yuz2?_Gub"