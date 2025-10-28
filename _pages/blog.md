---
layout: default
permalink: /blog/
title: blog
nav: true
nav_order: 8
pagination:
  enabled: true
  collection: posts
  per_page: 5
  sort_field: date
  sort_reverse: true
---

{% comment %}
This single template powers BOTH /blog and /music.
jekyll-paginate-v2 reuses the first paginated page’s content,
so we switch strings/links based on paginator.collection.
{% endcomment %}

{% if paginator and paginator.collection == 'music' %}
  {% assign base_path = '/music' %}
  {% assign title_text = site.music_name %}
  {% assign desc_text  = site.music_description %}
  {% assign display_tags_list = site.music_display_tags | default: site.display_tags %}
  {% assign display_categories_list = site.music_display_categories | default: site.display_categories %}
{% else %}
  {% assign base_path = '/blog' %}
  {% assign title_text = site.blog_name %}
  {% assign desc_text  = site.blog_description %}
  {% assign display_tags_list = site.display_tags %}
  {% assign display_categories_list = site.display_categories %}
{% endif %}

<div class="post">
 
  <div class="header-bar">
    <h1>{{ title_text }}</h1>
    <h2>{{ desc_text }}</h2>
  </div>

  {% if display_tags_list and display_tags_list.size > 0 or display_categories_list and display_categories_list.size > 0 %}
  <div class="tag-category-list">
    <ul class="p-0 m-0">
      {% for tag in display_tags_list %}
        <li>
          <i class="fa-solid fa-hashtag fa-sm"></i>
          <a href="{{ tag | slugify | prepend: base_path | prepend: '/tag/' | relative_url }}">{{ tag }}</a>
        </li>
        {% unless forloop.last %}<p>&bull;</p>{% endunless %}
      {% endfor %}
      {% if display_categories_list.size > 0 and display_tags_list.size > 0 %}
        <p>&bull;</p>
      {% endif %}
      {% for category in display_categories_list %}
        <li>
          <i class="fa-solid fa-tag fa-sm"></i>
          <a href="{{ category | slugify | prepend: base_path | prepend: '/category/' | relative_url }}">{{ category }}</a>
        </li>
        {% unless forloop.last %}<p>&bull;</p>{% endunless %}
      {% endfor %}
    </ul>
  </div>
  {% endif %}

  {%- assign postlist = paginator.posts -%}
  {%- assign featured_posts = paginator.posts | where: "featured", "true" -%}

  {% if featured_posts.size > 0 %}
  <br>
  <div class="container featured-posts">
    {% assign is_even = featured_posts.size | modulo: 2 %}
    <div class="row row-cols-{% if featured_posts.size <= 2 or is_even == 0 %}2{% else %}3{% endif %}">
      {% for post in featured_posts %}
      <div class="col mb-4">
        <a href="{{ post.url | relative_url }}">
          <div class="card hoverable">
            <div class="row g-0">
              <div class="col-md-12">
                <div class="card-body">
                  <div class="float-right"><i class="fa-solid fa-thumbtack fa-xs"></i></div>
                  <h3 class="card-title text-lowercase">{{ post.title }}</h3>
                  <p class="card-text">{{ post.description }}</p>

                  {% if post.external_source == blank %}
                    {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
                  {% else %}
                    {% assign read_time = post.feed_content | strip_html | number_of_words | divided_by: 180 | plus: 1 %}
                  {% endif %}
                  {% assign year = post.date | date: "%Y" %}

                  <p class="post-meta">
                    {{ read_time }} min read &nbsp; &middot; &nbsp;
                    <a href="{{ year | prepend: base_path | append: '/' | relative_url }}">
                      <i class="fa-solid fa-calendar fa-sm"></i> {{ year }}
                    </a>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
      {% endfor %}
    </div>
  </div>
  <hr>
  {% endif %}

  <ul class="post-list">
    {% for post in postlist %}
      {% if post.external_source == blank %}
        {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
      {% else %}
        {% assign read_time = post.feed_content | strip_html | number_of_words | divided_by: 180 | plus: 1 %}
      {% endif %}
      {% assign year = post.date | date: "%Y" %}
      {% assign tags = post.tags | join: "" %}
      {% assign categories = post.categories | join: "" %}

      <li>
        {% if post.thumbnail %}<div class="row"><div class="col-sm-9">{% endif %}

        <h3>
          {% if post.redirect == blank %}
            <a class="post-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
          {% elsif post.redirect contains '://' %}
            <a class="post-title" href="{{ post.redirect }}" target="_blank">{{ post.title }}</a>
            <svg width="2rem" height="2rem" viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg">
              <path d="M17 13.5v6H5v-12h6m3-3h6v6m0-6-9 9" class="icon_svg-stroke" stroke="#999" stroke-width="1.5" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"></path>
            </svg>
          {% else %}
            <a class="post-title" href="{{ post.redirect | relative_url }}">{{ post.title }}</a>
          {% endif %}
        </h3>

        <p>{{ post.description }}</p>

        <p class="post-meta">
          {{ read_time }} min read &nbsp; &middot; &nbsp; {{ post.date | date: '%B %d, %Y' }}
          {% if post.external_source %}&nbsp; &middot; &nbsp; {{ post.external_source }}{% endif %}
        </p>

        <p class="post-tags">
          <a href="{{ year | prepend: base_path | append: '/' | relative_url }}">
            <i class="fa-solid fa-calendar fa-sm"></i> {{ year }}
          </a>

          {% if tags != "" %}
            &nbsp; &middot; &nbsp;
            {% for tag in post.tags %}
              <a href="{{ tag | slugify | prepend: base_path | prepend: '/tag/' | relative_url }}">
                <i class="fa-solid fa-hashtag fa-sm"></i> {{ tag }}
              </a>{% unless forloop.last %}&nbsp;{% endunless %}
            {% endfor %}
          {% endif %}

          {% if categories != "" %}
            &nbsp; &middot; &nbsp;
            {% for category in post.categories %}
              <a href="{{ category | slugify | prepend: base_path | prepend: '/category/' | relative_url }}">
                <i class="fa-solid fa-tag fa-sm"></i> {{ category }}
              </a>{% unless forloop.last %}&nbsp;{% endunless %}
            {% endfor %}
          {% endif %}
        </p>

        {% if post.thumbnail %}
          </div>
          <div class="col-sm-3">
            <img class="card-img" src="{{ post.thumbnail | relative_url }}" style="object-fit: cover; height: 90%" alt="image">
          </div>
        </div>
        {% endif %}
      </li>
    {% endfor %}
  </ul>

  {% if page.pagination.enabled %}
    {% include pagination.liquid %}
  {% endif %}

</div>
