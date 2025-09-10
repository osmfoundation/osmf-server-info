---
layout: page
title: Thanks
permalink: /thanks/
---

{% assign nodes = site.data.nodes.rows %}

Hosting OpenStreetMap wouldn't be possible without the support of many people and organisations around the world who donate their time, hosting space or hardware to help us. We would like to thank all of these donors for their generosity and support.

## Equinix

We would like to thank [Equinix](https://www.equinix.com/) for their exceptional support. Equinix kindly provides us with colocation and high-capacity Internet connectivity, and the majority of OpenStreetMap.org runs thanks to [Equinix facilities](https://www.equinix.com/data-centers).

* [AM6](https://www.equinix.com/data-centers/europe-colocation/netherlands-colocation/amsterdam-data-centers/am6) – Amsterdam, Amsterdam Data Centers | [Premium Colocation Provider and Internet Exchange Point by Equinix](https://www.equinix.com/data-centers/europe-colocation/netherlands-colocation/amsterdam-data-centers)
* [DB4](https://www.equinix.com/data-centers/europe-colocation/ireland-colocation/dublin-data-centers/db4) – Dublin, Dublin Data Centers | [Premium Colocation Provider and Internet Exchange Point by Equinix](https://www.equinix.com/data-centers/europe-colocation/ireland-colocation/dublin-data-centers)

## University College London

We would like to thank [University College London](http://www.ucl.ac.uk/) for their many years of support. They have been supporting OpenStreetMap since its beginning at the [Bartlett centre](https://www.ucl.ac.uk/bartlett/casa/) and we are very grateful.

## Fastly

We would like to thank [Fastly](https://www.fastly.com/) for their support. We are very grateful for them providing the content delivery network for the tile service.

## Bytemark

We would like to thank [Bytemark](https://www.bytemark.co.uk/) for their many years of support. They have been extremely helpful to us in moments of dire need, and we are very grateful.

## And many others...

Many other people and organisations support OpenStreetMap, and we wouldn't be able to do all the things that we do without their help. Our thanks go to {{ nodes | recent | thanks_to | sort | uniq | linkify_all: 'isps' | join: ", " }} and everyone else who contributes to making OpenStreetMap.
