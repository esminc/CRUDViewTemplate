# delete old generated files
rm -rf ~/Library/Application\ Support/Xcode/File\ Templates/Cocoa\ Touch\ Class/CRUDViewController\ subclass.pbfiletemplate

# make directory
mkdir -p ~/Library/Application\ Support/Xcode/File\ Templates/Cocoa\ Touch\ Class/

# copy built files
cp -r CrudViewController\ subclass.pbfiletemplate ~/Library/Application\ Support/Xcode/File\ Templates/Cocoa\ Touch\ Class
