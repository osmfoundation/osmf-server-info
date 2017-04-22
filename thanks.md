---
layout: page
title: Thanks
permalink: /thanks/
---

{% assign nodes = site.data.nodes.rows %}

Hosting OpenStreetMap wouldn't be possible without the support of many people and organisations around the world who donate their time, hosting space or hardware to help us. We would like to thank all of these donors for their generosity and support.

## University College London

We would like to thank [University College London](http://www.ucl.ac.uk/) for their many years of support. They have been supporting OpenStreetMap since its beginning at the [Bartlett centre](http://www.bartlett.ucl.ac.uk/) and we are very grateful.

## Bytemark

We would like to thank [Bytemark](https://www.bytemark.co.uk/) for their many years of support. They have been extremely helpful to us in moments of dire need, and we are very grateful.

## Imperial College London

We would like to thank [Imperial College London](http://www.imperial.ac.uk/) for their many years of support and donations.

## And many others...

Many other people and organisations support OpenStreetMap, and we wouldn't be able to do all the things that we do without their help. Our thanks go to {{ nodes | recent | thanks_to | sort | uniq | linkify_all: 'isps' | join: ", " }} and everyone else who contributes to making OpenStreetMap.
