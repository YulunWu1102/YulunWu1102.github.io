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
  permalink: /music/page/:num/
  sort_field: date
  sort_reverse: true
  trail:
    before: 2
    after: 2
---

<div class="post">

  <div class="header-bar">
    <h1>{{ site.music_name }}</h1>
    <h2>{{ site.music_description }}</h2>
  </div>

  {% assign display_tags_list = site.music_display_tags | default: site.display_tags %}
  {% assign display_categories_list = site.music_display_categories | default: site.display_categories %}

  {% if display_tags_list or display_categories_list %}
  <div class="tag-category-list">
    <ul class="p-0 m-0">
      {% for tag in display_tags_list %}
        <li><i class="fa-solid fa-hashtag fa-sm"></i>
          <a href="{{ tag | slugify | prepend: '/music/tag/' | relative_url }}">{{ tag }}</a>
        </li>
        {% unless forloop.last %}<p>&bull;</p>{% endunless %}
      {% endfor %}
      {% if display_categories_list and display_tags_list %}<p>&bull;</p>{% endif %}
      {% for category in display_categories_list %}
        <li><i class="fa-solid fa-tag fa-sm"></i>
          <a href="{{ category | slugify | prepend: '/music/category/' | relative_url }}">{{ category }}</a>
        </li>
        {% unless forloop.last %}<p>&bull;</p>{% endunless %}
      {% endfor %}
    </ul>
  </div>
  {% endif %}

  {% assign featured_posts = site.music | where: "featured", "true" %}
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
                  {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
                  {% assign year = post.date | date: "%Y" %}
                  <p class="post-meta">
                    {{ read_time }} min read &nbsp; &middot; &nbsp;
                    <a href="{{ year | prepend: '/music/' | relative_url }}">
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
    {% assign postlist = site.music | sort: "date" | reverse %}
    {% for post in postlist %}
      {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
      {% assign year = post.date | date: "%Y" %}
      {% assign tags = post.tags | join: "" %}
      {% assign categories = post.categories | join: "" %}

      <li>
        {% if post.thumbnail %}<div class="row"><div class="col-sm-9">{% endif %}

        <h3>
          <a class="post-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </h3>

        <p>{{ post.description }}</p>

        <p class="post-meta">
          {{ read_time }} min read &nbsp; &middot; &nbsp; {{ post.date | date: '%B %d, %Y' }}
        </p>

        <p class="post-tags">
          <a href="{{ year | prepend: '/music/' | relative_url }}">
            <i class="fa-solid fa-calendar fa-sm"></i> {{ year }}
          </a>
          {% if tags != "" %}
            &nbsp; &middot; &nbsp;
            {% for tag in post.tags %}
              <a href="{{ tag | slugify | prepend: '/music/tag/' | relative_url }}">
                <i class="fa-solid fa-hashtag fa-sm"></i> {{ tag }}</a>{% unless forloop.last %}&nbsp;{% endunless %}
            {% endfor %}
          {% endif %}
          {% if categories != "" %}
            &nbsp; &middot; &nbsp;
            {% for category in post.categories %}
              <a href="{{ category | slugify | prepend: '/music/category/' | relative_url }}">
                <i class="fa-solid fa-tag fa-sm"></i> {{ category }}</a>{% unless forloop.last %}&nbsp;{% endunless %}
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

</div>
