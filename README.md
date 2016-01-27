# OSMF Server Info

This project automates the generation of high-level information about
the OSMF servers. Previously this was maintained on the wiki, but this was
both time-consuming and error-prone.

This project takes the node and role information that is gathered on each Chef
run, and parses it to gain the relevant information for the pages. The data
is exported from the chef server using the ["serverinfo" cookbook](https://github.com/openstreetmap/chef/tree/master/cookbooks/serverinfo)

This is a jekyll project, so it can be run locally using `jekyll serve -w`.
Since it uses custom plugins it can't be run directly by github pages. Currently
the `_data/nodes.json` and `_data/roles.json` are not publicly available.
