# OSMF Server Info

This is an attempt to automate the generation of high-level information about
the OSMF servers. Previously this was maintained on the wiki, but this is
both time-consuming and error-prone.

This project takes the information that is gathered on each Chef run, and
parses it to gain the relevant information for the pages. The information is
reported from the chef server using `knife search node "*:*" -l -Fj` and is
located at `_data/nodes.json`

This is a jekyll project, so it can be run locally using `jekyll serve -w`.
Since it uses custom plugins it can't be run directly by github pages, and so
the site needs to be generated locally and the results pushed to the `gh-pages`
branch. Use `rake site:generate` or the all-in-one `rake site:publish`.
