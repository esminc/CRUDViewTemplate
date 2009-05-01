# delete old generated files
rm -rf CrudViewController\ subclass

# copy files from base
cp -r CrudViewController\ subclass\ base CrudViewController\ subclass

# generate templates
cat Classes/CrudViewController.h | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/class.h
cat Classes/CrudViewController.m | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/class.m
cat Classes/DetailedCrudViewController.h | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/detailed.h.unpreprocessed
cat Classes/DetailedCrudViewController.m | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/detailed.m.unpreprocessed
cat CrudViewController.xib | ./to_template.rb > CrudViewController\ subclass.pbfiletemplate/view.xib.unpreprocessed
