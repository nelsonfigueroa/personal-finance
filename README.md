# Personal Finance

A finance tracking application. Currently tracks net worth and expenses month-to-month. Includes an `infrastructure` repository for Terraform resources. In the future, this directory will also hold Kubernetes manifests.

## Test-Driven Approach

I am using TDD to develop features. I'm using [RSpec](https://github.com/rspec/rspec-rails) for testing, and [simplecov](https://github.com/colszowka/simplecov) for test coverage analysis. I'm also using [Rubocop](https://github.com/rubocop-hq/rubocop-rails) to keep my code clean.

## Running Locally

You can run this application locally using `docker-compose`.

Set up the database container:

```
docker-compose run web rake db:create db:setup
```

(Optional) Run all tests:

```
docker-compose run web bundle exec rspec
```

Start up the Rails server and database:

```
docker-compose up
```

Then browse to `http://localhost:3000/`.

## Notes and Lessons Learned

### For future AJAX forms

https://edgeguides.rubyonrails.org/working_with_javascript_in_rails.html#form-with

Use `form_with`. `form_for` is soft deprecrated.

### Paths
You can use an endpoint instead of a path as such:

```rb
<%= link_to "Improve Your Ruby Skills", "/ruby-book" %>
```

### Routes testing

This should be done separately from controllers.
For example, redirects to the sign in page are handled at the router level, not controller. Test for this redirect in a routes_spec file.

### Asserting flash messages

```rb
expect(flash[:notice]).to eq "Congratulations on buying our stuff!"
```

### Running RSpec with descriptions

```shell
bundle exec rspec --format documentation
```

You can add this to `.rspec` and then you don't have to add the additional options.

### Debugging RSpec

My specs were failing, I wasn't getting clear error messages.
I ended up adding begin-rescue blocks and I used `binding.pry` from the `pry` gem.

My setup looked like this:

```rb
let(:account) do
  Account.create(name: Faker::Bank.name,
                 user: user)
end

it 'returns 200' do
  begin
    get "/accounts/#{account.id}"
  rescue
    binding.pry
  end

  expect(response).to render_template(:show)
  expect(response).to have_http_status(:ok)
end
```

Whenever the `get` request would fail, I would get a rails console right after the point of failure. I was able to access the `account` variable and I noticed it did not have an ID, which means it was not being saved.

I ran `account.save!` then `account.errors` in the console to see what the error was. The error message stated that the name was invalid. Upon further inspection, `Faker::Bank.name` was sometimes generating names with parenthesis, which are not allowed in my model. I changed my test to use `Faker::Alphanumeric.alpha(number: 40)` which will guarantee that only letters are used and no special characters.

I was stuck on this for a long time. I thought it might be the way I'm sending requests or an incorrect usage of `let()` and `let!()`. It never occurred to me that maybe I should take a peek at my model and see what validations I put in place...

### Forms for Nested Resources

I have routes set up like this:

```rb
resources :accounts do
  resources :statements, only: %i[new create edit update]
end
```


This way, it demonstrates the relationship between Accounts and Statements in the URL. For example, the endpoint to edit a Statement looks like this:

```
0.0.0.0/accounts/1/statements/1/edit
```

The problem is that when I create the form for a new Statement, I need to specify the controller and action or else it'll default to `statement_path` which doesn't exist due to Statements being a nested resource.
```rb
<%= form_with model: @statement, url: {controller: 'statements', action: 'create'} do |f| %>
  <%= f.label :balance, 'Balance:' %>
  <%= f.number_field :balance, step: 0.01 %>
  <%= f.label :date, 'Date:' %>
  <%= f.date_field :date %>
  <%= f.submit 'Submit' %>
<% end %>
```

I'm still investigating to see if there's a cleaner way of doing this.

### Adding SVGs to Button Links

I had links like this:

```rb
<%= link_to 'Add Expense', new_expense_tracker_expense_path(expense_tracker_id: @expense_tracker.id), class: 'button is-link' %>
```

To create a block out of this `link_to` tag, I had to remove the text `Add Expense`. The text would go within the block itself. If I didn't remove the text, it would give me an error. The updated link looks like this:

```rb
<%= link_to new_account_statement_path(account_id: @account.id), class: 'button is-link' do %>
  <span class="icon">
    <%= inline_svg_tag("plus.svg", size: '30 * 30') %>
  </span>
  <p>Add Statement</p>
<% end %>
```

### Linting ERB

The [erb-lint](https://github.com/Shopify/erb-lint) gem helps to lint .erb files. 

```
bundle exec erblint -a --lint-all
```

Configuration in `.erb-lint.yml`:

```yaml
---
EnableDefaultLinters: true
linters:
  ErbSafety:
    enabled: true
    # better_html_config: .better-html.yml
  Rubocop:
    enabled: false
    rubocop_config:
      inherit_from:
        - .rubocop.yml
      Style/FrozenStringLiteralComment:
        Enabled: false
```

I mainly used this to keep indentation consistent between views. Rubocop was disabled due to an issue where it inserts `frozen_string_literal: true` throughout views and ruins indentation.