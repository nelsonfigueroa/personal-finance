# frozen_string_literal: true

User.create!([
               { name: 'Demo User', email: 'demo@demo', password: 'demouser123!', encrypted_password: '$2a$11$szyzQvo9zT6uthYP42uUCObOfkOyVr/amilyXYBknFDhHMy8BtyAO', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil }
             ])
Account.create!([
                  { user_id: 1, name: 'Wells Fargo Debit' },
                  { user_id: 1, name: 'Vanguard IRA' },
                  { user_id: 1, name: 'Chase Debit' },
                  { user_id: 1, name: 'Fidelity Investing' },
                  { user_id: 1, name: 'Chase Savings' }
                ])
Statement.create!([
                    { account_id: 3, notes: '', date: '2022-11-01', balance_cents: 230_000, balance_currency: 'USD' },
                    { account_id: 4, notes: '', date: '2022-11-18', balance_cents: 5_014_278, balance_currency: 'USD' },
                    { account_id: 2, notes: '', date: '2022-11-01', balance_cents: 2_092_351, balance_currency: 'USD' },
                    { account_id: 1, notes: '', date: '2022-11-10', balance_cents: 320_000, balance_currency: 'USD' },
                    { account_id: 3, notes: '', date: '2022-10-01', balance_cents: 140_000, balance_currency: 'USD' },
                    { account_id: 1, notes: '', date: '2022-10-01', balance_cents: 100_000, balance_currency: 'USD' },
                    { account_id: 4, notes: '', date: '2022-10-01', balance_cents: 3_850_457, balance_currency: 'USD' },
                    { account_id: 2, notes: '', date: '2022-10-01', balance_cents: 1_470_025, balance_currency: 'USD' },
                    { account_id: 4, notes: '', date: '2022-11-01', balance_cents: 4_520_075, balance_currency: 'USD' },
                    { account_id: 5, notes: '', date: '2022-11-01', balance_cents: 150_000, balance_currency: 'USD' },
                    { account_id: 5, notes: '', date: '2022-10-15', balance_cents: 50_000, balance_currency: 'USD' }
                  ])
Transaction.create!([
                      { user_id: 1, date: '2022-11-01', category: 'Income', notes: 'Monthly Salary', amount_cents: 600_000, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-10-01', category: 'Income', notes: 'Monthly Salary', amount_cents: 600_000, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-10-08', category: 'Investing', notes: '$1000 invested.', amount_cents: 100_000, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-11-01', category: 'Savings', notes: '$1000 into Savings', amount_cents: 100_000, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-11-01', category: 'Food', notes: 'In n Out', amount_cents: 2235, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-11-05', category: 'Entertainment', notes: 'Movie theater', amount_cents: 3200, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-10-10', category: 'Gas', notes: 'Gas for car.', amount_cents: 6000, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-11-06', category: 'Groceries', notes: 'Costco', amount_cents: 14_856, amount_currency: 'USD' },
                      { user_id: 1, date: '2022-10-22', category: 'Groceries', notes: 'Costco', amount_cents: 13_245, amount_currency: 'USD' }
                    ])
