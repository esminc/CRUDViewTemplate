# delete old generated files
rm -rf CrudViewController\ subclass.pbfiletemplate

# copy files from base
cp -r CrudViewController\ subclass\ base CrudViewController\ subclass.pbfiletemplate

# generate templates
cat Classes/CrudViewController.h | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/class.h
cat Classes/CrudViewController.m | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/class.m
cat CrudViewController.xib | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/view.xib.unpreprocessed
