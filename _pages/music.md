---
layout: default
permalink: /music/
title: music
nav: true
nav_order: 9
pagination:
  enabled: true
  collection: music
  per_page: 5
  sort_field: date
  sort_reverse: true
---

{%- comment -%}
Body intentionally left empty.
Due to jekyll-paginate-v2, the first paginated page’s content is reused.
_blog.md_ is written to render both /blog and /music based on paginator.collection.
{%- endcomment -%}
