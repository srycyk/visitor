Site Visitor
============

A small (three table) Rails' site
for bookmarking a registered user's URL's.

There is an introduction on the landing page,
in *app/views/help/index.html.erb*

[On Heroku](https://serene-spire-81765.herokuapp.com)

Prerequisites
-------------

This application requires:

- Ruby 2.3.3
- Rails 5.0.2
- PostgreSQL or SQLite - should also work with others
- Twitter Bootstrap 3.3.6
- Devise 4.2.0
- Rspec 3.5.4

Comments on the Internals
-------------------------

For Rails developers there may be a few items of interest.

They are self-contained general-purpose components
that bring consistency across the site.
They avoid code duplication, allowing 
global changes to be propagated in a single stroke.

They are chiefly for the views, which is
where code repetition is often most rife.
They have saved a little development time,
but they will ease long-term maintenance markedly.

Another advantage, of using utilities like these,
is that they reduce a dependence on external gems,
such as SimpleForm, Formtastic, Ransack,
various Bootstrap helpers, etc..

> Using such gems usually bloats your code base with unwanted
> features, *whose code consumes resources unnecessarily*.
> Also, they can catch you out in corner cases,
> *when you're forced to come up with a work-around to
> add functionality not originally catered for*.
> And, worst of all, they can cause serious support problems
> if not actively maintained, *even postponing a Rails' upgrade*.

Nearly all of these shared utilities are in the two
directories: *app/views/application/*
and *app/helpers/concerns/*.

The various HTML input types are dealt with
in *app/helpers/concerns/form_field_group_helper.rb*.

There are some other cross-site Bootstrap controls
to ensure HTML forms and tables have uniform layouts,
in *app/helpers/concerns/html_settings.rb*.

There are three preset form field sizes controlled by the
class, *app/helpers/concerns/form_field_settings.rb*.

The links, (which can appear as text, buttons or icons),
are rendered from helper methods
in *app/helpers/concerns/link_up_helper.rb*.
Each link type has its own rendering class, *(in
the same directory)*.
The base class, *LinkUp* is for plain text,
its two sub-classes, *LinkUpBtn* and *LinkUpIcon*,
show buttons and icons.
Perhaps this code needs a bit more refactoring,
but most of it's okay.

The main headings are rendered through the
partial, *app/views/application/_heading.html.erb*,
which can also be used as a template, should you want
to add content to the right-hand side.

> Other view elements, not covered here,
> which may benefit from similar abstractions are:
> Bootstrap's grid system, pagination, sub-headings,
> alerts, image placement, I18N, etc..

As for the **model** classes, *(which, were the
application bigger, I'd move into segmented modules)*.

The class, *ImportBookmark*, acts as a Form Object
which handles the **create** and **update** actions.
It includes a few methods to induce Rails to treat it
as if it's persistent (so that Rails' *form_for* uses
the HTTP PUT method), *there may well be a neater way
of achieving this*.

There is also a utility class to allow multiple fields
in a model to be queried with the same search string.
It is in *app/models/concerns/search_fields.rb*, and
used in the *Tag* and *Bookmark* classes, for the
contextual searching.

Bookmarks are searched, (and retrieved),
with a Service class, *BookmarkLister*.
Tags have something similar, *TagLister*.

The *Tag* class may be of use if you happen to need
tree-structured tagging, but this is uncommon.
It uses recursion heavily, as it's the most elegant
way of processing b-trees.

