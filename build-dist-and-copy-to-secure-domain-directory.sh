set -e 
npm run build
rm -rf /home/DualShared/Projects/DigitalOcean-Webserver/secure-domain/www/new-year
cp -r ./dist /home/DualShared/Projects/DigitalOcean-Webserver/secure-domain/www/new-year
