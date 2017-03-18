Site Visitor
============

A small (three table) Rails' site for bookmarking a registered user's URL's.

There is an introduction on the landing page,
in *app/views/help/index.html.erb*

[On Heroku](https://serene-spire-81765.herokuapp.com)

Prerequisites
-------------

This application requires:

- Ruby 2.3.3
- Rails 5.0.2
- Twitter Bootstrap 3.3.6
- PostgreSQL and SQLite - should also work with others

Comments on the Internals
-------------------------

For Rails developers there may be a few items of interest.

These are general purpose components that reduce the need
to use external gems, such as SimpleForm, Bootstrap helpers,
etc..

> Using such gems usually bloats your code base with unwanted
> features. Also, they can often catch you out in corner cases
> *(when you're forced to come up with a work-around to
> add functionality not originally catered for)*,
> and, worst of all, they can cause long-term support issues,
> if not kept up to date.

In the directories, **app/views/application/** and
**app/helpers/concerns/**, there are a number of shared
utilities that bring constistency across the site,
and massively reduce code duplication.

These are most useful in  the views, notably,
for the HTML forms, headings, links and buttons.

The various HTML input types are dealt with in
*app/helpers/concerns/form_field_group_helper.rb*.

There are some other standardised Bootstrap controls for
*form_for* attributes and tables in
*app/helpers/concerns/html_settings.rb*.

There are three preset form sizes controlled by the
class, *app/helpers/concerns/form_field_settings.rb*.

The links, (which can appear as text, buttons or icons),
are called from the helper methods in
*app/helpers/concerns/link_up_helper.rb*.
Perhaps this code needs a further refactoring,
but most of it is okay.

As for the model classes.

The *Tag* class may be of use if you happen to need
tree-like tagging, but this is uncommon.
It uses recursion heavily, as it's the most elegant
way of processing b-trees.

The class *ImportBookmark* acts as a Form Object
which handles the **create** and **update** actions.
It includes a few methods to induce Rails to treat it
as if it is persistent,
*there may well be a neater way of achieving this*.

There is also a utility class to allow multiple fields
in a model to be queried with the same search string.
It is in *app/models/concerns/search_fields.rb*, and
used in the *Tag* and *Bookmark* classes.

