Under construction

## Test-Driven Approach

I am using TDD to develop features. I'm using [RSpec](https://github.com/rspec/rspec-rails) for testing, and [simplecov](https://github.com/colszowka/simplecov) for test coverage analysis. I'm also using [Rubocop](https://github.com/rubocop-hq/rubocop-rails) to keep my code clean.

## For future AJAX forms

https://edgeguides.rubyonrails.org/working_with_javascript_in_rails.html#form-with

Use `form_with`. `form_for` is soft deprecrated.

## Paths
You can use an endpoint instead of a path as such:

```rb
<%= link_to "Improve Your Ruby Skills", "/ruby-book" %>
```

## Routes testing

This should be done separately from controllers.
For example, redirects to the sign in page are handled at the router level, not controller. Test for this redirect in a routes_spec file.

## Asserting flash messages

```rb
expect(flash[:notice]).to eq "Congratulations on buying our stuff!"
```

## Running RSpec with descriptions

```shell
bundle exec rspec --format documentation
```